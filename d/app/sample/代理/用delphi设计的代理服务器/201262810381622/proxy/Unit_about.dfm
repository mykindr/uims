object about: Tabout
  Left = 226
  Top = 115
  Width = 320
  Height = 263
  Caption = '���ڱ��������'
  Color = clMenu
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 80
    Top = 16
    Width = 145
    Height = 19
    Caption = 'HTTP���������'
    Font.Charset = GB2312_CHARSET
    Font.Color = clNavy
    Font.Height = -19
    Font.Name = '����'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object SpeedButton1: TSpeedButton
    Left = 109
    Top = 204
    Width = 91
    Height = 25
    Caption = '��  ��'
    Font.Charset = GB2312_CHARSET
    Font.Color = clNavy
    Font.Height = -19
    Font.Name = '����'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = SpeedButton1Click
  end
  object Memo1: TMemo
    Left = 16
    Top = 40
    Width = 281
    Height = 153
    Color = clBtnShadow
    Font.Charset = GB2312_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = '����'
    Font.Style = []
    Lines.Strings = (
      '  �����������ṩHTTP��������ܣ�'
      '���ҵı�ҵ�����Ʒ������ʱ��̣ܶ�'
      '���кܶ�Ĵ���֮����ϣ����������֮'
      '���ܼ�ʱ�ṩ����Ա����Ժ��֮��'
      '�иĽ���'
      '  ��    �ߣ�����'
      '  ��ϵ������sodme@21cn.com '
      '  ���ڱ��������ϸʹ��˵������ա�'
      'ʹ��˵�������֡�')
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
  end
end
