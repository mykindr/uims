unit uSinaWeiboAPIConst;

interface

uses
  Windows,SysUtils;


type
  //API�ĵ��÷�ʽ��ʹ��Json����Xml�ĵ�
  TCallAPIStyle=(cpsJson,cpsXml);
  TCallAPIStyleSet=set of TCallAPIStyle;
  TCallAPIHTTPRequestMethod=(rmPost,rmGet);

const
  //��֤�û��������û�����
  CONST_API_Statuses_Verify_Credentials_ID         =0;
  CONST_API_Statuses_Verify_Credentials_NAME       ='account_verify_credentials';
  CONST_API_Statuses_Verify_Credentials_URL        ='http://api.t.sina.com.cn/account/verify_credentials';
  CONST_API_Statuses_Verify_Credential_DESCRIP     ='��֤�û��Ƿ��Ѿ���ͨ΢������'
                                                    +'����û�������ͨ��֤�����֤�ɹ������û��Ѿ���ͨ΢���򷵻� http״̬Ϊ 200�����򷵻�403����'
                                                    +'�ýӿڳ�source���⣬������������';
  CONST_API_Statuses_Verify_Credentials_STYLES     =[cpsJson,cpsXml];
  CONST_API_Statuses_Verify_Credentials_NEEDLOGIN  =True;
  CONST_API_Statuses_Verify_Credentials_REQLIMIT   =True;
  CONST_API_Statuses_Verify_Credentials_REQMETHOD  =rmGet;


  //��ȡ��ǰ��¼�û���������ע�û�������΢��
  CONST_API_Statuses_Friends_TimeLine_ID         =1;
  CONST_API_Statuses_Friends_TimeLine_NAME       ='statuses_friends_timeline';
  CONST_API_Statuses_Friends_TimeLine_URL        ='http://api.t.sina.com.cn/statuses/friends_timeline';
  CONST_API_Statuses_Friends_TimeLine_DESCRIP    ='��ȡ��ǰ��¼�û���������ע�û�������΢����Ϣ��'
                                                  +'���û���¼ http://t.sina.com.cn ���ڡ��ҵ���ҳ���п�����������ͬ��'
                                                  +'����statuses/home_timeline';
  CONST_API_Statuses_Friends_TimeLine_STYLES     =[cpsJson,cpsXml];
  CONST_API_Statuses_Friends_TimeLine_NEEDLOGIN  =True;
  CONST_API_Statuses_Friends_TimeLine_REQLIMIT   =True;
  CONST_API_Statuses_Friends_TimeLine_REQMETHOD  =rmGet;


  //��ȡ��ǰ��¼�û���������ע�û�������΢��
  CONST_API_Statuses_Update_ID         =2;
  CONST_API_Statuses_Update_NAME       ='statuses_update';
  CONST_API_Statuses_Update_URL        ='http://api.t.sina.com.cn/statuses/update';
  CONST_API_Statuses_Update_DESCRIP    ='����һ��΢����Ϣ��Ҳ����ͬʱת��ĳ��΢����'
                                        +'���������POST��ʽ�ύ��';
  CONST_API_Statuses_Update_STYLES     =[cpsJson,cpsXml];
  CONST_API_Statuses_Update_NEEDLOGIN  =True;
  CONST_API_Statuses_Update_REQLIMIT   =True;
  CONST_API_Statuses_Update_REQMETHOD  =rmPost;



  //��ȡ��ǰ��¼�û���������ע�û�������΢��
  CONST_API_Statuses_User_TimeLine_ID         =3;
  CONST_API_Statuses_User_TimeLine_NAME       ='statuses_user_timeline';
  CONST_API_Statuses_User_TimeLine_URL        ='http://api.t.sina.com.cn/statuses/user_timeline';
  CONST_API_Statuses_User_TimeLine_DESCRIP    ='�����û����·����΢����Ϣ�б�';
  CONST_API_Statuses_User_TimeLine_STYLES     =[cpsJson,cpsXml];
  CONST_API_Statuses_User_TimeLine_NEEDLOGIN  =True;
  CONST_API_Statuses_User_TimeLine_REQLIMIT   =True;
  CONST_API_Statuses_User_TimeLine_REQMETHOD  =rmGet;

  //��ȡ��ǰ�û�Web��վδ����Ϣ��
  CONST_API_Statuses_Unread_ID         =4;
  CONST_API_Statuses_Unread_NAME       ='statuses_unread';
  CONST_API_Statuses_Unread_URL        ='http://api.t.sina.com.cn/statuses/unread';
  CONST_API_Statuses_Unread_DESCRIP    ='��ȡ��ǰ�û�Web��վδ����Ϣ����������'
                                                +'�Ƿ�����΢����Ϣ'
                                                +'�����ᵽ���ҡ���΢����Ϣ��'
                                                +'��������'
                                                +'��˽����'
                                                +'�·�˿����'
                                                +'�˽ӿڶ�Ӧ������ӿ�Ϊstatuses/reset_count��';
  CONST_API_Statuses_Unread_STYLES     =[cpsJson,cpsXml];
  CONST_API_Statuses_Unread_NEEDLOGIN  =True;
  CONST_API_Statuses_Unread_REQLIMIT   =True;
  CONST_API_Statuses_Unread_REQMETHOD  =rmGet;

  //�����ͼƬ��΢����������POST��ʽ�ύpic��������Content-Type��������Ϊmultipart/form-data��ͼƬ��С<5M��
  CONST_API_Statuses_Upload_ID         =5;
  CONST_API_Statuses_Upload_NAME       ='statuses_upload';
  CONST_API_Statuses_Upload_URL        ='http://api.t.sina.com.cn/statuses/upload';
  CONST_API_Statuses_Upload_DESCRIP    ='�����ͼƬ��΢����'
                                       +'������POST��ʽ�ύpic������'
                                       +'��Content-Type��������Ϊmultipart/form-data��'
                                       +'ͼƬ��С<5M��';
  CONST_API_Statuses_Upload_STYLES     =[cpsJson,cpsXml];
  CONST_API_Statuses_Upload_NEEDLOGIN  =True;
  CONST_API_Statuses_Upload_REQLIMIT   =True;
  CONST_API_Statuses_Upload_REQMETHOD  =rmPost;


implementation

end.
