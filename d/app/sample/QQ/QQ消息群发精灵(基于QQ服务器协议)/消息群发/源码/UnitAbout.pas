//**********************************
//Դ�����ƣ�QQ��ϢȺ������(����QQ������Э��)
//����������Delphi7.0+WinXP
//Դ�����ߣ�Դ�����
//�ٷ���վ��http://www.codesky.net
//�ر��л��΢�� �ṩQQЭ�����
//������ԭ���ߵ��Ͷ�������������޸�Դ�룬���뱣��������Ϣ�������ԡ�
// **********************************
unit UnitAbout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TfrmAbout = class(TForm)
    btnOK: TBitBtn;
    Label1: TLabel;
    Memo1: TMemo;
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.dfm}

procedure TfrmAbout.btnOKClick(Sender: TObject);
begin
self.Close;
end;

end.
