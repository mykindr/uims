program Clock;

uses
  Forms,
  UnitMainForm in 'UnitMainForm.pas' {frmMainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'ʱ��';
  Application.CreateForm(TfrmMainForm, frmMainForm);
  Application.Run;
end.
