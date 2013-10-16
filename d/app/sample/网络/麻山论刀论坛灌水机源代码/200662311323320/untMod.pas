unit untMod;

interface
uses controls,wininet,windows,sysutils,Graphics,inifiles,stdctrls,classes,
  strutils,Dialogs,forms,olectrls,RzTabs,RzChkLst,RzTreeVw,comctrls,shellapi,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IdBaseComponent, IdCookieManager,
  IdCookie;
const
  keys:string='0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
type TType=(Analyze,OnlyLogin,LoginFromRevert,Reg,New,LoginAndNew,Revert,LoginAndRevert);
type oneAccount=record //һ���ʺŽṹ
  Account:string[10];
  Password:string[10];
  State:boolean;//״̬
end;
type oneBBS2=record //һ������̳�ṹ
  Name:string;
  URL:string;
  State:integer;//״̬
end;
type oneRevart=record //һ���ظ� 
  URL:string;
  State:integer;//״̬
end;
type oneBBS=record //һ����̳�ṹ
  Name:string;//����
  sType:string;//����
  Cookie:string;
  FileName_Validate:string;//��֤���ļ���
  ValidateLength:integer;//��֤�볤��
  State_Reg:boolean;//״̬ 
  State_New:integer;//״̬ 
  State_Revert:integer;//״̬  
  
  Error_LimitTime:string;//ʱ������
  Error_EstopIP :string;//��ֹIP
  Error_EstopAccount:string;//��ֹ�ʺ�
  Error_NewOK:string;//�����ɹ�
  Error_RegOK:string;//ע��ɹ� 
  Error_RevertOK:string;//�ظ��ɹ�
  Error_LoginOK:string;//��¼�ɹ�
  Error_Logined:string;//�ѵ�¼
  Error_Temp:string;//���صĴ�����Ϣ
  Error_Start:string;//������Ϣ��ͷ�ַ�
  Error_Validata:string;//��֤�����
  URL:string;//��ҳ
  URL_Reg:string;//ע���ַ
  URL_RegSubmit:string;//ע���ύ
  URL_LogIn:string;//��¼��ַ
  URL_LogOut:string;//�˳���ַ
  URL_Temp:string;//Ҫ�򿪵���ҳ��ַ 
  URL_New_B:string;//����������ַ
  URL_NewSubmit_B:string;//���������ύ��ַ
  URL_RevertSubmit_B:string;//����ظ��ύ��ַ  
  
  AccountIndex:integer;//�ʺ�����
  AccountCount:integer;//�ʺ�����
  Account:array of oneaccount;//�ʺ�����
  BBS2Count:integer;//��̳����
  BBS2:array of oneBBS2;//��̳����
  RevartCount:integer;//�ظ�����
  Revart:array of onerevart;//�ظ�����
  
  Value_Account:string;//���ʱ��ֵ
  Value_Password:string;
  Value_Ask1:string;
  Value_Ask2:string;
  Value_Answer1:string;
  Value_Answer2:string;
  Value_eMail:string;
  Value_NewName:string;//��������
  Value_NewRootId:string;//����ID
  Value_NewEdit:string;
  Value_NewText:string;
  Value_RevertRootId:string;//����ID
  Value_RevertFollowId:string;//����ID
  Value_RevertText:string;
  Value_Validate:string;
  
  Var_Reg_Acc:string;//�ʺű�����
  Var_Reg_Sex:string;//�Ա������ 
  Var_Reg_Pass1:string;//����1������
  Var_Reg_Pass2:string;//����2������
  Var_Reg_Ask1:string;//����1������
  Var_Reg_Answer1:string;//����1�ش������
  Var_Reg_Ask2:string;//����2������
  Var_Reg_Answer2:string;//����2�ش������
  Var_Reg_eMail:string;//����
  
  Var_Login_Account:string;//��¼ʱ�ı���
  Var_Login_Password:string;
  
  Var_New_Account:string;//����ʱ����
  Var_New_Password:string;
  Var_New_Main:string;
  Var_New_Memo:string;
  
  Var_Revert_Account:string;//�ظ�ʱ����
  Var_Revert_Password:string;
  Var_Revert_RootId:string;
  Var_Revert_FollowId:string;
  Var_Revert_Memo:string;
  
  Var_Validate:string;//��֤������
  Var_BoardId:string;//�������     
  Var_HideVali_1:string;//������֤����1
  Var_HideVali_1B:string;
  Var_HideVali_1E:string;
  Var_HideVali_2:string;//������֤����2
  Var_HideVali_2B:string;
  Var_HideVali_2E:string;
end;
type oneBBSType=record//һ����̳����
  Name:string;//������      
  FileName_Validate:string;//��֤���ļ���
  ValidateLength:integer;//��֤�볤��
  URL_Reg:string;//ע���ַ   
  URL_RegSubmit:string;//ע���ύ
  URL_Login:string;//����
  URL_Logout:string;//�ǳ� 
  URL_New_B:string;//����ʱ��ǰ��
  URL_NewSubmit_B:string;//�����ύʱ��ǰ��
  URL_RevertSubmit_B:string;//�����ύʱ��ǰ��
  
  Error_LimitTime:string;//ʱ������
  Error_EstopIP :string;//��ֹIP
  Error_EstopAccount:string;//��ֹ�ʺ�
  Error_NewOK:string;//�����ɹ�
  Error_RegOK:string;//ע��ɹ� 
  Error_RevertOK:string;//�ظ��ɹ�
  Error_LoginOK:string;//��¼�ɹ�    
  Error_Logined:string;//�ѵ�¼
  Error_Start:string;//������Ϣ��ͷ�ַ�
  Error_Validata:string;
  
  BBS2_B:string;//��̳����,β
  BBS2_E:STRING;
  BBS2_NameB:string;//��̳������ĸ
  BBS2_NameE:string;//β
  
  Var_Reg_Acc:string;//�ʺű�����
  Var_Reg_Sex:string;//�Ա������ 
  Var_Reg_Pass1:string;//����1������
  Var_Reg_Pass2:string;//����2������
  Var_Reg_Ask1:string;//����1������
  Var_Reg_Answer1:string;//����1�ش������
  Var_Reg_Ask2:string;//����2������
  Var_Reg_Answer2:string;//����2�ش������
  Var_Reg_eMail:string;//����
  
  Var_Login_Account:string;//��¼ʱ�ı���
  Var_Login_Password:string;
  
  Var_New_Account:string;//����ʱ�ʺ�
  Var_New_Password:string;
  Var_New_Main:string;//�����������
  Var_New_Memo:string;//�������ݱ���
  
  Var_Revert_Account:string;//�ظ�ʱ����
  Var_Revert_Password:string;
  Var_Revert_RootId:string;
  Var_Revert_FollowId:string;
  Var_Revert_Memo:string;//�ظ����ݱ���
  
  Var_Validate:string;//��֤������ 
  Var_BoardId:string;//�������  
  Var_HideVali_1:string;//������֤����1
  Var_HideVali_1B:string;
  Var_HideVali_1E:string;
  Var_HideVali_2:string;//������֤����2
  Var_HideVali_2B:string;
  Var_HideVali_2E:string;
end;
function ImgRGB(tBmp:TBitmap;x,y:integer):string;//ȡ����RGBֵ   
function IntToBin(Value: Longint;Digits: Integer): string;// ʮ���� --> ������   
function BinToInt(Value: string): Integer;// ������ --> ʮ���� 
//�����ͻ����ַ���
Function IsInt(const sInt : String) : Boolean;
//��λͼת������֤��
function BMPToValidate(tBMP:tBitmap;BBSType:string='����7.0SP2';ValidateLen:integer=4;Mottle:integer=2):string;
//��������ַ���,�����ǳ���Ҫ��
function GetRndString(RNDLength:integer;keys:string='abcdefghijklmnopqrstuvwxyz'):string ;
//�������һЩ�ַ�
function RNDInsertString(tmpStr:string;iBreachLevel:integer;iType:integer=5;MyChar:string='`_^'):string;
//��ȡһ��BBS���ݵ�����   
procedure LoadBBSfromFile(var tmpbbs:onebbs;LoadType:string='all');
//����һ��BBS���ݵ�INI�ļ�
procedure SaveBBStoFile(tmpbbs:onebbs;SaveType:string='all');
//��ȡ����̳������ص�����
function GetBBSTypeSet(var tmpBBSType:oneBBSType):boolean;
//slog���ı�,showdlg����ʾ�Ի���,savetolog�Ǳ��浽�ı�,showsb����ʾ��״̬��,showpb�ǽ�����
procedure SaveLog(sLog:string;ShowDlg:boolean=false;
                  SaveToLog:boolean=false;ShowSB:boolean=true;ShowPB:boolean=false
                  ;PBint:integer=0);
{===========ȡ����֮����ִ�(������ַ)==================================================}
function GetURLBack(WebURL:string;GetType:integer=5):string;
{============ɾ���ַ����еĵ��ֽ��ַ�=======================================}
function DelByteChr(tmpstr:string):string;
{==============ɾ��û�õ��ʺ�===============================} 
procedure DelTrashinessAccount(tmpbbs:onebbs);
{=============����һ�����õ��ʺ�=====================================}
function SetAccount(var tmpbbs:onebbs;Index:integer=-1):boolean ;
{==========��ʱ����==================================} 
procedure AppSleep(SleepTime:ttime);
{=============����һ���ļ�������ļ�����(���ļ�����)===================================}
function FileCount(FileSpec: string;filelist:tstrings): longint;
{===========���Ӹ�Ŀ¼�µĽڵ�:(�ڵ�)checktree==================================================}
function AddChkTreeSec(var tv:trzchecktree;itemName:string;imgIndex:integer=2;imgSelIndex:integer=1):TTreeNode;
{===========������һ��Ŀ¼(����):chk========================================}
function AddChkTreeChild(var tv:trzchecktree;ParentNode:TTreeNode;ChildName:string;imgIndex:integer=4;imgSelIndex:integer=3):TTreeNode;
{===========������һ��Ŀ¼(����):========================================}
function AddTreeChild(var tv:trztreeview;ParentNode:TTreeNode;ChildName:string;imgIndex:integer=4;imgSelIndex:integer=3):TTreeNode;
{===ȡ�Ӵ�ǰ�������ַ�==================================================== } 
function PredString(SubStr,aStr:string):string;
{==========��¼����̳ ===================================================}
function LoginBBS(IdHTTP1:tidhttp;var tmpbbs:onebbs;idCookie:tidcookiemanager;index:integer=0):boolean;
{=========����====================================================}
function PostNew(var idhttp1:tidhttp;var tmpbbs:onebbs;idCookie:tidcookiemanager):boolean;
{=========�ظ���====================================================}
function PostRevert(var idhttp1:tidhttp;var tmpbbs:onebbs;idCookie:tidcookiemanager):boolean;
{==========�Ƿ��Ѿ���¼��̳ ===================================================}
function Logined(IdHTTP1:tidhttp;var tmpbbs:onebbs;idCookie:tidcookiemanager):boolean; 
{=========ע��====================================================}
function PostReg(var idhttp1:tidhttp;var tmpbbs:onebbs):boolean;  
{======��www.Ms4F.com��վ=================================================}
procedure OpenWWW(sWebUrl:string='www.Ms4F.com');
{=====����һ����ʱ�ļ���==================================================  
Create: �Ƿ񴴽��ļ� ,PreFix: �ļ���ǰ׺ ,Ext: �ļ���չ��  }
function GetTmpFileName(Create: Boolean = False;Prefix: string = '~~';Ext: string = '.TMP'):string; 
{=============ȥ����ɫ(���ַ��������.��������ͼƬ��༭=======================}
procedure CheckMottle(var A:string;imgH,oneW:integer;Mottle:integer=2); 
{===========��ǰʱ���ַ���(8���ַ�+�ո�)==============================}
function NowTime():string;
{============�������ִ���ȡ���ַ���======================================} 
function GetMidStr(TmpStr,StartStr,EndStr:string):string ;

var                      
  MyCookList:string;//ȫ�ֱ�����ȡ�õ�ǰ�û���Cookie
implementation                           

uses untBBS, ACPfrm_Splash; 
{=======================================================}
{===========��ǰʱ���ַ���(8���ַ�+�ո�)==============================}
function NowTime():string;
begin
  result:=rightstr('00'+timetostr(now),8)+#9;
end;  
{======��www.Ms4F.com��վ=================================================}
procedure OpenWWW(sWebUrl:string='www.Ms4F.com');
begin
  ShellExecute(application.Handle, 'open', pchar(sWebUrl), nil,nil, SW_SHOW);
end;
{=====����һ����ʱ�ļ���==================================================  
Create: �Ƿ񴴽��ļ� ,PreFix: �ļ���ǰ׺ ,Ext: �ļ���չ��  }
function GetTmpFileName(Create: Boolean = False;Prefix: string = '~~';Ext: string = '.TMP'):
  string;
var
  Buffer            : string;
  Len               : integer;
  UID               : integer;
begin
  Len := GetTempPath(0, nil) + 1;{ Get Temp Path Length }
  SetLength(Buffer, Len);{ Get Memory for Buffer }
  GetTempPath(Len, @Buffer[1]);{ Get Temp Path }
  SetLength(Result,MAX_PATH);
  Randomize;
  if Create then
    UID := 0
  else
    UID := Random($FFFFFFFF) + 1;
  repeat
    GetTempFileName(pchar(Buffer), pchar(Prefix), UID, @Result[1]);
    Result := ChangeFileExt(Result, Ext);
  until (not FileExists(Result)) or Create;
end;
{===ȡ�Ӵ�ǰ�������ַ�==================================================== } 
function PredString(SubStr,aStr:string):string;
begin                
  result:=copy(aStr,1,pos(SubStr,aStr)-1);
end;
{==========��ʱ����==================================} 
procedure AppSleep(SleepTime:ttime);
var time1:ttime;
begin
  application.ProcessMessages;
  if SleepTime=0 then exit;   
  if SleepTime>0 then SleepTime:=SleepTime / 86400;
  time1:=time;
  while (time1+SleepTime>time)and(time1-time<strtotime('1:00:00'))and (not frmbbs.closeme) 
    do application.ProcessMessages;
end;
{============ɾ���ַ����еĵ��ֽ��ַ�=======================================}
function DelByteChr(tmpstr:string):string;
var i:integer;a,s:string;
begin
  for i:=1 to length(tmpstr)-1 do
  begin
    a:=midstr(tmpstr,i,1);
    if ByteType(a,1)<>mbSingleByte then s:=s+a;
  end;
  result:=s;
end;
{===========ȡ����֮����ִ�(������ַ)==================================================}
function GetURLBack(WebURL:string;GetType:integer=5):string;
var //����ȡ����,�ʺ�,����,·����
  aURLC: TURLComponents;a:string;
begin   
  result:=weburl;
  FillChar(aURLC, SizeOf(TURLComponents), 0);
  with aURLC do 
  begin
    lpszScheme := nil;
    dwSchemeLength := INTERNET_MAX_SCHEME_LENGTH;
    lpszHostName := nil;
    dwHostNameLength := INTERNET_MAX_HOST_NAME_LENGTH;
    lpszUserName := nil;
    dwUserNameLength := INTERNET_MAX_USER_NAME_LENGTH;
    lpszPassword := nil;
    dwPasswordLength := INTERNET_MAX_PASSWORD_LENGTH;
    lpszUrlPath := nil;
    dwUrlPathLength := INTERNET_MAX_PATH_LENGTH;
    lpszExtraInfo := nil;
    dwExtraInfoLength := INTERNET_MAX_PATH_LENGTH;
    dwStructSize := SizeOf(aURLC);
  end;
  if InternetCrackUrl(PChar(WebURL), Length(WebURL), 0, aURLC) then
  begin
    a:=leftstr(aURLC.lpszHostName,pos('/',aURLC.lpszHostName)-1);
    case GetType of
    1:result:=aURLC.lpszScheme ;//ԭ��
    2:result:=aURLC.lpszHostName;//������
    3:result:=aURLC.lpszUserName;//�û���
    4:result:=aURLC.lpszPassword;//����
    5:result:=aURLC.lpszUrlPath;//·��
    6:result:=aURLC.lpszExtraInfo;//��չ��Ϣ
    7:if a='' then result:=aURLC.lpszHostName else result:=a;
    end;
  end;
end;
{========�����ͻ����ַ���============================================================} 
Function IsInt(const sInt : String) : Boolean;
Begin 
 try
   StrToInt(sInt);
   Result := True;
 except
   On EConvertError Do
    Result := False;
 end;
End;
{==========״̬��===================================================}                                                                               
//slog���ı�,showdlg����ʾ�Ի���,savetolog�Ǳ��浽�ı�,showsb����ʾ��״̬��,showpb�ǽ�����
procedure SaveLog(sLog:string;ShowDlg:boolean=false;
                  SaveToLog:boolean=false;ShowSB:boolean=true;ShowPB:boolean=false
                  ;PBint:integer=0);
begin
  if showdlg and frmbbs.Set_ShowMessage.checked then showmessage(slog);//��ʾ��ʾ�Ի���
  if savetolog and frmbbs.Set_savetolog.checked then //���浽�ļ�
    frmbbs.log.Items.Add(timetostr(time)+#9+slog);
  if showsb then frmbbs.SB.Caption:=slog;//��ʾ״̬��
  frmbbs.PB.Visible:=showpb;//��ʾ������
  frmbbs.pb.Percent:=pbint;//�ٷֱ�
  application.ProcessMessages;
end;
{=====================��ȡ����̳������ص�����========================================}
function GetBBSTypeSet(var tmpBBSType:oneBBSType):boolean;
var tini:tinifile;t:string;
begin
try
  t:=tmpbbstype.Name;
  tini:=tinifile.Create('.\webtype.ini');
  tmpbbstype.FileName_Validate:=(tini.ReadString(t,'��֤�ļ�',''));
  tmpbbstype.validatelength:=(tini.ReadInteger(t,'��֤�볤��',4));
  tmpbbstype.URL_Reg :=tini.ReadString(t,'ע���ַ','');    
  tmpbbstype.URL_RegSubmit :=tini.ReadString(t,'ע���ύ','');  
  tmpbbstype.URL_Login :=tini.ReadString(t,'��¼','');
  tmpbbstype.URL_Logout:=tini.ReadString(t,'�˳�','');
  tmpbbstype.URL_New_B:=tini.ReadString(t,'������ַB','');
  tmpbbstype.URL_NewSubmit_B:=tini.ReadString(t,'�����ύB','');
  tmpbbstype.URL_RevertSubmit_B:=tini.ReadString(t,'�ظ��ύB','');
                                         
  tmpbbstype.Error_LimitTime:=tini.ReadString(t,'ʱ������','');
  tmpbbstype.Error_EstopIP:=tini.ReadString(t,'��ֹIP','');
  tmpbbstype.Error_EstopAccount:=tini.ReadString(t,'��ֹ�ʺ�','');
  tmpbbstype.Error_NewOK:=tini.ReadString(t,'�����ɹ�','');
  tmpbbstype.Error_RegOK:=tini.ReadString(t,'ע��ɹ�','');
  tmpbbstype.Error_RevertOK:=tini.ReadString(t,'�ظ��ɹ�','');
  tmpbbstype.Error_LoginOK:=tini.ReadString(t,'��¼�ɹ�','');
  tmpbbstype.Error_Logined:=tini.ReadString(t,'�ѵ�¼','');
  tmpbbstype.Error_Start:=tini.ReadString(t,'������Ϣ','');
  tmpbbstype.Error_Validata:=tini.ReadString(t,'��֤�����','');
     
  tmpbbstype.BBS2_B :=uppercase(tini.ReadString(t,'��̳B',''));
  tmpbbstype.BBS2_E :=uppercase(tini.ReadString(t,'��̳E',''));
  tmpbbstype.BBS2_NameB :=uppercase(tini.ReadString(t,'��̳����B',''));
  tmpbbstype.BBS2_NameE :=uppercase(tini.ReadString(t,'��̳����E',''));
  
  tmpbbstype.Var_BoardId:=(tini.ReadString(t,'�������',''));
  tmpbbstype.Var_Validate:=(tini.ReadString(t,'��֤����','')); 
  tmpbbstype.Var_HideVali_1:=(tini.ReadString(t,'���ر���1',''));
  tmpbbstype.Var_HideVali_1B:=(tini.ReadString(t,'���ر���1B',''));
  tmpbbstype.Var_HideVali_1E:=(tini.ReadString(t,'���ر���1E',''));
  tmpbbstype.Var_HideVali_2:=(tini.ReadString(t,'���ر���2',''));
  tmpbbstype.Var_HideVali_2B:=(tini.ReadString(t,'���ر���2B',''));
  tmpbbstype.Var_HideVali_2E:=(tini.ReadString(t,'���ر���2E',''));
  
  tmpbbstype.Var_Reg_Acc:=(tini.ReadString(t,'ע���ʺű���',''));
  tmpbbstype.Var_Reg_Pass1:=(tini.ReadString(t,'ע������1����',''));
  tmpbbstype.Var_Reg_Pass2:=(tini.ReadString(t,'ע������2����',''));
  tmpbbstype.Var_Reg_Ask1:=(tini.ReadString(t,'ע������1����',''));
  tmpbbstype.Var_Reg_Answer1:=(tini.ReadString(t,'ע��ش�1����',''));
  tmpbbstype.Var_Reg_Ask2:=(tini.ReadString(t,'ע������2����',''));
  tmpbbstype.Var_Reg_Answer2:=(tini.ReadString(t,'ע��ش�2����',''));
  tmpbbstype.Var_Reg_eMail:=(tini.ReadString(t,'ע���������',''));
  
  tmpbbstype.Var_Login_Account :=(tini.ReadString(t,'��¼�ʺű���',''));
  tmpbbstype.Var_Login_Password :=(tini.ReadString(t,'��¼�������',''));
  
  tmpbbstype.Var_New_Account:=(tini.ReadString(t,'�����ʺű���',''));
  tmpbbstype.Var_New_Password:=(tini.ReadString(t,'�����������',''));
  tmpbbstype.Var_New_Main:=(tini.ReadString(t,'�����������',''));
  tmpbbstype.Var_New_Memo:=(tini.ReadString(t,'�������ݱ���',''));
  
  tmpbbstype.Var_Revert_Account:=(tini.ReadString(t,'�ظ��ʺű���',''));
  tmpbbstype.Var_Revert_Password:=(tini.ReadString(t,'�ظ��������',''));
  tmpbbstype.Var_Revert_Memo:=(tini.ReadString(t,'�ظ����ݱ���',''));
  tmpbbstype.var_revert_followID:=(tini.ReadString(t,'�ظ�¥�ϱ���',''));
  tmpbbstype.var_revert_rootid:=(tini.ReadString(t,'�ظ���¥����',''));
  result:=true;
except result:=false;end;
  freeandnil(tini);
end;
{=================����һ��BBS���ݵ�INI�ļ�==all=account=login=====================================}
procedure SaveBBStoFile(tmpbbs:onebbs;SaveType:string='all');
var tini:tinifile;t,m:string;i,j,k:integer;
begin                                                  
  t:=tmpbbs.Name;
  if t='' then 
  begin
    savelog('��վ����û���ҵ�:'+t);
    exit;
  end;
  m:='.\Web\';
  if not directoryexists(m) then createdir(m);
  m:=m+t+'.ini';
  if (SaveType='all') and fileexists(m) then deletefile(m);
  tini:=tinifile.Create(m); 
  if ansicontainstext(SaveType,'all')then
  begin               
    tini.WriteString(t,'��ҳ',tmpbbs.URL);
    tini.WriteString(t,'����',tmpbbs.sType);
    tini.WriteBool (t,'ע��״̬',tmpbbs.State_Reg);
    tini.Writeinteger(t,'����״̬',tmpbbs.State_New); 
    tini.Writeinteger(t,'�ظ�״̬',tmpbbs.State_Revert);
     
    tini.WriteString(t,'��֤�ļ�',tmpbbs.FileName_Validate );
    tini.WriteInteger(t,'��֤�볤��',tmpbbs.ValidateLength);
    tini.WriteString(t,'ע���ַ',tmpbbs.URL_Reg);
    tini.WriteString(t,'ע���ύ',tmpbbs.URL_RegSubmit);
    tini.WriteString(t,'��¼',tmpbbs.URL_LogIn);
    tini.WriteString(t,'�˳�',tmpbbs.URL_LogOut); 
    tini.WriteString(t,'������ַB',tmpbbs.URL_New_B);
    tini.WriteString(t,'�����ύB',tmpbbs.URL_NewSubmit_B);
    tini.WriteString(t,'�ظ��ύB',tmpbbs.URL_RevertSubmit_B);
    
    tini.WriteString(t,'�����ɹ�',tmpbbs.Error_NewOK);
    tini.WriteString(t,'ע��ɹ� ',tmpbbs.Error_RegOK);
    tini.WriteString(t,'�ظ��ɹ�',tmpbbs.Error_RevertOK);
    tini.WriteString(t,'��¼�ɹ�',tmpbbs.Error_LoginOK);
    tini.WriteString(t,'ʱ������',tmpbbs.Error_LimitTime);
    tini.WriteString(t,'��ֹIP',tmpbbs.Error_EstopIP);
    tini.WriteString(t,'��ֹ�ʺ�',tmpbbs.Error_EstopAccount);
    tini.WriteString(t,'�ѵ�¼',tmpbbs.Error_Logined);
    tini.WriteString(t,'������Ϣ',tmpbbs.Error_Start);
    tini.WriteString(t,'��֤�����',tmpbbs.Error_Validata);
    
    tini.WriteString(t,'ע���ʺű���',tmpbbs.var_Reg_Acc );
    tini.WriteString(t,'ע������1����',tmpbbs.var_Reg_Pass1 );
    tini.WriteString(t,'ע������2����',tmpbbs.var_Reg_Pass2 );
    tini.WriteString(t,'ע������1����',tmpbbs.var_Reg_Ask1 );
    tini.WriteString(t,'ע������2����',tmpbbs.var_Reg_Ask2 );
    tini.WriteString(t,'ע��ش�1����',tmpbbs.var_Reg_Answer1 );
    tini.WriteString(t,'ע��ش�2����',tmpbbs.var_Reg_Answer2 );
    tini.WriteString(t,'ע���������',tmpbbs.var_Reg_eMail );
    
    tini.WriteString(t,'��¼�ʺű���',tmpbbs.Var_Login_Account );
    tini.WriteString(t,'��¼�������',tmpbbs.Var_Login_Password );
    
    tini.WriteString(t,'�ظ��ʺű���',tmpbbs.Var_Revert_Account);
    tini.WriteString(t,'�ظ��������',tmpbbs.Var_Revert_Password);
    tini.WriteString(t,'�ظ����ݱ���',tmpbbs.Var_Revert_Memo);
    tini.WriteString(t,'�ظ�¥�ϱ���',tmpbbs.var_revert_followID);
    tini.WriteString(t,'�ظ���¥����',tmpbbs.var_revert_rootid);

    tini.WriteString(t,'�����ʺű���',tmpbbs.Var_New_Account );
    tini.WriteString(t,'�����������',tmpbbs.Var_New_Password );
    tini.WriteString(t,'�����������',tmpbbs.Var_New_Main );
    tini.WriteString(t,'�������ݱ���',tmpbbs.Var_New_Memo );
    
    tini.WriteString(t,'�������',tmpbbs.Var_BoardId);
    tini.WriteString(t,'��֤����',tmpbbs.Var_Validate );
    tini.WriteString(t,'���ر���1',tmpbbs.Var_HideVali_1 );
    tini.WriteString(t,'���ر���1B',tmpbbs.Var_HideVali_1B );
    tini.WriteString(t,'���ر���1E',tmpbbs.Var_HideVali_1E );
    tini.WriteString(t,'���ر���2',tmpbbs.Var_HideVali_2 );
    tini.WriteString(t,'���ر���2B',tmpbbs.Var_HideVali_2B );
    tini.WriteString(t,'���ر���2E',tmpbbs.Var_HideVali_2E);
    i:=0;j:=0;
    while i<tmpbbs.BBS2Count do//��̳���� 
    begin
      application.ProcessMessages;
      if tmpbbs.bbs2[i].URL<>'' then 
      begin //ɾ����ַΪ�յķ�̳
        tini.WriteString(t,'��̳'+inttostr(j)+'����',tmpbbs.bbs2[i].Name );
        tini.WriteString(t,'��̳'+inttostr(j)+'URL',tmpbbs.bbs2[i].URL);
        tini.WriteInteger(t,'��̳'+inttostr(j)+'״̬',tmpbbs.bbs2[i].State );
        inc(j); 
      end;
      inc(i);
    end;
    tini.WriteInteger(t,'��̳��',j);     
    k:=tmpbbs.RevartCount ;//�ظ�����   
    tini.WriteInteger(t,'�ظ���',k);
    for i:=0 to k-1 do 
    begin
      application.ProcessMessages;
      tini.WriteString(t,'�ظ�'+inttostr(i),tmpbbs.Revart[i].URL);
      tini.Writeinteger(t,'�ظ�'+inttostr(i)+'״̬',tmpbbs.Revart[i].State);
    end;
  end;
  if ansicontainstext(SaveType,'all')or ansicontainstext(SaveType,'account')then
  begin                              
    tini.WriteInteger(t,'�ʺ�����',tmpbbs.AccountIndex );
    i:=0;j:=0;
    while i<tmpbbs.AccountCount do//�ʺ����� 
    begin
      if tmpbbs.account[i].state or not frmbbs.Set_DelEstopAccount.Checked then 
      begin //�Զ�ɾ���������ʺ�
        tini.WriteString(t,'�ʺ�'+inttostr(j),tmpbbs.account[i].Account );
        tini.WriteBool (t,'�ʺ�'+inttostr(j)+'״̬',tmpbbs.account[i].State );
        tini.WriteString(t,'����'+inttostr(j),tmpbbs.account[i].Password);
        inc(j); 
      end;
      inc(i);
      application.ProcessMessages;
    end;
    tini.WriteInteger(t,'�ʺ���',j);
  end;
  if ansicontainstext(SaveType,'all')or ansicontainstext(SaveType,'login')then
  begin                       
    tini.WriteString(t,'cookie',tmpbbs.Cookie );
  end;
  if ansicontainstext(SaveType,'AddAcc')then//����ʺ�
  begin
    i:=tini.ReadInteger(t,'�ʺ���',0);
    tini.WriteString(t,'�ʺ�'+inttostr(i),tmpbbs.Value_Account);
    tini.WriteBool (t,'�ʺ�'+inttostr(i)+'״̬',true);
    tini.WriteString(t,'����'+inttostr(i),tmpbbs.Value_Password);
    tini.WriteInteger(t,'�ʺ���',i+1);
  end;
  freeandnil(tini);
end;
{=================��ȡһ��BBS���ݵ�����==all=reg=login=new=revert======================}
procedure LoadBBSfromFile(var tmpbbs:onebbs;LoadType:string='all');
var tini:tinifile;t,m:string;i,k:integer;b:boolean;
begin 
  t:=tmpbbs.Name;
  m:='.\web\';
  if not directoryexists(m) then createdir(m);
  tini:=tinifile.Create(m + t + '.ini');
  tmpbbs.URL:=tini.ReadString(T,'��ҳ','');
  tmpbbs.sType:=tini.ReadString(T,'����','');
  tmpbbs.Cookie:=tini.ReadString(t,'cookie','');
  tmpbbs.FileName_Validate:=tini.ReadString(t,'��֤�ļ�','');
  tmpbbs.ValidateLength:=tini.ReadInteger(t,'��֤�볤��',4);
  
  tmpbbs.Error_LimitTime :=tini.ReadString(t,'ʱ������','');
  tmpbbs.Error_EstopIP :=tini.ReadString(t,'��ֹIP','');
  tmpbbs.Error_EstopAccount :=tini.ReadString(t,'��ֹ�ʺ�','');  
  tmpbbs.Error_Logined :=tini.ReadString(t,'�ѵ�¼','');
  tmpbbs.Error_Start:=tini.ReadString(t,'������Ϣ','');
  tmpbbs.Error_Validata:=tini.ReadString(t,'��֤�����','');
  
  tmpbbs.Var_BoardId:=(tini.ReadString(t,'�������',''));
  tmpbbs.var_Validate:=(tini.ReadString(t,'��֤����',''));
  tmpbbs.Var_HideVali_1:=(tini.ReadString(t,'���ر���1',''));
  tmpbbs.Var_HideVali_1B:=(tini.ReadString(t,'���ر���1B',''));
  tmpbbs.Var_HideVali_1E:=(tini.ReadString(t,'���ر���1E',''));
  tmpbbs.Var_HideVali_2:=(tini.ReadString(t,'���ر���2',''));
  tmpbbs.Var_HideVali_2B:=(tini.ReadString(t,'���ر���2B',''));
  tmpbbs.Var_HideVali_2E:=(tini.ReadString(t,'���ر���2E',''));
  tmpbbs.AccountIndex := tini.ReadInteger(t,'�ʺ�����',0);//�ʺ�����
  k:= tini.ReadInteger(t,'�ʺ���',0);//�ʺ�����
  tmpbbs.AccountCount:=k;
  if k>0 then 
  begin
    setlength(tmpbbs.account,k);
    for i:=0 to k-1 do 
    begin
      b:=tini.ReadBool (t,'�ʺ�'+inttostr(i)+'״̬',true);
      tmpbbs.account[i].Account:=tini.ReadString(t,'�ʺ�'+inttostr(i),'');
      tmpbbs.account[i].State:=b;
      tmpbbs.account[i].Password:=tini.ReadString(t,'����'+inttostr(i),'');
      application.ProcessMessages;
    end;
  end;
  if ansicontainstext(LoadType,'all') then 
  begin 
    tmpbbs.sType:=tini.ReadString(t,'����','');
    tmpbbs.State_Reg:=tini.ReadBool(t,'ע��״̬',false);
    tmpbbs.State_New:=tini.Readinteger(t,'����״̬',1);
    tmpbbs.State_Revert:=tini.Readinteger(t,'�ظ�״̬',1);
    k:= tini.ReadInteger(t,'�ظ���',0);//�ظ�����
    tmpbbs.RevartCount:=k;
    if k>0 then 
    begin
      setlength(tmpbbs.Revart,k);
      for i:=0 to k-1 do 
      begin
        application.ProcessMessages;
        tmpbbs.Revart[i].URL:=tini.ReadString(t,'�ظ�'+inttostr(i),'');
        tmpbbs.Revart[i].State:=tini.Readinteger(t,'�ظ�'+inttostr(i)+'״̬',1);
      end;
    end;
  end;                                               
  if ansicontainstext(LoadType,'all')or ansicontainstext(LoadType,'reg') then 
  begin 
    tmpbbs.URL_Reg :=tini.ReadString(t,'ע���ַ',''); 
    tmpbbs.URL_RegSubmit :=tini.ReadString(t,'ע���ύ',''); 
    tmpbbs.Error_RegOK :=tini.ReadString(t,'ע��ɹ�','');
    tmpbbs.var_Reg_Acc:=(tini.ReadString(t,'ע���ʺű���',''));
    tmpbbs.var_Reg_Pass1:=(tini.ReadString(t,'ע������1����',''));
    tmpbbs.var_Reg_Pass2:=(tini.ReadString(t,'ע������2����',''));
    tmpbbs.var_Reg_Ask1:=(tini.ReadString(t,'ע������1����',''));
    tmpbbs.var_Reg_Ask2:=(tini.ReadString(t,'ע������2����',''));
    tmpbbs.var_Reg_Answer1:=(tini.ReadString(t,'ע��ش�1����',''));
    tmpbbs.var_Reg_Answer2:=(tini.ReadString(t,'ע��ش�2����',''));
    tmpbbs.var_Reg_eMail:=(tini.ReadString(t,'ע���������',''));
  end;
  if ansicontainstext(LoadType,'all')or ansicontainstext(LoadType,'new') then 
  begin                                   
    tmpbbs.URL_New_B:=tini.ReadString(t,'������ַB','');
    tmpbbs.URL_NewSubmit_B:=tini.ReadString(t,'�����ύB','');
    tmpbbs.Error_NewOK :=tini.ReadString(t,'�����ɹ�',''); 
    tmpbbs.Var_New_Account:=(tini.ReadString(t,'�����ʺű���',''));
    tmpbbs.Var_New_Password:=(tini.ReadString(t,'�����������',''));
    tmpbbs.Var_New_Main:=(tini.ReadString(t,'�����������',''));
    tmpbbs.Var_New_Memo:=(tini.ReadString(t,'�������ݱ���',''));
    k:= tini.ReadInteger(t,'��̳��',0);//��̳����
    tmpbbs.BBS2Count:=k;
    if k>0 then 
    begin
      setlength(tmpbbs.BBS2,k);
      for i:=0 to k-1 do 
      begin
        application.ProcessMessages;
        tmpbbs.BBS2[i].Name:=tini.ReadString(t,'��̳'+inttostr(i)+'����','');
        tmpbbs.BBS2[i].URL:=tini.ReadString(t,'��̳'+inttostr(i)+'URL','');
        tmpbbs.BBS2[i].State:=tini.Readinteger (t,'��̳'+inttostr(i)+'״̬',1);
      end;
    end;
  end;
  if ansicontainstext(LoadType,'all')or ansicontainstext(LoadType,'revert') then 
  begin                       
    tmpbbs.URL_RevertSubmit_B:=tini.ReadString(t,'�ظ��ύB',''); 
    tmpbbs.Error_RevertOK :=tini.ReadString(t,'�ظ��ɹ�','');
    tmpbbs.Var_Revert_Account:=(tini.ReadString(t,'�ظ��ʺű���',''));
    tmpbbs.Var_Revert_Password:=(tini.ReadString(t,'�ظ��������',''));
    tmpbbs.Var_Revert_Memo:=(tini.ReadString(t,'�ظ����ݱ���',''));
    tmpbbs.var_revert_followid:=(tini.ReadString(t,'�ظ�¥�ϱ���',''));
    tmpbbs.Var_Revert_RootId:=(tini.ReadString(t,'�ظ���¥����',''));
  end;
  if ansicontainstext(LoadType,'all')or ansicontainstext(LoadType,'login') then 
  begin                                        
    tmpbbs.URL_LogIn :=tini.ReadString(t,'��¼','');
    tmpbbs.URL_LogOut :=tini.ReadString(t,'�˳�','');
    tmpbbs.Error_LoginOK :=tini.ReadString(t,'��¼�ɹ�','');
    tmpbbs.Var_Login_Account :=(tini.ReadString(t,'��¼�ʺű���',''));
    tmpbbs.Var_Login_Password :=(tini.ReadString(t,'��¼�������',''));
  end;
  freeandnil(tini);
end;
{================ ������ --> ʮ����=============================================} 
function BinToInt(Value: string): Integer;
var
  i, iValueSize: Integer;
begin
  Result := 0;
  iValueSize := Length(Value);
  for i := iValueSize downto 1 do
    if Value[i] = '1' then Result := Result + (1 shl (iValueSize - i));
end;
{=======ʮ���� --> ������========} 
function IntToBin(Value: Longint;Digits: Integer): string;
var
  i: Integer;
begin
  Result := '';
  for i := Digits downto 0 do
    if Value and (1 shl i) <> 0 then
      Result := Result + '1'
  else
    Result := Result + '0';
end;
{===============} 
function oneDBtoBin(oneDB:string;imgH,oneW:integer;tabWidth:integer=4):string;
var i,x:integer;t:string;
begin//��ȡ�����������ݿ����һ������,�����﷭��ɶ����Ʒ���ȥ
  if length(onedb)=0 then exit;
  t:='';
  for i:=1 to imgH do
  begin
    x:=strtoint(trim(copy(onedb,(i-1)*tabWidth+1,tabWidth)));//ȡһ�е����ֽ��,���4λ
    t:=t+inttobin(x,onew-1);//ת��2����
  end;//FOR imgH
  result:=t;
end;
{=============================================================}
function ImgRGB(tBmp:TBitmap;x,y:integer):string;
var//�õ�ͼ����ĳһ���RGBֵ
  red,green,blue:byte;
  i:integer;
begin
  i:= tBmp.Canvas.Pixels[x,y];
  Blue:=GetBValue(i);
  Green:=GetGValue(i);
  Red:= GetRValue(i);
  result:=inttostr(Red) + inttostr(green) + inttostr(blue);
end;//}                                                        
{=============ȥ����ɫ(���ַ��������.��������ͼƬ��༭=======================}
procedure CheckMottle(var A:string;imgH,oneW:integer;Mottle:integer=2);
//type dian =record  id:integer;value:integer;end;
var i,j,k,m:integer;n:array of integer;b:boolean;
begin{��ĸi��j����ʱע��Ҫ��Դ���ݿ���Ͱ���������ĵ㵱����ɫȥ��.}
try
  if Mottle<1 then exit;
  k:=sqr(Mottle*2+1);//��Χ�������         9
  m:=length(a);//���ص������             100
  setlength(n,k+1);//                     101
  for i:=1 to m do//ÿ���㶼Ҫ���һ��
  begin  
    if a[i]='0' then continue;//��0�ľ����� ,���Ϊ1��Ҫ���:    
    for j:=0 to k do n[j] :=0;//��ʼ��n�ṹ���ֵ
    b:=false;//������ɫ���  
{1	2	  3 ����ֻ��ȡ��Щ����ĵ�ַ����:
11	12	13
21	22	23}                     
    //����С��Χ������Ƿ������ڵĵ� 
    n[1]:=i-onew-1;n[2]:=i-onew;n[3]:=i-onew+1;n[4]:=i-1;n[5]:=i+1;n[6]:=i+onew-1;n[7]:=i+onew;n[8]:=i+onew+1;
    for j:=1 to 8 do //����
      if (n[j]>0) and (n[j]<=m) then//�����±�Խ�����
        if a[n[j]]='1' then//�Ƚ��Ƿ���'1' 
          begin          
            b:=true;//����ڱ������Χ��'1',Ҳ���Ǳ��㲻����ɫ(С��Χ��)
            break;
          end;
    //С��Χ���ҵ���.���ڴ�Χ�����
    if b and (Mottle=2) then
    begin
      b:=false;
{1	2	  3	  4	  5
11				      15
21		  23		  25
31				      35
41	42	43	44	45}     
      n[9]:=i-onew*2-2;n[10]:=i-onew*2-1;n[11]:=i-onew*2;n[12]:=i-onew*2+1;n[13]:=i-onew*2+2;n[14]:=i-onew-2;n[15]:=i-onew+2;n[16]:=i-2;n[17]:=i+2;n[18]:=i+onew-2;n[19]:=i+onew+2;n[20]:=i+onew*2-2;n[21]:=i+onew*2-1;n[22]:=i+onew*2;n[23]:=i+onew*2+1;n[24]:=i+onew*2+2;
      for j:=9 to 24 do //����
        if (n[j]>0) and (n[j]<=m) then//�����±�Խ�����
          if a[n[j] ]='1' then//�Ƚ��Ƿ���'1' 
            begin          
              b:=true;//�����'1'
              break;
            end;
    end;//h=2��Χ,С��Χ���Ѿ��е�����
    if not b then a[i]:='0';//����Χû���ҵ�'1',��ȥ�������
  end;//��һ����
except
end;
end;
{==========�Ѷ������ִ���������ֻ���ĸ===================================================} 
function StrToValidate(tmpstr:string;imgH,oneW:integer;FontType:string='����7.0SP2'):string;
var i,j,k,s,h:integer;c:string;
  //onefont:TStrings;tINI:tinifile;
begin
  result:='';
  with frmbbs do begin
  {tINI:=tinifile.Create('.\Validate.mdb');//��֤�����ݿ�
  onefont:=tstringlist.create;
  try
    tini.ReadSectionValues(fonttype,onefont);}
    if ansicontainstext(MemoValidata.Text ,tmpstr+'=')then
    begin
      for i:=0 to MemoValidata.Lines.Count-1 do
      begin
        if ansistartstext(tmpstr+'=',MemoValidata.Lines[i]) then begin
//        c:=leftbstr(onefont.Strings[i],pos('=',onefont.Strings[i])-1);
//        if c=tmpstr then //�ҵ�����ȫƥ���
//          result:=tini.readstring(fonttype,c,'');
          result:=rightstr(MemoValidata.Lines[i],1);
          break;
        end;  
      end;//for}
    end else 
    begin//if���û���ҵ�����ģ�����ҵķ�ʽ(���������бȽ�.ֻҪ��98%����ȷ�ʾ��� 
      s:=0;h:=0;
      for i :=0 to MemoValidata.Lines.Count-1 do begin//������ʵ���Ƿ���,�����ݿ���ȡһ���Ƚ�һ��.ֱ���ҵ�һ���Ƚ�ƥ���
        c:=leftbstr(MemoValidata.Lines[i],pos('=',MemoValidata.Lines[i])-1);
        k:=0;
        for j:=0 to length(c)-1 do
          if c[j]=tmpstr[j] then inc(k);//ͳ��ÿ���ֵ�ƥ����
        if k>s then begin 
          s:=k;//�ҳ�ƥ������ߵ�������
          h:=i;
        end;
      end;//for i:=0 ���е��ֱȽ�
      c:=MemoValidata.Lines[h];
      result:=rightbstr(c,length(c)-pos('=',c));
    end; //if
  //finally freeandnil(onefont);end;
  end;
end;
{==================��λͼת������֤��===========================================} 
function BMPToValidate(tBMP:tBitmap;BBSType:string='����7.0SP2';ValidateLen:integer=4;Mottle:integer=2):string;
var imgH,imgW,oneW,i,j,nIndex:integer;a,b,x,backcolor:string;
begin  //ValidateLen��֤������    
  result:='';
  tBMP.PixelFormat:=pf8bit;//ת����256ɫλͼ
  imgH:=tBMP.Height;//ȡͼƬ��
  imgW:=tBMP.Width;//��
  oneW:=imgw div ValidateLen;//ÿ���ֵĿ��
  backcolor:=imgrgb(tbmp,imgw-1,imgh-1);//�����½�Ϊ����ɫ
  for nIndex:=1 to ValidateLen do //ѭ��ȡ��,һ����4����  
  begin       
    a:='';
    for i:=1 to imgH do//���д���
    begin
      for j:=1 to oneW do //ÿ��
      begin
        b:=ImgRGB(tBMP ,j-1+(nIndex-1)*onew,i-1);//ȡһ�����RGBֵ
        if b=backcolor then a:=a+'0' else a:=a+'1';//����ɫ��+0����+1
      end;//for oneW
    end;//for imgH 
    //������ʹ�������һ����           
    //CheckMottle(a,imgh,onew,Mottle);//ȥ����ɫ
    x:=x+StrToValidate(a,imgh,onew,BBSType);//���ַ���ת������֤��
  end;//for nIndex  
  if length(x)=ValidateLen then 
    result:=x;
end;
{==================ȡ����֤��=========================} 
function GetValidate(var idhttp1:tidhttp;var tmpbbs:onebbs):boolean;
var tbmp:tbitmap;t:TmemoryStream;s:string;
begin
  tbmp:=tbitmap.Create;
  t:=TmemoryStream.Create;
  try                 
    try idhttp1.Get(tmpbbs.URL + tmpbbs.FileName_Validate,t);except end;
    application.ProcessMessages;
    s:=GetTmpFileName(true,'~~','.bmp');
    t.SaveToFile(s);
    tbmp.LoadFromFile(s);
    deletefile(s);
    tmpbbs.Value_Validate:=BMPToValidate(tbmp,tmpbbs.sType,tmpbbs.ValidateLength);//��֤��
    result:=true; 
  finally 
    freeandnil(tbmp);
    freeandnil(t);
  end;
end;
{==========��������ַ���,�����ǳ���Ҫ��===================================================}
function GetRndString(RNDLength:integer;keys:string='abcdefghijklmnopqrstuvwxyz'):string ;
var i,k:integer;a:string;
begin
  Randomize;
  k:=length(keys);
  for i:=1 to RNDLength do a:=a+keys[random(k)+1];
  result:=a;
end;
{==============�������һЩ�ַ�===============================================}
function InsertString(subStr:string;DestStr:string;index:integer):string;
begin
  if ByteType(deststr,index)=mbTrailByte then index:=index+1;//��������һ���ֽ�
  insert(substr,deststr,index);
  result:=deststr;
end;
{==============�������һЩ�ַ�===============================================} 
function RNDInsertString(tmpStr:string;iBreachLevel:integer;iType:integer=5;MyChar:string='`_^'):string;
{˵��:tmpStr:Ҫ��������ַ�
iType:0:�ײ���β��,1:���λ�ò���һ���ַ�,2:ÿ��һ���ַ�����һ���ַ�
      3:���λ�ò���ո�,4:ÿ��һ���ַ�����һ���ո�,5:�Զ����ַ�������} 
var i,k,m:integer;a:string;
begin
  Randomize;
  k:=length(tmpStr);
  m:=random(k div iBreachLevel)+(k div iBreachLevel);
  case itype of
  0:tmpStr:=GetRndString(1)+tmpstr+GetRndString(1);
  1:for i:=m downto 2 do begin InsertString(GetRndString(1),tmpstr,random(k));application.ProcessMessages;end;
  2:for i:=k-1 downto 2 do begin InsertString(GetRndString(1),tmpstr,i);application.ProcessMessages;end;
  3:for i:=m downto 2 do begin InsertString(' ',tmpstr,random(k));application.ProcessMessages;end;
  4:for i:=k-1 downto 2 do begin InsertString(' ',tmpstr,i);application.ProcessMessages;end;
  5:for i:=m downto 2 do 
  begin 
    a:=midstr(mychar,random(length(mychar))+1,1);
    tmpstr:=InsertString(a,tmpstr,random(k));
    application.ProcessMessages;
  end;
  end;
  result:=tmpStr;
end;
{=============����һ�����õ��ʺ�=====================================}
function SetAccount(var tmpbbs:onebbs;Index:integer=-1):boolean ;
var i:integer;tmpini:tinifile;
begin
  result:=false;
  if tmpbbs.AccountCount <1 then exit;
  if tmpbbs.AccountIndex >=tmpbbs.AccountCount-1 then tmpbbs.AccountIndex :=1 else inc(tmpbbs.AccountIndex);
  if index<>-1 then
  begin              
    tmpbbs.Value_Account:=tmpbbs.account[index].Account;
    tmpbbs.Value_Password:=tmpbbs.account[index].Password;
    result:=true;
  end else
  begin
    tmpbbs.Value_Account:=tmpbbs.account[tmpbbs.accountindex-1].Account;
    tmpbbs.Value_Password:=tmpbbs.account[tmpbbs.accountindex-1].Password;
    //���ʺŲ����õ�ʱ��Ż�
    if frmbbs.Set_Acc_AutoUse.Checked then
      for i:=0 to tmpbbs.AccountCount-1 do
      if (tmpbbs.Value_Account =tmpbbs.Account[i].Account ) and (tmpbbs.Account[i].State) then  
      begin
        result:=true;
        break;
      end;
    //ÿ�ζ����ʺ�(���ϴ�ʹ�õ��ʺŲ����õ�ʱ��)
    if not result or frmbbs.Set_Acc_EveryChg.Checked then
      for i:=tmpbbs.AccountIndex to tmpbbs.AccountCount-1 do
        if tmpbbs.Account[i].State then
        begin
          tmpbbs.Value_Account:=tmpbbs.account[i].Account;
          tmpbbs.Value_Password:=tmpbbs.account[i].Password;
          result:=true;
          break;
        end;
    //���浱ǰȡ���ʺ�����
    tmpini:=tinifile.Create('.\web\'+tmpbbs.Name +'.ini');
    tmpini.WriteInteger(tmpbbs.Name ,'�ʺ�����',tmpbbs.AccountIndex );
  end;
end;
{==============ɾ��û��(���ظ�)���ʺ�===============================} 
procedure DelTrashinessAccount(tmpbbs:onebbs);
var i,j:integer;
begin
try
  i:=0;
  while i<=tmpbbs.AccountCount-1 do
  begin                      
    //ɾ���ظ����ʺ�
    for j:=0 to i-1 do
    begin
      if tmpbbs.Account[j].Account =tmpbbs.Account[i].Account then
        tmpbbs.Account[i].State:=false;
    end;
    //ɾ��״̬Ϊ�����õ��ʺ�
    if not tmpbbs.Account[i].State then
    begin
      for j:=i to tmpbbs.AccountCount-2 do
      begin
        tmpbbs.Account[j].Account:=tmpbbs.Account[j+1].Account;
        tmpbbs.Account[j].Password:=tmpbbs.Account[j+1].Password;
        tmpbbs.Account[j].State:=tmpbbs.Account[j+1].State;
      end;
      tmpbbs.AccountCount:=tmpbbs.AccountCount-1;
      setlength(tmpbbs.Account ,tmpbbs.AccountCount);
    end;
    i:=i+1;
  end;
except end;
  savebbstofile(tmpbbs,'account');
end;
{=============����һ���ļ�������ļ�����(���ļ�����)=�������ļ����б�===========}
function FileCount(FileSpec: string;filelist:tstrings): longint;
var
  SR: TSearchRec;
  DosError: integer;
  c: longint;
begin
  c := 0;
  DosError := FindFirst(FileSpec, faAnyFile, SR);
  if DosError=0 then
  begin
    if (SR.Name<>'.') and (SR.Name<>'..') then
    begin
      filelist.Add(sr.Name);
      inc(c);
    end;
    while FindNext(SR)=0 do
    begin      
      if (SR.Name<>'.') and (SR.Name<>'..') then
      begin
        filelist.Add(sr.Name);
        inc(c);
      end;
    end;
  end
  else
    c := 0;
  result := c;
end;
{===========������һ��Ŀ¼(����):==��ͨtree======================================}
function AddTreeChild(var tv:trztreeview;ParentNode:TTreeNode;ChildName:string;imgIndex:integer=4;imgSelIndex:integer=3):TTreeNode;
var
  TipNode : TTreeNode;//�Ƚ���TREEVIEWʹ�õ��Ӷ���
  VersionNum : Integer;
begin                       
  VersionNum:=0;
  TipNode := tv.Items.AddChildObject( ParentNode,ChildName,Pointer( VersionNum ) );
  TipNode.ImageIndex := imgIndex;
  TipNode.SelectedIndex := imgSelIndex;
  //TipNode.MakeVisible;
  result:=tipnode;
end;
{===========������һ��Ŀ¼(����):chktree========================================}
function AddChkTreeChild(var tv:trzchecktree;ParentNode:TTreeNode;ChildName:string;imgIndex:integer=4;imgSelIndex:integer=3):TTreeNode;
var
  TipNode : TTreeNode;//�Ƚ���TREEVIEWʹ�õ��Ӷ���
  VersionNum : Integer;
begin                       
  VersionNum:=0;
  TipNode := tv.Items.AddChildObject( ParentNode,ChildName,Pointer( VersionNum ) );
  TipNode.ImageIndex := imgIndex;
  TipNode.SelectedIndex := imgSelIndex;
  //TipNode.MakeVisible;
  result:=tipnode;
end;
{===========���Ӹ�Ŀ¼�µĽڵ�:(�ڵ�)checktree==================================================}
function AddChkTreeSec(var tv:trzchecktree;itemName:string;imgIndex:integer=2;imgSelIndex:integer=1):TTreeNode;
var CatNode : TTreeNode;//�Ƚ���һ��TREEVIEWʹ�õ��Ӷ���
begin
  //tv.SetFocus;//�������õ����TREEVIEW�ؼ���
  { �ڸ������½���һ���µ��ӱ��� }
  CatNode:=tv.Items.AddChild(tv.Items.GetFirstNode,itemName );
  CatNode.ImageIndex := imgIndex;
  CatNode.SelectedIndex := imgSelIndex;
  catnode.MakeVisible;
  //CatNode.EditText;{ �����û��ı�������� }
  result:=catnode;
end;
{==========�Ƿ��Ѿ���¼��̳ ===================================================}
function Logined(IdHTTP1:tidhttp;var tmpbbs:onebbs;idCookie:tidcookiemanager):boolean;
var s:string;Response:TStringStream;
begin
  result:=false; 
  if tmpbbs.cookie='' then exit;                     
  savelog('�����Ƿ��ѵ�¼: ' + tmpbbs.Name + '(' + tmpbbs.URL + ')');
  Response:=TStringStream.Create('');
  idhttp1.Request.CustomHeaders.Text:=('Cookie: '+ copy(tmpbbs.Cookie ,1,length(tmpbbs.Cookie)-1));
  try
    try idhttp1.Get(tmpbbs.URL + tmpbbs.URL_LogIn ,Response);except end;
    s:=response.DataString;
  finally   
    response.free;
  end;
  if ansicontainstext(s,tmpbbs.Error_Logined) then  
  begin
    savelog('�ѵ�¼: ' + tmpbbs.Name + '(' + tmpbbs.URL + ')');
    result :=true;
  end else savelog('δ��¼: ' + tmpbbs.Name + '(' + tmpbbs.URL + ')');
end; 
{=========���������ı� ===================================================}
function GetErrorCode(s:string;var tmpbbs:onebbs):boolean;
var istart:integer;tmpList:TStrings;
begin
{��ֹ�ʺ�=�ʺű�����
��ֹIP=IP����
ʱ������=����ʱ��Ϊ
�����ɹ�=�������ӳɹ�
ע��ɹ�=ע��ɹ�
�ظ��ɹ�=����ظ��ɹ�
��¼�ɹ�=��¼�ɹ�
�ѵ�¼=�ص�¼}
  tmpList:=tstringlist.Create;
  result:=false;
  try
    tmpList.Text:=s;             
{$ifdef debug}
    tmplist.SaveToFile('.\tmp.txt');
{$endif}
    if ansicontainstext(s,tmpbbs.Error_RevertOK)or 
       AnsiContainsText(s,tmpbbs.Error_LoginOK) or 
       AnsiContainsText(s,tmpbbs.Error_NewOK ) or 
       AnsiContainsText(s,tmpbbs.Error_RegOK ) then
    begin
      tmpbbs.Error_Temp:=tmpbbs.Error_Temp+'���ɹ���';
      result:=true;
    end else if s='' then        
      tmpbbs.Error_Temp:=tmpbbs.Error_Temp+'��ʧ�ܡ�(�޷�����ҳ)'  
    else if ansicontainstext(s,tmpbbs.Error_EstopAccount ) then//�ʺű�����
    begin                   
      tmpbbs.Error_Temp:=tmpbbs.Error_Temp+'��ʧ�ܡ�('+tmpbbs.Error_EstopAccount+tmpbbs.Value_Account+')';
    end else if ansicontainstext(s,tmpbbs.Error_LimitTime) then
      tmpbbs.Error_Temp:=tmpbbs.Error_Temp+'��ʧ�ܡ�(ʱ������)'
    else if ansicontainstext(s,tmpbbs.Error_EstopIP) then//IP����ֹ
      tmpbbs.Error_Temp:=tmpbbs.Error_Temp+'��ʧ�ܡ�'+tmpbbs.Error_EstopIP
    else if ansicontainstext(s,tmpbbs.error_Validata) then
      tmpbbs.Error_Temp:=tmpbbs.Error_Temp+'��ʧ�ܡ�(��֤��У��ʧ��)'
    else
    begin
      for istart:=0 to tmpList.Count-3 do
      begin
        if ansistartstext(tmpbbs.Error_Start, tmpList.Strings[istart]) then
        begin
          tmpbbs.Error_Temp:=tmpbbs.Error_Temp+'��ʧ�ܡ�'+ tmpList.Strings[istart];
          break;
        end;
      end;
      if istart>=tmpList.Count-3 then tmpbbs.Error_Temp:=tmpbbs.Error_Temp+'��ʧ�ܡ�(����δ֪����)';//+leftbstr(DelByteChr(s),100);
    end;
  finally freeandnil(tmpList) end;
end;
{==========��¼����̳ ===================================================}
function LoginBBS(IdHTTP1:tidhttp;var tmpbbs:onebbs;idCookie:tidcookiemanager;index:integer=0):boolean;
var Response:TStringStream;i:Integer;Cookie,s:string;logininfo:tstrings;b:boolean;
begin
  result:=false;
  tmpbbs.Error_Temp:=nowtime+tmpbbs.Name +#9+'��¼';
  //����һ�����õ��ʺ�
  if not SetAccount(tmpbbs,index) then
    tmpbbs.Error_Temp:=nowtime+tmpbbs.Name +#9+'û���㹻���ʺ�(����Ҫ��2��).'
  else 
  begin
    IdHTTP1.Request.ContentType := 'application/x-www-form-urlencoded';
    IdHTTP1.Request.UserAgent:= 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.1.4322)';
    IdHTTP1.HandleRedirects:=true;
    getvalidate(idhttp1,tmpbbs);//ȡ����֤��
    Response := TStringStream.Create('');
    logininfo:=tstringlist.Create;
    try
      logininfo.Add(tmpbbs.Var_Login_Account +'='+ tmpbbs.Value_Account);
      logininfo.Add(tmpbbs.Var_Validate+'='+ tmpbbs.Value_Validate);
      logininfo.Add(tmpbbs.Var_Login_Password +'='+ tmpbbs.Value_Password);
      logininfo.Add('comeurl='+ geturlback(tmpbbs.URL,2));
      b:=true;
{$ifndef corporation}
      if not ansicontainstext(tmpbbs.URL,'ms4f.com') and
         not ansicontainstext(tmpbbs.URL,'30ok.com') then
{$endif}  
      while b do
      begin
        //���������postҲ������get
        try IdHTTP1.Post(tmpbbs.URL + tmpbbs.URL_LogIn,logininfo,response);except end;
        //try IdHTTP1.Get(tmpbbs.URL + tmpbbs.URL_LogIn + logininfo.Text,response);except end;
        s:=Response.DataString;
        result:=GetErrorCode(s,tmpbbs);
        if (length(s)=0)or(length(s)>300)or//��ҳ����
           ansicontainstext(tmpbbs.Error_Temp,tmpbbs.Error_EstopIP)//IP����
           then b:=false;
      end;//while
    finally freeandnil(Response);freeandnil(logininfo); end;
    //�ӷ��ص�ҳ�����ҳ�cookie
    if result then
    begin  
      tmpbbs.Cookie:='';
      for i := 0 to idCookie.CookieCollection.Count - 1 do    
      begin
        Cookie:=Trim(idcookie.CookieCollection.Items[i].CookieText);
        Cookie:=Copy(Cookie,1,Pos(';',Cookie));
        tmpbbs.Cookie :=tmpbbs.Cookie+Cookie;
      end;
    end;//if
  end;//if �ʺ�
  if AnsiEndsText('��¼',tmpbbs.Error_Temp) then 
    result:=geterrorcode('',tmpbbs);
end;
{=========����====================================================}
function PostNew(var idhttp1:tidhttp;var tmpbbs:onebbs;idCookie:tidcookiemanager):boolean;
var PostInfo:TStrings;s:string;Response:TStringStream;b:boolean;
begin
  Result:=False;
  frmbbs.SetNew(tmpbbs);
  PostInfo:=TStringList.Create;
  Response:=TStringStream.Create('');
  tmpbbs.Error_Temp:=nowtime+tmpbbs.Name + #9 + tmpbbs.Error_Temp + ' ��������';
  try
    idhttp1.Request.CustomHeaders.Text:=('Cookie: '+ copy(tmpbbs.Cookie ,1,length(tmpbbs.Cookie)-1));
    IdHTTP1.Request.ContentType := 'application/x-www-form-urlencoded';
    IF tmpbbs.Var_Validate<>'' then GetValidate(idhttp1,tmpbbs);//ȡ����֤��
    {//ȡ����ҳ��upfilerename=&Body=1234567890&dvbbs=bbs.4fcom.net&star=1&page=1&TotalUseTable=Dv_bbs4&username=��ɽ�۵�&passwd=6820956&font=&topic=1234567890&Expression=face1.gif&autofix=1&signflag=yes&emailflag=0';}
    postinfo.Add(tmpbbs.Var_New_Memo +'='+ tmpbbs.Value_NewText);
    postinfo.Add('dvbbs='+geturlback(tmpbbs.URL,2));
    postinfo.Add(tmpbbs.Var_New_Account +'='+ tmpbbs.Value_Account);
    postinfo.Add(tmpbbs.Var_New_Password +'='+ tmpbbs.Value_Password);
    IF tmpbbs.Var_Validate<>'' then postinfo.Add(tmpbbs.Var_Validate +'='+ tmpbbs.Value_Validate);
//    if tmpbbs.Var_HideVali_1<>'' then postinfo.add(tmpbbs.Var_HideVali_1 +'='+    
    postinfo.Add(tmpbbs.Var_New_Main +'='+ tmpbbs.Value_NewEdit);
    idhttp1.Request.Referer:=tmpbbs.URL +tmpbbs.URL_New_B +tmpbbs.URL_Temp ;//����Ҫ��������ַ
    b:=true;
    while b do
    begin
      try idhttp1.Post(tmpbbs.URL +tmpbbs.URL_NewSubmit_B +tmpbbs.URL_Temp,postinfo,Response);except end;
      application.ProcessMessages;    
      s:=response.DataString;
      result:=geterrorcode(s,tmpbbs);//������������
      if (length(s)=0)or(length(s)>300)or//��ҳ����
         ansicontainstext(tmpbbs.Error_Temp,tmpbbs.Error_EstopIP)//IP����
         then b:=false;
    end;
  finally
    PostInfo.Free;
    Response.Free;
  end;
  if AnsiEndsText('��������',tmpbbs.Error_Temp) then 
    result:=geterrorcode('',tmpbbs);
end;
{=========�ظ���====================================================}
function PostRevert(var idhttp1:tidhttp;var tmpbbs:onebbs;idCookie:tidcookiemanager):boolean;
var
  PostInfo:TStrings;s:string;Response:TStringStream;b:boolean;
  BoardID,ID:string;//���ڰ��ID ����ID
begin
  frmbbs.SetRevert(tmpbbs);
  //�ظ�����
  s:=geturlback(tmpbbs.URL_Temp); 
  BoardID:=getmidstr(uppercase(tmpbbs.URL_Temp),'&'+tmpbbs.Var_BoardId+'=','&');
  ID:=getmidstr(uppercase(tmpbbs.URL_Temp),'&'+tmpbbs.Var_Revert_RootId+'=','&');
  tmpbbs.Error_Temp:=nowtime+tmpbbs.Name + #9 + ID+' ����ظ�';
  IdHTTP1.Request.CustomHeaders.Text:=('Cookie: '+ copy(tmpbbs.Cookie ,1,length(tmpbbs.Cookie)-1));
  IdHTTP1.Request.ContentType := 'application/x-www-form-urlencoded';
  Response:=TStringStream.Create('');
  PostInfo:=TStringList.Create;
  s:='';
  try
    try s:=idhttp1.get(tmpbbs.URL_Temp);except end;
    application.ProcessMessages;
    if ansicontainstext(s,tmpbbs.Var_Revert_Followid)then
    begin//{upfilerename=&Body=����&dvbbs=bbs.4fcom.net%2F&star=1&page=1&TotalUseTable=Dv_bbs4&followup=1179995&rootID=1664514&username=��ɽ�۵�&passwd=6820956&font=&topic=����&Expression=face1.gif&autofix=1&signflag=yes&emailflag=0}
      IF tmpbbs.Var_Validate<>'' then GetValidate(idhttp1,tmpbbs);//ȡ����֤��
      if tmpbbs.value_reverttext='' then tmpbbs.value_reverttext:=GetRndString(20); 
      postinfo.Add(tmpbbs.Var_Revert_Memo +'='+ tmpbbs.Value_RevertText);
      postinfo.Add('dvbbs='+geturlback(tmpbbs.URL,2));
      IF tmpbbs.Var_HideVali_1<>'' then
        postinfo.Add(tmpbbs.Var_HideVali_1+'='+getmidstr(s,tmpbbs.Var_HideVali_1B,tmpbbs.Var_HideVali_1E));
      if tmpbbs.Var_HideVali_2<>'' then
        postinfo.Add(tmpbbs.Var_HideVali_2+'='+getmidstr(s,tmpbbs.Var_HideVali_2B,tmpbbs.Var_HideVali_2E));
      postinfo.Add(tmpbbs.Var_Revert_rootid+'='+id);
      postinfo.Add('rootid='+id);
      postinfo.Add(tmpbbs.Var_Revert_Account +'='+ tmpbbs.Value_Account);
      postinfo.Add(tmpbbs.Var_Revert_Password +'='+ tmpbbs.Value_Password);
       
      IF tmpbbs.Var_Validate<>'' then postinfo.Add(tmpbbs.Var_Validate +'='+ tmpbbs.Value_Validate);
      idhttp1.Request.Referer:=tmpbbs.URL_Temp;
      b:=true;
      while b do
      begin
        try idhttp1.Post(tmpbbs.URL_RevertSubmit_B +boardid ,postinfo,Response);except end;
        application.ProcessMessages;    
        s:=response.DataString;
        if (length(s)=0)or(length(s)>300)or//��ҳ����
           ansicontainstext(tmpbbs.Error_Temp,tmpbbs.Error_EstopIP)//IP����
           then b:=false;
      end;
    end;
  finally freeandnil(Response);freeandnil(PostInfo);end;
  result:=geterrorcode(s,tmpbbs);//������������//if ��֤��
  if AnsiEndsText('����ظ�',tmpbbs.Error_Temp) then 
    result:=geterrorcode('',tmpbbs);
end;     
{=========ע��====================================================}
function PostReg(var idhttp1:tidhttp;var tmpbbs:onebbs):boolean;
var
  PostInfo:TStrings;s:string;b:boolean;
  Response:TStringStream;
begin
  application.ProcessMessages;
  tmpbbs.Error_Temp:=nowtime+tmpbbs.Name +#9+'ע���ʺ�:'+tmpbbs.Value_Account;
  Result:=False;
  PostInfo:=TStringList.Create;
  Response:=TStringStream.Create('');
  try
    IdHTTP1.Request.ContentType := 'application/x-www-form-urlencoded';
    IdHTTP1.Request.UserAgent:= 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.1.4322)';
    try s:=idhttp1.get(tmpbbs.URL +tmpbbs.URL_Reg);except end;
    IF tmpbbs.Var_HideVali_1<>'' then
      postinfo.Add(tmpbbs.Var_HideVali_1+'='+getmidstr(s,tmpbbs.Var_HideVali_1B,tmpbbs.Var_HideVali_1E));
    if tmpbbs.Var_HideVali_2<>'' then
      postinfo.Add(tmpbbs.Var_HideVali_2+'='+getmidstr(s,tmpbbs.Var_HideVali_2B,tmpbbs.Var_HideVali_2E));
    if tmpbbs.Var_Validate<>''    then getvalidate(idhttp1,tmpbbs);//ȡ����֤��
    if tmpbbs.Var_Reg_Acc<>''     then postinfo.Add(tmpbbs.Var_Reg_Acc +'='+ tmpbbs.Value_Account);
    if tmpbbs.Var_Validate<>''    then postinfo.Add(tmpbbs.Var_Validate +'='+ tmpbbs.Value_Validate);
    if tmpbbs.Var_Reg_Pass1<>''   then postinfo.Add(tmpbbs.Var_Reg_Pass1 +'='+ tmpbbs.Value_Password );
    if tmpbbs.Var_Reg_Pass2<>''   then postinfo.Add(tmpbbs.Var_Reg_Pass2 +'='+ tmpbbs.Value_Password );
    if tmpbbs.Var_Reg_Ask1<>''    then postinfo.Add(tmpbbs.Var_Reg_Ask1 +'='+ tmpbbs.Value_Ask1 );
    if tmpbbs.Var_Reg_Answer1<>'' then postinfo.Add(tmpbbs.Var_Reg_Answer1 +'='+ tmpbbs.Value_Answer1 );
    if tmpbbs.Var_Reg_eMail<>''   then postinfo.Add(tmpbbs.Var_Reg_eMail +'='+ tmpbbs.Value_eMail);
    if tmpbbs.Var_Reg_Ask2<>''    then postinfo.Add(tmpbbs.Var_Reg_Ask2);// +'='+ tmpbbs.Value_Ask2);
    if tmpbbs.Var_Reg_Answer2<>'' then postinfo.Add(tmpbbs.Var_Reg_Answer2);// +'='+ tmpbbs.Value_Answer2);
    idhttp1.Request.Referer:=tmpbbs.URL +tmpbbs.URL_Reg;//����Ҫ��������ַ
    b:=true;
    while b do//��ʼע��
    begin
      try idhttp1.Post(tmpbbs.URL +tmpbbs.URL_RegSubmit ,postinfo,Response);except end;
      application.ProcessMessages;    
      s:=response.DataString;
      result:=geterrorcode(s,tmpbbs);//������������
      if (length(s)=0)or(length(s)>300)or//��ҳ����
         ansicontainstext(tmpbbs.Error_Temp,tmpbbs.Error_EstopIP)//IP����
         then b:=false;
    end;
  finally
    freeandnil(PostInfo);
    freeandnil(Response);
  end;
  if AnsiEndsText(tmpbbs.Value_Account,tmpbbs.Error_Temp) then 
    result:=geterrorcode('',tmpbbs);
end; 
{============�������ִ���ȡ���ַ���======================================} 
function GetMidStr(TmpStr,StartStr,EndStr:string):string ;
var i:integer;b:string;
begin 
{  StartStr:=uppercase(StartStr);
  EndStr:=uppercase(EndStr);
  TmpStr:=uppercase(TmpStr);}
  i:=pos(StartStr,TmpStr)+length(StartStr)-1;
  b:=rightbstr(TmpStr,length(TmpStr)-i);
  b:=leftbstr(b,pos(EndStr,b)-1);
  result:=b;
end;

{=============================================================}
{=============================================================} 
{=============================================================}
{=============================================================} 
{=============================================================}
{=============================================================} 
end.
 
