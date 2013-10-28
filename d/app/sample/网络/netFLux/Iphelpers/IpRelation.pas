{===================Unit IpRelation Edit by Oldseven 12.3.2003=================}
{==============================================================================}
unit IpRelation;

interface
uses
   Windows,
   SysUtils,
   Classes,
   Dialogs,
   Variants,
   Chart,
   Registry,
   IPExport,
   IPHlpApi,
   Iprtrmib,
   IpTypes,
   IpFunctions;

type  TiFaceInfo = Record
      CardIndex      : DWORD;  // iface����
      BIn            : DWORD;  // ������ֽ���
      BOut           : DWORD;  // ��ȥ���ֽ���

      pBin           : DWORD;  // ����Ĺ㲥��
      pubIn          : DWORD;  // ����ķǹ㲥��
      pbOut          : DWORD;  // �����Ĺ㲥��
      pubOut         : DWORD;  // �����ķǹ㲥��

      nSpeed         : DWORD;  // ���粨���� ��ʽ��

      inNetUseRate   : Double;   // ��������縺���� ��ʽ��bIn*8 div nSpeed
      outNetUseRate  : Double;   // ���������縺���� ��ʽ��bOut*8 div nSpeed
      netUseRate     : Double;   // �ۺ����縺����   ��ʽ��(bIn+bOut)*8 div (nSpeed*2)

      inBroastRate   : Double;   // ����㲥�������� ��˾��pubIn div (pbIn+pubIn)
      outBroastRate  : Double;   // �����㲥�������� ��˾��pubOut div (pbOut+pubOut)
end;


procedure getIfaceTableInfo(var TifaceIndexs:TStrings);
procedure getIfaceIfRowInfo(CardIndex:LongInt;var iFaceInfo:TiFaceInfo);

procedure getMAXpackInout(ifaceInfo:TiFaceInfo;TypeI:integer;ChartTag:integer;var packetsIn ,packetsOut,packetsFL:Double);
procedure TimerOnTime(iFaceInfo:TiFaceInfo;Typei:integer;var Chart1:TChart);
procedure beginGetTheGrp(iFaceInfo:TiFaceInfo;Typei:integer;var Chart1: TChart);
procedure initTempStru(CardI,TypeI:Integer);
function  newGetIfaceInfo(StrID:String):String;
Function getNetCardIndex(StrNetID:String):String;
implementation

CONST
  MaxTime =60; // 1 minutes
  MaxVal  = MaxTime;  // two reads per second

  MAXChartN = 20;

  //��ʱ������ݵĽṹ
  type TTempInfo = Record
      tmpIn     : Array[1..MAXChartN,0..2] of Double;
      tmpOut    : Array[1..MAXChartN,0..2] of Double;
      tmpFL     : Array[1..MAXChartN,0..2] of Double;

      tmpPBin   : Array[1..MAXChartN,0..2] of Double;
      tmpPubIn  : Array[1..MAXChartN,0..2] of Double;
      tmpPbOut  : Array[1..MAXChartN,0..2] of Double;
      tmpPubOut : Array[1..MAXChartN,0..2] of Double;
  end;

  var
   P            : Array[1..MAXChartN] of Integer;
   indexN       : Integer;
   Times        : Integer;
   TempInfo     : TTempInfo;
   dataIn, dataOut,dataFL : Array[0..MAXChartN,0..MaxVal+1] of Double;

//----------------------By 12.10 oldseven --------------------------------------
// Get iface Index Like as 1,2666359 of the netCark index in the ifaceTable
// Param StrNetID : like as {1233323-122asdf-23232323} in the Registry
//------------------------------------------------------------------------------
Function getNetCardIndex(StrNetID:String):String;
var
  PAdapter, PMem: PipAdapterInfo;
  pPerAdapter: PIpPerAdapterInfo;
  OutBufLen: ULONG;
begin
  VVGetAdaptersInfo(PAdapter, OutBufLen);
  PMem := PAdapter;

  try
    while PAdapter <> nil do
    begin
      if  CompareText(String(Padapter.AdapterName),StrNetID)=0 then
          Result:=FloatToStr(Padapter.Index);
      PAdapter := PAdapter.Next;
    end;
  finally
    if PAdapter <> nil then
      Freemem(PMem, OutBufLen);
  end;
end;

//==============================================================================
//  �õ� ifaceTable�еĸ����ӿڵ������ţ����ַ������浽���� TifaceIndexs ��
//==============================================================================

procedure getIfaceTableInfo(var TifaceIndexs:TStrings);
var
  PAdapter, PMem: PipAdapterInfo;
  pPerAdapter: PIpPerAdapterInfo;
  OutBufLen: ULONG;
  ConnName:String;
begin
  VVGetAdaptersInfo(PAdapter, OutBufLen);
  PMem := PAdapter;
  TifaceIndexs.Clear;
  try
    while PAdapter <> nil do
    begin
      Case PAdapter.Type_  of
          23:TifaceIndexs.Add(FloatToStr(PAdapter.Index)+'='+'��������ӿ�');
          24:;
           6:begin
              ConnName:=newGetIfaceInfo(PAdapter.AdapterName);
              TifaceIndexs.Add(FloatToStr(PAdapter.Index)+'='+ConnName);
            end;
      else
          TifaceIndexs.Add(FloatToStr(PAdapter.Index)+'='+'��������ӿ�');
      end;

      PAdapter := PAdapter.Next;
    end;
  finally
    if PAdapter <> nil then
      Freemem(PMem, OutBufLen);
  end;
end;

{procedure getIfaceTableInfo(var TifaceIndexs:TStrings);
var
  p: PMibIfTable;
  Size: Cardinal;
  i,j: integer;
  s: string;
begin
  try

    VVGetIfTable(p,Size,True);
    if p <> nil then
    try
      J:=p^.dwNumEntries;

      for i := 0 to J-1 do
      with p^.table[i] do
      begin
        if dwType<>24 then  // �ǻ�·   �ӿ�����           �ӿ�����
           TifaceIndexs.Add(FloatTostr(dwIndex)+'='+String(wszName));
      end;
    except

    end;
  finally
      FreeMem(p, size);
  end;
end; }
//==============================================================================
// ���ݲ��� CardIndex �õ��� cardIndex�����ŵĽӿ���ϸ��Ϣ�������ṹ iFaceInfo��
//==============================================================================
procedure getIfaceIfRowInfo(CardIndex:LongInt;var iFaceInfo:TiFaceInfo);
var
  IfRow: TMibIfRow;
  j: integer;
  tmpD:Double;
begin
  FillChar(IfRow,sizeof(IfRow),#0);
  IfRow.dwIndex := CardIndex;
  VVGetIfEntry(@IfRow);

  ifaceInfo.CardIndex := CardIndex;
  iFaceInfo.BIn := IfRow.dwInOctets ;
  ifaceInfo.BOut := ifRow.dwOutOctets ;

  ifaceInfo.pBin := ifRow.dwInUcastPkts;
  ifaceInfo.pubIn :=ifRow.dwInNUcastPkts;
  ifaceInfo.pbOut := ifRow.dwOutUcastPkts;
  ifaceInfo.pubOut :=ifRow.dwOutNUcastPkts;
  ifaceInfo.nSpeed :=ifRow.dwSpeed;

  {ifaceInfo.inNetUseRate :=  ifaceInfo.Bin * (8 / ifaceInfo.nSpeed);//bIn*8 div nSpeed
  ifaceInfo.outNetUseRate:= ifaceInfo.BOut *(8 / ifaceInfo.nSpeed) ;// ���������縺���� ��ʽ��bOut*8 div nSpeed
  tmpD:= (ifaceInfo.BIn + IfaceInfo.BOut)*(4 / (ifaceInfo.nSpeed));
  ifaceInfo.netUseRate:=tmpD; // �ۺ����縺����   ��ʽ��(bIn+bOut)*8 div (nSpeed*2)
  //ifaceInfo.netUseRate:=(ifaceInfo.inNetUseRate+ifaceInfo.outNetUseRate)/2;
  ifaceInfo.inBroastRate   :=1000*(ifaceInfo.pubIn / (IfaceInfo.pBin + ifaceInfo.pubIn));   // ����㲥�������� ��˾��pubIn div (pbIn+pubIn)
  ifaceInfo.outBroastRate  :=1000*(ifaceInfo.pubOut / (IfaceInfo.pbOut +IfaceInfo.pubOut));   //pubOut div (pbOut+pubOut)
   }
end;
//==============================================================================
//  (�ⲿ�������)    //�˹��̺���ã�Timer1.Enabled := true;
//  ��ʼ��Chart�������   beginGetTheGrp;
//  ������     iFaceInfo:TiFaceInfo; -- ����Ľṹ���ӿ���Ϣ��
//             Typei:integer; 0 : outIn 2��Seiros(����)    //FormIndex : �����������
//                            1 : Borst 2��Seiros(����)    //ChartIndex��Chart�ڴ����������
//                            2 : netFL 3��Seiros(����)
//             Chart1:        ����ģ������� TChart
//==============================================================================
procedure beginGetTheGrp(iFaceInfo:TiFaceInfo;Typei:integer;var Chart1: TChart);
var i:integer;
   x:double;
begin
   // initialize temp Stru
   initTempStru(Chart1.Tag,TypeI);
   // initialize packet counts
   getMAXpackInout(iFaceInfo,TypeI,Chart1.Tag,dataIn[Chart1.Tag,P[Chart1.Tag]], dataOut[Chart1.Tag,P[Chart1.Tag]],dataFL[Chart1.Tag,p[Chart1.Tag]]);

   if ((Chart1.Tag mod 3) =1) then
   begin
      x:= (IfaceInfo.nSpeed/8000);

      Chart1.LeftAxis.Minimum := 0;
      Chart1.LeftAxis.MAximum := x;
   end;


   // initialize values
   for i := 0 to MaxVal do begin
       dataOut[Chart1.Tag,i] := 0;
       dataIn[Chart1.Tag,i]  := 0;
       dataFL[Chart1.Tag,i]  := 0;
       Chart1.SeriesList.Series[0].Add(dataOut[Chart1.Tag,i]);
       Chart1.SeriesList.Series[1].Add(dataIn[Chart1.Tag,i]);
       if TypeI=2 then
       CHart1.SeriesList.Series[2].Add(dataFL[Chart1.Tag,i]);
   end;
   P[Chart1.Tag] := 0;
end;

//==============================================================================
// �õ���ǰ����������  getMAXpackInout
// ���أ�packetsIn,packetsOut,packetsFL: ���ߵ���  ifaceInfo:TiFaceInfo
//             Typei:integer; 0 : outIn 2��Seiros(����)
//                            1 : Borst 2��Seiros(����)
//                            2 : netFL 3��Seiros(����)
//==============================================================================
procedure getMAXpackInout(ifaceInfo:TiFaceInfo;TypeI:integer;ChartTag:integer;var packetsIn , packetsOut, packetsFL:Double);
var
  j: integer;
  s: string;
  xIn, xOut,xFL                :   Double;
  vPBin,vPubIn,vPbOut,vPubOut  :   Double;
begin
  if ifaceInfo.CardIndex <0 then Exit;

  if  TypeI = 0 then   // �����ڰ�
  begin
     xIn:=ifaceInfo.BIn;
     xOut:=ifaceInfo.BOut;
     packetsOut := (xOut - TempInfo.tmpOut[ChartTag,TypeI]) / 1024 ;  if packetsOut<0 then packetsOut := 0;
     packetsIn  := (xIn - TempInfo.tmpIn[ChartTag,TypeI]) / 1024 ;    if packetsIn <0  then packetsIn := 0;

     tempInfo.tmpIn[ChartTag,TypeI]    := ifaceInfo.BIn;
     tempInfo.tmpOut[ChartTag,TypeI]   := ifaceInfo.BOut;
  end
  else if TypeI=1 then  // �㲥��������
  begin
     vPubIn:=ifaceInfo.pubIn - TempInfo.tmpPubIn[ChartTag,TypeI];
     vPbin := ifaceInfo.pBin - TempInfo.tmpPBin[ChartTag,TypeI];
     if (VpBin+vPubIn)=0 then Xin:=0 else
     xIn:=(vPubIn/(vPBin+vPubIn))*100;

     vPubOut:=ifaceInfo.pubOut - TempInfo.tmpPubOut[ChartTag,TypeI];
     vPbOut := ifaceInfo.pbOut - TempInfo.tmpPbOut[ChartTag,TypeI];
     if (vPbOut+vPubOut)=0 then Xout:=0 else
     xOut:=(vPubOut/(vPbOut+vPubOut))*100;

     packetsOut := (xOut);
     packetsIn  := (xIn );


     tempInfo.tmpPubIn[ChartTag,TypeI] := IfaceInfo.PubIn;
     tempInfo.tmpPbin[ChartTag,TypeI]  := IfaceInfo.pBin ;
     tempInfo.tmpPubOut[ChartTag,TypeI]:= IfaceInfo.PubOut;
     tempInfo.tmpPbOut[ChartTag,TypeI] := IfaceInfo.PbOut;

  end
  else if TypeI=2 then  // ���縺����
  begin
    if (IfaceInfo.nSpeed =0) then
    begin
     xin:=0; xOut:=0;xFL:=0;
    end
    else
    begin
    xIn:= (ifaceInfo.Bin- TempInfo.tmpIn[ChartTag,TypeI])*(8/ifaceInfo.nSpeed);
    xOut:=(ifaceInfo.BOut -TempInfo.tmpOut[ChartTag,TypeI])*(8/ifaceInfo.nSpeed);
    xFL:= (ifaceInfo.BIn - TempInfo.tmpIn[ChartTag,TypeI]+ ifaceInfo.BOut-TempInfo.tmpOut[ChartTag,TypeI])*(4/ifaceInfo.NSpeed);
    end;
    packetsOut := (xOut)*100;
    packetsIn  := (xIn)*100;
    packetsFL  := (xFL)*100;

    tempInfo.tmpIn[ChartTag,TypeI]    := ifaceInfo.BIn;
    tempInfo.tmpOut[ChartTag,TypeI]   := ifaceInfo.BOut;
  end;

  // save new base
  {tempInfo.tmpIn[ChartTag,TypeI]    := ifaceInfo.BIn;
  tempInfo.tmpOut[ChartTag,TypeI]   := ifaceInfo.BOut;

  tempInfo.tmpPubIn[ChartTag,TypeI] := IfaceInfo.PubIn;
  tempInfo.tmpPbin[ChartTag,TypeI]  := IfaceInfo.pBin ;
  tempInfo.tmpPubOut[ChartTag,TypeI]:= IfaceInfo.PubOut;
  tempInfo.tmpPbOut[ChartTag,TypeI] := IfaceInfo.PbOut; }
end;

//==============================================================================
//   ����ˢ�µĺ���
//  ������     iFaceInfo:TiFaceInfo; -- ����Ľṹ���ӿ���Ϣ��
//             Typei:integer; 0 : outIn 2��Seiros(����)
//                            1 : Borst 2��Seiros(����)
//                            2 : netFL 3��Seiros(����)
//             Chart1:        ����ģ������� TChart
//==============================================================================
procedure TimerOnTime(iFaceInfo:TiFaceInfo;Typei:integer;var Chart1:TChart);
Var
   i : Integer;
begin
   // shift all values left
   if p[Chart1.Tag]>=MaxVal then
   begin
      Move(dataOut[Chart1.tag,1], dataOut[Chart1.tag,0], MaxVal*sizeOf(Double));
      Move(dataIn[Chart1.tag,1],  dataIn[Chart1.tag,0],  MaxVal*sizeOf(Double));
      if TypeI=2 then
      Move(dataFL[Chart1.tag,1],  dataFL[Chart1.tag,0],  MaxVal*sizeOf(Double));
   end;

   // latest value
   getMAXpackInout(iFaceInfo,TypeI,Chart1.tag,dataIn[Chart1.tag,P[Chart1.tag]], dataOut[Chart1.tag,P[Chart1.tag]],dataFL[Chart1.tag,p[Chart1.tag]]);

   // display all values
   for i := 0 to MaxVal do begin
      Chart1.SeriesList.Series[0].YValue[i] := dataOut[Chart1.tag,i];
      Chart1.SeriesList.Series[1].YValue[i] := dataIn[Chart1.tag,i];
      if TypeI=2 then
      CHart1.SeriesList.Series[2].YValue[i] := DataFL[Chart1.tag,i];
   end;
   if p[Chart1.Tag]<MaxVal then inc(P[Chart1.Tag]);
end;
//==============================================================================
//
//==============================================================================
procedure initTempStru(CardI,TypeI:Integer);
begin
    tempInfo.tmpIn[CardI,typeI]:=0;
    tempInfo.tmpOut[CardI,TypeI]:=0;
    tempInfo.tmpFL[CardI,TypeI]:=0;
    tempInfo.tmpPBin[CardI,TypeI]:=0;
    tempInfo.tmpPubIn[CardI,TypeI]:=0;
    tempInfo.tmpPbOut[CardI,TypeI]:=0;
    tempInfo.tmpPubOut[CardI,TypeI]:=0;
end;
//*************************************************************************************
//
//*************************************************************************************
//------------------------------------------------------------------------------
// NameType         0 -- iDriverDesc
//                  1--iConnName
//                  2 -- iIpAddress
//                  iIPMask     = 3; // Ip's netMask 
//------------------------------------------------------------------------------
function newGetIfaceInfo(StrID:String):String;
const
  NetWorkReg ='SYSTEM\CurrentControlSet\Control\Network\';
  DevInfoReg ='SYSTEM\CurrentControlSet\Enum\';
  IPAddreReg ='SYSTEM\CurrentControlSet\Services\';
var
  Reg:TRegistry;
  DevList,IfaceList :TStringList;
  RegPath ,RegPath1:String;
  IfaceName,InstanceID,tmpStr :String;
  i,c:integer;


  S:Array[0..15*128] of Char;
  IPList:TStrings;
  DHCPFlag:Boolean;

begin
  try
    DHCPFlag:=False;
    Result:='';
    Reg := TRegistry.Create;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    DevList :=TStringList.Create;
    IfaceList := TStringList.Create;
    IpList := TStringList.Create;
    try
    reg.OpenKeyReadOnly(NetWorkReg);
    reg.GetKeyNames(DevList);
    for i:= 0 to DevList.Count -1 do
    begin
        RegPath :=  NetWorkReg + DevList.Strings[i];
        Reg.CloseKey;
        if not Reg.OpenKey(RegPath,false) then Continue;
        tmpStr := Reg.ReadString('Class');
        if  Reg.ValueExists('Class') then
        begin
            IfaceName := Reg.ReadString('Class');
            if AnsiCompareText(ifaceName,'Net') = 0 then break;
        end;
    end;
    if i < DevList.Count then //������
    begin
         try
          Reg.GetKeyNames(IfaceList);
          if (IfaceList.Count = 0 ) then
          begin
            Result := StrID; Exit;
          end;
          RegPath1 := RegPath +  '\' + StrID + '\Connection' ;
          Reg.CloseKey ;
          if not Reg.OpenKey(RegPath1,false) then
          begin
              Result:=StrID; Exit;
          end;
          IfaceName := Reg.ReadString('Name');
          Result:=IFaceName
          except
             Result:=StrID;
          end;
    end
    else
    begin
        Result := StrID;  Exit;
    end;
    except
       Result := StrID;
    end;
  finally
    IpList.free;
    DevList.Free;
    IfaceList.Free;
    Reg.closeKey;
    Reg.Free;
  end;
end;
end.
