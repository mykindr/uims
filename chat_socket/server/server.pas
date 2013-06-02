unit server;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, ScktComp, StdCtrls, DB, DBTables, ToolWin;

type
  TForm1 = class(TForm)
    ServerSocket1: TServerSocket;
    StatusBar1: TStatusBar;
    GroupBox1: TGroupBox;
    ListBox1: TListBox;
    Table1: TTable;
    ToolBar1: TToolBar;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    GroupBox2: TGroupBox;
    Memo1: TMemo;
    Button4: TButton;
    procedure ServerSocket1Listen(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1ClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1ClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1ClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure N1Click(Sender: TObject);
    procedure ServerSocket1Accept(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1ClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  i : integer;
  //addr: array [0..100] of  string;
  counter : integer;
  chatname : array [0..100] of string;
  clientip: string;
implementation

uses Unit3;

{$R *.dfm}

procedure TForm1.ServerSocket1Listen(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  statusbar1.SimpleText:='����״̬...';
  counter:=0;
end;

procedure TForm1.ServerSocket1ClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
 statusbar1.SimpleText:='���ӵ� '+ socket.RemoteAddress;
end;

procedure TForm1.ServerSocket1ClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  statusbar1.SimpleText:= Socket.RemoteAddress +' ������';
end;

procedure TForm1.ServerSocket1ClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
  var
      tmptext: string;
      check :string;
      i,j: integer;
      chattext:string;
      signpos : integer;
      member : string;
      usename : string;
begin
     tmptext := socket.ReceiveText;
  if pos('%&%&%&',tmptext)<>0 then // ����'%&%&%&'�ַ���ʱ��ʾ˽��
    begin
      tmptext := copy(tmptext,1,length(tmptext)-6);
      signpos:= pos('&&',tmptext);
      chattext:= copy(tmptext,1,signpos-1);
      member:=copy(tmptext, signpos+2,pos('$$',tmptext)-2-signpos);
      usename:=copy(tmptext,pos('$$',tmptext)+2,length(tmptext)-pos('$$',tmptext)+2);
      for i:=0 to  counter-1  do
         begin
         if member=chatname[i] then
            begin
            serversocket1.Socket.Connections[i].SendText(usename+'���Ķ���˵��'+chattext);
            break;
            end;
         end;
    end

  else if   pos('$%$%$%',tmptext)<>0  then  // ����'$%$%$%'��ʾ�е�½��Ϣ
      begin
        tmptext := copy(tmptext,1,length(tmptext)-6);
        chatname[counter]:=tmptext;
        listbox1.Items.add(tmptext);
        check :=(table1.lookup('usename',tmptext,'password'));
        socket.SendText(check+'@#$%^&');
        if counter>0 then
         begin
           for i:=0 to counter-1 do
           begin
             serversocket1.Socket.Connections[counter].SendText(chatname[i]+'~{}()&*%^');
             serverSocket1.Socket.Connections[i].SendText(tmptext+'~{}()&*%^');
             sleep(300);
           end;
        end;
        inc(counter);
      end
else if pos('??**##',tmptext)<>0  then   //��ʾע����Ϣ
       begin
           signpos:=pos('??**##',tmptext);
           member:=copy(tmptext,1,signpos-1);
           chattext:=copy(tmptext,signpos+6,length(tmptext)-6-length(member));
           with table1 do
           begin
           if   table1.FindField('usename').AsString=member  then
                socket.SendText('�û����Ѿ��������ˣ����������ע�ᡣ')
           else
              begin
                insertrecord([member,chattext]);
                memo1.Lines.Add('���û���['+member+']ע��ɹ���');
                socket.SendText('ע��ɹ������ȵ�½�ٽ������죡');
              end;
           end;
       end
else if  pos('*^&%#^)@',tmptext)<>0 then // ��������
        begin
        tmptext:=copy(tmptext,1,length(tmptext)-8);
//        memo1.Lines.Add('�û�['+tmptext+']�뿪�����ҡ�');
        for i:=0 to counter-1 do
          serversocket1.Socket.Connections[i].SendText(tmptext+'^$%#^$');
        for i:=listbox1.items.Count downto 1 do
          if listbox1.Items.Strings[i-1]=tmptext then
              begin
              listbox1.Items.Delete(i-1);
              dec(counter);
              end;
        end
else  // �����κα��ʱ��ʾ����
         begin
         for i:=0 to counter-1 do
         serversocket1.Socket.Connections[i].SendText(tmptext);
         end;
end;

procedure TForm1.N1Click(Sender: TObject);
begin
       serversocket1.Active:=false;
       serversocket1.Close;
end;

procedure TForm1.ServerSocket1Accept(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   clientip:=socket.RemoteAddress
end;

procedure TForm1.ServerSocket1ClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  if errorcode=10054 then
    errorcode:=0;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  table1.Active:=true;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if not serversocket1.Active then
  begin
    serversocket1.Active:=true;
    memo1.Lines.Add('���������ӣ�['+Datetimetostr(now)+']');
  end else
    showmessage('�Ѿ��ڼ���״̬');
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  serversocket1.Active:=false;
  serversocket1.Close;
  statusbar1.SimpleText:='�������Ѿ��ر�';
  memo1.Lines.Add('�������رգ�['+Datetimetostr(now)+']');
  listbox1.Clear;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  button1.Click;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  Form3.ShowModal;
end;

end.
