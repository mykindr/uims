unit uSinaWeiboClient;

interface

uses
  Windows,SysUtils,Classes,Controls,Dialogs,
  uSinaWeiboAPI,
  uSinaWeiboUser,
  uMyOAuth,
  uSinaWeiboParam,
  uSinaWeiboAPIConst,
  uSinaWeiboItem;


type
  TSinaWeiboClient=class
  private
    FAPI:TSinaWeiboAPI;
    FUser:TSinaWeiboUser;
    FOAuth:TMyOAuth;
  protected
    //��ȡ���µ�΢���б�
    function GetStatuses_Friends_TimeLine_WeiboList: TSinaWeiboList;
    //��ȡָ���û���������΢���б�
    function GetStatuses_User_TimeLine_WeiboList: TSinaWeiboList;
    //�շ���΢��
    function GetStatuses_Update_WeiboItem: TSinaWeiboItem;
  public
    constructor Create;
    destructor Destroy;override;
    //�����û���Ϣ
    function SyncUserInfo:Boolean;
    //��һ���ı�΢��
    function SendTextWeibo(Source:String;WeiboText:String):Boolean;
    //��һͼƬ΢��
    function SendPicWeibo(Source:String;WeiboText:String;PicFileName:String):Boolean;
    //��ȡ���µ�΢���б�
    function GetHomePageWeiboList(Source:String;Since_Id:String;Max_Id:String;Count:String;
                           Page:String;Base_App:String;Feature:String):Boolean;
    //��ȡָ��ĳ�û���������΢���б�
    function GetUserRecentWeiboList(Source:String;Since_Id:String;Max_Id:String;Count:String;
                           Page:String;Base_App:String;Feature:String;
                           Id:String;User_Id:String;Screen_Name:String):Boolean;
    //��ǰ�û�Web��վδ����Ϣ��
    function GetHomePageUnReadMsgNum(Source:String;Since_Id:String;with_new_status:String):Boolean;
  public
    //����API
    property API:TSinaWeiboAPI read FAPI;
    //�û���
    property User:TSinaWeiboUser read FUser;
    //��֤��
    property OAuth:TMyOAuth read FOAuth;
  public
    //ָ���û����·����΢���б�
    property Statuses_User_TimeLine_WeiboList:TSinaWeiboList read GetStatuses_User_TimeLine_WeiboList;
    //��ҳ���µ�΢���б�
    property Statuses_Friends_TimeLine_WeiboList:TSinaWeiboList read GetStatuses_Friends_TimeLine_WeiboList;
    //�շ���΢��
    property Statuses_Update_WeiboItem:TSinaWeiboItem read GetStatuses_Update_WeiboItem;
  end;

var
  Client:TSinaWeiboClient;

implementation

uses
  uSinaWeiboAPI_Statuses_Friends_TimeLine,
  uSinaWeiboAPI_Statuses_Update,
  uSinaWeiboAPI_Statuses_Unread,
  uSinaWeiboAPI_Statuses_Upload,
  uSinaWeiboAPI_Statuses_User_TimeLine;


{ TSinaWeiboClient }

constructor TSinaWeiboClient.Create;
begin
  inherited Create;
  FOAuth:=TMyOAuth.Create('','');
  FAPI:=TSinaWeiboAPI.Create(FOAuth);
  FUser:=TSinaWeiboUser.Create;
end;

destructor TSinaWeiboClient.Destroy;
begin
  FAPI.Free;
  FUser.Free;
  FOAuth.Free;
  inherited;
end;

function HTMLEncode(const AStr: AnsiString): String;
const
  NoConversion = ['A'..'Z','a'..'z','*','.','_','-','0'..'9','!','''','(',')']; //����Ҫ����ת�����ַ���
var
  Rp:String;
  I: Integer;
begin
  Result:='';
  for I := 1 to Length(AStr) do
  begin
    if AStr[I] in NoConversion then
      Result :=Result+ AStr[I]
    else
    if AStr[I] = ' ' then
      Result :=Result+'+'
    else
    begin
      Result:=Result+'%'+Format('%x', [ORD( AStr[I])]);
    end;
  end;
end;

function TSinaWeiboClient.SendPicWeibo(Source:String;WeiboText, PicFileName: String): Boolean;
var
  APIItem:TSinaWeiboAPI_Statuses_Upload;
begin
  Result:=False;
  APIItem:=Self.FAPI.GetAPI(CONST_API_Statuses_Upload_ID) as TSinaWeiboAPI_Statuses_Upload;
  if APIItem<>nil then
  begin
    APIItem.Param_Status.Value:=URLEncodeUTF8(UTF8Encode(WeiboText));// 'test pic';//
    APIItem.Param_Source.Value:=Source;
    APIItem.Param_Pic.Value:=PicFileName;
    if Self.API.CallAPI(CONST_API_Statuses_Upload_ID) then
    begin
      Result:=True;
    end;
  end;
end;

function TSinaWeiboClient.SendTextWeibo(Source:String;WeiboText: String):Boolean;
var
  APIItem:TSinaWeiboAPI_Statuses_Update;
begin
  Result:=False;
  APIItem:=Self.FAPI.GetAPI(CONST_API_Statuses_Update_ID) as TSinaWeiboAPI_Statuses_Update;
  if APIItem<>nil then
  begin
    APIItem.Param_Status.Value:=URLEncodeUTF8(UTF8Encode(WeiboText));
    APIItem.Param_Source.Value:=Source;
    //APIItem.Param_In_Reply_To_Id.Value:='3377067832655670';
    if Self.API.CallAPI(CONST_API_Statuses_Update_ID) then
    begin
      Result:=True;
    end;
  end;
end;

function TSinaWeiboClient.GetStatuses_Friends_TimeLine_WeiboList: TSinaWeiboList;
var
  APIItem:TSinaWeiboAPI_Statuses_Friends_TimeLine;
begin
  Result:=nil;
  APIItem:=Self.FAPI.GetAPI(CONST_API_Statuses_Friends_TimeLine_ID) as TSinaWeiboAPI_Statuses_Friends_TimeLine;
  if APIItem<>nil then
  begin
    Result:=APIItem.WeiboList;
  end;
end;

function TSinaWeiboClient.GetStatuses_Update_WeiboItem: TSinaWeiboItem;
var
  APIItem:TSinaWeiboAPI_Statuses_Update;
begin
  Result:=nil;
  APIItem:=Self.FAPI.GetAPI(CONST_API_Statuses_Update_ID) as TSinaWeiboAPI_Statuses_Update;
  if APIItem<>nil then
  begin
    Result:=APIItem.WeiboItem;
  end;
end;

function TSinaWeiboClient.GetStatuses_User_TimeLine_WeiboList: TSinaWeiboList;
var
  APIItem:TSinaWeiboAPI_Statuses_User_TimeLine;
begin
  Result:=nil;
  APIItem:=Self.FAPI.GetAPI(CONST_API_Statuses_User_TimeLine_ID) as TSinaWeiboAPI_Statuses_User_TimeLine;
  if APIItem<>nil then
  begin
    Result:=APIItem.WeiboList;
  end;
end;

function TSinaWeiboClient.GetUserRecentWeiboList(Source, Since_Id, Max_Id,
  Count, Page, Base_App, Feature, Id, User_Id, Screen_Name: String): Boolean;
var
  APIItem:TSinaWeiboAPI_Statuses_User_TimeLine;
begin
  Result:=False;
  //���ò���
  APIItem:=Self.FAPI.GetAPI(CONST_API_Statuses_User_TimeLine_ID) as TSinaWeiboAPI_Statuses_User_TimeLine;
  APIItem.Param_Source.Value:=Source;
  APIItem.Param_Since_Id.Value:=Since_Id;
  APIItem.Param_Max_Id.Value:=Max_Id;
  APIItem.Param_Count.Value:=Count;
  APIItem.Param_Page.Value:=Page;
  APIItem.Param_Base_App.Value:=Base_App;
  APIItem.Param_Feature.Value:=Feature;
  APIItem.Param_Id.Value:=Id;
  APIItem.Param_User_Id.Value:=User_Id;
  APIItem.Param_Screen_Name.Value:=URLEncodeUTF8(UTF8Encode(Screen_Name));

  if APIItem<>nil then
  begin
    if Client.API.CallAPI(CONST_API_Statuses_User_TimeLine_ID) then
    begin
      Result:=True;
    end;
  end;
end;

function TSinaWeiboClient.SyncUserInfo:Boolean;
begin
  Result:=False;
  if Client.API.CallAPI(CONST_API_Statuses_Verify_Credentials_ID) then
  begin
    Result:=Client.User.LoadFromAPI( Client.API.GetAPI(CONST_API_Statuses_Verify_Credentials_ID) );
  end;
end;


//�������
// 	��ѡ	���ͼ���Χ	˵��
//source	true	string	����Ӧ��ʱ�����AppKey�����ýӿ�ʱ�����Ӧ�õ�Ψһ��ݡ�������OAuth��Ȩ��ʽ����Ҫ�˲�����
//with_new_status	false	int��Ĭ��Ϊ0��	1��ʾ����а���new_status�ֶΣ�0��ʾ���������new_status�ֶΡ�new_status�ֶα�ʾ�Ƿ�����΢����Ϣ��1��ʾ�У�0��ʾû��
//since_id	false	int64	����ֵΪ΢��id���ò��������with_new_status����ʹ�ã�����since_id֮���Ƿ�����΢����Ϣ����
function TSinaWeiboClient.GetHomePageUnReadMsgNum(Source, Since_Id,
  with_new_status: String): Boolean;
var
  APIItem:TSinaWeiboAPI_Statuses_Unread;
begin
  Result:=False;
  //���ò���
  APIItem:=Self.FAPI.GetAPI(CONST_API_Statuses_Unread_ID) as TSinaWeiboAPI_Statuses_Unread;
  APIItem.Param_Source.Value:=Source;
  APIItem.Param_Since_Id.Value:=Since_Id;
  APIItem.Param_Wit_New_Status.Value:=with_new_status;
  if APIItem<>nil then
  begin
    if Client.API.CallAPI(CONST_API_Statuses_Unread_ID) then
    begin
      Result:=True;
    end;
  end;
end;

// 	    ��ѡ	  ���ͼ���Χ	˵��
//source	true	string	����Ӧ��ʱ�����AppKey�����ýӿ�ʱ�����Ӧ�õ�Ψһ��ݡ�������OAuth��Ȩ��ʽ����Ҫ�˲�����
//since_id	false	int64	��ָ���˲�������ֻ����ID��since_id���΢����Ϣ������since_id����ʱ�����΢����Ϣ����
//max_id	false	int64	��ָ���˲������򷵻�IDС�ڻ����max_id��΢����Ϣ
//count	false	int��Ĭ��ֵ20�����ֵ200��	ָ��Ҫ���صļ�¼������
//page	false	int��Ĭ��ֵ1��	ָ�����ؽ����ҳ�롣���ݵ�ǰ��¼�û�����ע���û�������Щ����ע�û������΢��������ҳ��������ܲ鿴���ܼ�¼����������ͬ��ͨ������ܲ鿴1000�����ҡ�
//base_app	false	int	�Ƿ���ڵ�ǰӦ������ȡ���ݡ�1Ϊ���Ʊ�Ӧ��΢����0Ϊ�������ơ�
//feature	false	int	΢�����ͣ�0ȫ����1ԭ����2ͼƬ��3��Ƶ��4����. ����ָ�����͵�΢����Ϣ���ݡ�
function TSinaWeiboClient.GetHomePageWeiboList(Source:String;
                                        Since_Id:String;
                                        Max_Id:String;
                                        Count:String;
                                        Page:String;
                                        Base_App:String;
                                        Feature:String
                                        ):Boolean;
var
  APIItem:TSinaWeiboAPI_Statuses_Friends_TimeLine;
begin
  Result:=False;
  //���ò���
  APIItem:=Self.FAPI.GetAPI(CONST_API_Statuses_Friends_TimeLine_ID) as TSinaWeiboAPI_Statuses_Friends_TimeLine;
  APIItem.Param_Source.Value:=Source;
  APIItem.Param_Since_Id.Value:=Since_Id;
  APIItem.Param_Max_Id.Value:=Max_Id;
  APIItem.Param_Count.Value:=Count;
  APIItem.Param_Page.Value:=Page;
  APIItem.Param_Base_App.Value:=Base_App;
  APIItem.Param_Feature.Value:=Feature;
  if APIItem<>nil then
  begin
    if Client.API.CallAPI(CONST_API_Statuses_Friends_TimeLine_ID) then
    begin
      Result:=True;
    end;
  end;
end;

initialization
  Client:=TSinaWeiboClient.Create();


finalization
  FreeAndNil(Client);

end.
