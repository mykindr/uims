program QQHMXS;

uses
  Forms,
  QHMSX in 'QHMSX.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'QQ����ɸѡ����';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
