object web_add: Tweb_add
  Left = 195
  Top = 110
  BorderStyle = bsDialog
  Caption = '���Ӿܾ�����վ��'
  ClientHeight = 96
  ClientWidth = 213
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton1: TSpeedButton
    Left = 24
    Top = 64
    Width = 49
    Height = 22
    Caption = '�� ��'
    Font.Charset = GB2312_CHARSET
    Font.Color = clNavy
    Font.Height = -14
    Font.Name = '����'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = SpeedButton1Click
  end
  object Label1: TLabel
    Left = 14
    Top = 8
    Width = 86
    Height = 16
    Caption = 'վ���б�'
    Font.Charset = GB2312_CHARSET
    Font.Color = clNavy
    Font.Height = -16
    Font.Name = '����'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object SpeedButton3: TSpeedButton
    Left = 136
    Top = 64
    Width = 49
    Height = 22
    Caption = '�� ��'
    Font.Charset = GB2312_CHARSET
    Font.Color = clNavy
    Font.Height = -14
    Font.Name = '����'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = SpeedButton3Click
  end
  object ComboBox1: TComboBox
    Left = 16
    Top = 32
    Width = 177
    Height = 24
    Font.Charset = GB2312_CHARSET
    Font.Color = clNavy
    Font.Height = -16
    Font.Name = '����'
    Font.Style = []
    ItemHeight = 16
    ParentFont = False
    TabOrder = 0
  end
end
