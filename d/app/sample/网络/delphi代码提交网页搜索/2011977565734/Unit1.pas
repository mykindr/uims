unit Unit1;
{* |<PRE>
================================================================================
* ������ƣ�delphi����ֱ�ӿ��ưٶȡ��ȸ���ҳ����
* ��Ԫ���ƣ�
* ��������
* ��������
* uses������Ԫ��
* ���ߣ�    lah998 (lah02000@yahoo.com.cn)
* ����Ŀ�ģ�
* ʵ��ԭ��
* ����ʱ�䣺2009-09-19
* ����ƽ̨��Microsoft Wiondows XP Pro Service Pack 3 + Delphi 7
* ���ݲ��ԣ�Win2K
* �޸ļ�¼��
* �ӿ�˵����
* �������˵����
* ��    ע�� �򵥾�����
================================================================================
|</PRE>}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, OleCtrls, SHDocVw,MSHTML;

type
  TForm1 = class(TForm)
    WebBrowser1: TWebBrowser;
    GroupBox1: TGroupBox;
    Button2: TButton;
    Button1: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
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
//user MSHTML, SHDOCVW, IdGlobal
var
  Form: IHTMLFormElement;
  Doc: IHTMLDocument2;
  GJCinputStr: IHTMLInputElement;
begin
  //webbrowser1.Navigate(Edit1.Text);
  webbrowser1.Navigate('http://www.baidu.com');
  repeat
    Application.ProcessMessages;
  until (not webbrowser1.Busy);
  //��ҳû�д�����ͣ,��ҳ����ִ���������
  Doc := webbrowser1.document as IHTMLDocument2;
  GJCinputStr := (Doc.all.item('wd', 0) as IHTMLInputElement);
  GJCinputStr.value := Edit1.Text; //����ٶȹؼ���
  Form := (doc.all.item('f', 0) as ihtmlformelement);
  Form.submit;
end;


procedure TForm1.Button2Click(Sender: TObject);
var
  Doc: IHTMLDocument2;
  input: OleVariant;
  GJCinputStr: IHTMLInputElement;
begin
  //webbrowser1.Navigate(Edit1.Text);
  webbrowser1.Navigate('http://www.google.cn');
  repeat
    Application.ProcessMessages;
  until (not webbrowser1.Busy);
  //��ҳû�д�����ͣ,��ҳ����ִ���������
  Doc := webbrowser1.document as IHTMLDocument2;
  GJCinputStr := (Doc.all.item('q', 0) as IHTMLInputElement);
  GJCinputStr.value :=Edit1.Text; //����google�ؼ���
  input := Doc.all.item('btnG', 0); 
  input.click;
end;


end.
