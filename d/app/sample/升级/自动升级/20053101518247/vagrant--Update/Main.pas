unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,Registry, StdCtrls,shellapi, WinSkinData, ComCtrls, ExtCtrls,
  Buttons, ImgList, IdFTP, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP,IniFiles;

type
  TFrm_Main = class(TForm)
    Memo1: TMemo;
    SkinData1: TSkinData;
    btn_Update: TBitBtn;
    PB_Cur: TProgressBar;
    Panel1: TPanel;
    Image1: TImage;
    PB_Whole: TProgressBar;
    Label2: TLabel;
    Label1: TLabel;
    Btn_Cancel: TBitBtn;
    IdHTTP1: TIdHTTP;
    IdFTP1: TIdFTP;
    Label3: TLabel;
    procedure btn_UpdateClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Btn_CancelClick(Sender: TObject);
    procedure IdHTTP1Work(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
    procedure IdHTTP1WorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCountMax: Integer);
    procedure IdHTTP1WorkEnd(Sender: TObject; AWorkMode: TWorkMode);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    LocalVer,NetVer:Double;
    LocalVerStr,NetVerStr:String;
    SQLCount:integer;  //��ִ��SQL������
    nDownFileCount:integer; //�����ص��ļ���
    DispStr:String;   //��ʾ����ִ���ĸ���������Ϣ
    procedure CreateScript;
    procedure RunScript(const sSQL: String);
    function  GetFileVer(const AFileName: string;AIndex:integer): Cardinal;
    function  GetFileVerStr(AFileName:String): String;
    procedure ClearReg;
    procedure WriteErrLog(ErrStr:String);
  private
    AbortTransfer: Boolean; //�Ƿ��ж�
    BytesToTransfer: LongWord; //�����ܴ�С
    aHint,NoRunSQL:Boolean;
    WinPath,TmpURL,MyURL:String;
    NetIni:TIniFile;
    WebStr:String;
    procedure FtpDownLoad(aURL, aFile: string; bResume: Boolean);
    procedure HttpDownLoad(aURL, aFile: string; bResume: Boolean);
    procedure MyDownLoad(aURL, aFile: string; bResume: Boolean);
    function  GetProt(aURL: string): Byte;
    function  GetURLFileName(aURL: string): string;
    procedure GetFTPParams(aURL: string; var sName, sPass, sHost, sPort,sDir: string);  
    procedure BakOldFile;
    procedure DownNetUpdateIni;
    procedure DispPanelVer;
    procedure DownAFile(aName:String);
  public
    { Public declarations }
  end;

var
  Frm_Main: TFrm_Main;
  TxtFile:TextFile;
  DownList,ExeList:TStringList;
  AverageSpeed: Double = 0;
implementation

uses DM, DBTables, DB, ADODB;

{$R *.dfm}

//������صĵ�ַ��http����ftp
function TFrm_Main.GetProt(aURL: string): Byte;
begin
  Result := 0;
  if Pos('http', LowerCase(aURL))= 1 then  Result := 1; //httpЭ��
  if Pos('ftp', LowerCase(aURL)) = 1 then  Result := 2; //ftpЭ��
end;

 //�������ص�ַ���ļ���
function TFrm_Main.GetURLFileName(aURL: string): string;
var
  i: integer;
  s: string;
begin
  s := aURL;
  i := Pos('/', s);
  while i <> 0 do //ȥ��"/"ǰ�������ʣ�µľ����ļ�����
    begin
      Delete(s, 1, i);
      i := Pos('/', s);
    end;
  Result := s;
end;

//����ftp��ַ�ĵ�½�û����������Ŀ¼
procedure TFrm_Main.GetFTPParams(aURL: string; var sName, sPass, sHost, sPort, sDir: string);
var
  i, j: integer;
  s, tmp: string;
begin
  s := aURL;
  if Pos('ftp://', LowerCase(s)) <> 0 then  Delete(s, 1, 6);//ȥ��ftpͷ
  i := Pos('@', s);
  if i <> 0 then //��ַ���û�����Ҳ���ܺ�����
    begin
      tmp := Copy(s, 1, i - 1);
      s := copy(s, i+1, Length(s));
      j := Pos(':', tmp);
      if j <> 0 then //��������
        begin
          sName := Copy(tmp, 1, j - 1); //�õ��û���
          sPass := Copy(tmp, j + 1, i - j - 1); //�õ�����
        end
      else
        begin
          sName := tmp;
          sPass := Inputbox('�����','�������½ftp����','');
        end;
    end
  else //�����û�
    begin
      sName := 'anonymous';
      sPass := 'test@ftp.com';
    end;
  i := Pos(':', s);
  j := Pos('/', s);
  sHost := Copy(s, 1, j - 1); //����
  if i <> 0 then  sPort := Copy(s, i + 1, j - i - 1)//���˿�
  else  sPort := '21'; //Ĭ��21�˿�
  tmp := Copy(s, j + 1, Length(s));
  while j <> 0 do
    begin
      Delete(s, 1, j);
      j := Pos('/', s);
    end; //Ŀ¼
  sDir := '/' + Copy(tmp, 1, Length(tmp) - Length(s) - 1);
end;

//ftp��ʽ����
procedure TFrm_Main.FtpDownLoad(aURL, aFile: string; bResume: Boolean);
var
  tStream: TFileStream;
  sName, sPass, sHost, sPort, sDir: string;
begin
  if FileExists(aFile) then tStream := TFileStream.Create(aFile, fmOpenWrite)
  else  tStream := TFileStream.Create(aFile, fmCreate); //�����ļ���
  GetFTPParams(aURL, sName, sPass, sHost, sPort, sDir);
  with IdFTP1 do
  try
    if Connected then Disconnect; //��������
    Username := sName;
    Password := sPass;
    Host := sHost;
    Port := StrToInt(sPort);
    Connect;
  except
    exit;
  end;

  IdFTP1.ChangeDir(sDir); //�ı�Ŀ¼
  BytesToTransfer := IdFTP1.Size(aFile);
  try
    if bResume then //����
      begin
        tStream.Position := tStream.Size;
        IdFTP1.Get(aFile, tStream, True);
      end
    else
      begin
        IdFTP1.Get(aFile, tStream, False);
      end;
  finally
    tStream.Free;
  end;
end;

//http��ʽ����
procedure TFrm_Main.HttpDownLoad(aURL, aFile: string; bResume: Boolean);
var
  tStream: TFileStream;
begin
  try
     //����ļ��Ѿ�����
    if FileExists(aFile) then tStream := TFileStream.Create(aFile, fmOpenWrite)
    else tStream := TFileStream.Create(aFile, fmCreate);
    if bResume then //������ʽ
      begin
        IdHTTP1.Request.ContentRangeStart := tStream.Size - 1;
        tStream.Position := tStream.Size - 1; //�ƶ�������������
        IdHTTP1.Head(aURL);
        IdHTTP1.Request.ContentRangeEnd := IdHTTP1.Response.ContentLength;
      end
    else //���ǻ��½���ʽ
      begin
        IdHTTP1.Request.ContentRangeStart := 0;
      end;
    try
      IdHTTP1.Get(aURL, tStream); //��ʼ����
    finally
      tStream.Free;
    end;
  Except
    on E:Exception do
      begin
        if (Pos('Operation aborted',E.Message)>=0) and AbortTransfer then
          begin
            E.Message:='�ѱ��û��ж�';
          end;
        Application.MessageBox(PChar('���������г����˴�����,������Ϣ���£�'+#13+#13+E.Message),PChar('ϵͳ��ʾ'),Mb_OK+MB_ICONERROR);
        WriteErrLog('���������г����˴�����,������Ϣ���£�'+E.Message);
        CopyFile(PChar(ExtractFilePath(ParamStr(0))+'Bak\KQSys.exe'),PChar(ExtractFilePath(ParamStr(0))),False);
        Abort;
      end;
  end;
end;

procedure TFrm_Main.MyDownLoad(aURL, aFile: string; bResume: Boolean);
begin
  case GetProt(aURL) of
    0: Application.MessageBox(PChar('����ʶ��ĵ�ַ'),PChar('ϵͳ��ʾ'),Mb_OK+MB_ICONERROR);
    1: HttpDownLoad(aURL, aFile, bResume);
    2: FtpDownLoad(aURL, aFile, bResume);
  end;
end;


procedure TFrm_Main.btn_UpdateClick(Sender: TObject);
var
  aURL, aFile: string;
  LStr:string;
  i:integer;
  dFileName,LangFold:string; //������Ini�ļ���(��Language\CHS.INI)�������ļ���
  aFileName:String;  //ȥ��·������ļ���
begin
  DispStr:='���������°汾�ļ�%S,���Ժ�...';
  try
    Screen.Cursor:=crSQLWait;
    btn_Update.Enabled:=False;
    Btn_Cancel.Caption:='�ж�����';
    try
      Label3.Caption:='���ڻ�ȡ���������ļ�,���Ժ�...';
      Refresh;
      DownNetUpdateIni;
    except
      on  E:Exception do
        begin
          Application.MessageBox(PChar('��ȡ���������ļ�ʧ�ܣ����Һ�����'+#13+#13+E.Message),PChar('ϵͳ��ʾ'),MB_OK+MB_ICONERROR);
          WriteErrLog('��ȡ���������ļ�ʧ�ܣ�������Ϣ����:'+E.Message);
          Exit;
        end;
    end;
    with PB_Whole do
      begin
        Max:=6+2*nDownFileCount;
        Min:=0;
        Step:=1;
      end;

    Label3.Caption:='�����������������ļ�...';
    DispPanelVer;
    PB_Whole.StepIt;
    Refresh;

    Label3.Caption:='���ڱ��ݾɰ汾�ļ�,���Ժ�...';
    BakOldFile;
    PB_Whole.StepIt;
    Refresh;

   //�����°汾���ļ� 
    for i:=0 to DownList.Count-1 do
      begin
        dFileName:=Copy(DownList.Strings[i],Pos('=',DownList.Strings[i])+1,Length(DownList.Strings[i]));
        if Pos('\',dFileName)>0 then
          begin
            LangFold :=copy(dFileName,0,Pos('\',dFileName)-1);
            aFileName:=copy(dFileName,Pos('\',dFileName)+1,Length(dFileName));
            Label3.Caption:=Format(DispStr,[aFileName]);
            Refresh;
            DownAFile(aFileName);
          end
        else
          begin
            Label3.Caption:=Format(DispStr,[dFileName]);
            Refresh;
            DownAFile(dFileName);
          end;
        PB_Whole.StepIt;  
      end;

    ClearReg;
    PB_Whole.StepIt;

    Memo1.Lines.LoadFromFile(ExtractFilePath(ParamStr(0))+'UpdateSQL.dll');
    DeleteFile(ExtractFilePath(ParamStr(0))+'UpdateSQL.dll');
    Label3.Caption:='���ڸ������ݿ���Ϣ�����Ժ�...';
    Refresh;
    CreateScript;
    PB_Whole.StepIt;

    Label3.Caption:='���ڸ��±��س������Ժ�...';
    Refresh;
    CopyFile(PChar('CHS.ini'),PChar(ExtractFilePath(ParamStr(0)+'Language\CHS.ini')),False);
    CopyFile(PChar('CHT.ini'),PChar(ExtractFilePath(ParamStr(0)+'Language\CHT.ini')),False);
    CopyFile(PChar('MenuConf.ini'),PChar(WinPath+'MenuConf.ini'),False);
    Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0))+'SysData\Update.ini');
    with Ini do
      begin
        WriteString('WWW','URL',WebStr);
        Free;
      end;
    PB_Whole.StepIt;


    DeleteFile('CHS.INI');
    DeleteFile('CHT.INI');
    DeleteFile('MenuConf.INI');
    PB_Whole.StepIt;
    Application.MessageBox(PChar('��ϲ�������Ѿ����������°汾'),PChar('ϵͳ��ʾ'),MB_OK+MB_ICONINFORMATION);
  finally
    btn_Update.Enabled:=True;
    Screen.Cursor:=crDefault;
    PB_Cur.Position:=0;
    PB_Whole.Position:=0;
  end;
  Close;
end;

//�������ݿ�ű�(һ��һ������)
procedure TFrm_Main.CreateScript;
const
  sTAG = ';';
var
  Str : String;
  sSQL : String;
  iPos : Integer;
begin
  with PB_Cur do
    begin
      Max:=SQLCount;
      Min:=0;
      Step:=1;
    end;
  Str := Trim(Memo1.Lines.Text);
  while True do
    begin
      iPos := Pos(sTAG, Str);
      if (iPos > 0) then
        begin
          sSQL := Copy(Str, 1, iPos - 1);
          if not NoRunSql then RunScript(sSQL);
          Sleep(100);
          PB_Cur.StepIt;
          Delete(Str, 1, iPos);
          Application.ProcessMessages;
        end;
      if (Length(Str) = 0) then  break;
    end;
end;

//����ÿ���ű�
procedure TFrm_Main.RunScript(const sSQL: String);
begin
  Frm_DM.ADOQuery1.SQL.Text := sSQL;
  try
    Frm_DM.ADOQuery1.ExecSQL;
  except
    on E:Exception  do
      begin
         ShowMessage(E.Message);
         WriteErrLog(E.Message);
      end;
  end;
end;


procedure TFrm_Main.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

//�õ�Ҫ�����ļ��汾
function TFrm_Main.GetFileVer(const AFileName: string;AIndex:integer): Cardinal;
var
  FileName: string;
  InfoSize, Wnd: DWORD;
  VerBuf: Pointer;
  FI: PVSFixedFileInfo;
  VerSize: DWORD;
begin
  Result := Cardinal(-1);
  FileName := AFileName;
  UniqueString(FileName);
  InfoSize := GetFileVersionInfoSize(PChar(FileName), Wnd);
  if InfoSize <> 0 then
  begin
    GetMem(VerBuf, InfoSize);
    try
      if GetFileVersionInfo(PChar(FileName), Wnd, InfoSize, VerBuf) then
        if VerQueryValue(VerBuf, '\', Pointer(FI), VerSize) then
          begin
            if AIndex=1      then    Result:= FI.dwFileVersionMS
            else if AIndex=2 then    Result:= FI.dwFileVersionLS;
          end;
    finally
      FreeMem(VerBuf);
    end;
  end;
end;


//�õ�Ҫ�����ļ��汾
function TFrm_Main.GetFileVerStr(AFileName:String): String;
var
	FileVersion: Cardinal;
	Major1, Major2, Minor1, Minor2: Integer;
begin
	FileVersion := GetFileVer(AFileName,1);
	Major1 := FileVersion shr 16;
	Major2 := FileVersion and $FFFF;

	FileVersion := GetFileVer(AFileName,2);
	Minor1 := FileVersion shr 16;
	Minor2 := FileVersion and $FFFF;
	Result := Format('%d.%d.%d.%d', [Major1, Major2, Minor1, Minor2] );
end;

procedure TFrm_Main.FormCreate(Sender: TObject);
var
  MyPath:String;
begin
  SetLength(MyPath,100);
  GetWindowsDirectory(Pchar(MyPath),100);
  SetLength(MyPath,strLen(Pchar(MyPath)));
  WinPath:=Trim(MyPath)+'\';
end;

procedure TFrm_Main.FormShow(Sender: TObject);
var
  WebIni:TIniFile;
begin
  DownList:=TStringList.Create;
  ExeList :=TStringList.Create;  
  Panel1.Caption:='��ӭʹ�ÿ��ڹ������������������';
  WebIni:=TIniFile.Create(ExtractFilePath(ParamStr(0))+'SysData\Update.ini');
  with WebIni do
     TmpURL:=ReadString('WWW','URL','http://free.efile.com.cn/');
  MyURL:=TmpURL+'vagrant/KQ/';   
  WebIni.Free;
end;

procedure TFrm_Main.Btn_CancelClick(Sender: TObject);
begin
  if not btn_Update.Enabled then
    begin
      if Application.MessageBox(PChar('�ļ���û��������ϣ�ȷ��Ҫ�ж���'),PChar('ϵͳ��ʾ'),MB_YESNO+MB_ICONQUESTION)=IDNo then Exit;
      AbortTransfer := True;
    end
  else
    begin
      if Application.MessageBox(PChar('ȷ��Ҫ�˳�������'),PChar('ϵͳ��ʾ'),MB_YESNO+MB_ICONQUESTION)=IDNo then Exit;    
    end;
end;

procedure TFrm_Main.IdHTTP1Work(Sender: TObject; AWorkMode: TWorkMode;const AWorkCount: Integer);
begin
  try
    if AbortTransfer then
      begin //�ж�����
        IdHTTP1.Disconnect;
        IdFTP1.Abort;
      end;
    PB_Cur.Position := AWorkCount;
    Application.ProcessMessages;
  except
    WriteErrLog('���󣬳������¼�IdHTTP1Work��');
  end;
end;

procedure TFrm_Main.IdHTTP1WorkBegin(Sender: TObject; AWorkMode: TWorkMode;const AWorkCountMax: Integer);
begin
  try
    AbortTransfer := False;
    if AWorkCountMax > 0 then PB_Cur.Max := AWorkCountMax
    else  PB_Cur.Max := BytesToTransfer;
  except
    WriteErrLog('���󣬳������¼�IdHTTP1WorkBegin��');
  end;
end;

procedure TFrm_Main.IdHTTP1WorkEnd(Sender: TObject; AWorkMode: TWorkMode);
begin
  if AbortTransfer then
    begin
//      Application.MessageBox(PChar('����ʧ�ܣ��ѱ��û��ж�'),PChar('ϵͳ��ʾ'),MB_OK+MB_ICONERROR);
      Abort;
      Application.Terminate;
    end
  else
    begin
      if aHint then Application.MessageBox(PChar('OK,���������ɹ�!'),PChar('ϵͳ��ʾ'),MB_OK+MB_ICONINFORMATION);
    end;
  PB_Cur.Position := 0;
end;

procedure TFrm_Main.ClearReg;
var
  MyReg:TRegistry;
  Code,ID,DT:String;
  aDate,DDate:TDate;
begin
  aDate:=Date;
  DDate:=EncodeDate(2004,12,31);
  if aDate<DDate then
    begin
       //
    end;
end;

procedure TFrm_Main.BakOldFile;
var
  BakPath,aFiles:String;
  i:integer;
  dFileName,LangFold:String;
begin
  BakPath:=ExtractFilePath(ParamStr(0))+'Bak';
  if not DirectoryExists(BakPath) then ForceDirectories(BakPath);
  For i:=0 to DownList.Count-1 do
    begin
      dFileName:=Copy(DownList.Strings[i],Pos('=',DownList.Strings[i])+1,Length(DownList.Strings[i]));
      if Pos('\',dFileName)>0 then
        begin
          LangFold:=copy(dFileName,0,Pos('\',dFileName)-1);
          if not DirectoryExists(BakPath+'\'+LangFold) then ForceDirectories(BakPath+'\'+LangFold);
        end;
      CopyFile(PChar(ExtractFilePath(ParamStr(0))+dFileName),PChar(BakPath+'\'+dFileName),False);
      PB_Whole.StepIt;        
    end;  
end;

procedure TFrm_Main.DownNetUpdateIni;
var
  aURL,aFile:String;
  FileStr:TStringList;
  i:integer;
begin
  FileStr:=TStringList.Create;
  aURL := MyURL+'NetUpdate.ini';
  FileStr.Add(IdHTTP1.Get(aURL));
  FileStr.SaveToFile(WinPath+'NetUpdate.ini');
  FileStr.Free;
  NetIni:=TIniFile.Create(WinPath+'NetUpdate.ini');
  with NetIni do
    begin
      ReadSectionValues('FilesList',DownList);
      ReadSectionValues('Exe FileList',ExeList);
      NetVerStr:=ReadString('Version Info','KQSys.exe','');
      SQLCount :=ReadInteger('SQL','SQLCount',15);
      WebStr   :=ReadString('WWW','URL','');
    end;
  nDownFileCount:=DownList.Count;
  NetVer:=StrToFloat(Copy(NetVerStr,1,3));
  DeleteFile(WinPath+'NetUpdate.ini');
end;

procedure TFrm_Main.DispPanelVer;
begin
  if FileExists('KQSys.exe') then
    begin
      LocalVerStr:=GetFileVerStr('KQSys.exe');
      if Pos('65535',LocalVerStr)>0 then Panel1.Caption:=Format('�Ӿɰ汾�������°汾( %S )',[NetVerStr])
      else  Panel1.Caption:=Format('�Ӿɰ汾( %S )�������°汾( %S )',[LocalVerStr,NetVerStr]);
    end
  else Panel1.Caption:=Format('�Ӿɰ汾�������°汾( %S )',[NetVerStr]);
end;


procedure TFrm_Main.DownAFile(aName: String);
var
  aURL, aFile: string;
  LStr:string;
begin
  aURL := MyURL+aName;  //���ص�ַ
  aFile := GetURLFileName(aURL); //�õ��ļ���������"KQSys.exe"
  if (aFile='KQSys.exe') or (aFile='Update.exe') then
    begin
      if FileExists(aFile) then
        begin
          if GetFileVerStr(aFile)=NetVerStr then  //˵�������µİ汾��
            begin
               case Application.MessageBox(PChar('ϵͳ�Ѿ������°汾�ˣ��Ƿ�Ҫ������'),PChar('ϵͳ��ʾ'),MB_YESNO+MB_ICONQUESTION) of
                  IDYes:
                    begin
                      aHint:=False;
                      NoRunSQL:=True;
                      MyDownLoad(aURL, aFile, False); //����
                    end;
                  IDNo: Exit; //ȡ��
               end;
            end
          else if Pos('65535',GetFileVerStr(aFile))>0 then
            begin
              case Application.MessageBox(PChar('ϵͳ��鵽ԭ���ļ�δ������ϣ��Ƿ�������'),PChar('ϵͳ��ʾ'),MB_YESNOCANCEL+MB_ICONQUESTION) of
                  IDYes:
                    begin
                      aHint:=False;
                      MyDownLoad(aURL, aFile, True); //����
                    end;
                  IDNo:
                    begin
                      MyDownLoad(aURL, aFile, False); //����
                    end;
                  IDCancel: Exit; //ȡ��
              end;
            end
          else if StrToFloat(Copy(GetFileVerStr(aFile),1,3))<NetVer then //˵���Ǿɰ汾��
            begin
              MyDownLoad(aURL, aFile, False); //�������ļ�����
            end;
        end
      else
        begin
          MyDownLoad(aURL, aFile, False); //�������ļ�����
        end;
    end
  else
    begin
      MyDownLoad(aURL, aFile, False); //�������ļ�����
    end;
end;

procedure TFrm_Main.WriteErrLog(ErrStr:String);
var
  LogFilename: String;
  LogFile: TextFile;
begin
  LogFilename:=ExtractFilePath(ParamStr(0))+'Error.Log';
  AssignFile(LogFile, LogFilename);
  if FileExists(LogFilename) then Append(LogFile)
  else Rewrite(LogFile);
  Writeln(Logfile,DateTimeToStr(now)+': '+ErrStr);
  CloseFile(LogFile);
end;

procedure TFrm_Main.FormDestroy(Sender: TObject);
begin
  DownList.Free;
  ExeList.Free;
  Frm_Main:=nil;
end;

end.
