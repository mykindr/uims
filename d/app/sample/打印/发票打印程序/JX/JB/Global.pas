unit Global;

interface

uses
  Classes, ComCtrls, DBTables, Forms, Registry, Windows, ClassEnterprise;

type
  TIniInfo = record
    ImeName: string;
    SplashPath: string;
    BackGround: string;
  end;

procedure LoadIni; //װ������
procedure SaveIni; //��������

{ ȡ�ַ�����һ���ֽ����ǰ�벿��, ���ֽ���������򷵻������ַ��� }
function GetFront(sSource: string; cDelimiter: Char): string;
{ ȡ�ַ�����һ���ֽ��'|'��ǰ�벿�� }
function GetFrontDef(sSource: string): string;
{ ȡ�ַ�����һ���ֽ���ĺ�벿��, ���ֽ���������򷵻������ַ��� }
function GetBack(sSource: string; cDelimiter: Char): string;
{ ȡ��������TREEVIEW��}
procedure GetTown(ATreeView: TTreeView);

var
  IniInfo: TIniInfo;
  Enterprise: TEnterprise;

implementation

procedure LoadIni;
//װ������
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Swink\Tax_JB', False) then
    begin
      IniInfo.ImeName := Reg.ReadString('IMEName');
      IniInfo.SplashPath := Reg.ReadString('SplashPath');
      IniInfo.BackGround := Reg.ReadString('BackGround');
    end
    else
    begin
      IniInfo.ImeName := '';
      IniInfo.SplashPath := '';
    end;
  finally
    Reg.CloseKey;
    Reg.Free;
  end;
end;

procedure SaveIni;
//��������
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Swink\Tax_JB', True) then
    begin
      Reg.WriteString('IMEName', IniInfo.ImeName);
      Reg.WriteString('SplashPath', IniInfo.SplashPath);
      Reg.WriteString('BackGround', IniInfo.BackGround);
    end;
  finally
    Reg.CloseKey;
    Reg.Free;
  end;
end;

function GetFront(sSource: string; cDelimiter: Char): string;
//ȡ�ַ�����һ���ֽ����ǰ�벿��, ���ֽ���������򷵻������ַ���
var
  iPos: Integer;
begin
  iPos := Pos(cDelimiter, sSource);
  if iPos > 0 then
    Result := Copy(sSource, 1, iPos - 1)
  else
    Result := '';
end;

function GetFrontDef(sSource: string): string;
// ȡ�ַ�����һ���ֽ��'|'��ǰ�벿��
begin
  result := GetFront(sSource, '|');
end;

function GetBack(sSource: string; cDelimiter: Char): string;
// ȡ�ַ�����һ���ֽ���ĺ�벿��, ���ֽ���������򷵻������ַ���
var
  iPos: Integer;
begin
  iPos := Pos(cDelimiter, sSource);
  if iPos > 0 then
    Result := Copy(sSource, iPos + 1, 255)
  else
    Result := '';
end;

procedure GetTown(ATreeView: TTreeView);
// ȡ��������TREEVIEW��
var
  TmpQuery: TQuery;
  RootNode, CatNode: TTreeNode;
begin
  try
    TmpQuery := TQuery.Create(nil);
    with TmpQuery do
    try
      DatabaseName := 'JB';
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM Town.DB ORDER BY TownCode');
      Open;
      First;
      if not IsEmpty then
      begin
        RootNode := ATreeView.Items.Add(nil, '3144-����');
        RootNode.ImageIndex := 0;
        RootNode.SelectedIndex := 0;
        while not EOF do
        begin
          Application.ProcessMessages;
          CatNode := ATreeView.Items.AddChild(RootNode, FieldByName('TownCode').AsString + '-' + FieldByName('TownName').AsString);
          CatNode.ImageIndex := 1;
          CatNode.SelectedIndex := 2;
          Next;
        end;
      end;
      ATreeView.Selected := ATreeView.TopItem;
    finally
      Close;
      Free;
    end;
  except
    //
  end;
end;

end.

