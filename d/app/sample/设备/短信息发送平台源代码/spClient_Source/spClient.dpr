program spClient;

uses
  Forms,
  sysutils,
  windows,
  main in 'main.pas' {Form1},
  regForm in 'regForm.pas' {Form2};

{$R *.res}

var
    mutex     : THandle;
    mutexName : array [0..7] of char;
begin
  Application.Initialize;
  try
    strpcopy(mutexname,'SMSEXPRESS');
    mutex:=openmutex(MUTEX_ALL_ACCESS, False, mutexName );
    if mutex=0 then    //����δ��������������
    begin
        mutex :=createmutex(nil ,true, mutexName);
        Application.CreateForm(TForm1, Form1);
  Application.Run;
        releasemutex(mutex);
    end;
  finally
  end;
end.


