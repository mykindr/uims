unit uSinaWeiboAPI_Statuses_Friends_TimeLine;

interface

uses
  Windows,SysUtils,Classes,
  uSinaWeiboItem,
  uSinaWeiboAPI,
  uSinaWeiboAPIConst,
  uSinaWeiboParam,
  uLkJson,
  Variants,
  Dialogs;


type
  TSinaWeiboAPI_Statuses_Friends_TimeLine=class(TSinaWeiboAPIItem)
  private
    FWeiboList:TSinaWeiboList;
    FParam_Feature: TQueryParameter;
    FParam_Max_Id: TQueryParameter;
    FParam_Base_App: TQueryParameter;
    FParam_Source: TQueryParameter;
    FParam_Count: TQueryParameter;
    FParam_Since_Id: TQueryParameter;
    FParam_Page: TQueryParameter;
  protected
    //�ӷ��������ص�Jason��Ϣ�������û���Ϣ
    function ParseFromJson(Response:String):Boolean;override;
  public
    constructor Create;
    destructor Destroy;override;
  public
    //������� 	��ѡ	���ͼ���Χ	˵��
    //source	true	string	����Ӧ��ʱ�����AppKey��
    //���ýӿ�ʱ�����Ӧ�õ�Ψһ��ݡ�������OAuth��Ȩ��ʽ����Ҫ�˲�����
    property Param_Source:TQueryParameter read FParam_Source;
    //since_id	false	int64	��ָ���˲�������ֻ����ID��since_id���΢����Ϣ
    //������since_id����ʱ�����΢����Ϣ����
    property Param_Since_Id:TQueryParameter read FParam_Since_Id;
    //max_id	false	int64	��ָ���˲������򷵻�IDС�ڻ����max_id��΢����Ϣ
    property Param_Max_Id:TQueryParameter read FParam_Max_Id;
    //count	false	int��Ĭ��ֵ20�����ֵ200��	ָ��Ҫ���صļ�¼������
    property Param_Count:TQueryParameter read FParam_Count;
    //page	false	int��Ĭ��ֵ1��	ָ�����ؽ����ҳ�롣
    //���ݵ�ǰ��¼�û�����ע���û�������Щ����ע�û������΢������
    //��ҳ��������ܲ鿴���ܼ�¼����������ͬ��ͨ������ܲ鿴1000�����ҡ�
    property Param_Page:TQueryParameter read FParam_Page;
    //base_app	false	int	�Ƿ���ڵ�ǰӦ������ȡ���ݡ�1Ϊ���Ʊ�Ӧ��΢����0Ϊ�������ơ�
    property Param_Base_App:TQueryParameter read FParam_Base_App;
    //feature	false	int	΢�����ͣ�0ȫ����1ԭ����2ͼƬ��3��Ƶ��4����.
    //����ָ�����͵�΢����Ϣ���ݡ�
    property Param_Feature:TQueryParameter read FParam_Feature;
  public
    //��ȡ����΢���б�
    property WeiboList:TSinaWeiboList read FWeiboList;
  end;


var
  GlobalSinaWeiboAPI_Statuses_Friends_TimeLine:TSinaWeiboAPI_Statuses_Friends_TimeLine;

implementation

{ TSinaWeiboAPI_Statuses_Friends_TimeLine }

constructor TSinaWeiboAPI_Statuses_Friends_TimeLine.Create;
begin
  Inherited Create(
                          CONST_API_Statuses_Friends_TimeLine_ID,
                          CONST_API_Statuses_Friends_TimeLine_NAME,
                          CONST_API_Statuses_Friends_TimeLine_URL,
                          CONST_API_Statuses_Friends_TimeLine_NEEDLOGIN,
                          CONST_API_Statuses_Friends_TimeLine_REQLIMIT,
                          CONST_API_Statuses_Friends_TimeLine_DESCRIP,
                          CONST_API_Statuses_Friends_TimeLine_STYLES,
                          CONST_API_Statuses_Friends_TimeLine_REQMETHOD
                  );

  FWeiboList:=TSinaWeiboList.create;

  FParam_Feature:=TQueryParameter.Create('feature','');
  FParam_Max_Id:=TQueryParameter.Create('max_id','');
  FParam_Base_App:=TQueryParameter.Create('base_app','');
  FParam_Source:=TQueryParameter.Create('source','');
  FParam_Count:=TQueryParameter.Create('count','');
  FParam_Since_Id:=TQueryParameter.Create('since_id','');
  FParam_Page:=TQueryParameter.Create('page','');

  Params.Add(FParam_Feature);
  Params.Add(FParam_Max_Id);
  Params.Add(FParam_Base_App);
  Params.Add(FParam_Source);
  Params.Add(FParam_Count);
  Params.Add(FParam_Since_Id);
  Params.Add(FParam_Page);

end;

destructor TSinaWeiboAPI_Statuses_Friends_TimeLine.Destroy;
begin
  FWeiboList.Free;
  inherited;
end;

function TSinaWeiboAPI_Statuses_Friends_TimeLine.ParseFromJson(
  Response:String): Boolean;
var
  I: Integer;
  JsonList:TlkJSONlist;
  AWeiboItem:TSinaWeiboItem;
  WeiboItemJson: TlkJSONobject;
begin
  Result:=False;
  FWeiboList.Clear;
  //��ȡ΢���б�
  JsonList := TlkJson.ParseText(Response) as TlkJSONlist;
  if JsonList<>nil then
  begin
    for I := 0 to JsonList.Count - 1 do
    begin
      WeiboItemJson:=JsonList.Child[I] as TlkJSONobject;
      if WeiboItemJson <> nil then
      begin
        AWeiboItem:=Self.FWeiboList.Add;
        AWeiboItem.LoadFromJson(WeiboItemJson);
      end;//if
    end;//for
    Result:=True;
    JsonList.Free;
  end;//if
end;


initialization
  GlobalSinaWeiboAPI_Statuses_Friends_TimeLine:=TSinaWeiboAPI_Statuses_Friends_TimeLine.Create;
  RegisterSinaWeiboAPI(GlobalSinaWeiboAPI_Statuses_Friends_TimeLine);


finalization
  //UnRegisterSinaWeiboAPI(GlobalSinaWeiboAPI_Statuses_Friends_TimeLine);
  //GlobalSinaWeiboAPI_Statuses_Friends_TimeLine.Free;


end.


//[
//    {
//        "created_at" : "Tue Nov 30 16:21:13 +0800 2010",
//        "text" : "ת��΢����",
//        "truncated" : false,
//        "retweeted_status" :
//        {
//            "created_at" : "Tue Nov 30 16:05:41 +0800 2010",
//            "text" : "�Դ�����ĳ����㡢����㣬����������ķ�չ����չ��Ľ����������ʵ��Ҳ��һ����Զ��Եĳɰܡ����׼�׷�����ֳɰ�ȴ�ֵ������ó����㣬�����Ҳ�������㡣���Գ�Ҳ�ð�Ҳ�ã���������á�",
//            "truncated" : false,
//            "in_reply_to_status_id" : "",
//            "annotations" :
//            [
//
//            ],
//            "in_reply_to_screen_name" : "",
//            "geo" : null,
//            "user" :
//            {
//                "name" : "��Ԫ¡ӡ",
//                "domain" : "",
//                "geo_enabled" : true,
//                "followers_count" : 66710,
//                "statuses_count" : 77,
//                "favourites_count" : 0,
//                "city" : "1",
//                "description" : "�Ĵ�ȱ� ������� �������� �޼����� ��Ԫ���¹ٷ���վ��http://www.guiyuanchansi.net",
//                "verified" : true,
//                "id" : 1799833402,
//                "gender" : "m",
//                "friends_count" : 4,
//                "screen_name" : "��Ԫ¡ӡ",
//                "allow_all_act_msg" : false,
//                "following" : false,
//                "url" : "http://1",
//                "profile_image_url" : "http://tp3.sinaimg.cn/1799833402/50/1283207796",
//                "created_at" : "Tue Aug 24 00:00:00 +0800 2010",
//                "province" : "42",
//                "location" : "���� �人"
//            },
//            "favorited" : false,
//            "in_reply_to_user_id" : "",
//            "id" : 3980364843,
//            "source" : "<a href=\"http://t.sina.com.cn\" rel=\"nofollow\">����΢��</a>"
//        },
//        "in_reply_to_status_id" : "",
//        "annotations" :
//        [
//
//        ],
//        "in_reply_to_screen_name" : "",
//        "geo" : null,
//        "user" :
//        {
//            "name" : "������Ь",
//            "domain" : "banlatuoxie",
//            "geo_enabled" : true,
//            "followers_count" : 56,
//            "statuses_count" : 333,
//            "favourites_count" : 1,
//            "city" : "5",
//            "description" : "�������ֻ�ܰѻ�����ȥ����û������Ͳ����ҵ����ˣ�",
//            "verified" : false,
//            "id" : 1799824787,
//            "gender" : "m",
//            "friends_count" : 76,
//            "screen_name" : "������Ь",
//            "allow_all_act_msg" : false,
//            "following" : false,
//            "url" : "http://blog.sina.com.cn/lingdianjingq",
//            "profile_image_url" : "http://tp4.sinaimg.cn/1799824787/50/1289443070/1",
//            "created_at" : "Sun Sep 05 00:00:00 +0800 2010",
//            "province" : "11",
//            "location" : "���� ������"
//        },
//        "favorited" : false,
//        "in_reply_to_user_id" : "",
//        "id" : 3980654229,
//        "source" : "<a href=\"http://t.sina.com.cn\" rel=\"nofollow\">����΢��</a>"
//    },
//...
//]

//
//      Result:=True;
//      Response:=''
//                +'                                                                                           '
//                +'    {                                                                                       '
//                +'        "created_at" : "Tue Nov 30 16:21:13 +0800 2010",                                    '
//                +'        "text" : "ת��΢����",                                                              '
//                +'        "truncated" : false,                                                                '
//                +'        "retweeted_status" :                                                                '
//                +'        {                                                                                   '
//                +'            "created_at" : "Tue Nov 30 16:05:41 +0800 2010",                                '
//                +'            "text" : "�Դ�����ĳ����㡢����㣬����������ķ�չ����չ��Ľ����            '
//                +'                ������ʵ��Ҳ��һ����Զ��Եĳɰܡ����׼�׷�����ֳɰ�ȴ�ֵ������ó����㣬  '
//                +'                �����Ҳ�������㡣���Գ�Ҳ�ð�Ҳ�ã���������á�",                          '
//                +'            "truncated" : false,                                                            '
//                +'            "in_reply_to_status_id" : "",                                                   '
//                +'            "annotations" :                                                                 '
//                +'            [                                                                               '
//                +'                                                                                            '
//                +'            ],                                                                              '
//                +'            "in_reply_to_screen_name" : "",                                                 '
//                +'            "geo" : null,                                                                   '
//                +'            "user" :                                                                        '
//                +'            {                                                                               '
//                +'                "name" : "��Ԫ¡ӡ",                                                        '
//                +'                "domain" : "",                                                              '
//                +'                "geo_enabled" : true,                                                       '
//                +'                "followers_count" : 66710,                                                  '
//                +'                "statuses_count" : 77,                                                      '
//                +'                "favourites_count" : 0,                                                     '
//                +'                "city" : "1",                                                               '
//                +'                "description" : "�Ĵ�ȱ� ������� �������� �޼����� ��Ԫ���¹ٷ���վ��http:'
//                +'                      //www.guiyuanchansi.net",                                             '
//                +'                "verified" : true,                                                          '
//                +'                "id" : 1799833402,                                                          '
//                +'                "gender" : "m",                                                             '
//                +'                "friends_count" : 4,                                                        '
//                +'                "screen_name" : "��Ԫ¡ӡ",                                                 '
//                +'                "allow_all_act_msg" : false,                                                '
//                +'                "following" : false,                                                        '
//                +'                "url" : "http://1",                                                         '
//                +'                "profile_image_url" : "http://tp3.sinaimg.cn/1799833402/50/1283207796",     '
//                +'                "created_at" : "Tue Aug 24 00:00:00 +0800 2010",                            '
//                +'                "province" : "42",                                                          '
//                +'                "location" : "���� �人"                                                    '
//                +'            },                                                                              '
//                +'            "favorited" : false,                                                            '
//                +'            "in_reply_to_user_id" : "",                                                     '
//                +'            "id" : 3980364843,                                                              '
//                +'            "source" : "<a href=\"http://t.sina.com.cn\" rel=\"nofollow\">����΢��</a>"     '
//                +'        },                                                                                  '
//                +'        "in_reply_to_status_id" : "",                                                       '
//                +'        "annotations" :                                                                     '
//                +'        [                                                                                   '
//                +'                                                                                            '
//                +'        ],                                                                                  '
//                +'        "in_reply_to_screen_name" : "",                                                     '
//                +'        "geo" : null,                                                                       '
//                +'        "user" :                                                                            '
//                +'        {                                                                                   '
//                +'            "name" : "������Ь",                                                            '
//                +'            "domain" : "banlatuoxie",                                                       '
//                +'            "geo_enabled" : true,                                                           '
//                +'            "followers_count" : 56,                                                         '
//                +'            "statuses_count" : 333,                                                         '
//                +'            "favourites_count" : 1,                                                         '
//                +'            "city" : "5",                                                                   '
//                +'            "description" : "�������ֻ�ܰѻ�����ȥ����û������Ͳ����ҵ����ˣ�",         '
//                +'            "verified" : false,                                                             '
//                +'            "id" : 1799824787,                                                              '
//                +'            "gender" : "m",                                                                 '
//                +'            "friends_count" : 76,                                                           '
//                +'            "screen_name" : "������Ь",                                                     '
//                +'            "allow_all_act_msg" : false,                                                    '
//                +'            "following" : false,                                                            '
//                +'            "url" : "http://blog.sina.com.cn/lingdianjingq",                                '
//                +'            "profile_image_url" : "http://tp4.sinaimg.cn/1799824787/50/1289443070/1",       '
//                +'            "created_at" : "Sun Sep 05 00:00:00 +0800 2010",                                '
//                +'            "province" : "11",                                                              '
//                +'            "location" : "���� ������"                                                      '
//                +'        },                                                                                  '
//                +'        "favorited" : false,                                                                '
//                +'        "in_reply_to_user_id" : "",                                                         '
//                +'        "id" : 3980654229,                                                                  '
//                +'        "source" : "<a href=\"http://t.sina.com.cn\" rel=\"nofollow\">����΢��</a>"         '
//                +'    }                                                                                       '
//                +'                                                                                           ';

