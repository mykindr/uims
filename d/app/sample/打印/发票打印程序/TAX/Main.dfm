object FrmMain: TFrmMain
  Left = 205
  Top = 111
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = '������˰��ʦ��������ֵ˰��Ʊ�ᱨϵͳ'
  ClientHeight = 329
  ClientWidth = 536
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = '����'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  WindowState = wsMaximized
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object StatusBar1: TStatusBar
    Left = 0
    Top = 310
    Width = 536
    Height = 19
    Panels = <
      item
        Text = 'Fly Dance Software'
        Width = 120
      end
      item
        Width = 500
      end
      item
        Width = 50
      end>
    SimplePanel = False
  end
  object Wallpaper1: TWallpaper
    Left = 0
    Top = 0
    Width = 536
    Height = 310
    Align = alClient
    BevelInner = bvLowered
    TabOrder = 1
  end
  object MainMenu1: TMainMenu
    Top = 72
    object N1: TMenuItem
      Caption = 'ҵ����'
      object miJBInput: TMenuItem
        Caption = '�ᱨ¼��'
        OnClick = miJBInputClick
      end
      object miChargeInput: TMenuItem
        Caption = '�շ�¼��'
        OnClick = miChargeInputClick
      end
      object miEPriseReg: TMenuItem
        Caption = '��ҵ�Ǽ�'
        OnClick = miEPriseRegClick
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object miExit: TMenuItem
        Caption = '�˳�ϵͳ'
        OnClick = miExitClick
      end
    end
    object N7: TMenuItem
      Caption = '���ݲ�ѯ'
      object miJBQuery: TMenuItem
        Caption = '�ᱨ��ѯ'
      end
      object miChargeQuery: TMenuItem
        Caption = '�շѲ�ѯ'
      end
      object miEPriseQuery: TMenuItem
        Caption = '��ҵ��ѯ'
      end
    end
    object N11: TMenuItem
      Caption = '�����ӡ'
    end
    object N12: TMenuItem
      Caption = 'ϵͳ����'
      object miBackGround: TMenuItem
        Caption = '��������'
        OnClick = miBackGroundClick
      end
      object N2: TMenuItem
        Caption = '���뷨����'
        OnClick = N2Click
      end
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 32
    Top = 72
  end
  object BackGroundDialog: TOpenPictureDialog
    Left = 64
    Top = 72
  end
end
