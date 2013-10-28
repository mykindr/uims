unit RasDial3;
//Downlolad by http://www.codefans.net
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Formauto, StdCtrls, ShellApi, ComCtrls, ExtCtrls, registry, IniFiles;

type
  TConfigureAutoForm = class(TAutoForm)
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel2: TPanel;
    GroupBox4: TGroupBox;
    AutoStarted: TCheckBox;
    AutoConnected: TCheckBox;
    ReConnected: TCheckBox;
    Label7: TLabel;
    ReConnectTime: TComboBox;
    Label8: TLabel;
    ReConnectNb: TEdit;
    CancelButton: TButton;
    OkButton: TButton;
    procedure CancelButtonClick(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    function  GetAutoConnect : Boolean;
    procedure SetAutoConnect(newValue : Boolean);
    function  GetAutoStart : Boolean;
    procedure SetAutoStart(newValue : Boolean);
    function  GetReConnect : Boolean;
    procedure SetReConnect(newValue : Boolean);
    procedure ExecuteProg(Exe, Dir : String);
function SetRegValue(key:Hkey; subkey,name,value:string):boolean;
procedure SetDelValue(ROOT: hKey; Path, Value: string);
  public
    Section : String;
    procedure Configure;
    property  AutoConnect : Boolean  read GetAutoConnect  write SetAutoConnect;
    property  AutoStart : Boolean  read GetAutoStart  write SetAutoStart;
    property  ReConnect : Boolean  read GetReConnect  write SetReConnect;
  end;

var
  ConfigureAutoForm: TConfigureAutoForm;

implementation

uses
  RasDial5, RasDial1;

{$R *.DFM}


//����������Ϣ
procedure TConfigureAutoForm.Configure;
var
  OldAutoStart:Boolean;
  OldAutoConnect:Boolean;
  OldReConnect:Boolean;
  OldAutoPassword:Boolean;
  OldReConnectTime:integer;
  OldReConnectNb:integer;
begin
  OldAutoStart:=AutoStarted.Checked;                    //�����Զ�����
  OldAutoConnect:=AutoConnected.Checked;                //�Զ�����
  OldReConnect:=ReConnected.Checked;                    //������������
//  OldAutoPassword:=RasDialerForm.AutoPassword.Checked;  //�Զ�����
  OldReConnectTime:=ReConnectTime.ItemIndex;            //���Լ��
  OldReConnectNb:=StrToIntDef(ReConnectNb.Text,3);      //���Դ���

  if ShowModal<>mrOk then                               //�������޸���ع�
  begin
    AutoStarted.Checked:=OldAutoStart;                  //�����Զ�����
    AutoConnected.Checked:=OldAutoConnect;              //�Զ�����
    ReConnected.Checked:=OldReConnect;                  //������������
//    RasDialerForm.AutoPassword.Checked:=OldAutoPassword;//�Զ�����
    ReConnectTime.ItemIndex:=OldReConnectTime;          //���Լ��
    ReConnectNb.Text:=IntToStr(OldReConnectNb);         //���Դ���
  end;
end;


//�رմ���
procedure TConfigureAutoForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  inherited;
  if ModalResult<>mrOk then                             //���˷�����
  begin
    if Application.MessageBox('���Ƿ���������޸� ?',
                              'ע��', mb_YESNO+mb_DEFBUTTON2)<>IDYES then
    begin
      canClose:=FALSE;
    end;
  end;
end;

//�Զ����ӱ�־
function TConfigureAutoForm.GetAutoConnect : Boolean;
begin
  Result:=AutoConnected.Checked;
end;

//�޸��Ƿ��Զ����ӱ�־
procedure TConfigureAutoForm.SetAutoConnect(newValue : Boolean);
begin
  AutoConnected.Checked:=newValue;
end;

//�����Զ�������־
function TConfigureAutoForm.GetAutoStart : Boolean;
begin
  Result:=AutoStarted.Checked;
end;

//�޸Ŀ����Զ�������־
procedure TConfigureAutoForm.SetAutoStart(newValue : Boolean);
begin
  AutoStarted.Checked:=newValue;
end;

//�����Զ����ӱ�־
function TConfigureAutoForm.GetReConnect : Boolean;
begin
  Result:=ReConnected.Checked;
end;

//�޸Ķ����Զ����ӱ�־
procedure TConfigureAutoForm.SetReConnect(newValue : Boolean);
begin
  ReConnected.Checked:=newValue;
end;

//ȡ������
procedure TConfigureAutoForm.CancelButtonClick(Sender: TObject);
begin
  inherited;
  ModalResult:=mrCancel;
end;

//ȷ������
procedure TConfigureAutoForm.OkButtonClick(Sender: TObject);
var
  s,ss:string;
  Reg:TRegistry;                                        //���ȶ���һ��TRegistry���͵ı���Reg
begin
  inherited;

  s:='PPPOE Dialed';                                    //���ڼ�¼�û�Ҫ��ӵ���ֵ����
  ss:=sPath+'RASDIAL.exe';                              //���ڼ�¼��ֵ����(�������������·��)
  ss:=application.ExeName;
  if AutoStarted.Checked then                           //�����Զ�����
  begin
//    ����
//    Reg:=TRegistry.Create;                              //����һ���¼�
//    Reg.RootKey:=HKEY_LOCAL_MACHINE;                    //����������ΪHKEY_LOCAL_MACHINE
//    Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run',true); //��һ����
//    Reg.WriteString(s,ss);                              //��Reg�������д���������ƺ�������ֵ
//    Reg.CloseKey;                                       //�رռ�
//    Reg.Free;

    //���ע�����
    SetRegValue(HKEY_LOCAL_MACHINE,'Software\Microsoft\Windows\CurrentVersion\Run',s,ss);
  end
  else
  begin
//    �����ã�ɾ��ָ�����
//    Reg:=TRegistry.Create;                              //����һ���¼�
//    Reg.RootKey:=HKEY_LOCAL_MACHINE;                    //����������ΪHKEY_LOCAL_MACHINE
//    Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run',true); //��һ����
//    Reg.DeleteKey(s);                                   //��Reg�������ɾ���������ƺ�������ֵ
//    Reg.CloseKey;                                       //�رռ�
//    Reg.Free;

    //ɾ��ע�����
    SetDelValue(HKEY_LOCAL_MACHINE,'Software\Microsoft\Windows\CurrentVersion\Run',s);
  end;

  ModalResult:=mrOk;
end;

//�����ⲿ����
procedure TConfigureAutoForm.ExecuteProg(Exe, Dir : String);
var
  ExeName:String;
  Params:String;
  I:Integer;
  Status:Integer;
  Msg:String;
begin
  if Exe[1]='"' then
  begin
    I:=2;
    while (I<=Length(Exe)) and (Exe[I]<>'"') do
    begin
      Inc(I);
    end;
    Params:=Trim(Copy(Exe, I+1, Length(Exe)));
    ExeName:=Trim(Copy(Exe, 2, I-2));
  end
  else
  begin
    I:=1;
    while (I<=Length(Exe)) and not (Exe[I] in ['/','*','?','"','<','>','|']) do
    begin
      Inc(I);
    end;
    Params:=Trim(Copy(Exe, I, Length(Exe)));
    ExeName:=Trim(Copy(Exe, 1, I-1));
  end;

  Status:=ShellExecute(Handle, 'open', PChar(ExeName), PChar(Params), PChar(Dir), SW_SHOWNORMAL);
  if Status>32 then
  begin
    Exit;
  end;

  case Status of
    0                      :Msg:='The operating system is out of memory '
                                +'or resources.';
    ERROR_FILE_NOT_FOUND   :Msg:='The specified file was not found.';
    ERROR_PATH_NOT_FOUND   :Msg:='The specified path was not found.';
    ERROR_BAD_FORMAT	     :Msg:='The .EXE file is invalid (non-Win32 '
                                +'.EXE or error in .EXE image).';
    SE_ERR_ACCESSDENIED	   :Msg:='The operating system denied access to '
                                +'the specified file.';
    SE_ERR_ASSOCINCOMPLETE :Msg:='The filename association is incomplete '
                                +'or invalid.';
    SE_ERR_DDEBUSY	       :Msg:='The DDE transaction could not be '
                                +'completed because other DDE '
                                +'transactions were being processed.';
    SE_ERR_DDEFAIL	       :Msg:='The DDE transaction failed.';
    SE_ERR_DDETIMEOUT	     :Msg:='The DDE transaction could not be '
                                +'completed because the request timed out.';
    SE_ERR_DLLNOTFOUND	   :Msg:='The specified dynamic-link library was '
                                +'not found.';
    SE_ERR_NOASSOC	       :Msg:='There is no application associated with '
                                +'the given filename extension.';
    SE_ERR_OOM	           :Msg:='There was not enough memory to complete '
                                +'the operation.';
    SE_ERR_SHARE	         :Msg:='A sharing violation occurred.';
    else
                            Msg:='ShellExecute failed with error #'+IntToStr(Status);
  end;
  MessageBeep(MB_OK);
  Msg:=Msg+#10+'trying to execute '''+Exe+'''';
  Application.MessageBox(PChar(Msg), 'Warning', MB_OK);
end;

//���ע������
function TConfigureAutoForm.SetRegValue(key:Hkey; subkey,name,value:string):boolean;
var
  regkey:hkey;
begin
  result:=false;
  RegCreateKey(key,PChar(subkey),regkey);
  if RegSetValueEx(regkey,Pchar(name),0,REG_EXPAND_SZ,pchar(value),length(value))=0 then
  begin
    result:=true;
  end;
  RegCloseKey(regkey);
end;

//ɾ��ע�����
procedure TConfigureAutoForm.SetDelValue(ROOT: hKey; Path, Value: string);
var
  Key:hKey;
begin
  RegOpenKeyEx(ROOT, pChar(Path), 0, KEY_ALL_ACCESS, Key);
  RegDeleteValue(Key, pChar(Value));
  RegCloseKey(Key);
end;

procedure TConfigureAutoForm.FormCreate(Sender: TObject);
begin
  inherited;
  ReConnectTime.ItemIndex:=2;                           //��������ʱ��
  ReConnectNb.Text:='1';                                //�������Ӵ���
end;

end.

