program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Frm_main};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '�Զ�����';
  Application.CreateForm(TFrm_main, Frm_main);
  Application.Run;
end.
