unit ClassEnterprise;

interface

uses
  Classes, Windows, DBTables;

type
  TEnterprise = class(TObject)
  public
    RatepayingNo: string; //��˰����
    TaxRegisterNo: string; //˰��Ǽ�֤��
    EnterpriseName: string; //ί����ҵȫ��
    AffiliateTown: string; //��������
    DetailAddress: string; //��ϸ��ַ
    TelephoneNo: string; //��ϵ�绰
    Linkman: string; //��ϵ��
    constructor Create;
    destructor Destroy; override;
    procedure CreateQuery;
    procedure FreeQuery;
    function GetInfo(ARatepayingNo, ATaxRegisterNo: string; AEnterpriseName: string = ''): Boolean;
    function Update: Boolean;
    function Insert: Boolean;
    function Delete: Boolean;
  private
    TmpQuery: TQuery;
  end;

implementation

uses
  SysUtils, Forms, DB, Dialogs;

{ Enterprise }

constructor TEnterprise.Create;
begin
  inherited;
  CreateQuery;
end;

procedure TEnterprise.CreateQuery;
begin
  try
    TmpQuery := TQuery.Create(nil); //����TEMPQUERY��ѯ
    TmpQuery.DatabaseName := 'JB';
  except
    on E: Exception do
    begin
      Application.MessageBox(PChar(E.Message), '�����', MB_OK + MB_ICONERROR);
      Application.Terminate; //�رճ���
    end;
  end;
end;

function TEnterprise.Delete: Boolean;
begin
  with TmpQuery do
  try
    try
      Close;
      SQL.Clear;
      SQL.Add(' DELETE FROM Enterprise.DB ');
      SQL.Add(' WHERE  RatepayingNo="' + RatepayingNo + '"');
      Prepare;
      ExecSQL;
      Result := True; //�ɹ�������TRUE
    finally
      UnPrepare;
      Close;
      Application.MessageBox('ɾ����ҵ��Ϣ�ɹ���', 'ȷ��', MB_OK + MB_ICONINFORMATION);
    end;
  except
    Application.MessageBox('ɾ����ҵ��Ϣ����', '�����', MB_OK + MB_ICONERROR);
    Result := False;
  end;
end;

destructor TEnterprise.Destroy;
begin
  FreeQuery;
  inherited;
end;

procedure TEnterprise.FreeQuery;
begin
  TmpQuery.Free; //�ͷ�TEMPQUERY��ѯ
end;

function TEnterprise.GetInfo(ARatepayingNo, ATaxRegisterNo: string;
  AEnterpriseName: string = ''): Boolean;
begin
  Result := False;
  with TmpQuery do
  try
    Close; //�ر�TEMPQUERY��ѯ
    SQL.Clear;
    SQL.Add(' SELECT * FROM Enterprise.DB');
    if ARatepayingNo = '' then
      SQL.Add(' WHERE RatepayingNo= ' + '"' + Trim(ARatepayingNo) + '"')
    else
      SQL.Add(' WHERE TaxRegisterNo=' + '"' + Trim(ATaxRegisterNo) + '"');
    Open; //��ʼ��ѯ
    First;
    if RecordCount > 0 then //���������ļ�¼����Ϊ0(���м�¼)
    begin //ȡ���ӱ��еĸ����ֶ�
      RatepayingNo := fieldbyname('RatepayingNo').asstring; {ȡ��˰����}
      TaxRegisterNo := fieldbyname('TaxRegisterNo').asstring; {ȡ˰��Ǽ�֤��}
      EnterpriseName := fieldbyname('EnterpriseName').asstring; {ȡί����ҵȫ��}
      AffiliateTown := fieldbyname('AffiliateTown').asstring; {ȡ��������}
      DetailAddress := fieldbyname('DetailAddress').asstring; {ȡ��ϸ��ַ}
      TelephoneNo := fieldbyname('TelephoneNo').asstring; {ȡ��ϵ�绰}
      Linkman := fieldbyname('Linkman').asstring; {ȡ��ϵ��}
      Result := True
    end;
  finally
    Close; //�ر�TEMPQUERY��ѯ
  end;
end;

function TEnterprise.Insert: Boolean;
begin
  with TmpQuery do
  try
    try
      Close; //�رղ�ѯ
      SQL.Clear; //���ԭ��SQL���
      SQL.Add(' INSERT INTO Enterprise.DB ');
      SQL.Add('        (RatepayingNo,');
      SQL.Add('        TaxRegisterNo,');
      SQL.Add('        EnterpriseName,');
      SQL.Add('        AffiliateTown,');
      SQL.Add('        DetailAddress,');
      SQL.Add('        TelephoneNo,');
      SQL.Add('        Linkman)');
      SQL.Add(' VALUES ("' + RatepayingNo + '",'); //��˰����
      SQL.Add('        "' + TaxRegisterNo + '",'); //˰��Ǽ�֤��
      SQL.Add('        "' + EnterpriseName + '",'); //ί����ҵȫ��
      SQL.Add('        "' + AffiliateTown + '",'); //��������
      SQL.Add('        "' + DetailAddress + '",'); //��ϸ��ַ
      SQL.Add('        "' + TelephoneNo + '",'); //��ϵ�绰
      SQL.Add('        "' + Linkman + '")'); //��ϵ��
      Prepare; //����BDE��ִ��һ��SQL
      ExecSQL; //��ʼ��������
      Result := True; //����TRUE
    finally
      Unprepare; //����BDE���SQL��ִ��
      Close; //�رղ�ѯ
      Application.MessageBox('�����ҵ��Ϣ�ɹ���', 'ȷ��', MB_OK + MB_ICONINFORMATION);
    end;
  except
    Application.MessageBox('�����ҵ��Ϣ����', '�����', MB_OK + MB_ICONERROR);
    Result := False;
  end;
end;

function TEnterprise.Update: Boolean;
begin
  with TmpQuery do
  try
    try
      Close; //�رղ�ѯ
      SQL.Clear; //���ԭ��SQL���
      SQL.Add(' UPDATE Enterprise.DB ');
      SQL.Add(' SET    TaxRegisterNo="' + TaxRegisterNo + '",'); //˰��Ǽ�֤��
      SQL.Add('        EnterpriseName="' + EnterpriseName + '",'); //ί����ҵȫ��
      SQL.Add('        AffiliateTown="' + AffiliateTown + '",'); //��������
      SQL.Add('        DetailAddress="' + DetailAddress + '",'); //��ϸ��ַ
      SQL.Add('        TelephoneNo="' + TelephoneNo + '",'); //��ϵ�绰
      SQL.Add('        Linkman="' + Linkman + '"'); //��ϵ��
      SQL.Add(' WHERE  RatepayingNo="' + RatepayingNo + '"');
      Prepare; //����BDE��ִ��һ��SQL
      ExecSQL; //��ʼ��������
      Result := True; //����TRUE
    finally
      Unprepare; //����BDE���SQL��ִ��
      Close; //�رղ�ѯ
      Application.MessageBox('������ҵ��Ϣ�ɹ���', 'ȷ��', MB_OK + MB_ICONINFORMATION);
    end;
  except
    Application.MessageBox('������ҵ��Ϣ����', '����', MB_OK + MB_ICONERROR);
    Result := False;
  end;
end;

end.

