program AntiMm;

uses
  Forms,
  Unit1 in 'Unit1.pas' {MForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '��ҳľ������';
  Application.CreateForm(TMForm, MForm);
  Application.Run;
end.
