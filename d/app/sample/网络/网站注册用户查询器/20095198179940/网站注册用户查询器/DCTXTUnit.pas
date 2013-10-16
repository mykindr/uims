unit DCTXTUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, Buttons, RzBckgnd, StdCtrls, RzLabel, pngimage,
  ExtCtrls, RzPanel;

type
  TDCTXTForm = class(TForm)
    RzPanel1: TRzPanel;
    Image6: TImage;
    lblts: TRzLabel;
    RzSeparator6: TRzSeparator;
    sbtnDRETXT: TSpeedButton;
    DBGrid1: TDBGrid;
    procedure sbtnDRETXTClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DCTXTForm: TDCTXTForm;

implementation

uses dmUnit;

{$R *.dfm}

procedure TDCTXTForm.sbtnDRETXTClick(Sender: TObject);
var
 txt:tstrings;
 i:integer;
 x:string;
begin
//��ʼ������ť
try
  begin
    txt:=tstringlist.Create;
      with dm.ADOEXCELTable do
        begin
          while not eof do
            begin
              x:='';
              for i:=0 to fieldcount-1 do
                x:=x+fields[i].AsString+#39;
                txt.Add(x);
              next;
            end;
        end;
        txt.SaveToFile(trim(ExtractFilePath(Application.ExeName))+'\��վע���û���ѯ��.txt');
        application.MessageBox(pchar('�����ɹ�!'+#13+ExtractFilePath(Application.ExeName)+'��վע���û���ѯ��.txt'),'��վע���û���ѯ��',mb_ok+mb_iconinformation);
  end;
except
  begin

  end;
end;
end;

end.
