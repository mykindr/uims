{------------------------P-Mail 0.5 beta��-----------------
��̹��ߣ�Delphi 6 + D6_upd2 
������������ɫ PLQ������
�����������봿����ѣ�����ѧϰʹ�ã�ϣ������ʹ����ʱ������λ�
������Ա��������˸Ľ���Ҳϣ������������ϵ
My E-Mail:plq163001@163.com
	  plq163003@163.com
-----------------------------------------------------2002.5.19}

unit about;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TfmAbout = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    SpeedButton1: TSpeedButton;
    Label5: TLabel;
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmAbout: TfmAbout;

implementation

{$R *.dfm}

procedure TfmAbout.SpeedButton1Click(Sender: TObject);
begin
        close;
end;

end.
