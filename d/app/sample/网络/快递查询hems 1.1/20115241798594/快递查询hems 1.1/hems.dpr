program hems;

uses
  Forms,
  main in 'main.pas' {fMain};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '��ݲ�ѯϵͳ 1.0 by hpping';
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
