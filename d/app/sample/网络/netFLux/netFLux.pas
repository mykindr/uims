unit netFlux;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TeEngine, Series, ExtCtrls, TeeProcs, Chart, TeeFunci,
   IPExport,
   IPHlpApi,
   Iprtrmib,
   IpTypes,
   IpFunctions,
   ipRelation, ComCtrls,chartFrame, jpeg;


type
  TfrmNetFlux = class(TForm)
    Timer1: TTimer;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Image2: TImage;
    Panel2: TPanel;
    procedure FormShow(Sender: TObject);
  private
   { Private declarations }

    ifaceInfoArr : Array of TiFaceInfo;

    frmChartS:Array of TframeChart;
    FlagIndexArr:Array of Array of integer; // CHart�ĸ��������� ,x Ϊ ����ģ�yΪChart�ڱ����������

  public
    { Public declarations }
  end;


var
  frmNetFlux: TfrmNetFlux;
  NewTabSheet:array of TTabSheet;
implementation
{$R *.dfm}


//=========================================================================================
//             Typei:integer; 0 : outIn 2��Seiros(����)
//                            1 : Borst 2��Seiros(����)
//                            2 : netFL 3��Seiros(����)
//=========================================================================================
procedure TfrmNetFlux.FormShow(Sender: TObject);
var
  i:integer;
  TInterFaceIndex:TStrings;
  FaceCount:integer;
  a,tmpI:integer;

begin
  //
  try
  TInterFaceIndex:=TStringList.Create ;
  TInterFaceIndex.Clear;
  //�õ��ӿ�����
  getIfaceTableInfo(TinterFaceIndex);
  FaceCount:=TinterFaceIndex.Count;

  if  FaceCount=0 then Exit;

  setLength(NewTabSheet,FaceCount);
  setLength(frmChartS,FaceCount);
  setLength(ifaceInfoArr,FaceCount);
  SetLength(FlagIndexArr,FaceCount+1,3);

  tmpI:=0;
  for i:=0 to FaceCount -1 do
  begin
     //��ʼ������
     for a:=0 to 2 do begin
       inc(tmpI);
       FlagIndexArr[i,a]:=TmpI;
     end;

     getIfaceIfRowInfo(StrToint(TinterFaceIndex.Names[i]),ifaceInfoArr[i]);

     NewTabSheet[i] := TTabSheet.Create(PageControl1);
     NewTabSheet[i].PageControl := PageControl1;
     NewTabSheet[i].Visible :=true;
     newTabSheet[i].Caption := TinterFaceIndex.Values[TinterFaceIndex.Names[i]];
     frmChartS[i]:=TframeChart.create(nil);
     frmChartS[i].Parent := NewTabSheet[i];
     frmChartS[i].Align := alClient	;
     frmCharts[i].CardIndex :=ifaceInfoArr[i].CardIndex ;
     frmCharts[i].Chart1.Tag := FlagIndexArr[i,0];
     frmCharts[i].Chart2.Tag := FlagIndexArr[i,1];
     frmCharts[i].Chart3.Tag := FlagIndexArr[i,2];

     for a:=0 to 2 do
     begin
       frmChartS[i].beginToStartUp(a);
     end;

     frmChartS[i].Visible :=true;
     frmChartS[i].FormIndex :=i;
  end;

  finally
  TinterFaceIndex.Free;
  end;
end;


end.

