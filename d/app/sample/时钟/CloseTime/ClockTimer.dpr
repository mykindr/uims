program ClockTimer;

uses
  Forms,
  UnitMain in 'UnitMain.pas' {FormMain},
  UnitAlert in 'UnitAlert.pas' {FormAlert},
  UnitSet in 'UnitSet.pas' {FormSet};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '��ʱ����';
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormAlert, FormAlert);
  Application.CreateForm(TFormSet, FormSet);
  Application.Run;
end.
