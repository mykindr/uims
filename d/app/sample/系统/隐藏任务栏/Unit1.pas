unit Unit1;
//download by http://www.codefans.net
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
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

{$R *.DFM}

procedure hideTaskbar;
var
  wndHandle : THandle;
  wndClass : array[0..50] of Char;
  //char���鱣������������
begin
  StrPCopy(@wndClass[0], 'Shell_TrayWnd');
  wndHandle := FindWindow(@wndClass[0], nil);
  ShowWindow(wndHandle, SW_HIDE); 
//��nCmdShow��ΪSW_HIDE�����ش���
end;

procedure showTaskbar;
var
  wndHandle : THandle;
  wndClass : array[0..50] of Char;
begin
  StrPCopy(@wndClass[0], 'Shell_TrayWnd');
  wndHandle := FindWindow(@wndClass[0], nil);
  ShowWindow(wndHandle, SW_RESTORE); 
//��nCmdShow��ΪSW_RESTORE����ʾ����
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  hideTaskbar;
  //����hideTaskbar��������������
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  showTaskbar;
//����showTaskbar������ʾ������
end;


end.
