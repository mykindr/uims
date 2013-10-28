unit Unit7;

interface
uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB, Grids, DBGrids,strutils;
var
  //��һ���µ�ֵ,�����һ�� ,��λ����
  //firstLineDownValue:double=0;
  // ��һ���µ�ֵ,��Ա�׼ֵ,��λ����
  firstLineDownVersusStandard:double=0;

  pageNum:integer=1;

  //ÿһҳ��ֽ����ֵ,�����һ��,��λ����
  //everyPageAddValue:double=0;
  //��һ���µ�ֵ,��Ա�׼ֵ ��λ����
  everyPageAddVersusStandard:double=0;



  printPort:string='lpt1';

  databaseIp:string='109.72.14.209';
  databaseSid:string='orcl';
  procedure initParams;
  procedure saveParams;
implementation
  procedure initParams;
  var
   f:textfile;
   str:string;
  begin
    assignfile(f,'params.cfg');
    reset(f);

    readln(f,str);
    firstLineDownVersusStandard:=strtofloat(trim(str));

    readln(f,str);
    pageNum:=strtoint(trim(str));

    readln(f,str);
    everyPageAddVersusStandard:=strtofloat(trim(str));

    readln(f,str);
    printPort:=trim(str);

    readln(f,str);
    databaseIp:=trim(str);

    readln(f,str);
    databaseSid:=trim(str);

    closefile(f);
  end;

  procedure saveParams;
  var
   f:textfile;
   //str:string;
  begin
    assignfile(f,'params.cfg');
    rewrite(f);
    writeln(f,floattostr(firstLineDownVersusStandard));
    writeln(f,inttostr(pageNum));
    writeln(f,floattostr(everyPageAddVersusStandard));
    writeln(f,printPort);
    writeln(f,databaseIp);
    writeln(f,databaseSid);

    closefile(f);
  end;
end.
  
