{�㷨ʾ��
17715   -22360   -21571           -2345   -12854    -13105              �������룩
(1,3)   (3,5)    (1,2|3,4|4,5)    (1,3)   (3,5)    (1,2|3,4|4,5)         (ȡλ)
17       30        21| 57| 71       13     84       13 |10 |05           (ֵ)
N        NS         S|  S| NS        N     NS        S |S  |NS           (ҪתΪ���֣�N�����ַ���S�� NS�Ǽ�����ѡ)
8        0          I|  S| G         4     T         A |X  |5            (ת����õ���ֵ)
                                                                                         }

{1��(9>=x>=0  x)    2:(90>=x>=65 ȡ��ĸ)  3:(90>=x>=65 ȡ��ĸ)       4:(ͬ3)   5:(ͬ2)  (ǰ��λ���㷽ʽ)
    (���� x=x-9)      (����x=%10ȡ��λ)     (x<65 x+26 | x>90 x-26)                      (����λ��ʽһ��)
 }
unit UntReg;

interface

uses
  Windows, SysUtils, Registry;


function GetIdeSerialNumber: pchar; //�õ�Ӳ�����к�
function SnToAscii(Sn: string):string;//�ַ���תASCII
function AsciiToRegCode(sAsc: string):string;//ASCIIתע����
function Registration(RegCode: string):Boolean; //����ע��
function InitToRegTab:Boolean;// ��ʼ��ע���
function RegToRegTab(StrSN,StrRegCode:string):Boolean;//����ע����Ϣ��ע���
function VerifyRegInfo:Boolean;//��֤ע����Ϣ�Ƿ���ȷ

implementation

function VerifyRegInfo:Boolean;//��֤ע����Ϣ�Ƿ���ȷ
var
  Aregistry: TRegistry;
  RstrSN,RstrRegCode,strSN,strRegCode: string;
begin
  Result := False;
  try
    ARegistry := TRegistry.Create;
    ARegistry.RootKey := HKEY_LOCAL_MACHINE;
    if ARegistry.OpenKey('Software\SeekWang\RegInfo',True) then //���Ҵ���Ŀ¼
    begin
        RstrSN := ARegistry.ReadString('ComputerId'); //ע����еĻ�����
        RstrRegCode := ARegistry.ReadString('RegId'); //ע����е�ע����
    end
    else Exit;
    strSN := SnToAscii(GetIdeSerialNumber);
    strRegCode := AsciiToRegCode(strSN);
    if (RstrSN<>strSN) or (RstrRegCode<>strRegCode) then
      Exit;
  finally
    ARegistry.CloseKey;
  end;
  Result := True;
end;

function RegToRegTab(StrSN,StrRegCode:string):Boolean;//����ע����Ϣ��ע���
var
  Aregistry: TRegistry;
begin
  Result := False;
  try
    ARegistry := TRegistry.Create;
    ARegistry.RootKey := HKEY_LOCAL_MACHINE;
    if ARegistry.OpenKey('Software\SeekWang\RegInfo',True) then //���Ҵ���Ŀ¼
    begin
        ARegistry.WriteString('ComputerId',StrSN); //��д������
        ARegistry.WriteString('RegId',StrRegCode); //��дע����
    end else Exit;
  finally
    ARegistry.CloseKey;
  end;
  Result := True;
end;

function InitToRegTab:Boolean;// ��ʼ��ע���
var
  ARegistry: Tregistry;
  s: string;
begin
  Result := False;
  try
    ARegistry := TRegistry.Create;
    ARegistry.RootKey := HKEY_LOCAL_MACHINE;
    if ARegistry.OpenKey('Software\SeekWang\RegInfo',True) then //���Ҵ���Ŀ¼
    begin
      if ARegistry.ReadString('ComputerId') = '' then //������
      begin
        s:=GetIdeSerialNumber;
        s:=SnToAscii(s);
        ARegistry.WriteString('ComputerId',s);
      end;
      if ARegistry.ReadString('RegId') = '' then //ע����
        ARegistry.WriteString('RegId','');
    end else Exit;
  finally
    ARegistry.CloseKey;
  end;
  Result := True;
end;

function GetHDNumber(Drv : String): DWORD; //�õ�Ӳ�̷�����Ϣ���к�
var
VolumeSerialNumber : DWORD;
MaximumComponentLength : DWORD;
FileSystemFlags : DWORD;
begin
if Drv[Length(Drv)] =':' then Drv := Drv + '\';
  GetVolumeInformation(pChar(Drv), nil, 0, @VolumeSerialNumber, MaximumComponentLength, FileSystemFlags, nil, 0);
  Result:= (FileSystemFlags);
end;

//�õ�Ӳ�����к�
function GetIdeSerialNumber: pchar;
const IDENTIFY_BUFFER_SIZE = 512;
type
  TIDERegs = packed record
  bFeaturesReg: BYTE; // Used for specifying SMART "commands".
  bSectorCountReg: BYTE; // IDE sector count register
  bSectorNumberReg: BYTE; // IDE sector number register
  bCylLowReg: BYTE; // IDE low order cylinder value
  bCylHighReg: BYTE; // IDE high order cylinder value
  bDriveHeadReg: BYTE; // IDE drive/head register
  bCommandReg: BYTE; // Actual IDE command.
  bReserved: BYTE; // reserved for future use. Must be zero.
  end;
  TSendCmdInParams = packed record
  // Buffer size in bytes
  cBufferSize: DWORD;
  // Structure with drive register values.
  irDriveRegs: TIDERegs;
  // Physical drive number to send command to (0,1,2,3).
  bDriveNumber: BYTE;
  bReserved: array[0..2] of Byte;
  dwReserved: array[0..3] of DWORD;
  bBuffer: array[0..0] of Byte; // Input buffer.
  end;
  TIdSector = packed record
  wGenConfig: Word;
  wNumCyls: Word;
  wReserved: Word;
  wNumHeads: Word;
  wBytesPerTrack: Word;
  wBytesPerSector: Word;
  wSectorsPerTrack: Word;
  wVendorUnique: array[0..2] of Word;
  sSerialNumber: array[0..19] of CHAR;
  wBufferType: Word;
  wBufferSize: Word;
  wECCSize: Word;
  sFirmwareRev: array[0..7] of Char;
  sModelNumber: array[0..39] of Char;
  wMoreVendorUnique: Word;
  wDoubleWordIO: Word;
  wCapabilities: Word;
  wReserved1: Word;
  wPIOTiming: Word;
  wDMATiming: Word;
  wBS: Word;
  wNumCurrentCyls: Word;
  wNumCurrentHeads: Word;
  wNumCurrentSectorsPerTrack: Word;
  ulCurrentSectorCapacity: DWORD;
  wMultSectorStuff: Word;
  ulTotalAddressableSectors: DWORD;
  wSingleWordDMA: Word;
  wMultiWordDMA: Word;
  bReserved: array[0..127] of BYTE;
  end;
  PIdSector = ^TIdSector;
  TDriverStatus = packed record
  // ���������صĴ�����룬�޴��򷵻�0
  bDriverError: Byte;
  // IDE����Ĵ��������ݣ�ֻ�е�bDriverError Ϊ SMART_IDE_ERROR ʱ��Ч
  bIDEStatus: Byte;
  bReserved: array[0..1] of Byte;
  dwReserved: array[0..1] of DWORD;
  end;
  TSendCmdOutParams = packed record
  // bBuffer�Ĵ�С
  cBufferSize: DWORD;
  // ������״̬
  DriverStatus: TDriverStatus;
  // ���ڱ�������������������ݵĻ�������ʵ�ʳ�����cBufferSize����
  bBuffer: array[0..0] of BYTE;
  end;
var
  hDevice: Thandle;
  cbBytesReturned: DWORD;
  SCIP: TSendCmdInParams;
  aIdOutCmd: array[0..(SizeOf(TSendCmdOutParams) + IDENTIFY_BUFFER_SIZE - 1) - 1] of Byte;
  IdOutCmd: TSendCmdOutParams absolute aIdOutCmd;
  procedure ChangeByteOrder(var Data; Size: Integer);
  var
    ptr: Pchar;
    i: Integer;
    c: Char;
  begin
    ptr := @Data;
    for I := 0 to (Size shr 1) - 1 do begin
    c := ptr^;
    ptr^ := (ptr + 1)^;
    (ptr + 1)^ := c;
    Inc(ptr, 2);
    end;
  end;
begin
  Result := ''; // ��������򷵻ؿմ�
  if SysUtils.Win32Platform = VER_PLATFORM_WIN32_NT then
  begin // Windows NT, Windows 2000
    // ��ʾ! �ı����ƿ���������������������ڶ����������� '\\.\PhysicalDrive1\'
    hDevice := CreateFile('\\.\PhysicalDrive0', GENERIC_READ or GENERIC_WRITE,
    FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);
  end else // Version Windows 95 OSR2, Windows 98
    hDevice := CreateFile('\\.\SMARTVSD', 0, 0, nil, CREATE_NEW, 0, 0);
    if hDevice = INVALID_HANDLE_VALUE then Exit;
  try
    FillChar(SCIP, SizeOf(TSendCmdInParams) - 1, #0);
    FillChar(aIdOutCmd, SizeOf(aIdOutCmd), #0);
    cbBytesReturned := 0;
    // Set up data structures for IDENTIFY command.
  with SCIP do begin
    cBufferSize := IDENTIFY_BUFFER_SIZE;
    // bDriveNumber := 0;
  with irDriveRegs do begin
    bSectorCountReg := 1;
    bSectorNumberReg := 1;
    // if Win32Platform=VER_PLATFORM_WIN32_NT then bDriveHeadReg := $A0
    // else bDriveHeadReg := $A0 or ((bDriveNum and 1) shl 4);
    bDriveHeadReg := $A0;
    bCommandReg := $EC;
  end;
  end;
    if not DeviceIoControl(hDevice, $0007C088, @SCIP, SizeOf(TSendCmdInParams) - 1,
    @aIdOutCmd, SizeOf(aIdOutCmd), cbBytesReturned, nil) then Exit;
  finally
    CloseHandle(hDevice);
  end;
  with PIdSector(@IdOutCmd.bBuffer)^ do begin
    ChangeByteOrder(sSerialNumber, SizeOf(sSerialNumber));
    (Pchar(@sSerialNumber) + SizeOf(sSerialNumber))^ := #0;
    Result := Pchar(@sSerialNumber);
  end;
end;

function SnToAscii(Sn: string):string;
var
  i: Integer;
  code: string;
begin
  code:='';
  if Length(Sn)>=10 then
  begin
    for i := 5 to 10 do
    begin
      if i = 10 then
        code := code + Format('%d',[Ord(Sn[i])])
      else begin
        code := code + Format('%d',[Ord(Sn[i])]);
        while Length(Format('%d',[Ord(Sn[i])])) < 5 do
        begin
          code := code + '0';
          Sn[i] := chr(StrToInt(Format('%d',[Ord(Sn[i])])+'0'));
        end;
        code := code + '-';
      end;
    end;
  end;
  Result:=code;
end;

function AsciiToRegCode(sAsc: string):string;//ASCIIתע����
var
  i,Xi: Integer;
  str,sc,Si: string;
  code: String;
  endstr: string;//�ӵ�ע����ĩβ
begin
  code := '';
  endstr := '';
  for i := 1 to 6 do
  begin
    if i <> 6 then
    begin
      str:= Copy(sAsc,1,Pos('-',sAsc)-1);
      Delete(sAsc,1,Pos('-',sAsc));
    end else str := sAsc;
    case i of
      1,4: begin
             sc := str[1]+str[3];
             Xi := StrToInt(sc);
             while Xi > 9 do
             begin
               Xi := Xi - 9;
             end;
             code := code + IntToStr(Xi);

             sc := str[2]+str[4]+str[5];
             Xi := StrToInt(sc);
             if Xi < 10 then
               endstr := endstr + IntToStr(Xi)
             else begin
               while (Xi>90) or (Xi<65) do
               begin
                 if xi>90 then
                   Xi := Xi -26
                 else
                   Xi := Xi + 26;
               end;
               endstr := endstr + Chr(Xi);
             end;
           end;
      2,5: begin
             sc := str[3]+str[5];
             Xi := StrToInt(sc);
             if (Xi>90) or (Xi<65) then
             begin
               Xi := Xi mod 10;
               code := code + IntToStr(Xi);
             end else
               code := code + Chr(Xi);

             sc := str[1]+str[2]+str[4];
             Xi := StrToInt(sc);
             if Xi < 10 then
               endstr := endstr + IntToStr(Xi)
             else begin
               while (Xi>90) or (Xi<65) do
               begin
                 if xi>90 then
                   Xi := Xi -26
                 else
                   Xi := Xi + 26;
               end;
               endstr := endstr + Chr(Xi);
             end;
           end;
      3,6: begin
             sc := str[1]+str[2];
             Xi := StrToInt(sc);
             while (Xi>90) or (Xi<65) do
             begin
               if Xi < 65 then
                 Xi := Xi + 26
               else Xi := Xi -26;
             end;
             code := code + Chr(Xi);

             sc := str[3]+str[4];
             Xi := StrToInt(sc);
             while (Xi>90) or (Xi<65) do
             begin
               if Xi < 65 then
                 Xi := Xi + 26
               else Xi := Xi -26;
             end;
             code := code + Chr(Xi);

             sc := str[4]+str[5];
             Xi := StrToInt(sc);
             if (Xi>90) or (Xi<65) then
             begin
               Xi := Xi mod 10;
               code := code + IntToStr(Xi);
             end else
               code := code + Chr(Xi);
           end;
    end;
  end;
  Result := code + endstr;
end;

function Registration(RegCode: string):Boolean; //����ע��
var
  i,Xi: Integer;
  sAsc,str,Si: string;
  code: String;
  sc: array[0..13] of string;
begin
  Result := False;
  sAsc := SnToAscii(GetIdeSerialNumber);
  for i := 1 to 6 do
  begin
    if i <> 6 then
    begin
      str:= Copy(sAsc,1,Pos('-',sAsc)-1);
      Delete(sAsc,1,Pos('-',sAsc));
    end else str := sAsc;
    case i of
      1: begin sc[0] := str[1]+str[3]; sc[10] := str[2]+str[4]+str[5]; end;
      2: begin sc[1] := str[3]+str[5]; sc[11] := str[1]+str[2]+str[4]; end;
      3: begin
           sc[2] := str[1]+str[2];
           sc[3] := str[3]+str[4];
           sc[4] := str[4]+str[5];
         end;
      4: begin sc[5] := str[1]+str[3]; sc[12] := str[2]+str[4]+str[5]; end;
      5: begin sc[6] := str[3]+str[5]; sc[13] := str[1]+str[2]+str[4]; end;
      6: begin
           sc[7] := str[1]+str[2];
           sc[8] := str[3]+str[4];
           sc[9] := str[4]+str[5];
         end;
    end;
  end;
  for i := 1 to 14 do
  begin
    case i of
      1,6: begin
            Si := RegCode[i];
            Xi := StrToInt(Si);
            while Xi < StrToInt(Sc[i-1]) do
              Xi := Xi + 9;
            if Xi <> StrToInt(Sc[i-1]) then
              exit;
           end;
      2,5,7,10: begin
                  Si := RegCode[i];
                  Xi := StrToInt(Format('%d',[Ord(Si[1])]));
                  if (Xi>=65) and (Xi<=90)then
                  begin
                    if Xi <> StrToInt(sc[i-1]) then
                      exit;
                  end
                  else if (Xi >= 48) and (Xi <= 57) then
                  begin
                    Xi := StrToInt(Si);
                    while Xi < StrToInt(Sc[i-1]) do
                      Xi := Xi + 10;
                    if Xi <> StrToInt(Sc[i-1])then
                      exit;
                  end
                  else exit;
                end;
      3,4,8,9: begin
                 Si := RegCode[i];
                 Xi := StrToInt(Format('%d',[Ord(Si[1])]));
                 while Xi > StrToInt(Sc[i-1]) do
                   Xi := Xi -26;
                 while Xi < StrToInt(Sc[i-1]) do
                   Xi := Xi +26;
                 if Xi <> StrToInt(Sc[i-1]) then
                   exit;
               end;
      11,12,
      13,14: begin
               Si := RegCode[i];
               Xi := StrToInt(Format('%d',[Ord(Si[1])]));
               if (Xi >= 48) and (Xi <= 57) then
               begin
                 if StrToInt(Si) <> StrToInt(Sc[i-1]) then
                   Exit;
               end
               else if (Xi >= 65) and (Xi <= 90) then
               begin
                 while Xi < StrToInt(Sc[i-1]) do
                   Xi := Xi + 26;
                 while Xi > StrToInt(sc[i-1]) do
                   Xi := Xi - 26;
                 if Xi <> StrToInt(Sc[i-1]) then
                   Exit;
               end
               else exit;
             end;
    end;
  end;
  Result := True;
end;

end.

