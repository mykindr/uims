unit Option;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, EditNew, DrLabel, ExtDlgs, Buttons;

type
  TfrmOption = class(TForm)
    gbInterFace: TGroupBox;
    edtBackGround: TEditN;
    edtSplashPath: TEditN;
    cbbImeName: TComboBox;
    DRLabel1: TDRLabel;
    DRLabel2: TDRLabel;
    DRLabel3: TDRLabel;
    btnSplashPath: TButton;
    btnBackGroud: TButton;
    OpenPictureDialog: TOpenPictureDialog;
    bbtnOK: TBitBtn;
    bbtnCancel: TBitBtn;
    procedure btnBackGroudClick(Sender: TObject);
    procedure btnSplashPathClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bbtnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmOption: TfrmOption;

implementation

uses Global;

{$R *.DFM}

procedure TfrmOption.btnBackGroudClick(Sender: TObject);
begin
//ȡ���������汳��
  OpenPictureDialog.DefaultExt := GraphicExtension(TBitmap);
  if edtBackGround.Text<>'' then
    OpenPictureDialog.InitialDir:=ExtractFilePath(edtBackGround.Text);
  if OpenPictureDialog.Execute then
    edtBackGround.Text := OpenPictureDialog.FileName;
end;

procedure TfrmOption.btnSplashPathClick(Sender: TObject);
begin
//ȡ��������ʱ����
  OpenPictureDialog.DefaultExt := GraphicExtension(TBitmap);
  if edtSplashPath.Text<>'' then
    OpenPictureDialog.InitialDir:=ExtractFilePath(edtSplashPath.Text);
  if OpenPictureDialog.Execute then
    edtSplashPath.Text := OpenPictureDialog.FileName;
end;

procedure TfrmOption.FormCreate(Sender: TObject);
begin
//��ʼ����ѡ��
  cbbImeName.Items := Screen.Imes;
  edtBackGround.Text := IniInfo.BackGround;
  edtSplashPath.Text := IniInfo.SplashPath;
  cbbImeName.ItemIndex := cbbImeName.Items.IndexOf(IniInfo.ImeName);
end;

procedure TfrmOption.bbtnOKClick(Sender: TObject);
begin
//����������
  IniInfo.BackGround := edtBackGround.Text;
  IniInfo.SplashPath := edtSplashPath.Text;
  IniInfo.ImeName := cbbImeName.Text;
  SaveIni;
end;

end.

