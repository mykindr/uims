unit Unit1;
////������
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, DB, ADODB,Grids,
  DBGrids, SHELLAPI,DBGridEh, GridsEh,ehlibado;
var
firstLineStandardDown:integer=415;
type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Button1: TButton;
    Label3: TLabel;
    ComboBox1: TComboBox;
    ADOQuery2: TADOQuery;
    Button2: TButton;
    ADOQuery1: TADOQuery;
    N8: TMenuItem;
    N9: TMenuItem;
    DataSource1: TDataSource;
    N10: TMenuItem;
    DBGridEh1: TDBGridEh;
    Label4: TLabel;
    Edit3: TEdit;
    Label5: TLabel;
    Edit4: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure DBGridEh1TitleBtnClick(Sender: TObject; ACol: Integer;
      Column: TColumnEh);
    procedure startPrint;
  private
    { Private declarations }
  public
    { Public declarations }
  end;
//procedure startPrint;
var
  Form1: TForm1;
  //f:textfile;

implementation

uses unit4, Unit6, Unit5,unit7;

{$R *.dfm}




procedure test;
begin
  showMessage('test');
end;

procedure writeHalfLn(var f:textfile);
begin
Write(f,chr(27)+chr(74)+chr(15));
end;




////�鿴��¼,���������Ҫ�� "��ӡ" ������һ��.
procedure TForm1.Button2Click(Sender: TObject);
var
  beginDate:string;
  endDate:string;
  //������
  brno:string;


  a11187countrycode:string;
  allTable:string;
  finalSql:string;
  fcyaccStr:string;
begin
   button2.Enabled:=false;
   beginDate:=edit1.Text;
   endDate:=edit2.Text;

   ///��������Ƿ�Ϸ�
   if ((length(trim(beginDate))<>8) or  (length(trim(endDate))<>8) ) then
   begin
     showMessage('�����������,������������20091201��8λ����');
     button2.Enabled:=true;
     exit;
   end;
   try
     strtoint(begindate);
     strtoint(enddate);
   except
   begin
     showMessage('�����������,������������20091201��8λ����');
     button2.Enabled:=true;
     exit;
   end;
   end;


   brno:='%'+comboBox1.Text;
   ////�Ƿ�Ϸ���ʵ����Ҳû��ϵ,������Ϊ����.

   //����Ҫ�õ������ӵ�.
   //�����,ʱ��,�տ���,�տ��˺�,�տ����,�տ���,������,�����˹���,�걨���
  { adoquery2.SQL.Text:=' select rownum as ���,a.* from (select zhangHaoWangDian.wangDian as �����,a11187.apnumber as �걨����,a11187.rptdate as ��������,a11187.custname as �տ���,zhangHaoWangDian.zhangHao as �տ��˺�,'+
   'a11187.txccy as �տ����,a11187.txamt as �տ���,a11187.oppname as ������,a11187.countryCode as ������� '+
   'from a11187,countryCodeName,zhanghaoWangDian '+
   'where a11187.prtbrno like '+quotedStr(brno)+' and (a11187.rptdate between '+quotedStr(begindate)+' and '+quotedStr(endDate)+
   ') and a11187.countryCode=countryCodeName.countryCode and a11187.fcyacc=zhangHaoWangDian.zhangHao'+
   ' order by zhangHaoWangDian.wangDian asc)a';
  }

   {adoquery2.SQL.Text:=' select a11187.*,countryCodeName.countryName,zhangHaoWangDian.wangDian from a11187 left join zhanghaoWangDian on (a11187.fcyacc = zhanghaoWangDian.zhangHao'+'),countryCodeName  '+
   'where  a11187.prtbrno like '+quotedStr(brno)+'and (a11187.rptdate between '+quotedStr(begindate)+' and '+quotedStr(endDate)+
   ') and a11187.countryCode=countryCodeName.countryCode';
   }
   fcyaccStr:='0';
   a11187countrycode:='select a11187.fcyacc as �տ��˺�,a11187.apnumber as �걨����,a11187.rptdate as ��������,a11187.custname as �տ���, '+
   'a11187.txccy as �տ����,a11187.txamt as �տ���,a11187.oppname as ������,a11187.countryCode as �������,a11187.unitcode as ��֯���� '+
   'from a11187 '+
   'where a11187.prtbrno like '+quotedStr(brno)+
   //�����Ƕ��ⲹ���.
   ' and a11187.fcyacc <>'+quotedStr(fcyaccstr)+
   ' and (a11187.rptdate between '+quotedStr(begindate)+' and '+quotedStr(endDate)+
   ')  ';

    //finalSql:='select rownum as ���,a.* from ' +a11187countrycode;
    adoquery2.SQL.Text:=a11187countrycode;
   {adoquery2.SQL.Text:=' select zhangHaoWangDian.wangDian,a11187.rptdate,a11187.custname,zhangHaoWangDian.zhangHao,a11187.txccy,a11187.txamt,a11187.oppname,a11187.countryCode,a11187.apnumber from a11187,countryCodeName,zhanghaoWangDian '+
   'where a11187.brno like '+quotedStr(brno)+
   ' and a11187.countryCode=countryCodeName.countryCode and a11187.fcyacc=zhangHaoWangDian.zhangHao';   }
   //adoquery2.SQL.Text:='select * from a111872';
   try
   adoquery2.open;
   except on e:exception do
   begin
    showmessage('���ӵ����ݿⷢ�����󣬿��������粻ͨ��'+e.Message);
    button2.Enabled:=true;
    exit;
   end;
   end;
   //���õ�һ��"���"�Ŀ��ֵΪ50.
   dbgrideh1.Columns[0].title.caption:='���(��'+inttostr(adoquery2.RecordCount)+'����¼)';
   dbgrideh1.Columns[0].Width:=150;
   dbgrideh1.Columns[1].Width:=60;
   button2.Enabled:=true;
   //frxReport1.LoadFromFile(getCurrentdir+'\oracle.fr3');
   ///TForm1.Button3Click(Sender);
   //frxReport1.ShowReport;
end;

function getTotalDayOfMonth(year:integer;month:integer):integer;
var
  isRunNian:boolean;
begin
  isRunNian:=false;
  if(((year mod 4=0) and (year mod 100<> 0)) or (year mod 400=0)) then
  begin
    isRunNian:=true;
  end;

  if(month=2)then
  begin
    if (isRunNian) then result:=29 else result:=28;
  end
  else if((month=1 )or (month=3) or (month=5) or (month=7) or (month=8) or (month=10) or (month=12)) then
  begin
    result:=31;
  end
  else
  begin
    result:=30;
  end;
end;


procedure TForm1.FormCreate(Sender: TObject);
var
 brno:string;
 year,month,day:word;
 tianShu:integer;
 strMonth:string;
begin
  
//adoQuery1.Close;
  //adoquery1.ConnectionString:='Provider=MSDAORA.1;Password=tadaiben;User ID=tadaiben;Data Source=109.72.31.110/orcl;Persist Security Info=True';
  //adoquery2.ConnectionString:='Provider=MSDAORA.1;Password=tadaiben;User ID=tadaiben;Data Source=109.72.31.110/orcl;Persist Security Info=True';

  //adoquery1.ConnectionString:='Provider=MSDAORA.1;Password=reportprint;User ID=reportprint;Data Source='+unit7.databaseIp+'/'+unit7.databaseSid+';Persist Security Info=True';
  //adoquery2.ConnectionString:='Provider=MSDAORA.1;Password=reportprint;User ID=reportprint;Data Source='+unit7.databaseIp+'/'+unit7.databaseSid+';Persist Security Info=True';
  //Provider=Microsoft.Jet.OLEDB.4.0;Data Source=E:\report\����ҵ�program\reportPrint.mdb;Persist Security Info=False

  adoquery1.ConnectionString:='Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+getcurrentdir+'\reportPrint.mdb;Persist Security Info=False';
  adoquery2.ConnectionString:='Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+getcurrentdir+'\reportPrint.mdb;Persist Security Info=False';



  adoQuery1.Close;
  adoQuery1.SQL.Text:='select brno from brno';
  try
  adoQuery1.Open;
  except on e:exception do
  begin
    showmessage('���ӵ����ݿⷢ�����󣬿��������粻ͨ��'+e.Message);
    exit;
  end;
  end;
  form1.ADOQuery1.First;
  while(not form1.ADOQuery1.Eof) do
  begin
     brno:=form1.ADOQuery1.FieldByName('brno').AsString;
     comboBox1.Items.Add(brno);
     form1.ADOQuery1.Next;
  end;
  {
  decodeDate(date,year,month,day);
  if(month=1) then
  begin
   Month:=12;
   Year:=year-1;
  end
  else
  begin
   Month:=month-1;
   Year:=year;
  end;

  tianShu:=getTotalDayOfMonth(year,month);
  if(month<10) then  strMonth:='0'+inttostr(month) else strMonth:=inttostr(month);
  edit1.Text:=inttostr(year)+strMonth+'01';
  edit2.Text:=inttostr(year)+strMonth+inttostr(tianShu);
  }

end;


procedure TForm1.N7Click(Sender: TObject);
begin
   if application.MessageBox('ȷ��Ҫ�˳�ϵͳ��','��ʾ',mb_yesno)=idYes then
   begin
      application.Terminate;
   end;
end;

procedure TForm1.N5Click(Sender: TObject);
begin
  //ShellExecute(Handle, 'open', PChar('notepad'), PChar('�����ĵ�.txt'), nil, SW_SHOW);
  ShellExecute(Handle, 'open', PChar('winword'), PChar('help.doc'), nil, SW_SHOW);
end;



function space(count:integer):string;
var
  str:string;
  i:integer;
begin
  str:=' ';
  for i:=1 to count do
  begin
    str:=str+' ';
  end;
  result:=str;
end;

////��ӡ
procedure TForm1.startPrint;
var
  f:textFile;
  //Ҳ������Ϊ�Ǽ�¼��.
  startPage:integer;
  endPage:integer;
  page:integer;
  i:integer;
  itemp:integer;

  printedPageNum:integer;

  beginDate:string;
  endDate:string;

   //������
  brno:string;
  a11187countrycode:string;
  allTable:string;
  finalSql:string;

  expectMaxPage:integer;

  fcyaccstr:string;

  //firstLineStandardDown:integer;
begin
  beginDate:=edit1.Text;
  endDate:=edit2.Text;
  try
  startPage:=strtoint(trim(form1.edit3.Text));
  endPage:=strtoint(trim(form1.edit4.Text));
  except on e:exception do
  begin
    showmessage('��ӡ�ļ�¼��������ȷ�����ָ�ʽ'+e.Message);
    form1.button1.Enabled:=true;
    exit;
  end;
  end;

  if(startPage<1) then
  begin
    showmessage('��ӡ����ʼ��¼�Ų���С��1');
    form1.button1.Enabled:=true;
    exit;
  end;

  expectMaxPage:=500;
  ///expectMaxPage:=300;
  if((endPage-startPage)>=expectMaxPage) then
  begin
     if application.MessageBox(PChar('���ڴ�ӡֽ�ʹ�ӡ������ֽ���Ⱦ��������,Ϊ��֤��ӡλ�þ�ȷ,����һ�εĴ�ӡ������Ҫ����'+inttostr(expectMaxPage)+'��,ȷʵһ��Ҫ��ӡ����'+inttostr(expectMaxPage)+'��?'),'��ʾ',mb_yesno)=idNo then
     begin
       button1.Enabled:=true;
       exit;
     end;
  end;
  try
  AssignFile(F,unit7.printPort);
  //AssignFile(F, 'C:\\test.txt');
  Rewrite(F);
  except on e:exception do
  begin
    showmessage('����'+unit7.printPort+'��ӡ�˿�ʧ��,������ĵ���û��'+unit7.printPort+'�˿�,'+
    '������������,������ ��ӡ����--��ӡ�˿����� �������޸Ĵ�ӡ���˿�'+e.Message);
    form1.button1.Enabled:=true;
    exit;
  end;
  end;



  ///�������������ݿ�.
  brno:='%'+unit1.Form1.ComboBox1.Text;

   //adoQuery1.Close;
   //adoQuery1.SQL.Text:='select * from a111872';
   //adoQuery1.Open;
   ////�Ƿ�Ϸ���ʵ����Ҳû��ϵ,������Ϊ����.
   adoquery1.Close;
   //����Ҫ�õ������ӵ�.
   {adoquery1.SQL.Text:=' select a11187.*,countryCodeName.countryName,zhangHaoWangDian.wangDian from a11187,countryCodeName left join zhanghaoWangDian on (a11187.fcyacc = zhanghaoWangDian.zhangHao and a11187.prtbrno like '+quotedStr(brno)+') '+
   'where  (a11187.rptdate between '+quotedStr(begindate)+' and '+quotedStr(endDate)+
   ') and a11187.countryCode=countryCodeName.countryCode';//+
   //' order by zhangHaoWangDian.wangDian asc';
   }

   
   fcyaccstr:='0';
   {
   //һ��a11187�������ֶ�,����countryCodeName.countryName , zhangHaoWangDian.wangDian ��Ϊ�ǲ��������,���в���select
   //zhangHaoWangDian.zhanghao������a11187��fcyacc������,����Ұ����select
   a11187countrycode:='(select a11187.*,countryCodeName.countryName '+
   'from a11187,countryCodeName '+
   'where a11187.prtbrno like '+quotedStr(brno)+
   //�����Ƕ��ⲹ���.
   ' and a11187.fcyacc <>'+quotedStr(fcyaccstr)+
   ' and (a11187.rptdate between '+quotedStr(begindate)+' and '+quotedStr(endDate)+
   ') and a11187.countryCode=countryCodeName.countryCode '+
   ')a ';
   allTable:='(select a.* from '+
   a11187countrycode+
   'left join zhanghaowangdian on (a.fcyacc = zhanghaoWangDian.zhangHao) order by decode(unitcode,null,'+quotedstr('��˽')+','+quotedstr('�Թ�')+'),zhangHaoWangDian.wangDian asc nulls first)b';
   finalSql:='select rownum as ���,b.* from ' +allTable;
   adoquery1.SQL.Text:=finalSql;
   }
   a11187countrycode:='select *  from a11187 '+
   'where a11187.prtbrno like '+quotedStr(brno)+
   //�����Ƕ��ⲹ���.
   ' and a11187.fcyacc <>'+quotedStr(fcyaccstr)+
   ' and (a11187.rptdate between '+quotedStr(begindate)+' and '+quotedStr(endDate)+
   ')  ';

    //finalSql:='select rownum as ���,a.* from ' +a11187countrycode;
    adoquery1.SQL.Text:=a11187countrycode;



   //'where a11184.brno like '+ ''''+'%'+quotedStr(brno)+''''+' and a11187.rptdate<>99991231 and a11187.countryCode=countryCodeName.countryCode and tadaiben.apNumber=zhaoHaoWangDian.zhangHao';
   //adoquery1.active:=true;
   try
     adoquery1.Open;
   except on e:exception do
   begin
     showmessage('���ӵ����ݿⷢ�����󣬿��������粻ͨ��'+e.Message);
     form1.button1.Enabled:=true;
     exit;
   end;
   end;

   if (endPage>adoquery1.RecordCount) then
   begin
     showmessage('�ܹ���'+inttostr(adoquery1.RecordCount)+'����¼,��˽����ļ�¼�Ų��ܴ���'+ inttostr(adoquery1.RecordCount)+'!');
     form1.button1.Enabled:=true;
     exit;
   end;


  form1.ADOQuery1.First;
  ////��¼ǰ��startPage-1��.
  for i:=2 to startPage do
  begin
    form1.ADOQuery1.Next;
  end;
  page:=startPage;

  ////��հ�,��˵��λ��ĳ���߶�
  //��firstLineDownVersusStandard>415��,��Ҫ�쳣��,����Ҳ��֧�����޵���.

  itemp:=firstLineStandardDown+round(unit7.firstLineDownVersusStandard/25.4*180);
  for i:=1 to (itemp div 255) do
  begin
    Write(f,chr(27)+chr(74)+chr(255));
  end;
  Write(f,chr(27)+chr(74)+chr(itemp mod 255));


  printedPageNum:=0;
  ///Write(f,chr(27)+chr(74)+chr(200));
  ///Write(f,chr(27)+chr(74)+chr(215));
  //page��ʾҪ��ӡ��ҳ����.
  while(page<=endPage) do
  begin
     //zhangHaoShu:=form1.ADOQuery1.FieldByName('zhangHaoShu').AsString;
     ////�������һҳ,�������ݺ�Ҫ����հ�����һҳ����.
     if(page<>endPage) then
     begin

        unit4.printData(unit1.Form1.ADOQuery1,f);
        printedPageNum:=printedPageNum+1;
        //����ײ��հ�
        ////���19�п��� \
        {
        for i:=1 to 19 do
        begin
          writeln(f);
        end; }
        for i:=1 to 13 do
        begin
          writeln(f);
        end;

        ////���ҳ�����������ҳ�� �ı���,��ô����Ҫ��or����ֽ��
        if(printedPageNum mod unit7.pageNum =0) then
        begin
        //���>0,��������ֽ
        if (unit7.everyPageAddVersusStandard>0) then
        begin
          itemp:=round(unit7.everyPageAddVersusStandard/25.4*180);
          writeln(f);
          writeln(f);
          writeln(f);
          writeln(f);
          writeln(f);
          writeln(f);
          Write(f,chr(27)+chr(74)+chr(itemp));
        end
        //���<0,��������ֽ .ʵ������ʱ��������ֽ
        else if (unit7.everyPageAddVersusStandard<0) then
        begin
          itemp:=round(unit7.everyPageAddVersusStandard/25.4*180);
          //writeln(f);
          //writeln(f);
          //���ַ�ʽ��ʵ��ȱ�ݵ�,�����ڴ���6��(��1Ӣ��)ʱ,�ʹﲻ��Ч��.
          //һ����1/6Ӣ��,����һ����30����λ.
          //���ﲻ��-itemp,����+itemp,��ΪitempΪ����
          Write(f,chr(27)+chr(74)+chr(30*6+itemp));
          //Write(f,chr(27)+chr(74)+chr(30*6-itemp));
        end
        else
        //�������Ҫ����,ֱ�����2��
        begin
           writeln(f);
           writeln(f);
           writeln(f);
           writeln(f);
           writeln(f);
           writeln(f);
        end;
        end
        ////����ֱ������6ҳֽ.
        else
        begin
           writeln(f);
           writeln(f);
           writeln(f);
           writeln(f);
           writeln(f);
           writeln(f);
        end;
     end
     ////��������һҳ,�����Ҫ��һЩ
     else
     begin
     unit4.printData(unit1.Form1.ADOQuery1,f);
     //��ҳ�ĵײ��հ���΢��һ���,��ֽ����.
     //writeln(f);
     //writeln(f);
     {//��Ȼ��ȫ���Ҳû�й�ϵ
        for i:=1 to 19 do
        begin
          writeln(f);
        end;
        }
     end;
     form1.ADOQuery1.Next;
     page:=page+1;
  end;

  CloseFile(F);
  form1.button1.Enabled:=true;
  showmessage('�Ѿ��ɹ����ӡ�����ʹ�ӡ������,�����ӡ��û����Ӧ,�����Ǵ�ӡ��û����������Ӻ�,'+
  '���ߴ�ӡ�������й���');
end;

////��ӡ
procedure TForm1.Button1Click(Sender: TObject);
var
  beginDate:string;
  endDate:string;

begin
   button1.Enabled:=false;
   //frxReport1.DesignReport;
   beginDate:=edit1.Text;
   endDate:=edit2.Text;
   ///��������Ƿ�Ϸ�
   if ( (length(trim(beginDate))<>8) or  ( length(trim(endDate))<>8) ) then
   begin
     showMessage('�����������,������������20091201��8λ����');
     button1.Enabled:=true;
     exit;
   end;
   try
     strtoint(begindate);
     strtoint(enddate);
   except on e:exception do
   begin
     showMessage('�����������,������������20091201��8λ����'+e.Message);
     button1.Enabled:=true;
     exit;
   end;
   end;


   ////��ʵ�������������ֱ�ӷ�������,Ҳû�й�ϵ.
   startPrint;
   //form5.Visible:=true;
   //frxReport1.LoadFromFile(getCurrentdir+'\oracle.fr3');
   //frxReport1.LoadFromFile('E:\�����ӡϵͳ\testProject3\oracle.fr3');
   //adoquery1.Open;
   //adoquery1.active:=true;
   //Button3Click(Sender);
   //frxReport1.ShowReport;
end;


//΢����ӡλ��.
procedure TForm1.N9Click(Sender: TObject);
begin
  form6.visible:=true;
end;

procedure TForm1.N10Click(Sender: TObject);
begin
  form5.visible:=true;
end;

procedure TForm1.DBGridEh1TitleBtnClick(Sender: TObject; ACol: Integer;
  Column: TColumnEh);
var
  sortstring:string; //������
begin
  //��������
  with Column do
  begin
    if FieldName = '' then
      Exit;
    case Title.SortMarker of
      smNoneEh:
      begin
        Title.SortMarker := smDownEh;
        sortstring := Column.FieldName + ' ASC';
      end;
      smDownEh: sortstring := Column.FieldName + ' ASC';
      smUpEh: sortstring := Column.FieldName + ' DESC';
    end;
  //��������
    try
      adoquery2.Sort := sortstring //datasetΪʵ�����ݼ�������
    except
    end;
  end;
end;

end.
