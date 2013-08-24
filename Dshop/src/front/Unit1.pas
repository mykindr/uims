unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, RzForms, INIFiles, DB,
  ADODB, Buttons, Registry;

type
  TPass = class(TForm)
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Panel1: TPanel;
    ADOQuery1: TADOQuery;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure Edit1KeyPress(Sender: TObject; var Key:
      Char);
    procedure Edit2KeyPress(Sender: TObject; var Key:
      Char);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    authret: Boolean;
    mid: string;
    uid: string;
    { Public declarations }
  end;

var
  Pass: TPass;

implementation

uses MD5, Unit2, Unit3, Unit15;

{$R *.dfm}
type
  TCPUID = array[1..4] of Longint;

function GetCPUID: TCPUID; assembler; register;
asm
  PUSH    EBX         //Save affected register
  PUSH    EDI
  MOV     EDI,EAX     //@Resukt
  MOV     EAX,1
  DW      $A20F       //CPUID Command
  STOSD               //CPUID[1]
  MOV     EAX,EBX
  STOSD               //CPUID[2]
  MOV     EAX,ECX
  STOSD               //CPUID[3]
  MOV     EAX,EDX
  STOSD               //CPUID[4]
  POP     EDI         //Restore registers
  POP     EBX
end;

{���ݵ�¼����ȡ�û���}

procedure TPass.Edit1KeyPress(Sender: TObject; var Key:
  Char);
begin
  if key = #13 then
  begin
    key := #0;
    ADOQuery1.Close;
    ADOQuery1.SQL.Clear;
    ADOQuery1.SQL.Add('Select * from users Where uid="' +
      Edit1.Text + '"');
    try
      ADOQuery1.Open;
    except
      Abort;
    end;
    if ADOQuery1.RecordCount <> 0 then
    begin

      uid := Edit1.Text;
      Edit1.Text :=
        ADOQuery1.FieldByName('uname').AsString;
    end;

    Edit2.SetFocus;
  end;
end;

procedure TPass.Edit2KeyPress(Sender: TObject; var Key:
  Char);
begin
  if key = #13 then
  begin
    SpeedButton1.Click;
  end;
end;

{��֤�û����Ϳ���}

procedure TPass.SpeedButton1Click(Sender: TObject);
begin
  {
  vIniFile:=TIniFile.Create(ExtractFilePath(ParamStr(0))+'Config.Ini');
  Reg:=TRegistry.Create;
  Reg.RootKey:=HKEY_CURRENT_USER;
  Reg.OpenKey('Software\WL',True);
  if Key(vIniFile.Readstring('System','PCID',''))<>vIniFile.Readstring('System','Key','') then
  begin
    if StrToDate(FormatdateTime('yyyy-mm-dd', Now))-StrToDate(Reg.ReadString('Date'))>45 then
    begin
      //��ע�ᴰ��
      RegKey:=TRegKey.Create(Application);
      RegKey.showmodal;
      Application.Terminate;
    end;
  end;
  }

  //���û����Ƿ���Ȩ
  //�״�ʹ��ʱ��resultΪδ��Ȩ
  //Ҫ���û�����Ϸ�����Ȩ���Ի���������Ȩ������resultΪ����Ȩ
  //�Ϸ�����Ȩ������cdkey��ͬ��mid����GetCPUID
  mid := Inttostr(GetCPUID()[1]) + Inttostr(GetCPUID()[2]) +
    Inttostr(GetCPUID()[3]);

  ADOQuery1.Close;
  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add('select * from mauths where mid="' + mid + '"');
  ADOQuery1.Open;
  if (ADOQuery1.RecordCount = 0) or (ADOQuery1.FieldByName('result').AsString =
    'δ��Ȩ') then
  begin

    if CDKEY <> nil then
      CDKEY.ShowModal
    else
    begin
      CDKEY := TCDKEY.Create(Application);
      CDKEY.ShowModal;
    end;

    if not (authret) then
    begin
      showmessage('δ����Ȩ�Ļ���������ϵ����Ա~~!');
      Pass.Close;
      Exit;
    end;

  end;

  ADOQuery1.Close;
  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add('select * from users Where uid="' +
    uid + '"');
  ADOQuery1.Open;
  if (ADOQuery1.FieldByName('userpass').AsString =
    MD5.MD5Print(MD5.MD5String(Edit2.Text))) and
    (ADOQuery1.RecordCount <> 0) then
  begin
    Main.Show;
    Main.Caption := Edit1.Text;
    Main.uid := uid;
    //�������Ա����
    Main.Label19.Caption := Main.Caption;
    //����Ǽ�ʱ��
    //Main.Label21.Caption := FormatDateTime('tt', Now);
    Main.GetLoginTime;
    Pass.Hide;
  end
  else
  begin
    showmessage('�û����������������������~~!');
    Edit2.Text := '';
    Edit2.SetFocus;
  end;
end;

procedure TPass.SpeedButton2Click(Sender: TObject);
begin
  Pass.Close;
end;

procedure TPass.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE: SpeedButton2.Click;
  end;
end;

{��¼��֤ҳ��}

procedure TPass.FormCreate(Sender: TObject);
var
  vIniFile: TIniFile;
  ds: string;
begin
  {������������}
  //����INI�ļ�����
  vIniFile := TIniFile.Create(ExtractFilePath(ParamStr(0))
    +
    'Config.Ini');
  ds := vIniFile.Readstring('System', 'Data Source',
    'shop');
  //д����ID��
  //PCID;
  //�������ݿ�
  {
  Data:='Provider='+vIniFile.Readstring('System','Provider','')+';';
  Data:=Data+'Data Source='+vIniFile.Readstring('System','Data Source','')+';';
  Data:=Data+'Persist Security Info=False';
  ADOQuery1.ConnectionString:=Data;
  }
  ADOQuery1.ConnectionString := 'Provider=MSDASQL.1;' +
    'Persist Security Info=False;' +
    'User ID=root;' +
    'Password=zaqwsxcde123;' +
    'Data Source=' + ds; //shop';

  {��ѯϵͳ�û�}
  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add('Select * from users');
  ADOQuery1.Active := True;
  {
  //ע�����д��ǰ����
  Reg:=TRegistry.Create;
  Reg.RootKey:=HKEY_CURRENT_USER;
  Reg.OpenKey('Software\WL',True);
  Try
  begin
    if Reg.ReadString('Date')='' then
    begin
      //
      if messagedlg('ȷ�ϳ�ʼ����������ۡ�����¼~~!',mtconfirmation,[mbyes,mbno],0)=mryes then
      begin
        ADOQuery1.SQL.Clear;
        ADOQuery1.SQL.Add('Delete from sell_main');
        ADOQuery1.ExecSQL;

        ADOQuery1.SQL.Clear;
        ADOQuery1.SQL.Add('Delete from sell_minor');
        ADOQuery1.ExecSQL;

        ADOQuery1.SQL.Clear;
        ADOQuery1.SQL.Add('Select * from stock');
        ADOQuery1.ExecSQL;

        Reg.WriteString('Date',FormatdateTime('yyyy-mm-dd', Now));
      end
      else
      begin
        Application.Terminate;
      end;
    end;
  end;
  Except
    Abort;
  end;

  if Key(vIniFile.Readstring('System','PCID',''))<>vIniFile.Readstring('System','Key','') then
  begin
    //�ж�ע��������Ƿ��иĶ�
    if StrToDate(FormatdateTime('yyyy-mm-dd', Now))-StrToDate(Reg.ReadString('Date'))<0 then
    begin
      //��ע�ᴰ��
      RegKey:=TRegKey.Create(Application);
      RegKey.showmodal;
      Application.Terminate;
    end;
    //�ж������Ƿ���
    if StrToDate(FormatdateTime('yyyy-mm-dd', Now))-StrToDate(Reg.ReadString('Date'))>45 then
    begin
      //��ע�ᴰ��
      RegKey:=TRegKey.Create(Application);
      RegKey.showmodal;
      Application.Terminate;
    end;
  end;

  sample e.g.
  ------------------------------------------------------------------------------
  try
    ADOConnectionDM.ADOConnection2.BeginTrans;
    adoq.SQL.Add('select * from tabbar');
    adoq.open;
    c1:='0';
    while not adoq.Eof do
    begin
        adoq1.SQL.Add('insert into dbo.tabbar(barcode,scantime,userid,lip) values ('''+adoq.Fields[0].AsString+''','''+adoq.Fields[1].AsString+''','''+adoq.Fields[2].AsString+''','''+adoq.Fields[3].AsString+''')');
        adoq.Next;
        c1:='1';
    end;
    adoq1.ExecSQL;
    adoq.Close;
    adoq.SQL.Clear;
    adoq.SQL.Add('delete from tabbar');
    adoq.ExecSQL;
    b1:=true;
    ADOConnectionDM.ADOConnection2.CommitTrans;
    except
      ADOConnectionDM.ADOConnection2.RollbackTrans;
      b1:=false;
    end;

  }
end;

end.

