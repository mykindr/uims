unit Unit8;
{����BLOG ALALMN JACK     http://hi.baidu.com/alalmn  
Զ�̿��ƺ�ľ���дȺ30096995   }
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, jpeg,shellapi;

type
  TALALMN = class(TForm)
    Image1: TImage;
    procedure Image1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ALALMN: TALALMN;

implementation

{$R *.dfm}

procedure TALALMN.Image1Click(Sender: TObject);
begin
close;
   ShellExecute(0,nil,PChar('http://hi.baidu.com/alalmn'), nil, nil, SW_NORMAL);
end;

end.
