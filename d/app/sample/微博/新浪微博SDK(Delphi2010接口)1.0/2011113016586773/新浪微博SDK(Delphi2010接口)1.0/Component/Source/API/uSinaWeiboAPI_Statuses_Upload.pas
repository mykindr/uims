unit uSinaWeiboAPI_Statuses_Upload;

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
  IdHttp,
  IdMultipartFormData;


type
  TSinaWeiboAPI_Statuses_Upload=class(TSinaWeiboAPIItem)
  private
    FWeiboItem:TSinaWeiboItem;
    FParam_Pic: TQueryParameter;
    FParam_Source: TQueryParameter;
    FParam_Lat: TQueryParameter;
    FParam_Status: TQueryParameter;
    FParam_Long: TQueryParameter;
    FParam_Annotations: TQueryParameter;
  protected
    //�ӷ��������ص�Jason��Ϣ�������û���Ϣ
    procedure CallAPIHTTPPostSetting(AHTTP: TIdHttp;var HTTPPostStream:TMemoryStream);override;
    function ParseFromJson(Response:String):Boolean;override;
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
    //pic	true	binary	Ҫ�ϴ���ͼƬ���ݡ���֧��JPEG��GIF��PNG��ʽ��Ϊ�շ���400����ͼƬ��С<5M��
    property Param_Pic:TQueryParameter read FParam_Pic;
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
  GlobalSinaWeiboAPI_Statuses_Upload:TSinaWeiboAPI_Statuses_Upload;

implementation

{ TSinaWeiboAPI_Statuses_Upload }

constructor TSinaWeiboAPI_Statuses_Upload.Create;
begin
  Inherited Create(
                          CONST_API_Statuses_Upload_ID,
                          CONST_API_Statuses_Upload_NAME,
                          CONST_API_Statuses_Upload_URL,
                          CONST_API_Statuses_Upload_NEEDLOGIN,
                          CONST_API_Statuses_Upload_REQLIMIT,
                          CONST_API_Statuses_Upload_DESCRIP,
                          CONST_API_Statuses_Upload_STYLES,
                          CONST_API_Statuses_Upload_REQMETHOD
                  );

  FParam_Pic:=TQueryParameter.Create('pic','',False);
  FParam_Source:=TQueryParameter.Create('source','',False);
  FParam_Lat:=TQueryParameter.Create('lat','',False);
  FParam_Status:=TQueryParameter.Create('status','',False);
  FParam_Long:=TQueryParameter.Create('long','',False);
  FParam_Annotations:=TQueryParameter.Create('annotations','',False);

  Params.Add(FParam_Pic);
  Params.Add(FParam_Source);
  Params.Add(FParam_Lat);
  Params.Add(FParam_Status);
  Params.Add(FParam_Long);
  Params.Add(FParam_Annotations);

  FWeiboItem:=TSinaWeiboItem.Create;
end;

destructor TSinaWeiboAPI_Statuses_Upload.Destroy;
begin
  FWeiboItem.Free;
  inherited;
end;

procedure TSinaWeiboAPI_Statuses_Upload.CallAPIHTTPPostSetting(AHTTP: TIdHttp;var HTTPPostStream:TMemoryStream);
var
  IdMultiPartFormDataStream:TIdMultiPartFormDataStream;
  //FileStream:TFileStream;
  HTTPHeaderStrings:TStringList;
  HTTPFooterStrings:TStringList;
  Boundary:String;
  BoundaryHeader:String;
  BoundaryFooter:String;
begin
  Inherited;

  HTTPHeaderStrings:=TStringList.Create;
  HTTPFooterStrings:=TStringList.Create;

  IdMultiPartFormDataStream:=IdMultipartFormData.TIdMultiPartFormDataStream.Create;
  Boundary:=IdMultiPartFormDataStream.Boundary;
  BoundaryHeader:='--'+Boundary;
  BoundaryFooter:='--'+Boundary+'--';

  AHTTP.Request.ContentType:='multipart/form-data; boundary='+Boundary+'';

  //΢���ı�
  HTTPHeaderStrings.Add(BoundaryHeader);
  HTTPHeaderStrings.Add('Content-Disposition: form-data; name="status"');
  HTTPHeaderStrings.Add('Content-Type: text/plain; charset=US-ASCII');
  HTTPHeaderStrings.Add('Content-Transfer-Encoding: 8bit');
  HTTPHeaderStrings.Add('');
  HTTPHeaderStrings.Add(Self.FParam_Status.Value);

  //Ӧ��ID
  HTTPHeaderStrings.Add(BoundaryHeader);
  HTTPHeaderStrings.Add('Content-Disposition: form-data; name="source"');
  HTTPHeaderStrings.Add('Content-Type: text/plain; charset=US-ASCII');
  HTTPHeaderStrings.Add('Content-Transfer-Encoding: 8bit');
  HTTPHeaderStrings.Add('');
  HTTPHeaderStrings.Add(Self.FParam_Source.Value);

  //΢��ͼƬ
  IdMultiPartFormDataStream.AddFile('pic',Self.FParam_Pic.Value,'application/octet-stream'   );

  //���Ƶ�HTTP����
  HTTPHeaderStrings.SaveToStream(HTTPPostStream);
  HTTPPostStream.Position:=HTTPPostStream.Size;
  IdMultiPartFormDataStream.Position:=0;
  HTTPPostStream.CopyFrom(IdMultiPartFormDataStream,IdMultiPartFormDataStream.Size  );

  //�������ʱ�ļ�
//  FileStream:=TFileStream.Create('IdMultiPartFormDataStream.txt',fmCreate);
//  HTTPPostStream.Position:=0;
//  FileStream.CopyFrom(HTTPPostStream,HTTPPostStream.Size  );
//  FileStream.Free;

  //HTTPPostStream.LoadFromFile('IdMultiPartFormDataStream.txt');

  HTTPHeaderStrings.Free;
  HTTPFooterStrings.Free;
  IdMultiPartFormDataStream.Free;
end;

function TSinaWeiboAPI_Statuses_Upload.ParseFromJson(
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
  GlobalSinaWeiboAPI_Statuses_Upload:=TSinaWeiboAPI_Statuses_Upload.Create;
  RegisterSinaWeiboAPI(GlobalSinaWeiboAPI_Statuses_Upload);


finalization
  //UnRegisterSinaWeiboAPI(GlobalSinaWeiboAPI_Statuses_Upload);
  //GlobalSinaWeiboAPI_Statuses_Upload.Free;


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


