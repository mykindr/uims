unit uSinaWeiboAPI_Statuses_User_TimeLine;

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

//ע������
// :idΪREST���Ĳ�����ʹ�øò�����URLΪ��
//http://api.t.sina.com.cn/statuses/user_timeline/:id.format
//ʹ��ʾ�����£�
//http://api.t.sina.com.cn/statuses/user_timeline/11051.xml?source=appkey
//http://api.t.sina.com.cn/statuses/user_timeline/timyang.json?source=appkey
//Ĭ�Ϸ������15�����ڵ�΢����Ϣ
//���ڷ�ҳ���ƣ���ʱ���ֻ�ܷ����û����µ�200��΢����Ϣ
//�û����ֻ���������200����¼

//�ֶ�˵�� - status
//created_at: ����ʱ��
//id: ΢��ID
//text: ΢����Ϣ����
//source: ΢����Դ
//favorited: �Ƿ����ղ�
//truncated: �Ƿ񱻽ض�
//in_reply_to_status_id: �ظ�ID
//in_reply_to_user_id: �ظ���UID
//in_reply_to_screen_name: �ظ����ǳ�
//thumbnail_pic: ����ͼ
//bmiddle_pic: ����ͼƬ
//original_pic��ԭʼͼƬ
//user: ������Ϣ
//retweeted_status: ת���Ĳ��ģ�����Ϊstatus���������ת������û�д��ֶ�

//�ֶ�˵�� - user
//id: �û�UID
//screen_name: ΢���ǳ�
//name: �Ѻ���ʾ���ƣ�ͬ΢���ǳ�
//province: ʡ�ݱ��루�ο�ʡ�ݱ����
//city: ���б��루�ο����б����
//location����ַ
//description: ��������
//url: �û����͵�ַ
//profile_image_url: �Զ���ͼ��
//domain: �û����Ի�URL
//gender: �Ա�,m--�У�f--Ů,n--δ֪
//followers_count: ��˿��
//friends_count: ��ע��
//statuses_count: ΢����
//favourites_count: �ղ���
//created_at: ����ʱ��
//following: �Ƿ��ѹ�ע(�������ݲ�֧��)
//verified: ��V��ʾ���Ƿ�΢����֤�û�

type
  TSinaWeiboAPI_Statuses_User_TimeLine=class(TSinaWeiboAPIItem)
  private
    FWeiboList:TSinaWeiboList;
    FParam_Feature: TQueryParameter;
    FParam_Max_Id: TQueryParameter;
    FParam_Base_App: TQueryParameter;
    FParam_Source: TQueryParameter;
    FParam_Count: TQueryParameter;
    FParam_Since_Id: TQueryParameter;
    FParam_Page: TQueryParameter;
    FParam_Screen_Name: TQueryParameter;
    FParam_Id: TQueryParameter;
    FParam_User_Id: TQueryParameter;
  protected
    Function CallAPIURL:String;override;
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
    //���:id��user_id��screen_name����������δָ�����򷵻ص�ǰ��¼�û���������΢����Ϣ�б�
    //:id	false	int64/string	�����û�ID(int64)����΢���ǳ�(string)����ָ���û�������΢����Ϣ�б��ò���ΪREST���������μ�ע������
    Property Param_Id:TQueryParameter read FParam_Id;
    //user_id	false	int64	�û�ID����Ҫ�����������û�ID��΢���ǳơ���΢���ǳ�Ϊ���ֵ��º��û�ID�������壬�ر��ǵ�΢���ǳƺ��û�IDһ����ʱ�򣬽���ʹ�øò���
    Property Param_User_Id:TQueryParameter read FParam_User_Id;
    //screen_name	false	string	΢���ǳƣ���Ҫ�����������û�UID��΢���ǳƣ�������һ�������������ʱ�򣬽���ʹ�øò���
    Property Param_Screen_Name:TQueryParameter read FParam_Screen_Name;
  public
    //��ȡ����΢���б�
    property WeiboList:TSinaWeiboList read FWeiboList;
  end;


var
  GlobalSinaWeiboAPI_Statuses_User_TimeLine:TSinaWeiboAPI_Statuses_User_TimeLine;

implementation

{ TSinaWeiboAPI_Statuses_User_TimeLine }

constructor TSinaWeiboAPI_Statuses_User_TimeLine.Create;
begin
  Inherited Create(
                          CONST_API_Statuses_User_TimeLine_ID,
                          CONST_API_Statuses_User_TimeLine_NAME,
                          CONST_API_Statuses_User_TimeLine_URL,
                          CONST_API_Statuses_User_TimeLine_NEEDLOGIN,
                          CONST_API_Statuses_User_TimeLine_REQLIMIT,
                          CONST_API_Statuses_User_TimeLine_DESCRIP,
                          CONST_API_Statuses_User_TimeLine_STYLES,
                          CONST_API_Statuses_User_TimeLine_REQMETHOD
                  );

  FWeiboList:=TSinaWeiboList.create;

  FParam_Feature:=TQueryParameter.Create('feature','');
  FParam_Max_Id:=TQueryParameter.Create('max_id','');
  FParam_Base_App:=TQueryParameter.Create('base_app','');
  FParam_Source:=TQueryParameter.Create('source','');
  FParam_Count:=TQueryParameter.Create('count','');
  FParam_Since_Id:=TQueryParameter.Create('since_id','');
  FParam_Page:=TQueryParameter.Create('page','');
  FParam_Screen_Name:=TQueryParameter.Create('screen_name','');
  FParam_Id:=TQueryParameter.Create('id','',False);
  FParam_User_Id:=TQueryParameter.Create('user_id','');

  Params.Add(FParam_Feature);
  Params.Add(FParam_Max_Id);
  Params.Add(FParam_Base_App);
  Params.Add(FParam_Source);
  Params.Add(FParam_Count);
  Params.Add(FParam_Since_Id);
  Params.Add(FParam_Page);
  Params.Add(FParam_Screen_Name);
  Params.Add(FParam_Id);
  Params.Add(FParam_User_Id);

end;

function TSinaWeiboAPI_Statuses_User_TimeLine.CallAPIURL: String;
begin
  if Self.FParam_Id.Value<>'' then
  begin
    Result:=URL+'/'+Self.FParam_Id.Value;
  end
  else
  begin
    Result:=Inherited;
  end;
end;

destructor TSinaWeiboAPI_Statuses_User_TimeLine.Destroy;
begin
  FWeiboList.Free;
  inherited;
end;

function TSinaWeiboAPI_Statuses_User_TimeLine.ParseFromJson(
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
  GlobalSinaWeiboAPI_Statuses_User_TimeLine:=TSinaWeiboAPI_Statuses_User_TimeLine.Create;
  RegisterSinaWeiboAPI(GlobalSinaWeiboAPI_Statuses_User_TimeLine);


finalization
  //UnRegisterSinaWeiboAPI(GlobalSinaWeiboAPI_Statuses_User_TimeLine);
  //GlobalSinaWeiboAPI_Statuses_User_TimeLine.Free;


end.


