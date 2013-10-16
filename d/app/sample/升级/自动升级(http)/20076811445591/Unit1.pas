unit Unit1;
interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze, IniFiles,
  IdThreadComponent, IdFTP, ExtCtrls, IdRawBase, IdRawClient, IdIcmpClient,
  RzCmboBx, AbBase, AbBrowse, AbZBrows, AbUnzper;

type
  TThread1 = class(TThread)

  private
    fCount, tstart, tlast: integer;
    tURL, tFile, temFileName: string;
    tResume: Boolean;
    tStream: TFileStream;
  protected
    procedure Execute; override;
  public
    constructor create1(aURL, aFile, fileName: string; bResume: Boolean; Count,
      start, last: integer);
    procedure DownLodeFile(); //�����ļ�
  end;
type
  TForm1 = class(TForm)
    IdAntiFreeze1: TIdAntiFreeze;
    IdHTTP1: TIdHTTP;
    Button1: TButton;
    IdThreadComponent1: TIdThreadComponent;
    Button3: TButton;
    ListBox1: TListBox;
    Image1: TImage;
    ICMP: TIdIcmpClient;
    StatusBar1: TStatusBar;
    ProgressBar1: TProgressBar;
    Button5: TButton;
    IdHTTP2: TIdHTTP;
    Edit1: TRzComboBox;
    AbUnZipper1: TAbUnZipper;
    procedure Button1Click(Sender: TObject);
    procedure IdHTTP1WorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCountMax: Integer);
    procedure IdHTTP1Work(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
    procedure Button2Click(Sender: TObject);
    procedure IdHTTP1Status(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: string);
    procedure Button3Click(Sender: TObject);
    procedure ICMPReply(ASender: TComponent;
      const AReplyStatus: TReplyStatus);
    procedure StatusBar1DrawPanel(StatusBar: TStatusBar;
      Panel: TStatusPanel; const Rect: TRect);
    procedure IdHTTP1WorkEnd(Sender: TObject; AWorkMode: TWorkMode);
    procedure Button5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
     g_path: string;
    sys_id: string;
    AppIni: TIniFile;

  public
    nn, aFileSize, avg: integer;
    MyThread: array[1..10] of TThread;
    progressBarRect:TRect;
    procedure GetThread();
    procedure AddFile();
    function GetURLFileName(aURL: string): string;
    function GetFileSize(aURL: string): integer;
  end;

var
  Form1: TForm1;
implementation
var
  AbortTransfer: Boolean;
  aURL, aFile: string;
  tcount: integer; //����ļ��Ƿ�ȫ���������
  ip_address,FPath,Tver,over:string;   //���ص�ַ
  DownFile:string;
  oFile: TIniFile;
{$R *.dfm}
function TForm1.GetURLFileName(aURL: string): string;
var
  i: integer;
  s: string;
begin //�������ص�ַ���ļ���
  s := aURL;
  i := Pos('/', s);
  while i <> 0 do //ȥ��"/"ǰ�������ʣ�µľ����ļ�����
  begin
    Delete(s, 1, i);
    i := Pos('/', s);
  end;
  Result := s;
end;

//get FileSize

function TForm1.GetFileSize(aURL: string): integer;
var
  FileSize: integer;
begin
  try
  IdHTTP1.Head(aURL);
  FileSize := IdHTTP1.Response.ContentLength;
  IdHTTP1.Disconnect;
  Result :=FileSize;
  except
      Showmessage('�ļ����ʧ��,�������ص�ַ!');
      Exit;
    end;
end;

//ִ������

procedure TForm1.Button1Click(Sender: TObject);
var
  j: integer;
begin
 ProgressBar1.Position := 0;
 ListBox1.Items.Clear ;
 statusbar1.panels[0].Text:='��ʼ����';
  tcount := 0;
  aURL := trim(Edit1.Text)+downfile; //���ص�ַ
  aFile := GetURLFileName(aURL); //�õ��ļ���
  aFileSize := GetFileSize(aURL);
  if   aFileSize<1 then  begin
      nn :=0 ;//�߳���
      ListBox1.ItemIndex := Form1.ListBox1.Items.Add('����ʧ��!');
      exit;
    end
  else
    nn :=5 ;//�߳���
  ListBox1.Items.Add('��������,�����ĵȺ�...');  
  j := 1;
  avg := trunc(aFileSize / nn);
  begin
    try
      GetThread();
      while j <= nn do
      begin
        MyThread[j].Resume; //�����߳�
        j := j + 1;
      end;
    except
      Showmessage('�����߳�ʧ��!');
      Exit;
    end;
  end; 
end;

//��ʼ����ǰ,��ProgressBar1�����ֵ����Ϊ��Ҫ���յ����ݴ�С.

procedure TForm1.IdHTTP1WorkBegin(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCountMax: Integer);
begin
    AbortTransfer := False;
    ProgressBar1.Max := AWorkCountMax;
    ProgressBar1.Min := 0;
    ProgressBar1.Position := 0;
end;

//�������ݵ�ʱ��,���Ƚ���ProgressBar1��ʾ����.

procedure TForm1.IdHTTP1Work(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCount: Integer);
begin
  if AbortTransfer then
  begin
    IdHTTP1.Disconnect; //�ж�����
  end;
  ProgressBar1.Position:=ProgressBar1.Position+AWorkCount;
  statusbar1.panels[0].Text:='������:'+inttostr((ProgressBar1.Position div 1024)*5)+'K�ֽ�,�ܹ�:'+inttostr((ProgressBar1.Max div 1024)*5)+'K�ֽ�,Լ'+inttostr(ProgressBar1.Position*100 div ProgressBar1.Max)+'%';
  Application.ProcessMessages;
end;

//�ж�����

procedure TForm1.Button2Click(Sender: TObject);
begin
  AbortTransfer := True;
  IdHTTP1.Disconnect;
end;

//״̬��ʾ

procedure TForm1.IdHTTP1Status(ASender: TObject; const AStatus: TIdStatus;
  const AStatusText: string);
begin
    // ListBox1.ItemIndex := ListBox1.Items.Add('��������');
end;

//�˳�����

procedure TForm1.Button3Click(Sender: TObject);
begin
  application.Terminate;

end;

//ѭ�������߳�

procedure TForm1.GetThread();
var
  i: integer;
  start: array[1..100] of integer;
  last: array[1..100] of integer;   //���������飬Ҳ�ɲ���
  fileName: string;
begin
  i := 1;
  while i <= nn do
  begin
    start[i] := avg * (i - 1);
    last[i] := avg * i -1; //����ԭ����last:=avg*i;
    if i = nn then
    begin
      last[i] := avg*i + aFileSize-avg*nn; //����ԭ����aFileSize
    end;
    fileName := aFile + IntToStr(i);
    MyThread[i] := TThread1.create1(aURL, aFile, fileName, false, i, start[i],
      last[i]);
    i := i + 1;
  end;
end;

procedure TForm1.AddFile(); //�ϲ��ļ�
var
  mStream1, mStream2: TMemoryStream;
  i: integer;
begin
  i := 1;
  mStream1 := TMemoryStream.Create;
  mStream2 := TMemoryStream.Create;
  mStream1.loadfromfile(FPath+downfile + '1');
  while i < nn do
  begin
    mStream2.loadfromfile(FPath+downfile + IntToStr(i + 1));
    mStream1.seek(mStream1.size, soFromBeginning);
    mStream1.copyfrom(mStream2, mStream2.size);
    mStream2.clear;
    i := i + 1;
  end;
  mStream2.free;
  mStream1.SaveToFile(FPath+downfile);
  mStream1.free;
  //ɾ����ʱ�ļ�
  i:=1;
   while i <= nn do
  begin
    deletefile(FPath+downfile + IntToStr(i));
    i := i + 1;
  end;
  Form1.ListBox1.ItemIndex := Form1.ListBox1.Items.Add('���سɹ�');
end;

//���캯��

constructor TThread1.create1(aURL, aFile, fileName: string; bResume: Boolean;
  Count, start, last: integer);
begin
  inherited create(true);
  FreeOnTerminate := true;
  tURL := aURL;
  tFile := aFile;
  fCount := Count;
  tResume := bResume;
  tstart := start;
  tlast := last;
  temFileName := fileName;
end;
//�����ļ�����

procedure TThread1.DownLodeFile();
var
  temhttp: TIdHTTP;
begin
  temhttp := TIdHTTP.Create(nil);
  temhttp.onWorkBegin := Form1.IdHTTP1WorkBegin;
  temhttp.onwork := Form1.IdHTTP1work;
  temhttp.onStatus := Form1.IdHTTP1Status;
  Form1.IdAntiFreeze1.OnlyWhenIdle := False; //����ʹ�����з�Ӧ.
  if FileExists(temFileName) then //����ļ��Ѿ�����
    tStream := TFileStream.Create(temFileName, fmOpenWrite)
  else
    tStream := TFileStream.Create(temFileName, fmCreate);
  if tResume then //������ʽ
  begin
    exit;
  end
  else //���ǻ��½���ʽ
  begin
    temhttp.Request.ContentRangeStart := tstart;
    temhttp.Request.ContentRangeEnd := tlast;
  end;

  try
    temhttp.Get(tURL, tStream); //��ʼ����
  finally
    //tStream.Free;
    freeandnil(tstream);
    temhttp.Disconnect;
  end;

end;

procedure TThread1.Execute;
var s :string;

begin
  if Form1.Edit1.Text <> '' then
    DownLodeFile
  else
    exit;
  inc(tcount);
  if tcount = Form1.nn then //��tcount=nnʱ����ȫ�����سɹ�
  begin
    Form1.ListBox1.ItemIndex := Form1.ListBox1.Items.Add('���ںϲ��ļ�');
    Form1.AddFile;
    Form1.ListBox1.ItemIndex := Form1.ListBox1.Items.Add('��ʼ��ѹ��!');
  try
    with Form1.AbUnZipper1 do begin
      FileName:=FPath + DownFile;

      //showmessage(s)   ;
     if uppercase(copy(s,pos('.', downfile) + 1, 3))='ZIP' then
       begin
         BaseDirectory :=FPath;
         ExtractFiles( '*.*' );
        end
       else
        begin
         CloseArchive ;
         Form1.ListBox1.ItemIndex := Form1.ListBox1.Items.Add('�ļ���ʽ��֧�֣��ļ����سɹ�');
        end
    end;
    Form1.AbUnZipper1.CloseArchive ;
    deletefile(FPath+'OVer.ini');
    RenameFile(FPath+'Ver.ini','OVer.ini');
    Form1.ListBox1.ItemIndex := Form1.ListBox1.Items.Add('�����ɹ�!');
    Form1.Button1.Enabled:=false;
    except
      Form1.ListBox1.ItemIndex := Form1.ListBox1.Items.Add('��ѹ��zip�ļ�ʧ��!');
      Form1.ListBox1.ItemIndex := Form1.ListBox1.Items.Add('�ļ���ʽ��֧��,���ļ����سɹ�');
      //Showmessage('��ѹ��ʧ��!');
      Exit;
   end;
  end;
end;


procedure TForm1.ICMPReply(ASender: TComponent;
  const AReplyStatus: TReplyStatus);
var
  sTime: string;
begin
  if (AReplyStatus.MsRoundTripTime = 0) then
    sTime := '<1'
  else
    sTime := '=';
    ListBox1.Items.Add('������Գɹ�');
end;

procedure TForm1.StatusBar1DrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
begin
    progressBarRect:=Rect;
end;

procedure TForm1.IdHTTP1WorkEnd(Sender: TObject; AWorkMode: TWorkMode);
begin
    ProgressBar1.Position:=ProgressBar1.Max;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  MyStream:TMemoryStream;
  iFile: TIniFile;
  i: integer;
begin
    FPath := ExtractFilePath(Application.ExeName);
    ip_address:=trim(Edit1.Text);
    oFile:= TIniFile.Create(FPath + 'OVer.ini');     //�ϰ汾��
    over:=oFile.ReadString('sVer', 'Ver', 'δ֪��');
    ListBox1.Items.Clear;
    ICMP.OnReply := ICMPReply;
    ICMP.ReceiveTimeout := 1000;
    ICMP.Host:=copy(trim(Edit1.Text),8,Length(trim(Edit1.Text))-7);   //ȥ��http//
  try
  //  for i := 1 to 3 do begin
   //   ICMP.Ping;
   //   Application.ProcessMessages;
  //  end;
  except
        ListBox1.Items.Add('�������ʧ��');
        exit;
     end;
     IdAntiFreeze1.OnlyWhenIdle:=False;//����ʹ�����з�Ӧ.
     MyStream:=TMemoryStream.Create;
  try
     ip_address:=trim(Edit1.Text);
     IdHTTP2.Get(ip_address+'/Ver.txt',MyStream); //��ΪINI�ļ���������
  except
     ListBox1.Items.Add('�����ļ����ʧ��!');
     ListBox1.Items.Add('��������������ַ!');
     MyStream.Free;
     Exit;
  end;
    MyStream.SaveToFile(FPath+'Ver.ini');   //���ļ��ظ�ΪINI
    MyStream.Free;
    iFile := TIniFile.Create(FPath + 'Ver.ini');
    Tver := iFile.ReadString('sVer', 'Ver', 'δ֪��');
     if Tver=over then
    begin
      ListBox1.Items.Add('�Ѿ������°汾,��������!');
       deletefile(FPath+'Ver.ini');
      Exit;
    end
    else
     begin
        Button1.Enabled:=true;
        ListBox1.Items.Add('Ӧ���������°��ļ�!!!');
        Button1Click(self);
     end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var i,j:integer;
files:TStrings;
servers: TStringlist;
begin
    FPath := ExtractFilePath(Application.ExeName);
    files := TStringList.Create;
    try
 if copy(FPath, length(FPath), 1) <> '\' then FPath := FPath + '\';
    AppIni := TIniFile.Create(FPath + 'OVer.ini');
    sys_id := AppIni.ReadString('chis', 'SubSys', '');
    DownFile:=appini.ReadString('chis','exe','update.rar') ;
    servers := TStringList.Create;
    AppIni.ReadSectionValues('update', servers);
    edit1.Clear ;
    for i := 0 to servers.Count - 1 do
    begin

      edit1.AddItemValue(copy(servers[i], pos('=', servers[i]) + 1, length(servers[i])),copy(servers[i], pos('=', servers[i]) + 1, length(servers[i])));
      if i = 0 then edit1.Text := copy(servers[i], pos('=', servers[i]) + 1, length(servers[i]));
    end;
  finally
    AppIni.Free;
end;

end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
    ListBox1.Items.Clear ;
end;

end.
