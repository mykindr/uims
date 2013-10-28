unit IDCardClass_U;
//Download by http://www.codefans.net
interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;
type
  TIDCard = class(TObject)
  private
    FMZList: TStringList;//��������б�
    FMZ: string;//����
    FName:string;   //����
    FSex_Code: string;   //�Ա����
    FSex_CName: string;   //�Ա�
    FIDC: string;      //���֤����
    FNATION_Code: string;   //�������
    FNATION_CName: string;   //����
    FBIRTH: string;     //��������
    FADDRESS: string;    //סַ
    FREGORG: string;     //ǩ������
    FSTARTDATE: string;    //���֤��Ч��ʼ����
    FENDDATE: string;    //���֤��Ч��������
    FPeriod_Of_Validity_Code: string;   //��Ч���޴��룬���ԭ��ϵͳ����Ϊ��һ��֤���ǣ����������������ֶΣ�����֤���Ѿ�û����
    FPeriod_Of_Validity_CName: string;   //��Ч����

    procedure SetMZ(value: string);
    procedure SetName(value: string);
    procedure SetSex_Code(value: string);
    procedure SetSex_CName(value: string);
    procedure SeTIDCardC(value: string);
    procedure SetNATION_Code(value: string);
    procedure SetNATION_CName(value: string);
    procedure SetBIRTH(value: string);
    procedure SetADDRESS(value: string);
    procedure SetREGORG(value: string);
    procedure SetSTARTDATE(value: string);
    procedure SetENDDATE(value: string);
    procedure SetPeriod_Of_Validity_Code(value: string);
    procedure SetPeriod_Of_Validity_CName(value: string);

    function GetMZ: string;
    function GetName: string;
    function GetSex_Code: string;
    function GetSex_CName: string;
    function GeTIDCardC: string;
    function GetNATION_Code: string;
    function GetNATION_CName: string;
    function GetBIRTH: string;
    function GetADDRESS: string;
    function GetREGORG: string;
    function GetSTARTDATE: string;
    function GetENDDATE: string;
    function GetPeriod_Of_Validity_Code: string;
    function GetPeriod_Of_Validity_CName: string;
  public
    constructor Create();
    destructor Destroy();
    procedure InitInfo(FileName: string);
    property MZ: string read GetMZ ;
    property Name: string read GetName write SetName;
    property Sex_Code: string read GetSex_Code write SetSex_Code;
    property Sex_CName: string read GetSex_CName write SetSex_CName;
    property IDC: string read GeTIDCardC write SeTIDCardC;
    property NATION_Code: string read GetNATION_Code write SetNATION_Code;
    property NATION_CName: string read GetNATION_CName write SetNATION_CName;
    property BIRTH: string read GetBIRTH write SetBIRTH;
    property ADDRESS: string read GetADDRESS write SetADDRESS;
    property REGORG: string read GetREGORG write SetREGORG;
    property STARTDATE: string read GetSTARTDATE write SetSTARTDATE;
    property ENDDATE: string read GetENDDATE write SetENDDATE;
    property Period_Of_Validity_Code: string read GetPeriod_Of_Validity_Code write SetPeriod_Of_Validity_Code;
    property Period_Of_Validity_CName: string read GetPeriod_Of_Validity_CName write SetPeriod_Of_Validity_CName;
  end;
implementation

{ TIDCard }
constructor TIDCard.Create;
begin
  inherited;
  //----------�����Ⱥ�ѭ���ܴ�-----------//
  FMZList:= TStringList.Create;
  FMZList.Add('����');
  FMZList.Add( '�ɹ���');
  FMZList.Add('����');
  FMZList.Add('����');
  FMZList.Add('ά�����');
  FMZList.Add('����');
  FMZList.Add('����');
  FMZList.Add('׳��');
  FMZList.Add('������');
  FMZList.Add('������');
  FMZList.Add('����');
  FMZList.Add('����');
  FMZList.Add('����');
  FMZList.Add('����');
  FMZList.Add('������');
  FMZList.Add('������');
  FMZList.Add('��������');
  FMZList.Add('����');
  FMZList.Add('����');
  FMZList.Add('������');
  FMZList.Add('����');
  FMZList.Add('���');
  FMZList.Add('��ɽ��');
  FMZList.Add('������');
  FMZList.Add('ˮ��');
  FMZList.Add('������');
  FMZList.Add('������');
  FMZList.Add('������');
  FMZList.Add('�¶�������');
  FMZList.Add('����');
  FMZList.Add('�ﺲ����');
  FMZList.Add('������');
  FMZList.Add('Ǽ��');
  FMZList.Add('������');
  FMZList.Add('������');
  FMZList.Add('ë����');
  FMZList.Add('������');
  FMZList.Add('������');
  FMZList.Add('������');
  FMZList.Add('������');
  FMZList.Add('��������');
  FMZList.Add('ŭ��');
  FMZList.Add('���α����');
  FMZList.Add('����˹��');
  FMZList.Add('���¿���');
  FMZList.Add('�°���');
  FMZList.Add('������');
  FMZList.Add('ԣ����');
  FMZList.Add('����');
  FMZList.Add('��������');
  FMZList.Add('������');
  FMZList.Add('���״���');
  FMZList.Add('������');
  FMZList.Add('�Ű���');
  FMZList.Add('�����');
  FMZList.Add('��ŵ��');
  FMZList.Add('����');
  FMZList.Add('������뼮')
end;

function TIDCard.GetADDRESS: string;
begin
  Result:= FADDRESS;
end;

function TIDCard.GetBIRTH: string;
begin
  Result:= FBIRTH;
end;

function TIDCard.GetENDDATE: string;
begin
  Result:= FENDDATE;
end;

function TIDCard.GeTIDCardC: string;
begin
  Result:= FIDC;
end;

function TIDCard.GetMZ: string;
begin
  Result:= FMZ;
end;

function TIDCard.GetName: string;
begin
  Result:= FName;
end;

function TIDCard.GetNATION_CName: string;
begin
  Result:= FNATION_CName;
end;

function TIDCard.GetNATION_Code: string;
begin
  Result:= FNATION_Code;
end;

function TIDCard.GetPeriod_Of_Validity_CName: string;
begin
  Result:= FPeriod_Of_Validity_CName;
end;

function TIDCard.GetPeriod_Of_Validity_Code: string;
begin
  Result:= FPeriod_Of_Validity_Code;
end;

function TIDCard.GetREGORG: string;
begin
  Result:= FREGORG;
end;

function TIDCard.GetSex_CName: string;
begin
  Result:= FSex_CName
end;

function TIDCard.GetSex_Code: string;
begin
  Result:= FSex_Code;
end;

function TIDCard.GetSTARTDATE: string;
begin
  Result:= FSTARTDATE;
end;

procedure TIDCard.SetADDRESS(value: string);
begin
  FADDRESS:= value;
end;

procedure TIDCard.SetBIRTH(value: string);
begin
  FBIRTH:= value;
end;

procedure TIDCard.SetENDDATE(value: string);
begin
  FENDDATE:= value;
end;

procedure TIDCard.SeTIDCardC(value: string);
begin
  FIDC:= value;
end;

procedure TIDCard.SetMZ(value: string);
begin
  FMZ:= value;
end;

procedure TIDCard.SetName(value: string);
begin
  FName:= value;
end;

procedure TIDCard.SetNATION_CName(value: string);
begin
  FNATION_CName:= value;
end;

procedure TIDCard.SetNATION_Code(value: string);
begin
  FNATION_Code:= value;
end;

procedure TIDCard.SetPeriod_Of_Validity_CName(value: string);
begin
  FPeriod_Of_Validity_CName:= value;
end;

procedure TIDCard.SetPeriod_Of_Validity_Code(value: string);
begin
  FPeriod_Of_Validity_Code:= value;
end;

procedure TIDCard.SetREGORG(value: string);
begin
  FREGORG:= value;
end;

procedure TIDCard.SetSex_CName(value: string);
begin
  FSex_CName:= value;
end;

procedure TIDCard.SetSex_Code(value: string);
begin
  FSex_Code:= value;
end;

procedure TIDCard.SetSTARTDATE(value: string);
begin
  FSTARTDATE:= value;
end;

procedure TIDCard.InitInfo(FileName: string);
var
  iFileHandle,iFileLength: Integer;
  Buffer: PWideChar;
  wInfo :WideString;
begin
  iFileHandle := FileOpen(FileName, fmOpenRead);
  iFileLength := FileSeek(iFileHandle,0,2);
  FileSeek(iFileHandle,0,0);
  Buffer := PWideChar(AllocMem(iFileLength +2));
  FileRead(iFileHandle, Buffer^, iFileLength);
  FileClose(iFileHandle);
  wInfo:=WideChartostring(buffer);
  SetName(trim(copy(wInfo,1,15)));
  SetSex_Code(trim(copy(wInfo,16,1)));
  if FSex_Code = '1' then
    SetSex_CName('��')
  else if FSex_Code = '2' then
    SetSex_CName('Ů');
  SetNATION_Code(trim(copy(wInfo,17,2)));
  if FMZList<> nil then
    SetNATION_CName(FMZList.Strings[StrToInt(FNATION_Code)-1]);
  SetBIRTH(trim(copy(wInfo,19,8)));
  SetADDRESS(trim(copy(wInfo,27,35)));
  SeTIDCardC(trim(copy(wInfo,62,18)));
  SetREGORG(trim(copy(wInfo,80,15)));
  SetSTARTDATE(trim(copy(wInfo,95,8)));
  SetENDDATE(trim(copy(wInfo,103,8)));
end;


destructor TIDCard.Destroy;
begin
  FMZList.Free;
end;

end.
