// i:=Trunc(12.34);

unit Define;

interface

uses
  Graphics, windows, classes, Dialogs, Registry, forms, SysUtils;

//function  SendMsgToMML(sMsg:string):boolean;                        //����MML����, �жϷ���ֵΪE_SUCCESS����ʾ�ɹ��������ʾʧ��;

procedure SaveXls(fDB:integer);                         //����Xls�ļ�
procedure SaveTxt(fDB:integer);                         //����Txt�ļ�



const
  MainCaption='������ͨ�ֹ�˾����ҵ������շ�ϵͳI/O���ƻ�';
  CrLf=#13+#10;                                         //�س����У�����ҵ���ʱ��List����ȡҵ���ʱʹ�ã�
  Test=false;

  iTest = 0;                                            //0-ʹ�÷�������1-IPϵͳ���ԣ�ʹ�ñ���IP

  sHour=08;                                             //���ݶ�ʱɨ�裨��ʱiTELLIN��Voice�����в�����
  MaxErr=5;                                             //���������-1
  iNub=1;                                               //IOCtrlÿ�ν��룺0��-8��30����һ�δ���50����¼������ʱ��10����1��ֻ����5����¼
  IOBnb = 11;
  IOBHBnb = 11;

  DSNb = 20;                                            //���й���������������������ܳ���DSNb

  //iTELLIN�ӿڲ�����ѯѡ����
  IODBField = 'Zh,Yhmc,Dhhm,'+                         //ʹ�ñ�־��0-δʹ�á�1-�ʺſ�����2-�ʺſ�����3-�ʺ�ͣ�á�4-�޸����룩
              'case when IObz=1 then ''�ʺſ���''  '+
              '     when IObz=2 then ''�ʺſ���''  '+
              '     when IObz=3 then ''�ʺ�ͣ��''  '+
              '     else ''δʹ��''  '+
              'end as IObz,'+
              'Czlb,Tjsj,Wcsj,GS02,Fj,Zj,Yys,Bz';

  IOField:array[0..4,0..IOBnb] of string = (('Zh','Yhmc','Dhhm','IObz','Czlb',
                                             'Tjsj','Wcsj,','GS02','Fj','Zj',
                                             'Yys','Bz'),
  //ʹ��״̬��0-δ�ύ��1-���ύ��2-���������ɽӿڻ�д�룬ͬʱ�ô����־�����Ӵ��������
  //ʹ�ñ�־��0-δʹ�á�1-�ʺſ�ͨ��2-�ʺ�ͣ�á�3-�޸����룩
                                             ('�û��ʺ�','�û�����','��װ�绰','ʹ�ñ�־','�������',
                                              '�ύʱ��','���ʱ��','�м���˾','�����־�','����֧��',
                                              '����Ӫҵ��','��ע'),
                                             ('1','1','1','1','1','1','1','1','1','1',
                                              '1','1'),
                                             ('58','68','62','62','62','62','62','68','68',
                                              '68','68','128'),
                                             ('1','1','1','1','1','1','3','3','1','1',
                                              '1','1'));



//ϵͳ���⡢BDE���ò��� ��ʹ��MadeCord����ADSL.mdb��
  x0 = '^�_:[T`�IhK=]PQF�\�PodG`�imLaKnRaG_E';        //��ͨ�����ֹ�˾�������ҵ���ۺϹ���ϵͳ
  x1 = '��ð��´����������';                            //'DATABASE NAME=adsl'
  x3 = 'Ķ�ǶÑ����������������';                       //'SERVER NAME=10.72.00.236'
  x2 = '���Đ������ĝ�����';                            //'HOST NAME=XT-0004'
  x4 = '�ŷĒ�������';                                  //'USER NAME=sa'

//2005-3-28 �޸�sa����xtbai159->xtbai2126
//x5 = 'ô����ŷ�����ܤ��';                             //'PASSWORD=xtbai159'��ע�⣺��Ϊ�а�����֣�������ʾ���淶
  x5 = 'ô����ŷ�����ܥ���';                            //'PASSWORD=xtbai2126'
  x6 = '��ö�ǽι�����';                                //'BLOB SIZE=6400'


var
  SPath:string;                                         //ϵͳĿ¼
  WorkOK:boolean;                                       //���и��ն˵�¼��־��IP��ַ�Ƿ����ն��б��У�
  ShowOK:boolean;                                       //Ա����½��־����������FirstOK��־һ���ж��Ƿ���Ҫ�ڼ����ʱ��ʼ�����ݣ���

  i:integer;
  s,ss:string;
  NB,LinkFun:integer;
  LinkNB:integer;                                       //MML���������

  BeiLv:integer;                                        //IOCtrl()ÿ�ν��봦���¼������

  IP:array [0..15] of char;                             //����iTELLIN������IP��ַ
  HComm:pointer;                                        //�ӿھ�������ܶ����THANDLE���ͣ�
  pIP,pHComm:Pointer;                                   //IPָ�롢���ָ��
  Port:word;
  bAuto:boolean;
  dwTime:Longword;                                      //��ʱʱ��
  RT:pointer;
  bLogin:boolean;

  dlgCtrl:byte;
  cmd:string;
  service:string;


  OpId:string;                                          //����Ա����
  OpPass:string;                                        //����Ա����
  OpDj:string;                                          //����Ա�ȼ�
  OpIn:boolean;                                         //����Ա��¼��־
  OpQx:string[50];                                      //����ԱȨ��
  GSFun:integer;

	sXh:integer;                                          //��ţ�0=���أ�Ȼ���1��ʼ�����б�
	sName:string;                                         //����
	sArea:string;                                         //����
	sHostIp:string;                                       //����IP
	sHostName:string;                                     //��������
	sAlias:string;                                        //���ݿ����
	sLink:integer;                                        //���Ӻ�
	slocalIp:string;                                      //����IP
	slocalName:string;                                    //��������

  //����ΪдIO����ʱ���м����
  DSBh:    array[0..1,0..DSNb] of string;               //���б�ţ��������š��������ƣ������й�����������ܳ���DSNb
  sDSBh:string;                                         //�ۼƵ��������ַ���
  sGs:string;                                           //�����зֹ�˾��ʹ��Ա�����ϵĵ���
  sDs:string;                                           //�зֹ�˾��ʱ����
  iDs:integer;                                          //�зֹ�˾��ʱ����

	sFj:string;                                           //�־�
	sZj:string;                                           //֧��
  sJd:string;	   	                                      //�ֵ�
  sYwd:string;   	                                      //ҵ���
	sYys:string;                                          //Ӫҵ��
  sZdh:string;                                          //�ն˺�

  GS01:integer;                                         //�������ࣺʡ���ֹ�˾
  GS02:integer;                                         //�������ࣺ�м��ֹ�˾
  GS03:integer;                                         //�������ࣺ�зַ־֡�δ��
  GS04:integer;                                         //�������ࣺδ��
  GS05:integer;                                         //�������ࣺδ��

  iTime:real;
  iYear:Word;                            //��ǰ��
  iMon :Word;                            //��ǰ��
  iDay :Word;                            //��ǰ��
  iHour:Word;                            //��ǰʱ
  iMin :Word;                            //��ǰ��
  iSec :Word;                            //��ǰ��
  iMSec:Word;                            //��ǰ΢��
  lYear:Word;                            //������
  lMon :Word;                            //������
  lDay :Word;                            //������
  lHour:Word;                            //����ʱ
  lMin :Word;                            //������
  lSec :Word;                            //������

implementation

//function StartComm(pRemoteAddr:Pointer; port:word; dwHandle:Pointer): WORD; external 'SMIDLL.DLL' name 'StartComm';


//����Excel�ļ�
procedure SaveXls(fDB:integer);                         //����Xls�ļ�
var
  lNB:integer;
  sNB:array[0..4,0..99] of String;
  i,j: Integer;
  Str: String;
  StrList: TStringList;                                 //���ڴ洢���ݵ��ַ��б�
begin
end;

//����Txt�ļ�
procedure SaveTxt(fDB:integer);                         //����Txt�ļ�
var
  lNB:integer;
  sNB:array[0..4,0..99] of String;
  i,j: Integer;
  Str: String;
  txtfile:Textfile;
begin
end;

end.







