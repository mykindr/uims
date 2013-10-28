unit UMainFunc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Forms,
  ComObj, ActiveX, ShellApi, ShlObj, Registry, Winsock; //Sockets

function OpenSpecialFolder(Flag:Integer;Handle: HWND = 0):Boolean;
function LastPos(Needle: Char; Haystack: String): word;
function GetLocalIP(var LocalIp: string): Boolean;
Procedure EnableKeyboard;
function KM_UnLockMouse: Boolean;
function ColorToRGB(Color:TColor):string;
function StrToColor(str:string):TColor;
function StrToColor2(str:string):TColor;
function GetDirectoryName(str:string):string;
function GetFileName(str:string):string;
function findfiles(apath:string):Tstrings;
function ResolveLink(const ALinkFile: String): String;
function SelectDirectory(const Caption: string; const Root: WideString; OwnerWindow: THandle; out Directory: string): Boolean;
procedure CreateLnkToDesktop;
procedure CreateLnkToStartMenu;
procedure ClearMemory;

implementation

var
  oldHook: Hhook; hMouseHook: Integer;
  reg1:TRegistry;
  ShLink: IShellLink;
  PFile: IPersistFile;
  FileName: string;
  WFileName: WideString;
  AnObj: IUnknown;

function OpenSpecialFolder(Flag:Integer;Handle: HWND = 0):Boolean;
//�����Flag������Ҫ�򿪵��ļ��е�CSIDLֵ
  Procedure FreePidl(pidl: PItemIDList);//�ͷŵ�PItemIDListʵ��
  var allocator: IMalloc;
  begin
    if Succeeded(shlobj.SHGetMalloc(allocator)) then
    begin
      allocator.Free(pidl);
    {$IFDEF VER90}
      allocator.Release;
    {$ENDIF}
    end;
  end;
var exInfo: TShellExecuteInfo;
begin
  FillChar(exInfo, SizeOf(exInfo), 0);//��exInfo���ó�ʼֵ
  with exInfo do
  begin
    cbSize:=Sizeof(exInfo); fMask:=SEE_MASK_FLAG_DDEWAIT or SEE_MASK_IDLIST;
    Wnd:=handle; nShow:=SW_SHOWNORMAL;
    lpVerb:='open';
    SHGetSpecialFolderLocation(Handle, Flag, PItemIDLIst(lpIDList));//��λ����CSIDLֵָ�����ļ���
  end;
  ShellExecuteEx(@exInfo);//���ļ���
  FreePidl(exInfo.lpIDList);
  Result:=true;
end;

function LastPos(Needle: Char; Haystack: String): word;
begin
  for Result := Length(Haystack) downto 1 do
    if Haystack[Result] = Needle then Break
end;

function GetLocalIP(var LocalIp: string): Boolean;
var    //���IP��ַ
  HostEnt: PHostEnt;
  Ip: string; addr: pchar;
  Buffer: array [0..63] of char;
  GInitData: TWSADATA;
begin
  Result := False;
  try
    WSAStartup(2, GInitData);
    GetHostName(Buffer, SizeOf(Buffer));
    HostEnt := GetHostByName(buffer);
    if HostEnt = nil then Exit;
    addr := HostEnt^.h_addr_list^;
    ip := Format('%d.%d.%d.%d', [byte(addr [0]), byte (addr [1]), byte (addr [2]), byte (addr [3])]);
    LocalIp := Ip;
    Result := True;
  finally
    WSACleanup;
  end;
end;

Procedure EnableKeyboard;
Begin    //Enable Keyboard
  If oldHook <> 0 Then
  Begin
    UnhookWindowshookEx( oldHook );
    oldHook := 0;
  End;
End;

function KM_UnLockMouse: Boolean;
begin    //UnLock Mouse
  UnHookWindowsHookEx(hMouseHook); (* Uninstall mouse hook *)
  hMouseHook := 0;
  Result := True;
end;

function ColorToRGB(Color:TColor):string;
var R,G,B:byte;
begin
  R:=Color and $FF;
  G:=(Color and $FF00) shr 8;
  B:=(Color and $FF0000) shr 16;
  Result:=inttostr(R) + ' ' + inttostr(G) + ' ' + inttostr(B);
end;

function StrToColor(str:string):TColor;
var i,R,G,B:Byte;
begin
  if str <> '' then
  begin
    i:=pos(' ',str); R:=strtoint(copy(str,1,i-1)); delete(str,1,i);
    i:=pos(' ',str); G:=strtoint(copy(str,1,i-1)); delete(str,1,i);
    B:=strtoint(str);
    Result:=B Shl 16 Or G Shl 8 Or R;
  end
  else Result:=$00FFEBDE;
end;

function StrToColor2(str:string):TColor;
var i,R,G,B:Byte;
begin
  if str <> '' then
  begin
    i:=pos(' ',str); R:=255-strtoint(copy(str,1,i-1)); delete(str,1,i);
    i:=pos(' ',str); G:=255-strtoint(copy(str,1,i-1)); delete(str,1,i);
    B:=255-strtoint(str);
    Result:=B Shl 16 Or G Shl 8 Or R;
  end
  else Result:=$00FFEBDE;
end;

function GetDirectoryName(str:string):string;
begin
  if str[length(str)] <> '\'
  then result:=str+'\' else result:=str;
end;

function GetFileName(str:string):string;
begin
  delete(str,1,LastPos('\',str)); result:=str;
end;

function findfiles(apath:string):Tstrings;
var   //���һ��Ŀ¼�µ��ļ����б�
  fsr,dsr:tsearchrec;
  err:integer; fileext:string;
begin
  apath:=GetDirectoryName(apath); fileext:='*.*';
  err:=findfirst(apath+fileext,faAnyfile,fsr);
  result:=Tstringlist.Create;
  try
    while err=0 do
    begin
      result.Add(apath+fsr.Name);
      err:=findnext(fsr);
    end;
  finally  //�ͷ���Դ
    findclose(fsr);
    findclose(dsr);
  end;
end;

function ResolveLink(const ALinkFile: String): String;
var   //��ÿ�ݷ�ʽָ����ļ���
  link: IShellLink; storage: IPersistFile;
  filedata: TWin32FindData; widepath: WideString;
  buf: Array[0..MAX_PATH] of Char;
begin
  OleCheck(CoCreateInstance(CLSID_ShellLink, nil, CLSCTX_INPROC_SERVER, IShellLink, link));
  OleCheck(link.QueryInterface(IPersistFile, storage));
  widepath := ALinkFile;
  Result := '';
  If Succeeded(storage.Load(@widepath[1], STGM_READ)) Then
    If Succeeded(link.Resolve(GetActiveWindow, SLR_NOUPDATE)) Then
      If Succeeded(link.GetPath(buf, sizeof(buf), filedata, SLGP_UNCPRIORITY)) Then
        Result := buf;
  storage := nil;
  link:= nil;
end;

function SelectDirectory(const Caption: string; const Root: WideString; OwnerWindow: THandle; out Directory: string): Boolean;
var
  WindowList: Pointer;
  BrowseInfo: TBrowseInfo;
  Buffer: PChar;
  RootItemIDList, ItemIDList: PItemIDList;
  ShellMalloc: IMalloc;
  IDesktopFolder: IShellFolder;
  Eaten, Flags: LongWord;
begin
  Result := False;
  Directory := '';
  FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
  if (ShGetMalloc(ShellMalloc) = S_OK) and (ShellMalloc <> nil) then
  begin
    Buffer := ShellMalloc.Alloc(MAX_PATH);
    try
      RootItemIDList := nil;
      if Root <> '' then
      begin
        SHGetDesktopFolder(IDesktopFolder);
        IDesktopFolder.ParseDisplayName(Application.Handle, nil, POleStr(Root), Eaten, RootItemIDList, Flags);
      end;
      with BrowseInfo do
      begin
        hwndOwner := OwnerWindow;
        pidlRoot := RootItemIDList;
        pszDisplayName := Buffer;
        lpszTitle := PChar(Caption);
        ulFlags := BIF_RETURNONLYFSDIRS;
      end;
      WindowList := DisableTaskWindows(0);
      try
        ItemIDList := ShBrowseForFolder(BrowseInfo);
      finally
        EnableTaskWindows(WindowList);
      end;
      Result :=  ItemIDList <> nil;
      if Result then
      begin
        ShGetPathFromIDList(ItemIDList, Buffer);
        ShellMalloc.Free(ItemIDList);
        Directory := Buffer;
      end;
    finally
      ShellMalloc.Free(Buffer);
    end;
  end;
end;

procedure CreateLnkToDesktop; //������ݷ�ʽ������
begin
  Reg1:=TRegistry.Create; Reg1.RootKey:=HKEY_LOCAL_MACHINE;
  AnObj := CreateComObject(CLSID_ShellLink); //��ݷ�ʽ�ĳ�ʼ��
  ShLink := AnObj as IShellLink;
  PFile := AnObj as IPersistFile;
  FileName := ParamStr(0);
  ShLink.SetPath(PChar(FileName));
  ShLink.SetWorkingDirectory(PChar(ExtractFilePath(FileName)));
  //ShLink.SetDescription('��ݷ�ʽ����');
  if reg1.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders',false)
  then WFileName := GetDirectoryName(reg1.ReadString('Common Desktop')) + 'WindowsOPT.lnk';
  Reg1.CloseKey; Reg1.Free;
  PFile.Save(PWChar(WFileName), False);
end;

procedure CreateLnkToStartMenu; //������ݷ�ʽ����ʼ�˵�
begin
  Reg1:=TRegistry.Create; Reg1.RootKey:=HKEY_LOCAL_MACHINE;
  AnObj := CreateComObject(CLSID_ShellLink); //��ݷ�ʽ�ĳ�ʼ��
  ShLink := AnObj as IShellLink;
  PFile := AnObj as IPersistFile;
  FileName := ParamStr(0);
  ShLink.SetPath(PChar(FileName));
  ShLink.SetWorkingDirectory(PChar(ExtractFilePath(FileName)));
  //ShLink.SetDescription('��ݷ�ʽ����');
  if reg1.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders',false)
  then WFileName := GetDirectoryName(reg1.ReadString('Common Programs')) + 'WindowsOPT.lnk';
  Reg1.CloseKey; Reg1.Free;
  PFile.Save(PWChar(WFileName), False);
end;

procedure ClearMemory;  //��С������ڴ�ռ��
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    begin
      SetProcessWorkingSetSize(GetCurrentProcess, $FFFFFFFF, $FFFFFFFF);
      Application.ProcessMessages;
    end;
end;

end.

