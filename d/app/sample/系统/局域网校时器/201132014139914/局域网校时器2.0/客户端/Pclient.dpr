program Pclient;

uses
  Forms,
  Umain in 'Umain.pas' {Form1},
  Utip in 'Utip.pas' {tip};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Уʱ�ͻ���';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(Ttip, tip);
  Application.Run;
end.
