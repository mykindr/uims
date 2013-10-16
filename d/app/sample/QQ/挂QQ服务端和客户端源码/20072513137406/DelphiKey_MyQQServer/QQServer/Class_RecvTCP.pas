//��QQ����ˣ�����WEB���QQ�ģ��Լ������죬��������û�о���������
//����Ҫ�Ķ������Ѿ�ȡ����
//�ṩ�ó���ֻ������ѧϰĿ�ģ�ǧ��Ҫ���ڷǷ���;������Ը�
//�õ�RX�ؼ�����JCL�⣬������������
//������ܹ�QQ�Ļ����Ǿ��뿴LumqQQ�е����Э�飬�ĳ���Э�鼴��
//���и���ϣ����һ�ݸ��� QQ:709582502 Email:Touchboy@126.com 
unit Class_RecvTCP;

interface

uses
  Windows,Messages, SysUtils, Variants, Classes,ExtCtrls,Forms,
  MSWinsockLib_TLB,Class_QQTEA,Class_Record,Class_QQOUTPacket,Class_QQONLine,Class_QQDB;

Type
  TQQRecvTCP=Class
   private
     FTCPSock     :array [1..MAXTCPOnLineNum] of TWinSock;
     FOutTime     :TTimer;
     FLoginTime   :TTimer;
     FAutoReplay  :String;
     procedure OnLoginTime(Sender:TObject);
     procedure OnOutTime(Sender:TObject);

     procedure OnDataArrival(ASender: TObject; bytesTotal: Integer);
     procedure OnError(ASender: TObject; Number: Smallint;
       var Description: WideString; Scode: Integer; const Source,
       HelpFile: WideString; HelpContext: Integer;
       var CancelDisplay: WordBool);

     procedure OnSendComplete(Sender: TObject);

     procedure CloseSocket(Index:integer);
     procedure SetAutoReplay(const Value: String);

   public
     constructor Create(nLoginTime,nTimeOut:Integer;TCPForm:TComponent);
     destructor Destroy; override;

     procedure Accept(nAcceptID:integer);

     property  AutoReplay:String Read FAutoReplay Write SetAutoReplay;

     procedure ResetQQServer;

   end;

implementation

{ TQQRecvTCP }


constructor TQQRecvTCP.Create(nLoginTime,nTimeOut: Integer;TCPForm:TComponent);
var
  i:integer;
begin
  SocketNextSearch :=1;
  For i:=1 to MAXTCPOnLineNum do
  begin
    FTCPSock[i] :=TWinSock.Create(TCPForm);
    FTCPSock[i].Tag :=i;
    FTCPSock[i].OnError       :=OnError;
    FTCPSock[i].OnDataArrival :=OnDataArrival;
    FTCPSock[i].OnSendComplete:=OnSendComplete;
  end;
  FOutTime         :=TTimer.Create(Nil);
  FOutTime.Interval:=nTimeOut;
  FOutTime.OnTimer :=OnOutTime;

  FLoginTime       :=TTimer.Create(Nil);
  FLoginTime.Interval:=nLoginTime;
  FLoginTime.OnTimer :=OnLoginTime;

  FLoginTime.Enabled :=True;
  FOutTime.Enabled   :=True;
end;

destructor TQQRecvTCP.Destroy;
var
  i:integer;
begin
  FOutTime.Enabled   :=False;
  FLoginTime.Enabled :=False;

  FreeAndNil(FOutTime);
  FreeAndNil(FLoginTime);

  For i:=1 to MAXTCPOnLineNum do
  begin
    FTCPSock[i].Close;
    FreeAndNil(FTCPSock[i]);
  end;

  inherited;
end;

procedure TQQRecvTCP.OnLoginTime(Sender: TObject);
var
  i:integer;
  S:String;
begin
    For I := 1 To MAXTCPOnLineNum do
    begin
        If SockInfo[I].QQIndex <> 0 Then
        begin
            SockInfo[I].LoginI := SockInfo[I].LoginI + 1;
            If QQInfo[SockInfo[I].QQIndex].State=QsLoginSucess  Then
            begin
               { QQInfo[SockInfo[I].QQIndex].OneHour :=SockInfo[i].OneHour ;
                QQInfo[SockInfo[I].QQIndex].OneMin  :=SockInfo[i].OneMin  ;
                QQInfo[SockInfo[I].QQIndex].TwoHour :=SockInfo[i].TwoHour ;
                QQInfo[SockInfo[I].QQIndex].Twomin  :=SockInfo[i].Twomin  ;
                QQInfo[SockInfo[I].QQIndex].UserType:=SockInfo[i].UserType;
                }
                QQInfo[SockInfo[I].QQIndex].AddTime := Minute;
                SockInfo[I].QQIndex := 0;

                 S :='��'+IntTostr(SockInfo[i].OneHour)+':'+IntTostr(SockInfo[i].OneMin)+
                     '��'+IntTostr(SockInfo[i].TwoHour)+':'+IntTostr(SockInfo[i].TwoMin);

                FTCPSock[I].SendData('�һ��ɹ������� QQ ��'+S
                   +' ʱ����ڱ������ߡ�');
            end
            Else If QQInfo[SockInfo[I].QQIndex].State = QsError Then
              begin
                QQOnLine.Logout(SockInfo[I].QQIndex);
                SockInfo[I].QQIndex := 0;
                FTCPSock[I].SendData('�޷���½, ��������� QQ/���� �������');
              end
            Else If QQInfo[SockInfo[I].QQIndex].State =QsPassWordError  Then begin
                QQOnLine.Logout(SockInfo[I].QQIndex);
                SockInfo[I].QQIndex := 0;
                FTCPSock[I].SendData('QQ/���� �������, �޷���½�һ�');
            end;
            If SockInfo[I].LoginI > 20 Then
            begin
                QQOnLine.Logout(SockInfo[I].QQIndex);
                SockInfo[I].QQIndex := 0 ;
                FTCPSock[I].SendData('���� QQ ������ʱ�����������, ���Ժ����ԡ�');
            end;    
        end;
    end;
end;

procedure TQQRecvTCP.OnOutTime(Sender: TObject);
var
  i:integer;
begin
    For I := 1 To MAXTCPOnLineNum do
    begin
      If SockInfo[I].TimeoutMark <> -1 Then
      begin
          SockInfo[I].TimeoutMark := SockInfo[I].TimeoutMark + 1;
          If SockInfo[I].TimeoutMark > 50 Then
          begin
              SockInfo[I].TimeoutMark := -1;
              FTCPSock[I].Close
          end;
      end;
    end;
end;

procedure TQQRecvTCP.Accept(nAcceptID: integer);
var
  i:integer;
begin
    If SocketNextSearch > MAXTCPOnLineNum Then SocketNextSearch := 1;
    For I := SocketNextSearch To MAXTCPOnLineNum do
    begin
      If FTCPSock[I].State= 0 Then
      begin
        SockInfo[I].TimeoutMark :=0;
        FTCPSock[I].Accept(nAcceptID);
        SocketNextSearch := I + 1;
        Application.ProcessMessages;
        Exit;
      end;
    end;
    For I := 1 To SocketNextSearch - 1  do
    begin
      If FTCPSock[I].State = 0 Then
      begin
        SockInfo[I].TimeoutMark :=0;
        FTCPSock[I].Accept(nAcceptID);
        SocketNextSearch := I + 1;
        Application.ProcessMessages;
        Break;
      end;
    end;
end;


procedure TQQRecvTCP.OnError(ASender: TObject; Number: Smallint;
  var Description: WideString; Scode: Integer; const Source,
  HelpFile: WideString; HelpContext: Integer; var CancelDisplay: WordBool);
var
  index:integer;
begin
  index :=TWinSock(ASender).Tag;
  CloseSocket(Index);
end;

procedure TQQRecvTCP.OnDataArrival(ASender: TObject; bytesTotal: Integer);
var
   i,j:integer;
   hdr:String;
   Arr:String;
   Key    :array [0..15] of byte;
   Crypt  :array [0..39] of byte;
   Plain:TMYByte;
   S2Buff    :array [0..3] of byte;
   S3Buff    :array [0..1] of byte;
   Stra:String;
   index:integer;
   Buff:Array of Byte;
   v:OleVariant;
   P:Pointer;
   OneHour,OneMin,TwoHour,TwoMin,UserType:integer;
begin
    index :=TWinSock(ASender).Tag;
    If bytesTotal = 0 Then
    begin
      CloseSocket(Index);
      Exit;
    end;
    If bytesTotal <> 59 Then
    begin
      CloseSocket(Index);
      Exit;
    end;
    FTCPSock[index].GetData(v);
    SetLength(Buff,bytesTotal);
    p := VarArrayLock(V);
    try
      Move(p^, Buff[0], High(Buff)+1);
    finally
      VarArrayUnlock(V);
    end;

    CopyMemory(@Key[0],@Buff[1],16);
    CopyMemory(@Crypt[0],@Buff[18],40);
    Plain   := QQTEA.Decrypt(Crypt, Key);
    If (Plain[0] = 0) Or (Plain[0] > 4) Then
    begin
      CloseSocket(Index);
      Exit;
    end;

    If Plain[1] = 255 Then SockInfo[Index].QQAutoReply := True
       Else SockInfo[Index].QQAutoReply := False;
    If Plain[2] = 255 Then SockInfo[Index].QQHide := True
      Else SockInfo[Index].QQHide := False;
    CopyMemory(@SockInfo[Index].QQNum,@Plain[3],4);
    SockInfo[Index].QQPw :='';
    SockInfo[Index].QQAutoReply:=True;
    For I := 7 To 22 do
    begin
        If Plain[I] = 0 Then Break;
        SockInfo[Index].QQPw := SockInfo[Index].QQPw+Chr(Plain[I]);
    end;

    SockInfo[Index].OneHour :=Key[0];
    SockInfo[Index].OneMin  :=Key[1];
    SockInfo[Index].TwoHour :=Key[2];
    SockInfo[Index].Twomin  :=Key[3];
    SockInfo[Index].UserType:=Key[4];
    
    Case Plain[0] of
        1:
          begin
            For I := 1 To MAXUDPOnLineNum do
            begin
              If QQInfo[I].QQNumber = SockInfo[Index].QQNum Then
              begin
                  If QQInfo[I].QQPassword = SockInfo[Index].QQPw Then
                  begin
                      QQInfo[I].AddTime := Minute;
                      QQInfo[I].OneHour :=SockInfo[Index].OneHour ;
                      QQInfo[I].OneMin  :=SockInfo[Index].OneMin  ;
                      QQInfo[I].TwoHour :=SockInfo[Index].TwoHour ;
                      QQInfo[I].Twomin  :=SockInfo[Index].Twomin  ;
                      QQInfo[I].UserType:=SockInfo[Index].UserType;

                      FTCPSock[Index].SendData('���³ɹ�, ���� QQ ��'+QQONLine.GetOnLineTime(i)+' ʱ����ڱ������ߡ�');
                      //FTCPSock[Index].SendData('���³ɹ�, ���� QQ ������ 48 Сʱ����ʱ�䡣');
                  end
                  Else begin
                      FTCPSock[Index].SendData('��������������½ʱ����, ���˳����ٲ�����');
                      QQOnLine.LogOut(Index);
                  end;
                  Exit;
              end;
            end;
            
            For I := 1 To MAXUDPOnLineNum do
            If QQInfo[I].QQNumber = 0 Then
            begin
                {QQInfo[I].OneHour :=SockInfo[Index].OneHour ;
                QQInfo[I].OneMin  :=SockInfo[Index].OneMin  ;
                QQInfo[I].TwoHour :=SockInfo[Index].TwoHour ;
                QQInfo[I].Twomin  :=SockInfo[Index].Twomin  ;
                QQInfo[I].UserType:=SockInfo[Index].UserType;
                }
                QQOnLine.ResetServer(i);
                //If SockInfo[Index].QQAutoReply = True Then
                    QQOnLine.Login(I,SockInfo[Index].QQNum,SockInfo[Index].QQPw,
                                     SockInfo[Index].QQHide,FAutoReplay+BottomText,
                                     SockInfo[Index].Onehour,SockInfo[Index].OneMin,
                                     SockInfo[Index].Twohour,SockInfo[Index].TwoMin,
                                     SockInfo[Index].UserType );
               { Else
                    QQOnLine.Login(I,SockInfo[Index].QQNum,SockInfo[Index].QQPw,
                                     SockInfo[Index].QQHide,'',
                                     SockInfo[Index].Onehour,SockInfo[Index].OneMin,
                                     SockInfo[Index].Twohour,SockInfo[Index].TwoMin,
                                     SockInfo[Index].UserType );
                }

                QQInfo[I].AddTime := Minute;
                SockInfo[Index].LoginI  := 0;
                SockInfo[Index].LoginSessionEnabled := True;
                SockInfo[Index].QQIndex := I;
                Exit;
            End;
            FTCPSock[Index].SendData('�Բ���, ���������Ѿ���Ա');
          end;

         2:begin
             For I := 1 To MAXUDPOnLineNum do
             begin
                If QQInfo[I].QQNumber = SockInfo[Index].QQNum Then
                begin
                    If QQInfo[I].QQPassword = SockInfo[Index].QQPw Then
                    begin
                        If not QQInfo[I].QQHide  Then Hdr := '�ر�' Else Hdr := '����';
                        If QQInfo[I].QQAutoReply = '' Then Arr := '�ر�' Else Arr := '����';
                        Stra := 'QQ ����: '+IntTOStr(QQInfo[I].QQNumber)+#13#10+'�����½: '+Hdr
                             +'�Զ��ظ�: '+Arr+#13#10+'ʣ��ʱ��: '+IntToStr(QQInfo[I].AddTime + QQInfo[I].OnLineMin - Minute) + ' ����'+#13#10 +BottomText;
                        If QQInfo[I].ErrorCount <> 0 Then
                            Stra := Stra+#13#10 +'������½����: ' +IntToStr(QQInfo[I].ErrorCount) +#13#10 +'��½������Ϣ: ' +QQInfo[I].ErrorString
                        Else
                            Stra := Stra +#13#10 +'������½����: 0'+BottomText;
                        FTCPSock[Index].SendData(Stra +#13#10+BottomText);
                    end
                    Else
                        FTCPSock[Index].SendData('��������������½ʱ������' +#13#10 +#13#10 +BottomText);
                    Exit;
                end;
              end;
              FTCPSock[Index].SendData('���� QQ û���ڱ��������һ���' +#13#10 +#13#10 +BottomText);
              Exit;
            end;
          3:
            begin
              For I := 1 To MAXUDPOnLineNum do
              begin
                If QQInfo[I].QQNumber = SockInfo[Index].QQNum Then
                begin
                    If QQInfo[I].QQPassword = SockInfo[Index].QQPw Then
                    begin
                        QQOnLine.Logout(I);
                        FTCPSock[Index].SendData('���� QQ �Ѿ��ɹ��˳��һ���' +#13#10 +#13#10 +BottomText)
                    end
                    Else
                        FTCPSock[Index].SendData('��������������½ʱ������' +#13#10 +#13#10 +BottomText);
                    Exit;
                end
              end;
              FTCPSock[Index].SendData('���� QQ û���ڱ��������һ���' +#13#10 +#13#10 +BottomText);
            end;
         4:begin
             For I := 1 To MAXUDPOnLineNum do
             begin
                If QQInfo[I].QQNumber = SockInfo[Index].QQNum Then
                begin
                    QQInfo[I].QQHide := SockInfo[Index].QQHide;
                    If SockInfo[Index].QQAutoReply Then
                        QQInfo[I].QQAutoReply := FAutoReplay+#13#10 +BottomText
                    Else
                        QQInfo[I].QQAutoReply := '';
                    QQInfo[I].AddTime := Minute;
                    FTCPSock[Index].SendData('���³ɹ������� QQ ������ 24 Сʱ���ߡ�' +#13#10 +#13#10 +BottomText);
                    Exit;
                end;
             end;
             For I := 1 To MAXUDPOnLineNum do
             begin
                If QQInfo[I].QQNumber = 0 Then
                begin
                    QQInfo[I].AddTime := Minute;
                    QQOnLine.ResetServer(I);
                    If SockInfo[Index].QQAutoReply Then
                     QQOnLine.Login(I,SockInfo[Index].QQNum,SockInfo[Index].QQPw,
                                      SockInfo[Index].QQHide,FAutoReplay+BottomText,
                                      SockInfo[Index].Onehour,SockInfo[Index].OneMin,
                                      SockInfo[Index].Twohour,SockInfo[Index].TwoMin,
                                      SockInfo[Index].UserType )
                    Else
                    QQOnLine.Login(I,SockInfo[Index].QQNum,SockInfo[Index].QQPw,
                                     SockInfo[Index].QQHide,FAutoReplay+BottomText,
                                     SockInfo[Index].Onehour,SockInfo[Index].OneMin,
                                     SockInfo[Index].Twohour,SockInfo[Index].TwoMin,
                                     SockInfo[Index].UserType );
                    FTCPSock[Index].SendData('�һ��ɹ������� QQ ������ 24 Сʱ���ߡ�' +#13#10 +BottomText);
                    Exit;
                end;
             end;
             FTCPSock[Index].SendData('�Բ���, ���������Ѿ���Ա��' +#13#10 +#13#10 +BottomText);
          end;
      end;
    //SockInfo[Index.TimeoutMark := -1;
    //FTCPSock[Index].Close;
end;
procedure TQQRecvTCP.SetAutoReplay(const Value: String);
begin
  FAutoReplay := Value;
end;

procedure TQQRecvTCP.OnSendComplete(Sender: TObject);
begin
  CloseSocket(TWinSock(Sender).Tag);
end;

procedure TQQRecvTCP.CloseSocket(Index:integer);
begin
  FTCPSock[index].Close;
  SockInfo[Index].TimeoutMark := -1;
end;

procedure TQQRecvTCP.ResetQQServer;
var
  i:integer;
  nQQCount:integer;
begin
  InitSockQQ;
  QQUserDB.LoadQQInfo;
  nQQCount :=QQUserDb.DBQQNumber;
  For i:=1 to nQQCount do
  begin
    QQOnLine.Login( i,QQinfo[i].QQNumber,QQinfo[i].QQPassword,False,AutoReplay,
                                         QQinfo[i].Onehour,QQinfo[i].OneMin,
                                         QQinfo[i].Twohour,QQinfo[i].TwoMin,
                                         QQinfo[i].UserType);
    Application.ProcessMessages;                                     
    //Sleep(1500);
 end;

end;

end.
