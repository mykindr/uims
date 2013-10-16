unit UCatchScreenShow;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Clipbrd, JPEG;

type
  TCatchScreenShowForm = class(TForm)
    ChildImage: TImage;
    ChildTimer: TTimer;
    SaveDialog1: TSaveDialog;
    procedure ChildTimerTimer(Sender: TObject);
    procedure ChildImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ChildImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CatchScreenShowForm: TCatchScreenShowForm;
  foldx,x1,y1,x2,y2,oldx,oldy,foldy : Integer;
  Flag,Trace : Boolean;
implementation

uses UnitMain, var_;

{$R *.DFM}

procedure BMPToJPG(BmpFileName:string);
var
  Jpeg : TJPEGImage;
  Bmp : TBitmap;
begin
try
  if not FileExists(BmpFileName) then exit;
  Bmp := TBitmap.Create;
  try
    Bmp.LoadFromFile(BmpFileName);
    Jpeg := TJPEGImage.Create;
    try
      Jpeg.Assign(Bmp);
      Jpeg.Compress;
      Jpeg.SaveToFile(ChangeFileExt(BmpFileName,'.jpg'));
    finally
      Jpeg.Free;
    end;
  finally
     Bmp.Free;
  end;
except end;
end;

procedure TCatchScreenShowForm.ChildTimerTimer(Sender: TObject);
var
  Fullscreen:Tbitmap;
  FullscreenCanvas:TCanvas;
  DC:HDC;
begin
  ChildTimer.Enabled := False;
  Fullscreen := TBitmap.Create;
  Fullscreen.Width := Screen.width;
  Fullscreen.Height := Screen.Height;
  DC:=GetDC(0);
  FullscreenCanvas := TCanvas.Create;
  FullscreenCanvas.Handle := DC;
  Fullscreen.Canvas.CopyRect(Rect(0,0,Screen.Width,Screen.Height),FullscreenCanvas,
  Rect(0,0,Screen.Width,Screen.Height));
  FullscreenCanvas.Free;
  ReleaseDC(0,DC);
  ChildImage.picture.Bitmap:=fullscreen;
  ChildImage.Width := Fullscreen.Width;
  ChildImage.Height:=Fullscreen.Height;
  Fullscreen.free;
  CatchScreenShowForm.WindowState := wsMaximized;
  CatchScreenShowForm.show;
  messagebeep(1);
  foldx:=-1;
  foldy:=-1;
  ChildImage.Canvas.Pen.mode := Pmnot; //�ʵ�ģʽΪȡ��
  ChildImage.Canvas.pen.color := clblack; //��Ϊ��ɫ
  ChildImage.Canvas.brush.Style := bsclear;//�հ�ˢ��
  Flag := True;
end;


procedure TCatchScreenShowForm.ChildImageMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if trace=true then//�Ƿ���׷����ꣿ
  begin//�ǣ������ɵľ��β������µľ���
    with ChildImage.canvas do
    begin
        rectangle(x1,y1,oldx,oldy);
        Rectangle(x1,y1,x,y);
        oldx:=x;
        oldy:=y;
    end;
  end
  else if flag=true then//��������ڵ�λ���ϻ�ʮ��
  begin
    with ChildImage.canvas do
        begin
          MoveTo(foldx,0);//�����ɵ�ʮ��
          LineTo(foldx,Screen.Height);
          MoveTo(0,foldy);
          LineTo(Screen.Width,foldy);
          MoveTo(x,0);//�����µ�ʮ��
          LineTo(x,Screen.Height);
          MoveTo(0,y);
          LineTo(Screen.Width,y);
          foldx:=x;
          foldy:=y;
        end;
  end;
end;

procedure TCatchScreenShowForm.ChildImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Width,Height : Integer;
  NewBitmap : TBitmap;
  Clipboard: TClipboard;
begin
try
  if (Trace = False) then//TRACE��ʾ�Ƿ���׷�����
  begin//�״ε������������ʼ׷����ꡣ
    Flag := False;
    with ChildImage.canvas do
    begin
      MoveTo(foldx,0);
      LineTo(foldx,screen.height);
      MoveTo(0,foldy);
      LineTo(screen.width,foldy);
    end;
    x1 := x;
    y1 := y;
    oldx := x;
    oldy := y;
    Trace := True;
    ChildImage.Canvas.Pen.mode:=pmnot;//�ʵ�ģʽΪȡ��
    //��������ԭ����һ����Σ��൱�ڲ������Ρ�
    ChildImage.canvas.pen.color := clblack;//��Ϊ��ɫ
    ChildImage.canvas.brush.Style := bsclear;//�հ�ˢ��
  end
  else
  begin//�ڶ��ε������ʾ�Ѿ��õ������ˣ�����������FORM1�е�IMAGE�����ϡ�
    //{
    x2 := x;
    y2 := y;
    Trace := False;
    ChildImage.Canvas.Rectangle(x1,y1,oldx,oldy);
    Width := abs(x2-x1);
    Height := abs(y2-y1);
    FormMain.ShowImage.Width := Width;
    FormMain.ShowImage.Height := Height;

    NewBitmap:=Tbitmap.create;
    NewBitmap.Width := Width;
    NewBitmap.Height := Height;
    NewBitmap.Canvas.CopyRect
    (Rect(0,0,width,Height),CatchScreenShowForm.ChildImage.Canvas,
    Rect(x1,y1,x2,y2));//����
    FormMain.ShowImage.Picture.Bitmap := NewBitmap;//�ŵ�CatchScreenForm��ShowImage��
    try
    CatchScreenShowForm.Hide;
    //NewBitmap.Free;
    //CatchScreenForm.Show;
    //}
    //FormMain.Show;
    //finally
      if GetScreenSave then
      begin
        if SaveDialog1.Execute then
        begin
          if Trim(SaveDialog1.FileName) <> '' then
          begin
            if FileExists(SaveDialog1.FileName) then
            if MessageBox(Handle, PChar('�ļ�:<' + ExtractFileName(SaveDialog1.FileName) + '>�Ѿ�����,ȷ��Ҫ���Ǵ��ļ���?'),'ѯ��',MB_YESNO+MB_ICONINFORMATION)=ID_No then exit;
            if (ExtractFileExt(SaveDialog1.FileName) = '') then SaveDialog1.FileName := SaveDialog1.FileName + '.bmp';
            FormMain.ShowImage.Picture.SaveToFile(SaveDialog1.FileName);
            if (LowerCase(ExtractFileExt(SaveDialog1.FileName)) = '.jpg') then
            BMPToJPG(SaveDialog1.FileName);
          end;
        end;
          try
          finally
            Clipboard := TClipboard.Create;
            Clipboard.Assign(FormMain.ShowImage.Picture.Bitmap);
            Clipboard.Free;
          end;
      end
      else
      begin
        Clipboard := TClipboard.Create;
        Clipboard.Assign(FormMain.ShowImage.Picture.Bitmap);
        Clipboard.Free;
      end;
    finally
      NewBitmap.Free;
    end;
  end;
except end;
end;

procedure TCatchScreenShowForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

end.
