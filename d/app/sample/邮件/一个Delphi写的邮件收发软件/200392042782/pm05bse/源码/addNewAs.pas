{------------------------P-Mail 0.5 beta��-----------------
��̹��ߣ�Delphi 6 + D6_upd2 
������������ɫ PLQ������
�����������봿����ѣ�����ѧϰʹ�ã�ϣ������ʹ����ʱ������λ�
������Ա��������˸Ľ���Ҳϣ������������ϵ
My E-Mail:plq163001@163.com
	  plq163003@163.com
-----------------------------------------------------2002.5.19}
unit addNewAs;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls;

type
  TfmAddNewAs = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    edtFromName: TEdit;
    edtFromAddress: TEdit;
    btnSet: TBitBtn;
    btnClear: TBitBtn;
    btnOK: TBitBtn;
    ListView1: TListView;
    procedure btnSetClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmAddNewAs: TfmAddNewAs;


implementation

uses AsNote, main;

{$R *.dfm}

procedure TfmAddNewAs.btnSetClick(Sender: TObject);
var
        itm:TlistItem;
begin
        {fmAsN.adoqAsN.Close;
        fmAsN.adoqAsN.SQL.Clear;
        fmAsN.adoqAsN.SQL.Text:='select * from AddressNote where FromAddress='''+trim(edtFromAddress.Text)+'''';
        fmAsN.adoqAsN.Open;}

        fmAsN.adoqAsNQuery(edtFromAddress.Text);

        if fmAsN.adoqAsN.RecordCount=0 then
        begin
                fmAsN.adoqAsN.Edit;
                fmAsN.adoqAsN.Insert;
                fmAsN.adoqAsN.FieldByName('FromName').AsString:=trim(edtFromName.Text);
                fmAsN.adoqAsN.FieldByName('FromAddress').AsString:=trim(edtFromAddress.Text);
                fmAsN.adoqAsN.Post;
                fmAsN.adoqAsN.Close;

                {itm:=fmAsN.lvAddress.Items.Add;
                itm.ImageIndex:=2;
                itm.Caption:=edtFromName.Text;
                itm.SubItems.Add(edtFromAddress.Text);
                fmAsN.lvAddress.Update;}
                fmAsN.lvAddress.Clear;
                fmAsN.UpdatelvAddress(Sender);


        end

        else
        begin
                edtFromName.Text:='';
                edtFromAddress.Text:='';
                fmAsN.adoqAsN.Close;
                showmessage('��ַ����!');
                exit;
        end;
end;

procedure TfmAddNewAs.btnClearClick(Sender: TObject);
begin
        edtFromName.Text:='';
        edtFromAddress.Text:='';
end;

procedure TfmAddNewAs.btnOKClick(Sender: TObject);
begin
        close;
end;

end.
