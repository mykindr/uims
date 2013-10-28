unit URunDosThrd;

interface

uses
  Messages, Windows, SysUtils, Classes;

const
  READCOUNT = 1;
  //�Զ�����Ϣ��
  WM_CREATEPIPE_ERROR    = WM_USER + 1;
  WM_CREATEPROCESS_ERROR = WM_USER + 2;
  WM_READPIPE_ERROR      = WM_USER + 3;
  WM_FINISHED_COMMAND    = WM_USER + 4;

type
  TRunDosThread = class(TThread)
  private
    { Private declarations }
    Security : TSecurityAttributes;
    ReadPipe,WritePipe : Thandle;
    StartInfo : TStartUpInfo;
    ProcessInfo : TProcessInformation;
    //ProcessInformation: TProcessInformation;
    Buf: PChar;
    Command_line: string;
    DosApp: string;   
    procedure UpdateShow;
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended:boolean; AppName: string);
  end;

var
  aRunDosThread: TRunDosThread;

implementation

uses UMain;

constructor TRunDosThread.Create(CreateSuspended:boolean; AppName: string);
begin
  DosApp := AppName;
  FreeOnTerminate := True;
  inherited Create(CreateSuspended);
end;

procedure TRunDosThread.UpdateShow;
var
  s: string;
  i: integer;
begin
  s := string(Buf);
  i:=0;
  if Length(s)=0 then Exit;
  while True do begin
    i:=i+1;
    if s[i] = #10 then begin
       Insert(#13,s,i);
       i:=i+1;
    end;
    if i>=Length(s) then Break;
  end;
  
  FrmMain.MemoDOS.Text := FrmMain.MemoDOS.Text + s;
  FrmMain.MemoDOS.Refresh;
  
end;

procedure TRunDosThread.Execute;
var
  dwRead: DWORD;
  len: integer;
begin
  { Place thread code here }

  // ������Spawn.exeͨѶ�Ŀɼ̳е������ܵ�
  with Security do begin
    nlength := SizeOf(TSecurityAttributes);
    binherithandle := True;
    lpsecuritydescriptor := nil;
  end;
  if not Createpipe (ReadPipe, WritePipe, @Security, 0) then begin
     PostMessage(FrmMain.Handle,WM_CREATEPIPE_ERROR,0,0);
     Exit;
  end;

  // ׼��Spawn�������У��������и���д�ܵ������ҪSpawnִ�е�����
  FmtStr(command_line, 'spawn -h %d %s',[WritePipe, DosApp]);
  // �ӽ��������ط�ʽ����
  with StartInfo do begin
    cb := SizeOf(TStartUpInfo);
    dwFlags :=STARTF_USESHOWWINDOW;
    wShowWindow := SW_HIDE;
  end;

  // ����Spawn�ӽ���
  if not CreateProcess( nil, PChar(Command_line), nil, nil, TRUE,
                    0, nil, nil, StartInfo, ProcessInfo) then begin
     PostMessage(FrmMain.Handle,WM_CREATEPROCESS_ERROR,0,0);
     Exit;
  end;

  // ���ܵ�������ʾSpawn�ӹܵ��з��ص������Ϣ
  if (not ReadFile(ReadPipe, len, Sizeof(integer), dwRead, nil)) or (dwRead = 0) then Exit;

  while (len<>0) do begin
     Buf := AllocMem(len + 1);
     try
       ZeroMemory(buf,len+1);
       if (not ReadFile(ReadPipe, buf[0], len, dwRead, nil)) or (dwRead = 0) then Exit;
       buf[dwRead]:= #0;
       // �������ʾ��Memo�У���ˢ�¶Ի���
       Synchronize(UpdateShow);

       if (not ReadFile(ReadPipe, len, Sizeof(integer), dwRead, nil)) or (dwRead = 0) then Exit;

     finally
       FreeMem(Buf);
     end;
  end;

  // �ȴ�Spawn����
  WaitForSingleObject(ProcessInfo.hProcess, 30000);

  // �رչܵ����
  CloseHandle(ProcessInfo.hProcess);
  CloseHandle(ProcessInfo.hThread);
  CloseHandle(ReadPipe);
  CloseHandle(WritePipe);
  PostMessage(FrmMain.Handle,WM_FINISHED_COMMAND,0,0);  
end;

end.
