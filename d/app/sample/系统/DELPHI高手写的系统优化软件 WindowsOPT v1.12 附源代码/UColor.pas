unit UColor;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  RzButton, ExtCtrls, StdCtrls;

type
  TFrmColor = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Bevel1: TBevel;
    ComBoxColor: TComboBox;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit15: TEdit;
    ColorBox1: TColorBox;
    RzBtnOK: TRzButton;
    ComBoxLogon: TComboBox;
    RzBtnCancel: TRzButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Edit11MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Edit11Change(Sender: TObject);
    procedure Edit11DblClick(Sender: TObject);
    procedure ColorBox1Change(Sender: TObject);
    procedure ComBoxColorChange(Sender: TObject);
    procedure ComBoxLogonChange(Sender: TObject);
    procedure RzBtnOKClick(Sender: TObject);
    procedure RzBtnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmColor: TFrmColor;

implementation

uses Registry, UMainFunc;

var
  reg1,reg2,reg3: TRegistry;
  os:string;
  
{$R *.dfm}

procedure TFrmColor.FormCreate(Sender: TObject);
begin
  Reg1:=TRegistry.Create; Reg1.RootKey:=HKEY_LOCAL_MACHINE;
  Reg2:=TRegistry.Create; Reg2.RootKey:=HKEY_CURRENT_USER;
  Reg3:=TRegistry.Create; Reg3.RootKey:=HKEY_USERS;

  if reg2.OpenKey('\Control Panel\Colors',false) then
  begin
    Edit11.Text:=reg2.ReadString('Menu');
    Edit12.Text:=reg2.ReadString('MenuHilight');
    Edit13.Text:=reg2.ReadString('HilightText');
    Edit14.Text:=reg2.ReadString('Hilight');
    Edit11.Color:=StrToColor(Edit11.Text); Edit11.Font.Color:=StrToColor2(Edit11.Text);
    Edit12.Color:=StrToColor(Edit12.Text); Edit12.Font.Color:=StrToColor2(Edit12.Text);
    Edit13.Color:=StrToColor(Edit13.Text); Edit13.Font.Color:=StrToColor2(Edit13.Text);
    Edit14.Color:=StrToColor(Edit14.Text); Edit14.Font.Color:=StrToColor2(Edit14.Text);
  end;

  if reg1.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion',false) then os:=reg1.ReadString('ProductName');
  if ( os='Microsoft Windows 2000' ) and ( reg3.OpenKey('\.DEFAULT\Control Panel\Colors',false) ) then
    begin
      Edit15.Text:=reg3.ReadString('Background');
      Edit15.Color:=StrToColor(Edit15.Text);
      Edit15.Font.Color:=StrToColor2(Edit15.Text);
    end
  else
  if ( os='Microsoft Windows XP' ) and ( reg1.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon',false) ) then
    begin
      Edit15.Text:=reg1.ReadString('Background');
      Edit15.Color:=StrToColor(Edit15.Text);
      Edit15.Font.Color:=StrToColor2(Edit15.Text);
    end;

  with ColorBox1 do
  begin
    Items[0] := '�Զ���...';Items[1] := '��ɫ';  Items[2] := '���ɫ';
    Items[3] := '��ɫ';     Items[4] := '���ɫ';Items[5] := '����ɫ';
    Items[6] := '��ɫ';     Items[7] := '����';  Items[8] := '��ɫ';
    Items[9] := '��ɫ';     Items[10] := '��ɫ'; Items[11] := 'ǳ��ɫ';
    Items[12] := '��ɫ';    Items[13] := '��ɫ'; Items[14] := '�Ϻ�ɫ';
    Items[15] := 'ǳ��ɫ';  Items[16] := '��ɫ'; Items[17] := 'Ѽ����';
    Items[18] := '����ɫ';  Items[19] := '��ɫ'; Items[20] := '�λ�ɫ';
  end;
  ColorBox1.Selected:=Edit11.Color;
end;

procedure TFrmColor.FormShow(Sender: TObject);
begin
  ComBoxColor.ItemIndex:=0;
  ComBoxLogon.ItemIndex:=0;
end;

procedure TFrmColor.FormDestroy(Sender: TObject);
begin
  Reg1.CloseKey; Reg1.Free;
  Reg2.CloseKey; Reg2.Free;
  Reg3.CloseKey; Reg3.Free;
end;

procedure TFrmColor.Edit11MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin //��̬�ظı�ColorBox1��λ�ú���ɫ
  case TEdit(Sender).TabOrder of
  3: begin ColorBox1.Top:=60;  ColorBox1.Selected:=Edit11.Color; end;
  4: begin ColorBox1.Top:=90;  ColorBox1.Selected:=Edit12.Color; end;
  5: begin ColorBox1.Top:=120; ColorBox1.Selected:=Edit13.Color; end;
  6: begin ColorBox1.Top:=150; ColorBox1.Selected:=Edit14.Color; end;
  7: begin ColorBox1.Top:=264; ColorBox1.Selected:=Edit15.Color; end;
  end;
end;

procedure TFrmColor.Edit11Change(Sender: TObject);
begin //�༭���ֵ�ı�ʱ�ı�������ɫ������
  TEdit(sender).Color:=StrToColor(TEdit(sender).Text);
  TEdit(sender).Font.Color:=StrToColor2(TEdit(sender).Text);
end;

procedure TFrmColor.Edit11DblClick(Sender: TObject);
begin //˫���༭��ʱ�Զ������ݿ��������
  TEdit(sender).SelectAll;
  TEdit(sender).CopyToClipboard
end;

procedure TFrmColor.ColorBox1Change(Sender: TObject);
begin
  RzBtnOK.Enabled:=true;
  case ColorBox1.Top of
  60:
    begin
      Edit11.Color:=ColorBox1.Selected;
      Edit11.Text:=ColorToRGB(ColorBox1.Selected);
      Edit11.Font.Color:=StrToColor2(Edit11.Text);
      ComboxColor.ItemIndex:=-1;
    end;
  90:
    begin
      Edit12.Color:=ColorBox1.Selected;
      Edit12.Text:=ColorToRGB(ColorBox1.Selected);
      Edit12.Font.Color:=StrToColor2(Edit12.Text);
      ComboxColor.ItemIndex:=-1;
    end;
  120:
    begin
      Edit13.Color:=ColorBox1.Selected;
      Edit13.Text:=ColorToRGB(ColorBox1.Selected);
      Edit13.Font.Color:=StrToColor2(Edit13.Text);
      ComboxColor.ItemIndex:=-1;
    end;
  150:
    begin
      Edit14.Color:=ColorBox1.Selected;
      Edit14.Text:=ColorToRGB(ColorBox1.Selected);
      Edit14.Font.Color:=StrToColor2(Edit14.Text);
      ComboxColor.ItemIndex:=-1;
    end;
  264:
    begin
      Edit15.Color:=ColorBox1.Selected;
      Edit15.Text:=ColorToRGB(ColorBox1.Selected);
      Edit15.Font.Color:=StrToColor2(Edit15.Text);
      ComboxLogon.ItemIndex:=-1;
    end;
  end;
end;

procedure TFrmColor.ComBoxColorChange(Sender: TObject);
begin //�˵�ɫ
  ColorBox1.ItemIndex:=-1;
  case ComBoxColor.ItemIndex of
  0:  //��ǰ��ɫ
    if reg2.OpenKey('\Control Panel\Colors',false) then
    begin
      Edit11.Text:=reg2.ReadString('Menu');
      Edit13.Text:=reg2.ReadString('HilightText');Edit14.Text:=reg2.ReadString('Hilight');
      //if Edit12.Enabled=true then Edit12.Text:=reg2.ReadString('MenuHilight');
      Edit12.Text:=reg2.ReadString('MenuHilight');
      if ComBoxLogon.ItemIndex=0
      then RzBtnOK.Enabled:=false
      else RzBtnOK.Enabled:=true;
    end;
  1:  //Ĭ����ɫ(2000)
    begin
      Edit11.Text:='212 208 200';
      Edit13.Text:='255 255 255'; Edit14.Text:='10 36 106';
      //if Edit12.Enabled=true then Edit12.Text:='';
      Edit12.Text:='';
      RzBtnOK.Enabled:=true;
    end;
  2:  //2000 �Ƽ�
    begin
      Edit11.Text:='239 235 214';
      Edit13.Text:='216 252 216'; Edit14.Text:='80 140 216';
      //if Edit12.Enabled=true then Edit12.Text:='';
      Edit12.Text:='';
      RzBtnOK.Enabled:=true;
    end;
  3:  //Ĭ����ɫ(XP)
    begin
      Edit11.Text:='255 255 255';
      Edit13.Text:='255 255 255'; Edit14.Text:='49 106 197';
      //if Edit12.Enabled=true then Edit12.Text:='49 106 197';
      Edit12.Text:='49 106 197';
      RzBtnOK.Enabled:=true;
    end;
  4:  //Office 01
    begin
      Edit11.Text:='247 243 222';
      Edit13.Text:='0 0 0';       Edit14.Text:='133 193 255';
      //if Edit12.Enabled=true then Edit12.Text:='227 235 244';
      Edit12.Text:='227 235 244';
      RzBtnOK.Enabled:=true;
    end;
  5:  //Office 02
    begin
      Edit11.Text:='247 243 222';
      Edit13.Text:='0 0 0';       Edit14.Text:='133 193 255';
      //if Edit12.Enabled=true then Edit12.Text:='255 255 255';
      Edit12.Text:='255 255 255';
      RzBtnOK.Enabled:=true;
    end;
  6:  //FlatXP
    begin
      Edit11.Text:='231 227 231';
      Edit13.Text:='0 0 0';       Edit14.Text:='255 154 0';
      //if Edit12.Enabled=true then Edit12.Text:='255 207 0';
      Edit12.Text:='255 207 0';
      RzBtnOK.Enabled:=true;
    end;  
  7:  //Korilla
    begin
      Edit11.Text:='255 251 247';
      Edit13.Text:='0 0 0';       Edit14.Text:='82 170 255';
      //if Edit12.Enabled=true then Edit12.Text:='214 211 231';
      Edit12.Text:='214 211 231';
      RzBtnOK.Enabled:=true;
    end;
  8:  //����ݵ�
    begin
      Edit11.Text:='239 235 214';
      Edit13.Text:='216 252 216'; Edit14.Text:='60 120 184';
      //if Edit12.Enabled=true then Edit12.Text:='131 191 255';
      Edit12.Text:='131 191 255';
      RzBtnOK.Enabled:=true;
    end;
  9:  //�Ż�ͨ
    begin
      Edit11.Text:='239 243 231';
      Edit13.Text:='255 255 255'; Edit14.Text:='110 110 110';
      //if Edit12.Enabled=true then Edit12.Text:='181 181 181';
      Edit12.Text:='181 181 181';
      RzBtnOK.Enabled:=true;
    end;
  10:  //Win2003
    begin
      Edit11.Text:='212 208 200';
      Edit13.Text:='255 255 255'; Edit14.Text:='10 36 106';
      //if Edit12.Enabled=true then Edit12.Text:='210 210 255';
      Edit12.Text:='210 210 255';
      RzBtnOK.Enabled:=true;
    end;
  11:  //Longhorn
    begin
      Edit11.Text:='247 243 222';
      Edit13.Text:='0 0 0';       Edit14.Text:='146 180 195';
      //if Edit12.Enabled=true then Edit12.Text:='197 231 246';
      Edit12.Text:='197 231 246';
      RzBtnOK.Enabled:=true;
    end;
  end; //endcase
  case ColorBox1.Top of
  60:  ColorBox1.Selected:=Edit11.Color;
  90:  ColorBox1.Selected:=Edit12.Color;
  120: ColorBox1.Selected:=Edit13.Color;
  150: ColorBox1.Selected:=Edit14.Color;
  264: ColorBox1.Selected:=Edit15.Color;
  end;

end;

procedure TFrmColor.ComBoxLogonChange(Sender: TObject);
begin   //Windows ��½ʱ�ı���ɫ
  case ComBoxLogon.ItemIndex of
  0:   //��ǰ��ɫ
  //begin
    if ( os='Microsoft Windows 2000' ) and ( reg3.OpenKey('\.DEFAULT\Control Panel\Colors',false) ) then
      begin
        Edit15.Text:=reg3.ReadString('Background');
        if ComBoxColor.ItemIndex=0
        then RzBtnOK.Enabled:=false
        else RzBtnOK.Enabled:=true;
      end
    else
    if ( os='Microsoft Windows XP' ) and ( reg1.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon',false) ) then
      begin
        Edit15.Text:=reg1.ReadString('Background');
        if ComBoxColor.ItemIndex=0
        then RzBtnOK.Enabled:=false
        else RzBtnOK.Enabled:=true;
      end;
  //end;
  1:    //2000Ĭ��
    begin
      Edit15.Text:='58 110 165';
      RzBtnOK.Enabled:=true;
    end;
  2:    //XPĬ��
    begin
      Edit15.Text:='0 78 152';
      RzBtnOK.Enabled:=true;
    end;
  3:    //��ɫ
    begin
      Edit15.Text:='0 128 0';
      RzBtnOK.Enabled:=true;
    end;
  4:    //�ۺ�ɫ
    begin
      Edit15.Text:='250 156 210';
      RzBtnOK.Enabled:=true;
    end;
  end; //endcase
  case ColorBox1.Top of
  60:  ColorBox1.Selected:=Edit11.Color;
  90:  ColorBox1.Selected:=Edit12.Color;
  120: ColorBox1.Selected:=Edit13.Color;
  150: ColorBox1.Selected:=Edit14.Color;
  264: ColorBox1.Selected:=Edit15.Color;
  end;
end;

procedure TFrmColor.RzBtnOKClick(Sender: TObject);
begin //ȷ��
  try
    if reg2.OpenKey('\Control Panel\Colors',false) then
    begin
      reg2.WriteString('Menu',Edit11.Text);
      reg2.WriteString('HilightText',Edit13.Text);reg2.WriteString('Hilight',Edit14.Text);
      //if Edit12.Enabled=true then reg2.WriteString('MenuHilight',Edit12.Text);
      reg2.WriteString('MenuHilight',Edit12.Text);
      //reg2.writestring('Window','255 255 255'); //����Ϊ��ɫ
     RzBtnOK.Enabled:=false;
    end;

    if ( os='Microsoft Windows 2000' ) and ( reg3.OpenKey('\.DEFAULT\Control Panel\Colors',true) )
      then reg3.WriteString('Background',Edit15.Text)
    else
    if ( os='Microsoft Windows XP' ) and ( reg1.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon',true) )
      then reg1.WriteString('Background',Edit15.Text);

  except //�����쳣
    Reg1.CloseKey; Reg1.Free;
    Reg2.CloseKey; Reg2.Free;
    Reg3.CloseKey; Reg3.Free;
  end;
end;

procedure TFrmColor.RzBtnCancelClick(Sender: TObject);
begin //�ر�
  close
end;

end.
