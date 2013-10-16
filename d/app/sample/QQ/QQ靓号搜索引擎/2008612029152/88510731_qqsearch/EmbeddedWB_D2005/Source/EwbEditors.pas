//**************************************************************
//                                                             *
//                Ewb_Editors ver 14.56 (16/07/2005)           *
//                                                             *
//                 For Delphi 5, 6, 7, 2005, 2006              *
//                            by                               *
//       bsalsa - Eran Bodankin  - bsalsa@bsalsa.com           *
//        Based on an artical by Peter Morris from:            *
//  http://delphi.about.com/library/bluc/text/uc092501a.htm    *
//                                                             *
//                                                             *
//  Updated versions:                                          *
//               http://www.bsalsa.com                         *
//**************************************************************

{*******************************************************************************}
{LICENSE:
THIS SOFTWARE IS PROVIDED TO YOU "AS IS" WITHOUT WARRANTY OF ANY KIND,
EITHER EXPRESSED OR IMPLIED INCLUDING BUT NOT LIMITED TO THE APPLIED
WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
YOU ASSUME THE ENTIRE RISK AS TO THE ACCURACY AND THE USE OF THE SOFTWARE
AND ALL OTHER RISK ARISING OUT OF THE USE OR PERFORMANCE OF THIS SOFTWARE
AND DOCUMENTATION. [YOUR NAME] DOES NOT WARRANT THAT THE SOFTWARE IS ERROR-FREE
OR WILL OPERATE WITHOUT INTERRUPTION. THE SOFTWARE IS NOT DESIGNED, INTENDED
OR LICENSED FOR USE IN HAZARDOUS ENVIRONMENTS REQUIRING FAIL-SAFE CONTROLS,
INCLUDING WITHOUT LIMITATION, THE DESIGN, CONSTRUCTION, MAINTENANCE OR
OPERATION OF NUCLEAR FACILITIES, AIRCRAFT NAVIGATION OR COMMUNICATION SYSTEMS,
AIR TRAFFIC CONTROL, AND LIFE SUPPORT OR WEAPONS SYSTEMS. VSOFT SPECIFICALLY
DISCLAIMS ANY EXPRESS OR IMPLIED WARRANTY OF FITNESS FOR SUCH PURPOSE.

You may use, change or modify the component under 3 conditions:
1. In your website, add a link to "http://www.bsalsa.com"
2. In your application, add credits to "Embedded Web Browser"
3. Mail me  (bsalsa@bsalsa.com) any code change in the unit
   for the benefit of the other users.
{*******************************************************************************}

unit EwbEditors;

interface

{$I EWB.inc}

uses
{$IFDEF DELPHI_6_UP}DesignEditors, DesignIntf{$ELSE}DsgnIntf{$ENDIF};

type
   TEwbCompEditor = class(TComponentEditor)
   public
      procedure ExecuteVerb(Idx: integer); override;
      function GetVerb(Idx: integer): string; override;
      function GetVerbCount: integer; override;
   end;

   TBFFEditor = class(TComponentEditor)
   public
      procedure ExecuteVerb(Idx: integer); override;
      function GetVerb(Idx: integer): string; override;
      function GetVerbCount: integer; override;
   end;

   TSaveFileDLG = class(TStringProperty)
   public
      procedure Edit; override;
      function GetAttributes: TPropertyAttributes; override;
   end;

   TSaveTextDLG = class(TStringProperty)
   public
      procedure Edit; override;
      function GetAttributes: TPropertyAttributes; override;
   end;

   TSaveHtmlDLG = class(TStringProperty)
   public
      procedure Edit; override;
      function GetAttributes: TPropertyAttributes; override;
   end;

   TOpenFileDLG = class(TStringProperty)
   public
      procedure Edit; override;
      function GetAttributes: TPropertyAttributes; override;
   end;

   TOpenHtmlDLG = class(TStringProperty)
   public
      procedure Edit; override;
      function GetAttributes: TPropertyAttributes; override;
   end;

   TBrowse4FolderDLG = class(TStringProperty)
   public
      procedure Edit; override;
      function GetAttributes: TPropertyAttributes; override;
   end;

implementation

uses
   Browse4Folder, TypInfo, ShellApi, Windows, Dialogs, SysUtils, IEConst, Forms, shlobj;

//--Verb Delphi menu------------------------------------------------------------

procedure TEwbCompEditor.ExecuteVerb(Idx: integer);
begin
   case Idx of
      0: ShellExecute(0, 'open', SITE_ADDRESS, nil, nil, SW_SHOW);
   end;
end;

function TEwbCompEditor.GetVerb(Idx: Integer): string;
begin
   case Idx of
      0: Result := 'Support:  ' + SITE_ADDRESS;
      1: Result := 'Package Version:' + VER_NUM;
   end;
end;

function TEwbCompEditor.GetVerbCount: integer;
begin
   Result := 2;
end;

//---BuildIn Save Dialog for the components-------------------------------------

procedure TSaveFileDLG.Edit;
var
   SD: TSaveDialog;
begin
   SD := TSaveDialog.Create(Application);
   try
      with SD do
         begin
            Filename := GetValue();
            InitialDir := ExtractFilePath(FileName);
            Filter := '*.*';
            HelpContext := 0;
            Options := Options + [ofShowHelp, ofEnableSizing];
            if Execute then
               SetValue(FileName);
         end;
   finally
      SD.Free;
   end;
end;

function TSaveFileDLG.GetAttributes: TPropertyAttributes;
begin
   Result := [paDialog, paRevertable];
end;

procedure TSaveHtmlDLG.Edit;
var
   SD: TSaveDialog;
begin
   SD := TSaveDialog.Create(Application);
   try
      with SD do
         begin
            Filename := GetValue();
            InitialDir := ExtractFilePath(FileName);
            Filter := 'Html files|*.html|Htm files|*.htm';
            HelpContext := 0;
            Options := Options + [ofShowHelp, ofEnableSizing];
            if Execute then
               SetValue(FileName);
         end;
   finally
      SD.Free;
   end;
end;

function TSaveHtmlDLG.GetAttributes: TPropertyAttributes;
begin
   Result := [paDialog, paRevertable];
end;

procedure TSaveTextDLG.Edit;
var
   SD: TSaveDialog;
begin
   SD := TSaveDialog.Create(Application);
   try
      with SD do
         begin
            Filename := GetValue();
            InitialDir := ExtractFilePath(FileName);
            Filter := 'Text files|*.txt|Word files|*.doc';
            HelpContext := 0;
            Options := Options + [ofShowHelp, ofEnableSizing];
            if Execute then
               SetValue(FileName);
         end;
   finally
      SD.Free;
   end;
end;

function TSaveTextDLG.GetAttributes: TPropertyAttributes;
begin
   Result := [paDialog, paRevertable];
end;

//---BuildIn Open Dialog for the components-------------------------------------

procedure TOpenFileDLG.Edit;
var
   OD: TOpenDialog;
begin
   OD := TOpenDialog.Create(Application);
   try
      with OD do
         begin
            Filename := GetValue();
            InitialDir := ExtractFilePath(FileName);
            Filter := '*.*';
            HelpContext := 0;
            Options := Options + [ofShowHelp, ofEnableSizing];
            if Execute then
               SetValue(FileName);
         end;
   finally
      OD.Free;
   end;
end;

function TOpenFileDLG.GetAttributes: TPropertyAttributes;
begin
   Result := [paDialog, paRevertable];
end;

procedure TOpenHtmlDLG.Edit;
var
   OD: TOpenDialog;
begin
   OD := TOpenDialog.Create(Application);
   try
      with OD do
         begin
            Filename := GetValue();
            InitialDir := ExtractFilePath(FileName);
            Filter := 'Html files|*.html|Htm files|*.htm';
            HelpContext := 0;
            Options := Options + [ofShowHelp, ofEnableSizing];
            if Execute then
               SetValue(FileName);
         end;
   finally
      OD.Free;
   end;
end;

function TOpenHtmlDLG.GetAttributes: TPropertyAttributes;
begin
   Result := [paDialog, paRevertable];
end;

//---Browse For Folder----------------------------------------------------------

function TBrowse4FolderDLG.GetAttributes: TPropertyAttributes;
begin
   Result := [paDialog, paRevertable];
end;

procedure TBrowse4FolderDLG.Edit;
var
   BD: TBrowse4Folder;
begin
   BD := TBrowse4Folder.Create(Application);
   try
      with BD do
         begin
            Filename := GetValue();
            InitialDir := ExtractFilePath(FileName);
            if Execute then
               SetValue(FileName);
         end;
   finally
      BD.Free;
   end;
end;

procedure TBFFEditor.ExecuteVerb(Idx: integer);
var
   BD: TBrowse4Folder;
begin
   case Idx of
      0:
         begin
            BD := TBrowse4Folder.Create(Application);
            try
               with BD do
                  begin
                     InitialDir := ExtractFilePath(FileName);
                     Execute;
                  end;
            finally
               BD.Free;
            end;
         end;
   end;
end;

function TBFFEditor.GetVerb(Idx: Integer): string;
begin
   case Idx of
      0: Result := 'Support:  ' + SITE_ADDRESS;
      1: Result := 'Package Version:' + VER_NUM;
   end;
end;

function TBFFEditor.GetVerbCount: integer;
begin
   Result := 2;
end;

end.
