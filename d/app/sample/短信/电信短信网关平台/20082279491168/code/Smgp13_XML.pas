{-----------------------------------------------------------------------------
 Unit Name: ���Ŷ���Ϣ���أ��ڲ�XML�����������ɣ�
 Author:    luo xin xi
 Purpose:   SMS XML(Read/Write)
 History:
 Date:      2005-04-18
-----------------------------------------------------------------------------}
unit Smgp13_XML;

interface
uses Classes,
  SysUtils, Base64;

type
  //3.0Э���ѡ������Ϣ��
  TSMGPTLV_tag = packed record
    Tag:Word;
    Length:Word;
    Value:byte;
  end;
  TSMGPTLVLinkID_tag = packed record
    Tag:Word;
    Length:Word;
    Value:array[0..19] of char;  
  end;

  PCTDeliver = ^TTCDeliver;
  TTCDeliver = packed record
    MsgID: string; //���ز����Ķ���Ϣ��ˮ��
    IsReport: integer; //�Ƿ�״̬���棨0�����ǣ�1���ǣ�
    MsgFormat: integer; //����Ϣ��ʽ
    RecvTime: string; //����Ϣ����ʱ��
    DestTermID: string; //����Ϣ���պ���
    SrcTermID: string; //����Ϣ���ͺ���
    //SrcTermType : byte;
    MsgLength: integer; //����Ϣ����
    //ServiceID : string;
    MsgContent: string; //����Ϣ����
    Reserve: string; //����
    LinkID:string;
  end;  

  TTCSubmit = packed record
    Mid: string;
    MsgType: integer; // ����Ϣ����
    NeedReport: integer; // �Ƿ�Ҫ�󷵻�״̬����
    Priority: integer; // �������ȼ�
    ServiceID: string; // ҵ������
    FeeType: string; // �շ�����
    FixedFee :string;
    FeeUserType:byte;
    FeeCode: string; //  �ʷѴ��루��λΪ�֣�
    MsgFormat: integer; // ����Ϣ��ʽ
    ValidTime: string; // ��Чʱ��
    AtTime: string; // ��ʱ����ʱ��
    SrcTermID: string; // ����Ϣ�����û�����
    ChargeTermID: string; //  �Ʒ��û�����
    DestTermIDCount: integer; //  ����Ϣ���պ�������
    DestTermID: string; //  ����Ϣ���պ���
    MsgLength: integer; // ����Ϣ����
    MsgContent: string; // ����Ϣ����
    Reserve: string; // LinkID
    LinkID:string;
    SubmitMsgType:byte;//13ͬ������, 15 ͬ�������ظ�  0 �㲥��Ϣ 
  end;

  PReport = ^TReport;
  TReport = packed record
    id: string; //array [0..9] of char;	//״̬�����Ӧԭ����Ϣ���������е�MsgID
    sub: string; //array [0..2] of char;	//ȡȱʡֵ001
    dlvrd: string; //array [0..2] of char;	//ȡȱʡֵ001
    Submit_date: string; //array [0..9] of char;	//����Ϣ�ύʱ��(��ʽ:yymmddhhmm ����0306112000)
    done_date: string; //array [0..9] of char;	//����Ϣ�·�ʱ��(��ʽ:yymmddhhmm ����0306112000)
    Stat: string; //array [0..6] of char;	//����Ϣ״̬
    Err: string; //array [0..2] of char;	//�������,�ο���������
    Txt: string; //array [0..19] of char;	//ǰ3���ֽ�,��ʾ����Ϣ���Ⱥ�17���ֽڱ�ʾ����Ϣ��ǰһ���ַ�
  end;

function ReadDeliver(const XML: string; var rDeliver: TTCDeliver): Boolean;
function WriteDeliver(const rDeliver: TTCDeliver): string;
function ReadSubmit(const XML: string; var rSubmit: TTCSubmit): Boolean;
function WriteSubmit(const rSubmit: TTCSubmit): string;
function writeXmlReport(const xReport: TReport): string;

implementation

uses U_Main;

function GetBody(const XML, StarStr, EndStr: string): string;
var
  i, j: integer;
begin
  i := AnsiPos(AnsiUpperCase(StarStr), AnsiUpperCase(XML));
  if i = 0 then Exit;

  j := AnsiPos(AnsiUpperCase(EndStr), AnsiUpperCase(XML));
  if j = 0 then Exit;

  Inc(i, Length(StarStr));

  Result := '';
  Result := Trim(Copy(XML, i, j - i));
end;
//****����Э���޸�
function ReadDeliver(const XML: string; var rDeliver: TTCDeliver): Boolean;
var
  i: integer;
  TmpStr: string;
begin
  Result := False;
  i := AnsiPos('<Deliver>', XML);
  if i = 0 then Exit;
  TmpStr := GetBody(XML, '<MsgID>', '</MsgID>');
  rDeliver.MsgID := TmpStr;
  rDeliver.SrcTermID := GetBody(XML, '<SrcTermID>', '</SrcTermID>');
  rDeliver.DestTermID := GetBody(XML, '<DestTermID>', '</DestTermID>');
  //rDeliver.SrcTermType := StrToIntdef(GetBody(XML, '<SrcTermType>', '</SrcTermType>'),0);
  //rDeliver.ServiceID := GetBody(XML, '<ServiceID>', '</ServiceID>');
  rDeliver.MsgContent := DecodeBase64( GetBody(XML, '<MsgContent>', '</MsgContent>'));
  //rDeliver.LinkID := GetBody(XML, '<LinkID>', '</LinkID>');
  Result := True;
end;
//***д��ͨ�õ�xml�ṹ
function WriteDeliver(const rDeliver: TTCDeliver): string;
begin
  Result := '';
  Result := '<?xml version="1.0" encoding="UTF-8"?>';
  Result := Result + '<Deliver>';
  Result := Result + '<GateID>' + GateID + '</GateID>';
  Result := Result + '<MsgID>' + rDeliver.MsgID + '</MsgID>';
  Result := Result + '<SrcTermID>' + rDeliver.SrcTermID + '</SrcTermID>';
  Result := Result + '<DestTermID>' + rDeliver.DestTermID + '</DestTermID>';
  Result := Result + '<DestTermType>0</DestTermType>';
  Result := Result + '<ServiceID></ServiceID>'; //��ӦЭ��û�е�����''
  Result := Result + '<MsgContent>' + EncodeBase64(rDeliver.MsgContent) + '</MsgContent>';
  Result := Result + '<LinkID>'+rDeliver.LinkID+'</LinkID>';
  Result := Result + '</Deliver>';
end;
//���ݸ���Ӫ�̵�Э���submitxml�ĵ��ж�ȡ��Ҫ��������
function ReadSubmit(const XML: string; var rSubmit: TTCSubmit): Boolean;
var
  i: integer;
  TmpStr: string;
begin
  Result := False;
  i := AnsiPos('<Submit>', XML);
  if i = 0 then Exit;
  
  TmpStr := GetBody(XML, '<MID>', '</MID>');
  rSubmit.Mid := TmpStr;

  TmpStr := GetBody(XML, '<MsgType>', '</MsgType>');
  rSubmit.MsgType := strtoint(TmpStr);

  TmpStr := GetBody(XML, '<NeedReport>', '</NeedReport>');
  rSubmit.NeedReport := strtoint(TmpStr);

  TmpStr := GetBody(XML, '<Priority>', '</Priority>');
  rSubmit.Priority := strtoint(TmpStr);

  TmpStr := GetBody(XML, '<ServiceID>', '</ServiceID>');
  rSubmit.ServiceID := TmpStr;

  TmpStr := GetBody(XML, '<FeeType>', '</FeeType>');
  rSubmit.FeeType := TmpStr;

  TmpStr := GetBody(XML, '<FixedFee>', '</FixedFee>');
  rSubmit.FixedFee := TmpStr;

  TmpStr := GetBody(XML, '<FeeCode>', '</FeeCode>');
  rSubmit.FeeCode := TmpStr;

  TmpStr := GetBody(XML, '<FeeUserType>', '</FeeUserType>');
  rSubmit.FeeUserType := StrToIntDef(TmpStr,0);

  TmpStr := GetBody(XML, '<MsgFormat>', '</MsgFormat>');
  rSubmit.MsgFormat := strtoint(TmpStr);

  TmpStr := GetBody(XML, '<ValidTime>', '</ValidTime>');
  rSubmit.ValidTime := TmpStr;

  TmpStr := GetBody(XML, '<AtTime>', '</AtTime>'); // ��ʱ����ʱ��
  rSubmit.AtTime := TmpStr;

  TmpStr := GetBody(XML, '<SrcTermID>', '</SrcTermID>'); // ����Ϣ�����û�����
  rSubmit.SrcTermID := TmpStr;

  TmpStr := GetBody(XML, '<FeeTermID>', '</FeeTermID>'); //  �Ʒ��û�����
  rSubmit.ChargeTermID := TmpStr;

  TmpStr := GetBody(XML, '<DestTermIDCount>', '</DestTermIDCount>'); //  ����Ϣ���պ�������
  rSubmit.DestTermIDCount := strtoint(TmpStr);

  TmpStr := GetBody(XML, '<DestTermID>', '</DestTermID>'); //  ����Ϣ���պ���
  rSubmit.DestTermID := TmpStr ;

  TmpStr := GetBody(XML, '<MsgContent>', '</MsgContent'); // ����Ϣ����
  rSubmit.MsgContent := Base64.DecodeBase64(TmpStr);
  rSubmit.MsgLength := Length(rSubmit.MsgContent); // ����Ϣ���� 
  rSubmit.LinkID := GetBody(XML, '<LinkID>', '</LinkID');
  Result := True;
end;

function WriteSubmit(const rSubmit: TTCSubmit): string;
begin
  Result := '<?xml version="1.0" encoding="UTF-8"?>';
  Result := Result +'<Submit>';
  Result := Result + '<GateID>' + GateID + '</GateID>';
  Result := Result + '<Mid>'+ rSubmit.Mid +'</Mid>';
  Result := Result + '<MsgType>' + inttostr(rSubmit.MsgType) + '</MsgType>'; // ����Ϣ����
  Result := Result + '<PkTotal></PkTotal>'; //
  Result := Result + '<PkNumber></PkNumber>'; //
  Result := Result + '<NeedReport>' + inttostr(rSubmit.NeedReport) + '</NeedReport>'; // �Ƿ�Ҫ�󷵻�״̬����
  Result := Result + '<Priority>' + inttostr(rSubmit.Priority) + '</Priority>'; // �������ȼ�
  Result := Result + '<ServiceID>' + rSubmit.ServiceID + '</ServiceID>'; // ҵ������
  Result := Result + '<FeeType>' + rSubmit.FeeType + '</FeeType>'; // �շ�����
  Result := Result + '<FeeCode>' + rSubmit.FeeCode + '</FeeCode>'; //  �ʷѴ��루��λΪ�֣�
  Result := Result + '<FeeUserType>' + IntToStr(rSubmit.FeeUserType) + '</FeeUserType>';
  Result := Result + '<FeeTermID>' + rSubmit.ChargeTermID + '</FeeTermID>'; //  �Ʒ��û�����
  Result := Result + '<FeeTermType>0</FeeTermType>';
  Result := Result + '<TpPid>1</TpPid>';
	Result := Result + '<TpUdhi>1</TpUdhi>';
  Result := Result + '<MsgFormat>' + inttostr(rSubmit.MsgFormat) + '</MsgFormat>'; // ����Ϣ��ʽ
  Result := Result + '<SrcTermID>' + rSubmit.SrcTermID + '</SrcTermID>'; // ����Ϣ�����û�����
  Result := Result + '<FixedFee>0</FixedFee>';   //����ͨ��GivenValue����
  Result := Result + '<MorelatetoMTFlag>0</MorelatetoMTFlag>';   //��ͨ
  Result := Result + '<AgentFlag>1</AgentFlag>'; 
  Result := Result + '<ValidTime>' + rSubmit.ValidTime + '</ValidTime>'; // ��Чʱ��
  Result := Result + '<AtTime>' + rSubmit.AtTime + '</AtTime>'; // ��ʱ����ʱ��
  Result := Result + '<DestTermIDCount>' + IntToStr(rSubmit.DestTermIDCount) + '</DestTermIDCount>'; //  ����Ϣ���պ�������
  Result := Result + '<DestTermID>' + rSubmit.DestTermID + '</DestTermID>'; //  ����Ϣ���պ���
  Result := Result + '<DestTermType>0</DestTermType>';
  //Result := Result + '<MsgLength>' + inttostr(rSubmit.MsgLength) + '</MsgLength>'; // ����Ϣ����
  Result := Result + '<MsgContent>' + EncodeBase64(rSubmit.MsgContent) + '</MsgContent>'; // ����Ϣ����
  Result := Result + '<LinkID></LinkID>'; // ����
  Result := Result +'</Submit>';
end;

function writeXmlReport(const xReport: TReport): string;
begin
  Result := '';
  Result := '<?xml version="1.0" encoding="UTF-8"?>';
  Result := Result + '<Report>';
  Result := Result + '<GateID>' + GateID + '</GateID>';
  Result := Result + '<MsgID>' + xReport.id + '</MsgID>';
  Result := Result + '<Sub>' + xReport.sub + '</Sub>';
  Result := Result + '<Dlvrd>' + xReport.dlvrd + '</Dlvrd>';
  Result := Result + '<SubmitTime>' + xReport.Submit_date + '</SubmitTime>';
  Result := Result + '<DoneTime>' + xReport.done_date + '</DoneTime>';
  Result := Result + '<Stat>' + xReport.Stat + '</Stat>';
  Result := Result + '<Err>' + xReport.Err + '</Err>';
  Result := Result + '<Txt>' + EncodeBase64( xReport.Txt )+ '</Txt>';
  Result := Result + '<DestTermID></DestTermID>';
  Result := Result + '<SMSCSeq></SMSCSeq>'; 
  Result := Result + '</Report>';
end;
end.

