//API WnetOpenEnum()��WnetEnumResource��ʹ��
unit Unit1;
{Download by http://www.codefans.net}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls;

type
  TNetResourceArray = ^TNetResource;  //������Դ���͵�����
  TForm1 = class(TForm)
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    TreeView1: TTreeView;
    Button1: TButton;
    GroupBox2: TGroupBox;
    Button2: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
{$R *.DFM}
{ Start here }

procedure GetDomainList(TV:TTreeView);
var
   i:Integer;
   ErrCode:Integer;
   NetRes:Array[0..1023] of TNetResource;
   EnumHandle:THandle;
   EnumEntries:DWord;
   BufferSize:DWord;
begin
 try
  With NetRes[0] do
  begin
   dwScope :=RESOURCE_GLOBALNET;
   dwType :=RESOURCETYPE_ANY;
   dwDisplayType :=RESOURCEDISPLAYTYPE_DOMAIN;
   dwUsage :=RESOURCEUSAGE_CONTAINER;
   lpLocalName :=NIL;
   lpRemoteName :=NIL;
   lpComment :=NIL;
   lpProvider :=NIL;
   end;
//get net root
   ErrCode:=
    WNetOpenEnum(
     RESOURCE_GLOBALNET,
     RESOURCETYPE_ANY,
     RESOURCEUSAGE_CONTAINER,
     @NetRes[0],
     EnumHandle
      );
If ErrCode=NO_ERROR then
  begin
    EnumEntries:=1;
    BufferSize:=SizeOf(NetRes);
    ErrCode:=WNetEnumResource(
      EnumHandle,
      EnumEntries,
      @NetRes[0],
      BufferSize
       );
   WNetCloseEnum(EnumHandle);
If ErrCode=NO_ERROR then
 begin
    ErrCode:=WNetOpenEnum(
      RESOURCE_GLOBALNET,
      RESOURCETYPE_ANY,
      RESOURCEUSAGE_CONTAINER,
      @NetRes[0],
      EnumHandle
       );
    EnumEntries:=1024;
    BufferSize:=SizeOf(NetRes);
    ErrCode:=WNetEnumResource(
     EnumHandle,
     EnumEntries,
     @NetRes[0],
     BufferSize
      );

IF ErrCode=No_Error then
 for i:=0 to 1024 do
  begin
    if(NetRes[i].lpProvider=nil) then
     begin
      showmessage('�����Ϲ���'+inttostr(i)+'������');
      break;
     end
    else
    with TV do
     begin
      Items.BeginUpdate;
      Items.Add(TV.Selected,'��'+inttostr(i+1)+'������');
      Items.Add(TV.Selected,'�����ṩ�̣�'+string(NetRes[i].lpProvider));
      Items.Add(TV.Selected,'��������'+string(NetRes[i].lpLocalName));
      Items.Add(TV.Selected,'Զ�̻�������������'+string(NetRes[i].lpRemoteName));
      Items.Add(TV.Selected,'��ע��'+string(NetRes[i].lpComment));
      Items.Add(TV.Selected,'-------');
      Items.EndUpdate;      
     end;
  end;
 end;
 end;
 except
   showmessage('�����ھ���û�й����������');
 end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 TreeView1.Items.BeginUpdate;
 TreeView1.Items.Clear;
 TreeView1.Items.EndUpdate;
 GetDomainList(TreeView1);
end;

//����GetServerList�оٳ����������еĹ��������ƣ�����ֵΪTRUE��ʾִ�гɹ���
//����List�з��ط������������飩������
Function GetServerList( var List : TStringList ) : Boolean;
Var
NetResource : TNetResource;
Buf : Pointer;
Count,BufSize,Res : DWORD;
lphEnum : THandle;
p:TNetResourceArray;
i,j : SmallInt;
NetworkTypeList : TList;
Begin
Result := False;
NetworkTypeList := TList.Create;
List.Clear;
Res := WNetOpenEnum( RESOURCE_GLOBALNET, RESOURCETYPE_DISK,
RESOURCEUSAGE_CONTAINER, Nil,lphEnum);
//��ȡ���������е��ļ���Դ�ľ����lphEnumΪ��������
If Res <> NO_ERROR Then exit;
//ִ��ʧ�ܣ��˳�

//ִ�гɹ�����ʼ��ȡ���������е�����������Ϣ
Count := $FFFFFFFF;
//������Դ��Ŀ
BufSize := 8192;
//��������С����Ϊ8K
GetMem(Buf, BufSize);
//�����ڴ棬���ڻ�ȡ��������Ϣ
Res := WNetEnumResource(lphEnum, Count, Pointer(Buf), BufSize);
If ( Res = ERROR_NO_MORE_ITEMS )
//��Դ�о����
or (Res <> NO_ERROR )
//ִ��ʧ��
Then Exit;

P := TNetResourceArray(Buf);
For I := 0 To Count - 1 Do
//��¼�����������͵���Ϣ
Begin
NetworkTypeList.Add(p);
Inc(P);
End;

//WNetCloseEnum�ر�һ���оپ��
Res:= WNetCloseEnum(lphEnum);
//�ر�һ���о�
If Res <> NO_ERROR Then exit;
For J := 0 To NetworkTypeList.Count-1 Do
//�г��������������е����й���������
Begin
//�г�һ�����������е����й���������
NetResource := TNetResource(NetworkTypeList.Items[J]^);
//����������Ϣ
//��ȡĳ���������͵��ļ���Դ�ľ����NetResourceΪ����������Ϣ��lphEnumΪ��������
Res := WNetOpenEnum(RESOURCE_GLOBALNET, RESOURCETYPE_DISK,
RESOURCEUSAGE_CONTAINER, @NetResource,lphEnum);
If Res <> NO_ERROR Then break;
//ִ��ʧ��
While true Do
//�о�һ���������͵����й��������Ϣ
Begin
Count := $FFFFFFFF;
//������Դ��Ŀ
BufSize := 8192;
//��������С����Ϊ8K
GetMem(Buf, BufSize);
//�����ڴ棬���ڻ�ȡ��������Ϣ����ȡһ���������͵��ļ���Դ��Ϣ��
Res := WNetEnumResource(lphEnum, Count, Pointer(Buf), BufSize);
If ( Res = ERROR_NO_MORE_ITEMS )
//��Դ�о����
or (Res <> NO_ERROR)
//ִ��ʧ��
then break;
P := TNetResourceArray(Buf);
For I := 0 To Count - 1 Do
//�оٸ������������Ϣ
Begin
List.Add( StrPAS( P^.lpRemoteName ));
//ȡ��һ�������������
Inc(P);
End;
End;
Res := WNetCloseEnum(lphEnum);
//�ر�һ���о�
If Res <> NO_ERROR Then break;
//ִ��ʧ��
End;
Result := True;
FreeMem(Buf);
NetworkTypeList.Destroy;
End;


procedure TForm1.Button2Click(Sender: TObject);
var
 sl:TstringList;
 i:integer;
begin
 memo1.lines.Clear;
 sl:=Tstringlist.create;
if GetServerList(sl) then
 begin
  memo1.lines.Add('�ܹ��ҵ�'+inttostr(sl.count)+'�������飡');
 for i:=0 to sl.count-1 do
   memo1.lines.Add (sl.Strings[i]);
 end
 else
   memo1.lines.Add('û���ҵ������飡');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   memo1.lines.Clear;
end;

end.

