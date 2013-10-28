unit Unit1;
{Download by http://www.codefans.net}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    StaticText1: TStaticText;
    Panel1: TPanel;
    ListBox1: TListBox;
    StaticText2: TStaticText;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

Function GetUsers(GroupName:string;var List:TStringList):Boolean;
Function GetUserResource( UserName : string ; var List : TStringList ) : Boolean;

implementation
{$R *.DFM}
type
  TNetResourceArray = ^TNetResource;  //������Դ���͵�����

Function GetUsers(GroupName:string;var List:TStringList):Boolean;
Var
  NetResource:TNetResource;
  Buf : Pointer;
  Count,BufSize,Res : DWord;
  Ind : Integer;
  lphEnum : THandle;
  Temp:TNetResourceArray;
Begin
  Result := False;
  List.Clear;
  FillChar(NetResource, SizeOf(NetResource), 0);  //��ʼ����������Ϣ
  NetResource.lpRemoteName := @GroupName[1];      //ָ������������
  NetResource.dwDisplayType := RESOURCEDISPLAYTYPE_SERVER;//����Ϊ�������������飩
  NetResource.dwUsage := RESOURCEUSAGE_CONTAINER;
  NetResource.dwScope := RESOURCETYPE_DISK;      //�о��ļ���Դ��Ϣ
  Res := WNetOpenEnum( RESOURCE_GLOBALNET, RESOURCETYPE_DISK,RESOURCEUSAGE_CONTAINER, @NetResource,lphEnum);
If Res <> NO_ERROR Then Exit; //ִ��ʧ��
 While True Do          //�о�ָ���������������Դ
  Begin
   Count := $FFFFFFFF; //������Դ��Ŀ
   BufSize := 8192;    //��������С����Ϊ8K
   GetMem(Buf, BufSize);//�����ڴ棬���ڻ�ȡ��������Ϣ,��ȡ���������
   Res := WNetEnumResource(lphEnum, Count, Pointer(Buf), BufSize);
  If Res = ERROR_NO_MORE_ITEMS Then break;//��Դ�о����
  If (Res <> NO_ERROR) then Exit;//ִ��ʧ��
    Temp := TNetResourceArray(Buf);
   For Ind := 0 to Count - 1 do//�оٹ�����ļ��������
     Begin
       List.Add(Temp^.lpRemoteName);
       Inc(Temp);
     End;
 End;
 Res := WNetCloseEnum(lphEnum);//�ر�һ���о�
If Res <> NO_ERROR Then exit;//ִ��ʧ��
  Result:=True;
  FreeMem(Buf);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  List:TstringList;
  i:integer;
begin
try
  List:=TstringList.Create;
  if GetUsers(edit1.text,List) then
    if List.count=0 then        //��������û�ҵ������
      begin
        listbox1.Items.Add (edit1.text+'��������û�м������');
      end
   else
     listbox1.Items.Add (edit1.text+'�µ����м�������£�');
     for i:=0 to List.Count-1  do
      begin
        listbox1.Items.Add (List.strings[i]);
      end;
finally
   List:=TstringList.Create;     //�����쳣���ͷŷ������Դ
end;
end;

Function GetUserResource( UserName : string ; var List : TStringList ) : Boolean;
Var
  NetResource : TNetResource;
  Buf : Pointer;
  Count,BufSize,Res : DWord;
  Ind : Integer;
  lphEnum : THandle;
  Temp : TNetResourceArray;
Begin
  Result := False;
  List.Clear;
  FillChar(NetResource, SizeOf(NetResource), 0);  //��ʼ����������Ϣ
  NetResource.lpRemoteName := @UserName[1];       //ָ�����������
  Res := WNetOpenEnum( RESOURCE_GLOBALNET, RESOURCETYPE_ANY,RESOURCEUSAGE_CONNECTABLE, @NetResource,lphEnum);
   //��ȡָ���������������Դ���
 If Res <> NO_ERROR Then exit;                   //ִ��ʧ��
  While True Do                                  //�о�ָ���������������Դ
   Begin
    Count := $FFFFFFFF;                            //������Դ��Ŀ
    BufSize := 8192;                              //��������С����Ϊ8K
    GetMem(Buf, BufSize);                   //�����ڴ棬���ڻ�ȡ��������Ϣ
    Res := WNetEnumResource(lphEnum, Count, Pointer(Buf), BufSize);
                              //��ȡָ���������������Դ����
  If Res = ERROR_NO_MORE_ITEMS Then break;//��Դ�о����
   If (Res <> NO_ERROR) then Exit;        //ִ��ʧ��
     Temp := TNetResourceArray(Buf);
    For Ind := 0 to Count - 1 do
     Begin
     List.Add(Temp^.lpRemoteName);
     Inc(Temp);
    End;
 End;
 Res := WNetCloseEnum(lphEnum);          //�ر�һ���о�
 If Res <> NO_ERROR Then exit;           //ִ��ʧ��
   Result := True;
   FreeMem(Buf);
End;

procedure TForm1.ListBox1DblClick(Sender: TObject);
var
  List:TstringList;
  i:integer;
  user:string;
begin
  user:=Listbox1.Items[listbox1.ItemIndex];
try
  List:=TstringList.Create;
  if GetUserResource(user,List) then
    if List.count=0 then         //ָ���������û���ҵ�������Դ
      begin
        memo1.Lines.Add (user+'��û���ҵ�������Դ��');
      end
   else
     memo1.Lines.Add (user+'�µ����й�����Դ���£�');
     for i:=0 to List.Count-1  do
      begin
        Memo1.lines.Add (List.strings[i]);
      end;
finally
   List:=TstringList.Create;     //�����쳣���ͷŷ������Դ
end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   listbox1.Items.Clear ;
   memo1.Lines.Clear;
end;

end.


