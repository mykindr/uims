//ע�⣺Ӧ�ó������ɺ�Ӧ�޸�����
//SUpData.exe����RASDIAL.exe

//����RASDIAL.exeʱʹ������ָ��
//tempFile:=SPath+'RASDIAL.exe';                     //ϵͳ�����ļ�������
//TBlobField(Table1.FieldByName('FileData')).SaveToFile(tempFile);//��ȡ�������ļ�д��RASDIAL.exe

unit UpTemp;

interface

uses
  Windows, Messages, SysUtils, StrUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, jpeg;

type
  TUpTempForm = class(TForm)
    Panel1: TPanel;
    Timer1: TTimer;
    Image1: TImage;
    Label4: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    function DownloadFile(Source, Dest: string): Boolean;
  public
    { Public declarations }
  end;

const
  Versions='1.10';                                   //ϵͳ �汾�ţ��ж��Ƿ���Ҫ�Զ�����ʱ�ã�
  CrLf=#13+#10;                                         //�س����У�����ҵ���ʱ��List����ȡҵ���ʱʹ�ã�

  //��ͨ�����ֹ�˾������IP��222.41.161.40
  iTest = 1;                                            //0-ʹ�÷�������1-IPϵͳ���ԣ�ʹ�ñ���IP

var
  UpTempForm: TUpTempForm;
  t,tt:integer;
  SPath:string;

implementation

uses
  UrlMon;
  
{$R *.dfm}



//ϵͳ�Զ�����
procedure TUpTempForm.FormCreate(Sender: TObject);
begin
  GetDir(0,SPath);                                      //��ȡ��ǰĿ¼��,0-��ǰ������,1-A,2-B,3-C...
  SPath:=SPath+'\';                                     //ϵͳ��װĿ¼
  Timer1.Enabled:=true;
  t:=0;
  tt:=0;
end;

function TUpTempForm.DownloadFile(Source, Dest: string): Boolean;
begin
  try
    Result:=UrlDownloadToFile(nil, PChar(source), PChar(Dest), 0, nil) = 0;
  except
    Result := False;
  end;
end;

procedure TUpTempForm.Timer1Timer(Sender: TObject);
var
  i:integer;
  b:boolean;
  TSI:TStartupInfo;
  TPI:TProcessInformation;
  F:File;
  tempFile:String;
  BakFile:String;
begin
  Timer1.Enabled:=false;
  if (t<=5) then                                        //�ȴ�5��
  begin
    t:=t+1;
  end
  else
  begin
    tempFile:='RASDIAL.exe';                            //����RASDIAL.exe ��UpData.exe��
    BakFile:='RASDIAL.bak';                             //����RASDIAL.exe ��UpData.exe��

    if (tt=0) then                                      //δ����
    begin
      if iTest=1 then                                     //����
      begin
        b:=DownloadFile('\\127.0.0.1\UpData\'+tempFile, SPath+BakFile);
      end
      else
      begin
        b:=DownloadFile('\\222.41.161.40\UpData\'+tempFile, SPath+BakFile);
      end;

      if not b then                                       //������ʧ��
      begin
        messagebeep(0);
//      showmessage('          ϵͳ����ʧ�ܣ�����ά��������ϵ           ');
        Application.Terminate;
        exit;
      end;
      tt:=1;
    end;

    //ɾ��ԭʼ�ļ�
    if not DeleteFile(SPath+tempFile) then              //ɾ��ԭʼ�ļ�
    begin
      if FileExists(SPath+tempFile) then                //���ָ�����ļ������
      begin
        t:=0;                                             //���¼�ʱ
        Timer1.Enabled:=true;
        exit;
      end;
    end;

    tempFile:='RASDIAL.exe';                            //����RASDIAL.exe ��UpData.exe��
    BakFile:='RASDIAL.bak';                             //����RASDIAL.exe ��UpData.exe��

    //�����ļ�����
    AssignFile(F,SPath+BakFile);                        //��BakFile�ļ���F�����������ӣ��������ʹ��F�������ļ����в�����
    ReName(F,SPath+tempFile);                           //tempFile
//  CloseFile(F);                                       //����Ҫ�ر��ļ�

    //������������ʱ����������Ӧ��ԭ������this.exe��ͬһĿ¼�¡������������ʱ������汾������Ӧ���˳�����Ҫ��֤������ɾ���κ��ļ�����Ϊ��ʱApplication.Initialize��û�б����á��������£�
    FillChar(TSI, SizeOf(TSI), 0);
    TSI.CB := SizeOf(TSI);
    //�򿪲�������������
    if CreateProcess (PChar(SPath+tempFile), nil, nil, nil, False, DETACHED_PROCESS, nil, nil, TSI, TPI) then
    begin
      Application.Terminate;                                     //����
    end
    else     //���ǣ������������������ĳЩԭ��û�����У����Ǵ�ʱӦ�ø����û�������ͨ�����������õ�һ�����µĳ���汾����ʱ������Ȼ�˳��������Ա��û������������Ҫ�Ļ���Ҳ���Լ���װ�벢���оɰ汾��
    begin
      messagebeep(0);
//    showmessage('          ϵͳ����ʧ�ܣ�����ά��������ϵ           ');
      Application.Terminate;
    end;
  end;
  Timer1.Enabled:=true;
end;

end.
