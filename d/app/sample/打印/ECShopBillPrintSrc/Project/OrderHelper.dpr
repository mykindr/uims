program OrderHelper;

uses
  Forms,
  Controls,
  untMain in '..\Source\untMain.pas' {frmMain},
  untLogin in '..\Source\untLogin.pas' {frmLogin},
  untSplash in '..\Source\untSplash.pas' {frmSplash},
  untConsts in '..\Source\untConsts.pas',
  untOrderInfo in '..\Source\untOrderInfo.pas' {frmOrderInfo},
  untSearchOrder in '..\Source\untSearchOrder.pas' {frmSearchOrder},
  untOrderReport in '..\Source\untOrderReport.pas',
  untAbout in '..\Source\untAbout.pas' {frmAbout},
  untTFastReportEx in '..\Source\untTFastReportEx.pas',
  untPrintWindow in '..\Source\untPrintWindow.pas' {frmPrintWindow},
  untAddFormat in '..\Source\untAddFormat.pas' {frmAddFormat};

{$R *.res}

begin
  Application.Title := '��ݵ���ӡ';
  frmLogin:=TfrmLogin.Create(Application);
  frmLogin.ShowModal;
  if (frmLogin.ModalResult = mrOk) then
  begin
    try
      frmSplash:=TfrmSplash.Create(Application);
      with frmSplash do
      begin
        StartLoad;
        UpdateStatus('����������������', 10);
        UpdateStatus('���ڳ�ʼ������', 25);
        UpdateStatus('����ͻ�������', 35);
        CheckVersion('���ڼ��汾��', 50);
        Application.Initialize;
        Application.CreateForm(TfrmMain, frmMain);
        UpdateStatus('��ʼ����Զ����������', 60);
        UpdateStatus('��ʼ����Զ��Ȩ������', 70);
        UpdateStatus('��ʼ����Զ�̶�������', 90);
        Stopload;
      end;
    finally
      frmSplash.Close;
      frmSplash.Free;
    end;
    Application.Run;
  end
  else
    Exit;
end.
