unit MyFun;

interface

  uses
    Forms, windows,SysUtils,IniFiles,Dialogs,DateUtils,Registry,Nb30,WinSock;

const
	ID_BIT	=	$200000;    
type
	TCPUID	= array[1..4] of Longint;
	TVendor	= array [0..11] of char;
  TCPUMSG = record
    ID1    : String;
    ID2    : String;
    ID3    : String;
    ID4    : String;
    PValue : String;
    FValue : String;
    MValue : String;
    SValue : String;
    Vendor : String;
   end;


function  Decry(Str: String): String;
function  Encry(Str: String): String;
function  StrEncode(const Str: String): String;
function  HexToInt(Str: String): Int64;
function  StrDecode(const Str: String): String;

function IsCPUID_Available : Boolean; register;
function GetCPUID : TCPUID; assembler; register;
function GetCPUVendor : TVendor; assembler; register;
function GetCPUMSG:TCPUMSG;
procedure ReadReg;
function GetExeSize(ExeSize:integer):Boolean;

function GetIdeDiskSerialNumber(var SerialNumber: string; var ModelNumber: string;
 var FirmwareRev: string; var TotalAddressableSectors: ULong;
 var SectorCapacity: ULong; var SectorsPerTrack: Word): Boolean; //�õ�Ӳ�������
function GetMacAddr(a: integer):String;

procedure AdjustToken;
function GetPCName:string;
function GetIP:String;


implementation

uses Main;

//һ���ִ�תʮ����λ�ִ����� , �� '����' ת�� 'B4FAB8D5'
function Decry(Str: String): String;
var
  i: integer;
begin
  result := '';
  for i := 1 to Length(Str) do
      result := result + IntToHex( Ord( Str[i] ), 2 );
end;

//ʮ����λ�ִ�����ת��һ���ִ� , �� 'B4FAB8D5' ת�� '����'
function Encry(Str: String): String;
var
  i: integer;
begin
  result := '';
  for i := 1 to Length(Str) do
    begin
      if ((i mod 2) = 1) then  result := result + chr( StrToInt( '0x' + Copy( Str, i, 2 )));
    end;
end;


//ʮ����λֵ�ִ�ת������
function HexToInt(Str: String): Int64;
var
  RetVar : Int64;
  i : byte;
begin
  if (Str='') then
     begin
       result := 0;
       exit;
     end;
  Str := UpperCase(Str);
  if Str[length(Str)] = 'H' then  Delete(Str,length(Str),1);
  RetVar := 0;
  for i := 1 to length(Str) do
    begin
      RetVar := RetVar shl 4;
      if Str[i] in ['0'..'9'] then  RetVar := RetVar + (byte(Str[i]) - 48)
      else if Str[i] in ['A'..'F'] then RetVar := RetVar + (byte(Str[i]) - 55)
      else
        begin
          Retvar := 0;
          break;
        end;
    end;
  result := RetVar;
end;

//���ִ����� URL ����
function StrEncode(const Str: String): String;
var
  I: Integer;
begin
  result := '';
  if Length(Str) > 0 then
    for I := 1 to Length(Str) do
      begin
        if not (Str[I] in ['0'..'9', 'a'..'z','A'..'Z', ' ']) then result := result + '%' + IntToHex(Ord(Str[I]), 2)
        else if not (Str[I] = ' ') then result := result + Str[I]
        else  result := result + '%20';
      end;
end;


//�� URL �ִ����н���
function StrDecode(const Str: String): String;
var
  I: Integer;
begin
  result := '';
  if Length(Str) > 0 then
    begin
      I := 1;
      while I <= Length(Str) do
        begin
          if Str[I] = '%' then
            begin
              result := result + Chr(HexToInt(Str[I+1] + Str[I+2]));
              I := Succ(Succ(I));
            end
          else if Str[I] = '+' then  result := result + ' '
          else  result := result + Str[I];
          I := Succ(I);
        end;
    end;
end;

function IsCPUID_Available : Boolean; register;
asm
	PUSHFD							{direct access to flags no possible, only via stack}
  POP     EAX					{flags to EAX}
  MOV     EDX,EAX			{save current flags}
  XOR     EAX,ID_BIT	{not ID bit}
  PUSH    EAX					{onto stack}
  POPFD								{from stack to flags, with not ID bit}
  PUSHFD							{back to stack}
  POP     EAX					{get back to EAX}
  XOR     EAX,EDX			{check if ID bit affected}
  JZ      @exit				{no, CPUID not availavle}
  MOV     AL,True			{Result=True}
@exit:
end;

function GetCPUID : TCPUID; assembler; register;
asm
  PUSH    EBX         {Save affected register}
  PUSH    EDI
  MOV     EDI,EAX     {@Resukt}
  MOV     EAX,1
  DW      $A20F       {CPUID Command}
  STOSD			          {CPUID[1]}
  MOV     EAX,EBX
  STOSD               {CPUID[2]}
  MOV     EAX,ECX
  STOSD               {CPUID[3]}
  MOV     EAX,EDX
  STOSD               {CPUID[4]}
  POP     EDI					{Restore registers}
  POP     EBX
end;

function GetCPUVendor : TVendor; assembler; register;
asm
  PUSH    EBX					{Save affected register}
  PUSH    EDI
  MOV     EDI,EAX			{@Result (TVendor)}
  MOV     EAX,0
  DW      $A20F				{CPUID Command}
  MOV     EAX,EBX
  XCHG		EBX,ECX     {save ECX result}
  MOV			ECX,4
@1:
  STOSB
  SHR     EAX,8
  LOOP    @1
  MOV     EAX,EDX
  MOV			ECX,4
@2:
  STOSB
  SHR     EAX,8
  LOOP    @2
  MOV     EAX,EBX
  MOV			ECX,4
@3:
  STOSB
  SHR     EAX,8
  LOOP    @3
  POP     EDI					{Restore registers}
  POP     EBX
end;


function GetCPUMSG:TCPUMSG;
var
  CPUID : TCPUID;
  I     : Integer;
  S			: String;//TVendor;
  cups:TCPUMSG ;
begin
	for I := Low(CPUID) to High(CPUID)  do CPUID[I] := -1;
  if IsCPUID_Available then
    begin
      CPUID	:= GetCPUID;
      cups.ID1   := pchar(IntToHex(CPUID[1],8));
      cups.ID2   := pchar(IntToHex(CPUID[2],8));
      cups.ID3   := pchar(IntToHex(CPUID[3],8));
      cups.ID4   := pchar(IntToHex(CPUID[4],8));
      cups.PValue:= pchar(IntToStr(CPUID[1] shr 12 and 3));
      cups.FValue:= pchar(IntToStr(CPUID[1] shr 8 and $f));
      cups.MValue:= pchar(IntToStr(CPUID[1] shr 4 and $f));
      cups.SValue:= pchar(IntToStr(CPUID[1] and $f));
      S := GetCPUVendor;
      cups.Vendor:= PChar(S);
    end
  else
    begin
      cups.Vendor := 'CPUID not available';
    end;
  result :=cups;
end;

function GetIdeDiskSerialNumber(var SerialNumber: string; var ModelNumber: string;
 var FirmwareRev: string; var TotalAddressableSectors: ULong;
 var SectorCapacity: ULong; var SectorsPerTrack: Word): Boolean; //�õ�Ӳ�������
type
 TSrbIoControl = packed record
   HeaderLength: ULong;
   Signature: array[0..7] of Char;
   Timeout: ULong;
   ControlCode: ULong;
   ReturnCode: ULong;
   Length: ULong;
 end;
 SRB_IO_CONTROL = TSrbIoControl;
 PSrbIoControl = ^TSrbIoControl;

 TIDERegs = packed record
   bFeaturesReg: Byte; // Used for specifying SMART "commands".
   bSectorCountReg: Byte; // IDE sector count register
   bSectorNumberReg: Byte; // IDE sector number register
   bCylLowReg: Byte; // IDE low order cylinder value
   bCylHighReg: Byte; // IDE high order cylinder value
   bDriveHeadReg: Byte; // IDE drive/head register
   bCommandReg: Byte; // Actual IDE command.
   bReserved: Byte; // reserved. Must be zero.
 end;
 IDEREGS = TIDERegs;
 PIDERegs = ^TIDERegs;

 TSendCmdInParams = packed record
   cBufferSize: DWORD;
   irDriveRegs: TIDERegs;
   bDriveNumber: Byte;
   bReserved: array[0..2] of Byte;
   dwReserved: array[0..3] of DWORD;
   bBuffer: array[0..0] of Byte;
 end;
 SENDCMDINPARAMS = TSendCmdInParams;
 PSendCmdInParams = ^TSendCmdInParams;

 TIdSector = packed record
   wGenConfig: Word;
   wNumCyls: Word;
   wReserved: Word;
   wNumHeads: Word;
   wBytesPerTrack: Word;
   wBytesPerSector: Word;
   wSectorsPerTrack: Word;
   wVendorUnique: array[0..2] of Word;
   sSerialNumber: array[0..19] of Char;
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
   ulCurrentSectorCapacity: ULong;
   wMultSectorStuff: Word;
   ulTotalAddressableSectors: ULong;
   wSingleWordDMA: Word;
   wMultiWordDMA: Word;
   bReserved: array[0..127] of Byte;
 end;
 PIdSector = ^TIdSector;

const
 IDE_ID_FUNCTION = $EC;
 IDENTIFY_BUFFER_SIZE = 512;
 DFP_RECEIVE_DRIVE_DATA = $0007C088;
 IOCTL_SCSI_MINIPORT = $0004D008;
 IOCTL_SCSI_MINIPORT_IDENTIFY = $001B0501;
 DataSize = sizeof(TSendCmdInParams) - 1 + IDENTIFY_BUFFER_SIZE;
 BufferSize = sizeof(SRB_IO_CONTROL) + DataSize;
 W9xBufferSize = IDENTIFY_BUFFER_SIZE + 16;
var
 hDevice: THandle;
 cbBytesReturned: DWORD;
 pInData: PSendCmdInParams;
 pOutData: Pointer; // PSendCmdOutParams
 Buffer: array[0..BufferSize - 1] of Byte;
 srbControl: TSrbIoControl absolute Buffer;

 procedure ChangeByteOrder(var Data; Size: Integer);
 var ptr: PChar;
   i: Integer;
   c: Char;
 begin
   ptr := @Data;
   for i := 0 to (Size shr 1) - 1 do
   begin
     c := ptr^;
     ptr^ := (ptr + 1)^;
     (ptr + 1)^ := c;
     Inc(ptr, 2);
   end;
 end;

begin
  Result := False;
  FillChar(Buffer, BufferSize, #0);
  if Win32Platform = VER_PLATFORM_WIN32_NT then
     begin // Windows NT, Windows 2000
    // Get SCSI port handle
       hDevice := CreateFile('\\.\Scsi0:',GENERIC_READ or GENERIC_WRITE,
         FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);
       if hDevice = INVALID_HANDLE_VALUE then Exit;
       try
         srbControl.HeaderLength := sizeof(SRB_IO_CONTROL);
         System.Move('SCSIDISK', srbControl.Signature, 8);
         srbControl.Timeout := 2;
         srbControl.Length := DataSize;
         srbControl.ControlCode := IOCTL_SCSI_MINIPORT_IDENTIFY;
         pInData := PSendCmdInParams(PChar(@Buffer)
           + sizeof(SRB_IO_CONTROL));
         pOutData := pInData;
         with pInData^ do
           begin
             cBufferSize := IDENTIFY_BUFFER_SIZE;
             bDriveNumber := 0;
             with irDriveRegs do
               begin
                 bFeaturesReg := 0;
                 bSectorCountReg := 1;
                 bSectorNumberReg := 1;
                 bCylLowReg := 0;
                 bCylHighReg := 0;
                 bDriveHeadReg := $A0;
                 bCommandReg := IDE_ID_FUNCTION;
               end;
           end;
         if not DeviceIoControl(hDevice, IOCTL_SCSI_MINIPORT,
           @Buffer, BufferSize, @Buffer, BufferSize,
           cbBytesReturned, nil) then Exit;
       finally
         CloseHandle(hDevice);
       end;
     end
  else
     begin // Windows 95 OSR2, Windows 98
       hDevice := CreateFile('\\.\SMARTVSD', 0, 0, nil,
         CREATE_NEW, 0, 0);
       if hDevice = INVALID_HANDLE_VALUE then Exit;
       try
         pInData := PSendCmdInParams(@Buffer);
         pOutData := @pInData^.bBuffer;
         with pInData^ do
           begin
             cBufferSize := IDENTIFY_BUFFER_SIZE;
             bDriveNumber := 0;
             with irDriveRegs do
               begin
                 bFeaturesReg := 0;
                 bSectorCountReg := 1;
                 bSectorNumberReg := 1;
                 bCylLowReg := 0;
                 bCylHighReg := 0;
                 bDriveHeadReg := $A0;
                 bCommandReg := IDE_ID_FUNCTION;
               end;
           end;
         if not DeviceIoControl(hDevice, DFP_RECEIVE_DRIVE_DATA,
           pInData, sizeof(TSendCmdInParams) - 1, pOutData,
           W9xBufferSize, cbBytesReturned, nil) then Exit;
       finally
         CloseHandle(hDevice);
       end;
     end;
 with PIdSector(PChar(pOutData) + 16)^ do
   begin
     ChangeByteOrder(sSerialNumber, sizeof(sSerialNumber));
     SetString(SerialNumber, sSerialNumber, sizeof(sSerialNumber)); //Ӳ���������

     ChangeByteOrder(sModelNumber, sizeof(sModelNumber));
     SetString(ModelNumber, sModelNumber, sizeof(sModelNumber)); //Ӳ���ͺ�

     ChangeByteOrder(sFirmwareRev, sizeof(sFirmwareRev));
     SetString(FirmwareRev, sFirmwareRev, sizeof(sFirmwareRev)); //Ӳ��Ӳ���汾
     Result := True;
     ChangeByteOrder(ulTotalAddressableSectors, sizeof(ulTotalAddressableSectors));
     TotalAddressableSectors := ulTotalAddressableSectors; //Ӳ��ulTotalAddressableSectors����

     ChangeByteOrder(ulCurrentSectorCapacity, sizeof(ulCurrentSectorCapacity));
     SectorCapacity := ulCurrentSectorCapacity; //Ӳ��wBytesPerSector����

     ChangeByteOrder(wNumCurrentSectorsPerTrack, sizeof(wNumCurrentSectorsPerTrack));
     SectorsPerTrack := wNumCurrentSectorsPerTrack; //Ӳ��wSectorsPerTrack����
   end;
end;

function GetMacAddr(a: integer):String;
Var
  NCB:TNCB;
  ADAPTER : TADAPTERSTATUS;
  LANAENUM : TLANAENUM;
  intIdx : Integer;
  cRC : Char;
  MacAddr : String;
Begin
  Result := '';// Initialize
  Try
    // Zero control blocl
    ZeroMemory(@NCB, SizeOf(NCB));
    // Issue enum command
    NCB.ncb_command:=Chr(NCBENUM);
    cRC := NetBios(@NCB);
    // Reissue enum command
    NCB.ncb_buffer := @LANAENUM;
    NCB.ncb_length := SizeOf(LANAENUM);
    cRC := NetBios(@NCB);
    If Ord(cRC)<>0 Then  exit;
    // Reset adapter
    ZeroMemory(@NCB, SizeOf(NCB));
    NCB.ncb_command := Chr(NCBRESET);
    NCB.ncb_lana_num := LANAENUM.lana[a];
    cRC := NetBios(@NCB);
    If Ord(cRC)<>0 Then exit;
    // Get adapter address
    ZeroMemory(@NCB, SizeOf(NCB));
    NCB.ncb_command := Chr(NCBASTAT);
    NCB.ncb_lana_num := LANAENUM.lana[a];
    StrPCopy(NCB.ncb_callname, '*');
    NCB.ncb_buffer := @ADAPTER;
    NCB.ncb_length := SizeOf(ADAPTER);
    cRC := NetBios(@NCB);
    // Convert it to string
    MacAddr := '';
    For intIdx := 0 To 5 Do
      MacAddr := MacAddr + InttoHex(Integer(ADAPTER.adapter_address[intIdx]),2);
    result:=(MacAddr);
  Finally
  End;
end;

procedure ReadReg;
var
  DT,USEDT,RegDT,DDT,TempDT:String;
  Code,ID:String;
  ECode,EID:String;  
  EDT:TDateTime;  
  Y,M,D:Word;//���������õ�����(֮���Բ���Ϊ�˼��ݸ�������ƽ̨��ʱ���ʽ�Ĳ�һ��)
  Pos:integer; //��ѯ'-'��ʱ����������λ��
  LocaleName: array[0..4] of Char;
begin
//  GetLocaleInfo(SysLocale.DefaultLCID,LOCALE_SABBREVLANGNAME,LocaleName,SizeOf(LocaleName));
//  DecodeDate(Date,Y,M,D);
//  DT:=IntToStr(Y)+'-'+IntToStr(M)+'-'+IntToStr(D);
//  DDT:=Decry(DT);
//  MyReg.OpenKey('SOFTWARE\Classes\Interface\{00000021-0000-0010-8000-00AA006D2EA4}\TypeLib',True);
{  ID:=MyReg.ReadString('CLSID');
  if ID<>'' then EID:=Encry(ID);
  CODE:=MyReg.ReadString('LIBID');
  if Code<>'' then ECode:=Encry(Code);
  AA:=ECode;
  BB:=Decry(EID+'@'+'vagrant');
  if  ((ID='')or(Code='')) or (ECode<>Decry(EID+'@'+'vagrant'))then
    begin
      IsReg:=False;
      MyReg.CloseKey;
      //��ȡ����
      }
//      MyReg.OpenKey('SOFTWARE\Classes\Interface\{00000023-0000-0010-8000-00AA006D2EA4}\TypeLib',True);
{
      RegDT:=MyReg.ReadString('GUID');
      if RegDT='' then  MyReg.WriteString('GUID',DDT)
      else
        begin
          try
            TempDT:=Encry(RegDT);
            //һһȡ��������
            Pos:=System.Pos('-',TempDT);
            Y:=StrToInt(copy(TempDT,0,Pos-1));
            TempDT:=Copy(TempDT,Pos+1,Length(TempDT));
            Pos:=System.Pos('-',TempDT);
            M:=StrToInt(copy(TempDT,0,Pos-1));
             //����һ�ξ������ˣ�����Ҫ�ٽ���Pos('-',Str)������
            TempDT:=Copy(TempDT,Pos+1,Length(TempDT));
            D:=StrToInt(TempDT);
            EDT:=EncodeDate(Y,M,D);
            if DaysBetween(EDT,Date)>=1800 then
              begin
                if System.Pos('CHT',UpperCase(LocaleName))>0  Then   Application.MessageBox('��������ð棬�ѹ���������ע�ᣬлл��','������ʾ',MB_OK+MB_ICONERROR)
                else if System.Pos('CHS',UpperCase(LocaleName))>0 then  Application.MessageBox('  ��      ন�  ��          �Ĩ�ۤۤ��','��      ',MB_OK+MB_ICONERROR)
                Else Application.MessageBox('This Software is Demo,Please Buy!','Error',MB_OK+MB_ICONERROR);
                IsOver:=True;
              end
            else if DaysBetween(EDT,Date)>=3655 then
              begin
                if System.Pos('CHT',UpperCase(LocaleName))>0 Then   Application.MessageBox(PChar('�����60�����ð棬��ʣ��'+IntToStr(60-DaysBetween(EDT,Date))+'�쵽�ڣ��빺����ʽ�棬лл��'),'������ʾ',MB_OK+MB_ICONERROR)
                else if System.Pos('CHS',UpperCase(LocaleName))>0 then  Application.MessageBox(PChar('  ��  60      ন�ѷ    '+IntToStr(60-DaysBetween(EDT,Date))+'  ��  ��  ��ǹ    ন�ۤۤ��'),'��      ',MB_OK+MB_ICONERROR)
                Else Application.MessageBox('This Software is Demo,Please Buy!','Error',MB_OK+MB_ICONERROR);
              end;
          except
            on E:Exception do
              begin
                if System.Pos('CHT',UpperCase(LocaleName))>0 Then   Application.MessageBox(PChar('��������ð棬�ѹ���������ע�ᣬлл��'),'������ʾ',MB_OK+MB_ICONERROR)
                else if System.Pos('CHS',UpperCase(LocaleName))>0 then  Application.MessageBox(PChar('  ��      ন�  ��          �Ĩ�ۤۤ��'),'��      ',MB_OK+MB_ICONERROR)
                Else Application.MessageBox('This Software is Demo,Please Buy!','Error',MB_OK+MB_ICONERROR);
                IsOver:=True;
              end;
          end;
        end;
    end
  else
    begin
      IsReg:=True;
      IsOver:=False;
    end;
  MyReg.CloseKey;
  }
end;


function GetExeSize(ExeSize:integer):Boolean;
var
  Sr: TSearchRec;
  size : Longint;
begin
  Result:=False;
  FindFirst(ParamStr(0),$27,Sr);
  size:=Sr.Size;
  FindClose(Sr);
  if (size/1024)>ExeSize then Result:=False
  else Result:=True;
end;

procedure AdjustToken;
var
  hdlProcessHandle : Cardinal;
  hdlTokenHandle   : Cardinal;
  tmpLuid          : Int64;
  tkp              : TOKEN_PRIVILEGES;
  tkpNewButIgnored : TOKEN_PRIVILEGES;
  lBufferNeeded    : Cardinal;
  Privilege        : array[0..0] of _LUID_AND_ATTRIBUTES;
begin
  hdlProcessHandle := GetCurrentProcess;
  OpenProcessToken(hdlProcessHandle,(TOKEN_ADJUST_PRIVILEGES Or TOKEN_QUERY),hdlTokenHandle);
  // Get the LUID for shutdown privilege.
  LookupPrivilegevalue('', 'SeShutdownPrivilege', tmpLuid);
  Privilege[0].Luid := tmpLuid;
  Privilege[0].Attributes := SE_PRIVILEGE_ENABLED;
  tkp.PrivilegeCount := 1;   // One privilege to set
  tkp.Privileges[0] := Privilege[0];
  // Enable the shutdown privilege in the access token of this process.
  AdjustTokenPrivileges(hdlTokenHandle,False,tkp,Sizeof(tkpNewButIgnored),tkpNewButIgnored,lBufferNeeded);
end;

function GetPCName : String ;
var
  LocalMachine: PChar;
  Len: DWord;
begin
  Len := MAX_COMPUTERNAME_LENGTH + 1; // ȡ�ñ�����������
  GetMem(LocalMachine,Len);
  if GetComputerName(LocalMachine,Len) then Result := LocalMachine
  else  Result := 'UnKnow';
  FreeMem(LocalMachine,Len);
end;

function GetIP:String;
var
  phe:pHostEnt;
  w:TWSAData;
  ip_address:longint;
  p:^longint;
  ipstr:string;
begin
  if WSAStartup(2,w)<>0 then exit;
  phe:=GetHostbyName(pchar(GetPCName));
  if phe<>nil then
    begin
      p:=pointer(phe^.h_addr_list^);
      ip_address:=p^;
      ip_address:=ntohl(ip_address);
      ipstr:=IntToStr(ip_address shr 24)+'.'+IntToStr((ip_address shr 16) and $ff)
         +'.'+IntToStr((ip_address shr 8) and $ff)+'.'+IntToStr(ip_address and $ff);
      Result :=ipstr;
    end;
end;
end.
