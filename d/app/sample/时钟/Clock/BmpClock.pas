      //===========================================================//
      //  BmpClock  v 1.0 ģ���ӱ����;                            //
      //  �����������ñ���ĳ���,���򳤶�,���λͼ����,            //
      //  ͸��λͼ,�������ô���ɫ����;ʹ��˫����������˸;          //
      //  ������ҳ: http://users,7host.com/sail2000                //
      //  E-MAIL :  sail2000@126.com                               //
      //  ******���������ο��� vxtime ����Ĵ��룬******         //
      //  ���ǣ�vxtime �ؼ���ʱ������㷨��ʵ��ʱ�ӵ��߷���Ƚϣ�  //
      //  ʱ����㷨�������Ǵ���ģ�6:30���ʱ����ǶԱ��ˡ�6:30   //
      //  ���ʱ��ķ����ʱ���Ƿֿ�����Ӧ����һ���Ƕȵġ�����     //
      //  �ص�Ľ���ʱ�ӵĵı�����㷨; ���������˶���������û�   //
      //  �Զ���Ĺ��ܣ�������Ҫ�����Զ��嶼�����û�,����ö���;   //
      //                                                           //
      //  ������ɡ�С�������ҡ�����Ȩ���У�����ȫ��Ȩ��           //
      //  *****�����Դ˴�����иĽ�,�벻Ҫ���Ǹ���Ҳ��һ��!***** //
      //  ** ������ҵ�����д�˸��õ�������벻��Ҳ����һ��Ŷ��**  //
      //                                                           //
      //===========================================================//

unit BmpClock;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ExtCtrls, Graphics;

type
  TBmpClock = class(TIMage)
  private
    { Private declarations }
    DrawPicture: Boolean;
    FHour, FMinute, FSecond, FMillisecond: word; //�� DecodeTime ����ȡ��ʱ��;
    FHourHandLength, FMinHandLength, FSecHandLength: integer; //�������ĳ���;
    FBHourHandLength, FBMinHandLength, FBSecHandLength: integer; //���巴�����ĳ���
    FHourHandWidth, FMinHandWidth, FSecHandWidth: integer; //�������Ĵ�ϸ ;
    FHourHandColor, FMinHandColor, FSecHandColor: TColor; //����������ɫ ;
    FAngleHour, FAngleMin, FAngleSec: Real; //������ת�ĽǶ� ;
    FXCenter, FYCenter: integer;        //ʱ�ӵ�����;

    FBgColor: TColor;           //������ɫ
    FBgPicture: TPicture;           //����λͼ;

    FSteptime: TTimer;                  //�¼���ʱ;

    procedure onTimer(Sender: TObject);         //�¼��������;
    procedure Paint; override;                   //�ػ�ʱ��;
    procedure SetBgPicture(const Value: TPicture);  //����λͼ����

  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property HourHandWidth: integer     //����Ŀ��
      read FHourHandWidth
      write FHourHandWidth default 2;

    property MinHandWidth: integer
      read FMinHandWidth
      write FMinHandWidth default 2;

    property SecHandWidth: integer
      read FSecHandWidth
      write FSecHandWidth default 1;

    property HourHandLength: integer   //����ĳ��ȣ�
      read FHourHandLength
      write FHourHandLength default 28;

    property MinHandLength: integer
      read FMinHandLength
      write FMinHandLength default 35;

    property SecHandLength: integer
      read FSecHandLength
      write FSecHandLength default 40;

    property BHourHandLength: integer   //����ķ��򳤶ȣ�
      read FBHourHandLength
      write FBHourHandLength default 8;

    property BMinHandLength: integer
      read FBMinHandLength
      write FBMinHandLength default 8;

    property BSecHandLength: integer
      read FBSecHandLength
      write FBSecHandLength default 11;

    property HourHandColor: TColor      //�������ɫ
      read FHourHandColor
      write FHourHandColor default clred;

    property MinHandColor: TColor
      read FMinHandColor
      write FMinHandColor default clgreen;

    property SecHandColor: TColor
      read FSecHandColor
      write FSecHandColor default clblack;

    property BgColor: TColor    //����ɫ
      read FBgColor
      write FBgColor;

    property BgPicture: TPicture    //����ͼ
      read FBgPicture
      write SetBgPicture;

  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TBmpClock]);
end;

{ TBmpClock }

constructor TBmpClock.Create(AOwner: TComponent); //�ڷ�����ʱ���¼�ʱ�ػ�����
begin
  inherited Create(AOwner);

  FHourHandWidth := 2;
  FMinHandWidth := 2;
  FSecHandWidth := 1;

  FHourHandLength := 28;
  FMinHandLength := 35;
  FSecHandLength := 40;

  FBHourHandLength := 8;
  FBMinHandLength := 8;
  FBSecHandLength := 11;

  FHourHandColor := clRed;
  FMinHandColor := clGreen;
  FSecHandColor := clBlue;

  FBgColor := clwhite;

  FSteptime := TTimer.Create(self);
  FSteptime.Enabled := true;
  FSteptime.Interval := 1000;
  FSteptime.OnTimer := onTimer;

  FBgPicture := TPicture.Create;

  DrawPicture := True;
end;

destructor TBmpClock.Destroy;
begin
  FSteptime.Free;
  FBgPicture.Free;
  inherited;
end;

procedure TBmpClock.Paint;
var
  Bitmap: TBitmap;
  bx, by :integer;
  //angle, anglem, angleh :real;
begin
  inherited;
  self.Parent.DoubleBuffered := True; //Parent ʹ��˫����,������˸;
  if DrawPicture then
  begin
    DrawPicture := false;

    Bitmap := TBitmap.Create;
    Bitmap.Width := Self.Width;
    Bitmap.Height := Self.Height;
    Bitmap.Canvas.Brush.Color := BgColor;
    Bitmap.Canvas.Pen.Color := BgColor;
    Bitmap.Canvas.Rectangle(0, 0, Bitmap.Width, Bitmap.Height);

    if FBgPicture.Height <> 0 then  //��ֹλͼΪ��ʱ���ִ���;
      Bitmap.Assign(FBgPicture.Graphic);

    with Bitmap  do
    begin
      {---------��������-----------}
      FXCenter := Width div 2;
      FYCenter := Height div 2;
      {---------ȡ��ʱ��,����,���� ����ת�Ƕ�--------}
      Decodetime(now, FHour, FMinute, FSecond, FMillisecond);

      FAngleHour := 2*pi*(FHour+FMinute/60)/12;
      FAngleMin := FMinute/60.0*2*Pi;
      FAngleSec := FSecond/60.0*2*Pi;


      {---------����ʱ��-----------}
      Canvas.Pen.Color := FHourHandColor;
      Canvas.Pen.Width := FHourHandWidth;
      by:=round(FYCenter-FHourHandLength*cos(FAngleHour));
      bx:=round(FXCenter+FHourHandLength*sin(FAngleHour));
      Canvas.MoveTo(FXCenter, FYCenter);
      Canvas.LineTo(bx,by);  //������ʱ��;
      by:=round(FYCenter+FBHourHandLength*cos(FAngleHour));
      bx:=round(FXCenter-FBHourHandLength*sin(FAngleHour));
      Canvas.MoveTo(FXCenter, FYCenter);
      Canvas.LineTo(bx,by);  //������ʱ��;

      {---------��������-----------}
      Canvas.Pen.Color := FMinHandColor;
      Canvas.Pen.Width := FMinHandWidth;
      by:=round(FYCenter-FMinHandLength*cos(FAngleMin));
      bx:=round(FXCenter+FMinHandLength*sin(FAngleMin));
      Canvas.MoveTo(FXCenter, FYCenter);
      Canvas.LineTo(bx,by);  //���������;
      by:=round(FYCenter+FBMinHandLength*cos(FAngleMin));
      bx:=round(FXCenter-FBMinHandLength*sin(FAngleMin));
      Canvas.MoveTo(FXCenter, FYCenter);
      Canvas.LineTo(bx,by);  //���������;

      {---------��������-----------}
      Canvas.Pen.Color := FSecHandColor;
      Canvas.Pen.Width := FSecHandWidth;
      by:=round(FYCenter-FSecHandLength*cos(FAngleSec));
      bx:=round(FXCenter+FSecHandLength*sin(FAngleSec));
      Canvas.MoveTo(FXCenter, FYCenter);
      Canvas.LineTo (bx,by);  //����������;
      by:=round(FYCenter+FBSecHandLength*cos(FAngleSec));
      bx:=round(FXCenter-FBSecHandLength*sin(FAngleSec));
      Canvas.MoveTo(FXCenter, FYCenter);
      Canvas.LineTo(bx,by); //����������;
    end;
      self.Picture.Bitmap := Bitmap;   //�����õ��ӱ�λͼ���� Image ��;
        Bitmap.Free;  //�ͷ��Դ�����λͼ,�ͷ���Դռ��;
  end;
end;

procedure TBmpClock.SetBgPicture(const Value: TPicture);
begin
  FBgPicture.Assign(Value); //����λͼ;
end;

procedure TBmpClock.onTimer(Sender: TObject);
begin
  DrawPicture := true;
  Paint;
end;


end.

 