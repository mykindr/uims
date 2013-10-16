//��QQ����ˣ�����WEB���QQ�ģ��Լ������죬��������û�о���������
//����Ҫ�Ķ������Ѿ�ȡ����
//�ṩ�ó���ֻ������ѧϰĿ�ģ�ǧ��Ҫ���ڷǷ���;������Ը�
//�õ�RX�ؼ�����JCL�⣬������������
//������ܹ�QQ�Ļ����Ǿ��뿴LumqQQ�е����Э�飬�ĳ���Э�鼴��
//���и���ϣ����һ�ݸ��� QQ:709582502 Email:Touchboy@126.com 
unit Class_QQINPacket;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,Class_QQTEA;

Type
   TQQInPacket=Class
   private

   public
     function GetPacketAbout(Const Packet: array of byte): integer;
     function GetIMPacketFrom(QQNum: Integer; Packet,
      SessionKey: array of Byte): integer;
     function GetIMPacketTime(Packet, SessionKey: array of Byte): Integer;
     function GetLoginPacketError(Packet, LoginKey: array of Byte): String;
     function GetLoginPacketRedirect(Packet,
       LoginKey: array of Byte): String;
     function GetLoginPacketSessionKey(Packet,
       PasswordKey: array of Byte): TMYByte;
     function LoginTokenReply(Packet: array of Byte): TMYByte;
   end;

var
  QQInPacket:TQQInPacket;   

implementation

{
' * <li>ͷ��
' * <ol>
' * <li>��־�ֽ�, 0x00. (==0x2)
' * <li>�������˰汾����, 0x01~0x02.
' * <li>��������, 0x03~0x04.
' * <li>�����, 0x05~0x06.
' * </ol>
' * <li>��������
' * <li>β��, 0x00. (==0x3)
' * </ol>
Option Explicit
}

Function TQQInPacket.GetPacketAbout(Const Packet:Array of byte):integer;
begin
    Result :=0;
    If High(Packet) < 17 Then Exit ;
    If Packet[3] <> 0 Then Exit;
    Case Packet[4] of
        98:
            begin
            //�����½���ƵĻظ���
            //�ж��Ƿ��� 02 00 00 00 62 ��ͷ���� 8��9 �ֽ��Ƿ�Ϊ 00 18���Լ����һ�ֽ��Ƿ�Ϊ 03����Щ��������򷵻ش���
              If High(Packet) <> 33 Then Exit;
              If (Packet[0] = 2) And (Packet[1]=0) And (Packet[2] = 0) And (Packet[3]=0)
                  And (Packet[7]=0) And (Packet[8] = 24) And (Packet[33] = 3) Then
                Result  := 1;
            end;
        34:
            //��½�ظ���
            If (Packet[0] = 2) And (Packet[High(Packet)] = 3) Then
                Result := 2;
        23:
            //���յ���Ϣ
            If (Packet[0] = 2) And (Packet[High(Packet)] = 3) Then
                  Result := 3;
        2:
            //Keep-Alive ��
            If (Packet[0] = 2) And (Packet[High(Packet)] = 3) Then
                Result := 4 ;
    end
end;

Function TQQInPacket.LoginTokenReply(Packet:Array of  Byte):TMYByte;
var
  OutputPacket:array [0..23] of Byte;
begin
    CopyMemory(@OutputPacket[0], @Packet[9], 24);
    CopyMemory(@Result[0],@OutputPacket[0],24);
end;

Function TQQInPacket.GetLoginPacketRedirect(Packet,LoginKey:Array of  Byte):String;
var
    Crypt :Array of Byte;
    Plain:TMyByte;
begin
    If High(Packet) < 17 Then Exit ;
    SetLength(Crypt,High(Packet) - 7);
    CopyMemory(@Crypt[0], @Packet[7], High(Packet) - 7);
    Plain := QQTEA.Decrypt(Crypt,LoginKey);
    If Plain[0] = 1 Then
       Result := IntToStr(Plain[5]) + '.'+IntToStr(Plain[6])+'.'+ IntToStr(Plain[7])+'.'+IntToStr(Plain[8]);
    //Result := 'sz.tencent.com';

end;

Function TQQInPacket.GetLoginPacketError(Packet,LoginKey:Array of  Byte):String;
var
    MyMessage :Array of  Byte;
    Crypt:Array of Byte;
    Plain:TMyByte;
    nLen :integer;
begin
    Result :='';
    If High(Packet) < 17 Then Exit;
    nLen := High(Packet) - 7;
    SetLength(Crypt,nLen);
    CopyMemory(@Crypt[0], @Packet[7], High(Packet) - 7);
    Plain := QQTEA.Decrypt(Crypt, LoginKey);
    If Plain[0] = 5 Then
    begin
      SetLength(MyMessage,nLen);
      CopyMemory(@MyMessage[0], @Plain[1], nLen);
      Result := String(MyMessage);
    end;
end;

Function TQQInPacket.GetLoginPacketSessionKey(Packet,PasswordKey:Array of  Byte):TMYByte;
var
  Ret :Integer;
  Crypt:Array of Byte;
  Plain,SessionKey :TMyByte;
begin
    //SetLength(SessionKey,1);
    InitArray(SessionKey);
    InitArray(Plain);

    If High(Packet) < 17 Then
    begin
      Result :=SessionKey;
      Exit;
    end;

    SetLength(Crypt,High(Packet) - 7);
    CopyMemory(@Crypt[0], @Packet[7], High(Packet)-7);
    Plain := QQTEA.Decrypt(Crypt, PasswordKey);
    //'����Ƿ���ܳɹ�
    //SetLength(SessionKey,16);
    CopyMemory( @Result[0], @Plain[1],16);
end;

Function TQQInPacket.GetIMPacketTime(Packet,SessionKey:Array of  Byte):Integer;
var
  TimeBuff :array [0..3] of Byte;
  ThisTime :Integer;
  Crypt:Array of byte;
  Plain:TMyByte;
begin
    If High(Packet) < 17 Then Exit;
    InitArray(Plain);
    //InitArray(Crypt);

    SetLength(Crypt,High(Packet) - 7);
    CopyMemory(@Crypt[0], @Packet[7], High(Packet)-7);
    Plain := QQTEA.Decrypt(Crypt, SessionKey);
    If (Plain[18] <> 0) Or (Plain[19] <> 9) And (Plain[19] <> 10) Then Exit;
    TimeBuff[3] := Plain[50];
    TimeBuff[2] := Plain[51];
    TimeBuff[1] := Plain[52];
    TimeBuff[0] := Plain[53];
    CopyMemory(@ThisTime, @TimeBuff[0],4);
    Result := ThisTime;
end;

Function TQQInPacket.GetIMPacketFrom(QQNum :Integer; Packet,SessionKey:Array of  Byte):integer;
var
  Plain:TMyByte;
  Crypt:array of Byte;
  TimeBuff :array [0..3] of Byte;
  RemoteQQNumBuff :array [0..7] of Byte;
  LocalQQNumBuff :array [0..7] of Byte;
  RemoteQQNum1 ,
  RemoteQQNum2,
  LocalQQNum1,
  LocalQQNum2 :integer;
begin
    If High(Packet) < 17 Then Exit;
    SetLength(Crypt,High(Packet) - 7);
    CopyMemory(@Crypt[0], @Packet[7], High(Packet)-7);

    //InitArray(Plain);

    Plain := QQTEA.Decrypt(Crypt, SessionKey);

    If (Plain[18] <> 0) Or (Plain[19] <> 9) And (Plain[19] <> 10) Then Exit;
    RemoteQQNumBuff[3] := Plain[0]  ;
    RemoteQQNumBuff[2] := Plain[1];
    RemoteQQNumBuff[1] := Plain[2];
    RemoteQQNumBuff[0] := Plain[3] ;
    LocalQQNumBuff[3] := Plain[4] ;
    LocalQQNumBuff[2] := Plain[5];
    LocalQQNumBuff[1] := Plain[6] ;
    LocalQQNumBuff[0] := Plain[7] ;
    RemoteQQNumBuff[7] := Plain[22]  ;
    RemoteQQNumBuff[6] := Plain[23];
    RemoteQQNumBuff[5] := Plain[24] ;
    RemoteQQNumBuff[4] := Plain[25];
    LocalQQNumBuff[7] := Plain[26]  ;
    LocalQQNumBuff[6] := Plain[27] ;
    LocalQQNumBuff[5] := Plain[28] ;
    LocalQQNumBuff[4] := Plain[29] ;
    CopyMemory(@RemoteQQNum1, @RemoteQQNumBuff[0], 4);
    CopyMemory(@RemoteQQNum2, @RemoteQQNumBuff[4], 4);
    CopyMemory(@LocalQQNum1, @LocalQQNumBuff[0], 4);
    CopyMemory(@LocalQQNum2, @LocalQQNumBuff[4], 4);
    If (QQNum = LocalQQNum1) And (LocalQQNum1 = LocalQQNum2) And (RemoteQQNum1 = RemoteQQNum2)
      Then Result  := RemoteQQNum1;
end;

initialization
   QQInPacket:=TQQInPacket.Create;
finalization
  FreeAndNil(QQInPacket);

end.
