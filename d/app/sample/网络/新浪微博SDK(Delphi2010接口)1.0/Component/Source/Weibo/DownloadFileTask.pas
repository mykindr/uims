unit DownloadFileTask;

interface
  uses
    SysUtils, Windows, Messages, Classes, Controls, ExtCtrls, DownloadFileFromWeb;

type
  TOnTaskCompleteEvent = procedure(Sender: TObject;
                                  TaskName: string;
                                  ADownloadFileList: TStringList;
                                  AID: Int64) of object;

type
  TDownloadFileTask = class(TComponent)
  private
    //�����ļ���
    FDownFile:TDownFile;
    //������
    FTaskName: string;
    //��������ʧ�ܴ���
    FMaxFailCount: Integer;
    //���ظ���
    FDownloadCount: Integer;
    //���ص�ַ
    FDownloadURL: string;
    //���ر���·��
    FSaveFileDir: string;
    //�����ļ��б�
    FDownloadFileList: TStringList;
    //�������Ϊ�ļ��б�
    FSaveAsFileList: TStringList;
    //��������¼�
    FOnTaskComplete: TOnTaskCompleteEvent;
    //�Ƿ��������
    FComplete: Boolean;
    //�Ƿ������ͷ�
    //FWillFree: Boolean;
    //�û�ID
    FID: Int64;
    procedure DoDownFileComplete;
    procedure DownFileComplete(AThread: TThread; Source_file, Dest_file: string;
                                blStatus: boolean; ErrMessage: string);
    procedure DownFileProgress(AThread: TThread; ulProgress, ulProgressMax, ulStatusCode: integer;
                                szStatusText: string);
    property DownloadFileList: TStringList read FDownloadFileList;
    property SaveAsFileList:TStringLIst read FSaveAsFileList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddDownload(AFileName,ASaveAsName:String);
    procedure BeginTask;
    property TaskName: string read FTaskName write FTaskName;
    property ID: Int64 read FID write FID;
    property MaxFailCount: Integer read FMaxFailCount write FMaxFailCount;
    property DownloadURL: string read FDownloadURL write FDownloadURL;
    property SaveFileDir: string read FSaveFileDir write FSaveFileDir;
    property OnTaskComplete: TOnTaskCompleteEvent read FOnTaskComplete write FOnTaskComplete;
  end;

  TDownloadFileTaskManage = class(TComponent)
  private
    FTaskList: TThreadList;
    FTaskTimer: TTimer;
    procedure OnTaskTimer(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    //��������б�
    procedure ClearTasks;
    //���һ������
    procedure AddTask(ATask: TDownloadFileTask);
    //�Ƴ�һ������
    procedure RemoveTask(ATask: TDownloadFileTask);
  end;

var
  DownloadFileTaskManage: TDownloadFileTaskManage;

implementation

{ TDownloadFileTask }

procedure TDownloadFileTask.AddDownload(AFileName, ASaveAsName: String);
begin
  Self.FDownloadFileList.Add(AFileName);
  Self.FSaveAsFileList.Add(ASaveAsName);
end;

procedure TDownloadFileTask.BeginTask;
var
  ILoop:Integer;
  ADownloadFileName:string;
  ASaveAsFileName:String;
begin
  if Assigned(DownloadFileTaskManage) then
  begin
    DownloadFileTaskManage.FTaskTimer.Enabled := True;
  end;
  for ILoop:=FDownloadFileList.Count - 1 downto 0 do
  begin
    ADownloadFileName:= FDownloadFileList[ILoop];
    ASaveAsFileName:=FSaveAsFileList[ILoop];
    FDownFile.ThreadDownFile(FDownloadURL+ADownloadFileName, FSaveFileDir+ASaveAsFileName);
  end;
end;

constructor TDownloadFileTask.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDownloadFileList := TStringList.Create;
  FSaveAsFileList := TStringList.Create;
  FDownFile := TDownFile.Create(nil);
  FDownFile.OnThreadComplete := DownFileComplete;
  FDownFile.OnThreadProgress := DownFileProgress;
  FDownloadCount := 0;
  FComplete := False;
  DownloadFileTaskManage.AddTask(Self);
end;


destructor TDownloadFileTask.Destroy;
begin
  if Assigned(DownloadFileTaskManage) then
    DownloadFileTaskManage.RemoveTask(Self);
  FreeAndNil(FDownFile);
  FDownloadFileList.Free;
  FSaveAsFileList.Free;
  inherited;
end;

procedure TDownloadFileTask.DownFileComplete(AThread: TThread; Source_file, Dest_file: string;
  blStatus: boolean; ErrMessage: string);
begin
  //if FWillFree then Exit;
  //�ɹ�������һ���ļ�
  if blStatus then
  begin
    FDownloadCount := FDownloadCount + 1;
    //������ȫ�����ļ�����ô�������ɹ�
    if FDownloadCount = FDownloadFileList.Count then
    begin
      FComplete := True;
      //FWillFree := True;
      if Assigned(DownloadFileTaskManage) then
      begin
        DownloadFileTaskManage.FTaskTimer.Enabled := True;
      end;
    end;
  end
  else
  begin
    if not FComplete then
    begin
      if FMaxFailCount > 0 then
      begin
        FMaxFailCount := FMaxFailCount-1;
        FDownFile.ThreadDownFile(Source_file, Dest_file);
      end
      else
      begin
        FDownloadCount := FDownloadCount + 1;
        if FDownloadCount = FDownloadFileList.Count then
        begin
          FComplete := True;
          //FWillFree := True;
        end;
      end;
    end;
  end;
end;

procedure TDownloadFileTask.DownFileProgress(AThread: TThread; ulProgress, ulProgressMax,
  ulStatusCode: integer; szStatusText: string);
begin

end;

procedure TDownloadFileTask.DoDownFileComplete;
begin
  if Assigned(FOnTaskComplete) then
    FOnTaskComplete(Self, FTaskName,FDownloadFileList,FID);
end;

{ TDownloadFileTaskManage }

procedure TDownloadFileTaskManage.AddTask(ATask: TDownloadFileTask);
var
  objList: TList;
begin
  objList := FTaskList.LockList();
  try
    objList.Add(ATask);
  finally
    FTaskList.UnlockList();
  end;
end;

procedure TDownloadFileTaskManage.ClearTasks;
var
  objList: TList;
  objTask: TDownloadFileTask;
begin
  objList := FTaskList.LockList();
  try
    while objList.Count > 0 do
    begin
      objTask := TDownloadFileTask(objList.Items[0]);
      objList.Delete(0);
      try
        objTask.Free();
      except
      end;
    end;
  finally
    FTaskList.UnlockList();
  end;
end;

constructor TDownloadFileTaskManage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTaskList := TThreadList.Create();
  //ÿһ���Ӽ�����ص�����
  FTaskTimer := TTimer.Create(nil);
  FTaskTimer.Interval := 1000;
  FTaskTimer.OnTimer := OnTaskTimer;
  FTaskTimer.Enabled := False;
end;

destructor TDownloadFileTaskManage.Destroy;
begin
  FTaskTimer.Free();
  ClearTasks();
  FTaskList.Free();
  inherited;
end;

procedure TDownloadFileTaskManage.OnTaskTimer(Sender: TObject);
var
  i: Integer;
  objList: TList;
  objTask: TDownloadFileTask;
begin
  objList := FTaskList.LockList();
  try
    for i := objList.Count - 1 downto 0 do
    begin
      objTask := TDownloadFileTask(objList.Items[i]);

      if objTask.FComplete then
      begin
        objTask.DoDownFileComplete();
        objList.Delete(i);
        objTask.Free();
      end;//if
//      if objTask.FWillFree then
//      begin
//        objList.Delete(i);
//        objTask.Free();
//      end;
    end;
    if objList.Count =0 then
    begin
      FTaskTimer.Enabled := False;
    end;
    //for
  finally
    FTaskList.UnlockList();
  end;
end;

procedure TDownloadFileTaskManage.RemoveTask(ATask: TDownloadFileTask);
var
  objList: TList;
begin
  objList := FTaskList.LockList();
  try
    objList.Remove(ATask);
  finally
    FTaskList.UnlockList();
  end;
end;

initialization
  DownloadFileTaskManage := TDownloadFileTaskManage.Create(nil);

finalization
  FreeAndNil(DownloadFileTaskManage);

end.
