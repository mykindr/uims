(*//
����:�򵥵�ͼ��ʶ��
����:����ֻ��Ϊ��������
���:Zswang
����:2003-09-09

http://verify.tencent.com/getimage?0.13927358567975412
����һ�������롫��

�ȷ�����
�ѵ㣺
1.�ĸ����ּ�����һЩ����Ĳ��㡫��
2.������������ɫҲ�������

���㣺
1.���ִ�Сһ�£����岻�ᷢ���ı䡫��
2.ֻ��������ɫ����

˼·��
ȡ�ñ���ɫ������ɫ�Ƚ����ף�˭�ĵ����Ǳ�������
��������TBitmap::PixelFormat������ɵ�ɫ����

����׼���������屣���������ͣ�����������Ϊ�Ƚϵ�Ԫ�ء���
������ͼ���ص�����
�Ƚ��ص�ǰ���ص����Ƿ����仯����
�����Ϳ��Ա����������ĸ��š���

������˵������Ϊ������
//*)

unit RecogniseUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ImgList, StdCtrls, OleCtrls, SHDocVw,MSHTML,WinInet;

type
  TFormRecognise = class(TForm)
    ImageList1: TImageList;
    ButtonRefresh: TButton;
    Panel1: TPanel;
    WebBrowser1: TWebBrowser;
    procedure ButtonRefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    procedure FillIEForm(aValidatecode:String;bPost:boolean=False);
    { Public declarations }
  end;

var
  FormRecognise: TFormRecognise;
const
  cURL='http://freeqq2.qq.com/nom_reg.shtml';
  cImgX=231;
  cImgY=314;
implementation

{$R *.dfm}

uses Math; //use Math.Min()
procedure TFormRecognise.FillIEForm(aValidatecode:String;bPost:boolean=False);
  procedure DoWithHtmlElement(aElementCollection:IHTMLElementCollection);
  var
    k:integer;
    vk:oleVariant;
    Dispatch: IDispatch;
    HTMLInputElement:IHTMLInputElement;
    HTMLSelectElement:IHTMLSelectElement;
    HTMLOptionElement: IHTMLOptionElement;
    HTMLTextAreaElement: IHTMLTextAreaElement;
    HTMLFormElement:IHTMLFormElement;
    HTMLOptionButtonElement:IHTMLOptionButtonElement;
  begin
    for k:=0 to aElementCollection.length -1 do
    begin
      Vk:=k;
      Application.ProcessMessages;
      Dispatch:=aElementCollection.item(Vk,0);
      if SUCCEEDED(Dispatch.QueryInterface(IHTMLFormElement,HTMLFormElement))then
      begin
        with HTMLFormElement do//��
        begin
          //����
          if bPost then
          begin
            HTMLFormElement.submit ;
            exit;
          end;
        end;
      end
      else if Succeeded(Dispatch.QueryInterface(IHTMLInputElement,HTMLInputElement)) then
      begin
        With HTMLInputElement do//�����ı�
        begin
          if (UpperCase(Type_)='TEXT') or (UpperCase(Type_)='PASSWORD') then
          begin
            value:='qq';
            if Name='Validatecode' then Value:=aValidatecode
            else if Name='Passwd' then Value:='123456'
            else if Name='Passwd1' then Value:='123456';
          end
          else if (UpperCase(Type_)='CHECKBOX') then//��ѡ��
          begin
            checked:=true;
          end
          else if (UpperCase(Type_)='RADIO') then//��ѡ��
          begin
            checked :=true;
          end;
        end;
      end
      else if Succeeded(Dispatch.QueryInterface(IHTMLSelectElement,HTMLSelectElement)) then
      begin
        With HTMLSelectElement do//������
        begin
          selectedIndex :=1;
        end;
      end
      else if Succeeded(Dispatch.QueryInterface(IHTMLTEXTAreaElement,HTMLTextAreaElement)) then
      begin
        with HTMLTextAreaElement do//�����ı�
        begin
          value :='textarea';
        end;
      end
      else if Succeeded(Dispatch.QueryInterface(IHTMLOptionElement,HTMLOptionElement)) then
      begin
        with HTMLOptionElement do//����ѡ��
        begin
          //����
        end;
      end
      else if SUCCEEDED(Dispatch.QueryInterface(IHTMLOptionButtonElement,HTMLOptionButtonElement))then
      begin
        //����
        //����
      end
      else
        //showmessage('other');
        ;
    end;
  end;
var
  HTMLDocument:IHTMLDocument2;
  ElementCollection:IHTMLElementCollection;
begin
  HTMLDocument:=IHTMLDocument2(WebBrowser1.Document);
  if HTMLDocument<>nil then
  begin
    if HTMLDocument.frames.length =0 then//�޿��
    begin
      ElementCollection:=HTMLDocument.Get_All;
      DoWithHtmlElement(ElementCollection);
    end;
  end;
end;
function SameCanvas(mCanvasA, mCanvasB: TCanvas): Boolean; { �Ƚ����������Ƿ���ͬ }
var
  I, J: Integer;
begin
  Result := False;
  if not Assigned(mCanvasA) then Exit;
  if not Assigned(mCanvasB) then Exit;
  for I := Min(mCanvasA.ClipRect.Left, mCanvasB.ClipRect.Left) to
    Min(mCanvasA.ClipRect.Right, mCanvasB.ClipRect.Right) do
    for J := Min(mCanvasA.ClipRect.Top, mCanvasB.ClipRect.Top) to
      Min(mCanvasA.ClipRect.Bottom, mCanvasB.ClipRect.Bottom) do
      if mCanvasA.Pixels[I, J] <> mCanvasB.Pixels[I, J] then Exit;
  Result := True;
end; { SameCanvas }

procedure TFormRecognise.ButtonRefreshClick(Sender: TObject);
  procedure fNumBitmap(mHandle: THandle; mIndex: Integer; mBitmap: TBitmap);
  var
    vDC: HDC;
  begin
    vDC := GetDC(mHandle);
    try
      mBitmap.Assign(nil);
      mBitmap.Width := 5;
      mBitmap.Height := 8;
      BitBlt(mBitmap.Canvas.Handle, 0, 0, mBitmap.Width, mBitmap.Height, vDC,
        CImgX + 6 * mIndex, CImgY, SRCCOPY);
      mBitmap.PixelFormat := pf8bit;
      mBitmap.PixelFormat := pf1bit;
    finally
      DeleteDC(vDC);
    end;
  end;

  function fGetNum(mHandle: THandle; mIndex: Integer): Integer;
  var
    I: Integer;
    vBitmapA: TBitmap;
    vBitmapB: TBitmap;
  begin
    Result := -1;
    vBitmapA := TBitmap.Create;
    vBitmapB := TBitmap.Create;
    fNumBitmap(mHandle, mIndex, vBitmapA);
    vBitmapB.Width := vBitmapA.Width;
    vBitmapB.Height := vBitmapA.Height;
    for I := 9 downto 0 do begin //8�Ḳ��3�Ļ����룬���Է�ѭ��
      vBitmapB.Canvas.Draw(0, 0, vBitmapA);
      ImageList1.Draw(vBitmapB.Canvas, 0, 0, I);
      vBitmapB.PixelFormat := pf8bit;
      vBitmapB.PixelFormat := pf1bit;
      if SameCanvas(vBitmapA.Canvas, vBitmapB.Canvas) then begin
        Result := I;
        Exit;
      end;
    end;
    vBitmapA.Free;
    vBitmapB.Free;
  end;
  procedure AppendFile(aFileName,aContent:String);
  var
    StrList:TStringList;
  begin
    StrList:=TStringList.Create;
    //����׷��
    if FileExists(aFileName) then
      StrList.LoadFromFile(aFileName);
    StrList.Add(aContent);
    StrList.SaveToFile(aFileName);
    StrList.Free;
  end;

var
  S,tmpStr,tmpContent: string;
  I: Integer;
  HTMLDocument:IHTMLDocument2;
begin
  TButton(Sender).Enabled := False;
  if not InternetCheckConnection(PChar(CUrl), 1, 0) then
  Begin
    ShowMessage('��·��ͨ!');
    Exit;
  End;
  WebBrowser1.Navigate(CURL);
  while WebBrowser1.ReadyState <READYSTATE_COMPLETE	 do
      Application.ProcessMessages;
  S := '';
  SetWindowPos(Handle, HWND_TOPMOST, Left, Top, 0, 0, SWP_NOSIZE);
  for I := 0 to 3 do S := S + IntToStr(fGetNum(WebBrowser1.Handle, I));
  SetWindowPos(Handle, HWND_NOTOPMOST, Left, Top, 0, 0, SWP_NOSIZE);
  //�� ��
  FillIEForm(S);
  //�ύ
  FillIEForm('',True);
  //�ȴ��ύ���
  while (WebBrowser1.LocationURL  =CURL) do
  Begin
    //ǿ�ƽ���
    If Tag=27 then Exit;
    Application.ProcessMessages;
  End;
  //��ʾ���
  while WebBrowser1.ReadyState <READYSTATE_COMPLETE	 do
      Application.ProcessMessages;

  if Succeeded(WebBrowser1.Document.QueryInterface(IHTMLDocument2,HTMLDocument)) then
  Begin
    if assigned(HTMLDocument.body) then
    begin
      tmpStr:=HTMLDocument.body.OuterText;
      if tmpStr<>'' then
      begin
        if Pos('�������QQ����Ϊ��',tmpStr)>0 then
        Begin
          tmpContent:=Copy(tmpStr,Pos('�������QQ����Ϊ��',tmpStr),28)+
            #13#10+'��������ʼ����Ϊ123456';
          ShowMessage(tmpContent+#13#10+#13#10+'������<QQ���������б�.txt>');
          tmpContent:=tmpContent+'  ��'+DateTimeTOStr(Now);
          //����
          AppendFile(ExtractFilePath(Application.ExeName)+'QQ���������б�.txt',tmpContent);
        End
        else if Pos('��ip����qq������࣬���Ժ�����!!',tmpStr)>0 then
          ShowMessage('��ip����qq������࣬���Ժ�����!!')
        else
          ShowMessage('δ֪����');
      end
      else
        ShowMessage('��IP�Ѿ������');
    End;
  End;
  WebBrowser1.Navigate('about:blank');
  ButtonRefresh.Enabled := True;
end;


procedure TFormRecognise.FormCreate(Sender: TObject);
begin
  //WebBrowser1.Navigate('http://freeqq2.qq.com/nom_reg.shtml');
  //WebBrowser1.Navigate('about:blank');
  WebBrowser1.Left:=Panel1.Left-CImgX+8;//-223    0        231
  WebBrowser1.Top:=Panel1.Top-CImgY+8;;  //-306    0        314
  WebBrowser1.Width:=CImgX+50;//300     52
  WebBrowser1.Height:=CImgY+50;//350    23
end;

procedure TFormRecognise.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  Tag:=27;
  if WebBrowser1.Busy then
  Begin
    WebBrowser1.Navigate('about:blank');
    Application.Terminate;
  End;
end;

end.
