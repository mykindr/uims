unit Unit1;
//download by http://www.codefans.net
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, OleCtrls, SHDocVw, Buttons;

type
  TForm1 = class(TForm)
    WebBrowser1: TWebBrowser;
    ComboBox1: TComboBox;
    Label1: TLabel;
    BitBtn1: TBitBtn;


    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}



procedure TForm1.BitBtn1Click(Sender: TObject);
begin
     WebBrowser1.Navigate(combobox1.text);
end;

end.
