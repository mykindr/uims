program CClient;

uses
  Forms,
  CC_main in 'CC_main.pas' {frmmain},
  CC_Types in 'CC_Types.pas',
  CC_Const in 'CC_Const.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'ͨѶ����-�ͻ���';
  Application.CreateForm(Tfrmmain, frmmain);
  Application.Run;
end.
