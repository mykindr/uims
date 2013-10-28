unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, DB, DBTables, Grids, DBGrids,ComObj;

type
  TMainForm = class(TForm)
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Table1: TTable;
    BitBtnSave: TBitBtn;
    BitBtnClose: TBitBtn;
    CheckBox1: TCheckBox;
    procedure BitBtnSaveClick(Sender: TObject);
    procedure BitBtnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  v:variant;

implementation

{$R *.dfm}

procedure TMainForm.BitBtnSaveClick(Sender: TObject);
var
  s:string;
  i,j:integer;
begin
  s:='f:\zfhd\example.xls'; //�ļ���
  if fileexists(s) then deletefile(s);
  v:=CreateOLEObject('Excel.Application'); //����OLE����
  V.WorkBooks.Add;
  if Checkbox1.Checked then
    begin
      V.Visible:=True;
      MainForm.WindowState:=wsMinimized;
      //ʹExcel�ɼ���������������С�����Թ۲�Excel���������
    end
  else
    begin
      V.Visible:=False;
    end;
    //ʹExcel���ڲ��ɼ�
    Application.BringToFront; //����ǰ��
  try
  try
    Cursor:=crSQLWait;
    Table1.DisableControls;
    For i:=0 to Table1.FieldCount-1 do //�ֶ���
    //ע�⣺Delphi�е�������±��Ǵ�0��ʼ�ģ�
    // ��Excel�ı���Ǵ�1��ʼ���
      begin
      V.Goto('R1'+'C'+IntToStr(i+1)); //Excel�ı���Ǵ�1��ʼ���
      V.ActiveCell.FormulaR1C1:=Table1.Fields[i].FieldName;//�����ֶ���
      end;
    j:=2;
    Table1.First;
    while not Table1.EOF do
      begin
      For i:=0 to Table1.FieldCount-1 do //�ֶ���
        begin
          V.Goto('R'+IntToStr(j)+'C'+IntToStr(i+1));
          V.ActiveCell.FormulaR1C1:=Table1.Fields[i].AsString;//��������
        end;
      Table1.Next;
      j:=j+1;
     end;
    V.ActiveSheet.Protect(DrawingObjects:=True,Contents:=True,Scenarios:=True);//���ñ���
    ShowMessage('���ݿ⵽Excel�����ݴ������!');
    v.ActiveWorkBook.Saveas(filename:=s);//�ļ�����
    except //��������ʱ
    ShowMessage('û�з���Excel!');
    end;
    finally
    Cursor:=crDefault;
    Table1.First;
    Table1.EnableControls;
    end;
    end;
procedure TMainForm.BitBtnCloseClick(Sender: TObject);
begin
v.quit; //�˳�OLE����
MainForm.WindowState:=wsNormal;
end;
//Download by http://www.codefans.net
procedure TMainForm.FormShow(Sender: TObject);
begin
Table1.Open;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Table1.Close;
end;

end.
