unit U_RequestID;

interface
  const
    Vision          :byte=$30;
    Login	          :LongWord=$00000001;	//CP��SMGW��¼����
    Login_resp	    :LongWord=$80000001;	//CP��SMGW��¼�Ļ�Ӧ
    Submit	        :LongWord=$00000002;	//CP���Ͷ���Ϣ����
    Submit_resp	    :LongWord=$80000002;//	CP���Ͷ���Ϣ�Ļ�Ӧ
    Deliver	        :LongWord=$00000003;	//SMGW��CP���Ͷ���Ϣ����
    Deliver_resp    :LongWord=$80000003;//	SMGW��CP���Ͷ���Ϣ�Ļ�Ӧ
    Active_test	    :LongWord=$00000004;	//����ͨ����·�Ƿ���������(�ɿͻ��˷���CP��SMGW����ͨ����ʱ���ʹ�������ά������)
    Active_test_resp:LongWord=$80000004;//	����ͨ����·�Ƿ������Ļ�Ӧ
    xExit	          :LongWord=$00000006;//	�˳�����
    Exit_resp	      :LongWord=$80000006;//	�˳�����Ļ�Ӧ
    Query	          :LongWord=$00000007;//	CPͳ�Ʋ�ѯ����
    Query_resp	    :LongWord=$80000007;//	CPͳ�Ʋ�ѯ��Ӧ



    //��ѡ������ǩ  TLV_Lab_
    TLV_Lab_TP_pid	=$0001;
    TLV_Lab_TP_udhi	=$0002;
    TLV_Lab_LinkID	=$0003;
    TLV_Lab_ChargeUserType	=$0004;
    TLV_Lab_ChargeTermType	=$0005;
    TLV_Lab_ChargeTermPseudo	=$0006;
    TLV_Lab_DestTermType	=$0007;
    TLV_Lab_DestTermPseudo	=$0008;
    TLV_Lab_PkTotal	=$0009;
    TLV_Lab_PkNumber	=$000A;
    TLV_Lab_SubmitMsgType	=$000B;
    TLV_Lab_SPDealReslt	=$000C;
    TLV_Lab_SrcTermType	=$000D;
    TLV_Lab_SrcTermPseudo	=$000E;
    //TLV_Lab_NodesCount	=$000F;
    TLV_Lab_MsgSrc	=$0010;
    //TLV_Lab_SrcType	=$0011;
    TLV_Lab_MServiceID	=$0012;


implementation

end.
