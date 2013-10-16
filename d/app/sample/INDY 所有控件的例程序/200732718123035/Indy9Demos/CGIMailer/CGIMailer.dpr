{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  23248: CGIMailer.dpr 
{
{   Rev 1.1    25/10/2004 22:48:12  ANeillans    Version: 9.0.17
{ Verified
}
{
{   Rev 1.0    12/09/2003 21:09:18  ANeillans
{ Initial checkin
}
{
  Demo Name:  CGI Mailer
  Created By: Allen O'Neill
          On: 13/07/2002

  Notes:
   Demonstrates how to send mail using Indy components
   from a cgi-script

  Version History:
   12th Sept 03: Andy Neillans
                 Updated the Indy URL.

  Tested:
   Indy 9.0.17:
     D5:     Untested
     D6:     Untested
     D7:     25th Oct 04 by Andy Neillans
             Tested under Windows XP, running IIS WebServer.
}

program CGIMailer;

{$APPTYPE CONSOLE}
{$I IdCompilerDefines.inc}

uses
  {$IFDEF VCL5ORABOVE}
   WebBroker,
  {$ELSE}
    httpApp,
  {$ENDIF}
  CGIApp,
  fMain in 'fMain.pas' {WebModule1: TWebModule};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TWebModule1, WebModule1);
  Application.Run;
end.
