program proBBS;

uses
  Forms,
  untBBS in 'untBBS.pas' {frmBBS},
  untMod in 'untMod.pas',
  untBBSThread in 'untBBSThread.pas';

{$R *.res}
begin
  Application.Initialize;
  Application.Title := '��ɽ�۵���ˮ��';
  Application.CreateForm(TfrmBBS, frmBBS);
  Application.Run;
end.
