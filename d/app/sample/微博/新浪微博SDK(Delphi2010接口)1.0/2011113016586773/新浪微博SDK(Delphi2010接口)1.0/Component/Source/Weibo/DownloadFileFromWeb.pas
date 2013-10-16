unit DownloadFileFromWeb;

interface

uses
  Windows, SysUtils, UrlMon, ActiveX, Classes, ExtCtrls, shellapi;

type
  //��������״̬�ص��ӿ���
  TOnThreadProgressEvent =
    procedure(AThread: TThread;                //�߳�
              ulProgress,                      //���ؽ���
              ulProgressMax,                   //������
              ulStatusCode: integer;           //״̬��
              szStatusText:string) of object;  //״̬�ַ���
  TOnThreadCompleteEvent =
    procedure(AThread: TThread;                //�߳�
              Source_file,                     //Դ�ļ�
              Dest_file: string;
              blStatus:boolean;
              ErrMessage:string) of object;

  TDownFile = class;
  TDownThread = class;

  //���ؽ��ȣ������Ϣ�ص��ӿ�
  TBindStatusCallback = class(TObject, IBindStatusCallback)
  private
    //�����߳�
    FDownThread: TDownThread;
    FOnThreadProgress: TOnThreadProgressEvent;
    procedure CallThreadProgress(
          AThread: TThread;
          ulProgress,
          ulProgressMax,
          ulStatusCode: integer;
          szStatusText:string);
    procedure SetOnThreadProgress(const Value: TOnThreadProgressEvent);  //���ؽ��ȣ��̣߳�
  protected
    // IUnknown
    FRefCount: Integer;
    function QueryInterface(const IID: TGUID; out Obj): Integer; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  public
    // IBindStatusCallback
    function OnStartBinding(dwReserved: DWORD; pib: IBinding): HResult; stdcall;
    function GetPriority(out nPriority): HResult; stdcall;
    function OnLowResource(reserved: DWORD): HResult; stdcall;
    function OnProgress(ulProgress, ulProgressMax, ulStatusCode: ULONG;szStatusText: LPCWSTR): HResult; stdcall;
    function OnStopBinding(hresult: HResult; szError: LPCWSTR): HResult; stdcall;
    function GetBindInfo(out grfBINDF: DWORD; var bindinfo: TBindInfo): HResult; stdcall;
    function OnDataAvailable(grfBSCF: DWORD; dwSize: DWORD; formatetc: PFormatEtc;stgmed: PStgMedium): HResult; stdcall;
    function OnObjectAvailable(const iid: TGUID; punk: IUnknown): HResult; stdcall;
    property OnThreadProgress: TOnThreadProgressEvent read FOnThreadProgress write SetOnThreadProgress;
  end;

  //�����߳���
  TDownThread = class(TThread)
  private
    //�ص�
    FStatusCallback:TBindStatusCallback;
    //�ļ�������
    FDownFile:TDownFile;
    //Դ�ļ���
    Source_file:string;
    //�����ڱ��ص��ļ���
    Dest_file:string;
    //�����Ƿ�ɹ�
    blDownOK:boolean;
    //������Ϣ
    ErrMessage:string;
    //ȡ��
    FCancel:Boolean;
    //���ؽ���
    FOnThreadProgress:TOnThreadProgressEvent;
    //�������
    FOnThreadComplete:TOnThreadCompleteEvent;
    //�������ؽ��Ȼص�
    procedure CallThreadProgress(AThread: TThread; ulProgress, ulProgressMax, ulStatusCode: integer; szStatusText:string);
    //������������¼�
    procedure CallThreadComplete(AThread: TThread; Source_file, Dest_file: string; blStatus:boolean; ErrMessage:string);
    //�����߳̽����¼�
    //���ؽ��ȣ��̣߳�
    procedure SetOnThreadProgress(const Value: TOnThreadProgressEvent);
    //�����߳�����¼�
    //������ɣ��̣߳�
    procedure SetOnThreadComplete(const Value: TOnThreadCompleteEvent);
  protected
    procedure Execute;override;
  public
    constructor Create(URL,
                       FileName:string;
                       DownFile:TDownFile);
    destructor Destroy;override;
    //ȡ������
    procedure Cancel;
  published
    property OnThreadProgress: TOnThreadProgressEvent read FOnThreadProgress write SetOnThreadProgress;
    property OnThreadComplete: TOnThreadCompleteEvent read FOnThreadComplete write SetOnThreadComplete;
  end;


  //�ļ����ؿؼ�
  TDownFile = class(TComponent)
  private
    //�����߳��б�
    FDownThreads: TThreadList;
    //���ؽ���
    FOnThreadProgress: TOnThreadProgressEvent;
    //�������
    FOnThreadComplete: TOnThreadCompleteEvent;
    //�Ƴ��߳�
    procedure RemoveThread(AThread: TDownThread);
    ////////
    //procedure CallThreadProgress(AThread: TThread; ulProgress, ulProgressMax, ulStatusCode: integer; szStatusText:string);
    //procedure CallThreadComplete(AThread: TThread; Source_file, Dest_file: string; blStatus:boolean; ErrMessage:string);
    ////////
    //���ؽ��ȣ��̣߳�
    procedure SetOnThreadProgress(const Value: TOnThreadProgressEvent);
    //������ɣ��̣߳�
    procedure SetOnThreadComplete(const Value: TOnThreadCompleteEvent);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    //ȡ�����������߳�.
    procedure CancelThreads;
    //�����ļ�
    procedure ThreadDownFile(Source, Dest: string);
  published
    property OnThreadProgress: TOnThreadProgressEvent read FOnThreadProgress write SetOnThreadProgress;
    property OnThreadComplete: TOnThreadCompleteEvent read FOnThreadComplete write SetOnThreadComplete;
  end;

implementation

{ TBindStatusCallback }

function TBindStatusCallback._AddRef: Integer;
begin
  Inc(FRefCount);
  Result := FRefCount;
end;

function TBindStatusCallback._Release: Integer;
begin
  Dec(FRefCount);
  Result := FRefCount;
end;

procedure TBindStatusCallback.CallThreadProgress(AThread: TThread; ulProgress,
  ulProgressMax, ulStatusCode: integer; szStatusText: string);
begin
  if Assigned(FOnThreadProgress) then
    FOnThreadProgress(AThread, ulProgress, ulProgressMax, ulStatusCode, szStatusText);
end;

function TBindStatusCallback.GetBindInfo(out grfBINDF: DWORD;
  var bindinfo: TBindInfo): HResult;
begin
  Result := E_NOTIMPL;
end;

function TBindStatusCallback.GetPriority(out nPriority): HResult;
begin
  Result := E_NOTIMPL;
end;

function TBindStatusCallback.OnDataAvailable(grfBSCF, dwSize: DWORD;
  formatetc: PFormatEtc; stgmed: PStgMedium): HResult;
begin
  Result := E_NOTIMPL;
end;

function TBindStatusCallback.OnLowResource(reserved: DWORD): HResult;
begin
  Result := E_NOTIMPL;
end;

function TBindStatusCallback.OnObjectAvailable(const iid: TGUID;
  punk: IInterface): HResult;
begin
  Result := E_NOTIMPL;
end;

function TBindStatusCallback.OnStartBinding(dwReserved: DWORD;
  pib: IBinding): HResult;
begin
  Result := E_NOTIMPL;
end;

function TBindStatusCallback.OnStopBinding(hresult: HResult;
  szError: LPCWSTR): HResult;
begin
  Result := E_NOTIMPL;
end;

function TBindStatusCallback.QueryInterface(const IID: TGUID;
  out Obj): Integer;
begin
  if GetInterface(IID, Obj) then
    Result := S_OK
  else
    Result := E_NOINTERFACE;
end;

procedure TBindStatusCallback.SetOnThreadProgress(
  const Value: TOnThreadProgressEvent);
begin
  FOnThreadProgress := Value;
end;

function TBindStatusCallback.OnProgress(ulProgress, ulProgressMax,
  ulStatusCode: ULONG; szStatusText: LPCWSTR): HResult;
begin
  Result := S_OK;
  CallThreadProgress(FDownThread,ulProgress,ulProgressMax,ulStatusCode,szStatusText);
end;

{ TDownFile }

procedure TDownFile.CancelThreads;
var
  DownThread: TDownThread;
  objList: TList;
begin
  objList := FDownThreads.LockList();
  try
    while objList.Count > 0 do
    begin
      DownThread := TDownThread(objList.Items[0]);
      objList.Delete(0);
      DownThread.Cancel();
    end;//while
  finally
    FDownThreads.UnlockList();
  end;
end;

constructor TDownFile.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDownThreads := TThreadList.Create();
end;

procedure TDownFile.RemoveThread(AThread: TDownThread);
var
  objList: TList;
begin
  objList := FDownThreads.LockList();
  try
    objList.Remove(AThread);
  finally
    FDownThreads.UnlockList();
  end;
end;

destructor TDownFile.Destroy;
begin
  CancelThreads();
  FDownThreads.Free();
  inherited;
end;

procedure TDownFile.SetOnThreadComplete(const Value: TOnThreadCompleteEvent);
begin
  FOnThreadComplete := Value;
end;

procedure TDownFile.SetOnThreadProgress(const Value: TOnThreadProgressEvent);
begin
  FOnThreadProgress := Value;
end;

procedure TDownFile.ThreadDownFile(Source, Dest: string);
var
  DownThread:TDownThread;
  objList: TList;
begin
  objList := FDownThreads.LockList();
  try
    DownThread := TDownThread.Create(Source, Dest, Self);
    DownThread.OnThreadProgress:=OnThreadProgress;
    DownThread.OnThreadComplete:=OnThreadComplete;
    objList.Add(DownThread);
    DownThread.Resume;
  finally
    FDownThreads.UnlockList();
  end;
end;

{ TDownThread }

procedure TDownThread.CallThreadComplete(AThread: TThread; Source_file,
  Dest_file: string; blStatus: boolean; ErrMessage: string);
begin
  if Assigned(FOnThreadComplete) then
  begin
    FOnThreadComplete(AThread, Source_file, Dest_file, blStatus, ErrMessage);
  end;
end;

procedure TDownThread.CallThreadProgress(AThread: TThread; ulProgress,
  ulProgressMax, ulStatusCode: integer; szStatusText: string);
begin
  if Assigned(FOnThreadProgress) then
  begin
    FOnThreadProgress(AThread, ulProgress, ulProgressMax, ulStatusCode, szStatusText);
  end;
end;

procedure TDownThread.Cancel;
begin
  FCancel := True;
  FDownFile := nil;
end;

constructor TDownThread.Create(URL, FileName: string; DownFile: TDownFile);
begin
  inherited Create(True);
  //���ػص�����
  FStatusCallback := TBindStatusCallback.Create;
  FStatusCallback.FDownThread := Self;
  //��ֹ�ͷ�
  FreeOnTerminate := True;
  //�����ļ�
  FDownFile := DownFile;
  //Դ�ļ�
  Source_file := URL;
  //�����ļ�
  Dest_file := FileName;
  //ȡ��
  FCancel := False;
end;

destructor TDownThread.Destroy;
begin
  if FDownFile<>nil then
  begin
    FDownFile.RemoveThread(Self);
  end;
  FStatusCallback.Free();
  inherited;
end;

procedure TDownThread.Execute;
begin
  //������Ϣ
  ErrMessage:='';
  //�Ƿ����سɹ�
  blDownOK:=False;
  //�����ļ�
  try
    if UrlDownloadToFile(nil,Pchar(Source_file),Pchar(Dest_file), 0, FStatusCallback) = 0 then
    begin
      blDownOK:=True;
    end;
  except
    on E:Exception do
    begin
      ErrMessage := e.Message;
    end;
  end;
  //���ȡ������ôӦ��������һ��ҲҪȡ��,����ִ�������ִ���壬
  if FCancel then Exit;
  //���FDownFile�Ѿ��ͷ�,�̻߳�ִֻ�е������ô�����.
  CallThreadComplete(Self, Source_file, Dest_file, blDownOK, ErrMessage);
end;

procedure TDownThread.SetOnThreadComplete(const Value: TOnThreadCompleteEvent);
begin
  FOnThreadComplete := Value;
end;

procedure TDownThread.SetOnThreadProgress(const Value: TOnThreadProgressEvent);
begin
  FOnThreadProgress := Value;
  FStatusCallback.OnThreadProgress := Value;
end;

end.
