{******************************************************************************}
{       ����Ԥ��                                                               }
{     ���� ������ Delphi����Ԥ����ѯ ��д��                                    }
{���µ�ַ��http://www.cnblogs.com/DxSoft/archive/2010/04/16/1713475.html       }
{          ��ȡ���е��Ǹ�http://www.ipseeker.cn/�е���                         }
{           �͸���http://www.ip138.com/ips8.asp                                }
{           С����sailxia���� gdi ��ͨ�����壬��ַ��                           }
{ http://topic.csdn.net/u/20100911/10/8f36bbc2-7bbd-423d-81c3-4f114a4d40f4.html}
{           ˵������ֻ�ǰ����������Ķ�����һ���ˣ�                             }
{           ʱ�����ޣ�ֻ����˹��ܣ������˭���ˣ�����������ˣ�               }
{           ���Ҵ�һ�ݣ�лл�ˣ��磡                                           }
{           û�а�Ȩ���㶮�� ��զ��զ�㣬��������Ϣ����Ҫ����                }
{       by luwei                                                               }
{       2011 06 23                                                             }
{******************************************************************************}

unit Weather;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GDIPUTIL, GDIPAPI, GDIPOBJ, {GDI+ ��Ҫ} bspngimage, {PNG ��Ҫ} ActiveX,
  Menus, ExtCtrls, IdComponent, msxml,
  bsPngImageList; {�ڴ�����Ҫ}

type
  TfrmWeather = class(TForm)
    ImgStorage: TbsPngImageStorage;
    tmrAotuClose: TTimer;
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tmrAotuCloseTimer(Sender: TObject);
  private
    WeatherLeft, WeatherTop: Integer;
    CityID: string;
    CityStr: string;
    DateStr: string; //������Ϣ
    WeatherStr: string; //����
    Temperature: string; //�¶�
    WindPower: string; //����
    WeatherIco: Integer; //����ͼ��
    HttpReq: IXMLHttpRequest;
    { Private declarations }
    procedure DrawBkgroud; { �ϳ�ͼƬ�Ĺ��� }
    {�������̣�RenderForm(͸���ȣ����屳��ͼ)}
    procedure RenderForm(TransparentValue: Byte; SourceImage: TGPBitmap);
    function ReadWeather(ACityID: string): Boolean;
  public
    { Public declarations }
  end;

type
  TFixedStreamAdapter = class(TStreamAdapter)
  public
    function Stat(out statstg: TStatStg; grfStatFlag: Longint): HResult; override; stdcall;
  end;

var
  frmWeather: TfrmWeather;
function ShowFrmWeatherModal(ACityID: string; AWeatherLeft: Integer = 0; AWeatherTop: Integer = 0): Boolean;
function ShowFrmWeather(ACityID: string; AWeatherLeft: Integer = 0; AWeatherTop: Integer = 0): Boolean;

implementation

uses uLkJSON;

{$R *.dfm}

function ShowFrmWeather(ACityID: string; AWeatherLeft: Integer = 0; AWeatherTop: Integer = 0): Boolean;
begin
  Result := False;
  frmWeather := TfrmWeather.Create(nil);
  try
    frmWeather.CityID := ACityID;
    frmWeather.WeatherLeft := AWeatherLeft;
    frmWeather.WeatherTop := AWeatherTop;
    frmWeather.FormStyle := fsStayOnTop;
    frmWeather.tmrAotuClose.Enabled := True;
    frmWeather.Show;
    Result := True;
  except
  end;
end;

function ShowFrmWeatherModal(ACityID: string; AWeatherLeft: Integer = 0; AWeatherTop: Integer = 0): Boolean;
begin
  Result := False;
  frmWeather := TfrmWeather.Create(nil);
  try
    frmWeather.CityID := ACityID;
    frmWeather.WeatherLeft := AWeatherLeft;
    frmWeather.WeatherTop := AWeatherTop;
    if frmWeather.ShowModal = mrok then
      Result := True;
  finally
    FreeAndNil(frmWeather);
  end;
end;

function TFixedStreamAdapter.Stat(out statstg: TStatStg;
  grfStatFlag: Integer): HResult;
begin
  Result := inherited Stat(statstg, grfStatFlag);
  statstg.pwcsName := nil;
end;

procedure TfrmWeather.DrawBkgroud;
var
  Bg: TGPBitmap;
  G: TGPGraphics;
  Guid: TGUID;
  WD: TGPBitmap;
  Cav: TGPBitmap;
  Png: TbsPngImage;
  MS: TMemoryStream;
  FontFamily: TGPFontFamily;
  LFont, SFont: TGPFont; { ���� }
  LPointF, SPointF: TGPPointF;
  LSolidBrush, SSolidBrush: TGPSolidBrush;
begin

  Png := TbsPngImage.CreateBlank(COLOR_RGBALPHA, 16, 359, 272); { ����ָ����С 359 * 272 �հ׵�png }
  {��ͬѧ���� �Ǹ� 359��272 ����ô�õ����أ�����ݱ���ͼƬ��С�Լ�д�ġ����� }
  //Png.SaveToFile('png_out.png'); { ���Ա��棬�����һ���� Alpha ͨ���Ŀհ� PNG }

  MS := TMemoryStream.Create;
  Png.SaveToStream(MS); { ���浽�ڴ��������� }
  Png.Free;

  ImgStorage.PngImages[24].PngImage.SaveToFile('bg.png'); //����ͼƬ
  ImgStorage.PngImages[WeatherIco].PngImage.SaveToFile('WeatherIco.png'); //����ͼƬ

  Bg := TGPBitmap.Create('bg.png'); { ���뱳��ͼƬ }
  WD := TGPBitmap.Create('WeatherIco.png'); { ��������״��ͼƬ }

  Cav := TGPBitmap.Create(TFixedStreamAdapter.Create(MS)); { ���ڴ����������屳��ͼ }
  MS.Free;

  G := TGPGraphics.Create(Cav); { ��ʼ�ϳ� }

  FontFamily := TGPFontFamily.Create('Tahoma');
  LFont := TGPFont.Create('Tahoma', 20, FontStyleBold, UnitPixel); { ������ }
  SFont := TGPFont.Create('΢���ź�', 15, FontStyleBold, UnitPixel); { С���� }

  LSolidBrush := TGPSolidBrush.Create(MakeColor(26, 161, 245)); { ������ɫ }
  SSolidBrush := TGPSolidBrush.Create(MakeColor(240, 240, 240));
  G.DrawImage(Bg, -3, -3);
  G.DrawImage(WD, 0, 0);

  LPointF := MakePoint(80.0, 18.0); { λ�� }
  G.DrawString(CityStr, -1, LFont, LPointF, LSolidBrush); //����

  LFont := TGPFont.Create('Tahoma', 12, FontStyleBold, UnitPixel); { ������ }
  LPointF := MakePoint(60.0, 45.0); { λ�� }
  G.DrawString(DateStr, -1, LFont, LPointF, LSolidBrush); //������Ϣ

  SPointF := MakePoint(50.0, 75.0);
  G.DrawString(WeatherStr, -1, SFont, SPointF, SSolidBrush); //����

  SPointF := MakePoint(50.0, 100.0);
  G.DrawString(Temperature, -1, SFont, SPointF, SSolidBrush); //�¶�

  SPointF := MakePoint(50.0, 125.0);
  G.DrawString(WindPower, -1, SFont, SPointF, SSolidBrush); //����

  { ���Դ�Ϊ png ... }
  //GetEncoderClsid('image/png', Guid);
  //Cav.Save('out.png', Guid); { �����ϳɽ���� }

  RenderForm(220, Cav); { ����������Ϊ���������ɡ�����}

  Cav.Free;
  WD.Free;
  G.Free;
  Bg.Free;
end;

procedure TfrmWeather.RenderForm(TransparentValue: Byte; SourceImage: TGPBitmap);
var
  zsize: TSize;
  zpoint: TPoint;
  zbf: TBlendFunction;
  TopLeft: TPoint;
  WR: TRect;
  GPGraph: TGPGraphics;
  m_hdcMemory: HDC;
  hdcScreen: HDC;
  hBMP: HBITMAP;
  FDC: HDC;
begin
  hdcScreen := GetDC(0);
  m_hdcMemory := CreateCompatibleDC(hdcScreen);
  hBMP := CreateCompatibleBitmap(hdcScreen, SourceImage.GetWidth(),
    SourceImage.GetHeight());
  SelectObject(m_hdcMemory, hBMP);
  GPGraph := TGPGraphics.Create(m_hdcMemory);
  try
    { GPGraph.SetInterpolationMode(InterpolationModeHighQualityBicubic); }
    GPGraph.DrawImage(SourceImage, 0, 0, SourceImage.GetWidth(),
      SourceImage.GetHeight());
    SetWindowLong(Handle, GWL_EXSTYLE,
      GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_LAYERED); { ��������� }
    zsize.cx := SourceImage.GetWidth;
    zsize.cy := SourceImage.GetHeight;
    zpoint := Point(0, 0);
    with zbf do
    begin
      BlendOp := AC_SRC_OVER;
      BlendFlags := 0;
      AlphaFormat := AC_SRC_ALPHA;
      SourceConstantAlpha := TransparentValue;
    end;
    GetWindowRect(Handle, WR);
    TopLeft := WR.TopLeft;
    { UpdateLayeredWindow(Handle, FDC, @TopLeft, @zsize, GPGraph.GetHDC, @zpoint,
     0, @zbf, ULW_ALPHA); WIN7 ������ԣ�WINXPSP3 �Ͳ��С��������Ը�Ϊ����:}
    UpdateLayeredWindow(Handle, 0, nil, @zsize, GPGraph.GetHDC, @zpoint, 0,
      @zbf, ULW_ALPHA);
  finally
    GPGraph.ReleaseHDC(m_hdcMemory);
    ReleaseDC(0, hdcScreen);
    DeleteObject(hBMP);
    DeleteDC(m_hdcMemory);
    GPGraph.Free;
  end;
end;

procedure TfrmWeather.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  Perform(WM_SYSCOMMAND, $F012, 0);
end;

procedure TfrmWeather.FormDblClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmWeather.FormShow(Sender: TObject);
begin
  if (WeatherLeft = 0) and (WeatherTop = 0) then
  begin
    Self.Left := Screen.Width - 252;
    self.Top := Screen.Height - 215;
  end
  else
  begin
    Self.Left := WeatherLeft;
    self.Top := WeatherTop;
  end;
  if ReadWeather(CityID) then
    DrawBkgroud
  else
    self.Close;
end;

function TfrmWeather.ReadWeather(ACityID: string): Boolean;
const
  URL = 'http://m.weather.com.cn/data/%s.html';
var
  Json: TlkJSONobject;
  ChildJson, tmpJson: TlkJSONbase;
  ReWeather: string;
  IcoStr: string;
begin
  Result := False;
  HttpReq.open('Get', Format(URL, [CityID]), False, EmptyParam, EmptyParam);
  HttpReq.send(EmptyParam); //��ʼ����
  ReWeather := HttpReq.responseText;
  Json := Tlkjson.ParseText(ReWeather) as TlkJSONobject;
  ChildJson := Json.Field['weatherinfo'];
  if ChildJson.SelfType = jsObject then
  begin
    CityStr := VarToStr(ChildJson.Field['city'].Value);
    DateStr := Vartostr(ChildJson.Field['date_y'].Value) +
      ' ' + Vartostr(ChildJson.Field['week'].Value);
    IcoStr := Vartostr(ChildJson.Field['weather1'].Value);
    WeatherStr := '������' + IcoStr;
    Temperature := '�¶ȣ�' + Vartostr(ChildJson.Field['temp1'].Value);
    WindPower := '������' + Vartostr(ChildJson.Field['wind1'].Value);
    //��������
    if pos('����', IcoStr) > 0 then
      WeatherIco := 0;
    if pos('��', IcoStr) > 0 then
      WeatherIco := 1;
    if pos('��', IcoStr) > 0 then
      WeatherIco := 2;
    if pos('��', IcoStr) > 0 then
      WeatherIco := 3;
    //ɳ��
    if pos('ǿɳ����', IcoStr) > 0 then
      WeatherIco := 4
    else if pos('ɳ����', IcoStr) > 0 then
      WeatherIco := 5
    else if pos('��ɳ', IcoStr) > 0 then
      WeatherIco := 6
    else if pos('����', IcoStr) > 0 then
      WeatherIco := 7;
    //��ѩ
    if pos('��ѩ', IcoStr) > 0 then
      WeatherIco := 8
    else if pos('���ѩ', IcoStr) > 0 then
      WeatherIco := 9
    else if pos('��ѩ', IcoStr) > 0 then
      WeatherIco := 10
    else if pos('��ѩ', IcoStr) > 0 then
      WeatherIco := 11
    else if pos('��ѩ', IcoStr) > 0 then
      WeatherIco := 12
    else if pos('Сѩ', IcoStr) > 0 then
      WeatherIco := 13;
    //����
    if pos('����', IcoStr) > 0 then
      WeatherIco := 14
    else if pos('���ѩ', IcoStr) > 0 then
      WeatherIco := 9
    else if pos('��������б���', IcoStr) > 0 then
      WeatherIco := 15
    else if pos('������', IcoStr) > 0 then
      WeatherIco := 16
    else if pos('����', IcoStr) > 0 then
      WeatherIco := 17
    else if pos('�ش���', IcoStr) > 0 then
      WeatherIco := 18
    else if pos('����', IcoStr) > 0 then
      WeatherIco := 19
    else if pos('����', IcoStr) > 0 then
      WeatherIco := 20
    else if pos('����', IcoStr) > 0 then
      WeatherIco := 21
    else if pos('����', IcoStr) > 0 then
      WeatherIco := 22
    else if pos('С��', IcoStr) > 0 then
      WeatherIco := 23;
    //WeatherIco := StringReplace(Vartostr(ChildJson.Field['weather1'].Value), 'ת�е�', '-', [rfReplaceAll]) + '.png'; //����ͼ��
    Result := True;
  end;
  if WeatherIco = -1 then
    WeatherIco := 3; //����ͼ��
end;

procedure TfrmWeather.FormCreate(Sender: TObject);
begin
  HttpReq := CoXMLHTTPRequest.Create;
  WeatherIco := -1;
end;

procedure TfrmWeather.tmrAotuCloseTimer(Sender: TObject);
begin
  Self.Close;
end;

end.

