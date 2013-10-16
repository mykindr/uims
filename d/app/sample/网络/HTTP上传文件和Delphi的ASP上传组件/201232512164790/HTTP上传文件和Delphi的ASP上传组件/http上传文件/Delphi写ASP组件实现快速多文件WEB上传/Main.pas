unit Main;
interface
uses
  ComObj,ASPComponent_TLB,ASPTypeLibrary_TLB,ActiveX,Sysutils,Classes,Variants;
const error_code=-1024;
type
  TInputInfo=record      //������Ϣ
  name:shortstring;      //������
  value:string;          //����ֵ
  filetype:shortstring;
  filesize:integer;
 end;

  TFileUpload = class(TAutoObject, IFileUpload)
  private
    fsize,ftype,fvalue:string;
    fRequest: IRequest; //ASP����
    savepath:string;  //�ļ�����·��
    foverwrite:boolean; //�Ƿ񸲸��ļ�
    fresult:integer;
    Inputs:array [0..40] of TInputInfo;
    fcount:integer;

    Function Mapfile(fs:Tfilestream):boolean;  //�ڴ�ӳ���ļ�
    function getitem2(const buf:pchar;const filesize:integer):boolean;
    // �ӱ������ݻ�ȡ��Ϣ
    function SeekItem(Item:OleVariant):integer;
  protected
    function  OnStartPage(const pUnk: IUnknown): Integer; safecall;
    procedure OnEndPage; safecall;
    function  Savefile(const path: WideString; overwrite: WordBool): Integer; safecall;
           //�����ϴ��ļ���pathΪ����·��
    function  InputCount: Integer; safecall; //���ر������
    function  FileSize(Item: OleVariant): Integer; safecall;//�����ļ���С
    function  FileType(Item: OleVariant): WideString; safecall;//�����ļ�����
    function  Request(Item: OleVariant): WideString; safecall;//���ر���ֵ
  end;

implementation
uses Windows, ComServ;

function TFileUpload.SeekItem(Item:OleVariant):integer;
var t,i:integer;
temp:string;
begin
 result:=-1;
 t:=VarType(Item);
 if t=varOleStr then //Item�Ǳ���
  begin
   temp:=item;
   for i:=0 to fcount-1 do
     if AnsiSameText(temp,Inputs[i].name) then
       begin
       result:=i; break;
      end;
  end else if t=varInteger then //Item �����
   begin
     i:=item;
     if i<fcount then result:=i-1;
   end;
end;

function  TFileUpload.FileSize(Item: OleVariant): Integer;
begin
  result:=0;
  if SeekItem(item)<>-1 then
    result:=Inputs[SeekItem(item)].filesize;
end;

function  TFileUpload.FileType(Item:OleVariant): WideString;
begin
  result:='';
  if SeekItem(item)<>-1 then
    result:=Inputs[SeekItem(item)].filetype ;
end;

function  TFileUpload.Request(Item: OleVariant): WideString;
begin
  result:='';
  if SeekItem(item)<>-1 then
    result:=Inputs[SeekItem(item)].value ;
end;

function  TFileUpload.InputCount: Integer;
begin
   result:=fcount;
end;

function  TFileUpload.Savefile(const path: WideString; overwrite: WordBool): Integer;
const fsize=8192;
var fs:Tfilestream;
total:integer;
size,p:OleVariant;
buffer:pchar;
filename:array[0..260] of char;
begin
    fcount:=0;
    fresult:=0;
    savepath:=path;
    if not directoryexists(savepath) then
      begin
       CreateDir(savepath);
      end;

    foverwrite:=overwrite;
    if savepath[length(savepath)]<>'\' then
     savepath:=savepath+'\';
    GetTempFileName(pchar(savepath),'upl',0,filename);
//    GetTempFileName

    try
     fs:=Tfilestream.create(filename,fmCreate);  //������ʱ�ļ�
    except
     fresult:=error_code;
     exit;
    end;

    total:=0;
    while total<frequest.Get_TotalBytes do  //��ȡ�ͻ����ϴ�������
      begin
           size:=fsize;
           p:=frequest.BinaryRead(size);
           buffer:=VarArrayLock(P);   //safearray��pchar��ת��
           fs.Write(buffer^,size);
           VarArrayUnlock(p);
           total:=total+size;
      end;
   Mapfile(fs); //�ڴ�ӳ���ļ���������
   if fresult<>0 then result:=fresult  else result:=fs.size;
   //�ɹ����������������ݵĳ��ȣ��������Ĵ������
   fs.Free;
   DeleteFile(filename);   //ɾ����ʱ�ļ�
end;

function TFileUpload.OnStartPage(const pUnk: IUnknown): Integer;
var
   Script: IScriptingContext;
begin
    if pUnk<>nil then
     begin
      Script := pUnk as IScriptingContext;  ////ʵ��ASP��������Ľӿ�
      fRequest := Script.Request;
      result:=S_OK;
    end;
end;

procedure TFileUpload.OnEndPage;
begin
//
end;

function TFileUpload.getitem2(const buf:pchar; const filesize:integer):boolean;
  const
  head='Content-Disposition: form-data; name="';
  filetag='"; filename="';
  file_type='Content-Type: ';
  var
  curr:integer;
  taglen:integer;
  tag:array[0..50] of char;
  temp:array[0..300] of char;
  i,k,p,t:integer;
  savefile,isfile:boolean;
  fs:Tfilestream;
  filename:string;
     function seekstring(from:integer;str:pchar):integer;
     var        //ɨ��ָ���ַ���
      i:integer;
     begin
        result:=-1;
        for i:=from to filesize-1 do
         if buf[i]=str^ then
          if strLcomp(str,pchar(@buf[i]),strlen(str))=0 then
            begin
             result:=i;
             break;
            end;
     end;

    function seektag(from:integer):integer;
     var     //����ɨ����
     i:integer;
     begin
        result:=-1;
        for i:=from to filesize-1 do
          if pdword(@buf[i])^=$2d2d2d2d then //$2d2d2d2d ='----'
            if strLcomp(tag,pchar(@buf[i]),taglen)=0 then
               begin
                result:=i;
                break;
               end;
     end;
begin
  curr:=0;
  tag[0]:=#0;
  t:=seekstring(0,#13#10);
  taglen:=t;
  strlcopy(tag,buf,taglen);
  curr:=taglen+2;
   while curr+2<filesize do
      begin ////1
          if strlcomp(head,@buf[curr],strlen(head))=0 then
           begin   //��������
              curr:=curr+strlen(head);
              t:=seekstring(curr,'"');
              strlcopy(temp,@buf[curr],t-curr);
              Inputs[fcount].name:=strpas(temp);//��ȡ������
              isfile:=false;
              if strlcomp(@buf[t],filetag,strlen(filetag))=0 then
                begin //�����ļ�
                   t:=t+strlen(filetag);
                   k:=seekstring(t,'"');
                   strlcopy(temp,@buf[t],k-t);
                   isfile:=true;
                   Inputs[fcount].value:=extractfilename(temp); //�ļ���
                   t:=seekstring(k,file_type)+strlen(file_type);
                   curr:=seekstring(t,#13#10);
                   strlcopy(temp,@buf[t],curr-t);
                   Inputs[fcount].filetype:=strpas(temp);//�ļ�����
                   curr:=curr+4;
                end else
                begin
                  curr:=t+5;
                end;
               t:=seektag(curr);   //ɨ���¸����
               if not isfile then
               begin
                 buf[t-2]:=#0;
                 Inputs[fcount].value:=strpas(@buf[curr]);//����ֵ
                 inc(fcount);
                 curr:=t+2+taglen;
               end else
               begin
                  filename:=savepath+Inputs[fcount].value ;
                  Inputs[fcount].filesize:=t-2-curr;     //�ļ���С
                  savefile:=fileexists(filename) and not foverwrite;
                  if (length(Inputs[fcount].value)>0) and not savefile then
                   try
                     fs:=Tfilestream.create(filename,fmCreate); //�����ļ�
                     fs.Writebuffer(buf[curr],t-2-curr);
                   finally
                     fs.Free;
                   end;
                  inc(fcount);
                  curr:=t+2+taglen;
               end;
          end else
          begin
             exit;
          end;
      end;
end;

function TFileUpload.Mapfile(fs:Tfilestream):boolean;
var
  FMapHandle: THandle;  // �ļ�ӳ����
  PData: PChar;      // �ļ���ͼ�ĵ�ַ
begin
  FMapHandle := CreateFileMapping(fs.Handle, nil,
       PAGE_READWRITE	, 0, fs.size, nil);
       //ֻ����ʽ�����ļ��ڴ�ӳ�����
  if FMapHandle = 0 then
   begin //�����ļ��ڴ�ӳ��������
     fresult:=error_code+1;
     exit;
   end;
  PData := MapViewOfFile(FMapHandle, FILE_MAP_WRITE	, 0, 0,
     fs.size); //ӳ���ļ���ͼ������ӳ����ͼ�ĳ�ʼ��ַ

  if PData=nil then  //����ӳ����ͼ����
     begin
      CloseHandle(FMapHandle); //�ر��ļ�ӳ�����
      fresult:=error_code+2;
      exit;
   end;
  try
   getitem2(pdata,fs.size);
  except
    fresult:=error_code+3;
  end;
   UnmapViewOfFile(PData); //ɾ���ļ���ͼ
   CloseHandle (FMapHandle);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TFileUpload, CLASS_CoIFileUpload, ciMultiInstance,
    tmApartment);
end.
