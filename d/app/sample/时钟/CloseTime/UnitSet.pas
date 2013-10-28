unit UnitSet;
//Download by http://www.codefans.net
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IniFiles, Registry, ExtCtrls;

type
  TFormSet = class(TForm)
    Button1: TButton;
    Panel1: TPanel;
    SaveBootCB: TCheckBox;
    SaveTimeCB: TCheckBox;
    SaveSkinCB: TCheckBox;
    SaveExecCB: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSet: TFormSet;
  FileName: String;

implementation

uses UnitMain;

{$R *.dfm}

procedure SetStart;
var
  Reg: TRegistry;
begin
  Reg:= TRegistry.Create;
  try
    Reg.RootKey:= HKEY_CURRENT_USER;
    if Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run',True) then
    begin
      Reg.WriteString(Application.Title, ParamStr(0));
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

procedure CloStart;
var
  Reg: TRegistry;
begin
  Reg:= TRegistry.Create;
  try
    Reg.RootKey:= HKEY_CURRENT_USER;
    if Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run\',True) then
    begin
      Reg.DeleteValue(Application.Title);
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

procedure TFormSet.Button1Click(Sender: TObject);
begin
  FileName:= ExtractFilePath(ParamStr(0))+Ini;
  UnitMain.MyIni:= TIniFile.Create(FileName);
  if SaveTimeCB.Checked then
  begin
    UnitMain.MyIni.Writebool('ϵͳ����','���涨ʱ����',True);
    UnitMain.MyIni.WriteInteger('��ʱ����','ʱ',FormMain.HnSE.Value);
    UnitMain.MyIni.WriteInteger('��ʱ����','��',FormMain.MnSE.Value);
    UnitMain.MyIni.WriteInteger('��ʱ����','��',FormMain.SnSE.Value);
    UnitMain.MyIni.WriteInteger('��ʱ����','��ʱ��ʽ',FormMain.TimeWayRG.ItemIndex);
    UnitMain.MyIni.WriteBool('��ʱ����','�ػ�����',FormMain.AlertCB.Checked);
  end
  else
  begin
    UnitMain.MyIni.Writebool('ϵͳ����','���涨ʱ����',False);
    UnitMain.MyIni.WriteInteger('��ʱ����','ʱ',0);
    UnitMain.MyIni.WriteInteger('��ʱ����','��',0);
    UnitMain.MyIni.WriteInteger('��ʱ����','��',30);
    UnitMain.MyIni.WriteInteger('��ʱ����','��ʱ��ʽ',0);
    UnitMain.MyIni.WriteBool('��ʱ����','�ػ�����',FormMain.AlertCB.Checked);
  end;
  if SaveSkinCB.Checked then
  begin
    UnitMain.MyIni.WriteBool('Ƥ������','����Ƥ��',True);
  end
  else
  begin
    UnitMain.MyIni.WriteBool('Ƥ������','����Ƥ��',False);
  end;
  if SaveBootCB.Checked then
  begin
    UnitMain.MyIni.Writebool('ϵͳ����','��ϵͳ����������',True);
    SetStart;
  end
  else
  begin
    UnitMain.MyIni.Writebool('ϵͳ����','��ϵͳ����������',False);
    CloStart;
  end;
  if SaveExecCB.Checked then
  begin
    UnitMain.MyIni.WriteBool('��������','����ʱִ�ж�ʱ����',True);
  end
  else
  begin
    UnitMain.MyIni.WriteBool('��������','����ʱִ�ж�ʱ����',False);
  end;
  FormSet.Close;
end;

procedure TFormSet.FormCreate(Sender: TObject);
begin
  if FileExists(UnitMain.CurrentDir+'\'+Ini) then
  begin
    SaveTimeCB.Checked:= UnitMain.MyIni.ReadBool('ϵͳ����','���涨ʱ����', False);
    SaveSkinCB.Checked:= UnitMain.MyIni.ReadBool('Ƥ������','����Ƥ��', True);
    SaveBootCB.Checked:= UnitMain.MyIni.ReadBool('ϵͳ����','��ϵͳ����������', False);
    SaveExecCB.Checked:= UnitMain.MyIni.ReadBool('��������','����ʱִ�ж�ʱ����', False);
  end;
end;
end.
