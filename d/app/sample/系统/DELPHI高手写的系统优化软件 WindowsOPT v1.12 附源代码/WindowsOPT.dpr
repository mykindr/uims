program WindowsOPT;

uses
  Forms,
  windows,
  messages,
  dialogs,
  UMain in 'UMain.pas' {FrmMain},
  UMainFunc in 'UMainFunc.pas',
  URunDosThrd in 'URunDosThrd.pas';

const
  CM_RESTORE=WM_USER+$1000;{�Զ����"�ָ�"��Ϣ}
  MYAPPNAME='MyDelphiProgram';
var
  RvHandle:hWnd;

{$R *.res}

begin
  RvHandle:= FindWindow(MYAPPNAME,NIL);
  if RvHandle>0 then
  begin
    ShowMessage('�����Ѿ������У� ');
    PostMessage(RvHandle,CM_RESTORE,0,0);
    Exit;
  end;
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
