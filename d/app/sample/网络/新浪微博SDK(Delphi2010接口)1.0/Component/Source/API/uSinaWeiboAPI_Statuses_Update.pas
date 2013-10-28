unit uSinaWeiboAPI_Statuses_Update;

interface

uses
  Windows,SysUtils,Classes,
  uSinaWeiboItem,
  uSinaWeiboAPI,
  uSinaWeiboAPIConst,
  uSinaWeiboParam,
  uLkJson,
  Variants,
  Dialogs,
  IdHttp;


type
  TSinaWeiboAPI_Statuses_Update=class(TSinaWeiboAPIItem)
  private
    FWeiboItem:TSinaWeiboItem;
    FParam_In_Reply_To_Id: TQueryParameter;
    FParam_Source: TQueryParameter;
    FParam_Lat: TQueryParameter;
    FParam_Status: TQueryParameter;
    FParam_Long: TQueryParameter;
    FParam_Annotations: TQueryParameter;
  protected
    //�ӷ��������ص�Jason��Ϣ�������û���Ϣ
    function ParseFromJson(Response:String):Boolean;override;
    //procedure CallAPIHTTPPostSetting(AHTTP:TIdHttp;var HTTPPostStream:TMemoryStream);override;

  public
    constructor Create;
    destructor Destroy;override;
  public
    ////////////////////////////����/////////////////////////////////
    //status	true	string	Ҫ������΢����Ϣ�ı�����
    property Param_Status:TQueryParameter read FParam_Status;
    //������� 	��ѡ	���ͼ���Χ	˵��
    //source	true	string	����Ӧ��ʱ�����AppKey��
    //���ýӿ�ʱ�����Ӧ�õ�Ψһ��ݡ�������OAuth��Ȩ��ʽ����Ҫ�˲�����
    property Param_Source:TQueryParameter read FParam_Source;
    //in_reply_to_status_id	false	int64	Ҫת����΢����ϢID��
    property Param_In_Reply_To_Id:TQueryParameter read FParam_In_Reply_To_Id;
    //ע�⣺lat��long���������ʹ�ã����ڱ�Ƿ���΢����Ϣʱ���ڵĵ���λ�ã�ֻ���û�������geo_enabled=trueʱ�����λ����Ϣ����Ч��
    //lat	false	float	γ�ȡ���Ч��Χ��-90.0��+90.0��+��ʾ��γ��
    Property Param_Lat:TQueryParameter read FParam_Lat;
    //long	false	float	���ȡ���Ч��Χ��-180.0��+180.0��+��ʾ������
    Property Param_Long:TQueryParameter read FParam_Long;
    //annotations	false	string	Ԫ���ݣ���Ҫ��Ϊ�˷��������Ӧ�ü�¼һЩ�ʺ����Լ�ʹ�õ���Ϣ��
    //ÿ��΢�����԰���һ�����߶��Ԫ���ݡ�����json�ִ�����ʽ�ύ���ִ����Ȳ�����512���ַ����������ݿ����Զ���
    property Param_Annotations:TQueryParameter read FParam_Annotations;
  public
    //�շ���΢��
    property WeiboItem:TSinaWeiboItem read FWeiboItem;
  end;


var
  GlobalSinaWeiboAPI_Statuses_Update:TSinaWeiboAPI_Statuses_Update;

implementation

{ TSinaWeiboAPI_Statuses_Update }

//procedure TSinaWeiboAPI_Statuses_Update.CallAPIHTTPPostSetting(AHTTP: TIdHttp;var HTTPPostStream:TMemoryStream);
//begin
//  inherited;
//  //AHTTP.Request.ContentType:='application/x-www-form-urlencoded';
//  //AHTTP.Request.RawHeaders.AddValue('API-RemoteIP','127.0.0.1');
//end;

constructor TSinaWeiboAPI_Statuses_Update.Create;
begin
  Inherited Create(
                          CONST_API_Statuses_Update_ID,
                          CONST_API_Statuses_Update_NAME,
                          CONST_API_Statuses_Update_URL,
                          CONST_API_Statuses_Update_NEEDLOGIN,
                          CONST_API_Statuses_Update_REQLIMIT,
                          CONST_API_Statuses_Update_DESCRIP,
                          CONST_API_Statuses_Update_STYLES,
                          CONST_API_Statuses_Update_REQMETHOD
                  );

  FParam_In_Reply_To_Id:=TQueryParameter.Create('in_reply_to_id','');
  FParam_Source:=TQueryParameter.Create('source','');
  FParam_Lat:=TQueryParameter.Create('lat','');
  FParam_Status:=TQueryParameter.Create('status','');
  FParam_Long:=TQueryParameter.Create('long','');
  FParam_Annotations:=TQueryParameter.Create('annotations','');

  Params.Add(FParam_In_Reply_To_Id);
  Params.Add(FParam_Source);
  Params.Add(FParam_Lat);
  Params.Add(FParam_Status);
  Params.Add(FParam_Long);
  Params.Add(FParam_Annotations);


  FWeiboItem:=TSinaWeiboItem.Create;
end;

destructor TSinaWeiboAPI_Statuses_Update.Destroy;
begin
  FWeiboItem.Free;
  inherited;
end;

function TSinaWeiboAPI_Statuses_Update.ParseFromJson(
  Response:String): Boolean;
var
  WeiboItemJson: TlkJSONobject;
begin
  Result:=False;
//  Response:=
//'{'
//+'"created_at":"Sun Nov 06 17:23:40 +0800 2011",'
//+'"id":3376783640356245,'
//+'"text":"OrangerBo",'
//+'"source":"<a href=\"http://open.t.sina.com.cn\" rel=\"nofollow\">δͨ�����Ӧ��</a>",'
//+'"favorited":false,"truncated":false,'
//+'"in_reply_to_status_id":"",'
//+'"in_reply_to_user_id":"",'
//+'"in_reply_to_screen_name":"",'
//+'"geo":null,'
//+'"mid":"3376783640356245",'
//+'"user":{'
//+'"id":1651072717,'
//+'"screen_name":"OrangerBo",'
//+'"name":"OrangerBo",'
//+'"province":"31",'
//+'"city":"7",'
//+'"location":"�Ϻ� ������",'
//+'"description":"",'
//+'"url":"http://blog.csdn.net/delphiteacher/",'
//+'"profile_image_url":"http://tp2.sinaimg.cn/1651072717/50/5607820735/1",'
//+'"domain":"orangeinmymind",'
//+'"gender":"m",'
//+'"followers_count":62,'
//+'"friends_count":41,'
//+'"statuses_count":0,'
//+'"favourites_count":0,'
//+'"created_at":"Wed Jan 12 00:00:00 +0800 2011","following":false,'
//+'"allow_all_act_msg":false,"geo_enabled":true,"verified":false}}';
//

  WeiboItemJson := TlkJson.ParseText(Response) as TlkJSONobject;
  if WeiboItemJson <> nil then
  begin
    Self.FWeiboItem.LoadFromJson(WeiboItemJson);
    Result:=True;
    WeiboItemJson.Free;
  end;

end;


initialization
  GlobalSinaWeiboAPI_Statuses_Update:=TSinaWeiboAPI_Statuses_Update.Create;
  RegisterSinaWeiboAPI(GlobalSinaWeiboAPI_Statuses_Update);


finalization
  //UnRegisterSinaWeiboAPI(GlobalSinaWeiboAPI_Statuses_Update);
  //GlobalSinaWeiboAPI_Statuses_Update.Free;


//'{
//"created_at":"Sun Nov 06 17:23:40 +0800 2011",
//"id":3376783640356245,
//"text":"OrangerBo",
//"source":"<a href=\"http://open.t.sina.com.cn\" rel=\"nofollow\">δͨ�����Ӧ��</a>",
//"favorited":false,"truncated":false,
//"in_reply_to_status_id":"",
//"in_reply_to_user_id":"",
//"in_reply_to_screen_name":"",
//"geo":null,
//"mid":"3376783640356245",
//"user":{
//"id":1651072717,
//"screen_name":"OrangerBo",
//"name":"OrangerBo",
//"province":"31",
//"city":"7",
//"location":"�Ϻ� ������",
//"description":"",
//"url":"http://blog.csdn.net/delphiteacher/",
//"profile_image_url":"http://tp2.sinaimg.cn/1651072717/50/5607820735/1",
//"domain":"orangeinmymind",
//"gender":"m",
//"followers_count":62,
//"friends_count":41,
//"statuses_count":0,
//"favourites_count":0,
//"created_at":"Wed Jan 12 00:00:00 +0800 2011","following":false,"allow_all_act_msg":false,"geo_enabled":true,"verified":false}}'

end.


