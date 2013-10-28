unit Unit1;
//Download by http://www.codefans.net
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    Function ConvertMoney(Num: Real): String;
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
   uses math;
{$R *.dfm}

{ TForm1 }

function TForm1.ConvertMoney(Num: Real): String;
var
  intstr,decstr,s: String;
  intlen,declen,i: word;
begin
  Intstr:= intToStr(Trunc(Num));
  decstr := FloatToStr(RoundTo(Frac(num),-2));//��С��������������
  decstr := copy(decstr,3,Length(decstr)-1);
  declen := Length(decstr);
  intlen := Length(Intstr);
  For i :=  1 to Intlen do
  begin
    Case StrToInt(Intstr[i]) of
      0: begin
           if (copy(s,Length(s)-1,2)<>'��')  then
             s := s+'��';
         end;
      1: s := s+'Ҽ';
      2: s := s+'��';
      3: s := s+'��';
      4: s := s+'��';
      5: s := s+'��';
      6: s := s+'½';
      7: s := s+'��';
      8: s := s+'��';
      9: s := s+'��';
    end;
     case intlen-i+1 of
       13: begin
             if (StrToInt(Intstr[i])<>0)then
               s := s+'��';
           end;
       12: begin
             if (StrToInt(Intstr[i])<>0) then
               s := s+'ǧ';
           end;
       11: begin
             if (StrToInt(Intstr[i])<>0) then
               s := s+'��';
           end;
       10: begin
             if (StrToInt(Intstr[i])<>0) then
             begin
               //if (copy(s,Length(s)-1,2) ='Ҽ')then
                // s := copy(s,0,Length(s)-2);
               s := s+'ʮ';
             end;
           end;
       9: begin
              if (StrToInt(Intstr[i])<>0) then
                s := s+'��'
              else
              begin
                if (copy(s,Length(s)-1,2) ='��')then
                  s := copy(s,0,Length(s)-2);
                  s := s+'��';
              end;
           end;
       8: begin
             if (StrToInt(Intstr[i])<>0) then
               s := s+'ǧ';
           end;
       7: begin
             if (StrToInt(Intstr[i])<>0)then
               s := s+'��';
           end;
       6: begin
             if (StrToInt(Intstr[i])<>0) then
             begin
               if (copy(s,Length(s)-1,2) ='Ҽ')then
                 s := copy(s,0,Length(s)-2);
               s := s+'ʮ';
             end;
           end;
       5: begin
             if (StrToInt(Intstr[i])<>0) then
              s := s+'��'
              else
              begin
                  s := copy(s,0,Length(s)-2);
                if (copy(s,Length(s)-1,2) <>'��')then
                  s := s+'��'
                else
                  s := s+'��';
              end;
           end;
       4: begin
             if (StrToInt(Intstr[i])<>0) then
               s := s+'ǧ';
           end;
       3: begin
             if (StrToInt(Intstr[i])<>0) then
               s := s+'��';
           end;
       2: begin
             if (StrToInt(Intstr[i])<>0) then
               s := s+'ʮ';
           end;
       1: begin
             if (copy(s,Length(s)-1,2) ='��')then
               s := copy(s,0,Length(s)-2);
               s := s+'Ԫ';
           end;
     end;
  end;
  For i := 1 to declen do
  begin
    Case StrToInt(decstr[i]) of
      0: begin
           if (copy(s,Length(s)-1,2)<>'��')  then
             s := s+'��';
         end;
      1: s := s+'Ҽ';
      2: s := s+'��';
      3: s := s+'��';
      4: s := s+'��';
      5: s := s+'��';
      6: s := s+'½';
      7: s := s+'��';
      8: s := s+'��';
      9: s := s+'��';
    end;
    case i of
      1: begin
            if (StrToInt(decstr[i])<>0)then
              s := s+'��';
          end;
      2: begin
            if (StrToInt(decstr[i])<>0) then
              s := s+'��';
          end;
    end;
  end;
  Result := s;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Edit2.Text:= Convertmoney(StrToFloat(Edit1.Text));
end;

end.
