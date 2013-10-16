{------------------------P-Mail 0.5 beta��-----------------
��̹��ߣ�Delphi 6 + D6_upd2 
������������ɫ PLQ������
�����������봿����ѣ�����ѧϰʹ�ã�ϣ������ʹ����ʱ������λ�
������Ա��������˸Ľ���Ҳϣ������������ϵ
My E-Mail:plq163001@163.com
	  plq163003@163.com
-----------------------------------------------------2002.5.19}


unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, XPMenu, ToolWin, ComCtrls, ImgList, Buttons, ExtCtrls,
  StdCtrls, DB, ADODB,DbTables, Mail2000,shellAPI, CoolTrayIcon, ComObj, ActiveX, ShlObj, Registry
  ;

type
  TfmMain = class(TForm)
    MainMenu1: TMainMenu;
    User: TMenuItem;
    quit: TMenuItem;
    N2: TMenuItem;
    meuDeleteUser: TMenuItem;
    meuUserSet: TMenuItem;
    meuAddNew: TMenuItem;
    XPMenu1: TXPMenu;
    mail: TMenuItem;
    meuSaveMail: TMenuItem;
    N3: TMenuItem;
    meuAddNote: TMenuItem;
    meuDeleteMail: TMenuItem;
    meuReplyTo: TMenuItem;
    meuNewMail: TMenuItem;
    Help1: TMenuItem;
    meuAbout: TMenuItem;
    meuHelp: TMenuItem;
    CoolBar1: TCoolBar;
    meuGetMail: TMenuItem;
    N1: TMenuItem;
    ToolBar1: TToolBar;
    ImageList1: TImageList;
    ToolButton1: TToolButton;
    tbAddNew: TToolButton;
    tbUserSet: TToolButton;
    ToolButton4: TToolButton;
    tbGetMail: TToolButton;
    tbNewMail: TToolButton;
    tbReply: TToolButton;
    ToolButton8: TToolButton;
    tbAsNote: TToolButton;
    ToolButton10: TToolButton;
    tbHelp: TToolButton;
    ImageList2: TImageList;
    ToolButton12: TToolButton;
    tbAbout: TToolButton;
    tbSaveMail: TToolButton;
    Panel1: TPanel;
    Panel2: TPanel;
    Bevel1: TBevel;
    Panel3: TPanel;
    sb1: TStatusBar;
    gbUser: TGroupBox;
    gbAF: TGroupBox;
    gbText: TGroupBox;
    tvUser: TTreeView;
    lvAF: TListView;
    meoText: TMemo;
    gbMail: TGroupBox;
    lvMail: TListView;
    Label1: TLabel;
    labFromName: TLabel;
    Label2: TLabel;
    labFromAddress: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    labSubject: TLabel;
    labDate: TLabel;
    adocPm: TADOConnection;
    adoqUser: TADOQuery;
    adoqMail: TADOQuery;
    adoqAF: TADOQuery;
    POP: TPOP2000;
    Msg: TMailMessage2000;
    sadMail: TSaveDialog;
    pmUser: TPopupMenu;
    pmMail: TPopupMenu;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N13: TMenuItem;
    CoolTrayIcon1: TCoolTrayIcon;
    PopupMenu1: TPopupMenu;
    PMail1: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    PMail05beta1: TMenuItem;
    N17: TMenuItem;
    N12: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;

    {n4,addNewuser
        n5,setuser
        n6,deleuser
        n8,getmail
        n9,newmail
        n10 ,replayto
        n11,addAsn
        n13,savemail}

    procedure quitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tvUserClick(Sender: TObject);
    procedure lvMailClick(Sender: TObject);
    procedure meuAddNewClick(Sender: TObject);
    procedure tvUserChange(Sender: TObject; Node: TTreeNode);
    procedure meuUserSetClick(Sender: TObject);
    procedure meuDeleteUserClick(Sender: TObject);
    procedure tbAsNoteClick(Sender: TObject);
    procedure Retrieve(Sender: TObject);

    procedure meuGetMailClick(Sender: TObject);
   
    procedure meuNewMailClick(Sender: TObject);
    procedure meuDeleteMailClick(Sender: TObject);
    procedure lvAFDblClick(Sender: TObject);
    procedure meuAddNoteClick(Sender: TObject);
    procedure meuReplyToClick(Sender: TObject);
    procedure meuSaveMailClick(Sender: TObject);

    procedure UpdatetvUser(Sender: TObject);
    procedure adoqUserQuery(target:string);
    procedure isUserSelected(Selected:boolean);
    procedure isMailSelected(Selected:boolean);
    procedure PMail1Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure N16Click(Sender: TObject);
    procedure meuAboutClick(Sender: TObject);
    procedure meuHelpClick(Sender: TObject);
    procedure CoolTrayIcon1DblClick(Sender: TObject);

    function Encrypt(const S: String; Key: Word): String;//����
    function Decrypt(const S: String; Key: Word): String;//����

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
        UserName:string;	//�ʻ���
        UserID:string;		//�������û���
        UserAddress:string;	//�û������ʼ���ַ
        Pwd:string;		//��½����
        PopHost:string;		//pop������ַ
        SmtpHost:string;	//smtp������ַ
        fmMain: TfmMain;
        const c1:integer =52845;
        const c2:integer =22719;

implementation

uses NewUser, UseSet, AsNote, getmail, Send, addNewAs, about;

{$R *.dfm}

procedure TfmMain.quitClick(Sender: TObject);
begin
        close;
end;

procedure TfmMain.FormCreate(Sender: TObject);
var
  sDefaultDB, sConStr: String;
  //index:integer;
  ShLink: IShellLink;
  PFile: IPersistFile;
  FileName: string;
  WFileName: WideString;
  Reg: TRegIniFile;
  AnObj: IUnknown;
  time:LongInt;

begin
        time:=GetTickCount div 350;
        while ((GetTickCount div 350)<(time+4)) do
                Sleep(1);
  sDefaultDB :=ExtractFilePath(ParamStr(0)) +'pm.mdb';    //Access���ݿ��ļ�·��

  sConStr := 'Provider=MSDASQL.1;Persist Security Info=False;' +
             'User ID=pm;Database Password=pm;Data Source=MS Access Database;' +        //��̬����dsn
             'Extended Properties="DSN=MS Access Database;' +
             'DBQ=' + sDefaultDB + ';FIL=MS Access;MaxBufferSize=2048;' +
             'PageTimeout=5;UID=admin;";Initial Catalog=' + sDefaultDB;

  with adocPm do begin          //�������ݿ�
    Close;
    Connected := False;
    ConnectionString := '';
    ConnectionString := sConStr;
    try
      Connected := True;
    except
      showmessage('�������ݿⶪʧ���𻵣�����װP-Mail!');
    end;
  end;
  fmMain.UpdatetvUser(Sender); 
  {adoqUser.Close;
  adoqUser.SQL.Clear;
  adoqUser.SQL.Text:='select * from User';
  adoqUser.Open;

  if adoqUser.RecordCount>0 then                //��ȡUserName������Ӧ��TreeNode of tvUser
  begin
        for index:=0 to adoqUser.RecordCount-1 do
        begin
                //adoqUser.FieldByName('UserName').AsString;
                tvUser.Items.Add(tvUser.Selected, adoqUser.FieldByName('UserName').AsString );
                adoqUser.Next;
        end;
  end;

  adoqUser.Close;}

        isUserSelected(false);
        isMailSelected(false);
        meuAddNew.Enabled:=true;
        tbAddNew.Enabled:=true;
        n4.Enabled:=true;

        AnObj := CreateComObject (CLSID_ShellLink);             //��ݷ�ʽ�ĳ�ʼ��
        ShLink := AnObj as IShellLink;
        PFile := AnObj as IPersistFile;
        FileName := ParamStr (0);
        ShLink.SetPath (PChar (FileName));
        ShLink.SetWorkingDirectory (PChar (ExtractFilePath (FileName)));





        Reg := TRegIniFile.Create('Software\MicroSoft\Windows\CurrentVersion\Explorer');
        WFileName := Reg.ReadString ('Shell Folders', 'Desktop', '') +'\'+'P-Mail 0.5 beta ��' + '.lnk';
        Reg.Free;
        PFile.Save (PWChar (WFileName), False);


        Reg := TRegIniFile.Create('Software\MicroSoft\Windows\CurrentVersion\Explorer');
        WFileName := Reg.ReadString ('Shell Folders', 'Start Menu', '') +'\' + 'P-Mail 0.5 beta ��' + '.lnk';
        Reg.Free;
        PFile.Save (PWChar (WFileName), False);



end;
procedure TfmMain.tvUserClick(Sender: TObject);         //��tvUser��TreeNode��ѡ��ʱ����Ӧ��User table �еļ�¼���������ȫ�ֱ�����
var
        //temp:string;
        i:integer;
        itm:TListItem;
        //temp:string;
begin
       if tvUser.Selected<>nil then
       begin
                fmMain.isMailSelected(false);
                fmMain.isUserSelected(true);
                fmMain.adoqUserQuery(tvUser.Selected.Text);
                {adoqUser.Close;
                adoqUser.SQL.Clear;
                adoqUser.SQL.Text:='select * from User where UserName='''+tvUser.Selected.Text+'''';
                adoqUser.Open;}

                UserName:=adoqUser.Fields.Fields[0].AsString;	//�ʻ���
                UserID:=adoqUser.Fields.Fields[1].AsString;		//�������û���
                UserAddress:=adoqUser.Fields.Fields[2].AsString;	//�û������ʼ���ַ
                PopHost:=adoqUser.Fields.Fields[3].AsString;		//pop������ַ
                SmtpHost:=adoqUser.Fields.Fields[4].AsString;
                Pwd:=adoqUser.Fields.Fields[5].AsString;        	//��½����
                {temp:=Decrypt(temp,200);
                :=temp;}
                adoqUser.Close;


                adoqMail.Close;
                adoqMail.SQL.Clear;
                adoqMail.SQL.Text:='select * from Mail where UserName='''+tvUser.Selected.Text+''' order by Nu desc';
                adoqMail.Open;

                if adoqMail.RecordCount>0 then          //ͬʱ��mail table ����UserName��Ӧ��mail��¼��������ʾ��lvMail(report)�У����ʼ���ǰ��
                begin
                        lvMail.Clear;
                        for  i:=0 to adoqMail.RecordCount-1 do
                        begin
                             itm:=lvMail.Items.Add;
                             itm.ImageIndex:=5;
                             itm.Caption:=adoqMail.Fields.Fields[3].AsString;
                             itm.SubItems.Add(adoqMail.Fields.Fields[2].AsString);
                             itm.SubItems.Add(adoqMail.Fields.Fields[1].AsString);
                             itm.SubItems.Add(adoqMail.Fields.Fields[4].AsString);
                             itm.SubItems.Add(adoqMail.Fields.Fields[7].AsString);

                             adoqMail.Next;
                        end;
                end;
                sb1.Panels.Items[1].Text:='���ʻ��ֹ����ʼ�'+IntToStr(adoqMail.RecordCount)+'��';
                adoqMail.Close;



                sb1.Panels.Items[0].Text:='';
                sb1.Panels.Items[0].Text:='��ǰ�ʻ���'+UserName;

       end
       else
       begin
                fmMain.isMailSelected(false);
                fmMain.isUserSelected(false);
       end;
end;

procedure TfmMain.lvMailClick(Sender: TObject);         //��lvMail��ListItem��ѡ��ʱ
var
        temp:TMemoryStream;
        index:integer;
        itm:TlistItem;
begin
        if lvMail.Selected<>nil  then
        begin
                fmMain.isUserSelected(false);
                fmMain.isMailSelected(true);

        adoqMail.Close;
        adoqMail.SQL.Clear;
        adoqMail.SQL.Text:='select * from Mail where MsgID='''+trim(lvMail.Selected.SubItems.Strings[3])+'''';
        adoqMail.Open;
        temp:=TMemoryStream.Create;
        TBlobField(adoqMail.FieldByName('Text') ).SaveToStream(temp);
        adoqMail.Close;
        meoText.Clear;
        temp.Position:=0;
        meoText.Lines.LoadFromStream(temp);             //Memo��ʾ���ģ�
        temp.Free;

        adoqAF.Close;
        adoqAF.SQL.Clear;
        adoqAF.SQL.Text:='select * from AFP where MsgID='''+trim(lvMail.Selected.SubItems.Strings[3])+'''';
        adoqAF.Open;
        lvAF.Clear;
        if adoqAF.RecordCount>0 then            //��AFP table ��MsgID��Ӧ�ļ�¼����������ʾ��lvAF(small icon)��
        begin
                lvAF.Clear;
                for index:=0 to adoqAF.RecordCount-1 do
                begin
                     itm:=lvAF.Items.Add;
                     itm.ImageIndex:=1;
                     itm.Caption:=adoqAF.Fields.Fields[2].AsString;
                     adoqAF.Next;

                end;
        end;
        adoqAF.Close;

        labFromName.Caption:='';
        labFromAddress.Caption:='';
        labDate.Caption:='';
        labSubject.Caption:='';

        labFromName.Caption:=lvMail.Selected.Caption;
        labFromAddress.Caption:=lvMail.Selected.SubItems.Strings[0];
        labDate.Caption:=lvMail.Selected.SubItems.Strings[2];
        labSubject.Caption:=lvMail.Selected.SubItems.Strings[1];


        end
        else
        begin
                 fmMain.isUserSelected(false);
                fmMain.isMailSelected(false);
        end;

end;

procedure TfmMain.meuAddNewClick(Sender: TObject);
begin
        Application.CreateForm(TfmAddNewUser,fmAddNewUser);
        fmAddNewUser.ShowModal;
end;

procedure TfmMain.tvUserChange(Sender: TObject; Node: TTreeNode);
begin

        UserName:='';	//�ʻ���
        UserID:='';		//�������û���
        UserAddress:='';	//�û������ʼ���ַ
        PopHost:='';		//pop������ַ
        SmtpHost:='';
        Pwd:='';        	//��½����

        sb1.Panels.Items[1].Text:='';
        labFromName.Caption:='';
        labFromAddress.Caption:='';
        labDate.Caption:='';
        labSubject.Caption:='';


        meoText.Clear;
        lvMail.Clear;
        lvAF.Clear;
end;

procedure TfmMain.meuUserSetClick(Sender: TObject);
begin
        Application.CreateForm(TfmUserSet,fmUserSet);
        fmUserSet.ShowModal;
end;

{ɾ���ʻ�:ѡ��ĳһTreeNode
ɾ��AFP table ����Ӧ��¼
ɾ��Mail table ����Ӧ��¼
ɾ��User table ����Ӧ��¼
ɾ����ӦTreeNodeȫ�ֱ����ÿ�
���ڱ����ÿ�}


procedure TfmMain.meuDeleteUserClick(Sender: TObject);  //ɾ���ʻ�
begin
        if tvUser.Selected <> nil then
        begin
                adoqUser.Close;
                adoqUser.SQL.Clear;
                adoqUser.SQL.Text:='Delete from User where UserName='''+trim(tvUser.Selected.Text)+'''';
                adoqUser.ExecSQL;
                adoqUser.Close;

                adoqMail.Close;
                adoqMail.SQL.Clear;
                adoqMail.SQL.Text:='Delete from Mail where UserName='''+trim(tvUser.Selected.Text)+'''';
                adoqMail.ExecSQL;
                adoqMail.Close;

                adoqAF.Close;
                adoqAF.SQL.Clear;
                adoqAF.SQL.Text:='Delete from AFP where UserName='''+trim(tvUser.Selected.Text)+'''';
                adoqAF.ExecSQL;
                adoqAF.Close;

                tvUser.Items.Delete(tvUser.Selected);
                tvUser.Update;

                UserName:='';	//�ʻ����ÿ�
                UserID:='';		//�������û����ÿ�
                UserAddress:='';	//�û������ʼ���ַ�ÿ�
                PopHost:='';		//pop������ַ�ÿ�
                SmtpHost:='';
                Pwd:='';        	//��½�����ÿ�


                labFromName.Caption:='';
                labFromAddress.Caption:='';
                labDate.Caption:='';
                labSubject.Caption:='';


                meoText.Clear;
                lvMail.Clear;
                lvAF.Clear;
                sb1.Panels.Items[0].Text:='';

                 

        end;
end;

{��ȫ�ֱ��������ؼ�����Ӧ���ԣ����պ󣬽��ʼ���Ϣ��һ��ӵ�mail table ,����и������Ƚ�
�䱣����Ĭ��Ŀ¼�£��ٽ���·����ӵ�AFP table�У�����mail table ����,���Ⱥ�����ǰ����
������ʾ��lvMail�У�}



procedure TfmMain.tbAsNoteClick(Sender: TObject);       //�򿪵�ַ��
begin
       Application.CreateForm(TfmAsN,fmAsN);
       fmAsN.ShowModal;


end;

procedure TfmMain.Retrieve(Sender: TObject);    //���ʼ�
var
        itm:TListItem;
        index,i,Loop,NewMailCount:integer;
        text,path:string;
        temp,temp2:TMemoryStream;
begin
       if tvUser.Selected<>nil then
       begin 
        POP.UserName :=UserID;          //���ؼ���Ӧ���Ը�ֵ
        POP.Password :=Pwd;
        POP.Host :=PopHost;
        POP.Port :=110;
        Screen.Cursor := crHourglass;
        sb1.Panels.Items[1].Text:='';
        sb1.Panels.Items[1].Text:='�������ӷ�����'+PopHost+'......';

        if POP.Connect then
        begin
                
                if POP.Login then
                begin
                         showmessage('��½�������ɹ�!');
                         

                         sb1.Panels.Items[1].Text:='';
                         sb1.Panels.Items[1].Text:='�ɹ���½������!';



                end
                else
                begin

                        POP.Abort;

                        showmessage('�޷���½������');
                        exit;
                        Screen.Cursor := crDefault;
                        sb1.Panels.Items[1].Text:='';
                        sb1.Panels.Items[1].Text:='�޷���½������';
                        


                end;
        end
        else
        begin

                POP.Abort;

                showmessage('����ʧ��');

                Screen.Cursor := crDefault;

                sb1.Panels.Items[1].Text:='';
                sb1.Panels.Items[1].Text:='����ʧ��';
                exit;

        end;


        if POP.SessionMessageCount>0 then       //��ʼ����
        begin
                sb1.Panels.Items[1].Text:='��ʼ��'+PopHost+'�����ʼ�....';
	        {adoqMail.Close;
                adoqMail.SQL.Clear;
                adoqMail.SQL.Text:='select * from Mail where UserName='''+UserName+'''';
                adoqMail.Open;}

                NewMailCount:=0;



	        for index:=1 to POP.SessionMessageCount do
  	        begin

       		        POP.RetrieveMessage(index);

		        SetLength(Text, Msg.Body.Size);

         	        if Length(Text) > 0 then
         	        begin
                	        Msg.Body.Position := 0;
                	        Msg.Body.ReadBuffer(Text[1], Msg.Body.Size);	//���뻺��
         	        end;

                        adoqMail.Close;
                        adoqMail.SQL.Clear;
                        adoqMail.SQL.Text:='select * from Mail where MsgID='''+Msg.MessageId+'''';      //ͨ��msgid�жϴ��ʼ��Ƿ��Ѵ������ݿ�
                        adoqMail.Open;

                        if adoqMail.RecordCount=0 then          //����������գ��Ӷ��жϳ��Ƿ�������
                        begin

                                adoqMail.Close;
                                adoqMail.SQL.Clear;
                                adoqMail.SQL.Text:='select * from Mail where UserName='''+UserName+'''';
                                adoqMail.Open;


                                sb1.Panels.Items[1].Text:='���ڽ��յ�'+IntToStr(NewMailCount+1)+'�����ʼ�....';
         	                adoqMail.Edit;
         	                adoqMail.Insert;
                                adoqMail.FieldByName('MsgID').AsString:=Msg.MessageId; 
         	                adoqMail.FieldByName('UserName').AsString:=UserName;
         	                adoqMail.FieldByName('FromName').AsString:=Msg.FromName;
         	                adoqMail.FieldByName('FromAddress').AsString:= Msg.FromAddress;
         	                adoqMail.FieldByName('Subject').AsString:=Msg.Subject;
         	                adoqMail.FieldByName('Date').AsString:=DateToStr(Msg.Date);
         	                temp:=TMemoryStream.Create;
         	                Msg.TextPlain.SaveToStream(temp);
         	                temp.Position:=0;
         	                TBlobField(adoqMail.FieldByName('Text') ).LoadFromStream(temp);         //ͨ��blob������ע�ֶ�Text
         	                temp.Free;
         	                adoqMail.Post;
                                adoqMail.Close;

        	                if Msg.AttachList.Count>0 then          //���渽����������Ӧ��Ϣ����afp table
        	                begin
                	                adoqAF.Close;
                	                adoqAF.SQL.Clear;
                	                adoqAF.SQL.Text:='select * from AFP';
                	                adoqAF.Open;
                	                for Loop := 0 to Msg.AttachList.Count-1 do
                	                begin

                                                        path:=ExtractFilePath(ParamStr(0))+'AFP\'+Msg.AttachList[loop].FileName;
                                                        temp2:=TMemoryStream.Create;
                                                        Msg.AttachList[loop].Decoded.SaveToStream(temp2); 
                                                        temp2.Position:=0;
                                                        temp2.SaveToFile(path);
                                                        temp2.Free;                                                                //Msg.AttachList[loop].SaveToFile()���ո����������⣬Ϊ�˰�ȫ�����ȥ���˹���
                        	                        adoqAF.Edit;
                        	                        adoqAF.Insert;
                        	                        adoqAF.FieldByName('UserName').AsString:=UserName;
                        	                        adoqAF.FieldByName('MsgID').AsString:=Msg.MessageId;
                        	                        adoqAF.FieldByName('AFP').AsString:=Msg.AttachList[loop].FileName; //ֻ��ʾ������
                        	                        adoqAF.Post;



                	                end;
                	                adoqAF.Close;
                                end;
                                NewMailCount:=NewMailCount+1;
                                sb1.Panels.Items[1].Text:='���յ�'+IntToStr(NewMailCount)+'�����ʼ�!';
                        end;
                        Msg.Reset;
  	        end;
                sb1.Panels.Items[1].Text:='�������!';
                sb1.Panels.Items[1].Text:='���յ�'+IntToStr(NewMailCount)+'�����ʼ�';
       end
       else
       begin
                showmessage('�÷�������û���ʼ���');
                adoqMail.Close;
                Screen.Cursor := crDefault;
       end;
       if POP.Quit then
       begin
                showmessage('�˳���½��');
                Screen.Cursor := crDefault;
                sb1.Panels.Items[1].Text:='���˳�������!';
       end
       else
       begin
                POP.Abort;
                Screen.Cursor := crDefault;
                showmessage('�˳�ʧ��!');
                //lStatus.Caption := 'Failed on quit';
       end;
       Screen.Cursor := crDefault;
       adoqMail.Close;
       adoqMail.SQL.Clear;
       adoqMail.SQL.Text:='select * from Mail where UserName='''+UserName+''' order by Nu desc';
       adoqMail.Open;


       if adoqMail.RecordCount>0 then           //������ʾ�ʼ�!
       begin
                lvMail.Clear;
                for  i:=0 to adoqMail.RecordCount-1 do
                begin
                        itm:=lvMail.Items.Add;
                        itm.ImageIndex:=4;
                        itm.Caption:=adoqMail.Fields.Fields[3].AsString;
                        itm.SubItems.Add(adoqMail.Fields.Fields[2].AsString);
                        itm.SubItems.Add(adoqMail.Fields.Fields[1].AsString);
                        itm.SubItems.Add(adoqMail.Fields.Fields[4].AsString);
                        itm.SubItems.Add(adoqMail.Fields.Fields[7].AsString);
                        adoqMail.Next;
                end;
        end;
        sb1.Panels.Items[1].Text:='���ʻ��ֹ����ʼ�'+IntToStr(adoqMail.RecordCount)+'��'+' '+'�������ʼ�'+IntToStr(NewMailCount)+'��';
        adoqMail.Close;
        end;
end;







procedure TfmMain.meuGetMailClick(Sender: TObject);
begin
        Retrieve(Sender);
end;



procedure TfmMain.meuNewMailClick(Sender: TObject);
begin
        Application.CreateForm(TfmSend,fmSend);         //д���ʼ�

        fmSend.meSend.Clear;
        fmSend.meSend.Lines.Add('_____'+'  ��ã�');
        fmSend.meSend.Lines.Add('');
        fmSend.meSend.Lines.Add('');
        fmSend.meSend.Lines.Add('');
        fmSend.meSend.Lines.Add('');
        fmSend.meSend.Lines.Add('                         '+UserName);
        fmSend.meSend.Lines.Add('                         '+UserAddress);

        fmSend.ShowModal;
end;

{ɾ���ʼ�:ѡ��lvMail��item
��ɾ��AFP table ����Ӧ��¼
��ɾ��mail table����Ӧ��¼
Ȼ��ˢ��lvMail��lvAF}



procedure TfmMain.meuDeleteMailClick(Sender: TObject);  //ɾ���ʼ�
begin
        if lvMail.Selected<>nil then
        begin
                adoqMail.Close;
                adoqMail.SQL.Clear;
                adoqMail.SQL.Text:='Delete from Mail where MsgID='''+trim(lvMail.Selected.SubItems.Strings[3])+'''';
                adoqMail.ExecSQL;
                adoqMail.Close;

                adoqAF.Close;
                adoqAF.SQL.Clear;
                adoqAF.SQL.Text:='Delete from AFP where MsgID='''+trim(lvMail.Selected.SubItems.Strings[3])+'''';
                adoqAF.ExecSQL;
                adoqAF.Close;


                lvAF.Clear;
                lvMail.DeleteSelected;
                lvMail.Update;
        end;
end;

procedure TfmMain.lvAFDblClick(Sender: TObject);
begin
        if lvAF.Selected<>nil then
                 ShellExecute(handle,nil,pchar(lvAF.Selected.Caption),nil,nil,sw_ShowNormal);   //����ϵͳapi�����򿪸���
end;

{�Զ���ӵ�ַ:ѡ��ĳһ�ʼ�����fromname,
fromaddress,��ӽ�AddressNote table �м�¼��}

procedure TfmMain.meuAddNoteClick(Sender: TObject);     //�Զ���ӵ�ַ����ַ��
begin
        if lvMail.Selected<>nil then
        begin
                Application.CreateForm(TfmAddNewAs,fmAddNewAs);
                Application.CreateForm(TfmAsN,fmAsN);
                fmAddNewAs.edtFromName.Text:=lvMail.Selected.Caption;
                fmAddNewAs.edtFromAddress.Text:=lvMail.Selected.SubItems.Strings[0];


                fmAddNewAs.ShowModal;


                fmAsN.ShowModal;



        end;
end;

procedure TfmMain.meuReplyToClick(Sender: TObject);     //�ظ��ʼ�:��fromaddress,subject��������,�ռ�����

begin
        if lvMail.Selected<>nil then
        begin
         Application.CreateForm(TfmSend,fmSend);
         fmSend.edtToAddress.Text:=trim(lvMail.Selected.SubItems.Strings[0]);
         fmSend.edtSubject.Text:='Re:'+trim(lvMail.Selected.SubItems.Strings[1]);
         fmSend.meSend.Clear;
         fmSend.meSend.Lines.Add(trim(lvMail.Selected.Caption)+'  ��ã�');
         fmSend.meSend.Lines.Add('');
         fmSend.meSend.Lines.Add('');
         fmSend.meSend.Lines.Add('');
         fmSend.meSend.Lines.Add('');
         fmSend.meSend.Lines.Add('                         '+UserName);
         fmSend.meSend.Lines.Add('                         '+UserAddress);

                  

         fmSend.ShowModal;
        end;

end;

procedure TfmMain.meuSaveMailClick(Sender: TObject); //�����ʼ�
begin
      if lvMail.Selected<>nil then
      begin
                sadMail.FileName:=lvMail.Selected.SubItems.Strings[1]+'.txt';
                if sadMail.Execute then
                begin
                       meoText.Lines.SaveToFile(sadMail.FileName);
                end;
      end;
end;

procedure TfmMain.UpdatetvUser(Sender: TObject);
var
        itm:TTreeNode;
        i:integer;
begin
        with fmMain.adoqUser  do
        begin
              close;
              SQL.Clear;
              SQL.Text:='select * from User';
              open;
        end;

        if fmMain.adoqUser.RecordCount>0 then
        begin
                for i:=0 to fmMain.adoqUser.RecordCount-1 do
                begin
                        itm:=fmMain.tvUser.Items.Add(fmMain.tvUser.Selected,fmMain.adoqUser.Fields.Fields[0].AsString);
                        itm.ImageIndex:=12;
                        fmMain.adoqUser.Next; 
                end;
                fmMain.adoqUser.Close;
        end;
        fmMain.adoqUser.Close;


end;

procedure TfmMain.adoqUserQuery(target:string);
begin
        fmMain.adoqUser.Close;
        fmMain.adoqUser.SQL.Clear;
        fmMain.adoqUser.SQL.Text:='select * from User where UserName='''+trim(target)+'''';
        fmMain.adoqUser.Open;
end;

procedure TfmMain.isUserSelected(Selected:boolean);
begin
        meuDeleteUser.Enabled:=Selected;
        meuUserSet.Enabled:=Selected;
        meuAddNew.Enabled:=Selected;
        meuNewMail.Enabled:=Selected;
        meuGetMail.Enabled:=Selected;
       
        tbGetMail.Enabled:=Selected;
        tbAddNew.Enabled:=Selected;
        tbUserSet.Enabled:=Selected;
        tbNewMail.Enabled:=Selected;
        

        n4.Enabled:=Selected;
        n5.Enabled:=Selected;
        n6.Enabled:=Selected;
        n8.Enabled:=Selected;
        n9.Enabled:=Selected;


end;

procedure TfmMain.isMailSelected(Selected:boolean);
begin
        //mail.Enabled:=Selected;
        meuSaveMail.Enabled:=Selected;
        meuAddNote.Enabled:=Selected;
        meuDeleteMail.Enabled:=Selected;
        meuReplyTo.Enabled:=Selected;
        meuNewMail.Enabled:=Selected;


        //tbGetMail.Enabled:=Selected;
        tbNewMail.Enabled:=Selected;
        tbReply.Enabled:=Selected;
        //tbAsNote.Enabled:=Selected;
        tbSaveMail.Enabled:=Selected;

        
        n10.Enabled:=Selected;
        n11.Enabled:=Selected;
        n13.Enabled:=Selected;
        n18.Enabled:=Selected;


end;

procedure TfmMain.PMail1Click(Sender: TObject);
begin
     CoolTrayIcon1.ShowMainForm;
end;

procedure TfmMain.N14Click(Sender: TObject);
begin
        CoolTrayIcon1.HideMainForm;
end;

procedure TfmMain.N16Click(Sender: TObject);
begin
        close;
end;

procedure TfmMain.meuAboutClick(Sender: TObject);
begin
    Application.CreateForm(TfmAbout, fmAbout);

     fmAbout.ShowModal;
  
  
end;

procedure TfmMain.meuHelpClick(Sender: TObject);
begin
        ShellExecute(handle,nil,pchar(ExtractFilePath(ParamStr(0))+'Help.txt'),nil,nil,sw_ShowNormal);
end;

procedure TfmMain.CoolTrayIcon1DblClick(Sender: TObject);
begin
        CoolTrayIcon1.ShowMainForm;
end;

function TfmMain.Encrypt(const S: String; Key: Word): String;
var
  I: byte;
begin
  SetLength(Result,Length(s));		//���ַ�������������
  //SetLength(s,Length(s));
  //Result[0] := S[0];
  for I := 1 to Length(S) do
  begin
    Result[I] := char(byte(S[I]) xor (Key shr 8));
    Key := (byte(Result[I]) + Key) * C1 + C2;
  end;
end;

function TfmMain.Decrypt(const S: String; Key: Word): String;
var
  I: byte;
begin
   setlength(Result,length(s));
  //Result[0] := S[0];
  for I := 1 to Length(S) do
  begin
    Result[I] := char(byte(S[I]) xor (Key shr 8));
    Key := (byte(S[I]) + Key) * C1 + C2;
  end;
  
end;




end.
