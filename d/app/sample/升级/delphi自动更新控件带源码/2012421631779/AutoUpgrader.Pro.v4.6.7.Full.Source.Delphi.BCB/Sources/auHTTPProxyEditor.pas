{*******************************************************************************

  AutoUpgrader Professional
  FILE: auHTTPProxyEditor.pas - property editor for Proxy structure of the
                                auHTTP component.

  Copyright (c) 1999-2004 UtilMind Solutions
  All rights reserved.
  E-Mail: info@utilmind.com
  WWW: http://www.utilmind.com, http://www.appcontrols.com

  The entire contents of this file is protected by International Copyright
Laws. Unauthorized reproduction, reverse-engineering, and distribution of all
or any portion of the code contained in this file is strictly prohibited and
may result in severe civil and criminal penalties and will be prosecuted to
the maximum extent possible under the law.

*******************************************************************************}
{$I auDefines.inc}

unit auHTTPProxyEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,

{$IFDEF D6}
  DesignIntf, DesignWindows, 
{$ELSE}
  DsgnIntf, DsgnWnds,
{$ENDIF}

  auHTTP;

type
  TauHTTPProxyEditor = class(TDesignWindow)
    PreconfigBtn: TRadioButton;
    DirectBtn: TRadioButton;
    Bevel1: TBevel;
    ProxyBtn: TRadioButton;
    ProxyServerLab: TLabel;
    BypassLab: TLabel;
    BypassMemo: TMemo;
    TipLab: TLabel;
    OKBtn: TButton;
    CancelBtn: TButton;
    ProxyAddressLab: TLabel;
    SeparatorLab: TLabel;
    PortLab: TLabel;
    ServerEdit: TEdit;
    PortEdit: TEdit;
    procedure CancelBtnClick(Sender: TObject);
    procedure PreconfigBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  private
    Proxy: TauHTTPProxy;
  public
  end;

{$IFNDEF D4}
type
  IDesigner = TDesigner;
  IFormDesigner = TFormDesigner;
{$ENDIF}

procedure ShowHTTPProxyDesigner(Designer: IDesigner; Proxy: TauHTTPProxy);

implementation

{$R *.DFM}

procedure ShowHTTPProxyDesigner(Designer: IDesigner; Proxy: TauHTTPProxy);
var
  Editor: TauHTTPProxyEditor;

  function FindEditor(Proxy: TauHTTPProxy): TauHTTPProxyEditor;
  var
    I: Integer;
  begin
    Result := nil;
    for I := 0 to Screen.FormCount - 1 do
     if Screen.Forms[I] is TauHTTPProxyEditor then
      if TauHTTPProxyEditor(Screen.Forms[I]).Proxy = Proxy then
       begin
        Result := TauHTTPProxyEditor(Screen.Forms[I]);
        Break;
       end;
  end;

begin
  if Proxy = nil then Exit;
  Editor := FindEditor(Proxy);
  if Editor <> nil then
   begin
    Editor.Show;
    if Editor.WindowState = wsMinimized then
      Editor.WindowState := wsNormal;
   end
  else
   begin
    Editor := TauHTTPProxyEditor.Create(Application);
    try
      {$IFDEF D6}
      Editor.Designer := Designer;
      {$ELSE}
      Editor.Designer := IFormDesigner(Designer);
      {$ENDIF}
      Editor.Proxy := Proxy;
      Editor.Show;
    except
      Editor.Free;
      raise;
    end;
  end;
end;

// ---------------------------------------------------

procedure TauHTTPProxyEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TauHTTPProxyEditor.FormShow(Sender: TObject);
begin
  with Proxy do
   begin
    ServerEdit.Text := ProxyServer;
    PortEdit.Text := IntToStr(ProxyPort);
    BypassMemo.Text := ProxyBypass;

    PreconfigBtn.Checked := AccessType = atPreconfig;
    DirectBtn.Checked := AccessType = atDirect;
    ProxyBtn.Checked := AccessType = atUseProxy;
   end;
end;

procedure TauHTTPProxyEditor.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TauHTTPProxyEditor.PreconfigBtnClick(Sender: TObject);
begin
  ProxyServerLab.Enabled := ProxyBtn.Checked;
  ProxyAddressLab.Enabled := ProxyBtn.Checked;
  PortLab.Enabled := ProxyBtn.Checked;
  SeparatorLab.Enabled := ProxyBtn.Checked;
  BypassLab.Enabled := ProxyBtn.Checked;
  TipLab.Enabled := ProxyBtn.Checked;

  ServerEdit.Enabled := ProxyBtn.Checked;
  PortEdit.Enabled := ProxyBtn.Checked;
  BypassMemo.Enabled := ProxyBtn.Checked;
  if ProxyBtn.Checked then
   begin
    ServerEdit.Color := clWindow;
    PortEdit.Color := clWindow;
    BypassMemo.Color := clWindow;
   end
  else
   begin
    ServerEdit.Color := clBtnFace;
    PortEdit.Color := clBtnFace;
    BypassMemo.Color := clBtnFace;
   end; 
end;

procedure TauHTTPProxyEditor.OKBtnClick(Sender: TObject);
begin
  with Proxy do
   begin
    ProxyServer := ServerEdit.Text;
    ProxyPort := StrToIntDef(PortEdit.Text, 8080);
    ProxyBypass := BypassMemo.Text;

    if PreconfigBtn.Checked then
      AccessType := atPreconfig
    else
     if DirectBtn.Checked then
       AccessType := atDirect
     else
       AccessType := atUseProxy;
   end;

  Designer.Modified;   
  Close;
end;

end.
