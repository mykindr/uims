unit Unit4;
////���ƴ�ӡ��unit
//download by http://www.codefans.net
interface
uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB, Grids, DBGrids,strutils;

procedure printData(adoQuery1:Tadoquery;var f:textfile);
implementation


procedure writeHalfLn(var f:textfile);
begin
Write(f,chr(27)+chr(74)+chr(15));
end;




function space(count:integer):string;
var
  str:string;
  i:integer;
begin
  str:='';
  for i:=1 to count do
  begin
    str:=str+' ';
  end;
  result:=str;
end;
function getWideString(strdata:string;strSpace:string):string;
var
  i:integer;
  len:integer;
  //strReturn:string;
begin
  result:='';
  len:=length(strdata);
  for i:=1 to len do
  begin
    result:=result+midbstr(strdata,i,1);
    if (i<>len) then
    begin
      result:=result+strSpace;
    end;
  end;
end;


procedure writeWideString(strdata:string;int:integer;var f:textfile);
var
  i:integer;
  len:integer;
  //strReturn:string;
begin
  //result:='';
  len:=length(strdata);
  for i:=1 to len do
  begin
    write(f,midbstr(strdata,i,1));
    //result:=result+midbstr(strdata,i,1);
    if (i<>len) then
    begin
      //result:=result+strSpace;
      Write(f,chr(27)+chr(92)+chr(int)+chr(00));
    end;
  end;
end;
procedure printData(adoQuery1:tadoquery;var f:textfile);
var
  apNumber:string;
  custName:string;
  checkDuiGong:string;
  UNITCODE:string;
  idCODE:string;
  i:integer;
  itemp:integer;
  itemp2:integer;
  stemp:string;

  i2:integer;
begin
  ////�걨��
  apNumber:=ADOQuery1.FieldByName('apNumber').AsString;


  stemp:=midbstr(apNumber,1,6);
  //�Ƶ�����5.2cm��
  itemp:=round(5.2/2.54*60);
  Write(f,chr(27)+chr(36)+chr(itemp)+chr(0));
  //д�м����ַ���,i2������Ϊi2*1/180Ӣ��.����Ϊ0.3cm
  i2:=21;
  writeWideString(stemp,i2,f);

  stemp:=midbstr(apNumber,7,4);
  //�Ƶ�����8.9cm��
  itemp:=round(8.9/2.54*60);
  itemp2:=0;
  if(itemp>255) then
  begin
    itemp2:=itemp div 256;
    itemp:=itemp mod 256;
  end;
  Write(f,chr(27)+chr(36)+chr(itemp)+chr(itemp2));
  //д�м����ַ���,i2������Ϊi2*1/180Ӣ��.����Ϊ0.3cm
  i2:=21;
  writeWideString(stemp,i2,f);

  stemp:=midbstr(apNumber,11,2);
  //�Ƶ�����11.6cm��
  itemp:=round(11.6/2.54*60);
  itemp2:=0;
  if(itemp>255) then
  begin
    itemp2:=itemp div 256;
    itemp:=itemp mod 256;
  end;
  Write(f,chr(27)+chr(36)+chr(itemp)+chr(itemp2));
  //д�м����ַ���,i2������Ϊi2*1/180Ӣ��.����Ϊ0.3cm
  i2:=21;
  writeWideString(stemp,i2,f);

  stemp:=midbstr(apNumber,13,6);
  //�Ƶ�����5.2cm��
  itemp:=round(13.4/2.54*60);
  itemp2:=0;
  if(itemp>255) then
  begin
    itemp2:=itemp div 256;
    itemp:=itemp mod 256;
  end;
  Write(f,chr(27)+chr(36)+chr(itemp)+chr(itemp2));
  //д�м����ַ���,i2������Ϊi2*1/180Ӣ��.����Ϊ0.3cm
  i2:=21;
  writeWideString(stemp,i2,f);

  stemp:=midbstr(apNumber,19,4);
  //�Ƶ�����5.2cm��
  itemp:=round(17.1/2.54*60);
  itemp2:=0;
  if(itemp>255) then
  begin
    itemp2:=itemp div 256;
    itemp:=itemp mod 256;
  end;
  Write(f,chr(27)+chr(36)+chr(itemp)+chr(itemp2));
  //д�м����ַ���,i2������Ϊi2*1/180Ӣ��.����Ϊ0.3cm
  i2:=21;
  writeWideString(stemp,i2,f);

  writeln(f);
  //stemp:=getWideString(stemp,'  ');
  //write(f,Space(26)+stemp);
  {
  stemp:=midbstr(apNumber,7,4);
  stemp:=getWideString(stemp,'  ');
  write(f,Space(4)+stemp);

  stemp:=midbstr(apNumber,11,2);
  stemp:=getWideString(stemp,'  ');
  write(f,Space(4)+stemp);

  stemp:=midbstr(apNumber,13,6);
  stemp:=getWideString(stemp,'  ');
  write(f,Space(4)+stemp);

  stemp:=midbstr(apNumber,19,4);
  stemp:=getWideString(stemp,'  ');
  write(f,Space(4)+stemp);

  writeln(f);
  }
  //midbstr(apNumber,1,1)
  //Write(f,chr(27)+chr(74)+chr($CF)+chr($00));
  //writeln(f,Space(26)+apNumber);

  ////�տ�������
  //��2��
  writeln(f);
  custName:=ADOQuery1.FieldByName('custName').AsString;
  //Write(f,chr(27)+chr(ord('\'))+chr($CF)+chr($00));
  writeln(f,space(26)+custName);

  ////�Թ�,��֯��������
  writeln(f);
  //��4.5��
  ///writehalfln(f);
  writeln(f);
  UNITCODE:=ADOQuery1.FieldByName('UNITCODE').AsString;
  if  (trim(UNITCODE)<>'') then
  begin
    write(f,space(10)+'��');

    ////��֯��������
    stemp:=midbstr(UNITCODE,1,8);
    //stemp:=unitcode;
    //�Ƶ�����5.2cm��
    itemp:=round(10.6/2.54*60);
    itemp2:=0;
    if(itemp>255) then
    begin
      itemp2:=itemp div 256;
      itemp:=itemp mod 256;
    end;
    Write(f,chr(27)+chr(36)+chr(itemp)+chr(itemp2));
    //д�м����ַ���,i2������Ϊi2*1/180Ӣ��.����Ϊ0.3cm
    i2:=round(0.37/2.54*180);
    writeWideString(stemp,i2,f);

    stemp:=midbstr(UNITCODE,9,1);
    //stemp:=unitcode;
    //�Ƶ�����5.2cm��
    itemp:=round(15.8/2.54*60);
    itemp2:=0;
    if(itemp>255) then
    begin
      itemp2:=itemp div 256;
      itemp:=itemp mod 256;
    end;
    Write(f,chr(27)+chr(36)+chr(itemp)+chr(itemp2));
    //д�м����ַ���,i2������Ϊi2*1/180Ӣ��.����Ϊ0.3cm
    i2:=round(0.37/2.54*180);
    writeWideString(stemp,i2,f);

    writeln(f);
    //writeln(f,space(10)+'��'+space(44)+UNITCODE);
  end
  //������ǶԹ���,ֱ�������
  else
  begin
    writeln(f);
  end;
  //��6.5��
  ///writehalfln(f);

  ////��˽,�������֤��,�Ƿ��й�����
  writeln(f);
  idCODE:=ADOQuery1.FieldByName('idCODE').AsString;
  if  trim(idCODE)<>'' then
  begin

     //�ڶ�˽�ϴ�,������
    write(f,space(10)+'��');
    //����������֤����
    writeln(f,space(41)+trim(idcode));




    //��"�й��������"�ϴ���'v'.
    if  trim(ADOQuery1.FieldByName('custype').AsString)='D' then
    begin
      writeln(f,space(27)+'��');
    end
    else
    begin
    writeln(f,space(63)+'��');
    end;
  end
  else
  begin
    writeln(f);
    writeln(f);
  end;

  ////���㷽ʽ
  //��11��
  writeln(f);



  {writeln(f,space(27)+'��');
  writeln(f,space(40)+'��');
  writeln(f,space(54)+'��');
  writeln(f,space(65)+'��');
  writeln(f,space(76)+'��');
  writeln(f,space(86)+'��');
  writeln(f,space(97)+'��');
  }
  if  trim(ADOQuery1.FieldByName('paymethod').AsString)='L' then
  begin
    writeln(f,space(27)+'��');
  end
  else if  trim(ADOQuery1.FieldByName('paymethod').AsString)='C' then
  begin
    writeln(f,space(40)+'��');
  end
  else if  trim(ADOQuery1.FieldByName('paymethod').AsString)='G' then
  begin
    writeln(f,space(54)+'��');
  end
  else if  trim(ADOQuery1.FieldByName('paymethod').AsString)='T' then
  begin
    writeln(f,space(65)+'��');
  end
  else if  trim(ADOQuery1.FieldByName('paymethod').AsString)='D' then
  begin
    writeln(f,space(76)+'��');
  end
  else if  trim(ADOQuery1.FieldByName('paymethod').AsString)='M' then
  begin
    writeln(f,space(86)+'��');
  end
  else
  begin
    writeln(f,space(97)+'��');
  end;

  ////�������ּ����
  writeln(f);
  writeln(f,space(33)+trim(ADOQuery1.FieldByName('TXCCY').AsString)+space(2)+trim(ADOQuery1.FieldByName('txamt').AsString));

  ////���������п���,���Ϊ0.00(��˵�˺�Ϊ��)����ʾ
  writeln(f);
  //��15��
  writeln(f);
  if(trim(ADOQuery1.FieldByName('lcyacc').AsString)<>'')then
  begin
     writeln(f,space(33)+trim(ADOQuery1.FieldByName('lcyamt').AsString)+space(37)+trim(ADOQuery1.FieldByName('lcyacc').AsString));
  end
  else
  begin
    //writeln(f,space(32)+trim(ADOQuery1.FieldByName('lcyamt').AsString)+space(42)+trim(ADOQuery1.FieldByName('lcyacc').AsString));
    writeln(f);
  end;
  ////�ֻ�������п���
  writeln(f);
  if(trim(ADOQuery1.FieldByName('fcyacc').AsString)<>'')then
  begin
     writeln(f,space(33)+trim(ADOQuery1.FieldByName('fcyamt').AsString)+space(37)+trim(ADOQuery1.FieldByName('fcyacc').AsString));
  end
  else
  begin
    //writeln(f,space(32)+trim(ADOQuery1.FieldByName('fcyamt').AsString)+space(42)+trim(ADOQuery1.FieldByName('fcyacc').AsString));
    writeln(f);
  end;
  //writeln(f,space(32)+trim(ADOQuery1.FieldByName('fcyamt').AsString)+space(42)+trim(ADOQuery1.FieldByName('fcyacc').AsString));

  ////�����������п���
  writeln(f);
  //��20��
  writeln(f);
  if(trim(ADOQuery1.FieldByName('othacc').AsString)<>'')then
  begin
     writeln(f,space(33)+trim(ADOQuery1.FieldByName('othamt').AsString)+space(37)+trim(ADOQuery1.FieldByName('othacc').AsString));
  end
  else
  begin
    //writeln(f,space(32)+trim(ADOQuery1.FieldByName('lcyamt').AsString)+space(42)+trim(ADOQuery1.FieldByName('lcyacc').AsString));
    writeln(f);
  end;

  //writeln(f,space(32)+trim(ADOQuery1.FieldByName('othamt').AsString)+space(42)+trim(ADOQuery1.FieldByName('othacc').AsString));

  ////����,�������п۷ѱ��ּ����
  writeln(f);
  writeln(f,space(32)+trim(ADOQuery1.FieldByName('INCHARGECCY').AsString)+space(2)+trim(ADOQuery1.FieldByName('INCHARGEamt').AsString)+space(37)+trim(ADOQuery1.FieldByName('OUTCHARGECCY').AsString)+space(2)+trim(ADOQuery1.FieldByName('OUTCHARGEamt').AsString));

  ////����������
  writeln(f);
  //��25��
  writeln(f,space(26)+trim(ADOQuery1.FieldByName('OPPNAME').AsString));

  ////�����˳�ס���Ҽ�����   �걨����
  writeln(f);
  writeln(f);
  ///writeln(f,space(34)+trim(ADOQuery1.FieldByName('countryCodeName.countryName').AsString)+space(16)+trim(ADOQuery1.FieldByName('COUNTRYCODE').AsString)+space(22)+trim(ADOQuery1.FieldByName('RPTDATE').AsString));
  itemp:=52-length(trim(ADOQuery1.FieldByName('countryCode').AsString));
  if(itemp<0) then itemp:=0;
  write(f,space(itemp)+trim(ADOQuery1.FieldByName('countryCode').AsString));

  //���Ҵ���
  stemp:=trim(ADOQuery1.FieldByName('COUNTRYCODE').AsString);
  //�Ƶ�����5.2cm��
  itemp:=round(10.2/2.54*60);
  itemp2:=0;
  if(itemp>255) then
  begin
    itemp2:=itemp div 256;
    itemp:=itemp mod 256;
  end;
  Write(f,chr(27)+chr(36)+chr(itemp)+chr(itemp2));
  //д�м����ַ���,i2������Ϊi2*1/180Ӣ��.����Ϊ0.3cm
  i2:=round(0.42/2.56*180);
  writeWideString(stemp,i2,f);

  //stemp:=trim(ADOQuery1.FieldByName('rptdate').AsString);
  write(f,space(15)+trim(ADOQuery1.FieldByName('rptdate').AsString));

  writeln(f);
  //writeln(f,space(34)+trim(ADOQuery1.FieldByName('countryName').AsString)+space(2)+trim(ADOQuery1.FieldByName('COUNTRYCODE').AsString)+space(22)+trim(ADOQuery1.FieldByName('RPTDATE').AsString));


  ////�Ƿ�Ԥ�ո�����˿�
  writeln(f);
  //�����ǵ�30��
  if  trim(ADOQuery1.FieldByName('paytype').AsString)='A' then
  begin
    writeln(f,space(53)+'��');
  end
  else
  begin
    writeln(f,space(82)+'��');
  end;

  ////�Ƿ�Ϊ���������ջ�
  writeln(f);

  if  trim(ADOQuery1.FieldByName('iswriteoff').AsString)='Y' then
  begin
    writeln(f,space(53)+'��');
  end
  else
  begin
    writeln(f,space(82)+'��');
  end;
  
  writeln(f);
  //��ծ���
  writeln(f);
  //��35��
  writeln(f,space(26)+trim(ADOQuery1.FieldByName('BILLNO').AsString));

  ////���ױ���,��Ӧ���ּ����,���׸��� ���Ϊ0.00(��˵���ױ���Ϊ��)����ʾ
  writeln(f);
  //writeln(f);
  if(trim(ADOQuery1.FieldByName('txcode1').AsString)<>'')then
  begin

     write(f,space(19));
     //д�м����ַ���,i2������Ϊi2*1/180Ӣ��.����Ϊ0.3cm
     i2:=round(0.4/2.54*180);
     writeWideString(trim(ADOQuery1.FieldByName('txcode1').AsString),i2,f);
    writeln(f,space(15)+trim(ADOQuery1.FieldByName('txamt1').AsString)+space(20)+ trim(ADOQuery1.FieldByName('txrem1').AsString));

  end
  else
  begin
    writeln(f);
  end;


  writeln(f);
  writeln(f);
  //��40��
  if(trim(ADOQuery1.FieldByName('txcode2').AsString)<>'')then
  begin
    write(f,space(19));
     //д�м����ַ���,i2������Ϊi2*1/180Ӣ��.����Ϊ0.3cm
     i2:=round(0.4/2.54*180);
     writeWideString(trim(ADOQuery1.FieldByName('txcode2').AsString),i2,f);
     writeln(f,space(15)+trim(ADOQuery1.FieldByName('txamt2').AsString)+space(20)+ trim(ADOQuery1.FieldByName('txrem2').AsString));

    ///writeln(f,space(18)+trim(ADOQuery1.FieldByName('txcode2').AsString)+space(32)+trim(ADOQuery1.FieldByName('txamt2').AsString)+space(22)+
    ///trim(ADOQuery1.FieldByName('txrem2').AsString));
  end
  else
  begin
    writeln(f);
  end;
  ////���ǩ��,��˵绰
  writeln(f);
  writeln(f);
  writeln(f);
  writeln(f);
  //��45��
  if(trim(ADOQuery1.FieldByName('idCODE').AsString)<>'') then
  begin
    writeln(f,space(26)+trim(ADOQuery1.FieldByName('custName').AsString)+space(50)+trim(ADOQuery1.FieldByName('rpttel').AsString));
  end
  else
  begin
    writeln(f);
  end;

  ////���о�����ǩ��,����ҵ����
  writeln(f);
  writeln(f);
  writeln(f);
  writeln(f);
  //��50��
  //writeln(f,space(50)+trim(ADOQuery1.FieldByName('rptuser').AsString)+space(25)+trim(ADOQuery1.FieldByName('busicode').AsString));
  writeln(f,space(50)+'xxx'+space(26)+trim(ADOQuery1.FieldByName('busicode').AsString));

  {
  ////���19�п���
  for i:=1 to 19 do
  begin
    writeln(f);
  end;
  }
  //�����0.x����,һ����λΪ0.14����
  //Write(f,chr(27)+chr(74)+chr(7));
end;
end.
 