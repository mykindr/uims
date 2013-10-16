//  Update Demo
//
//      -'`"_         -'`" \
//     /     \       /      "
//    /     /\\__   /  ___   \    ADDRESS:
//   |      | \  -"`.-(   \   |     HuaDu GuangZHou,China
//   |      |  |     | \"  |  |   ZIP CODE:
//   |     /  /  "-"  \  \    |     510800
//    \___/  /  (o o)  \  (__/    NAME:
//         __| _     _ |__          ZHONG WAN
//        (      ( )      )       EMAIL:
//         \_\.-.___.-./_/          mantousoft@163.com
//           __  | |  __          HOMEPAGE:
//          |  \.| |./  |           http://www.delphibox.com
//          | '#.   .#' |         OICQ:
//          |__/ '"" \__|           6036742
//        -/             \-
//
//
//  2003-10-11 in GuangZhou China
//  Compiled by Delphi7.0

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, StdCtrls, ComCtrls, CheckLst, IniFiles,shellapi, WinSkinData;

type
  TForm1 = class(TForm)
    IdHTTP1: TIdHTTP;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ProgressBar1: TProgressBar;
    ProgressBar2: TProgressBar;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    StatusBar1: TStatusBar;
    ListView1: TListView;
    Memo1: TMemo;
    SkinData1: TSkinData;
    procedure IdHTTP1Work(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
    procedure IdHTTP1WorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCountMax: Integer);
    procedure Button1Click(Sender: TObject);
    procedure IdHTTP1WorkEnd(Sender: TObject; AWorkMode: TWorkMode);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    function DownLoadFile(sURL, sFName: string): boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
qinterbanben:string;
  Form1: TForm1;

implementation

{$R *.dfm}

function AppPath: string;
begin
  Result := ExtractFilePath(ParamStr(0));
end;

function TForm1.DownLoadFile(sURL, sFName: string): boolean;
var //�����ļ�
  tStream: TMemoryStream;
begin
  tStream := TMemoryStream.Create;
  try //��ֹ����Ԥ�ϴ�����
    try
      IdHTTP1.Get(sURL, tStream); //���浽�ڴ���
      tStream.SaveToFile(sFName); //����Ϊ�ļ�
      Result := True;
    finally //��ʹ��������Ԥ�ϵĴ���Ҳ�����ͷ���Դ
      tStream.Free;
    end;
  except //��ķ�������ִ�еĴ���
    Result := False;
    tStream.Free;
  end;
end;

procedure TForm1.IdHTTP1Work(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCount: Integer);
begin
  ProgressBar1.Position := AWorkCount;
  Application.ProcessMessages;
end;

procedure TForm1.IdHTTP1WorkBegin(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCountMax: Integer);
begin
  ProgressBar1.Max := AWorkCountMax;
  ProgressBar1.Position := 0;
end;

procedure TForm1.IdHTTP1WorkEnd(Sender: TObject; AWorkMode: TWorkMode);
begin
  ProgressBar1.Position := 0;
end;

procedure TForm1.Button1Click(Sender: TObject);
const
  sChkURL = 'http://www.hoposoft.com/update.ini';

var
banben:string;
  banbenini,NewFile, OrgFile: TIniFile;
  SectionList: TStrings;
  aFile: string;
  aDate, bDate: TDate;
  i: Integer;
  ListItem: TListItem;
begin
  StatusBar1.SimpleText := '��������ļ�...';
  Button1.Enabled := False;
{-------------------------------------------}
  if not DownLoadFile(sChkURL, AppPath + 'tmp.ini') then
  begin
    StatusBar1.SimpleText := '��������ļ�ʧ��!';
    Button1.Enabled := True;
    Exit;
  end;

  StatusBar1.SimpleText := '���������ļ�...';
  ListView1.Clear;

  NewFile := TIniFile.Create(AppPath + 'tmp.ini');
  OrgFile := TIniFile.Create(AppPath + 'update.ini');
  try
    SectionList := TStringList.Create;
    try

    //�汾
     banbenini:= TIniFile.Create(extractfilepath(application.ExeName)+'banben.rt');
     banben:=banbenini.ReadString('file','banben','1.2');
     banbenini.Free;///�ͷ�


    //----
      //��ȡ�����ļ��б�
      NewFile.ReadSections(SectionList);
      qinterbanben:=NewFile.ReadString(SectionList.Strings[i], 'banben', '1.2');

      for i := 0 to SectionList.Count - 1 do
      begin
        //��ȡ�����ļ����ļ���
        aFile := NewFile.ReadString(SectionList.Strings[i], 'Name', '');
        //��ȡ�����ļ�������
        bDate := NewFile.ReadDate(SectionList.Strings[i], 'Date', Date);
        //�滻�ļ�����"."����Ϊ"_"����ֹini�ļ���ȡ���󣬵õ����ļ���������ȡ����������Ϣ
        aFile := StringReplace(aFile, '.', '_', [rfReplaceAll]);
        //��ȡ���������ļ�������
        aDate := OrgFile.ReadDate(aFile, 'Date', 1999 - 1 - 1);
        //�����ǰû������ļ�����ô����ļ�һ����Ҫ���µģ�������ȱʡΪ1999-1-1��ֻҪС�������������ڼ���

 if strtofloat(qinterbanben) > strtofloat(banben) then //�Ա�����ȷ���Ƿ���Ҫ����
        begin
          ListItem := ListView1.Items.Add;
          ListItem.Checked := True;
          //��������ļ���
          ListItem.Caption := NewFile.ReadString(SectionList.Strings[i], 'Name', '');
          //��������ļ���С
          ListItem.SubItems.Add(NewFile.ReadString(SectionList.Strings[i], 'Size', ''));
          //��������ļ�����
          ListItem.SubItems.Add(NewFile.ReadString(SectionList.Strings[i], 'Date', ''));
          //��������ļ����ص�ַ
          ListItem.SubItems.Add(NewFile.ReadString(SectionList.Strings[i], 'URL', ''));
          ListItem.SubItems.Add('δ����');
        end;
      end;
      if ListView1.Items.Count = 0 then
        MessageBox(handle, 'û�������ļ��б�', '��Ϣ', MB_OK) else
        Button2.Enabled := True; //�������ļ������ذ�ť�ɲ���
    finally
      SectionList.Free;
    end;
  finally
    OrgFile.Free;
    NewFile.Free;
    banbenini.Free;///�ͷ�
  end;

  StatusBar1.SimpleText := '����...';
  Button1.Enabled := True;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Button2Click(Sender: TObject);
var

  i,i2: integer;
  aDownURL: string;
  aFile,banben: string;
  aDate: TDate;
  banbenini:tinifile;
begin
memo1.Clear;
  StatusBar1.SimpleText := '�������������ļ�...';
  Button1.Enabled := False;
  Button2.Enabled := False;
ProgressBar2.Max := ListView1.Items.Count;

  for i := 0 to ListView1.Items.Count - 1 do
  begin
    banbenini:= TIniFile.Create(extractfilepath(application.ExeName)+'banben.rt');
banbenini.writeString('file','banben',qinterbanben);

    if ListView1.Items.Item[i].Checked then //ѡ��������
    begin
      ListView1.Items.Item[i].SubItems.Strings[3] := '������';
      //�õ����ص�ַ
      aDownURL := ListView1.Items.Item[i].SubItems.Strings[2];
      //�õ��ļ���
      aFile := ListView1.Items.Item[i].Caption;
      memo1.lines.add(afile);
      if DownLoadFile(aDownURL, aFile) then //��ʼ����
      begin
        ListView1.Items.Item[i].SubItems.Strings[3] := '���';
        aFile := StringReplace(aFile, '.', '_', [rfReplaceAll]);
        aDate := StrToDate(ListView1.Items.Item[i].SubItems.Strings[1]);

      end else
        ListView1.Items.Item[i].SubItems.Strings[3] := 'ʧ��';
    end;
    ProgressBar2.Position := ProgressBar2.Position + 1;
    Application.ProcessMessages;
  end;

  MessageBox(handle, '���������ļ����', '��Ϣ', MB_OK);

if messagedlg('�Ƿ��������������ļ�?',mtconfirmation,[mbyes,mbno],0)=mryes then
begin



  ProgressBar2.Position := 0;
  StatusBar1.SimpleText := '����...';
  Button1.Enabled := True;
  Button2.Enabled := True;
  
  for i:=0 to memo1.Lines.Count do
  if memo1.Lines[i] <>'' then
  shellexecute(0,'open',pchar(memo1.lines[i]),nil,nil,1);

end;
  shellexecute(0,'open',pchar(extractfilepath(application.ExeName)),nil,nil,1);
   banbenini.Free;///�ͷ�
end;

end.

