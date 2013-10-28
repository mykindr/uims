{*******************************************************}
{                                                       }
{       IEBar ͼ�Ŀ��                                  }
{                                                       }
{       ��Ȩ���� (C) 2005��������           ������������}
{            ת���뱣������Ϣ ������������������������  }
{       ��ַ��batconv.512j.com                          }
{       batconv@163.com                                 }
{*******************************************************}

unit IEForm;

interface

uses 
 Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, 
 SHDocVw,MSHTML, StdCtrls, Buttons, ExtCtrls, OleCtrls, inifiles,Menus,
  ToolWin, ComCtrls,ComObj, ImgList;

type 
 TfrmMain = class(TForm)
    SpeedButton1: TSpeedButton;
    Panel1: TPanel;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    ImageList1: TImageList;
   procedure FormResize(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure SpeedButton1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SpeedButton3Click(Sender: TObject);
 private 
   { Private declarations }
   MyInifile: TInifile;
   W1,w2,w3,w4,w5,w6:integer;
   ssSavepath:string;
   procedure PutData; //�Զ���дIE����ҳ������������
   function GetMhtText(URL:string):string;
 public 
   IEThis:IWebbrowser2;
   { Public declarations } 
 end; 

var 
 frmMain: TfrmMain;

implementation

uses ShizhiUnit;

{$R *.DFM} 

procedure TfrmMain.FormCreate(Sender: TObject);
var
  vIniFileName :string;
  vSysPath: array[0..255] of char;
begin
  GetSystemDirectory(vSysPath, 256);
  vIniFileName := vSysPath + '\QC.ini';
  MyInifile := TInifile.Create(vIniFileName);
  SpeedButton1.Visible:=myinifile.ReadBool('CBVisible', 'CB1', True);
  N1.Checked:=myinifile.ReadBool('CBVisible', 'CB1', True);
  SpeedButton2.Visible:=myinifile.ReadBool('CBVisible', 'CB2', True);
  N2.Checked:=myinifile.ReadBool('CBVisible', 'CB2', True);
  SpeedButton3.Visible:=myinifile.ReadBool('CBVisible', 'CB3', True);
  N3.Checked:=myinifile.ReadBool('CBVisible', 'CB3', True);
  SpeedButton4.Visible:=myinifile.ReadBool('CBVisible', 'CB4', True);
  N4.Checked:=myinifile.ReadBool('CBVisible', 'CB4', True);
  SpeedButton5.Visible:=myinifile.ReadBool('CBVisible', 'CB5', True);
  N5.Checked:=myinifile.ReadBool('CBVisible', 'CB5', True);
  SpeedButton6.Visible:=myinifile.ReadBool('CBVisible', 'CB6', True);
  N6.Checked:=myinifile.ReadBool('CBVisible', 'CB6', True);
  ssSavepath:=myinifile.Readstring('App','SavePath','C:\WWQC');
  if not DirectoryExists(ssSavepath) then MkDir(ssSavepath);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  MyInifile.Destroy;
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  if SpeedButton1.Visible then w1:=38 else w1:=0;
  if SpeedButton2.Visible then w2:=38 else w2:=0;
  if SpeedButton3.Visible then w3:=38 else w3:=0;
  if SpeedButton4.Visible then w4:=38 else w4:=0;
  if SpeedButton5.Visible then w5:=38 else w5:=0;
  if SpeedButton6.Visible then w6:=38 else w6:=0;

 With Panel1 do begin
   Left := 0;
   Top := 0;
   Height:=Self.ClientHeight;
 end;
 With SpeedButton1 do begin
   Left :=Panel1.Width;
   Top := 0;
   Height:=Self.ClientHeight;
 end;
 With SpeedButton2 do begin
   Left :=Panel1.Width+W1;
   Top := 0;
   Height:=Self.ClientHeight;
 end;
 With SpeedButton3 do begin
   Left :=Panel1.Width+W1+W2;
   Top := 0;
   Height:=Self.ClientHeight;
 end;
 With SpeedButton4 do begin
   Left :=Panel1.Width+W1+W2+W3;
   Top := 0;
   Height:=Self.ClientHeight;
 end;
 With SpeedButton5 do begin
   Left :=Panel1.Width+W1+W2+W3+W4;
   Top := 0;
   Height:=Self.ClientHeight;
 end;
 With SpeedButton6 do begin
   Left :=Panel1.Width+W1+W2+W3+W4+W5;
   Top := 0;
   Height:=Self.ClientHeight;
 end;

end;

procedure TfrmMain.Panel1Click(Sender: TObject);
begin
    MessageDlg('���Ŀ�� V1.0' + #13 + #13 + #13
    + '���ٱ��浱ǰ�����ҳ����ҳ���ı���ͼƬ��' + #13 + 'ץȡ��ҳͼƬ�����ӣ����Ӽ����塣'
    + #13 + #13 + '��Ȩ���У�������' + #13 +'�ٷ���վ��http://batconv.512j.com'+ #13+
    '����֧�֣�batconv@163.com' + #13 + #13 + 'Copyright(C) 2005 yuelu software',
    mtInformation,[mbOk], 0);
end;

procedure TfrmMain.SpeedButton1Click(Sender: TObject); //������ҳ
var
  ShellWindow: IShellWindows;
  nCount: integer;
  spDisp: IDispatch;
  i: integer;
  vi: OleVariant;
  IE1: IWebBrowser2;
  IDoc1: IHTMLDocument2;
  F:textfile;
  sDir,s:string;
  iHour,iMin,iSec,iMSec:word;
begin
  ShellWindow := CoShellWindows.Create;
  nCount := ShellWindow.Count;
  sDir:=ssSavepath+'\��ҳ\';
  if not DirectoryExists(sDir) then MkDir(sDir);
  DecodeTime(now,iHour,iMin,iSec,iMSec);
  s:=Trim(IntToStr(iHour))+Trim(IntToStr(iMin))+Trim(IntToStr(iSec))+Trim(IntToStr(iMSec));
  try
    AssignFile(F,sDir+s+'.htm');
    Rewrite(F);
    for i := 0 to nCount - 1 do
    begin
      vi := i;
      spDisp := ShellWindow.Item(vi);
      spDisp.QueryInterface( iWebBrowser2, IE1 );
      if IE1 <> nil then
      begin
        IE1.Document.QueryInterface(IHTMLDocument2,iDoc1);
        if iDoc1 <> nil then
          Writeln(F,iDoc1.body.innerHTML);
      end;
    end;
  finally
    Closefile(F);
  end;
end;

procedure TfrmMain.SpeedButton2Click(Sender: TObject); //������ҳΪ�ı�
var
  ShellWindow: IShellWindows;
  nCount: integer;
  spDisp: IDispatch;
  i: integer;
  vi: OleVariant;
  IE1: IWebBrowser2;
  IDoc1: IHTMLDocument2;
  F:textfile;
  sDir,s:string;
  iHour,iMin,iSec,iMSec:word;
begin
  ShellWindow := CoShellWindows.Create;
  nCount := ShellWindow.Count;
  sDir:=ssSavepath+'\�ı�\';
  if not DirectoryExists(sDir) then MkDir(sDir);
  DecodeTime(now,iHour,iMin,iSec,iMSec);
  s:=Trim(IntToStr(iHour))+Trim(IntToStr(iMin))+Trim(IntToStr(iSec))+Trim(IntToStr(iMSec));
  try
    AssignFile(F,sDir+s+'.txt');
    Rewrite(F);
    for i := 0 to nCount - 1 do
    begin
      vi := i;
      spDisp := ShellWindow.Item(vi);
      spDisp.QueryInterface( iWebBrowser2, IE1 );
      if IE1 <> nil then
      begin
        IE1.Document.QueryInterface(IHTMLDocument2,iDoc1);
        if iDoc1 <> nil then
          Writeln(F,iDoc1.body.innerText);
      end;
    end;
  finally
    Closefile(F);
  end;
end;


procedure TfrmMain.PutData; //�Զ���дIE����ҳ������������
var
  ShellWindow: IShellWindows;
  nCount: integer;
  spDisp: IDispatch;
  i,j,X: integer;
  vi: OleVariant;
  IE1: IWebBrowser2;
  IDoc1: IHTMLDocument2;
  iELC : IHTMLElementCollection ;
  S,S2 : string;
  HtmlInputEle : IHTMLInputElement;
  HtmlSelEle : IHTMLSelectElement;
  HtmlTextEle: IHTMLTextElement;
begin
  ShellWindow := CoShellWindows.Create;
  nCount := ShellWindow.Count;
  for i := 0 to nCount - 1 do
  begin
    vi := i;
    spDisp := ShellWindow.Item(vi);
    if spDisp = nil then continue;
    spDisp.QueryInterface( iWebBrowser2, IE1 );
    if IE1 <> nil then
    begin
      IE1.Document.QueryInterface(IHTMLDocument2,iDoc1);
      if iDoc1 <> nil then
      begin
        ielc:=idoc1.Get_all;
        for j:=0 to ielc.length-1 do
        begin
          Application.ProcessMessages;
          spDisp := ielc.item(J, 0);
          if SUCCEEDED(spDisp.QueryInterface(IHTMLInputElement ,HtmlInputEle))then
          with HtmlInputEle do
          begin
            S2:=Type_;
            S2:=UpperCase(S2);
            //�Ұ����е�input������ try �� checkbox ����
            if (StrComp(PChar(S2),'TEXT')=0) or (StrComp(PChar(S2),'PASSWORD')=0) then
              value :='try' //S:=S+#9+Value
            else if StrComp(PChar(S2),'CHECKBOX')=0 then
            begin
              checked := True;
            end;
          end;
         { if SUCCEEDED(spDisp.QueryInterface(IHTMLTextelement ,HtmlTextEle))then
           HtmlTextEle  }

          {if SUCCEEDED(spDisp.QueryInterface(IHTMLselectelement ,HtmlSelEle))then
          with HtmlSelEle, Memo1.Lines do
          begin
            S:=S+#9+IntToStr(selectedIndex+1); //����ǻ�ȡ������
          end; }
        end; //END FOR
        //Memo2.Lines.Add(S);
        exit;
      end;
    end;
  end;
end;


procedure TfrmMain.SpeedButton4Click(Sender: TObject); //��ȡѡ�е��ı�
var
  FDoc:IHTMLDocument2;
  FSel:IHTMLSelectionObject;
  FRange:IHTMLTxtRange;
  s,sDir:string;
  sText:widestring;
  F: TextFile;
begin
  if Assigned(IEThis)then
  begin
    FDoc:=IEThis.Document as IHTMLDocument2;
    FRange:=FDoc.selection.createRange as IHTMLTxtRange;
    sText:=FRange.Get_text;
    if trim(sText)<>'' then
    begin
     try
      sDir:=ssSavepath+'\�ı�\';
      if not DirectoryExists(sDir) then MkDir(sDir);
      s:=copy(sText,1,12);
      AssignFile(F,sDir+s+'.txt');
      Rewrite(F);
      Writeln(F,sText);
     finally
      Closefile(F);
     end;
    end;
  end;
end;

procedure TfrmMain.SpeedButton5Click(Sender: TObject);//��ȡ����
var
 doc:IHTMLDocument2;
 name,all:IHTMLElementCollection;
 len,i,flag:integer;
 item:IHTMLElement;
 vAttri:Variant;
 F: TextFile;
 sDir,s:string;
 iHour,iMin,iSec,iMSec:word;
 sTitle:widestring;
begin
 if Assigned(IEThis)then
 begin
   //���Webbrowser�����е��ĵ�����
   doc:=IEThis.Document as IHTMLDocument2;
   //����ĵ������е�HTMLԪ�ؼ���
   sTitle:=doc.get_title;
   all:=doc.Get_all;
   len:=all.Get_length;
   sDir:=ssSavepath+'\����\';
   if not DirectoryExists(sDir) then MkDir(sDir);
   DecodeTime(now,iHour,iMin,iSec,iMSec);
   s:=Trim(IntToStr(iHour))+Trim(IntToStr(iMin))+Trim(IntToStr(iSec))+Trim(IntToStr(iMSec));

   try
     AssignFile(F,sDir+sTitle+s+'.txt');
     Rewrite(F);
     //����HTMLԪ�ؼ����е�ÿһ��Ԫ��
     for i:=0 to len-1 do begin
       item:=all.item(i,varempty) as IHTMLElement;
       //�����Ԫ����һ������
       if item.Get_tagName = 'A'then begin
         flag:=0;
         vAttri:=item.getAttribute('protocol',flag);     //�����������
         //�����mailto���������ӵ�Ŀ���ַ��ӵ�ComboBox1
         if vAttri = 'http:' then
         begin
           vAttri:=item.getAttribute('href',flag);
           Writeln(F,vAttri);
           //ComboBox1.Items.Add(vAttri);
         end;
       end;
     end;
   finally
     CloseFile(F);
   end;
 end;
end;

procedure TfrmMain.SpeedButton6Click(Sender: TObject);
begin
  Application.CreateForm(TfrmShizhi, frmShizhi);
  frmShizhi.ShowModal;
end;


procedure TfrmMain.N1Click(Sender: TObject);
begin
  if sender=N1 then
  begin
    SpeedButton1.Visible:=not SpeedButton1.Visible;
    N1.Checked:=SpeedButton1.Visible;
    myinifile.WriteBool('CBVisible', 'CB1', SpeedButton1.Visible);
  end;
  if sender=N2 then
  begin
    SpeedButton2.Visible:=not SpeedButton2.Visible;
    N2.Checked:=SpeedButton2.Visible;
    myinifile.WriteBool('CBVisible', 'CB2', SpeedButton2.Visible);
  end;
  if sender=N3 then
  begin
    SpeedButton3.Visible:=not SpeedButton3.Visible;
    N3.Checked:=SpeedButton3.Visible;
    myinifile.WriteBool('CBVisible', 'CB3', SpeedButton3.Visible);
  end;
  if sender=N4 then
  begin
    SpeedButton4.Visible:=not SpeedButton4.Visible;
    N4.Checked:=SpeedButton4.Visible;
    myinifile.WriteBool('CBVisible', 'CB4', SpeedButton4.Visible);
  end;
  if sender=N5 then
  begin
    SpeedButton5.Visible:=not SpeedButton5.Visible;
    N5.Checked:=SpeedButton5.Visible;
    myinifile.WriteBool('CBVisible', 'CB5', SpeedButton5.Visible);
  end;
  if sender=N6 then
  begin
    SpeedButton6.Visible:=not SpeedButton6.Visible;
    N6.Checked:=SpeedButton6.Visible;
    myinifile.WriteBool('CBVisible', 'CB6', SpeedButton6.Visible);
  end;
  FormResize(Sender);
end;

procedure TfrmMain.SpeedButton1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
{  SpeedButton1.Font.Color:=clWindowText;
  SpeedButton2.Font.Color:=clWindowText;
  SpeedButton3.Font.Color:=clWindowText;
  SpeedButton4.Font.Color:=clWindowText;
  SpeedButton5.Font.Color:=clWindowText;
  SpeedButton6.Font.Color:=clWindowText;

  if sender=SpeedButton1 then SpeedButton1.Font.Color:=clRed;
  if sender=SpeedButton2 then SpeedButton2.Font.Color:=clRed;
  if sender=SpeedButton3 then SpeedButton3.Font.Color:=clRed;
  if sender=SpeedButton4 then SpeedButton4.Font.Color:=clRed;
  if sender=SpeedButton5 then SpeedButton5.Font.Color:=clRed;
  if sender=SpeedButton6 then SpeedButton6.Font.Color:=clRed;  }
end;

procedure TfrmMain.SpeedButton3Click(Sender: TObject);  //����ΪMHT��Ŀǰ����֧������:(
var
  ShellWindow: IShellWindows;
  nCount: integer;
  spDisp: IDispatch;
  i: integer;
  vi: OleVariant;
  IE1: IWebBrowser2;
  IDoc1: IHTMLDocument2;
  F:textfile;
  sDir,s:string;
  iHour,iMin,iSec,iMSec:word;
  sTitle:widestring;
begin
  ShellWindow := CoShellWindows.Create;
  nCount := ShellWindow.Count;
  sDir:=ssSavepath+'\MHT\';
  if not DirectoryExists(sDir) then MkDir(sDir);
  DecodeTime(now,iHour,iMin,iSec,iMSec);
  s:=Trim(IntToStr(iHour))+Trim(IntToStr(iMin))+Trim(IntToStr(iSec))+Trim(IntToStr(iMSec));
  try
    AssignFile(F,sDir+s+'.mht');
    Rewrite(F);
    for i := 0 to nCount - 1 do
    begin
      vi := i;
      spDisp := ShellWindow.Item(vi);
      spDisp.QueryInterface( iWebBrowser2, IE1 );
      if IE1 <> nil then
      begin
        IE1.Document.QueryInterface(IHTMLDocument2,iDoc1);
        if iDoc1 <> nil then
          Writeln(F,GetMhtText(IDOC1.url));
      end;
    end;
  finally
    Closefile(F);
  end;
end;

function TfrmMain.GetMhtText(URL:string):string;
var
  iMsg,iConf:olevariant;
begin
  imsg:=createoleobject('CDO.Message');
  iConf:=CreateoleObject('CDO.Configuration');
  imsg.Configuration := iConf;
  try
    iMsg.CreateMHTMLBody(url,0,'domain\username','password');
    result:=imsg.getstream.readtext;
  except
    raise;
  end;
end;

end.

