program ProjectTest;

uses
  Forms,
  UnitTest in 'UnitTest.pas' {frmMainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'ʱ��������Գ���';
  Application.CreateForm(TfrmMainForm, frmMainForm);
  Application.Run;
end.
