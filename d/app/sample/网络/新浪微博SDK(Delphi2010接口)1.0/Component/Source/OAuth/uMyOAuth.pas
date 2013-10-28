unit uMyOAuth;

interface

uses
  Windows,SysUtils,Classes,StrUtils,DateUtils,Dialogs,Forms,
  OleCtrls, MSHTML, ComObj, ActiveX,SHDocVw, ComCtrls,
  IdHMACSHA1,
  IdCoderMIME,
  IdHashMessageDigest,
  IdGlobal,
  IdHash,
  uSinaWeiboParam,
  IdBaseComponent,
  IdComponent,
  IdTCPConnection,
  IdTCPClient,
  IdHttp  ;


type
  //ǩ���㷨����
  TSignatureType=(stHMACSHA1);

const
  //ǩ���㷨��������
  ConstSignatureTypeName:array [TSignatureType] of String
              =('HMAC-SHA1');

type
  //OAuth��֤
  TCustomMyOAuth=class
  private
    FIsAuthorizeing:Boolean;
    FIsAuthorizeSucc:Boolean;
    FHTTP:TIDHttp;
    //OAuth�İ汾,1.0,1.0a,2.0
    FOAuthVersion: String;
    //OAuth������ǰ׺����Ϊoauth_
    FOAuthParameterPrefix: String;
    ///////////////////�����ǲ���������//////////////////
    //ǩ�����õ��㷨
    FOAuthSignatureMethodKey: String;
    //ʱ���MD5�Ĳ�����
    FOAuthNonceKey: String;
    //�汾�ŵĲ�����
    FOAuthVersionKey: String;
    //����˽Կ�Ĳ�����
    FOAuthTokenSecretKey: String;
    //�û�˽Կ�Ĳ�����
    FOAuthConsumerKeyKey: String;
    //ʱ����Ĳ�����
    FOAuthTimestampKey: String;
    //���ƵĲ�����
    FOAuthTokenKey: String;
    //ǩ���Ĳ�����
    FOAuthSignatureKey: String;
    //��֤��Ĳ�����
    FOAuthVerifierKey: String;
    //�ص���ַ�Ĳ�����
    FOAuthCallbackKey: String;
    ///////////////////////////////////////////
    //Ӧ�õ�App Secret
    FAppSecret: String;
    //Ӧ�õ�App Key
    FAppKey: String;
    //���������ص�����˽Կ
    FTokenSecret: String;
    //���������ص�����
    FToken: String;
    //���������ص���֤��
    FOAuthVerifier: String;
    FOAuthUserID: String;
    FOAuthRequestTokenURL: String;
    FOAuthPassword: String;
    FOAuthUserName: String;
    FOAuthAuthorizeURL: String;
    FOAuthRequestTokenBaseString: String;
    FOAuthAuthorizeBaseString: String;
    FOAuthAuthorizeCallBackURL: String;
    FOAuthOAuthRequestTokenURL: String;
    FOAuthAccessTokenBaseString: String;
    FOAuthAccessTokenURL: String;
    property OAuthVersion:String read FOAuthVersion write FOAuthVersion;
    property OAuthParameterPrefix:String read FOAuthParameterPrefix write FOAuthParameterPrefix;
    ///////////////////�����ǲ���������//////////////////
    property OAuthConsumerKeyKey:String read FOAuthConsumerKeyKey write FOAuthConsumerKeyKey;
    property OAuthCallbackKey:String read FOAuthCallbackKey write FOAuthCallbackKey;
    property OAuthVersionKey:String read FOAuthVersionKey write FOAuthVersionKey;
    property OAuthSignatureMethodKey:String read FOAuthSignatureMethodKey write FOAuthSignatureMethodKey;
    property OAuthSignatureKey:String read FOAuthSignatureKey write FOAuthSignatureKey;
    property OAuthTimestampKey:String read FOAuthTimestampKey write FOAuthTimestampKey;
    property OAuthNonceKey:String read FOAuthNonceKey write FOAuthNonceKey;
    property OAuthTokenKey:String read FOAuthTokenKey write FOAuthTokenKey;
    property OAuthVerifierKey:String read FOAuthVerifierKey write FOAuthVerifierKey;
    property OAuthTokenSecretKey:String read FOAuthTokenSecretKey write FOAuthTokenSecretKey;
    procedure OnEWBAuthorizeDocumentComplete(ASender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    //����ǩ����ʹ�õĻ���
    function GenerateSignatureBaseString(
          const AScheme:String;                 //Э�飬      exp.  http or https
          const AHost:String;                   //������ַ    exp.  weibo.com
          const APort:String;                   //�˿�        exp.  80
          const APath:String;
          const AQuery:String;                  //QueryString
          const AConsumerKey:String;            //�û���˽Կ
          const AToken:String;                  //����
          const ATokenSecret:String;            //���Ƶ�˽Կ
          const AHttpMethod:String;             //HTTP������  exp.  GET or POST
          const ATimeStamp:String;              //ʱ���
          const ANonce:String;                  //�����
          const ASignatureTypeStr:String;       //ǩ������
          var ANormalizedUrl:String;
          var ANormalizedRequestParameters:String
          ):String;overload;
    //����ǩ��
    function GenerateSignature(
          const AScheme:String;
          const AHost:String;
          const APort:String;
          const APath:String;
          const AQuery:String;
          const AConsumerKey:String;
          const AConsumerSecret:String;
          const AToken:String;
          const ATokenSecret:String;
          const AHttpMethod:String;
          const ATimeStamp:String;
          const ANonce:String;
          const ASignatureType:TSignatureType;
          var ANormalizedUrl:String;
          var ANormalizedRequestParameters:String
          ):String;overload;
    //����ǩ��
    function GenerateSignature(
          const AScheme:String;
          const AHost:String;
          const APort:String;
          const APath:String;
          const AQuery:String;
          const AMethod:String;
          var ANormalizedUrl:String;
          var ANormalizedRequestParameters:String):String;overload;
    //��ǩ����ӵ���������
    function AppendSignatureString(
          const AScheme:String;
          const AHost:String;
          const APort:String;
          const APath:String;
          const AQuery:String;
          const AMethod:String
          ):String;overload;
  protected
    //����ʱ���
    function GenerateTimeStamp:String;
    //�ٶȰٿ�,�����(Nonce)������Ļ���ظ���ֵ��
    //�������ھ���һ��Э������ݽ����У�
    //ͨ��Ϊ��֤��Ծ�ȵ�Ŀ�ĺ����̽��ͱ����������ظ�������
    function GenerateNonce:String;
    //���ַ��������������б�
    procedure GetQueryParameters(const AParametersString:String;var AParameters: TQueryParameters);
    //���ɲ����ַ���
    function NormalizeRequestParameters(const AParameters: TQueryParameters):String;

    function GenerateSignatureBaseString(
          const AUrl:String;
          const AQuery:String;                  //QueryString
          const AConsumerKey:String;            //�û���˽Կ
          const AToken:String;                  //����
          const ATokenSecret:String;            //���Ƶ�˽Կ
          const AHttpMethod:String;             //HTTP������  exp.  GET or POST
          const ATimeStamp:String;              //ʱ���
          const ANonce:String;                  //�����
          const ASignatureTypeStr:String;       //ǩ������
          var ANormalizedRequestParameters:String
          ):String;overload;

    function GenerateSignature(
          const AUrl:String;
          const AQuery:String;
          const AConsumerKey:String;
          const AConsumerSecret:String;
          const AToken:String;
          const ATokenSecret:String;
          const AHttpMethod:String;
          const ATimeStamp:String;
          const ANonce:String;
          const ASignatureType:TSignatureType;
          var ANormalizedRequestParameters:String
          ):String;overload;

    function GenerateSignature(
          const AUrl:String;
          const AQuery:String;
          const AMethod:String;
          var ANormalizedRequestParameters:String):String;overload;
  public
    constructor Create(AAppKey:String;AAppSecret:String);
    destructor Destroy;override;
  public

    function AppendSignatureString(
          const AUrl:String;
          const AQuery:String;
          const AMethod:String
          ):String;overload;
  public
    property AppKey:String read FAppKey write FAppKey;
    property AppSecret:String read FAppSecret write FAppSecret;
    property Token:String read FToken write FToken;
    property TokenSecret:String read FTokenSecret write FTokenSecret;
    property OAuthVerifier:String read FOAuthVerifier write FOAuthVerifier;
    property OAuthUserID:String read FOAuthUserID write FOAuthUserID;
    //��֤���û���������
    property OAuthUserName:String read FOAuthUserName write FOAuthUserName;
    property OAuthPassword:String read FOAuthPassword write FOAuthPassword;
    //�����ַ
    property OAuthOAuthRequestTokenURL:String read FOAuthOAuthRequestTokenURL write FOAuthOAuthRequestTokenURL;
    property OAuthRequestTokenBaseString:String read FOAuthRequestTokenBaseString write FOAuthRequestTokenBaseString;
    //��֤��ַ
    property OAuthAuthorizeURL:String read FOAuthAuthorizeURL write FOAuthAuthorizeURL;
    property OAuthAuthorizeBaseString:String read FOAuthAuthorizeBaseString write FOAuthAuthorizeBaseString;
    property OAuthAuthorizeCallBackURL:String read FOAuthAuthorizeCallBackURL write FOAuthAuthorizeCallBackURL;
    //��Ȩ��ַ
    property OAuthAccessTokenURL:String read FOAuthAccessTokenURL write FOAuthAccessTokenURL;
    property OAuthAccessTokenBaseString:String read FOAuthAccessTokenBaseString write FOAuthAccessTokenBaseString;
  public
    //��ȡδ��Ȩ�� Request Token
    function RequestToken(AOAuthOAuthRequestTokenURL:String):Boolean;
    //��֤
    function Authorize(EWBAuthorize:TWebBrowser;
                       AOAuthAuthorizeURL:String;
                       AOAuthAuthorizeCallBackURL:String;
                       AOAuthUserName:String;
                       AOAuthPassword:String
                        ):Boolean;
    //��ȡ��Ȩ��Token
    function RequestAccessToken(AOAuthAccessTokenURL:String):Boolean;
  end;

  TMyOAuth=class(TCustomMyOAuth)
  end;

const
  UnixStartDate : TDateTime = 25569;


implementation

//Base64����
function Base64Encode(const Input: TBytes): string;
begin
  Result := TIdEncoderMIME.EncodeBytes(Input);
end;
//HMACSha1�㷨
function EncryptHMACSha1(Input,AKey:AnsiString): TBytes;
var
  Key:TBytes;
begin
  with TIdHMACSHA1.Create do
  try
    Key := TBytes(AKey);
    Result := HashValue(TBytes(Input));
  finally
    Free;
  end;
end;


function DateTimeToUnix(ConvDate: TDateTime): Longint;
var
  x: double;
  lTimeZone: TTimeZoneInformation;
begin
  GetTimeZoneInformation(lTimeZone);
  ConvDate := ConvDate + (lTimeZone.Bias / 1440);
  x := (ConvDate - UnixStartDate) * 86400;
  Result := Trunc(x);
end;

function _IntToHex(Value: Integer; Digits: Integer): String;
begin
  Result := SysUtils.IntToHex(Value, Digits);
end;

function XDigit(Ch : Char) : Integer;
begin
  if (Ch >= '0') and (Ch <= '9') then
      Result := Ord(Ch) - Ord('0')
  else
      Result := (Ord(Ch) and 15) + 9;
end;


function IsXDigit(Ch : Char) : Boolean;
begin
  Result := ((Ch >= '0') and (Ch <= '9')) or
            ((Ch >= 'a') and (Ch <= 'f')) or
            ((Ch >= 'A') and (Ch <= 'F'));
end;

//function htoin(Value : PChar; Len : Integer) : Integer;
//var
//  I : Integer;
//begin
//  Result := 0;
//  I      := 0;
//  while (I < Len) and (Value[I] = ' ') do
//      I := I + 1;
//  while (I < len) and (IsXDigit(Value[I])) do begin
//      Result := Result * 16 + XDigit(Value[I]);
//      I := I + 1;
//  end;
//end;

//function htoi2(Value : PChar) : Integer;
//begin
//  Result := htoin(Value, 2);
//end;

//function FucnUrlEncode(const S : AnsiString) : String;
//var
//  I : Integer;
//  Ch : AnsiChar;
//begin
//  Result := '';
//  for I := 1 to Length(S) do begin
//      Ch := S[I];
//      if ((Ch >= '0') and (Ch <= '9')) or
//         ((Ch >= 'a') and (Ch <= 'z')) or
//         ((Ch >= 'A') and (Ch <= 'Z')) or
//         (Ch = '.') or (Ch = '-') or (Ch = '_') or (Ch = '~')then
//          Result := Result + Ch
//      else
//          Result := Result + '%' + _IntToHex(Ord(Ch), 2);
//  end;
//end;
//
//function UrlDecode(const Url : String) : String;
//var
//  I, J, K, L : Integer;
//begin
//  Result := Url;
//  L      := Length(Result);
//  I      := 1;
//  K      := 1;
//  while TRUE do begin
//      J := I;
//      while (J <= Length(Result)) and (Result[J] <> '%') do begin
//          if J <> K then
//              Result[K] := Result[J];
//          Inc(J);
//          Inc(K);
//      end;
//      if J > Length(Result) then
//          break;                   { End of string }
//      if J > (Length(Result) - 2) then begin
//          while J <= Length(Result) do begin
//              Result[K] := Result[J];
//              Inc(J);
//              Inc(K);
//          end;
//          break;
//      end;
//      Result[K] := Char(htoi2(@Result[J + 1]));
//      Inc(K);
//      I := J + 3;
//      Dec(L, 2);
//  end;
//  SetLength(Result, L);
//end;

{ TCustomMyOAuth }


function TCustomMyOAuth.AppendSignatureString(const AScheme, AHost, APort, APath, AQuery,
  AMethod: String): String;
var
  Signature:String;
  ANormalizedUrl,ANormalizedRequestParameters: String;
begin
  Signature:=Self.GenerateSignature(AScheme, AHost, APort, APath, AQuery,AMethod,ANormalizedUrl,ANormalizedRequestParameters);
  ANormalizedRequestParameters:=ANormalizedRequestParameters+'&oauth_signature=' + URLEncode(signature);
  Result:=ANormalizedRequestParameters;
end;

function TCustomMyOAuth.AppendSignatureString(const AUrl, AQuery, AMethod: String): String;
var
  Signature:String;
  ANormalizedRequestParameters:String;
begin
  Signature:=Self.GenerateSignature(AUrl, AQuery,AMethod,ANormalizedRequestParameters);
  ANormalizedRequestParameters:=ANormalizedRequestParameters+'&oauth_signature=' + URLEncode(signature);
  Result:=ANormalizedRequestParameters;
end;

function TCustomMyOAuth.Authorize(EWBAuthorize:TWebBrowser;
                    AOAuthAuthorizeURL:String;
                    AOAuthAuthorizeCallBackURL:String;
                    AOAuthUserName:String;
                    AOAuthPassword:String
                    ):Boolean;
var
  BeginTime:DWORD;
begin
  Result:=False;
  FIsAuthorizeing:=True;
  FIsAuthorizeSucc:=False;
  Self.FOAuthUserName:=AOAuthUserName;
  Self.FOAuthPassword:=AOAuthPassword;
  FOAuthAuthorizeURL :=AOAuthAuthorizeURL;// 'http://api.t.sina.com.cn/oauth/authorize';
  FOAuthAuthorizeCallBackURL := AOAuthAuthorizeCallBackURL;//'oob';
  FOAuthAuthorizeBaseString := FOAuthAuthorizeURL + '?' + 'oauth_token=' + Self.Token + '&' +
            'oauth_token_secret=' + Self.TokenSecret +
            '&oauth_callback=' + UrlEncode(FOAuthAuthorizeCallBackURL);
  EWBAuthorize.OnDocumentComplete:=Self.OnEWBAuthorizeDocumentComplete;
  EWBAuthorize.Navigate(FOAuthAuthorizeBaseString);


  BeginTime:=GetTickCount;
  //��ʱ��ʮ��
  while FIsAuthorizeing And (GetTickCount-BeginTime<=20000) do
  begin
    Application.ProcessMessages;
  end;
  if Not FIsAuthorizeing then
  begin
    Result:=FIsAuthorizeSucc;
  end;
end;

constructor TCustomMyOAuth.Create(AAppKey:String;AAppSecret:String);
begin

  Self.FAppSecret:=AAppSecret;
  Self.FAppKey:=AAppKey;

  FHTTP:=TIDHttp.Create(nil);
  FHTTP.ConnectTimeout:=20000;

  FOAuthVersion:='1.0';
  FOAuthParameterPrefix:='oauth_';
  FOAuthConsumerKeyKey:='oauth_consumer_key';
  FOAuthCallbackKey:='oauth_callback';
  FOAuthVersionKey:='oauth_version';
  FOAuthSignatureMethodKey:='oauth_signature_method';
  FOAuthSignatureKey:='oauth_signature';
  FOAuthTimestampKey:='oauth_timestamp';
  FOAuthNonceKey:='oauth_nonce';
  FOAuthTokenKey:='oauth_token';
  FoAuthVerifierKey:='oauth_verifier';
  FOAuthTokenSecretKey:='oauth_token_secret';
end;

destructor TCustomMyOAuth.Destroy;
begin
  FreeAndNil(FHTTP);
  inherited;
end;


procedure TCustomMyOAuth.OnEWBAuthorizeDocumentComplete(ASender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
var
  HTML: String;
  Doc: IHTMLDocument2;
  VerifyCodeStartPos,
  VerifyCodeEndPos:Integer;
  EWBAuthorize:TWebBrowser;
begin
  EWBAuthorize:=TWebBrowser(ASender);
  if SameText(Self.FOAuthAuthorizeBaseString,URL) then
  begin
    //�����û���������
    EWBAuthorize.OleObject.document.GetElementById('userId').InnerText :=
      Self.FOAuthUserName;
    EWBAuthorize.OleObject.document.GetElementById('passwd').InnerText :=
      Self.FOAuthPassword;
    // �ύ
    EWBAuthorize.OleObject.document.GetElementById('sub').click;
  end;

  //if Pos('&oauth_verifier=', URL) > 0 then
  //OOB��ʽ��֤,��ȡ��֤��
  if SameText(Self.FOAuthAuthorizeURL,URL) then
  begin
    Doc := EWBAuthorize.Document as IHTMLDocument2;
    if (Doc <> nil) and (Doc.body <> nil) then
    begin
      //<span class="fb">178404</span>
      HTML:=LowerCase(Doc.body.innerHTML);
      VerifyCodeStartPos:=Pos('<span',HTML);
      if VerifyCodeStartPos>0 then
      begin
        VerifyCodeStartPos:=PosEx('>',HTML,VerifyCodeStartPos+Length('<span'));
        if VerifyCodeStartPos>0 then
        begin
          VerifyCodeStartPos:=VerifyCodeStartPos+1;
          VerifyCodeEndPos:=PosEx('</span>',HTML,VerifyCodeStartPos+1);
          if VerifyCodeEndPos>0 then
          begin
            Self.OAuthVerifier:=Copy(HTML,
                                        VerifyCodeStartPos,
                                        VerifyCodeEndPos-VerifyCodeStartPos);
            FIsAuthorizeSucc:=True;
          end;
        end;
      end;
      Self.FIsAuthorizeing:=False;
    end;

    //    Response := Copy(URL, Pos('?', URL) + 1, Length(URL) - Pos('?', URL));
    //    Client.API.OAuth.Token := Copy(Response, Pos('oauth_token=',
    //        Response) + Length('oauth_token='),
    //      Length(Response) - Pos('oauth_token=',
    //        Response) - (Length(Response) - Pos('&oauth_verifier=', Response) + 1)
    //        - Length('oauth_token=') + 1);
    //    Self.OAuthVerifier := Copy(URL,
    //            Pos('oauth_verifier=', URL) + Length('oauth_verifier='),
    //            Length(URL) - Pos('oauth_verifier=', URL) - Length('oauth_verifier=')
    //              + 1);
  end;

end;

function TCustomMyOAuth.GenerateNonce: String;
var
  md5:TIdHashMessageDigest;
//var
//  RandomNum:Integer;
begin
  //Result:='F625A3B4B63BD016BAD5D06D7472534C';
  //Exit;  // Just a simple implementation of a random number between 123400 and 9999999
  //return random.Next(123400, 9999999).ToString();
//  Randomize;
//  RandomNum:=123400+Random(9999999-123400);
//  Result:=IntToStr(RandomNum);
  md5:=TIdHashMessageDigest5.Create;
  Result:=md5.HashStringAsHex(GenerateTimeStamp);
  md5.Free;
end;

function TCustomMyOAuth.GenerateSignature(const AScheme, AHost, APort, APath, AQuery,
  AConsumerKey, AConsumerSecret, AToken, ATokenSecret, AHttpMethod, ATimeStamp,
  ANonce: String; const ASignatureType: TSignatureType; var ANormalizedUrl,
  ANormalizedRequestParameters: String): String;
var
  SinatureBase:String;
  KeyStr:AnsiString;
begin
  case ASignatureType of
    stHMACSHA1:
    begin
      //ǩ������
      SinatureBase:=Self.GenerateSignatureBaseString(AScheme, AHost, APort, APath, AQuery,
                    AConsumerKey, AToken, ATokenSecret, AHttpMethod, ATimeStamp,
                    ANonce,ConstSignatureTypeName[ASignatureType],
                    ANormalizedUrl,ANormalizedRequestParameters);
      //ǩ���㷨��ʹ�õļ���
      if ATokenSecret<>'' then
      begin
        KeyStr:=UrlEncode(AConsumerSecret)+'&'+UrlEncode(ATokenSecret);
      end
      else
      begin
        KeyStr:=UrlEncode(AConsumerSecret)+'&';
      end;
      //Base64����
      Result:=Base64Encode(EncryptHMACSha1(SinatureBase,KeyStr));
    end;
  end;
end;

function TCustomMyOAuth.GenerateSignatureBaseString(const AScheme,AHost,APort, APath, AQuery, AConsumerKey,
  AToken,ATokenSecret, AHttpMethod, ATimeStamp, ANonce, ASignatureTypeStr: String;
  var ANormalizedUrl, ANormalizedRequestParameters: String): String;
var
  Params:TQueryParameters;
begin
  ANormalizedUrl:='';
  ANormalizedRequestParameters:='';
  //���������б�
  Params:=TQueryParameters.Create;
  Try
    //��Ӳ���
    GetQueryParameters(AQuery,Params);
    Params.AddQueryParameter(Self.FOAuthVersionKey,FOAuthVersion);
    Params.AddQueryParameter(Self.FOAuthNonceKey,ANonce);
    Params.AddQueryParameter(Self.FOAuthTimestampKey,ATimeStamp);
    Params.AddQueryParameter(Self.FOAuthSignatureMethodKey,ASignatureTypeStr);
    Params.AddQueryParameter(Self.FOAuthConsumerKeyKey,AConsumerKey);
    if (AToken<>'') then
    begin
      Params.AddQueryParameter(Self.FOAuthTokenKey,AToken);
    end;
    if (ATokenSecret<>'') then
    begin
      Params.AddQueryParameter(Self.FOAuthTokenSecretKey,ATokenSecret);
    end;
    if (Self.FOAuthVerifier<>'') and (AHttpMethod='GET') then
    begin
      Params.AddQueryParameter(Self.FOAuthVerifierKey,Self.FOAuthVerifier);
    end;
    //���ղ������ƣ�����ֵ��������
    Params.Sort;
    //��ϳ�URL
    ANormalizedUrl:=AScheme+'://'+AHost;
    if Not (((AScheme='http') and (APort='80'))
          or ((AScheme='https') and (APort='443'))) then
    begin
      ANormalizedUrl:=ANormalizedUrl+':'+APort;
    end;
    ANormalizedUrl:=ANormalizedUrl+APath;
    //���ɲ����б��ַ���
    ANormalizedRequestParameters:=NormalizeRequestParameters(Params);
    //����ǩ������
    Result:=UpperCase(AHttpMethod)+'&'+UrlEncode(ANormalizedUrl)+'&'+UrlEncode(ANormalizedRequestParameters);
  Finally
    Params.Free;
  End;
end;

function TCustomMyOAuth.GenerateTimeStamp: String;
begin
  //Result:='1320753939';
  //Exit;
  Result := IntToStr(DateTimeToUnix(Now));
end;

procedure TCustomMyOAuth.GetQueryParameters(const AParametersString: String;
  var AParameters: TQueryParameters);
var
  EqualCharPos:Integer;
  ParamStrList:TStringList;
  I: Integer;
  AName,AValue:String;
begin
  AParameters.Clear;
  //�����������б�
  if AParametersString<>'' then
  begin
    //�ҵ������б��ַ���
    ParamStrList:=TStringList.Create;
    Try
      ParamStrList.Delimiter:='&';
      ParamStrList.DelimitedText:=AParametersString;
      for I := 0 to ParamStrList.Count-1 do
      begin
        if (ParamStrList[I]<>'')
            //and (Pos(Self.FOAuthParameterPrefix,ParamStrList[I])>0)
            then
        begin
          EqualCharPos:=Pos('=',ParamStrList[I]);
          if EqualCharPos>0 then
          begin
            AName:=Copy(ParamStrList[I],1,EqualCharPos-1);
            AValue:=Copy(ParamStrList[I],EqualCharPos+1,Length(ParamStrList[I])-EqualCharPos);
          end
          else
          begin
            AName:=ParamStrList[I];
            AValue:='';
          end;
          AParameters.AddQueryParameter(AName,AValue);
        end;
      end;
    Finally
      ParamStrList.Free;
    End;
  end;
end;

function TCustomMyOAuth.NormalizeRequestParameters(const AParameters: TQueryParameters): String;
begin
  Result:='';
  if AParameters<>nil then
  begin
    Result:=AParameters.GetQueryParamsStr;
  end;
end;

function TCustomMyOAuth.RequestAccessToken(AOAuthAccessTokenURL: String): Boolean;
var
  Response:String;
begin
  Result:=False;

  Self.FOAuthAccessTokenURL:=AOAuthAccessTokenURL;
  Self.FOAuthAccessTokenBaseString := FOAuthAccessTokenURL + '?'
        + Self.AppendSignatureString(FOAuthAccessTokenURL, '',
      'GET');
  Response := FHTTP.Get(FOAuthAccessTokenBaseString);
  Self.Token :=
              Copy(Response, Pos('oauth_token=', Response) + Length('oauth_token='),
              Length(Response) - Pos('oauth_token=',
                Response) - (Length(Response) - Pos('&oauth_token_secret=',
                  Response) + 1) - Length('oauth_token=') + 1);

  Self.TokenSecret :=
              Copy(Response, Pos('&oauth_token_secret=', Response) + Length
                ('&oauth_token_secret='), Length(Response) - Pos('&oauth_token_secret=',
                Response) - (Length(Response) - Pos('&user_id=', Response) + 1) - Length
                ('&oauth_token_secret=') + 1);

  Self.OAuthUserID :=
              Copy(Response, Pos('&user_id=', Response) + Length('&user_id='),
              Length(Response) - Pos('&user_id=', Response) - Length('&user_id=') + 1);

  Result:=True;
end;

function TCustomMyOAuth.RequestToken(AOAuthOAuthRequestTokenURL:String): Boolean;
var
  URL: string;
  Response: String;
begin
  Result := False;
  if AOAuthOAuthRequestTokenURL<>'' then
  begin
    FOAuthOAuthRequestTokenURL:=AOAuthOAuthRequestTokenURL;
    Self.Token := '';
    Self.TokenSecret := '';

    FOAuthRequestTokenBaseString:=FOAuthOAuthRequestTokenURL + '?' +Self.AppendSignatureString
                    (FOAuthOAuthRequestTokenURL, '', 'GET');
    //OutputDebugString(PWideChar(FOAuthRequestTokenBaseString));
    Response := FHTTP.Get(FOAuthRequestTokenBaseString);

    Self.Token := Copy(Response, Pos('oauth_token=',
                      Response) + Length('oauth_token='),
                      Length(Response) - Pos('oauth_token=',
                      Response) - (Length(Response) - Pos('&oauth_token_secret=',
                      Response) + 1) - Length('oauth_token=') + 1);
    Self.TokenSecret := Copy(Response,
                      Pos('&oauth_token_secret=', Response) + Length('&oauth_token_secret='),
                      Length(Response));
    Result := True;
  end;
end;


//var
//  Response: String;
//begin
//  Result:=False;
//  Response := FHTTP.Get(FOAuthOAuthRequestTokenURL + '?' + AppendSignatureString(FOAuthOAuthRequestTokenURL, '','POST'));
//  Self.Token :=Copy(Response, Pos('oauth_token=', Response) + Length('oauth_token='),
//                  Length(Response) - Pos('oauth_token=',
//                  Response) - (Length(Response) - Pos('&oauth_token_secret=',
//                  Response) + 1) - Length('oauth_token=') + 1);
//
//  Self.TokenSecret :=Copy(Response, Pos('&oauth_token_secret=', Response) + Length
//                  ('&oauth_token_secret='), Length(Response) - Pos('&oauth_token_secret=',
//                  Response) - (Length(Response) - Pos('&user_id=', Response) + 1) - Length
//                  ('&oauth_token_secret=') + 1);
//
//  Self.OAuthUserID :=Copy(Response, Pos('&user_id=', Response) + Length('&user_id='),
//                  Length(Response) - Pos('&user_id=', Response) - Length('&user_id=') + 1);
//  Result:=True;
//end;

function TCustomMyOAuth.GenerateSignature(const AScheme, AHost, APort, APath, AQuery,
  AMethod: String; var ANormalizedUrl, ANormalizedRequestParameters: String): String;
begin
  Result:=GenerateSignature(AScheme, AHost, APort, APath, AQuery,FAppKey,FAppSecret,
        Self.FToken,Self.FTokenSecret,AMethod,Self.GenerateTimeStamp,Self.GenerateNonce,
        TSignatureType.stHMACSHA1,ANormalizedUrl,ANormalizedRequestParameters);
end;

function TCustomMyOAuth.GenerateSignature(const AUrl, AQuery, AConsumerKey,
  AConsumerSecret, AToken, ATokenSecret, AHttpMethod, ATimeStamp,
  ANonce: String; const ASignatureType: TSignatureType;
  var ANormalizedRequestParameters: String): String;
var
  SinatureBase:String;
  KeyStr:AnsiString;
begin
  case ASignatureType of
    stHMACSHA1:
    begin
      //ǩ������
      SinatureBase:=Self.GenerateSignatureBaseString(AUrl, AQuery,
                    AConsumerKey, AToken, ATokenSecret, AHttpMethod, ATimeStamp,
                    ANonce,ConstSignatureTypeName[ASignatureType],
                    ANormalizedRequestParameters);
      //ǩ���㷨��ʹ�õļ���
      if ATokenSecret<>'' then
      begin
        KeyStr:=UrlEncode(AConsumerSecret)+'&'+UrlEncode(ATokenSecret);
      end
      else
      begin
        KeyStr:=UrlEncode(AConsumerSecret)+'&';
      end;
      //Base64����
      Result:=Base64Encode(EncryptHMACSha1(SinatureBase,KeyStr));
    end;
  end;
end;

function TCustomMyOAuth.GenerateSignatureBaseString(const AUrl, AQuery,
  AConsumerKey, AToken, ATokenSecret, AHttpMethod, ATimeStamp, ANonce,
  ASignatureTypeStr: String; var
  ANormalizedRequestParameters: String): String;
var
  Params:TQueryParameters;
begin
  ANormalizedRequestParameters:='';
  //���������б�
  Params:=TQueryParameters.Create;
  Try
    //��Ӳ���
    GetQueryParameters(AQuery,Params);
    Params.AddQueryParameter(Self.FOAuthVersionKey,FOAuthVersion);
    Params.AddQueryParameter(Self.FOAuthNonceKey,ANonce);
    Params.AddQueryParameter(Self.FOAuthTimestampKey,ATimeStamp);
    Params.AddQueryParameter(Self.FOAuthSignatureMethodKey,ASignatureTypeStr);
    Params.AddQueryParameter(Self.FOAuthConsumerKeyKey,AConsumerKey);
    //
    if (AToken<>'') then
    begin
      Params.AddQueryParameter(Self.FOAuthTokenKey,AToken);
    end;
    //
    if (ATokenSecret<>'') then
    begin
      Params.AddQueryParameter(Self.FOAuthTokenSecretKey,ATokenSecret);
    end;
    if (Self.FOAuthVerifier<>'') and (AHttpMethod='GET') then
    begin
      Params.AddQueryParameter(Self.FOAuthVerifierKey,Self.FOAuthVerifier);
    end;
    //���ղ������ƣ�����ֵ��������
    Params.Sort;
    //���ɲ����б��ַ���
    ANormalizedRequestParameters:=NormalizeRequestParameters(Params);
    //����ǩ������
    Result:=UpperCase(AHttpMethod)+'&'+UrlEncode(AUrl)+'&'+UrlEncode(ANormalizedRequestParameters);
  Finally
    Params.Free;
  End;
end;

function TCustomMyOAuth.GenerateSignature(const AUrl, AQuery, AMethod: String;
  var ANormalizedRequestParameters: String): String;
begin
  Result:=GenerateSignature(AUrl, AQuery,FAppKey,FAppSecret,
        Self.FToken,Self.FTokenSecret,AMethod,Self.GenerateTimeStamp,Self.GenerateNonce,
        TSignatureType.stHMACSHA1,ANormalizedRequestParameters);
end;


end.
