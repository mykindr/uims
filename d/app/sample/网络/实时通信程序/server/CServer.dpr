program CServer;

uses
  Forms,
  windows,
  CSrv_main in 'CSrv_main.pas' {frmmain},
  CSrv_const in 'CSrv_const.pas',
  CSrv_Setup in 'CSrv_Setup.pas' {frmSetup};

{$R *.res}
  var
     h: THandle;
begin
  Application.Initialize;
  if FindWindow('Tfrmmain', 'ͨ�ŷ�����') <> 0 then
  begin
    Application.Terminate;
    Exit;
  end;
  Application.Title := 'ͨѶ����-��������';
  Application.CreateForm(Tfrmmain, frmmain);
  Application.Run;
end.
