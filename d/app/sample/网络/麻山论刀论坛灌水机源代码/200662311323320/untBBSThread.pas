unit untBBSThread; 


interface

uses Classes,untmod,sysutils,StrUtils,Forms,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IdBaseComponent, IdCookieManager,
  IdCookie;

type
  {�˴�������TsortThread��}
  TMs4fBBSThread=class(TThread)
  Private
  {��TMs4fBBSThread���ж��������¼���˽�б�Ԫ}
    TmpBBS:onebbs;
    sType:TType;
    BLogin:boolean;
    Start:boolean;
    Succeed:boolean;
    BExit:boolean;
  Protected
    {��TMs4fBBSThread��Խ����Tthread��Execute����}
    procedure Execute;override;
{==============��ǰ״̬====()==================================} 
procedure State;
  public
    Terminated:boolean;
    sName:string;
    startTime:TDateTime;
    {==============�̴߳���=====================================}
    constructor Create(sType1:TType);
    destructor Destroy; override;
    {==============������վ����==================================}
    procedure SetBBSName(sBBSName:string;sURLName:string='';sURL:string='');
  end;
  
implementation

uses untBBS, ACPfrm_Splash;
{=============================================================} 
{=============================================================}
{=============================================================} 
{=============================================================}
{=============================================================} 
{==============������վ����==================================}
procedure TMs4fBBSThread.SetBBSName(sBBSName:string;sURLName:string='';sURL:string='');
begin
  tmpbbs.Name:=sBBSName;
  sName:=sbbsname;
  case stype of
{����=====================} 
    analyze:tmpbbs.URL_Temp:=sURL;//��ҳ��ַ
{ע��=====================} 
    reg:loadbbsfromfile(tmpbbs,'Reg');
{��¼������=====================} 
    LoginAndNew,new:begin
      loadbbsfromfile(tmpbbs,'Login New');
      tmpbbs.URL_Temp:=sURL;//��̳��ַ
      tmpbbs.Error_Temp:=sURLName;//��̳��
    end;
{��¼���ظ�=====================} 
    LoginAndRevert,Revert:begin
      loadbbsfromfile(tmpbbs,'Login Revert');
      tmpbbs.URL_Temp:=sURL;//�ظ�ȫ��ַ
    end;
  end;//case
end;
{==============�̴߳���=====================================}
constructor TMs4fBBSThread.Create(sType1:TType);
begin
  sType:=sType1;
  starttime:=Now;
  inherited Create(true);//true=����֮�����,false=������
  //inherited SetPriority(2);
end;
{==============�߳̽���=====================================}
destructor TMs4fBBSThread.Destroy;
begin
  inherited Destroy;
end;
{==============��ǰ״̬======================================} 
procedure TMs4fBBSThread.State;
begin
  case stype of
{����=====================} 
    analyze:begin
      if Start then
      frmbbs.mng_bbsmemo.Text:=nowtime+tmpbbs.name+#9+'׼������...'
      else frmbbs.mng_bbsmemo.Text:=tmpbbs.Error_Temp;
    end;
{ע��=====================} 
    reg:begin
      if Start then
        frmbbs.reg_Memo.Lines.Insert(0,nowtime+tmpbbs.name+#9+'׼��ע��...')
      else 
      begin
        frmbbs.reg_Memo.Lines.Insert(0,tmpbbs.Error_Temp);
        if Succeed then//�ɹ����� 
        begin
          frmbbs.sb_reg.Caption:=inttostr(strtoint(frmbbs.sb_reg.Caption)+1);
          ACPfrmSplash.Ticon.Hint:=ACPfrmSplash.sappname+' '+ACPfrmSplash.sappver
            +#13+#10+'ע���ʺ���:'+frmbbs.sb_reg.Caption
            +#13+#10+'ע���ʺ���:'+frmbbs.sb_New.Caption
            +#13+#10+'ע���ʺ���:'+frmbbs.sb_Revert.Caption; //������ͼ��
          savebbstofile(tmpbbs,'AddAcc');//����ע��ɹ����ʺ�
        end;
        if (tmpbbs.AccountCount>round(frmbbs.set_regcount_edit.Value))
          and frmbbs.Set_regcount.Checked then bexit:=true;//�ﵽ��ע������ 
        if (time>frmbbs.Set_RegWhile_Time_Edit.Time) //������ע�ᶨʱ��
          and frmbbs.Set_RegWhile_Time.Checked then bexit:=true;
      end;//if  
    end;//if
{���� ��¼������==============} 
    New,LoginAndNew:begin
      if Start then
        frmbbs.New_Memo.Lines.Insert(0,nowtime+tmpbbs.name+#9+'׼��(��¼/����)...')
      else
      begin
        frmbbs.New_Memo.Lines.Insert(0,tmpbbs.Error_Temp);
        if Succeed then
        begin//�ɹ�����
          frmbbs.sb_new.Caption:=inttostr(strtoint(frmbbs.sb_new.Caption)+1);
          ACPfrmSplash.Ticon.Hint:=ACPfrmSplash.sappname+' '+ACPfrmSplash.sappver
            +#13+#10+'ע���ʺ���:'+frmbbs.sb_reg.Caption
            +#13+#10+'ע���ʺ���:'+frmbbs.sb_New.Caption
            +#13+#10+'ע���ʺ���:'+frmbbs.sb_Revert.Caption; //������ͼ��
          if (strtoint(frmbbs.sb_new.Caption)>frmbbs.set_newcount_edit.Value)
            and frmbbs.Set_newcount.Checked then bexit:=true;//�ﵽ�˷������� 
        end;
        if (time>frmbbs.Set_newWhile_Time_Edit.Time) //�����˷�����ʱ��
          and frmbbs.Set_newWhile_Time.Checked then bexit:=true;
        if ansicontainstext(tmpbbs.Error_Temp,tmpbbs.Error_EstopAccount) then
        begin
          tmpbbs.Account[tmpbbs.AccountIndex].State:=false;
          savebbstofile(tmpbbs,'account');
        end;
      end;
    end;
{�ظ� ��¼���ظ�=============} 
    Revert,LoginAndRevert:begin
      if Start then
        frmbbs.revert_Memo.Lines.Insert(0,nowtime+tmpbbs.name+#9+'׼��(��¼/����)...')
      else
      begin
        frmbbs.revert_Memo.Lines.Insert(0,tmpbbs.Error_Temp);//�����ɹ����
        if Succeed then
        begin//�ɹ�����
          frmbbs.sb_revert.Caption:=inttostr(strtoint(frmbbs.sb_revert.Caption)+1);
          ACPfrmSplash.Ticon.Hint:=ACPfrmSplash.sappname+' '+ACPfrmSplash.sappver
            +#13+#10+'ע���ʺ���:'+frmbbs.sb_reg.Caption
            +#13+#10+'ע���ʺ���:'+frmbbs.sb_New.Caption
            +#13+#10+'ע���ʺ���:'+frmbbs.sb_Revert.Caption; //������ͼ��
          if (strtoint(frmbbs.sb_revert.Caption)>frmbbs.set_revertcount_edit.Value)
            and frmbbs.Set_revertcount.Checked then bexit:=true;//�ﵽ�˶������� 
        end;
        if (time>frmbbs.Set_revertWhile_Time_Edit.Time) //�����˶�����ʱ��
          and frmbbs.Set_revertWhile_Time.Checked then bexit:=true;
        if ansicontainstext(tmpbbs.Error_Temp,tmpbbs.Error_EstopAccount) then
        begin
          tmpbbs.Account[tmpbbs.AccountIndex].State:=false;
          savebbstofile(tmpbbs,'account');
        end;
      end;
    end;
  end;//case 
  if Now-startTime>StrTotime('1:00:00') then Terminated:=True;
end;
{==================Execute����============================} 
procedure TMs4fBBSThread.Execute;
var idhttp1:tidhttp; idcookie1:tidcookiemanager;s:string; t1:TDateTime;
begin
  t1:=now;
  repeat
  idcookie1:=tidcookiemanager.Create(Application);
  idhttp1:=tidhttp.Create(Application);
  s:=tmpbbs.error_temp;
  try
    START:=true; synchronize(state);start:=false;//��ʼ״̬
    idhttp1.CookieManager:=idCookie1;
    IdHTTP1.Request.ContentType:= 'application/x-www-form-urlencoded';
    IdHTTP1.Request.UserAgent:= 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.1.4322)';
    idhttp1.AllowCookies:=true;
    frmbbs.SetProxy(idhttp1);//���ô���
    case stype of
{����=====================} 
    analyze:begin
      bexit:=true;
    end;
{ע��=====================} 
    reg:begin
      loadbbsfromfile(tmpbbs,'reg');
      frmbbs.SetBBS(tmpbbs);//����ע������
      Succeed:=postreg(idhttp1,tmpbbs);
      synchronize(state);//�ɹ������������ʾ
    end;
{��¼������=====================} 
    LoginAndNew,new:begin//
      if frmbbs.Set_AlwaysLogin.Checked or not BLogin then
      begin
        BLogin:=loginbbs(idhttp1,tmpbbs,idcookie1,-1);
        synchronize(state);
        tmpbbs.error_temp:=s;
        appsleep(frmbbs.set_LoginOKSleep.Value);
      end;
      Succeed:=postnew(idhttp1,tmpbbs,idcookie1);
      synchronize(state);//�ɹ������������ʾ
      tmpbbs.error_temp:=s;
    end;
{��¼���ظ�=====================} 
    LoginAndRevert,Revert:begin
      if frmbbs.Set_AlwaysLogin.Checked or not BLogin then
      begin
        BLogin:=loginbbs(idhttp1,tmpbbs,idcookie1,-1);
        synchronize(state);
        appsleep(frmbbs.set_LoginOKSleep.Value);//��¼ͣ��
      end;
      Succeed:=postrevert(idhttp1,tmpbbs,idcookie1);
      synchronize(state);//�ɹ������������ʾ
    end;
    end;//case
  finally freeandnil(idCookie1);freeandnil(idhttp1);end;
  if Now-t1>StrTotime('1:00:00') then Terminated:=True;
  until Terminated or BExit;
end;
{=============================================================}
{=============================================================} 
{=============================================================}
{=============================================================} 
{=============================================================}
{=============================================================} 
end.

