{------------------------P-Mail 0.5 beta��-----------------
��̹��ߣ�Delphi 6 + D6_upd2 
������������ɫ PLQ������
�����������봿����ѣ�����ѧϰʹ�ã�ϣ������ʹ����ʱ������λ�
������Ա��������˸Ľ���Ҳϣ������������ϵ
My E-Mail:plq163001@163.com
	  plq163003@163.com
-----------------------------------------------------2002.5.19}


unit NewUser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TfmAddNewUser = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    edtUserName: TEdit;
    edtUserID: TEdit;
    edtPwd: TEdit;
    edtUserAddress: TEdit;
    edtPopHost: TEdit;
    edtSmtpHost: TEdit;
    btnSet: TBitBtn;
    btnClear: TBitBtn;
    btnOK: TBitBtn;
    procedure btnSetClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmAddNewUser: TfmAddNewUser;

implementation

uses main;

{$R *.dfm}

{�½��ʻ�:�ж��Ƿ���ԭ�ʻ�������
��->����Ӧ��Ϣ����UserMail table
 ��һ���¼�¼����һ��TreeNode of tvUser}



procedure TfmAddNewUser.btnSetClick(Sender: TObject);
{var
        temp:string;}
begin
        {fmMain.adoqUser.Close;
        fmMain.adoqUser.SQL.Clear;
        fmMain.adoqUser.SQL.Text:='select * from User where UserName='''+trim(edtUserName.Text)+'''';
        fmMain.adoqUser.Open;}

        fmMain.adoqUserQuery(edtUserName.Text);

        if fmMain.adoqUser.RecordCount=0 then
        begin
                if  (edtUserName.Text<>'') and (edtUserID.Text<>'') and (edtPopHost.Text<>'') and (edtSmtpHost.Text<>'') and  (edtPwd.Text<>'') and (edtUserAddress.Text<>'') then
                begin
                fmMain.adoqUser.Edit;
                fmMain.adoqUser.Insert;
                fmMain.adoqUser.FieldByName('UserName').AsString:=trim(edtUserName.Text);
                fmMain.adoqUser.FieldByName('UserID').AsString:=trim(edtUserID.Text);
                fmMain.adoqUser.FieldByName('UserAddress').AsString:=trim(edtUserAddress.Text);
                {temp:=trim(edtPwd.Text);
                temp:=fmMain.Encrypt(temp,200);}
                fmMain.adoqUser.FieldByName('Pwd').AsString:=trim(edtPwd.Text);
                fmMain.adoqUser.FieldByName('PopHost').AsString:=trim(edtPopHost.Text);
                fmMain.adoqUser.FieldByName('SmtpHost').AsString:=trim(edtSmtpHost.Text);
                fmMain.adoqUser.Post;
                fmMain.adoqUser.Close;

                
                fmMain.tvUser.Items.Clear;
                fmMain.UpdatetvUser(Sender);
                end
                else
                begin
                        ShowMessage('���ݲ���Ϊ��');    //��Ч����
                end;


        end

        else
        begin
                fmMain.adoqUser.Close;
                showmessage('�����ʻ�����ԭ���ʻ������ˣ��뻻һ���ʻ���!');
        end;
end;

procedure TfmAddNewUser.btnClearClick(Sender: TObject);
begin
        edtUserName.Text:='';
        edtUserID.Text:='';
        edtUserAddress.Text:='';
        edtPwd.Text:='';
        edtPopHost.Text:='';
        edtSmtpHost.Text:='';
end;

procedure TfmAddNewUser.btnOKClick(Sender: TObject);
begin
        close;
end;

end.
