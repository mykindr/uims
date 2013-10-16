unit HtmlCloner;

{*****
  Sgxcn By 2010/8/12
  http://www.programbbs.com
******}

interface

uses
  Windows, Classes, SysUtils, RegExpr;

type
  THtmlCloner = class
  private
    FSrcRootPath: string;
    FDestResourcePath: string;
    FDestResourceUrl: string;

    //FRegxFile: string;
    //FRegxPath: string;
    FRegxPathRpl: string;

    FRegx: TRegExpr;
    procedure SetDestResourceUrl(const Value: string);
  public
    constructor Create;
    destructor Destory;
    //����
    function Process(sSrc: string; sStatus: TStrings = nil): string;
    //Դվ���Ŀ¼  �����\
    property SrcRootPath: string read FSrcRootPath write FSrcRootPath;
    //Ŀ����Դ·��  �����\
    property DestResourcePath: string read FDestResourcePath write FDestResourcePath;
    //Ŀ�����URL  �����/
    property DestResourceUrl: string read FDestResourceUrl write SetDestResourceUrl;
  end;

implementation

{ THtmlCloner }

constructor THtmlCloner.Create;
begin
  FRegx := TRegExpr.Create;
  FRegx.Expression := '(src\s?=\s?["|''|\s]?)(\S+/)(\S+\.[^"^''^ ]+)';
  //FRegxFile := 'src\s?=\s?["|''|\s]?([^"^''^ ]+)';
  //FRegxPath := '(src\s?=\s?["|''|\s]?)(\S+/)(\S+\.[^"^''^ ]+)';
  FRegxPathRpl := '$1$3';
end;

destructor THtmlCloner.Destory;
begin
  FRegx.Free;
end;

function THtmlCloner.Process(sSrc: string; sStatus: TStrings): string;
var
  sFile: String;
begin
  //�����ļ�
  if FRegx.Exec(sSrc) then
  begin
    repeat
      sFile := FSrcRootPath + StringReplace(FRegx.Match[2], '/', '\', [rfReplaceAll]) + FRegx.Match[3];
      if FileExists(sFile) then
      begin
        CopyFile(PChar(sFile), PChar(FDestResourcePath + FRegx.Match[3]), false);
        if sStatus <> nil then
           sStatus.Append(sFile + '�Ѿ����Ƶ�' + FDestResourcePath + FRegx.Match[3] + '��');
      end
      else
      begin
        if sStatus <> nil then
           sStatus.Append(PChar(sFile) + '�����ڡ�');
      end;
    until not FRegx.ExecNext;
  end;

  //����HTML
  Result := FRegx.Replace(sSrc, FRegxPathRpl, true);
  if sStatus <> nil then
     sStatus.Append('Դ��ת����ɣ�');
end;

procedure THtmlCloner.SetDestResourceUrl(const Value: string);
begin
  FDestResourceUrl := StringReplace(Value , '\', '/', [rfReplaceAll]);
  FDestResourceUrl := StringReplace(FDestResourceUrl , '$', '', [rfReplaceAll]);

  FRegxPathRpl := '$1' + FDestResourceUrl + '$3';
end;

end.

