//**********************************
//Դ�����ƣ�QQ��ϢȺ������(����QQ������Э��)
//����������Delphi7.0+WinXP
//Դ�����ߣ�Դ�����
//�ٷ���վ��http://www.codesky.net
//�ر��л��΢�� �ṩQQЭ�����
//������ԭ���ߵ��Ͷ�������������޸�Դ�룬���뱣��������Ϣ�������ԡ�
// **********************************
program SuperQQMsg;

uses
  Forms,
  Unit1 in 'Unit1.pas' {frmMain},
  UnitMD5 in 'UnitMD5.pas',
  UnitSkipQQ in 'UnitSkipQQ.pas' {frmSetSkipQQ},
  UnitAbout in 'UnitAbout.pas' {frmAbout};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmSetSkipQQ, frmSetSkipQQ);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.Run;
end.
