unit IWUnit1;
{PUBDIST}

interface

uses
  IWAppForm, IWApplication, IWTypes, IWCompLabel, DB, DBClient,
  IWCompListbox, IWDBStdCtrls, IWCompButton, IWCompEdit, Classes, Controls,
  IWControl, IWGrids, IWDBGrids,
  types,Variants, InvokeRegistry, Rio, SOAPHTTPClient, DBTables,
  IWClientSideDatasetBase, IWClientSideDatasetDBLink, IWDynGrid,
  IWCompCheckbox;

type
  TformMain = class(TIWAppForm)
    IWDBGrid1: TIWDBGrid;
    edtQryByName: TIWEdit;
    btnQryByName: TIWButton;
    IWDBEdit1: TIWDBEdit;
    IWDBEdit2: TIWDBEdit;
    IWDBComboBox1: TIWDBComboBox;
    IWDBEdit3: TIWDBEdit;
    IWDBEdit4: TIWDBEdit;
    dbcbDep: TIWDBComboBox;
    btnUpdate: TIWButton;
    btnExit: TIWButton;
    DataSource1: TDataSource;
    IWLabel1: TIWLabel;
    IWLabel2: TIWLabel;
    IWLabel3: TIWLabel;
    IWLabel4: TIWLabel;
    IWLabel5: TIWLabel;
    IWLabel6: TIWLabel;
    HTTPRIO1: THTTPRIO;
    cdsUserMaint: TClientDataSet;
    IWCheckBox1: TIWCheckBox;
    procedure btnQryByNameClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWDBGrid1Columns0Click(ASender: TObject;
      const AValue: String);
    procedure btnExitClick(Sender: TObject);
    procedure IWCheckBox1Click(Sender: TObject);
  end;

implementation
{$R *.dfm}

uses
  ServerController, uIUserService;

procedure TformMain.btnQryByNameClick(Sender: TObject);
var
  IUser:IUserService;
begin
  IUser:=(HTTPRIO1 as IUserService);
  cdsUserMaint.Active:=false;
  cdsUserMaint.XMLData:=IUser.GetUserList(edtQryByName.Text);
  cdsUserMaint.Active:=True;
  IUser:=nil;
  btnUpdate.Enabled:=true;
end;

procedure TformMain.btnUpdateClick(Sender: TObject);
var
  IUser:IUserService;
begin
  IUser:=(HTTPRIO1 as IUserService);
  if IUser.UpdateUserData(cdsUserMaint.XMLData)=0 then
    WebApplication.ShowMessage('���³ɹ���',smAlert,'������ʾ')
  else
    WebApplication.ShowMessage('����ʧ�ܣ�',smAlert,'������ʾ');
  IUser:=nil;
  btnQryByNameClick(nil);
end;

procedure TformMain.IWAppFormCreate(Sender: TObject);
var
  IUser:IUserService;
  i,count:integer;
  aDeps:TStringDynArray;
begin
  count:=0;
  IUser:=(HTTPRIO1 as IUserService);
  aDeps:=IUser.GetDepList(count);
  for  i:=0  to count-1 do
    dbcbDep.Items.Add(aDeps[i]);
end;

procedure TformMain.IWDBGrid1Columns0Click(ASender: TObject;
  const AValue: String);
begin
  cdsUserMaint.Locate('ID',AValue,[]);
end;

procedure TformMain.btnExitClick(Sender: TObject);
begin
  WebApplication.Terminate('��лʹ�ã��ټ���');
end;

procedure TformMain.IWCheckBox1Click(Sender: TObject);
begin
  if IWCheckBox1.Checked then
    self.Background.URL:='http://ly/ws/B003.jpg'
  else  self.Background.URL:='';
end;

end.
