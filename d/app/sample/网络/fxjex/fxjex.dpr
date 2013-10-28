program fxjex;

{

�����ˢ��fxj�Ĵ��̱��۱�

���������ˢ��FXJ�Ĵ��̱��۱�û��ʵʱ���ջ�ӿڲ������û����ã��������غ͵�
��FXJ������������ݣ������б�����

ԭ����Kinneng ��ҳ��http://kinneng.icpcn.com ������������ί�б�ģ�ûʱ�俼�ǳ�
Ȩ�Ĺ�Ʊ, ���Գ�Ȩ�ɵ����ռ۰����̼ۼ��㣬����ᵼ���ǵ�������

����Դ���룬�����޸ģ��κ�������������ҵ�Ҫ�������ע��ԭ����Kinneng �ñ���
�и����ף�ʡ�÷������ؼ��ɡ�


                                                                               }
uses Classes, SysUtils, Windows;

const
  PROJECTNAME = 'ˢ��FXJ�Ĵ��̱��۱�';
  WELCOME = '���������ˢ��FXJ�Ĵ��̱��۱�' + #13 +
    'û��ʵʱ���ջ�ӿڲ������û����ã�' + #13 + #13 +
    '�������غ͵���FXJ������������ݣ�' + #13 + '�����б�����' + #13 + #13 +
    '��Ҫ������?';
  LOCATION = '�뽫���������FXJ���ļ�������';
  MEASURE = '���FXJ���������������ݣ���ʹ�ñ����';
  CHOOSE = '׼������, ��ȷ���Ƿ���Ҫ������';
  COMPLETE = '�������' + #13 + 'ԭ����Kinneng' + #13 +
    '��ҳ��http://kinneng.icpcn.com';
  ERROR = '�����������FXJ��ʹ�ã���ر���';
  SH = 'SH';
  SZ = 'SZ';
  FXJ = 'SUPERSTK.EXE';
  SHDAY = 'DATA\SH\DAY.DAT';
  SHINF = 'DATA\SH\STKINFO5.DAT';
  SZDAY = 'DATA\SZ\DAY.DAT';
  SZINF = 'DATA\SZ\STKINFO5.DAT';
  DATA = 'data\';
  DAY = '\day.dat';
  INFO = '\stkinfo5.dat';

function RefreshMarket(Market: string): boolean;
type
  TStkData = packed record
    m_szLabel: array[1..6] of Char;
    m_LastClose: Single;
    m_time: Integer;
    m_open, m_High, m_Low, m_Close, m_Volume, m_Amount: Single;
    m_Advance, m_Decline: Word;
  end;
var
  dayfile: TFileStream;
  StkData: array of TStkData;
  I, J, StkCount1, StkCount2, todaypoint: Integer;
  DayCount: Word;
  szLabel: array[1..6] of Char;
  szName: array[1..8] of Char;
begin
  try
    with dayfile do
    begin
      dayfile := TFileStream.Create(DATA + Market + DAY, fmOpenRead);
      Position := $C;
      ReadBuffer(StkCount1, 4);
      SetLength(StkData, StkCount1);
      for I := 0 to StkCount1 - 1 do // Iterate
      begin
        DayCount := 0;
        todaypoint := 0;
        Position := $18 + I * $40;
        ReadBuffer(StkData[I].m_szLabel, 6);
        Position := $22 + I * $40;
        ReadBuffer(DayCount, 2);
        Dec(DayCount);
        if DayCount >= 0 then
        begin
          Position := $26 + DayCount div $100 * 2 + I * $40;
          ReadBuffer(todaypoint, 2);
          Position := $41000 + todaypoint * $2000 + DayCount mod $100 * $20;
          ReadBuffer(StkData[I].m_time, $20);
          Dec(DayCount);
          if DayCount >= 0 then
          begin
            Position := $26 + DayCount div $100 * 2 + I * $40;
            ReadBuffer(todaypoint, 2);
            Position := $41010 + todaypoint * $2000 + DayCount mod $100 * $20;
            ReadBuffer(StkData[I].m_LastClose, 4);
          end
          else
            StkData[I].m_LastClose := StkData[I].m_Open;
        end
        else
        begin
          StkData[I].m_time := 0;
        end;
      end; // for
      Free;
      dayfile := TFileStream.Create(DATA + Market + INFO,
        fmOpenReadWrite);
      Position := 8;
      ReadBuffer(StkCount2, 4);
      for I := 0 to StkCount2 - 1 do // Iterate
      begin
        Position := $1DD968 + $D0 * I;
        ReadBuffer(szLabel, 6);
        Position := $1DD972 + $D0 * I;
        ReadBuffer(szName, 8);
        for J := 0 to StkCount1 - 1 do // Iterate
        begin
          if StkData[J].m_szLabel = szLabel then
          begin
            if (szName[1] = 'X') or (szName[1] = 'D') then
              StkData[J].m_LastClose := StkData[J].m_open;
            Position := $1DD9AC + $D0 * I;
            with StkData[J] do
            begin
              WriteBuffer(m_LastClose, 4);
              WriteBuffer(m_open, 4);
              WriteBuffer(m_High, 4);
              WriteBuffer(m_Low, 4);
              WriteBuffer(m_Close, 4);
              WriteBuffer(m_Volume, 4);
              WriteBuffer(m_Amount, 4);
            end; // with
          end;
        end; // for
      end;
      Free;
    end; // with
    Result := True;
  except
    on e: Exception do
    begin
      MessageBox(0, ERROR, PROJECTNAME, MB_ICONERROR or MB_OK);
      Result := False;
    end;
  end; // try/except
end;
begin
  if MessageBox(0, WELCOME, PROJECTNAME, MB_ICONINFORMATION or MB_OKCANCEL) <> 1
    then
    exit;
  if not FileExists(FXJ) then
  begin
    MessageBox(0, LOCATION, PROJECTNAME, MB_ICONWARNING or
      MB_OK);
    exit;
  end;
  if not FileExists(SHDAY) or
    not FileExists(SHINF) or
    not FileExists(SZDAY) or
    not FileExists(SZINF) then
  begin
    MessageBox(0, MEASURE, PROJECTNAME, MB_ICONWARNING or
      MB_OK);
    exit;
  end;
  if MessageBox(0, CHOOSE, PROJECTNAME, MB_ICONQUESTION
    or MB_OKCANCEL) = 1 then
  begin
    if RefreshMarket(SH) then
      if RefreshMarket(SZ) then
        MessageBox(0, COMPLETE, PROJECTNAME, MB_ICONWARNING or
          MB_OK);
  end;
end.

