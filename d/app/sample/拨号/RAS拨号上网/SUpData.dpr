program SUpData;

uses
  Forms,
  UpTemp in 'UpTemp.pas' {UpTempForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '��ͨ�����ֹ�˾������������';
  Application.CreateForm(TUpTempForm, UpTempForm);
  Application.Run;
end.
