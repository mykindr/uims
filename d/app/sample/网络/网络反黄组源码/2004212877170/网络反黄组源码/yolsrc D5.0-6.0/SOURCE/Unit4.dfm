object Form4: TForm4
  Left = 229
  Top = 157
  ActiveControl = FlatTabControl1
  BorderStyle = bsToolWindow
  Caption = '���練�����û�ע��'
  ClientHeight = 250
  ClientWidth = 345
  Color = 15389115
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object FlatTabControl1: TFlatTabControl
    Left = 3
    Top = 4
    Width = 340
    Height = 243
    ColorUnselectedTab = 11255641
    Tabs.Strings = (
      '����������'
      'ע�᱾���')
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = '����'
    Font.Style = []
    Color = 13693852
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    OnMouseDown = FlatTabControl1MouseDown
    object Notebook1: TNotebook
      Left = 1
      Top = 17
      Width = 338
      Height = 225
      Color = 13693852
      ParentColor = False
      TabOrder = 0
      object TPage
        Left = 0
        Top = 0
        Caption = '0'
        object Label1: TLabel
          Left = 24
          Top = 16
          Width = 282
          Height = 84
          Caption = 
            '�𾴵��û���'#13#10#13#10'   ����ǰ����ʹ�õ������δ����ע�ᣬ���������' +
            '��Ϊ30�ա����������ú�����ǵĲ�Ʒ���Ⲣ���⹺����������������' +
            '����������E-MAIL��ʽ���͵�dhzyx@elong.com��ͬʱ��ϵ������ˣ���' +
            '�ǽ��ܿ���������ע���벢���͸�����лл!'
          Color = 15006428
          ParentColor = False
          Transparent = True
          WordWrap = True
        end
        object Label2: TLabel
          Left = 25
          Top = 129
          Width = 72
          Height = 12
          Caption = '���������룺'
        end
        object Label3: TLabel
          Left = 161
          Top = 129
          Width = 6
          Height = 12
          Caption = '-'
        end
        object Label4: TLabel
          Left = 218
          Top = 129
          Width = 6
          Height = 12
          Caption = '-'
        end
        object edit1: TFlatEdit
          Left = 113
          Top = 125
          Width = 45
          Height = 18
          ColorFlat = 13693852
          ParentColor = True
          Enabled = False
          ReadOnly = True
          TabOrder = 0
        end
        object edit2: TFlatEdit
          Left = 169
          Top = 125
          Width = 46
          Height = 18
          ColorFlat = 13693852
          ParentColor = True
          Enabled = False
          ReadOnly = True
          TabOrder = 1
          Text = 'edit2'
        end
        object edit3: TFlatEdit
          Left = 226
          Top = 125
          Width = 46
          Height = 18
          ColorFlat = 13693852
          ParentColor = True
          Enabled = False
          ReadOnly = True
          TabOrder = 2
          Text = 'edit3'
        end
        object FlatButton1: TFlatButton
          Left = 21
          Top = 173
          Width = 188
          Height = 25
          Caption = '��������ע���룬����ע��'
          TabOrder = 3
          OnClick = FlatButton1Click
        end
        object FlatButton2: TFlatButton
          Left = 232
          Top = 173
          Width = 81
          Height = 25
          Caption = '�ر�'
          TabOrder = 4
          OnClick = FlatButton2Click
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = '1'
        object Label5: TLabel
          Left = 24
          Top = 16
          Width = 288
          Height = 72
          Caption = 
            'ע��˵����'#13#10#13#10'   ���Ѿ������ע�������̴����ע�������𣿼�����' +
            '����ϲ�������뽫ע������������沢������ȷ������ť�����ע�ᡣ��' +
            '�򣬶Բ����뵥�����رա���ť��лл!'
          Color = 15006428
          ParentColor = False
          Transparent = True
          WordWrap = True
        end
        object Label6: TLabel
          Left = 26
          Top = 121
          Width = 72
          Height = 12
          Caption = '���ע��ţ�'
        end
        object Label7: TLabel
          Left = 162
          Top = 121
          Width = 6
          Height = 12
          Caption = '-'
        end
        object Label8: TLabel
          Left = 218
          Top = 121
          Width = 6
          Height = 12
          Caption = '-'
        end
        object redit1: TFlatEdit
          Left = 114
          Top = 117
          Width = 46
          Height = 18
          ColorFlat = 13693852
          ParentColor = True
          TabOrder = 0
          Text = 'redit1'
          OnKeyUp = redit1KeyUp
        end
        object redit2: TFlatEdit
          Left = 170
          Top = 117
          Width = 46
          Height = 18
          ColorFlat = 13693852
          ParentColor = True
          TabOrder = 1
          Text = 'redit2'
          OnKeyUp = redit2KeyUp
        end
        object redit3: TFlatEdit
          Left = 226
          Top = 117
          Width = 46
          Height = 18
          ColorFlat = 13693852
          ParentColor = True
          TabOrder = 2
          Text = 'redit3'
          OnKeyPress = redit3KeyPress
        end
        object FlatButton3: TFlatButton
          Left = 38
          Top = 168
          Width = 87
          Height = 26
          Caption = 'ȷ��(&Y)'
          TabOrder = 3
          OnClick = FlatButton3Click
        end
        object FlatButton4: TFlatButton
          Left = 198
          Top = 168
          Width = 83
          Height = 25
          Caption = 'ȡ��(&N)'
          TabOrder = 4
          OnClick = FlatButton4Click
        end
      end
    end
  end
end
