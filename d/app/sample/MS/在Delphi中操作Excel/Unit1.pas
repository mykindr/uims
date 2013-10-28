unit Unit1;
//Download by http://www.codefans.net
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComObj, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  eclApp, WorkBook: Variant;
  //����ΪOLE Automation ����
  xlsFileName: String;
begin
    xlsFileName:='myexcel.xls';
    try
    //����OLE����Excel Application�� WorkBook
      eclApp := CreateOleObject('Excel.Application');
      WorkBook := CreateOleobject('Excel.Sheet');
    except
      ShowMessage('���Ļ�����δ��װMicrosoft Excel��');
      Exit;
    end;
    try
      ShowMessage('������ʾ:�½�һ��XLS�ļ�,��д������,���ر�����');
      workBook := eclApp.workBooks.Add;
      eclApp.Cells(1 , 1) := '�ַ���';
      eclApp.Cells(2 , 1) := 'Excel�ļ�';
      eclApp.Cells(1 , 2) := 'Money��';
      eclApp.Cells(2 , 2) := 10.01;
      eclApp.Cells(1 , 3) := '������';
      eclApp.Cells(2 , 3) := Date;
      WorkBook.SaveAs(xlsFileName);
      WorkBook.Close;
      ShowMessage('������ʾ:�򿪸մ�����XLS�ļ�,���޸����е�����,Ȼ��,���û������Ƿ񱣴档');
      WorkBook := eclApp.workBooks.Open(xlsFileName);
      eclApp.Cells(2 , 1):='Excel�ļ�����';
      if MessageDlg(xlsFileName+'�ļ��ѱ��޸�,�Ƿ񱣴�?',mtConfirmation, [mbYes, mbNo], 0) = mrYes then
         WorkBook.Save
      else
         workBook.Saved := True; //�����޸�

      WorkBook.Close;
      eclApp.Quit;
      //�˳�Excel Application
      //�ͷ�VARIANT����
      eclApp := Unassigned;

      ShowMessage('��ʾ��ϣ�');
    except
      ShowMessage('������ȷ����Excel�ļ��������Ǹ��ļ��ѱ����������, ��ϵͳ����');
      WorkBook.Close;
      eclApp.Quit;
      //�ͷ�VARIANT����
      eclApp:=Unassigned;
    end;
end;

end.
