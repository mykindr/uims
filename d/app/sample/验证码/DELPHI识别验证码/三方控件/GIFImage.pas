Unit GIFImage;
////////////////////////////////////////////////////////////////////////////////
//                                                                            //
// Project:	GIF Graphics Object                                           //
// Module:	gifimage                                                      //
// Description:	TGraphic implementation of the GIF89a graphics format         //
// Version:	2.2                                                           //
// Release:	5                                                             //
// Date:	23-MAY-1999                                                   //
// Target:	Win32, Delphi 2, 3, 4 & 5, C++ Builder 3 & 4                  //
// Author(s):	anme: Anders Melander, anders@melander.dk                     //
//		fila: Filip Larsen                                            //
//		rps: Reinier Sterkenburg                                      //
// Copyright:	(c) 1997-99 Anders Melander.                                  //
//		All rights reserved.                                          //
// Formatting:	2 space indent, 8 space tabs, 80 columns.                     //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
// Changed 2001.07.23 by Finn Tolderlund:                                     //
// Changed according to e-mail from "Rolf Frei" <rolf@eicom.ch>               //
//   on 2001.07.23 so that it works in Delphi 6.                              //
//                                                                            //
// Changed 2002.07.07 by Finn Tolderlund:                                     //
// Incorporated additional modifications by Alexey Barkovoy (clootie@reactor.ru)
// found in his Delphi 6 GifImage.pas (from 22-Dec-2001).                     //
// Alexey Barkovoy's Delphi 6 gifimage.pas can be downloaded from             //
//   http://clootie.narod.ru/delphi/download_vcl.html                         //
// These changes made showing of animated gif files more stable. The code     //
// from 2001.07.23 could crash sometimes with an Execption EAccessViolation.  //
//                                                                            //
// Changed 2002.10.06 by Finn Tolderlund:                                     //
// Delphi 7 compatible.                                                       //
//                                                                            //
// Changed 2003-03-06 by Finn Tolderlund:                                     //
// Changes made as a result of postings in borland.public.delphi.graphics     //
// from 2003-02-28 to 2003-03-05 where white (255,255,255) in a bitmap        //
// was converted to (254,254,254) in the gif.                                 //
// The doCreateOptimizedPaletteFromSingleBitmap function and                  //
// the CreateOptimizedPaletteFromManyBitmaps function is changed so that      //
// the correct offset 246 is used instead of 245.                             //
// The ReduceColors function is changed according to Anders Melander's post   //
// so that a colour get converted to the precise colour if that colour is     //
// present in the palette when using ColorReduction rmQuantize.               //
//                                                                            //
// Changed 2003-03-09 by Finn Tolderlund:                                     //
// Delphi 7 version is now assumed if unknown compiler version is unknown     //
// for better compatibility with future Delphi versions.                      //
// Hopefully this code is now compatible with future Delphi versions,         //
// unless Borland makes some changes that breaks existing code.               //
//                                                                            //
// Changed 2003-08-04 by Finn Tolderlund:                                     //
// Changed procedure AddMaskOnly so that it doesn't leak a GDI HBitmap-object //
// and it doesn't release the handle of the source bitmap which               //
// is used to assign to the GIF object as in gif.assign(bm);                  //
// These changes were made as a result of a news post made by Renate Schaaf   //
// with the subject "TGifImage HBitmap leak on assign?"                       //
// in borland.public.delphi.graphics on Mon 28 Jul 2003 and Sun 03 Aug 2003.  //
//                                                                            //
// Changed 2004.03.09 by Finn Tolderlund:                                     //
// Added a ForceFrame property to the TGIFImage class.                        //
// The ForceFrame property can be used to make TGIFImage display a apecific   //
// sub frame from an animated gif.                                            //
// How to use: Set the Animate property to False and set the ForceFrame       //
// property to a desired frame number (0-N)                                   //
// Normal display: Set the ForceFrame property to -1 and set Animate to True. //
// If ForceFrame is negative TGIFImage behaves just as before this change.    //
// Note that if the sub frame in the gif only contains part of the image      //
// (i.e. only the changes from previous frames) the result is unpredictable.  //
// The result is best if each sub frame contains a whole image.               //
// If the sub frame is transparent the background is not automatically        //
// restored, you must do so yourself if you want that.                        //
// If you are using a TImage to display the gif you can use                   //
// Image.Parent.Invalidate or Image.Parent.Refresh to restore the background. //
// This change was made as a result of a email correspondance with            //
// Tineke Kosmis (http://www.classe.nl/) which requested such a property.     //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
//                                                                            //
// Please read the "Conditions of use" in the release notes.                  //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
// Known problems:
//
// * The combination of buffered, tiled and transparent draw will display the
//   background incorrectly (scaled).
//   If this is a problem for you, use non-buffered (goDirectDraw) drawing
//   instead.
//
// * The combination of non-buffered, transparent and stretched draw is
//   sometimes distorted with a pattern effect when the image is displayed
//   smaller than the real size (shrinked).
//
// * Buffered display flickers when TGIFImage is used by a transparent TImage
//   component.
//   This is a problem with TImage caused by the fact that TImage was designed
//   with static images in mind. Not much I can do about it.
//
////////////////////////////////////////////////////////////////////////////////
// To do (in rough order of priority):
// { TODO -oanme -cFeature : TImage hook for destroy notification. }
// { TODO -oanme -cFeature : TBitmap pool to limit resource consumption on Win95/98. }
// { TODO -oanme -cImprovement : Make BitsPerPixel property writable. }
// { TODO -oanme -cFeature : Visual GIF component. }
// { TODO -oanme -cImprovement : Easier method to determine DrawPainter status. }
// { TODO -oanme -cFeature : Import to 256+ color GIF. }
// { TODO -oanme -cFeature : Make some of TGIFImage's properties persistent (DrawOptions etc). }
// { TODO -oanme -cFeature : Add TGIFImage.Persistent property. Should save published properties in application extension when this options is set. }
// { TODO -oanme -cBugFix : Solution for background buffering in scrollbox. }
//
//////////////////////////////////////////////////////////////////////////////////
{$IFDEF BCB}
{$OBJEXPORTALL On}
{$ENDIF}

Interface
////////////////////////////////////////////////////////////////////////////////
//
//		Conditional Compiler Symbols
//
////////////////////////////////////////////////////////////////////////////////
(*
  DEBUG				Must be defined if any of the DEBUG_xxx
      symbols are defined.
                                If the symbol is defined the source will not be
                                optimized and overflow- and range checks will be
                                enabled.

  DEBUG_HASHPERFORMANCE		Calculates hash table performance data.
  DEBUG_HASHFILLFACTOR		Calculates fill factor of hash table -
      Interferes with DEBUG_HASHPERFORMANCE.
  DEBUG_COMPRESSPERFORMANCE	Calculates LZW compressor performance data.
  DEBUG_DECOMPRESSPERFORMANCE	Calculates LZW decompressor performance data.
  DEBUG_DITHERPERFORMANCE	Calculates color reduction performance data.
  DEBUG_DRAWPERFORMANCE		Calculates low level drawing performance data.
      The performance data for DEBUG_DRAWPERFORMANCE
                                will be displayed when you press the Ctrl key.
  DEBUG_RENDERPERFORMANCE	Calculates performance data for the GIF to
      bitmap converter.
      The performance data for DEBUG_DRAWPERFORMANCE
                                will be displayed when you press the Ctrl key.

  GIF_NOSAFETY			Define this symbol to disable overflow- and
    range checks.
                                Ignored if the DEBUG symbol is defined.

  STRICT_MOZILLA		Define to mimic Mozilla as closely as possible.
      If not defined, a slightly more "optimal"
                                implementation is used (IMHO).

  FAST_AS_HELL			Define this symbol to use strictly GIF compliant
      (but too fast) animation timing.
                                Since our paint routines are much faster and
                                more precise timed than Mozilla's, the standard
                                GIF and Mozilla values causes animations to loop
                                faster than they would in Mozilla.
                                If the symbol is _not_ defined, an alternative
                                set of tweaked timing values will be used.
                                The tweaked values are not optimal but are based
                                on tests performed on my reference system:
                                - Windows 95
                                - 133 MHz Pentium
                                - 64Mb RAM
                                - Diamond Stealth64/V3000
                                - 1600*1200 in 256 colors
                                The alternate values can be modified if you are
                                not satisfied with my defaults (they can be
                                found a few pages down).

  REGISTER_TGIFIMAGE            Define this symbol to register TGIFImage with
      the TPicture class and integrate with TImage.
                                This is required to be able to display GIFs in
                                the TImage component.
                                The symbol is defined by default.
                                Undefine if you use another GIF library to
                                provide GIF support for TImage.

  PIXELFORMAT_TOO_SLOW		When this symbol is defined, the internal
      PixelFormat routines are used in some places
                                instead of TBitmap.PixelFormat.
                                The current implementation (Delphi4, Builder 3)
                                of TBitmap.PixelFormat can in some situation
                                degrade performance.
                                The symbol is defined by default.

  CREATEDIBSECTION_SLOW		If this symbol is defined, TDIBWriter will
      use global memory as scanline storage, instead
                                of a DIB section.
                                Benchmarks have shown that a DIB section is
                                twice as slow as global memory.
                                The symbol is defined by default.
                                The symbol requires that PIXELFORMAT_TOO_SLOW
                                is defined.

  SERIALIZE_RENDER		Define this symbol to serialize threaded
      GIF to bitmap rendering.
                                When a GIF is displayed with the goAsync option
                                (the default), the GIF to bitmap rendering is
                                executed in the context of the draw thread.
                                If more than one thread is drawing the same GIF
                                or the GIF is being modified while it is
                                animating, the GIF to bitmap rendering should be
                                serialized to guarantee that the bitmap isn't
                                modified by more than one thread at a time. If
                                SERIALIZE_RENDER is defined, the draw threads
                                uses TThread.Synchronize to serialize GIF to
                                bitmap rendering.
*)

{$DEFINE REGISTER_TGIFIMAGE}
{$DEFINE PIXELFORMAT_TOO_SLOW}
{$DEFINE CREATEDIBSECTION_SLOW}

////////////////////////////////////////////////////////////////////////////////
//
//		Determine Delphi and C++ Builder version
//
////////////////////////////////////////////////////////////////////////////////

// Delphi 1.x
{$IFDEF VER80}
'Error: TGIFImage does not support Delphi 1.x'
{$ENDIF}

// Delphi 2.x
{$IFDEF VER90}
{$DEFINE VER9x}
{$ENDIF}

// C++ Builder 1.x
{$IFDEF VER93}
  // Good luck...
{$DEFINE VER9x}
{$ENDIF}

// Delphi 3.x
{$IFDEF VER100}
{$DEFINE VER10_PLUS}
{$DEFINE D3_BCB3}
{$ENDIF}

// C++ Builder 3.x
{$IFDEF VER110}
{$DEFINE VER10_PLUS}
{$DEFINE VER11_PLUS}
{$DEFINE D3_BCB3}
{$DEFINE BAD_STACK_ALIGNMENT}
{$ENDIF}

// Delphi 4.x
{$IFDEF VER120}
{$DEFINE VER10_PLUS}
{$DEFINE VER11_PLUS}
{$DEFINE VER12_PLUS}
{$DEFINE BAD_STACK_ALIGNMENT}
{$ENDIF}

// C++ Builder 4.x
{$IFDEF VER125}
{$DEFINE VER10_PLUS}
{$DEFINE VER11_PLUS}
{$DEFINE VER12_PLUS}
{$DEFINE VER125_PLUS}
{$DEFINE BAD_STACK_ALIGNMENT}
{$ENDIF}

// Delphi 5.x
{$IFDEF VER130}
{$DEFINE VER10_PLUS}
{$DEFINE VER11_PLUS}
{$DEFINE VER12_PLUS}
{$DEFINE VER125_PLUS}
{$DEFINE VER13_PLUS}
{$DEFINE BAD_STACK_ALIGNMENT}
{$ENDIF}

// Delphi 6.x
{$IFDEF VER140}
{$WARN SYMBOL_PLATFORM OFF}
{$DEFINE VER10_PLUS}
{$DEFINE VER11_PLUS}
{$DEFINE VER12_PLUS}
{$DEFINE VER125_PLUS}
{$DEFINE VER13_PLUS}
{$DEFINE VER14_PLUS}
{$DEFINE BAD_STACK_ALIGNMENT}
{$ENDIF}

// Delphi 7.x
{$IFDEF VER150}
{$WARN SYMBOL_PLATFORM OFF}
{$DEFINE VER10_PLUS}
{$DEFINE VER11_PLUS}
{$DEFINE VER12_PLUS}
{$DEFINE VER125_PLUS}
{$DEFINE VER13_PLUS}
{$DEFINE VER14_PLUS}
{$DEFINE VER15_PLUS}
{$DEFINE BAD_STACK_ALIGNMENT}
{$ENDIF}

// 2003.03.09 ->
// Unknown compiler version - assume D4 compatible
//{$IFNDEF VER9x}
//  {$IFNDEF VER10_PLUS}
//    {$DEFINE VER10_PLUS}
//    {$DEFINE VER11_PLUS}
//    {$DEFINE VER12_PLUS}
//    {$DEFINE BAD_STACK_ALIGNMENT}
//  {$ENDIF}
//{$ENDIF}
// 2003.03.09 <-

// 2003.03.09 ->
// Unknown compiler version - assume D7 compatible
{$IFNDEF VER9x}
{$IFNDEF VER10_PLUS}
{$WARN SYMBOL_PLATFORM OFF}
{$DEFINE VER10_PLUS}
{$DEFINE VER11_PLUS}
{$DEFINE VER12_PLUS}
{$DEFINE VER125_PLUS}
{$DEFINE VER13_PLUS}
{$DEFINE VER14_PLUS}
{$DEFINE VER15_PLUS}
{$DEFINE BAD_STACK_ALIGNMENT}
{$ENDIF}
{$ENDIF}
// 2003.03.09 <-

////////////////////////////////////////////////////////////////////////////////
//
//		Compiler Options required to compile this library
//
////////////////////////////////////////////////////////////////////////////////
{$A+,B-,H+,J+,K-,M-,T-,X+}

// Debug control - You can safely change these settings
{$IFDEF DEBUG}
{$C+} // ASSERTIONS
{$O-} // OPTIMIZATION
{$Q+} // OVERFLOWCHECKS
{$R+} // RANGECHECKS
{$ELSE}
{$C-} // ASSERTIONS
{$IFDEF GIF_NOSAFETY}
{$Q-} // OVERFLOWCHECKS
{$R-} // RANGECHECKS
{$ENDIF}
{$ENDIF}

// Special options for Time2Help parser
{$IFDEF TIME2HELP}
{$UNDEF PIXELFORMAT_TOO_SLOW}
{$ENDIF}

////////////////////////////////////////////////////////////////////////////////
//
//			External dependecies
//
////////////////////////////////////////////////////////////////////////////////
Uses
  sysutils,
  Windows,
  Graphics,
  Classes;

////////////////////////////////////////////////////////////////////////////////
//
//			TGIFImage library version
//
////////////////////////////////////////////////////////////////////////////////
Const
  GIFVersion = $0202;
  GIFVersionMajor = 2;
  GIFVersionMinor = 2;
  GIFVersionRelease = 5;

////////////////////////////////////////////////////////////////////////////////
//
//			Misc constants and support types
//
////////////////////////////////////////////////////////////////////////////////
Const
  GIFMaxColors = 256; // Max number of colors supported by GIF
       // Don't bother changing this value!

  BitmapAllocationThreshold = 500000; // Bitmap pixel count limit at which
       // a newly allocated bitmap will be
                                        // converted to 1 bit format before
                                        // being resized and converted to 8 bit.

Var
{$IFDEF FAST_AS_HELL}
  GIFDelayExp: integer = 10; // Delay multiplier in mS.
{$ELSE}
  GIFDelayExp: integer = 12; // Delay multiplier in mS. Tweaked.
{$ENDIF}
     // * GIFDelayExp:
       // The following delay values should all
                                        // be multiplied by this value to
                                        // calculate the effective time (in mS).
                                        // According to the GIF specs, this
                                        // value should be 10.
                                        // Since our paint routines are much
                                        // faster than Mozilla's, you might need
                                        // to increase this value if your
                                        // animations loops too fast. The
                                        // optimal value is impossible to
                                        // determine since it depends on the
                                        // speed of the CPU, the viceo card,
                                        // memory and many other factors.

  GIFDefaultDelay: integer = 10; // * GIFDefaultDelay:
       // Default animation delay.
       // This value is used if no GCE is
                                        // defined.
                                        // (10 = 100 mS)

{$IFDEF FAST_AS_HELL}
  GIFMinimumDelay: integer = 1; // Minimum delay (from Mozilla source).
       // (1 = 10 mS)
{$ELSE}
  GIFMinimumDelay: integer = 3; // Minimum delay - Tweaked.
{$ENDIF}
     // * GIFMinimumDelay:
     // The minumum delay used in the Mozilla
                                        // source is 10mS. This corresponds to a
                                        // value of 1. However, since our paint
                                        // routines are much faster than
                                        // Mozilla's, a value of 3 or 4 gives
                                        // better results.

  GIFMaximumDelay: integer = 1000; // * GIFMaximumDelay:
       // Maximum delay when painter is running
       // in main thread (goAsync is not set).
                                        // This value guarantees that a very
                                        // long and slow GIF does not hang the
                                        // system.
                                        // (1000 = 10000 mS = 10 Seconds)

Type
  TGIFVersion = (gvUnknown, gv87a, gv89a);
  TGIFVersionRec = Array[0..2] Of char;

Const
  GIFVersions: Array[gv87a..gv89a] Of TGIFVersionRec = ('87a', '89a');

Type
  // TGIFImage mostly throws exceptions of type GIFException
  GIFException = Class(EInvalidGraphic);

  // Severity level as indicated in the Warning methods and the OnWarning event
  TGIFSeverity = (gsInfo, gsWarning, gsError);

////////////////////////////////////////////////////////////////////////////////
//
//			Delphi 2.x support
//
////////////////////////////////////////////////////////////////////////////////
{$IFDEF VER9x}
// Delphi 2 doesn't support TBitmap.PixelFormat
{$DEFINE PIXELFORMAT_TOO_SLOW}
Type
  // TThreadList from Delphi 3 classes.pas
  TThreadList = Class
  Private
    FList: TList;
    FLock: TRTLCriticalSection;
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Procedure Add(Item: Pointer);
    Procedure Clear;
    Function LockList: TList;
    Procedure Remove(Item: Pointer);
    Procedure UnlockList;
  End;

  // From Delphi 3 sysutils.pas
  EOutOfMemory = Class(Exception);

  // From Delphi 3 classes.pas
  EOutOfResources = Class(EOutOfMemory);

  // From Delphi 3 windows.pas
  PMaxLogPalette = ^TMaxLogPalette;
  TMaxLogPalette = Packed Record
    palVersion: Word;
    palNumEntries: Word;
    palPalEntry: Array[Byte] Of TPaletteEntry;
  End; { TMaxLogPalette }

  // From Delphi 3 graphics.pas. Used by the D3 TGraphic class.
  TProgressStage = (psStarting, psRunning, psEnding);
  TProgressEvent = Procedure(Sender: TObject; Stage: TProgressStage;
    PercentDone: Byte; RedrawNow: Boolean; Const R: TRect; Const Msg: String) Of Object;

  // From Delphi 3 windows.pas
  PRGBTriple = ^TRGBTriple;
{$ENDIF}

////////////////////////////////////////////////////////////////////////////////
//
//			Forward declarations
//
////////////////////////////////////////////////////////////////////////////////
Type
  TGIFImage = Class;
  TGIFSubImage = Class;

////////////////////////////////////////////////////////////////////////////////
//
//			TGIFItem
//
////////////////////////////////////////////////////////////////////////////////
  TGIFItem = Class(TPersistent)
  Private
    FGIFImage: TGIFImage;
  Protected
    Function GetVersion: TGIFVersion; Virtual;
    Procedure Warning(Severity: TGIFSeverity; Message: String); Virtual;
  Public
    Constructor Create(GIFImage: TGIFImage); Virtual;

    Procedure SaveToStream(Stream: TStream); Virtual; Abstract;
    Procedure LoadFromStream(Stream: TStream); Virtual; Abstract;
    Procedure SaveToFile(Const Filename: String); Virtual;
    Procedure LoadFromFile(Const Filename: String); Virtual;
    Property Version: TGIFVersion Read GetVersion;
    Property Image: TGIFImage Read FGIFImage;
  End;

////////////////////////////////////////////////////////////////////////////////
//
//			TGIFList
//
////////////////////////////////////////////////////////////////////////////////
  TGIFList = Class(TPersistent)
  Private
    FItems: TList;
    FImage: TGIFImage;
  Protected
    Function GetItem(Index: integer): TGIFItem;
    Procedure SetItem(Index: integer; Item: TGIFItem);
    Function GetCount: integer;
    Procedure Warning(Severity: TGIFSeverity; Message: String); Virtual;
  Public
    Constructor Create(Image: TGIFImage);
    Destructor Destroy; Override;

    Function Add(Item: TGIFItem): integer;
    Procedure Clear;
    Procedure Delete(Index: integer);
    Procedure Exchange(Index1, Index2: integer);
    Function First: TGIFItem;
    Function IndexOf(Item: TGIFItem): integer;
    Procedure Insert(Index: integer; Item: TGIFItem);
    Function Last: TGIFItem;
    Procedure Move(CurIndex, NewIndex: integer);
    Function Remove(Item: TGIFItem): integer;
    Procedure SaveToStream(Stream: TStream); Virtual;
    Procedure LoadFromStream(Stream: TStream; Parent: TObject); Virtual; Abstract;

    Property Items[Index: integer]: TGIFItem Read GetItem Write SetItem; Default;
    Property Count: integer Read GetCount;
    Property List: TList Read FItems;
    Property Image: TGIFImage Read FImage;
  End;

////////////////////////////////////////////////////////////////////////////////
//
//			TGIFColorMap
//
////////////////////////////////////////////////////////////////////////////////
  // One way to do it:
  //  TBaseColor = (bcRed, bcGreen, bcBlue);
  //  TGIFColor = array[bcRed..bcBlue] of BYTE;
  // Another way:
  TGIFColor = Packed Record
    Red: Byte;
    Green: Byte;
    Blue: Byte;
  End;

  TColorMap = Packed Array[0..GIFMaxColors - 1] Of TGIFColor;
  PColorMap = ^TColorMap;

  TUsageCount = Record
    Count: integer; // # of pixels using color index
    Index: integer; // Color index
  End;
  TColormapHistogram = Array[0..255] Of TUsageCount;
  TColormapReverse = Array[0..255] Of Byte;

  TGIFColorMap = Class(TPersistent)
  Private
    FColorMap: PColorMap;
    FCount: integer;
    FCapacity: integer;
    FOptimized: Boolean;
  Protected
    Function GetColor(Index: integer): TColor;
    Procedure SetColor(Index: integer; Value: TColor);
    Function GetBitsPerPixel: integer;
    Function DoOptimize: Boolean;
    Procedure SetCapacity(Size: integer);
    Procedure Warning(Severity: TGIFSeverity; Message: String); Virtual; Abstract;
    Procedure BuildHistogram(Var Histogram: TColormapHistogram); Virtual; Abstract;
    Procedure MapImages(Var Map: TColormapReverse); Virtual; Abstract;

  Public
    Constructor Create;
    Destructor Destroy; Override;
    Class Function Color2RGB(Color: TColor): TGIFColor;
    Class Function RGB2Color(Color: TGIFColor): TColor;
    Procedure SaveToStream(Stream: TStream);
    Procedure LoadFromStream(Stream: TStream; Count: integer);
    Procedure Assign(Source: TPersistent); Override;
    Function IndexOf(Color: TColor): integer;
    Function Add(Color: TColor): integer;
    Function AddUnique(Color: TColor): integer;
    Procedure Delete(Index: integer);
    Procedure Clear;
    Function Optimize: Boolean; Virtual; Abstract;
    Procedure Changed; Virtual; Abstract;
    Procedure ImportPalette(Palette: HPalette);
    Procedure ImportColorTable(Pal: Pointer; Count: integer);
    Procedure ImportDIBColors(Handle: HDC);
    Procedure ImportColorMap(Map: TColorMap; Count: integer);
    Function ExportPalette: HPalette;
    Property Colors[Index: integer]: TColor Read GetColor Write SetColor; Default;
    Property Data: PColorMap Read FColorMap;
    Property Count: integer Read FCount;
    Property Optimized: Boolean Read FOptimized Write FOptimized;
    Property BitsPerPixel: integer Read GetBitsPerPixel;
  End;

////////////////////////////////////////////////////////////////////////////////
//
//			TGIFHeader
//
////////////////////////////////////////////////////////////////////////////////
  TLogicalScreenDescriptor = Packed Record
    ScreenWidth: Word; { logical screen width }
    ScreenHeight: Word; { logical screen height }
    PackedFields: Byte; { packed fields }
    BackgroundColorIndex: Byte; { index to global color table }
    AspectRatio: Byte; { actual ratio = (AspectRatio + 15) / 64 }
  End;

  TGIFHeader = Class(TGIFItem)
  Private
    FLogicalScreenDescriptor: TLogicalScreenDescriptor;
    FColorMap: TGIFColorMap;
    Procedure Prepare;
  Protected
    Function GetVersion: TGIFVersion; Override;
    Function GetBackgroundColor: TColor;
    Procedure SetBackgroundColor(Color: TColor);
    Procedure SetBackgroundColorIndex(Index: Byte);
    Function GetBitsPerPixel: integer;
    Function GetColorResolution: integer;
  Public
    Constructor Create(GIFImage: TGIFImage); Override;
    Destructor Destroy; Override;
    Procedure Assign(Source: TPersistent); Override;
    Procedure SaveToStream(Stream: TStream); Override;
    Procedure LoadFromStream(Stream: TStream); Override;
    Procedure Clear;
    Property Version: TGIFVersion Read GetVersion;
    Property Width: Word Read FLogicalScreenDescriptor.ScreenWidth
      Write FLogicalScreenDescriptor.ScreenWidth;
    Property Height: Word Read FLogicalScreenDescriptor.ScreenHeight
      Write FLogicalScreenDescriptor.ScreenHeight;
    Property BackgroundColorIndex: Byte Read FLogicalScreenDescriptor.BackgroundColorIndex
      Write SetBackgroundColorIndex;
    Property BackgroundColor: TColor Read GetBackgroundColor
      Write SetBackgroundColor;
    Property AspectRatio: Byte Read FLogicalScreenDescriptor.AspectRatio
      Write FLogicalScreenDescriptor.AspectRatio;
    Property ColorMap: TGIFColorMap Read FColorMap;
    Property BitsPerPixel: integer Read GetBitsPerPixel;
    Property ColorResolution: integer Read GetColorResolution;
  End;

////////////////////////////////////////////////////////////////////////////////
//
//                      TGIFExtension
//
////////////////////////////////////////////////////////////////////////////////
  TGIFExtensionType = Byte;
  TGIFExtension = Class;
  TGIFExtensionClass = Class Of TGIFExtension;

  TGIFGraphicControlExtension = Class;

  TGIFExtension = Class(TGIFItem)
  Private
    FSubImage: TGIFSubImage;
  Protected
    Function GetExtensionType: TGIFExtensionType; Virtual; Abstract;
    Function GetVersion: TGIFVersion; Override;
    Function DoReadFromStream(Stream: TStream): TGIFExtensionType;
    Class Procedure RegisterExtension(elabel: Byte; eClass: TGIFExtensionClass);
    Class Function FindExtension(Stream: TStream): TGIFExtensionClass;
    Class Function FindSubExtension(Stream: TStream): TGIFExtensionClass; Virtual;
  Public
     // Ignore compiler warning about hiding base class constructor
    Constructor Create(ASubImage: TGIFSubImage); {$IFDEF VER12_PLUS} Reintroduce; {$ENDIF} Virtual;
    Destructor Destroy; Override;
    Procedure SaveToStream(Stream: TStream); Override;
    Procedure LoadFromStream(Stream: TStream); Override;
    Property ExtensionType: TGIFExtensionType Read GetExtensionType;
    Property SubImage: TGIFSubImage Read FSubImage;
  End;

////////////////////////////////////////////////////////////////////////////////
//
//			TGIFSubImage
//
////////////////////////////////////////////////////////////////////////////////
  TGIFExtensionList = Class(TGIFList)
  Protected
    Function GetExtension(Index: integer): TGIFExtension;
    Procedure SetExtension(Index: integer; Extension: TGIFExtension);
  Public
    Procedure LoadFromStream(Stream: TStream; Parent: TObject); Override;
    Property Extensions[Index: integer]: TGIFExtension Read GetExtension Write SetExtension; Default;
  End;

  TImageDescriptor = Packed Record
    Separator: Byte; { fixed value of ImageSeparator }
    Left: Word; { Column in pixels in respect to left edge of logical screen }
    Top: Word; { row in pixels in respect to top of logical screen }
    Width: Word; { width of image in pixels }
    Height: Word; { height of image in pixels }
    PackedFields: Byte; { Bit fields }
  End;

  TGIFSubImage = Class(TGIFItem)
  Private
    FBitmap: TBitmap;
    FMask: HBitmap;
    FNeedMask: Boolean;
    FLocalPalette: HPalette;
    FData: PChar;
    FDataSize: integer;
    FColorMap: TGIFColorMap;
    FImageDescriptor: TImageDescriptor;
    FExtensions: TGIFExtensionList;
    FTransparent: Boolean;
    FGCE: TGIFGraphicControlExtension;
    Procedure Prepare;
    Procedure Compress(Stream: TStream);
    Procedure Decompress(Stream: TStream);
  Protected
    Function GetVersion: TGIFVersion; Override;
    Function GetInterlaced: Boolean;
    Procedure SetInterlaced(Value: Boolean);
    Function GetColorResolution: integer;
    Function GetBitsPerPixel: integer;
    Procedure AssignTo(Dest: TPersistent); Override;
    Function DoGetBitmap: TBitmap;
    Function DoGetDitherBitmap: TBitmap;
    Function GetBitmap: TBitmap;
    Procedure SetBitmap(Value: TBitmap);
    Procedure FreeMask;
    Function GetEmpty: Boolean;
    Function GetPalette: HPalette;
    Procedure SetPalette(Value: HPalette);
    Function GetActiveColorMap: TGIFColorMap;
    Function GetBoundsRect: TRect;
    Procedure SetBoundsRect(Const Value: TRect);
    Procedure DoSetBounds(ALeft, ATop, AWidth, AHeight: integer);
    Function GetClientRect: TRect;
    Function GetPixel(x, y: integer): Byte;
    Function GetScanline(y: integer): Pointer;
    Procedure NewBitmap;
    Procedure FreeBitmap;
    Procedure NewImage;
    Procedure FreeImage;
    Procedure NeedImage;
    Function ScaleRect(DestRect: TRect): TRect;
    Function HasMask: Boolean;
    Function GetBounds(Index: integer): Word;
    Procedure SetBounds(Index: integer; Value: Word);
    Function GetHasBitmap: Boolean;
    Procedure SetHasBitmap(Value: Boolean);
  Public
    Constructor Create(GIFImage: TGIFImage); Override;
    Destructor Destroy; Override;
    Procedure Clear;
    Procedure SaveToStream(Stream: TStream); Override;
    Procedure LoadFromStream(Stream: TStream); Override;
    Procedure Assign(Source: TPersistent); Override;
    Procedure Draw(ACanvas: TCanvas; Const Rect: TRect;
      DoTransparent, DoTile: Boolean);
    Procedure StretchDraw(ACanvas: TCanvas; Const Rect: TRect;
      DoTransparent, DoTile: Boolean);
    Procedure Crop;
    Procedure Merge(Previous: TGIFSubImage);
    Property HasBitmap: Boolean Read GetHasBitmap Write SetHasBitmap;
    Property Left: Word Index 1 Read GetBounds Write SetBounds;
    Property Top: Word Index 2 Read GetBounds Write SetBounds;
    Property Width: Word Index 3 Read GetBounds Write SetBounds;
    Property Height: Word Index 4 Read GetBounds Write SetBounds;
    Property BoundsRect: TRect Read GetBoundsRect Write SetBoundsRect;
    Property ClientRect: TRect Read GetClientRect;
    Property Interlaced: Boolean Read GetInterlaced Write SetInterlaced;
    Property ColorMap: TGIFColorMap Read FColorMap;
    Property ActiveColorMap: TGIFColorMap Read GetActiveColorMap;
    Property Data: PChar Read FData;
    Property DataSize: integer Read FDataSize;
    Property Extensions: TGIFExtensionList Read FExtensions;
    Property Version: TGIFVersion Read GetVersion;
    Property ColorResolution: integer Read GetColorResolution;
    Property BitsPerPixel: integer Read GetBitsPerPixel;
    Property Bitmap: TBitmap Read GetBitmap Write SetBitmap;
    Property Mask: HBitmap Read FMask;
    Property Palette: HPalette Read GetPalette Write SetPalette;
    Property Empty: Boolean Read GetEmpty;
    Property Transparent: Boolean Read FTransparent;
    Property GraphicControlExtension: TGIFGraphicControlExtension Read FGCE;
    Property Pixels[x, y: integer]: Byte Read GetPixel;
    Property Scanline[y: integer]: Pointer Read GetScanline;
  End;

////////////////////////////////////////////////////////////////////////////////
//
//                      TGIFTrailer
//
////////////////////////////////////////////////////////////////////////////////
  TGIFTrailer = Class(TGIFItem)
    Procedure SaveToStream(Stream: TStream); Override;
    Procedure LoadFromStream(Stream: TStream); Override;
  End;

////////////////////////////////////////////////////////////////////////////////
//
//                      TGIFGraphicControlExtension
//
////////////////////////////////////////////////////////////////////////////////
  // Graphic Control Extension block a.k.a GCE
  TGIFGCERec = Packed Record
    BlockSize: Byte; { should be 4 }
    PackedFields: Byte;
    DelayTime: Word; { in centiseconds }
    TransparentColorIndex: Byte;
    Terminator: Byte;
  End;

  TDisposalMethod = (dmNone, dmNoDisposal, dmBackground, dmPrevious);

  TGIFGraphicControlExtension = Class(TGIFExtension)
  Private
    FGCExtension: TGIFGCERec;
  Protected
    Function GetExtensionType: TGIFExtensionType; Override;
    Function GetTransparent: Boolean;
    Procedure SetTransparent(Value: Boolean);
    Function GetTransparentColor: TColor;
    Procedure SetTransparentColor(Color: TColor);
    Function GetTransparentColorIndex: Byte;
    Procedure SetTransparentColorIndex(Value: Byte);
    Function GetDelay: Word;
    Procedure SetDelay(Value: Word);
    Function GetUserInput: Boolean;
    Procedure SetUserInput(Value: Boolean);
    Function GetDisposal: TDisposalMethod;
    Procedure SetDisposal(Value: TDisposalMethod);

  Public
    Constructor Create(ASubImage: TGIFSubImage); Override;
    Destructor Destroy; Override;
    Procedure SaveToStream(Stream: TStream); Override;
    Procedure LoadFromStream(Stream: TStream); Override;
    Property Delay: Word Read GetDelay Write SetDelay;
    Property Transparent: Boolean Read GetTransparent Write SetTransparent;
    Property TransparentColorIndex: Byte Read GetTransparentColorIndex
      Write SetTransparentColorIndex;
    Property TransparentColor: TColor Read GetTransparentColor Write SetTransparentColor;
    Property UserInput: Boolean Read GetUserInput Write SetUserInput;
    Property Disposal: TDisposalMethod Read GetDisposal Write SetDisposal;
  End;

////////////////////////////////////////////////////////////////////////////////
//
//                      TGIFTextExtension
//
////////////////////////////////////////////////////////////////////////////////
  TGIFPlainTextExtensionRec = Packed Record
    BlockSize: Byte; { should be 12 }
    Left, Top, Width, Height: Word;
    CellWidth, CellHeight: Byte;
    TextFGColorIndex,
      TextBGColorIndex: Byte;
  End;

  TGIFTextExtension = Class(TGIFExtension)
  Private
    FText: TStrings;
    FPlainTextExtension: TGIFPlainTextExtensionRec;
  Protected
    Function GetExtensionType: TGIFExtensionType; Override;
    Function GetForegroundColor: TColor;
    Procedure SetForegroundColor(Color: TColor);
    Function GetBackgroundColor: TColor;
    Procedure SetBackgroundColor(Color: TColor);
    Function GetBounds(Index: integer): Word;
    Procedure SetBounds(Index: integer; Value: Word);
    Function GetCharWidthHeight(Index: integer): Byte;
    Procedure SetCharWidthHeight(Index: integer; Value: Byte);
    Function GetColorIndex(Index: integer): Byte;
    Procedure SetColorIndex(Index: integer; Value: Byte);
  Public
    Constructor Create(ASubImage: TGIFSubImage); Override;
    Destructor Destroy; Override;
    Procedure SaveToStream(Stream: TStream); Override;
    Procedure LoadFromStream(Stream: TStream); Override;
    Property Left: Word Index 1 Read GetBounds Write SetBounds;
    Property Top: Word Index 2 Read GetBounds Write SetBounds;
    Property GridWidth: Word Index 3 Read GetBounds Write SetBounds;
    Property GridHeight: Word Index 4 Read GetBounds Write SetBounds;
    Property CharWidth: Byte Index 1 Read GetCharWidthHeight Write SetCharWidthHeight;
    Property CharHeight: Byte Index 2 Read GetCharWidthHeight Write SetCharWidthHeight;
    Property ForegroundColorIndex: Byte Index 1 Read GetColorIndex Write SetColorIndex;
    Property ForegroundColor: TColor Read GetForegroundColor;
    Property BackgroundColorIndex: Byte Index 2 Read GetColorIndex Write SetColorIndex;
    Property BackgroundColor: TColor Read GetBackgroundColor;
    Property Text: TStrings Read FText Write FText;
  End;

////////////////////////////////////////////////////////////////////////////////
//
//                      TGIFCommentExtension
//
////////////////////////////////////////////////////////////////////////////////
  TGIFCommentExtension = Class(TGIFExtension)
  Private
    FText: TStrings;
  Protected
    Function GetExtensionType: TGIFExtensionType; Override;
  Public
    Constructor Create(ASubImage: TGIFSubImage); Override;
    Destructor Destroy; Override;
    Procedure SaveToStream(Stream: TStream); Override;
    Procedure LoadFromStream(Stream: TStream); Override;
    Property Text: TStrings Read FText;
  End;

////////////////////////////////////////////////////////////////////////////////
//
//                      TGIFApplicationExtension
//
////////////////////////////////////////////////////////////////////////////////
  TGIFIdentifierCode = Array[0..7] Of char;
  TGIFAuthenticationCode = Array[0..2] Of char;
  TGIFApplicationRec = Packed Record
    Identifier: TGIFIdentifierCode;
    Authentication: TGIFAuthenticationCode;
  End;

  TGIFApplicationExtension = Class;
  TGIFAppExtensionClass = Class Of TGIFApplicationExtension;

  TGIFApplicationExtension = Class(TGIFExtension)
  Private
    FIdent: TGIFApplicationRec;
    Function GetAuthentication: String;
    Function GetIdentifier: String;
  Protected
    Function GetExtensionType: TGIFExtensionType; Override;
    Procedure SetAuthentication(Const Value: String);
    Procedure SetIdentifier(Const Value: String);
    Procedure SaveData(Stream: TStream); Virtual; Abstract;
    Procedure LoadData(Stream: TStream); Virtual; Abstract;
  Public
    Constructor Create(ASubImage: TGIFSubImage); Override;
    Destructor Destroy; Override;
    Procedure SaveToStream(Stream: TStream); Override;
    Procedure LoadFromStream(Stream: TStream); Override;
    Class Procedure RegisterExtension(eIdent: TGIFApplicationRec; eClass: TGIFAppExtensionClass);
    Class Function FindSubExtension(Stream: TStream): TGIFExtensionClass; Override;
    Property Identifier: String Read GetIdentifier Write SetIdentifier;
    Property Authentication: String Read GetAuthentication Write SetAuthentication;
  End;

////////////////////////////////////////////////////////////////////////////////
//
//                      TGIFUnknownAppExtension
//
////////////////////////////////////////////////////////////////////////////////
  TGIFBlock = Class(TObject)
  Private
    FSize: Byte;
    FData: Pointer;
  Public
    Constructor Create(ASize: integer);
    Destructor Destroy; Override;
    Procedure SaveToStream(Stream: TStream);
    Procedure LoadFromStream(Stream: TStream);
    Property Size: Byte Read FSize;
    Property Data: Pointer Read FData;
  End;

  TGIFUnknownAppExtension = Class(TGIFApplicationExtension)
  Private
    FBlocks: TList;
  Protected
    Procedure SaveData(Stream: TStream); Override;
    Procedure LoadData(Stream: TStream); Override;
  Public
    Constructor Create(ASubImage: TGIFSubImage); Override;
    Destructor Destroy; Override;
    Property Blocks: TList Read FBlocks;
  End;

////////////////////////////////////////////////////////////////////////////////
//
//                      TGIFAppExtNSLoop
//
////////////////////////////////////////////////////////////////////////////////
  TGIFAppExtNSLoop = Class(TGIFApplicationExtension)
  Private
    FLoops: Word;
    FBufferSize: DWORD;
  Protected
    Procedure SaveData(Stream: TStream); Override;
    Procedure LoadData(Stream: TStream); Override;
  Public
    Constructor Create(ASubImage: TGIFSubImage); Override;
    Property Loops: Word Read FLoops Write FLoops;
    Property BufferSize: DWORD Read FBufferSize Write FBufferSize;
  End;

////////////////////////////////////////////////////////////////////////////////
//
//                      TGIFImage
//
////////////////////////////////////////////////////////////////////////////////
  TGIFImageList = Class(TGIFList)
  Protected
    Function GetImage(Index: integer): TGIFSubImage;
    Procedure SetImage(Index: integer; SubImage: TGIFSubImage);
  Public
    Procedure LoadFromStream(Stream: TStream; Parent: TObject); Override;
    Procedure SaveToStream(Stream: TStream); Override;
    Property SubImages[Index: integer]: TGIFSubImage Read GetImage Write SetImage; Default;
  End;

  // Compression algorithms
  TGIFCompression =
    (gcLZW, // Normal LZW compression
    gcRLE // GIF compatible RLE compression
    );

  // Color reduction methods
  TColorReduction =
    (rmNone, // Do not perform color reduction
    rmWindows20, // Reduce to the Windows 20 color system palette
    rmWindows256, // Reduce to the Windows 256 color halftone palette (Only works in 256 color display mode)
    rmWindowsGray, // Reduce to the Windows 4 grayscale colors
    rmMonochrome, // Reduce to a black/white monochrome palette
    rmGrayScale, // Reduce to a uniform 256 shade grayscale palette
    rmNetscape, // Reduce to the Netscape 216 color palette
    rmQuantize, // Reduce to optimal 2^n color palette
    rmQuantizeWindows, // Reduce to optimal 256 color windows palette
    rmPalette // Reduce to custom palette
    );
  TDitherMode =
    (dmNearest, // Nearest color matching w/o error correction
    dmFloydSteinberg, // Floyd Steinberg Error Diffusion dithering
    dmStucki, // Stucki Error Diffusion dithering
    dmSierra, // Sierra Error Diffusion dithering
    dmJaJuNI, // Jarvis, Judice & Ninke Error Diffusion dithering
    dmSteveArche, // Stevenson & Arche Error Diffusion dithering
    dmBurkes // Burkes Error Diffusion dithering
     // dmOrdered,		// Ordered dither
    );

  // Optimization options
  TGIFOptimizeOption =
    (ooCrop, // Crop animated GIF frames
    ooMerge, // Merge pixels of same color
    ooCleanup, // Remove comments and application extensions
    ooColorMap, // Sort color map by usage and remove unused entries
    ooReduceColors // Reduce color depth ***NOT IMPLEMENTED***
    );
  TGIFOptimizeOptions = Set Of TGIFOptimizeOption;

  TGIFDrawOption =
    (goAsync, // Asyncronous draws (paint in thread)
    goTransparent, // Transparent draws
    goAnimate, // Animate draws
    goLoop, // Loop animations
    goLoopContinously, // Ignore loop count and loop forever
    goValidateCanvas, // Validate canvas in threaded paint ***NOT IMPLEMENTED***
    goDirectDraw, // Draw() directly on canvas
    goClearOnLoop, // Clear animation on loop
    goTile, // Tiled display
    goDither, // Dither to Netscape palette
    goAutoDither // Only dither on 256 color systems
    );
  TGIFDrawOptions = Set Of TGIFDrawOption;
  // Note: if goAsync is not set then goDirectDraw should be set. Otherwise
  // the image will not be displayed.

  PGIFPainter = ^TGIFPainter;

  TGIFPainter = Class(TThread)
  Private
    FImage: TGIFImage; // The TGIFImage that owns this painter
    FCanvas: TCanvas; // Destination canvas
    FRect: TRect; // Destination rect
    FDrawOptions: TGIFDrawOptions; // Paint options
    FAnimationSpeed: integer; // Animation speed %
    FActiveImage: integer; // Current frame
    Disposal, // Used by synchronized paint
      OldDisposal: TDisposalMethod; // Used by synchronized paint
    BackupBuffer: TBitmap; // Used by synchronized paint
    FrameBuffer: TBitmap; // Used by synchronized paint
    Background: TBitmap; // Used by synchronized paint
    ValidateDC: HDC;
    DoRestart: Boolean; // Flag used to restart animation
    FStarted: Boolean; // Flag used to signal start of paint
    PainterRef: PGIFPainter; // Pointer to var referencing painter
    FEventHandle: THandle; // Animation delay event
    ExceptObject: Exception; // Eaten exception
    ExceptAddress: Pointer; // Eaten exceptions address
    FEvent: TNotifyEvent; // Used by synchronized events
    FOnStartPaint: TNotifyEvent;
    FOnPaint: TNotifyEvent;
    FOnAfterPaint: TNotifyEvent;
    FOnLoop: TNotifyEvent;
    FOnEndPaint: TNotifyEvent;
    Procedure DoOnTerminate(Sender: TObject); // Sync. shutdown procedure
    Procedure DoSynchronize(Method: TThreadMethod); // Conditional sync stub
{$IFDEF SERIALIZE_RENDER}
    Procedure PrefetchBitmap; // Sync. bitmap prefetch
{$ENDIF}
    Procedure DoPaintFrame; // Sync. buffered paint procedure
    Procedure DoPaint; // Sync. paint procedure
    Procedure DoEvent;
    Procedure SetActiveImage(Const Value: integer); // Sync. event procedure
  Protected
    Procedure Execute; Override;
    Procedure SetAnimationSpeed(Value: integer);
  Public
    Constructor Create(AImage: TGIFImage; ACanvas: TCanvas; ARect: TRect;
      Options: TGIFDrawOptions);
    Constructor CreateRef(Painter: PGIFPainter; AImage: TGIFImage; ACanvas: TCanvas; ARect: TRect;
      Options: TGIFDrawOptions);
    Destructor Destroy; Override;
    Procedure Start;
    Procedure Stop;
    Procedure Restart;
    Property Image: TGIFImage Read FImage;
    Property Canvas: TCanvas Read FCanvas;
    Property Rect: TRect Read FRect Write FRect;
    Property DrawOptions: TGIFDrawOptions Read FDrawOptions Write FDrawOptions;
    Property AnimationSpeed: integer Read FAnimationSpeed Write SetAnimationSpeed;
    Property Started: Boolean Read FStarted;
    Property ActiveImage: integer Read FActiveImage Write SetActiveImage;
    Property OnStartPaint: TNotifyEvent Read FOnStartPaint Write FOnStartPaint;
    Property OnPaint: TNotifyEvent Read FOnPaint Write FOnPaint;
    Property OnAfterPaint: TNotifyEvent Read FOnAfterPaint Write FOnAfterPaint;
    Property OnLoop: TNotifyEvent Read FOnLoop Write FOnLoop;
    Property OnEndPaint: TNotifyEvent Read FOnEndPaint Write FOnEndPaint;
    Property EventHandle: THandle Read FEventHandle;
  End;

  TGIFWarning = Procedure(Sender: TObject; Severity: TGIFSeverity; Message: String) Of Object;

  TGIFImage = Class(TGraphic)
  Private
    IsDrawing: Boolean;
    IsInsideGetPalette: Boolean;
    FImages: TGIFImageList;
    FHeader: TGIFHeader;
    FGlobalPalette: HPalette;
    FPainters: TThreadList;
    FDrawOptions: TGIFDrawOptions;
    FColorReduction: TColorReduction;
    FReductionBits: integer;
    FDitherMode: TDitherMode;
    FCompression: TGIFCompression;
    FOnWarning: TGIFWarning;
    FBitmap: TBitmap;
    FDrawPainter: TGIFPainter;
    FThreadPriority: TThreadPriority;
    FAnimationSpeed: integer;
    FForceFrame: integer; // 2004.03.09
    FDrawBackgroundColor: TColor;
    FOnStartPaint: TNotifyEvent;
    FOnPaint: TNotifyEvent;
    FOnAfterPaint: TNotifyEvent;
    FOnLoop: TNotifyEvent;
    FOnEndPaint: TNotifyEvent;
{$IFDEF VER9x}
    FPaletteModified: Boolean;
    FOnProgress: TProgressEvent;
{$ENDIF}
    Function GetAnimate: Boolean; // 2002.07.07
    Procedure SetAnimate(Const Value: Boolean); // 2002.07.07
    Procedure SetForceFrame(Const Value: integer); // 2004.03.09
  Protected
    // Obsolete: procedure Changed(Sender: TObject); {$IFDEF VER9x} virtual; {$ELSE} override; {$ENDIF}
    Function GetHeight: integer; Override;
    Procedure SetHeight(Value: integer); Override;
    Function GetWidth: integer; Override;
    Procedure SetWidth(Value: integer); Override;
    Procedure AssignTo(Dest: TPersistent); Override;
    Function InternalPaint(Painter: PGIFPainter; ACanvas: TCanvas; Const Rect: TRect; Options: TGIFDrawOptions): TGIFPainter;
    Procedure Draw(ACanvas: TCanvas; Const Rect: TRect); Override;
    Function Equals(Graphic: TGraphic): Boolean; Override;
    Function GetPalette: HPalette; {$IFDEF VER9x} Virtual; {$ELSE} Override; {$ENDIF}
    Procedure SetPalette(Value: HPalette); {$IFDEF VER9x} Virtual; {$ELSE} Override; {$ENDIF}
    Function GetEmpty: Boolean; Override;
    Procedure WriteData(Stream: TStream); Override;
    Function GetIsTransparent: Boolean;
    Function GetVersion: TGIFVersion;
    Function GetColorResolution: integer;
    Function GetBitsPerPixel: integer;
    Function GetBackgroundColorIndex: Byte;
    Procedure SetBackgroundColorIndex(Const Value: Byte);
    Function GetBackgroundColor: TColor;
    Procedure SetBackgroundColor(Const Value: TColor);
    Function GetAspectRatio: Byte;
    Procedure SetAspectRatio(Const Value: Byte);
    Procedure SetDrawOptions(Value: TGIFDrawOptions);
    Procedure SetAnimationSpeed(Value: integer);
    Procedure SetReductionBits(Value: integer);
    Procedure NewImage;
    Function GetBitmap: TBitmap;
    Function NewBitmap: TBitmap;
    Procedure FreeBitmap;
    Function GetColorMap: TGIFColorMap;
    Function GetDoDither: Boolean;
    Property DrawPainter: TGIFPainter Read FDrawPainter; // Extremely volatile
    Property DoDither: Boolean Read GetDoDither;
{$IFDEF VER9x}
    Procedure Progress(Sender: TObject; Stage: TProgressStage;
      PercentDone: Byte; RedrawNow: Boolean; Const R: TRect; Const Msg: String); Dynamic;
{$ENDIF}
  Public
    Constructor Create; Override;
    Destructor Destroy; Override;
    Procedure SaveToStream(Stream: TStream); Override;
    Procedure LoadFromStream(Stream: TStream); Override;
    Procedure LoadFromResourceName(Instance: THandle; Const ResName: String; ResType: PChar); // 2002.07.07
    Procedure LoadFromResourceID(Instance: THandle; ResID: integer; ResType: PChar);
    Function Add(Source: TPersistent): integer;
    Procedure Pack;
    Procedure OptimizeColorMap;
    Procedure Optimize(Options: TGIFOptimizeOptions;
      ColorReduction: TColorReduction; DitherMode: TDitherMode;
      ReductionBits: integer);
    Procedure Clear;
    Procedure StopDraw;
    Function Paint(ACanvas: TCanvas; Const Rect: TRect; Options: TGIFDrawOptions): TGIFPainter;
    Procedure PaintStart;
    Procedure PaintPause;
    Procedure PaintStop;
    Procedure PaintResume;
    Procedure PaintRestart;
    Procedure Warning(Sender: TObject; Severity: TGIFSeverity; Message: String); Virtual;
    Procedure Assign(Source: TPersistent); Override;
    Procedure LoadFromClipboardFormat(AFormat: Word; AData: THandle;
      APalette: HPalette); Override;
    Procedure SaveToClipboardFormat(Var AFormat: Word; Var AData: THandle;
      Var APalette: HPalette); Override;
    Property GlobalColorMap: TGIFColorMap Read GetColorMap;
    Property Version: TGIFVersion Read GetVersion;
    Property Images: TGIFImageList Read FImages;
    Property ColorResolution: integer Read GetColorResolution;
    Property BitsPerPixel: integer Read GetBitsPerPixel;
    Property BackgroundColorIndex: Byte Read GetBackgroundColorIndex Write SetBackgroundColorIndex;
    Property BackgroundColor: TColor Read GetBackgroundColor Write SetBackgroundColor;
    Property AspectRatio: Byte Read GetAspectRatio Write SetAspectRatio;
    Property Header: TGIFHeader Read FHeader; // ***OBSOLETE***
    Property IsTransparent: Boolean Read GetIsTransparent;
    Property DrawOptions: TGIFDrawOptions Read FDrawOptions Write SetDrawOptions;
    Property DrawBackgroundColor: TColor Read FDrawBackgroundColor Write FDrawBackgroundColor;
    Property ColorReduction: TColorReduction Read FColorReduction Write FColorReduction;
    Property ReductionBits: integer Read FReductionBits Write SetReductionBits;
    Property DitherMode: TDitherMode Read FDitherMode Write FDitherMode;
    Property Compression: TGIFCompression Read FCompression Write FCompression;
    Property AnimationSpeed: integer Read FAnimationSpeed Write SetAnimationSpeed;
    Property Animate: Boolean Read GetAnimate Write SetAnimate; // 2002.07.07
    Property ForceFrame: integer Read FForceFrame Write SetForceFrame; // 2004.03.09
    Property Painters: TThreadList Read FPainters;
    Property ThreadPriority: TThreadPriority Read FThreadPriority Write FThreadPriority;
    Property Bitmap: TBitmap Read GetBitmap; // Volatile - beware!
    Property OnWarning: TGIFWarning Read FOnWarning Write FOnWarning;
    Property OnStartPaint: TNotifyEvent Read FOnStartPaint Write FOnStartPaint;
    Property OnPaint: TNotifyEvent Read FOnPaint Write FOnPaint;
    Property OnAfterPaint: TNotifyEvent Read FOnAfterPaint Write FOnAfterPaint;
    Property OnLoop: TNotifyEvent Read FOnLoop Write FOnLoop;
    Property OnEndPaint: TNotifyEvent Read FOnEndPaint Write FOnEndPaint;
{$IFDEF VER9x}
    Property Palette: HPalette Read GetPalette Write SetPalette;
    Property PaletteModified: Boolean Read FPaletteModified Write FPaletteModified;
    Property OnProgress: TProgressEvent Read FOnProgress Write FOnProgress;
{$ENDIF}
  End;

////////////////////////////////////////////////////////////////////////////////
//
//                      Utility routines
//
////////////////////////////////////////////////////////////////////////////////
  // WebPalette creates a 216 color uniform palette a.k.a. the Netscape Palette
Function WebPalette: HPalette;

  // ReduceColors
  // Map colors in a bitmap to their nearest representation in a palette using
  // the methods specified by the ColorReduction and DitherMode parameters.
  // The ReductionBits parameter specifies the desired number of colors (bits
  // per pixel) when the reduction method is rmQuantize. The CustomPalette
  // specifies the palette when the rmPalette reduction method is used.
Function ReduceColors(Bitmap: TBitmap; ColorReduction: TColorReduction;
  DitherMode: TDitherMode; ReductionBits: integer; CustomPalette: HPalette): TBitmap;

  // CreateOptimizedPaletteFromManyBitmaps
  //: Performs Color Quantization on multiple bitmaps.
  // The Bitmaps parameter is a list of bitmaps. Returns an optimized palette.
Function CreateOptimizedPaletteFromManyBitmaps(Bitmaps: TList; Colors, ColorBits: integer;
  Windows: Boolean): HPalette;

{$IFDEF VER9x}
  // From Delphi 3 graphics.pas
Type
  TPixelFormat = (pfDevice, pf1bit, pf4bit, pf8bit, pf15bit, pf16bit, pf24bit, pf32bit, pfCustom);
{$ENDIF}

Procedure InternalGetDIBSizes(Bitmap: HBitmap; Var InfoHeaderSize: integer;
  Var ImageSize: longInt; PixelFormat: TPixelFormat);
Function InternalGetDIB(Bitmap: HBitmap; Palette: HPalette;
  Var BitmapInfo; Var Bits; PixelFormat: TPixelFormat): Boolean;

////////////////////////////////////////////////////////////////////////////////
//
//                      Global variables
//
////////////////////////////////////////////////////////////////////////////////
// GIF Clipboard format identifier for use by LoadFromClipboardFormat and
// SaveToClipboardFormat.
// Set in Initialization section.
Var
  CF_GIF: Word;

////////////////////////////////////////////////////////////////////////////////
//
//                      Library defaults
//
////////////////////////////////////////////////////////////////////////////////
Var
  //: Default options for TGIFImage.DrawOptions.
  GIFImageDefaultDrawOptions: TGIFDrawOptions =
  [goAsync, goLoop, goTransparent, goAnimate, goDither, goAutoDither
{$IFDEF STRICT_MOZILLA}
  , goClearOnLoop
{$ENDIF}
  ];

  // WARNING! Do not use goAsync and goDirectDraw unless you have absolute
  // control of the destination canvas.
  // TGIFPainter will continue to write on the canvas even after the canvas has
  // been deleted, unless *you* prevent it.
  // The goValidateCanvas option will fix this problem if it is ever implemented.

  //: Default color reduction methods for bitmap import.
  // These are the fastest settings, but also the ones that gives the
  // worst result (in most cases).
  GIFImageDefaultColorReduction: TColorReduction = rmNetscape;
  GIFImageDefaultColorReductionBits: integer = 8; // Range 3 - 8
  GIFImageDefaultDitherMode: TDitherMode = dmNearest;

  //: Default encoder compression method.
  GIFImageDefaultCompression: TGIFCompression = gcLZW;

  //: Default painter thread priority
  GIFImageDefaultThreadPriority: TThreadPriority = tpNormal;

  //: Default animation speed in % of normal speed (range 0 - 1000)
  GIFImageDefaultAnimationSpeed: integer = 100;

  // DoAutoDither is set to True in the initializaion section if the desktop DC
  // supports 256 colors or less.
  // It can be modified in your application to disable/enable Auto Dithering
  DoAutoDither: Boolean = False;

  // Palette is set to True in the initialization section if the desktop DC
  // supports 256 colors or less.
  // You should NOT modify it.
  PaletteDevice: Boolean = False;

  // Set GIFImageRenderOnLoad to True to render (convert to bitmap) the
  // GIF frames as they are loaded instead of rendering them on-demand.
  // This might increase resource consumption and will increase load time,
  // but will cause animated GIFs to display more smoothly.
  GIFImageRenderOnLoad: Boolean = False;

  // If GIFImageOptimizeOnStream is true, the GIF will be optimized
  // before it is streamed to the DFM file.
  // This will not affect TGIFImage.SaveToStream or SaveToFile.
  GIFImageOptimizeOnStream: Boolean = False;

////////////////////////////////////////////////////////////////////////////////
//
//                      Design Time support
//
////////////////////////////////////////////////////////////////////////////////
// Dummy component registration for design time support of GIFs in TImage
Procedure Register;

////////////////////////////////////////////////////////////////////////////////
//
//                      Error messages
//
////////////////////////////////////////////////////////////////////////////////
{$IFNDEF VER9x}
Resourcestring
{$ELSE}
Const
{$ENDIF}
  // GIF Error messages
  sOutOfData = 'Premature end of data';
  sTooManyColors = 'Color table overflow';
  sBadColorIndex = 'Invalid color index';
  sBadVersion = 'Unsupported GIF version';
  sBadSignature = 'Invalid GIF signature';
  sScreenBadColorSize = 'Invalid number of colors specified in Screen Descriptor';
  sImageBadColorSize = 'Invalid number of colors specified in Image Descriptor';
  sUnknownExtension = 'Unknown extension type';
  sBadExtensionLabel = 'Invalid extension introducer';
  sOutOfMemDIB = 'Failed to allocate memory for GIF DIB';
  sDIBCreate = 'Failed to create DIB from Bitmap';
  sDecodeTooFewBits = 'Decoder bit buffer under-run';
  sDecodeCircular = 'Circular decoder table entry';
  sBadTrailer = 'Invalid Image trailer';
  sBadExtensionInstance = 'Internal error: Extension Instance does not match Extension Label';
  sBadBlockSize = 'Unsupported Application Extension block size';
  sBadBlock = 'Unknown GIF block type';
  sUnsupportedClass = 'Object type not supported for operation';
  sInvalidData = 'Invalid GIF data';
  sBadHeight = 'Image height too small for contained frames';
  sBadWidth = 'Image width too small for contained frames';
{$IFNDEF REGISTER_TGIFIMAGE}
  sGIFToClipboard = 'Clipboard operations not supported for GIF objects';
{$ELSE}
  sFailedPaste = 'Failed to store GIF on clipboard';
{$IFDEF VER9x}
  sUnknownClipboardFormat = 'Unsupported clipboard format';
{$ENDIF}
{$ENDIF}
  sScreenSizeExceeded = 'Image exceeds Logical Screen size';
  sNoColorTable = 'No global or local color table defined';
  sBadPixelCoordinates = 'Invalid pixel coordinates';
  sUnsupportedBitmap = 'Unsupported bitmap format';
  sInvalidPixelFormat = 'Unsupported PixelFormat';
  sBadDimension = 'Invalid image dimensions';
  sNoDIB = 'Image has no DIB';
  sInvalidStream = 'Invalid stream operation';
  sInvalidColor = 'Color not in color table';
  sInvalidBitSize = 'Invalid Bits Per Pixel value';
  sEmptyColorMap = 'Color table is empty';
  sEmptyImage = 'Image is empty';
  sInvalidBitmapList = 'Invalid bitmap list';
  sInvalidReduction = 'Invalid reduction method';
{$IFDEF VER9x}
  // From Delphi 3 consts.pas
  SOutOfResources = 'Out of system resources';
  SInvalidBitmap = 'Bitmap image is not valid';
  SScanLine = 'Scan line index out of range';
{$ENDIF}

////////////////////////////////////////////////////////////////////////////////
//
//                      Misc texts
//
////////////////////////////////////////////////////////////////////////////////
  // File filter name
  sGIFImageFile = 'GIF Image';

  // Progress messages
  sProgressLoading = 'Loading...';
  sProgressSaving = 'Saving...';
  sProgressConverting = 'Converting...';
  sProgressRendering = 'Rendering...';
  sProgressCopying = 'Copying...';
  sProgressOptimizing = 'Optimizing...';


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//
//			Implementation
//
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
Implementation

{ This makes me long for the C preprocessor... }
{$IFDEF DEBUG}
{$IFDEF DEBUG_COMPRESSPERFORMANCE}
{$DEFINE DEBUG_PERFORMANCE}
{$ELSE}
{$IFDEF DEBUG_DECOMPRESSPERFORMANCE}
{$DEFINE DEBUG_PERFORMANCE}
{$ELSE}
{$IFDEF DEBUG_DITHERPERFORMANCE}
{$DEFINE DEBUG_PERFORMANCE}
{$ELSE}
{$IFDEF DEBUG_DITHERPERFORMANCE}
{$DEFINE DEBUG_PERFORMANCE}
{$ELSE}
{$IFDEF DEBUG_DRAWPERFORMANCE}
{$DEFINE DEBUG_PERFORMANCE}
{$ELSE}
{$IFDEF DEBUG_RENDERPERFORMANCE}
{$DEFINE DEBUG_PERFORMANCE}
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF}

Uses
{$IFDEF DEBUG}
  dialogs,
{$ENDIF}
  mmsystem, // timeGetTime()
  messages,
  Consts;


////////////////////////////////////////////////////////////////////////////////
//
//			Misc consts
//
////////////////////////////////////////////////////////////////////////////////
Const
  { Extension/block label values }
  bsPlainTextExtension = $01;
  bsGraphicControlExtension = $F9;
  bsCommentExtension = $FE;
  bsApplicationExtension = $FF;

  bsImageDescriptor = Ord(',');
  bsExtensionIntroducer = Ord('!');
  bsTrailer = Ord(';');

  // Thread messages - Used by TThread.Synchronize()
  CM_DESTROYWINDOW = $8FFE; // Defined in classes.pas
  CM_EXECPROC = $8FFF; // Defined in classes.pas


////////////////////////////////////////////////////////////////////////////////
//
//                      Design Time support
//
////////////////////////////////////////////////////////////////////////////////
//: Dummy component registration to add design-time support of GIFs to TImage.
// Since TGIFImage isn't a component there's nothing to register here, but
// since Register is only called at design time we can set the design time
// GIF paint options here (modify as you please):
Procedure Register;
Begin
  // Don't loop animations at design-time. Animated GIFs will animate once and
  // then stop thus not using CPU resources and distracting the developer.
  Exclude(GIFImageDefaultDrawOptions, goLoop);
End;

////////////////////////////////////////////////////////////////////////////////
//
//			Utilities
//
////////////////////////////////////////////////////////////////////////////////
//: Creates a 216 color uniform non-dithering Netscape palette.
Function WebPalette: HPalette;
Type
  TLogWebPalette = Packed Record
    palVersion: Word;
    palNumEntries: Word;
    PalEntries: Array[0..5, 0..5, 0..5] Of TPaletteEntry;
  End;
Var
  R, g, b: Byte;
  LogWebPalette: TLogWebPalette;
  LogPalette: TLogpalette Absolute LogWebPalette; // Stupid typecast
Begin
  With LogWebPalette Do
  Begin
    palVersion := $0300;
    palNumEntries := 216;
    For R := 0 To 5 Do
      For g := 0 To 5 Do
        For b := 0 To 5 Do
        Begin
          With PalEntries[R, g, b] Do
          Begin
            peRed := 51 * R;
            peGreen := 51 * g;
            peBlue := 51 * b;
            peFlags := 0;
          End;
        End;
  End;
  Result := CreatePalette(LogPalette);
End;

(*
**  GDI Error handling
**  Adapted from graphics.pas
*)
{$IFOPT R+}
{$DEFINE R_PLUS}
{$RANGECHECKS OFF}
{$ENDIF}
{$IFDEF D3_BCB3}
Function GDICheck(Value: integer): integer;
{$ELSE}
Function GDICheck(Value: Cardinal): Cardinal;
{$ENDIF}
Var
  ErrorCode: integer;
  Buf: Array[Byte] Of char;

  Function ReturnAddr: Pointer;
  // From classes.pas
  Asm
    MOV		EAX,[EBP+4] // sysutils.pas says [EBP-4], but this works !
  End;

Begin
  If (Value = 0) Then
  Begin
    ErrorCode := GetLastError;
    If (ErrorCode <> 0) And (FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, Nil,
      ErrorCode, LOCALE_USER_DEFAULT, Buf, SizeOf(Buf), Nil) <> 0) Then
      Raise EOutOfResources.Create(Buf)at ReturnAddr
    Else
      Raise EOutOfResources.Create(SOutOfResources)at ReturnAddr;
  End;
  Result := Value;
End;
{$IFDEF R_PLUS}
{$RANGECHECKS ON}
{$UNDEF R_PLUS}
{$ENDIF}

(*
**  Raise error condition
*)
Procedure Error(Msg: String);
  Function ReturnAddr: Pointer;
  // From classes.pas
  Asm
    MOV		EAX,[EBP+4] // sysutils.pas says [EBP-4] !
  End;
Begin
  Raise GIFException.Create(Msg)at ReturnAddr;
End;

(*
**  Return number bytes required to
**  hold a given number of bits.
*)
Function ByteAlignBit(Bits: Cardinal): Cardinal;
Begin
  Result := (Bits + 7) Shr 3;
End;
// Rounded up to nearest 2
Function WordAlignBit(Bits: Cardinal): Cardinal;
Begin
  Result := ((Bits + 15) Shr 4) Shl 1;
End;
// Rounded up to nearest 4
Function DWordAlignBit(Bits: Cardinal): Cardinal;
Begin
  Result := ((Bits + 31) Shr 5) Shl 2;
End;
// Round to arbitrary number of bits
Function AlignBit(Bits, BitsPerPixel, Alignment: Cardinal): Cardinal;
Begin
  Dec(Alignment);
  Result := ((Bits * BitsPerPixel) + Alignment) And Not Alignment;
  Result := Result Shr 3;
End;

(*
**  Compute Bits per Pixel from Number of Colors
**  (Return the ceiling log of n)
*)
Function Colors2bpp(Colors: integer): integer;
Var
  MaxColor: integer;
Begin
  (*
  ** This might be faster computed by multiple if then else statements
  *)

  If (Colors = 0) Then
    Result := 0
  Else
  Begin
    Result := 1;
    MaxColor := 2;
    While (Colors > MaxColor) Do
    Begin
      inc(Result);
      MaxColor := MaxColor Shl 1;
    End;
  End;
End;

(*
**  Write an ordinal byte value to a stream
*)
Procedure WriteByte(Stream: TStream; b: Byte);
Begin
  Stream.Write(b, 1);
End;

(*
**  Read an ordinal byte value from a stream
*)
Function ReadByte(Stream: TStream): Byte;
Begin
  Stream.Read(Result, 1);
End;

(*
**  Read data from stream and raise exception of EOF
*)
Procedure ReadCheck(Stream: TStream; Var Buffer; Size: longInt);
Var
  ReadSize: integer;
Begin
  ReadSize := Stream.Read(Buffer, Size);
  If (ReadSize <> Size) Then
    Error(sOutOfData);
End;

(*
**  Write a string list to a stream as multiple blocks
**  of max 255 characters in each.
*)
Procedure WriteStrings(Stream: TStream; Text: TStrings);
Var
  i: integer;
  b: Byte;
  Size: integer;
  s: String;
Begin
  For i := 0 To Text.Count - 1 Do
  Begin
    s := Text[i];
    Size := Length(s);
    If (Size > 255) Then
      b := 255
    Else
      b := Size;
    While (Size > 0) Do
    Begin
      Dec(Size, b);
      WriteByte(Stream, b);
      Stream.Write(PChar(s)^, b);
      Delete(s, 1, b);
      If (b > Size) Then
        b := Size;
    End;
  End;
  // Terminating zero (length = 0)
  WriteByte(Stream, 0);
End;


(*
**  Read a string list from a stream as multiple blocks
**  of max 255 characters in each.
*)
{ TODO -oanme -cImprovement : Replace ReadStrings with TGIFReader. }
Procedure ReadStrings(Stream: TStream; Text: TStrings);
Var
  Size: Byte;
  Buf: Array[0..255] Of char;
Begin
  Text.Clear;
  If (Stream.Read(Size, 1) <> 1) Then
    Exit;
  While (Size > 0) Do
  Begin
    ReadCheck(Stream, Buf, Size);
    Buf[Size] := #0;
    Text.Add(Buf);
    If (Stream.Read(Size, 1) <> 1) Then
      Exit;
  End;
End;


////////////////////////////////////////////////////////////////////////////////
//
//		Delphi 2.x / C++ Builder 1.x support
//
////////////////////////////////////////////////////////////////////////////////
{$IFDEF VER9x}
Var
  // From Delphi 3 graphics.pas
  SystemPalette16: HPalette; // 16 color palette that maps to the system palette

Type
  TPixelFormats = Set Of TPixelFormat;

Const
  // Only pf1bit, pf4bit and pf8bit is supported since they are the only ones
  // with palettes
  SupportedPixelformats: TPixelFormats = [pf1bit, pf4bit, pf8bit];
{$ENDIF}


// --------------------------
// InitializeBitmapInfoHeader
// --------------------------
// Fills a TBitmapInfoHeader with the values of a bitmap when converted to a
// DIB of a specified PixelFormat.
//
// Parameters:
// Bitmap	The handle of the source bitmap.
// Info		The TBitmapInfoHeader buffer that will receive the values.
// PixelFormat	The pixel format of the destination DIB.
//
{$IFDEF BAD_STACK_ALIGNMENT}
  // Disable optimization to circumvent optimizer bug...
{$IFOPT O+}
{$DEFINE O_PLUS}
{$O-}
{$ENDIF}
{$ENDIF}
Procedure InitializeBitmapInfoHeader(Bitmap: HBitmap; Var Info: TBitmapInfoHeader;
  PixelFormat: TPixelFormat);
// From graphics.pas, "optimized" for our use
Var
  DIB: TDIBSection;
  Bytes: integer;
Begin
  DIB.dsbmih.biSize := 0;
  Bytes := GetObject(Bitmap, SizeOf(DIB), @DIB);
  If (Bytes = 0) Then
    Error(SInvalidBitmap);

  If (Bytes >= (SizeOf(DIB.dsbm) + SizeOf(DIB.dsbmih))) And
    (DIB.dsbmih.biSize >= SizeOf(DIB.dsbmih)) Then
    Info := DIB.dsbmih
  Else
  Begin
    FillChar(Info, SizeOf(Info), 0);
    With Info, DIB.dsbm Do
    Begin
      biSize := SizeOf(Info);
      biWidth := bmWidth;
      biHeight := bmHeight;
    End;
  End;
  Case PixelFormat Of
    pf1bit: Info.biBitCount := 1;
    pf4bit: Info.biBitCount := 4;
    pf8bit: Info.biBitCount := 8;
    pf24bit: Info.biBitCount := 24;
  Else
    Error(sInvalidPixelFormat);
    // Info.biBitCount := DIB.dsbm.bmBitsPixel * DIB.dsbm.bmPlanes;
  End;
  Info.biPlanes := 1;
  Info.biCompression := BI_RGB; // Always return data in RGB format
  Info.biSizeImage := AlignBit(Info.biWidth, Info.biBitCount, 32) * Cardinal(abs(Info.biHeight));
End;
{$IFDEF O_PLUS}
{$O+}
{$UNDEF O_PLUS}
{$ENDIF}

// -------------------
// InternalGetDIBSizes
// -------------------
// Calculates the buffer sizes nescessary for convertion of a bitmap to a DIB
// of a specified PixelFormat.
// See the GetDIBSizes API function for more info.
//
// Parameters:
// Bitmap	The handle of the source bitmap.
// InfoHeaderSize
//		The returned size of a buffer that will receive the DIB's
//		TBitmapInfo structure.
// ImageSize	The returned size of a buffer that will receive the DIB's
//		pixel data.
// PixelFormat	The pixel format of the destination DIB.
//
Procedure InternalGetDIBSizes(Bitmap: HBitmap; Var InfoHeaderSize: integer;
  Var ImageSize: longInt; PixelFormat: TPixelFormat);
// From graphics.pas, "optimized" for our use
Var
  Info: TBitmapInfoHeader;
Begin
  InitializeBitmapInfoHeader(Bitmap, Info, PixelFormat);
  // Check for palette device format
  If (Info.biBitCount > 8) Then
  Begin
    // Header but no palette
    InfoHeaderSize := SizeOf(TBitmapInfoHeader);
    If ((Info.biCompression And BI_BITFIELDS) <> 0) Then
      inc(InfoHeaderSize, 12);
  End Else
    // Header and palette
    InfoHeaderSize := SizeOf(TBitmapInfoHeader) + SizeOf(TRGBQuad) * (1 Shl Info.biBitCount);
  ImageSize := Info.biSizeImage;
End;

// --------------
// InternalGetDIB
// --------------
// Converts a bitmap to a DIB of a specified PixelFormat.
//
// Parameters:
// Bitmap	The handle of the source bitmap.
// Pal		The handle of the source palette.
// BitmapInfo	The buffer that will receive the DIB's TBitmapInfo structure.
//		A buffer of sufficient size must have been allocated prior to
//		calling this function.
// Bits		The buffer that will receive the DIB's pixel data.
//		A buffer of sufficient size must have been allocated prior to
//		calling this function.
// PixelFormat	The pixel format of the destination DIB.
//
// Returns:
// True on success, False on failure.
//
// Note: The InternalGetDIBSizes function can be used to calculate the
// nescessary sizes of the BitmapInfo and Bits buffers.
//
Function InternalGetDIB(Bitmap: HBitmap; Palette: HPalette;
  Var BitmapInfo; Var Bits; PixelFormat: TPixelFormat): Boolean;
// From graphics.pas, "optimized" for our use
Var
  OldPal: HPalette;
  DC: HDC;
Begin
  InitializeBitmapInfoHeader(Bitmap, TBitmapInfoHeader(BitmapInfo), PixelFormat);
  OldPal := 0;
  DC := CreateCompatibleDC(0);
  Try
    If (Palette <> 0) Then
    Begin
      OldPal := SelectPalette(DC, Palette, False);
      RealizePalette(DC);
    End;
    Result := (GetDIBits(DC, Bitmap, 0, abs(TBitmapInfoHeader(BitmapInfo).biHeight),
      @Bits, TBitmapInfo(BitmapInfo), DIB_RGB_COLORS) <> 0);
  Finally
    If (OldPal <> 0) Then
      SelectPalette(DC, OldPal, False);
    DeleteDC(DC);
  End;
End;

// ----------
// DIBFromBit
// ----------
// Converts a bitmap to a DIB of a specified PixelFormat.
// The DIB is returned in a TMemoryStream ready for streaming to a BMP file.
//
// Note: As opposed to D2's DIBFromBit function, the returned stream also
// contains a TBitmapFileHeader at offset 0.
//
// Parameters:
// Stream	The TMemoryStream used to store the bitmap data.
//		The stream must be allocated and freed by the caller prior to
//		calling this function.
// Src		The handle of the source bitmap.
// Pal		The handle of the source palette.
// PixelFormat	The pixel format of the destination DIB.
// DIBHeader	A pointer to the DIB's TBitmapInfo (or TBitmapInfoHeader)
//		structure in the memory stream.
//		The size of the structure can either be deduced from the
//		pixel format (i.e. number of colors) or calculated by
//		subtracting the DIBHeader pointer from the DIBBits pointer.
// DIBBits	A pointer to the DIB's pixel data in the memory stream.
//
Procedure DIBFromBit(Stream: TMemoryStream; Src: HBitmap;
  Pal: HPalette; PixelFormat: TPixelFormat; Var DIBHeader, DIBBits: Pointer);
// (From D2 graphics.pas, "optimized" for our use)
Var
  HeaderSize: integer;
  FileSize: longInt;
  ImageSize: longInt;
  BitmapFileHeader: PBitmapFileHeader;
Begin
  If (Src = 0) Then
    Error(SInvalidBitmap);
  // Get header- and pixel data size for new pixel format
  InternalGetDIBSizes(Src, HeaderSize, ImageSize, PixelFormat);
  // Make room in stream for a TBitmapInfo and pixel data
  FileSize := SizeOf(TBitmapFileHeader) + HeaderSize + ImageSize;
  Stream.SetSize(FileSize);
  // Get pointer to TBitmapFileHeader
  BitmapFileHeader := Stream.Memory;
  // Get pointer to TBitmapInfo
  DIBHeader := Pointer(longInt(BitmapFileHeader) + SizeOf(TBitmapFileHeader));
  // Get pointer to pixel data
  DIBBits := Pointer(longInt(DIBHeader) + HeaderSize);
  // Initialize file header
  FillChar(BitmapFileHeader^, SizeOf(TBitmapFileHeader), 0);
  With BitmapFileHeader^ Do
  Begin
    bfType := $4D42; // 'BM' = Windows BMP signature
    bfSize := FileSize; // File size (not needed)
    bfOffBits := SizeOf(TBitmapFileHeader) + HeaderSize; // Offset of pixel data
  End;
  // Get pixel data in new pixel format
  InternalGetDIB(Src, Pal, DIBHeader^, DIBBits^, PixelFormat);
End;

// --------------
// GetPixelFormat
// --------------
// Returns the current pixel format of a bitmap.
//
// Replacement for delphi 3 TBitmap.PixelFormat getter.
//
// Parameters:
// Bitmap	The bitmap which pixel format is returned.
//
// Returns:
// The PixelFormat of the bitmap
//
Function GetPixelFormat(Bitmap: TBitmap): TPixelFormat;
{$IFDEF VER9x}
// From graphics.pas, "optimized" for our use
Var
  DIBSection: TDIBSection;
  Bytes: integer;
  Handle: HBitmap;
Begin
  Result := pfCustom; // This value is never returned
  // BAD_STACK_ALIGNMENT
  // Note: To work around an optimizer bug, we do not use Bitmap.Handle
  // directly. Instead we store the value and use it indirectly. Unless we do
  // this, the register containing Bitmap.Handle will be overwritten!
  Handle := Bitmap.Handle;
  If (Handle <> 0) Then
  Begin
    Bytes := GetObject(Handle, SizeOf(DIBSection), @DIBSection);
    If (Bytes = 0) Then
      Error(SInvalidBitmap);

    With (DIBSection) Do
    Begin
      // Check for NT bitmap
      If (Bytes < (SizeOf(dsbm) + SizeOf(dsbmih))) Or (dsbmih.biSize < SizeOf(dsbmih)) Then
        DIBSection.dsbmih.biBitCount := dsbm.bmBitsPixel * dsbm.bmPlanes;

      Case (dsbmih.biBitCount) Of
        0: Result := pfDevice;
        1: Result := pf1bit;
        4: Result := pf4bit;
        8: Result := pf8bit;
        16: Case (dsbmih.biCompression) Of
            BI_RGB:
              Result := pf15bit;
            BI_BITFIELDS:
              If (dsBitFields[1] = $07E0) Then
                Result := pf16bit;
          End;
        24: Result := pf24bit;
        32: If (dsbmih.biCompression = BI_RGB) Then
            Result := pf32bit;
      Else
        Error(sUnsupportedBitmap);
      End;
    End;
  End Else
//    Result := pfDevice;
    Error(sUnsupportedBitmap);
End;
{$ELSE}
Begin
  Result := Bitmap.PixelFormat;
End;
{$ENDIF}

// --------------
// SetPixelFormat
// --------------
// Changes the pixel format of a TBitmap.
//
// Replacement for delphi 3 TBitmap.PixelFormat setter.
// The returned TBitmap will always be a DIB.
//
// Note: Under Delphi 3.x this function will leak a palette handle each time it
//       converts a TBitmap to pf8bit format!
//       If possible, use SafeSetPixelFormat instead to avoid this.
//
// Parameters:
// Bitmap	The bitmap to modify.
// PixelFormat	The pixel format to convert to.
//
Procedure SetPixelFormat(Bitmap: TBitmap; PixelFormat: TPixelFormat);
{$IFDEF VER9x}
Var
  Stream: TMemoryStream;
  Header,
    Bits: Pointer;
Begin
  // Can't change anything without a handle
  If (Bitmap.Handle = 0) Then
    Error(SInvalidBitmap);

  // Only convert to supported formats
  If Not (PixelFormat In SupportedPixelformats) Then
    Error(sInvalidPixelFormat);

  // No need to convert to same format
  If (GetPixelFormat(Bitmap) = PixelFormat) Then
    Exit;

  Stream := TMemoryStream.Create;
  Try
    // Convert to DIB file in memory stream
    DIBFromBit(Stream, Bitmap.Handle, Bitmap.Palette, PixelFormat, Header, Bits);
    // Load DIB from stream
    Stream.Position := 0;
    Bitmap.LoadFromStream(Stream);
  Finally
    Stream.Free;
  End;
End;
{$ELSE}
Begin
  Bitmap.PixelFormat := PixelFormat;
End;
{$ENDIF}

{$IFDEF VER100}
Var
  pf8BitBitmap: TBitmap = Nil;
{$ENDIF}

// ------------------
// SafeSetPixelFormat
// ------------------
// Changes the pixel format of a TBitmap but doesn't preserve the contents.
//
// Replacement for Delphi 3 TBitmap.PixelFormat setter.
// The returned TBitmap will always be an empty DIB of the same size as the
// original bitmap.
//
// This function is used to avoid the palette handle leak that Delphi 3's
// SetPixelFormat and TBitmap.PixelFormat suffers from.
//
// Parameters:
// Bitmap	The bitmap to modify.
// PixelFormat	The pixel format to convert to.
//
Procedure SafeSetPixelFormat(Bitmap: TBitmap; PixelFormat: TPixelFormat);
{$IFDEF VER9x}
Begin
  SetPixelFormat(Bitmap, PixelFormat);
End;
{$ELSE}
{$IFNDEF VER100}
Var
  Palette: HPalette;
Begin
  Bitmap.PixelFormat := PixelFormat;

  // Work around a bug in TBitmap:
  // When converting to pf8bit format, the palette assigned to TBitmap.Palette
  // will be a half tone palette (which only contains the 20 system colors).
  // Unfortunately this is not the palette used to render the bitmap and it
  // is also not the palette saved with the bitmap.
  If (PixelFormat = pf8bit) Then
  Begin
    // Disassociate the wrong palette from the bitmap (without affecting
    // the DIB color table)
    Palette := Bitmap.ReleasePalette;
    If (Palette <> 0) Then
      DeleteObject(Palette);
    // Recreate the palette from the DIB color table
    Bitmap.Palette;
  End;
End;
{$ELSE}
Var
  Width,
    Height: integer;
Begin
  If (PixelFormat = pf8bit) Then
  Begin
    // Partial solution to "TBitmap.PixelFormat := pf8bit" leak
    // by Greg Chapman <glc@well.com>
    If (pf8BitBitmap = Nil) Then
    Begin
      // Create a "template" bitmap
      // The bitmap is deleted in the finalization section of the unit.
      pf8BitBitmap := TBitmap.Create;
      // Convert template to pf8bit format
      // This will leak 1 palette handle, but only once
      pf8BitBitmap.PixelFormat := pf8bit;
    End;
    // Store the size of the original bitmap
    Width := Bitmap.Width;
    Height := Bitmap.Height;
    // Convert to pf8bit format by copying template
    Bitmap.Assign(pf8BitBitmap);
    // Restore the original size
    Bitmap.Width := Width;
    Bitmap.Height := Height;
  End Else
    // This is safe since only pf8bit leaks
    Bitmap.PixelFormat := PixelFormat;
End;
{$ENDIF}
{$ENDIF}


{$IFDEF VER9x}

// -----------
// CopyPalette
// -----------
// Copies a HPALETTE.
//
// Copied from D3 graphics.pas.
// This is declared private in some old versions of Delphi 2 so we have to
// implement it here to support those old versions.
//
// Parameters:
// Palette	The palette to copy.
//
// Returns:
// The handle to a new palette.
//
Function CopyPalette(Palette: HPalette): HPalette;
Var
  PaletteSize: integer;
  LogPal: TMaxLogPalette;
Begin
  Result := 0;
  If Palette = 0 Then Exit;
  PaletteSize := 0;
  If GetObject(Palette, SizeOf(PaletteSize), @PaletteSize) = 0 Then Exit;
  If PaletteSize = 0 Then Exit;
  With LogPal Do
  Begin
    palVersion := $0300;
    palNumEntries := PaletteSize;
    GetPaletteEntries(Palette, 0, PaletteSize, palPalEntry);
  End;
  Result := CreatePalette(PLogPalette(@LogPal)^);
End;


// TThreadList implementation from Delphi 3 classes.pas
Constructor TThreadList.Create;
Begin
  Inherited Create;
  InitializeCriticalSection(FLock);
  FList := TList.Create;
End;

Destructor TThreadList.Destroy;
Begin
  LockList; // Make sure nobody else is inside the list.
  Try
    FList.Free;
    Inherited Destroy;
  Finally
    UnlockList;
    DeleteCriticalSection(FLock);
  End;
End;

Procedure TThreadList.Add(Item: Pointer);
Begin
  LockList;
  Try
    If FList.IndexOf(Item) = -1 Then
      FList.Add(Item);
  Finally
    UnlockList;
  End;
End;

Procedure TThreadList.Clear;
Begin
  LockList;
  Try
    FList.Clear;
  Finally
    UnlockList;
  End;
End;

Function TThreadList.LockList: TList;
Begin
  EnterCriticalSection(FLock);
  Result := FList;
End;

Procedure TThreadList.Remove(Item: Pointer);
Begin
  LockList;
  Try
    FList.Remove(Item);
  Finally
    UnlockList;
  End;
End;

Procedure TThreadList.UnlockList;
Begin
  LeaveCriticalSection(FLock);
End;
// End of TThreadList implementation

// From Delphi 3 sysutils.pas
{ CompareMem performs a binary compare of Length bytes of memory referenced
  by P1 to that of P2.  CompareMem returns True if the memory referenced by
  P1 is identical to that of P2. }
Function CompareMem(P1, P2: Pointer; Length: integer): Boolean; Assembler;
Asm
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,P1
        MOV     EDI,P2
        MOV     EDX,ECX
        XOR     EAX,EAX
        AND     EDX,3
        SHR     ECX,1
        SHR     ECX,1
        REPE    CMPSD
        JNE     @@2
        MOV     ECX,EDX
        REPE    CMPSB
        JNE     @@2
@@1:    INC     EAX
@@2:    POP     EDI
        POP     ESI
End;

// Dummy ASSERT procedure since ASSERT does not exist in Delphi 2.x
Procedure ASSERT(Condition: Boolean; Message: String);
Begin
End;

{$ENDIF} // Delphi 2.x stuff

////////////////////////////////////////////////////////////////////////////////
//
//			TDIB Classes
//
//  These classes gives read and write access to TBitmap's pixel data
//  independently of the Delphi version used.
//
////////////////////////////////////////////////////////////////////////////////
Type
  TDIB = Class(TObject)
  Private
    FBitmap: TBitmap;
    FPixelFormat: TPixelFormat;
  Protected
    Function GetScanline(Row: integer): Pointer; Virtual; Abstract;
    Constructor Create(ABitmap: TBitmap; APixelFormat: TPixelFormat);
  Public
    Property Scanline[Row: integer]: Pointer Read GetScanline;
    Property Bitmap: TBitmap Read FBitmap;
    Property PixelFormat: TPixelFormat Read FPixelFormat;
  End;

  TDIBReader = Class(TDIB)
  Private
{$IFDEF VER9x}
    FDIB: TDIBSection;
    FDC: HDC;
    FScanLine: Pointer;
    FLastRow: integer;
    FInfo: PBitmapInfo;
    FBytes: integer;
{$ENDIF}
  Protected
    Function GetScanline(Row: integer): Pointer; Override;
  Public
    Constructor Create(ABitmap: TBitmap; APixelFormat: TPixelFormat);
    Destructor Destroy; Override;
  End;

  TDIBWriter = Class(TDIB)
  Private
{$IFDEF PIXELFORMAT_TOO_SLOW}
    FDIBInfo: PBitmapInfo;
    FDIBBits: Pointer;
    FDIBInfoSize: integer;
    FDIBBitsSize: longInt;
{$IFNDEF CREATEDIBSECTION_SLOW}
    FDIB: HBitmap;
{$ENDIF}
{$ENDIF}
    FPalette: HPalette;
    FHeight: integer;
    FWidth: integer;
  Protected
    Procedure CreateDIB;
    Procedure FreeDIB;
    Procedure NeedDIB;
    Function GetScanline(Row: integer): Pointer; Override;
  Public
    Constructor Create(ABitmap: TBitmap; APixelFormat: TPixelFormat;
      AWidth, AHeight: integer; APalette: HPalette);
    Destructor Destroy; Override;
    Procedure UpdateBitmap;
    Property Width: integer Read FWidth;
    Property Height: integer Read FHeight;
    Property Palette: HPalette Read FPalette;
  End;

////////////////////////////////////////////////////////////////////////////////
Constructor TDIB.Create(ABitmap: TBitmap; APixelFormat: TPixelFormat);
Begin
  Inherited Create;
  FBitmap := ABitmap;
  FPixelFormat := APixelFormat;
End;

////////////////////////////////////////////////////////////////////////////////
Constructor TDIBReader.Create(ABitmap: TBitmap; APixelFormat: TPixelFormat);
{$IFDEF VER9x}
Var
  InfoHeaderSize: integer;
  ImageSize: longInt;
{$ENDIF}
Begin
  Inherited Create(ABitmap, APixelFormat);
{$IFNDEF VER9x}
  SetPixelFormat(FBitmap, FPixelFormat);
{$ELSE}
  FDC := CreateCompatibleDC(0);
  SelectPalette(FDC, FBitmap.Palette, False);

  // Allocate DIB info structure
  InternalGetDIBSizes(ABitmap.Handle, InfoHeaderSize, ImageSize, APixelFormat);
  GetMem(FInfo, InfoHeaderSize);
  // Get DIB info
  InitializeBitmapInfoHeader(ABitmap.Handle, FInfo^.bmiHeader, APixelFormat);

  // Allocate scan line buffer
  GetMem(FScanLine, ImageSize Div abs(FInfo^.bmiHeader.biHeight));

  FLastRow := -1;
{$ENDIF}
End;

Destructor TDIBReader.Destroy;
Begin
{$IFDEF VER9x}
  DeleteDC(FDC);
  FreeMem(FScanLine);
  FreeMem(FInfo);
{$ENDIF}
  Inherited Destroy;
End;

Function TDIBReader.GetScanline(Row: integer): Pointer;
Begin
{$IFDEF VER9x}
  If (Row < 0) Or (Row >= FBitmap.Height) Then
    Raise EInvalidGraphicOperation.Create(SScanLine);
  GdiFlush;

  Result := FScanLine;
  If (Row = FLastRow) Then
    Exit;
  FLastRow := Row;

  If (FInfo^.bmiHeader.biHeight > 0) Then // bottom-up DIB
    Row := FInfo^.bmiHeader.biHeight - Row - 1;
  GetDIBits(FDC, FBitmap.Handle, Row, 1, FScanLine, FInfo^, DIB_RGB_COLORS);

{$ELSE}
  Result := FBitmap.Scanline[Row];
{$ENDIF}
End;

////////////////////////////////////////////////////////////////////////////////
Constructor TDIBWriter.Create(ABitmap: TBitmap; APixelFormat: TPixelFormat;
  AWidth, AHeight: integer; APalette: HPalette);
Begin
  Inherited Create(ABitmap, APixelFormat);

  // DIB writer only supports 8 or 24 bit bitmaps
  If Not (APixelFormat In [pf8bit, pf24bit]) Then
    Error(sInvalidPixelFormat);
  If (AWidth = 0) Or (AHeight = 0) Then
    Error(sBadDimension);

  FHeight := AHeight;
  FWidth := AWidth;
{$IFNDEF PIXELFORMAT_TOO_SLOW}
  FBitmap.Palette := 0;
  FBitmap.Height := FHeight;
  FBitmap.Width := FWidth;
  SafeSetPixelFormat(FBitmap, FPixelFormat);
  FPalette := CopyPalette(APalette);
  FBitmap.Palette := FPalette;
{$ELSE}
  FPalette := APalette;
  FDIBInfo := Nil;
  FDIBBits := Nil;
{$IFNDEF CREATEDIBSECTION_SLOW}
  FDIB := 0;
{$ENDIF}
{$ENDIF}
End;

Destructor TDIBWriter.Destroy;
Begin
  UpdateBitmap;
  FreeDIB;
  Inherited Destroy;
End;

Function TDIBWriter.GetScanline(Row: integer): Pointer;
Begin
{$IFDEF PIXELFORMAT_TOO_SLOW}
  NeedDIB;

  If (FDIBBits = Nil) Then
    Error(sNoDIB);
  With FDIBInfo^.bmiHeader Do
  Begin
    If (Row < 0) Or (Row >= Height) Then
      Raise EInvalidGraphicOperation.Create(SScanLine);
    GdiFlush;

    If biHeight > 0 Then // bottom-up DIB
      Row := biHeight - Row - 1;
    Result := PChar(Cardinal(FDIBBits) + Cardinal(Row) * AlignBit(biWidth, biBitCount, 32));
  End;
{$ELSE}
  Result := FBitmap.Scanline[Row];
{$ENDIF}
End;

Procedure TDIBWriter.CreateDIB;
{$IFDEF PIXELFORMAT_TOO_SLOW}
Var
  SrcColors: Word;
//  ScreenDC		: HDC;

  // From Delphi 3.02 graphics.pas
  // There is a bug in the ByteSwapColors from Delphi 3.0!
  Procedure ByteSwapColors(Var Colors; Count: integer);
  Var // convert RGB to BGR and vice-versa.  TRGBQuad <-> TPaletteEntry
    SysInfo: TSystemInfo;
  Begin
    GetSystemInfo(SysInfo);
    Asm
          MOV   EDX, Colors
          MOV   ECX, Count
          DEC   ECX
          JS    @@END
          LEA   EAX, SysInfo
          CMP   [EAX].TSystemInfo.wProcessorLevel, 3
          JE    @@386
    @@1:  MOV   EAX, [EDX+ECX*4]
          BSWAP EAX
          SHR   EAX,8
          MOV   [EDX+ECX*4],EAX
          DEC   ECX
          JNS   @@1
          JMP   @@END
    @@386:
          PUSH  EBX
    @@2:  XOR   EBX,EBX
          MOV   EAX, [EDX+ECX*4]
          MOV   BH, AL
          MOV   BL, AH
          SHR   EAX,16
          SHL   EBX,8
          MOV   BL, AL
          MOV   [EDX+ECX*4],EBX
          DEC   ECX
          JNS   @@2
          POP   EBX
      @@END:
    End;
  End;
{$ENDIF}
Begin
{$IFDEF PIXELFORMAT_TOO_SLOW}
  FreeDIB;

  If (PixelFormat = pf8bit) Then
    // 8 bit: Header and palette
    FDIBInfoSize := SizeOf(TBitmapInfoHeader) + SizeOf(TRGBQuad) * (1 Shl 8)
  Else
    // 24 bit: Header but no palette
    FDIBInfoSize := SizeOf(TBitmapInfoHeader);

  // Allocate TBitmapInfo structure
  GetMem(FDIBInfo, FDIBInfoSize);
  Try
    FDIBInfo^.bmiHeader.biSize := SizeOf(FDIBInfo^.bmiHeader);
    FDIBInfo^.bmiHeader.biWidth := Width;
    FDIBInfo^.bmiHeader.biHeight := Height;
    FDIBInfo^.bmiHeader.biPlanes := 1;
    FDIBInfo^.bmiHeader.biSizeImage := 0;
    FDIBInfo^.bmiHeader.biCompression := BI_RGB;

    If (PixelFormat = pf8bit) Then
    Begin
      FDIBInfo^.bmiHeader.biBitCount := 8;
      // Find number of colors defined by palette
      If (Palette <> 0) And
        (GetObject(Palette, SizeOf(SrcColors), @SrcColors) <> 0) And
        (SrcColors <> 0) Then
      Begin
        // Copy all colors...
        GetPaletteEntries(Palette, 0, SrcColors, FDIBInfo^.bmiColors[0]);
        // ...and convert BGR to RGB
        ByteSwapColors(FDIBInfo^.bmiColors[0], SrcColors);
      End Else
        SrcColors := 0;

      // Finally zero any unused entried
      If (SrcColors < 256) Then
        FillChar(Pointer(longInt(@FDIBInfo^.bmiColors) + SizeOf(TRGBQuad) * SrcColors)^,
          256 - SrcColors, 0);
      FDIBInfo^.bmiHeader.biClrUsed := 256;
      FDIBInfo^.bmiHeader.biClrImportant := SrcColors;
    End Else
    Begin
      FDIBInfo^.bmiHeader.biBitCount := 24;
      FDIBInfo^.bmiHeader.biClrUsed := 0;
      FDIBInfo^.bmiHeader.biClrImportant := 0;
    End;
    FDIBBitsSize := AlignBit(Width, FDIBInfo^.bmiHeader.biBitCount, 32) * Cardinal(abs(Height));

{$IFDEF CREATEDIBSECTION_SLOW}
    FDIBBits := GlobalAllocPtr(GMEM_MOVEABLE, FDIBBitsSize);
    If (FDIBBits = Nil) Then
      Raise EOutOfMemory.Create(sOutOfMemDIB);
{$ELSE}
//    ScreenDC := GDICheck(GetDC(0));
    Try
      // Allocate DIB section
      // Note: You can ignore warnings about the HDC parameter being 0. The
      // parameter is not used for 24 bit bitmaps
      FDIB := GDICheck(CreateDIBSection(0 {ScreenDC}, FDIBInfo^, DIB_RGB_COLORS,
        FDIBBits,
{$IFDEF VER9x}Nil, {$ELSE}0, {$ENDIF}
        0));
    Finally
//      ReleaseDC(0, ScreenDC);
    End;
{$ENDIF}

  Except
    FreeDIB;
    Raise;
  End;
{$ENDIF}
End;

Procedure TDIBWriter.FreeDIB;
Begin
{$IFDEF PIXELFORMAT_TOO_SLOW}
  If (FDIBInfo <> Nil) Then
    FreeMem(FDIBInfo);
{$IFDEF CREATEDIBSECTION_SLOW}
  If (FDIBBits <> Nil) Then
    GlobalFreePtr(FDIBBits);
{$ELSE}
  If (FDIB <> 0) Then
    DeleteObject(FDIB);
  FDIB := 0;
{$ENDIF}
  FDIBInfo := Nil;
  FDIBBits := Nil;
{$ENDIF}
End;

Procedure TDIBWriter.NeedDIB;
Begin
{$IFDEF PIXELFORMAT_TOO_SLOW}
{$IFDEF CREATEDIBSECTION_SLOW}
  If (FDIBBits = Nil) Then
{$ELSE}
  If (FDIB = 0) Then
{$ENDIF}
    CreateDIB;
{$ENDIF}
End;

// Convert the DIB created by CreateDIB back to a TBitmap
Procedure TDIBWriter.UpdateBitmap;
{$IFDEF PIXELFORMAT_TOO_SLOW}
Var
  Stream: TMemoryStream;
  FileSize: longInt;
  BitmapFileHeader: TBitmapFileHeader;
{$ENDIF}
Begin
{$IFDEF PIXELFORMAT_TOO_SLOW}

{$IFDEF CREATEDIBSECTION_SLOW}
  If (FDIBBits = Nil) Then
{$ELSE}
  If (FDIB = 0) Then
{$ENDIF}
    Exit;

  // Win95 and NT differs in what solution performs best
{$IFNDEF CREATEDIBSECTION_SLOW}
{$IFDEF VER10_PLUS}
  If (Win32Platform = VER_PLATFORM_WIN32_NT) Then
  Begin
    // Assign DIB to bitmap
    FBitmap.Handle := FDIB;
    FDIB := 0;
    FBitmap.Palette := CopyPalette(Palette);
  End Else
{$ENDIF}
{$ENDIF}
  Begin
    // Write DIB to a stream in the BMP file format
    Stream := TMemoryStream.Create;
    Try
      // Make room in stream for a TBitmapInfo and pixel data
      FileSize := SizeOf(TBitmapFileHeader) + FDIBInfoSize + FDIBBitsSize;
      Stream.SetSize(FileSize);
      // Initialize file header
      FillChar(BitmapFileHeader, SizeOf(TBitmapFileHeader), 0);
      With BitmapFileHeader Do
      Begin
        bfType := $4D42; // 'BM' = Windows BMP signature
        bfSize := FileSize; // File size (not needed)
        bfOffBits := SizeOf(TBitmapFileHeader) + FDIBInfoSize; // Offset of pixel data
      End;
      // Save file header
      Stream.Write(BitmapFileHeader, SizeOf(TBitmapFileHeader));
      // Save TBitmapInfo structure
      Stream.Write(FDIBInfo^, FDIBInfoSize);
      // Save pixel data
      Stream.Write(FDIBBits^, FDIBBitsSize);

      // Rewind and load bitmap from stream
      Stream.Position := 0;
      FBitmap.LoadFromStream(Stream);
    Finally
      Stream.Free;
    End;
  End;
{$ENDIF}
End;

////////////////////////////////////////////////////////////////////////////////
//
//			Color Mapping
//
////////////////////////////////////////////////////////////////////////////////
Type
  TColorLookup = Class(TObject)
  Private
    FColors: integer;
  Public
    Constructor Create(Palette: HPalette); Virtual;
    Function Lookup(Red, Green, Blue: Byte; Var R, g, b: Byte): char; Virtual; Abstract;
    Property Colors: integer Read FColors;
  End;

  PRGBQuadArray = ^TRGBQuadArray; // From Delphi 3 graphics.pas
  TRGBQuadArray = Array[Byte] Of TRGBQuad; // From Delphi 3 graphics.pas

  BGRArray = Array[0..0] Of TRGBTriple;
  PBGRArray = ^BGRArray;

  PalArray = Array[Byte] Of TPaletteEntry;
  PPalArray = ^PalArray;

  // TFastColorLookup implements a simple but reasonably fast generic color
  // mapper. It trades precision for speed by reducing the size of the color
  // space.
  // Using a class instead of inline code results in a speed penalty of
  // approx. 15% but reduces the complexity of the color reduction routines that
  // uses it. If bitmap to GIF conversion speed is really important to you, the
  // implementation can easily be inlined again.
  TInverseLookup = Array[0..1 Shl 15 - 1] Of SmallInt;
  PInverseLookup = ^TInverseLookup;

  TFastColorLookup = Class(TColorLookup)
  Private
    FPaletteEntries: PPalArray;
    FInverseLookup: PInverseLookup;
  Public
    Constructor Create(Palette: HPalette); Override;
    Destructor Destroy; Override;
    Function Lookup(Red, Green, Blue: Byte; Var R, g, b: Byte): char; Override;
  End;

  // TSlowColorLookup implements a precise but very slow generic color mapper.
  // It uses the GetNearestPaletteIndex GDI function.
  // Note: Tests has shown TFastColorLookup to be more precise than
  // TSlowColorLookup in many cases. I can't explain why...
  TSlowColorLookup = Class(TColorLookup)
  Private
    FPaletteEntries: PPalArray;
    FPalette: HPalette;
  Public
    Constructor Create(Palette: HPalette); Override;
    Destructor Destroy; Override;
    Function Lookup(Red, Green, Blue: Byte; Var R, g, b: Byte): char; Override;
  End;

  // TNetscapeColorLookup maps colors to the netscape 6*6*6 color cube.
  TNetscapeColorLookup = Class(TColorLookup)
  Public
    Constructor Create(Palette: HPalette); Override;
    Function Lookup(Red, Green, Blue: Byte; Var R, g, b: Byte): char; Override;
  End;

  // TGrayWindowsLookup maps colors to 4 shade palette.
  TGrayWindowsLookup = Class(TSlowColorLookup)
  Public
    Constructor Create(Palette: HPalette); Override;
    Function Lookup(Red, Green, Blue: Byte; Var R, g, b: Byte): char; Override;
  End;

  // TGrayScaleLookup maps colors to a uniform 256 shade palette.
  TGrayScaleLookup = Class(TColorLookup)
  Public
    Constructor Create(Palette: HPalette); Override;
    Function Lookup(Red, Green, Blue: Byte; Var R, g, b: Byte): char; Override;
  End;

  // TMonochromeLookup maps colors to a black/white palette.
  TMonochromeLookup = Class(TColorLookup)
  Public
    Constructor Create(Palette: HPalette); Override;
    Function Lookup(Red, Green, Blue: Byte; Var R, g, b: Byte): char; Override;
  End;

Constructor TColorLookup.Create(Palette: HPalette);
Begin
  Inherited Create;
End;

Constructor TFastColorLookup.Create(Palette: HPalette);
Var
  i: integer;
  InverseIndex: integer;
Begin
  Inherited Create(Palette);

  GetMem(FPaletteEntries, SizeOf(TPaletteEntry) * 256);
  FColors := GetPaletteEntries(Palette, 0, 256, FPaletteEntries^);

  New(FInverseLookup);
  For i := Low(TInverseLookup) To High(TInverseLookup) Do
    FInverseLookup^[i] := -1;

  // Premap palette colors
  If (FColors > 0) Then
    For i := 0 To FColors - 1 Do
      With FPaletteEntries^[i] Do
      Begin
        InverseIndex := (peRed Shr 3) Or ((peGreen And $F8) Shl 2) Or ((peBlue And $F8) Shl 7);
        If (FInverseLookup^[InverseIndex] = -1) Then
          FInverseLookup^[InverseIndex] := i;
      End;
End;

Destructor TFastColorLookup.Destroy;
Begin
  If (FPaletteEntries <> Nil) Then
    FreeMem(FPaletteEntries);
  If (FInverseLookup <> Nil) Then
    Dispose(FInverseLookup);

  Inherited Destroy;
End;

// Map color to arbitrary palette
Function TFastColorLookup.Lookup(Red, Green, Blue: Byte; Var R, g, b: Byte): char;
Var
  i: integer;
  InverseIndex: integer;
  Delta,
    MinDelta,
    MinColor: integer;
Begin
  // Reduce color space with 3 bits in each dimension
  InverseIndex := (Red Shr 3) Or ((Green And $F8) Shl 2) Or ((Blue And $F8) Shl 7);

  If (FInverseLookup^[InverseIndex] <> -1) Then
    Result := char(FInverseLookup^[InverseIndex])
  Else
  Begin
    // Sequential scan for nearest color to minimize euclidian distance
    MinDelta := 3 * (256 * 256);
    MinColor := 0;
    For i := 0 To FColors - 1 Do
      With FPaletteEntries[i] Do
      Begin
        Delta := abs(peRed - Red) + abs(peGreen - Green) + abs(peBlue - Blue);
        If (Delta < MinDelta) Then
        Begin
          MinDelta := Delta;
          MinColor := i;
        End;
      End;
    Result := char(MinColor);
    FInverseLookup^[InverseIndex] := MinColor;
  End;

  With FPaletteEntries^[Ord(Result)] Do
  Begin
    R := peRed;
    g := peGreen;
    b := peBlue;
  End;
End;

Constructor TSlowColorLookup.Create(Palette: HPalette);
Begin
  Inherited Create(Palette);
  FPalette := Palette;
  FColors := GetPaletteEntries(Palette, 0, 256, Nil^);
  If (FColors > 0) Then
  Begin
    GetMem(FPaletteEntries, SizeOf(TPaletteEntry) * FColors);
    FColors := GetPaletteEntries(Palette, 0, 256, FPaletteEntries^);
  End;
End;

Destructor TSlowColorLookup.Destroy;
Begin
  If (FPaletteEntries <> Nil) Then
    FreeMem(FPaletteEntries);

  Inherited Destroy;
End;

// Map color to arbitrary palette
Function TSlowColorLookup.Lookup(Red, Green, Blue: Byte; Var R, g, b: Byte): char;
Begin
  Result := char(GetNearestPaletteIndex(FPalette, Red Or (Green Shl 8) Or (Blue Shl 16)));
  If (FPaletteEntries <> Nil) Then
    With FPaletteEntries^[Ord(Result)] Do
    Begin
      R := peRed;
      g := peGreen;
      b := peBlue;
    End;
End;

Constructor TNetscapeColorLookup.Create(Palette: HPalette);
Begin
  Inherited Create(Palette);
  FColors := 6 * 6 * 6; // This better be true or something is wrong
End;

// Map color to netscape 6*6*6 color cube
Function TNetscapeColorLookup.Lookup(Red, Green, Blue: Byte; Var R, g, b: Byte): char;
Begin
  R := (Red + 3) Div 51;
  g := (Green + 3) Div 51;
  b := (Blue + 3) Div 51;
  Result := char(b + 6 * g + 36 * R);
  R := R * 51;
  g := g * 51;
  b := b * 51;
End;

Constructor TGrayWindowsLookup.Create(Palette: HPalette);
Begin
  Inherited Create(Palette);
  FColors := 4;
End;

// Convert color to windows grays
Function TGrayWindowsLookup.Lookup(Red, Green, Blue: Byte; Var R, g, b: Byte): char;
Begin
  Result := Inherited Lookup(MulDiv(Red, 77, 256),
    MulDiv(Green, 150, 256), MulDiv(Blue, 29, 256), R, g, b);
End;

Constructor TGrayScaleLookup.Create(Palette: HPalette);
Begin
  Inherited Create(Palette);
  FColors := 256;
End;

// Convert color to grayscale
Function TGrayScaleLookup.Lookup(Red, Green, Blue: Byte; Var R, g, b: Byte): char;
Begin
  Result := char((Blue * 29 + Green * 150 + Red * 77) Div 256);
  R := Ord(Result);
  g := Ord(Result);
  b := Ord(Result);
End;

Constructor TMonochromeLookup.Create(Palette: HPalette);
Begin
  Inherited Create(Palette);
  FColors := 2;
End;

// Convert color to black/white
Function TMonochromeLookup.Lookup(Red, Green, Blue: Byte; Var R, g, b: Byte): char;
Begin
  If ((Blue * 29 + Green * 150 + Red * 77) > 32512) Then
  Begin
    Result := #1;
    R := 255;
    g := 255;
    b := 255;
  End Else
  Begin
    Result := #0;
    R := 0;
    g := 0;
    b := 0;
  End;
End;

////////////////////////////////////////////////////////////////////////////////
//
//			Dithering engine
//
////////////////////////////////////////////////////////////////////////////////
Type
  TDitherEngine = Class
  Private
  Protected
    FDirection: integer;
    FColumn: integer;
    FLookup: TColorLookup;
    Width: integer;
  Public
    Constructor Create(AWidth: integer; Lookup: TColorLookup); Virtual;
    Function Dither(Red, Green, Blue: Byte; Var R, g, b: Byte): char; Virtual;
    Procedure NextLine; Virtual;
    Procedure NextColumn;

    Property Direction: integer Read FDirection;
    Property Column: integer Read FColumn;
  End;

  // Note: TErrorTerm does only *need* to be 16 bits wide, but since
  // it is *much* faster to use native machine words (32 bit), we sacrifice
  // some bytes (a lot actually) to improve performance.
  TErrorTerm = integer;
  TErrors = Array[0..0] Of TErrorTerm;
  PErrors = ^TErrors;

  TFloydSteinbergDitherer = Class(TDitherEngine)
  Private
    ErrorsR,
      ErrorsG,
      ErrorsB: PErrors;
    ErrorR,
      ErrorG,
      ErrorB: PErrors;
    CurrentErrorR, // Current error or pixel value
      CurrentErrorG,
      CurrentErrorB,
      BelowErrorR, // Error for pixel below current
      BelowErrorG,
      BelowErrorB,
      BelowPrevErrorR, // Error for pixel below previous pixel
      BelowPrevErrorG,
      BelowPrevErrorB: TErrorTerm;
  Public
    Constructor Create(AWidth: integer; Lookup: TColorLookup); Override;
    Destructor Destroy; Override;
    Function Dither(Red, Green, Blue: Byte; Var R, g, b: Byte): char; Override;
    Procedure NextLine; Override;
  End;

  T5by3Ditherer = Class(TDitherEngine)
  Private
    ErrorsR0,
      ErrorsG0,
      ErrorsB0,
      ErrorsR1,
      ErrorsG1,
      ErrorsB1,
      ErrorsR2,
      ErrorsG2,
      ErrorsB2: PErrors;
    ErrorR0,
      ErrorG0,
      ErrorB0,
      ErrorR1,
      ErrorG1,
      ErrorB1,
      ErrorR2,
      ErrorG2,
      ErrorB2: PErrors;
    FDirection2: integer;
  Protected
    FDivisor: integer;
    Procedure Propagate(Errors0, Errors1, Errors2: PErrors; Error: integer); Virtual; Abstract;
  Public
    Constructor Create(AWidth: integer; Lookup: TColorLookup); Override;
    Destructor Destroy; Override;
    Function Dither(Red, Green, Blue: Byte; Var R, g, b: Byte): char; Override;
    Procedure NextLine; Override;
  End;

  TStuckiDitherer = Class(T5by3Ditherer)
  Protected
    Procedure Propagate(Errors0, Errors1, Errors2: PErrors; Error: integer); Override;
  Public
    Constructor Create(AWidth: integer; Lookup: TColorLookup); Override;
  End;

  TSierraDitherer = Class(T5by3Ditherer)
  Protected
    Procedure Propagate(Errors0, Errors1, Errors2: PErrors; Error: integer); Override;
  Public
    Constructor Create(AWidth: integer; Lookup: TColorLookup); Override;
  End;

  TJaJuNiDitherer = Class(T5by3Ditherer)
  Protected
    Procedure Propagate(Errors0, Errors1, Errors2: PErrors; Error: integer); Override;
  Public
    Constructor Create(AWidth: integer; Lookup: TColorLookup); Override;
  End;

  TSteveArcheDitherer = Class(TDitherEngine)
  Private
    ErrorsR0,
      ErrorsG0,
      ErrorsB0,
      ErrorsR1,
      ErrorsG1,
      ErrorsB1,
      ErrorsR2,
      ErrorsG2,
      ErrorsB2,
      ErrorsR3,
      ErrorsG3,
      ErrorsB3: PErrors;
    ErrorR0,
      ErrorG0,
      ErrorB0,
      ErrorR1,
      ErrorG1,
      ErrorB1,
      ErrorR2,
      ErrorG2,
      ErrorB2,
      ErrorR3,
      ErrorG3,
      ErrorB3: PErrors;
    FDirection2,
      FDirection3: integer;
  Public
    Constructor Create(AWidth: integer; Lookup: TColorLookup); Override;
    Destructor Destroy; Override;
    Function Dither(Red, Green, Blue: Byte; Var R, g, b: Byte): char; Override;
    Procedure NextLine; Override;
  End;

  TBurkesDitherer = Class(TDitherEngine)
  Private
    ErrorsR0,
      ErrorsG0,
      ErrorsB0,
      ErrorsR1,
      ErrorsG1,
      ErrorsB1: PErrors;
    ErrorR0,
      ErrorG0,
      ErrorB0,
      ErrorR1,
      ErrorG1,
      ErrorB1: PErrors;
    FDirection2: integer;
  Public
    Constructor Create(AWidth: integer; Lookup: TColorLookup); Override;
    Destructor Destroy; Override;
    Function Dither(Red, Green, Blue: Byte; Var R, g, b: Byte): char; Override;
    Procedure NextLine; Override;
  End;

////////////////////////////////////////////////////////////////////////////////
//	TDitherEngine
Constructor TDitherEngine.Create(AWidth: integer; Lookup: TColorLookup);
Begin
  Inherited Create;

  FLookup := Lookup;
  Width := AWidth;

  FDirection := 1;
  FColumn := 0;
End;

Function TDitherEngine.Dither(Red, Green, Blue: Byte; Var R, g, b: Byte): char;
Begin
  // Map color to palette
  Result := FLookup.Lookup(Red, Green, Blue, R, g, b);
  NextColumn;
End;

Procedure TDitherEngine.NextLine;
Begin
  FDirection := -FDirection;
  If (FDirection = 1) Then
    FColumn := 0
  Else
    FColumn := Width - 1;
End;

Procedure TDitherEngine.NextColumn;
Begin
  inc(FColumn, FDirection);
End;

////////////////////////////////////////////////////////////////////////////////
//	TFloydSteinbergDitherer
Constructor TFloydSteinbergDitherer.Create(AWidth: integer; Lookup: TColorLookup);
Begin
  Inherited Create(AWidth, Lookup);

  // The Error arrays has (columns + 2) entries; the extra entry at
  // each end saves us from special-casing the first and last pixels.
  // We can get away with a single array (holding one row's worth of errors)
  // by using it to store the current row's errors at pixel columns not yet
  // processed, but the next row's errors at columns already processed.  We
  // need only a few extra variables to hold the errors immediately around the
  // current column.  (If we are lucky, those variables are in registers, but
  // even if not, they're probably cheaper to access than array elements are.)
  GetMem(ErrorsR, SizeOf(TErrorTerm) * (Width + 2));
  GetMem(ErrorsG, SizeOf(TErrorTerm) * (Width + 2));
  GetMem(ErrorsB, SizeOf(TErrorTerm) * (Width + 2));
  FillChar(ErrorsR^, SizeOf(TErrorTerm) * (Width + 2), 0);
  FillChar(ErrorsG^, SizeOf(TErrorTerm) * (Width + 2), 0);
  FillChar(ErrorsB^, SizeOf(TErrorTerm) * (Width + 2), 0);
  ErrorR := ErrorsR;
  ErrorG := ErrorsG;
  ErrorB := ErrorsB;
  CurrentErrorR := 0;
  CurrentErrorG := CurrentErrorR;
  CurrentErrorB := CurrentErrorR;
  BelowErrorR := CurrentErrorR;
  BelowErrorG := CurrentErrorR;
  BelowErrorB := CurrentErrorR;
  BelowPrevErrorR := CurrentErrorR;
  BelowPrevErrorG := CurrentErrorR;
  BelowPrevErrorB := CurrentErrorR;
End;

Destructor TFloydSteinbergDitherer.Destroy;
Begin
  FreeMem(ErrorsR);
  FreeMem(ErrorsG);
  FreeMem(ErrorsB);
  Inherited Destroy;
End;

{$IFOPT R+}
{$DEFINE R_PLUS}
{$RANGECHECKS OFF}
{$ENDIF}
Function TFloydSteinbergDitherer.Dither(Red, Green, Blue: Byte; Var R, g, b: Byte): char;
Var
  BelowNextError: TErrorTerm;
  Delta: TErrorTerm;
Begin
  CurrentErrorR := Red + (CurrentErrorR + ErrorR[0] + 8) Div 16;
//  CurrentErrorR := Red + (CurrentErrorR + ErrorR[Direction] + 8) DIV 16;
  If (CurrentErrorR < 0) Then
    CurrentErrorR := 0
  Else If (CurrentErrorR > 255) Then
    CurrentErrorR := 255;

  CurrentErrorG := Green + (CurrentErrorG + ErrorG[0] + 8) Div 16;
//  CurrentErrorG := Green + (CurrentErrorG + ErrorG[Direction] + 8) DIV 16;
  If (CurrentErrorG < 0) Then
    CurrentErrorG := 0
  Else If (CurrentErrorG > 255) Then
    CurrentErrorG := 255;

  CurrentErrorB := Blue + (CurrentErrorB + ErrorB[0] + 8) Div 16;
//  CurrentErrorB := Blue + (CurrentErrorB + ErrorB[Direction] + 8) DIV 16;
  If (CurrentErrorB < 0) Then
    CurrentErrorB := 0
  Else If (CurrentErrorB > 255) Then
    CurrentErrorB := 255;

  // Map color to palette
  Result := Inherited Dither(CurrentErrorR, CurrentErrorG, CurrentErrorB, R, g, b);

  // Propagate Floyd-Steinberg error terms.
  // Errors are accumulated into the error arrays, at a resolution of
  // 1/16th of a pixel count.  The error at a given pixel is propagated
  // to its not-yet-processed neighbors using the standard F-S fractions,
  //		...	(here)	7/16
  //		3/16	5/16	1/16
  // We work left-to-right on even rows, right-to-left on odd rows.

  // Red component
  CurrentErrorR := CurrentErrorR - R;
  If (CurrentErrorR <> 0) Then
  Begin
    BelowNextError := CurrentErrorR; // Error * 1

    Delta := CurrentErrorR * 2;
    inc(CurrentErrorR, Delta);
    ErrorR[0] := BelowPrevErrorR + CurrentErrorR; // Error * 3

    inc(CurrentErrorR, Delta);
    BelowPrevErrorR := BelowErrorR + CurrentErrorR; // Error * 5

    BelowErrorR := BelowNextError; // Error * 1

    inc(CurrentErrorR, Delta); // Error * 7
  End;

  // Green component
  CurrentErrorG := CurrentErrorG - g;
  If (CurrentErrorG <> 0) Then
  Begin
    BelowNextError := CurrentErrorG; // Error * 1

    Delta := CurrentErrorG * 2;
    inc(CurrentErrorG, Delta);
    ErrorG[0] := BelowPrevErrorG + CurrentErrorG; // Error * 3

    inc(CurrentErrorG, Delta);
    BelowPrevErrorG := BelowErrorG + CurrentErrorG; // Error * 5

    BelowErrorG := BelowNextError; // Error * 1

    inc(CurrentErrorG, Delta); // Error * 7
  End;

  // Blue component
  CurrentErrorB := CurrentErrorB - b;
  If (CurrentErrorB <> 0) Then
  Begin
    BelowNextError := CurrentErrorB; // Error * 1

    Delta := CurrentErrorB * 2;
    inc(CurrentErrorB, Delta);
    ErrorB[0] := BelowPrevErrorB + CurrentErrorB; // Error * 3

    inc(CurrentErrorB, Delta);
    BelowPrevErrorB := BelowErrorB + CurrentErrorB; // Error * 5

    BelowErrorB := BelowNextError; // Error * 1

    inc(CurrentErrorB, Delta); // Error * 7
  End;

  // Move on to next column
  If (Direction = 1) Then
  Begin
    inc(longInt(ErrorR), SizeOf(TErrorTerm));
    inc(longInt(ErrorG), SizeOf(TErrorTerm));
    inc(longInt(ErrorB), SizeOf(TErrorTerm));
  End Else
  Begin
    Dec(longInt(ErrorR), SizeOf(TErrorTerm));
    Dec(longInt(ErrorG), SizeOf(TErrorTerm));
    Dec(longInt(ErrorB), SizeOf(TErrorTerm));
  End;
End;
{$IFDEF R_PLUS}
{$RANGECHECKS ON}
{$UNDEF R_PLUS}
{$ENDIF}

{$IFOPT R+}
{$DEFINE R_PLUS}
{$RANGECHECKS OFF}
{$ENDIF}
Procedure TFloydSteinbergDitherer.NextLine;
Begin
  ErrorR[0] := BelowPrevErrorR;
  ErrorG[0] := BelowPrevErrorG;
  ErrorB[0] := BelowPrevErrorB;

  // Note: The optimizer produces better code for this construct:
  //   a := 0; b := a; c := a;
  // compared to this construct:
  //   a := 0; b := 0; c := 0;
  CurrentErrorR := 0;
  CurrentErrorG := CurrentErrorR;
  CurrentErrorB := CurrentErrorG;
  BelowErrorR := CurrentErrorG;
  BelowErrorG := CurrentErrorG;
  BelowErrorB := CurrentErrorG;
  BelowPrevErrorR := CurrentErrorG;
  BelowPrevErrorG := CurrentErrorG;
  BelowPrevErrorB := CurrentErrorG;

  Inherited NextLine;

  If (Direction = 1) Then
  Begin
    ErrorR := ErrorsR;
    ErrorG := ErrorsG;
    ErrorB := ErrorsB;
  End Else
  Begin
    ErrorR := @ErrorsR[Width + 1];
    ErrorG := @ErrorsG[Width + 1];
    ErrorB := @ErrorsB[Width + 1];
  End;
End;
{$IFDEF R_PLUS}
{$RANGECHECKS ON}
{$UNDEF R_PLUS}
{$ENDIF}

////////////////////////////////////////////////////////////////////////////////
//	T5by3Ditherer
Constructor T5by3Ditherer.Create(AWidth: integer; Lookup: TColorLookup);
Begin
  Inherited Create(AWidth, Lookup);

  GetMem(ErrorsR0, SizeOf(TErrorTerm) * (Width + 4));
  GetMem(ErrorsG0, SizeOf(TErrorTerm) * (Width + 4));
  GetMem(ErrorsB0, SizeOf(TErrorTerm) * (Width + 4));
  GetMem(ErrorsR1, SizeOf(TErrorTerm) * (Width + 4));
  GetMem(ErrorsG1, SizeOf(TErrorTerm) * (Width + 4));
  GetMem(ErrorsB1, SizeOf(TErrorTerm) * (Width + 4));
  GetMem(ErrorsR2, SizeOf(TErrorTerm) * (Width + 4));
  GetMem(ErrorsG2, SizeOf(TErrorTerm) * (Width + 4));
  GetMem(ErrorsB2, SizeOf(TErrorTerm) * (Width + 4));
  FillChar(ErrorsR0^, SizeOf(TErrorTerm) * (Width + 4), 0);
  FillChar(ErrorsG0^, SizeOf(TErrorTerm) * (Width + 4), 0);
  FillChar(ErrorsB0^, SizeOf(TErrorTerm) * (Width + 4), 0);
  FillChar(ErrorsR1^, SizeOf(TErrorTerm) * (Width + 4), 0);
  FillChar(ErrorsG1^, SizeOf(TErrorTerm) * (Width + 4), 0);
  FillChar(ErrorsB1^, SizeOf(TErrorTerm) * (Width + 4), 0);
  FillChar(ErrorsR2^, SizeOf(TErrorTerm) * (Width + 4), 0);
  FillChar(ErrorsG2^, SizeOf(TErrorTerm) * (Width + 4), 0);
  FillChar(ErrorsB2^, SizeOf(TErrorTerm) * (Width + 4), 0);

  FDivisor := 1;
  FDirection2 := 2 * Direction;
  ErrorR0 := PErrors(longInt(ErrorsR0) + 2 * SizeOf(TErrorTerm));
  ErrorG0 := PErrors(longInt(ErrorsG0) + 2 * SizeOf(TErrorTerm));
  ErrorB0 := PErrors(longInt(ErrorsB0) + 2 * SizeOf(TErrorTerm));
  ErrorR1 := PErrors(longInt(ErrorsR1) + 2 * SizeOf(TErrorTerm));
  ErrorG1 := PErrors(longInt(ErrorsG1) + 2 * SizeOf(TErrorTerm));
  ErrorB1 := PErrors(longInt(ErrorsB1) + 2 * SizeOf(TErrorTerm));
  ErrorR2 := PErrors(longInt(ErrorsR2) + 2 * SizeOf(TErrorTerm));
  ErrorG2 := PErrors(longInt(ErrorsG2) + 2 * SizeOf(TErrorTerm));
  ErrorB2 := PErrors(longInt(ErrorsB2) + 2 * SizeOf(TErrorTerm));
End;

Destructor T5by3Ditherer.Destroy;
Begin
  FreeMem(ErrorsR0);
  FreeMem(ErrorsG0);
  FreeMem(ErrorsB0);
  FreeMem(ErrorsR1);
  FreeMem(ErrorsG1);
  FreeMem(ErrorsB1);
  FreeMem(ErrorsR2);
  FreeMem(ErrorsG2);
  FreeMem(ErrorsB2);
  Inherited Destroy;
End;

{$IFOPT R+}
{$DEFINE R_PLUS}
{$RANGECHECKS OFF}
{$ENDIF}
Function T5by3Ditherer.Dither(Red, Green, Blue: Byte; Var R, g, b: Byte): char;
Var
  ColorR,
    ColorG,
    ColorB: integer; // Error for current pixel
Begin
  // Apply red component error correction
  ColorR := Red + (ErrorR0[0] + FDivisor Div 2) Div FDivisor;
  If (ColorR < 0) Then
    ColorR := 0
  Else If (ColorR > 255) Then
    ColorR := 255;

  // Apply green component error correction
  ColorG := Green + (ErrorG0[0] + FDivisor Div 2) Div FDivisor;
  If (ColorG < 0) Then
    ColorG := 0
  Else If (ColorG > 255) Then
    ColorG := 255;

  // Apply blue component error correction
  ColorB := Blue + (ErrorB0[0] + FDivisor Div 2) Div FDivisor;
  If (ColorB < 0) Then
    ColorB := 0
  Else If (ColorB > 255) Then
    ColorB := 255;

  // Map color to palette
  Result := Inherited Dither(ColorR, ColorG, ColorB, R, g, b);

  // Propagate red component error
  Propagate(ErrorR0, ErrorR1, ErrorR2, ColorR - R);
  // Propagate green component error
  Propagate(ErrorG0, ErrorG1, ErrorG2, ColorG - g);
  // Propagate blue component error
  Propagate(ErrorB0, ErrorB1, ErrorB2, ColorB - b);

  // Move on to next column
  If (Direction = 1) Then
  Begin
    inc(longInt(ErrorR0), SizeOf(TErrorTerm));
    inc(longInt(ErrorG0), SizeOf(TErrorTerm));
    inc(longInt(ErrorB0), SizeOf(TErrorTerm));
    inc(longInt(ErrorR1), SizeOf(TErrorTerm));
    inc(longInt(ErrorG1), SizeOf(TErrorTerm));
    inc(longInt(ErrorB1), SizeOf(TErrorTerm));
    inc(longInt(ErrorR2), SizeOf(TErrorTerm));
    inc(longInt(ErrorG2), SizeOf(TErrorTerm));
    inc(longInt(ErrorB2), SizeOf(TErrorTerm));
  End Else
  Begin
    Dec(longInt(ErrorR0), SizeOf(TErrorTerm));
    Dec(longInt(ErrorG0), SizeOf(TErrorTerm));
    Dec(longInt(ErrorB0), SizeOf(TErrorTerm));
    Dec(longInt(ErrorR1), SizeOf(TErrorTerm));
    Dec(longInt(ErrorG1), SizeOf(TErrorTerm));
    Dec(longInt(ErrorB1), SizeOf(TErrorTerm));
    Dec(longInt(ErrorR2), SizeOf(TErrorTerm));
    Dec(longInt(ErrorG2), SizeOf(TErrorTerm));
    Dec(longInt(ErrorB2), SizeOf(TErrorTerm));
  End;
End;
{$IFDEF R_PLUS}
{$RANGECHECKS ON}
{$UNDEF R_PLUS}
{$ENDIF}

{$IFOPT R+}
{$DEFINE R_PLUS}
{$RANGECHECKS OFF}
{$ENDIF}
Procedure T5by3Ditherer.NextLine;
Var
  TempErrors: PErrors;
Begin
  FillChar(ErrorsR0^, SizeOf(TErrorTerm) * (Width + 4), 0);
  FillChar(ErrorsG0^, SizeOf(TErrorTerm) * (Width + 4), 0);
  FillChar(ErrorsB0^, SizeOf(TErrorTerm) * (Width + 4), 0);

  // Swap lines
  TempErrors := ErrorsR0;
  ErrorsR0 := ErrorsR1;
  ErrorsR1 := ErrorsR2;
  ErrorsR2 := TempErrors;

  TempErrors := ErrorsG0;
  ErrorsG0 := ErrorsG1;
  ErrorsG1 := ErrorsG2;
  ErrorsG2 := TempErrors;

  TempErrors := ErrorsB0;
  ErrorsB0 := ErrorsB1;
  ErrorsB1 := ErrorsB2;
  ErrorsB2 := TempErrors;

  Inherited NextLine;

  FDirection2 := 2 * Direction;
  If (Direction = 1) Then
  Begin
    // ErrorsR0[1] gives compiler error, so we
    // use PErrors(longInt(ErrorsR0)+sizeof(TErrorTerm)) instead...
    ErrorR0 := PErrors(longInt(ErrorsR0) + 2 * SizeOf(TErrorTerm));
    ErrorG0 := PErrors(longInt(ErrorsG0) + 2 * SizeOf(TErrorTerm));
    ErrorB0 := PErrors(longInt(ErrorsB0) + 2 * SizeOf(TErrorTerm));
    ErrorR1 := PErrors(longInt(ErrorsR1) + 2 * SizeOf(TErrorTerm));
    ErrorG1 := PErrors(longInt(ErrorsG1) + 2 * SizeOf(TErrorTerm));
    ErrorB1 := PErrors(longInt(ErrorsB1) + 2 * SizeOf(TErrorTerm));
    ErrorR2 := PErrors(longInt(ErrorsR2) + 2 * SizeOf(TErrorTerm));
    ErrorG2 := PErrors(longInt(ErrorsG2) + 2 * SizeOf(TErrorTerm));
    ErrorB2 := PErrors(longInt(ErrorsB2) + 2 * SizeOf(TErrorTerm));
  End Else
  Begin
    ErrorR0 := @ErrorsR0[Width + 1];
    ErrorG0 := @ErrorsG0[Width + 1];
    ErrorB0 := @ErrorsB0[Width + 1];
    ErrorR1 := @ErrorsR1[Width + 1];
    ErrorG1 := @ErrorsG1[Width + 1];
    ErrorB1 := @ErrorsB1[Width + 1];
    ErrorR2 := @ErrorsR2[Width + 1];
    ErrorG2 := @ErrorsG2[Width + 1];
    ErrorB2 := @ErrorsB2[Width + 1];
  End;
End;
{$IFDEF R_PLUS}
{$RANGECHECKS ON}
{$UNDEF R_PLUS}
{$ENDIF}

////////////////////////////////////////////////////////////////////////////////
//	TStuckiDitherer
Constructor TStuckiDitherer.Create(AWidth: integer; Lookup: TColorLookup);
Begin
  Inherited Create(AWidth, Lookup);
  FDivisor := 42;
End;

{$IFOPT R+}
{$DEFINE R_PLUS}
{$RANGECHECKS OFF}
{$ENDIF}
Procedure TStuckiDitherer.Propagate(Errors0, Errors1, Errors2: PErrors; Error: integer);
Begin
  If (Error = 0) Then
    Exit;
  // Propagate Stucki error terms:
  //	...	...	(here)	8/42	4/42
  //	2/42	4/42	8/42	4/42	2/42
  //	1/42	2/42	4/42	2/42	1/42
  inc(Errors2[FDirection2], Error); // Error * 1
  inc(Errors2[-FDirection2], Error); // Error * 1

  Error := Error + Error;
  inc(Errors1[FDirection2], Error); // Error * 2
  inc(Errors1[-FDirection2], Error); // Error * 2
  inc(Errors2[Direction], Error); // Error * 2
  inc(Errors2[-Direction], Error); // Error * 2

  Error := Error + Error;
  inc(Errors0[FDirection2], Error); // Error * 4
  inc(Errors1[-Direction], Error); // Error * 4
  inc(Errors1[Direction], Error); // Error * 4
  inc(Errors2[0], Error); // Error * 4

  Error := Error + Error;
  inc(Errors0[Direction], Error); // Error * 8
  inc(Errors1[0], Error); // Error * 8
End;
{$IFDEF R_PLUS}
{$RANGECHECKS ON}
{$UNDEF R_PLUS}
{$ENDIF}

////////////////////////////////////////////////////////////////////////////////
//	TSierraDitherer
Constructor TSierraDitherer.Create(AWidth: integer; Lookup: TColorLookup);
Begin
  Inherited Create(AWidth, Lookup);
  FDivisor := 32;
End;

{$IFOPT R+}
{$DEFINE R_PLUS}
{$RANGECHECKS OFF}
{$ENDIF}
Procedure TSierraDitherer.Propagate(Errors0, Errors1, Errors2: PErrors; Error: integer);
Var
  TempError: integer;
Begin
  If (Error = 0) Then
    Exit;
  // Propagate Sierra error terms:
  //	...	...	(here)	5/32	3/32
  //	2/32	4/32	5/32	4/32	2/32
  //	...	2/32	3/32	2/32	...
  TempError := Error + Error;
  inc(Errors1[FDirection2], TempError); // Error * 2
  inc(Errors1[-FDirection2], TempError); // Error * 2
  inc(Errors2[Direction], TempError); // Error * 2
  inc(Errors2[-Direction], TempError); // Error * 2

  inc(TempError, Error);
  inc(Errors0[FDirection2], TempError); // Error * 3
  inc(Errors2[0], TempError); // Error * 3

  inc(TempError, Error);
  inc(Errors1[-Direction], TempError); // Error * 4
  inc(Errors1[Direction], TempError); // Error * 4

  inc(TempError, Error);
  inc(Errors0[Direction], TempError); // Error * 5
  inc(Errors1[0], TempError); // Error * 5
End;
{$IFDEF R_PLUS}
{$RANGECHECKS ON}
{$UNDEF R_PLUS}
{$ENDIF}

////////////////////////////////////////////////////////////////////////////////
//	TJaJuNiDitherer
Constructor TJaJuNiDitherer.Create(AWidth: integer; Lookup: TColorLookup);
Begin
  Inherited Create(AWidth, Lookup);
  FDivisor := 38;
End;

{$IFOPT R+}
{$DEFINE R_PLUS}
{$RANGECHECKS OFF}
{$ENDIF}
Procedure TJaJuNiDitherer.Propagate(Errors0, Errors1, Errors2: PErrors; Error: integer);
Var
  TempError: integer;
Begin
  If (Error = 0) Then
    Exit;
  // Propagate Jarvis, Judice and Ninke error terms:
  //	...	...	(here)	8/38	4/38
  //	2/38	4/38	8/38	4/38	2/38
  //	1/38	2/38	4/38	2/38	1/38
  inc(Errors2[FDirection2], Error); // Error * 1
  inc(Errors2[-FDirection2], Error); // Error * 1

  TempError := Error + Error;
  inc(Error, TempError);
  inc(Errors1[FDirection2], Error); // Error * 3
  inc(Errors1[-FDirection2], Error); // Error * 3
  inc(Errors2[Direction], Error); // Error * 3
  inc(Errors2[-Direction], Error); // Error * 3

  inc(Error, TempError);
  inc(Errors0[FDirection2], Error); // Error * 5
  inc(Errors1[-Direction], Error); // Error * 5
  inc(Errors1[Direction], Error); // Error * 5
  inc(Errors2[0], Error); // Error * 5

  inc(Error, TempError);
  inc(Errors0[Direction], Error); // Error * 7
  inc(Errors1[0], Error); // Error * 7
End;
{$IFDEF R_PLUS}
{$RANGECHECKS ON}
{$UNDEF R_PLUS}
{$ENDIF}

////////////////////////////////////////////////////////////////////////////////
//	TSteveArcheDitherer
Constructor TSteveArcheDitherer.Create(AWidth: integer; Lookup: TColorLookup);
Begin
  Inherited Create(AWidth, Lookup);

  GetMem(ErrorsR0, SizeOf(TErrorTerm) * (Width + 6));
  GetMem(ErrorsG0, SizeOf(TErrorTerm) * (Width + 6));
  GetMem(ErrorsB0, SizeOf(TErrorTerm) * (Width + 6));
  GetMem(ErrorsR1, SizeOf(TErrorTerm) * (Width + 6));
  GetMem(ErrorsG1, SizeOf(TErrorTerm) * (Width + 6));
  GetMem(ErrorsB1, SizeOf(TErrorTerm) * (Width + 6));
  GetMem(ErrorsR2, SizeOf(TErrorTerm) * (Width + 6));
  GetMem(ErrorsG2, SizeOf(TErrorTerm) * (Width + 6));
  GetMem(ErrorsB2, SizeOf(TErrorTerm) * (Width + 6));
  GetMem(ErrorsR3, SizeOf(TErrorTerm) * (Width + 6));
  GetMem(ErrorsG3, SizeOf(TErrorTerm) * (Width + 6));
  GetMem(ErrorsB3, SizeOf(TErrorTerm) * (Width + 6));
  FillChar(ErrorsR0^, SizeOf(TErrorTerm) * (Width + 6), 0);
  FillChar(ErrorsG0^, SizeOf(TErrorTerm) * (Width + 6), 0);
  FillChar(ErrorsB0^, SizeOf(TErrorTerm) * (Width + 6), 0);
  FillChar(ErrorsR1^, SizeOf(TErrorTerm) * (Width + 6), 0);
  FillChar(ErrorsG1^, SizeOf(TErrorTerm) * (Width + 6), 0);
  FillChar(ErrorsB1^, SizeOf(TErrorTerm) * (Width + 6), 0);
  FillChar(ErrorsR2^, SizeOf(TErrorTerm) * (Width + 6), 0);
  FillChar(ErrorsG2^, SizeOf(TErrorTerm) * (Width + 6), 0);
  FillChar(ErrorsB2^, SizeOf(TErrorTerm) * (Width + 6), 0);
  FillChar(ErrorsR3^, SizeOf(TErrorTerm) * (Width + 6), 0);
  FillChar(ErrorsG3^, SizeOf(TErrorTerm) * (Width + 6), 0);
  FillChar(ErrorsB3^, SizeOf(TErrorTerm) * (Width + 6), 0);

  FDirection2 := 2 * Direction;
  FDirection3 := 3 * Direction;

  ErrorR0 := PErrors(longInt(ErrorsR0) + 3 * SizeOf(TErrorTerm));
  ErrorG0 := PErrors(longInt(ErrorsG0) + 3 * SizeOf(TErrorTerm));
  ErrorB0 := PErrors(longInt(ErrorsB0) + 3 * SizeOf(TErrorTerm));
  ErrorR1 := PErrors(longInt(ErrorsR1) + 3 * SizeOf(TErrorTerm));
  ErrorG1 := PErrors(longInt(ErrorsG1) + 3 * SizeOf(TErrorTerm));
  ErrorB1 := PErrors(longInt(ErrorsB1) + 3 * SizeOf(TErrorTerm));
  ErrorR2 := PErrors(longInt(ErrorsR2) + 3 * SizeOf(TErrorTerm));
  ErrorG2 := PErrors(longInt(ErrorsG2) + 3 * SizeOf(TErrorTerm));
  ErrorB2 := PErrors(longInt(ErrorsB2) + 3 * SizeOf(TErrorTerm));
  ErrorR3 := PErrors(longInt(ErrorsR3) + 3 * SizeOf(TErrorTerm));
  ErrorG3 := PErrors(longInt(ErrorsG3) + 3 * SizeOf(TErrorTerm));
  ErrorB3 := PErrors(longInt(ErrorsB3) + 3 * SizeOf(TErrorTerm));
End;

Destructor TSteveArcheDitherer.Destroy;
Begin
  FreeMem(ErrorsR0);
  FreeMem(ErrorsG0);
  FreeMem(ErrorsB0);
  FreeMem(ErrorsR1);
  FreeMem(ErrorsG1);
  FreeMem(ErrorsB1);
  FreeMem(ErrorsR2);
  FreeMem(ErrorsG2);
  FreeMem(ErrorsB2);
  FreeMem(ErrorsR3);
  FreeMem(ErrorsG3);
  FreeMem(ErrorsB3);
  Inherited Destroy;
End;

{$IFOPT R+}
{$DEFINE R_PLUS}
{$RANGECHECKS OFF}
{$ENDIF}
Function TSteveArcheDitherer.Dither(Red, Green, Blue: Byte; Var R, g, b: Byte): char;
Var
  ColorR,
    ColorG,
    ColorB: integer; // Error for current pixel

  // Propagate Stevenson & Arche error terms:
  //	...	...	...	(here)	...	32/200	...
  //    12/200	...	26/200	...	30/200	...	16/200
  //	...	12/200	...	26/200	...	12/200	...
  //	5/200	...	12/200	...	12/200	...	5/200
  Procedure Propagate(Errors0, Errors1, Errors2, Errors3: PErrors; Error: integer);
  Var
    TempError: integer;
  Begin
    If (Error = 0) Then
      Exit;
    TempError := 5 * Error;
    inc(Errors3[FDirection3], TempError); // Error * 5
    inc(Errors3[-FDirection3], TempError); // Error * 5

    TempError := 12 * Error;
    inc(Errors1[-FDirection3], TempError); // Error * 12
    inc(Errors2[-FDirection2], TempError); // Error * 12
    inc(Errors2[FDirection2], TempError); // Error * 12
    inc(Errors3[-Direction], TempError); // Error * 12
    inc(Errors3[Direction], TempError); // Error * 12

    inc(Errors1[FDirection3], 16 * TempError); // Error * 16

    TempError := 26 * Error;
    inc(Errors1[-Direction], TempError); // Error * 26
    inc(Errors2[0], TempError); // Error * 26

    inc(Errors1[Direction], 30 * Error); // Error * 30

    inc(Errors0[FDirection2], 32 * Error); // Error * 32
  End;

Begin
  // Apply red component error correction
  ColorR := Red + (ErrorR0[0] + 100) Div 200;
  If (ColorR < 0) Then
    ColorR := 0
  Else If (ColorR > 255) Then
    ColorR := 255;

  // Apply green component error correction
  ColorG := Green + (ErrorG0[0] + 100) Div 200;
  If (ColorG < 0) Then
    ColorG := 0
  Else If (ColorG > 255) Then
    ColorG := 255;

  // Apply blue component error correction
  ColorB := Blue + (ErrorB0[0] + 100) Div 200;
  If (ColorB < 0) Then
    ColorB := 0
  Else If (ColorB > 255) Then
    ColorB := 255;

  // Map color to palette
  Result := Inherited Dither(ColorR, ColorG, ColorB, R, g, b);

  // Propagate red component error
  Propagate(ErrorR0, ErrorR1, ErrorR2, ErrorR3, ColorR - R);
  // Propagate green component error
  Propagate(ErrorG0, ErrorG1, ErrorG2, ErrorG3, ColorG - g);
  // Propagate blue component error
  Propagate(ErrorB0, ErrorB1, ErrorB2, ErrorB3, ColorB - b);

  // Move on to next column
  If (Direction = 1) Then
  Begin
    inc(longInt(ErrorR0), SizeOf(TErrorTerm));
    inc(longInt(ErrorG0), SizeOf(TErrorTerm));
    inc(longInt(ErrorB0), SizeOf(TErrorTerm));
    inc(longInt(ErrorR1), SizeOf(TErrorTerm));
    inc(longInt(ErrorG1), SizeOf(TErrorTerm));
    inc(longInt(ErrorB1), SizeOf(TErrorTerm));
    inc(longInt(ErrorR2), SizeOf(TErrorTerm));
    inc(longInt(ErrorG2), SizeOf(TErrorTerm));
    inc(longInt(ErrorB2), SizeOf(TErrorTerm));
    inc(longInt(ErrorR3), SizeOf(TErrorTerm));
    inc(longInt(ErrorG3), SizeOf(TErrorTerm));
    inc(longInt(ErrorB3), SizeOf(TErrorTerm));
  End Else
  Begin
    Dec(longInt(ErrorR0), SizeOf(TErrorTerm));
    Dec(longInt(ErrorG0), SizeOf(TErrorTerm));
    Dec(longInt(ErrorB0), SizeOf(TErrorTerm));
    Dec(longInt(ErrorR1), SizeOf(TErrorTerm));
    Dec(longInt(ErrorG1), SizeOf(TErrorTerm));
    Dec(longInt(ErrorB1), SizeOf(TErrorTerm));
    Dec(longInt(ErrorR2), SizeOf(TErrorTerm));
    Dec(longInt(ErrorG2), SizeOf(TErrorTerm));
    Dec(longInt(ErrorB2), SizeOf(TErrorTerm));
    Dec(longInt(ErrorR3), SizeOf(TErrorTerm));
    Dec(longInt(ErrorG3), SizeOf(TErrorTerm));
    Dec(longInt(ErrorB3), SizeOf(TErrorTerm));
  End;
End;
{$IFDEF R_PLUS}
{$RANGECHECKS ON}
{$UNDEF R_PLUS}
{$ENDIF}

{$IFOPT R+}
{$DEFINE R_PLUS}
{$RANGECHECKS OFF}
{$ENDIF}
Procedure TSteveArcheDitherer.NextLine;
Var
  TempErrors: PErrors;
Begin
  FillChar(ErrorsR0^, SizeOf(TErrorTerm) * (Width + 6), 0);
  FillChar(ErrorsG0^, SizeOf(TErrorTerm) * (Width + 6), 0);
  FillChar(ErrorsB0^, SizeOf(TErrorTerm) * (Width + 6), 0);

  // Swap lines
  TempErrors := ErrorsR0;
  ErrorsR0 := ErrorsR1;
  ErrorsR1 := ErrorsR2;
  ErrorsR2 := ErrorsR3;
  ErrorsR3 := TempErrors;

  TempErrors := ErrorsG0;
  ErrorsG0 := ErrorsG1;
  ErrorsG1 := ErrorsG2;
  ErrorsG2 := ErrorsG3;
  ErrorsG3 := TempErrors;

  TempErrors := ErrorsB0;
  ErrorsB0 := ErrorsB1;
  ErrorsB1 := ErrorsB2;
  ErrorsB2 := ErrorsB3;
  ErrorsB3 := TempErrors;

  Inherited NextLine;

  FDirection2 := 2 * Direction;
  FDirection3 := 3 * Direction;

  If (Direction = 1) Then
  Begin
    // ErrorsR0[1] gives compiler error, so we
    // use PErrors(longInt(ErrorsR0)+sizeof(TErrorTerm)) instead...
    ErrorR0 := PErrors(longInt(ErrorsR0) + 3 * SizeOf(TErrorTerm));
    ErrorG0 := PErrors(longInt(ErrorsG0) + 3 * SizeOf(TErrorTerm));
    ErrorB0 := PErrors(longInt(ErrorsB0) + 3 * SizeOf(TErrorTerm));
    ErrorR1 := PErrors(longInt(ErrorsR1) + 3 * SizeOf(TErrorTerm));
    ErrorG1 := PErrors(longInt(ErrorsG1) + 3 * SizeOf(TErrorTerm));
    ErrorB1 := PErrors(longInt(ErrorsB1) + 3 * SizeOf(TErrorTerm));
    ErrorR2 := PErrors(longInt(ErrorsR2) + 3 * SizeOf(TErrorTerm));
    ErrorG2 := PErrors(longInt(ErrorsG2) + 3 * SizeOf(TErrorTerm));
    ErrorB2 := PErrors(longInt(ErrorsB2) + 3 * SizeOf(TErrorTerm));
    ErrorR3 := PErrors(longInt(ErrorsR3) + 3 * SizeOf(TErrorTerm));
    ErrorG3 := PErrors(longInt(ErrorsG3) + 3 * SizeOf(TErrorTerm));
    ErrorB3 := PErrors(longInt(ErrorsB3) + 3 * SizeOf(TErrorTerm));
  End Else
  Begin
    ErrorR0 := @ErrorsR0[Width + 2];
    ErrorG0 := @ErrorsG0[Width + 2];
    ErrorB0 := @ErrorsB0[Width + 2];
    ErrorR1 := @ErrorsR1[Width + 2];
    ErrorG1 := @ErrorsG1[Width + 2];
    ErrorB1 := @ErrorsB1[Width + 2];
    ErrorR2 := @ErrorsR2[Width + 2];
    ErrorG2 := @ErrorsG2[Width + 2];
    ErrorB2 := @ErrorsB2[Width + 2];
    ErrorR3 := @ErrorsR2[Width + 2];
    ErrorG3 := @ErrorsG2[Width + 2];
    ErrorB3 := @ErrorsB2[Width + 2];
  End;
End;
{$IFDEF R_PLUS}
{$RANGECHECKS ON}
{$UNDEF R_PLUS}
{$ENDIF}

////////////////////////////////////////////////////////////////////////////////
//	TBurkesDitherer
Constructor TBurkesDitherer.Create(AWidth: integer; Lookup: TColorLookup);
Begin
  Inherited Create(AWidth, Lookup);

  GetMem(ErrorsR0, SizeOf(TErrorTerm) * (Width + 4));
  GetMem(ErrorsG0, SizeOf(TErrorTerm) * (Width + 4));
  GetMem(ErrorsB0, SizeOf(TErrorTerm) * (Width + 4));
  GetMem(ErrorsR1, SizeOf(TErrorTerm) * (Width + 4));
  GetMem(ErrorsG1, SizeOf(TErrorTerm) * (Width + 4));
  GetMem(ErrorsB1, SizeOf(TErrorTerm) * (Width + 4));
  FillChar(ErrorsR0^, SizeOf(TErrorTerm) * (Width + 4), 0);
  FillChar(ErrorsG0^, SizeOf(TErrorTerm) * (Width + 4), 0);
  FillChar(ErrorsB0^, SizeOf(TErrorTerm) * (Width + 4), 0);
  FillChar(ErrorsR1^, SizeOf(TErrorTerm) * (Width + 4), 0);
  FillChar(ErrorsG1^, SizeOf(TErrorTerm) * (Width + 4), 0);
  FillChar(ErrorsB1^, SizeOf(TErrorTerm) * (Width + 4), 0);

  FDirection2 := 2 * Direction;
  ErrorR0 := PErrors(longInt(ErrorsR0) + 2 * SizeOf(TErrorTerm));
  ErrorG0 := PErrors(longInt(ErrorsG0) + 2 * SizeOf(TErrorTerm));
  ErrorB0 := PErrors(longInt(ErrorsB0) + 2 * SizeOf(TErrorTerm));
  ErrorR1 := PErrors(longInt(ErrorsR1) + 2 * SizeOf(TErrorTerm));
  ErrorG1 := PErrors(longInt(ErrorsG1) + 2 * SizeOf(TErrorTerm));
  ErrorB1 := PErrors(longInt(ErrorsB1) + 2 * SizeOf(TErrorTerm));
End;

Destructor TBurkesDitherer.Destroy;
Begin
  FreeMem(ErrorsR0);
  FreeMem(ErrorsG0);
  FreeMem(ErrorsB0);
  FreeMem(ErrorsR1);
  FreeMem(ErrorsG1);
  FreeMem(ErrorsB1);
  Inherited Destroy;
End;

{$IFOPT R+}
{$DEFINE R_PLUS}
{$RANGECHECKS OFF}
{$ENDIF}
Function TBurkesDitherer.Dither(Red, Green, Blue: Byte; Var R, g, b: Byte): char;
Var
  ErrorR,
    ErrorG,
    ErrorB: integer; // Error for current pixel

  // Propagate Burkes error terms:
  //	...	...	(here)	8/32	4/32
  //	2/32	4/32	8/32	4/32	2/32
  Procedure Propagate(Errors0, Errors1: PErrors; Error: integer);
  Begin
    If (Error = 0) Then
      Exit;
    inc(Error, Error);
    inc(Errors1[FDirection2], Error); // Error * 2
    inc(Errors1[-FDirection2], Error); // Error * 2

    inc(Error, Error);
    inc(Errors0[FDirection2], Error); // Error * 4
    inc(Errors1[-Direction], Error); // Error * 4
    inc(Errors1[Direction], Error); // Error * 4

    inc(Error, Error);
    inc(Errors0[Direction], Error); // Error * 8
    inc(Errors1[0], Error); // Error * 8
  End;

Begin
  // Apply red component error correction
  ErrorR := Red + (ErrorR0[0] + 16) Div 32;
  If (ErrorR < 0) Then
    ErrorR := 0
  Else If (ErrorR > 255) Then
    ErrorR := 255;

  // Apply green component error correction
  ErrorG := Green + (ErrorG0[0] + 16) Div 32;
  If (ErrorG < 0) Then
    ErrorG := 0
  Else If (ErrorG > 255) Then
    ErrorG := 255;

  // Apply blue component error correction
  ErrorB := Blue + (ErrorB0[0] + 16) Div 32;
  If (ErrorB < 0) Then
    ErrorB := 0
  Else If (ErrorB > 255) Then
    ErrorB := 255;

  // Map color to palette
  Result := Inherited Dither(ErrorR, ErrorG, ErrorB, R, g, b);

  // Propagate red component error
  Propagate(ErrorR0, ErrorR1, ErrorR - R);
  // Propagate green component error
  Propagate(ErrorG0, ErrorG1, ErrorG - g);
  // Propagate blue component error
  Propagate(ErrorB0, ErrorB1, ErrorB - b);

  // Move on to next column
  If (Direction = 1) Then
  Begin
    inc(longInt(ErrorR0), SizeOf(TErrorTerm));
    inc(longInt(ErrorG0), SizeOf(TErrorTerm));
    inc(longInt(ErrorB0), SizeOf(TErrorTerm));
    inc(longInt(ErrorR1), SizeOf(TErrorTerm));
    inc(longInt(ErrorG1), SizeOf(TErrorTerm));
    inc(longInt(ErrorB1), SizeOf(TErrorTerm));
  End Else
  Begin
    Dec(longInt(ErrorR0), SizeOf(TErrorTerm));
    Dec(longInt(ErrorG0), SizeOf(TErrorTerm));
    Dec(longInt(ErrorB0), SizeOf(TErrorTerm));
    Dec(longInt(ErrorR1), SizeOf(TErrorTerm));
    Dec(longInt(ErrorG1), SizeOf(TErrorTerm));
    Dec(longInt(ErrorB1), SizeOf(TErrorTerm));
  End;
End;
{$IFDEF R_PLUS}
{$RANGECHECKS ON}
{$UNDEF R_PLUS}
{$ENDIF}

{$IFOPT R+}
{$DEFINE R_PLUS}
{$RANGECHECKS OFF}
{$ENDIF}
Procedure TBurkesDitherer.NextLine;
Var
  TempErrors: PErrors;
Begin
  FillChar(ErrorsR0^, SizeOf(TErrorTerm) * (Width + 4), 0);
  FillChar(ErrorsG0^, SizeOf(TErrorTerm) * (Width + 4), 0);
  FillChar(ErrorsB0^, SizeOf(TErrorTerm) * (Width + 4), 0);

  // Swap lines
  TempErrors := ErrorsR0;
  ErrorsR0 := ErrorsR1;
  ErrorsR1 := TempErrors;

  TempErrors := ErrorsG0;
  ErrorsG0 := ErrorsG1;
  ErrorsG1 := TempErrors;

  TempErrors := ErrorsB0;
  ErrorsB0 := ErrorsB1;
  ErrorsB1 := TempErrors;

  Inherited NextLine;

  FDirection2 := 2 * Direction;
  If (Direction = 1) Then
  Begin
    // ErrorsR0[1] gives compiler error, so we
    // use PErrors(longInt(ErrorsR0)+sizeof(TErrorTerm)) instead...
    ErrorR0 := PErrors(longInt(ErrorsR0) + 2 * SizeOf(TErrorTerm));
    ErrorG0 := PErrors(longInt(ErrorsG0) + 2 * SizeOf(TErrorTerm));
    ErrorB0 := PErrors(longInt(ErrorsB0) + 2 * SizeOf(TErrorTerm));
    ErrorR1 := PErrors(longInt(ErrorsR1) + 2 * SizeOf(TErrorTerm));
    ErrorG1 := PErrors(longInt(ErrorsG1) + 2 * SizeOf(TErrorTerm));
    ErrorB1 := PErrors(longInt(ErrorsB1) + 2 * SizeOf(TErrorTerm));
  End Else
  Begin
    ErrorR0 := @ErrorsR0[Width + 1];
    ErrorG0 := @ErrorsG0[Width + 1];
    ErrorB0 := @ErrorsB0[Width + 1];
    ErrorR1 := @ErrorsR1[Width + 1];
    ErrorG1 := @ErrorsG1[Width + 1];
    ErrorB1 := @ErrorsB1[Width + 1];
  End;
End;
{$IFDEF R_PLUS}
{$RANGECHECKS ON}
{$UNDEF R_PLUS}
{$ENDIF}

////////////////////////////////////////////////////////////////////////////////
//
//			Octree Color Quantization Engine
//
////////////////////////////////////////////////////////////////////////////////
//  Adapted from Earl F. Glynn's ColorQuantizationLibrary, March 1998
////////////////////////////////////////////////////////////////////////////////
Type
  TOctreeNode = Class; // Forward definition so TReducibleNodes can be declared

  TReducibleNodes = Array[0..7] Of TOctreeNode;

  TOctreeNode = Class(TObject)
  Public
    IsLeaf: Boolean;
    PixelCount: integer;
    RedSum: integer;
    GreenSum: integer;
    BlueSum: integer;
    Next: TOctreeNode;
    Child: TReducibleNodes;

    Constructor Create(Level: integer; ColorBits: integer; Var LeafCount: integer;
      Var ReducibleNodes: TReducibleNodes);
    Destructor Destroy; Override;
  End;

  TColorQuantizer = Class(TObject)
  Private
    FTree: TOctreeNode;
    FLeafCount: integer;
    FReducibleNodes: TReducibleNodes;
    FMaxColors: integer;
    FColorBits: integer;

  Protected
    Procedure AddColor(Var Node: TOctreeNode; R, g, b: Byte; ColorBits: integer;
      Level: integer; Var LeafCount: integer; Var ReducibleNodes: TReducibleNodes);
    Procedure DeleteTree(Var Node: TOctreeNode);
    Procedure GetPaletteColors(Const Node: TOctreeNode;
      Var RGBQuadArray: TRGBQuadArray; Var Index: integer);
    Procedure ReduceTree(ColorBits: integer; Var LeafCount: integer;
      Var ReducibleNodes: TReducibleNodes);

  Public
    Constructor Create(MaxColors: integer; ColorBits: integer);
    Destructor Destroy; Override;

    Procedure GetColorTable(Var RGBQuadArray: TRGBQuadArray);
    Function ProcessImage(Const DIB: TDIBReader): Boolean;

    Property ColorCount: integer Read FLeafCount;
  End;

Constructor TOctreeNode.Create(Level: integer; ColorBits: integer;
  Var LeafCount: integer; Var ReducibleNodes: TReducibleNodes);
Var
  i: integer;
Begin
  PixelCount := 0;
  RedSum := 0;
  GreenSum := 0;
  BlueSum := 0;
  For i := Low(Child) To High(Child) Do
    Child[i] := Nil;

  IsLeaf := (Level = ColorBits);
  If (IsLeaf) Then
  Begin
    Next := Nil;
    inc(LeafCount);
  End Else
  Begin
    Next := ReducibleNodes[Level];
    ReducibleNodes[Level] := self;
  End;
End;

Destructor TOctreeNode.Destroy;
Var
  i: integer;
Begin
  For i := High(Child) Downto Low(Child) Do
    Child[i].Free;
End;

Constructor TColorQuantizer.Create(MaxColors: integer; ColorBits: integer);
Var
  i: integer;
Begin
  ASSERT(ColorBits <= 8, 'ColorBits must be 8 or less');

  FTree := Nil;
  FLeafCount := 0;

  // Initialize all nodes even though only ColorBits+1 of them are needed
  For i := Low(FReducibleNodes) To High(FReducibleNodes) Do
    FReducibleNodes[i] := Nil;

  FMaxColors := MaxColors;
  FColorBits := ColorBits;
End;

Destructor TColorQuantizer.Destroy;
Begin
  If (FTree <> Nil) Then
    DeleteTree(FTree);
End;

Procedure TColorQuantizer.GetColorTable(Var RGBQuadArray: TRGBQuadArray);
Var
  Index: integer;
Begin
  Index := 0;
  GetPaletteColors(FTree, RGBQuadArray, Index);
End;

// Handles passed to ProcessImage should refer to DIB sections, not DDBs.
// In certain cases, specifically when it's called upon to process 1, 4, or
// 8-bit per pixel images on systems with palettized display adapters,
// ProcessImage can produce incorrect results if it's passed a handle to a
// DDB.
Function TColorQuantizer.ProcessImage(Const DIB: TDIBReader): Boolean;
Var
  i,
    j: integer;
  Scanline: Pointer;
  Pixel: PRGBTriple;
Begin
  Result := True;

  For j := 0 To DIB.Bitmap.Height - 1 Do
  Begin
    Scanline := DIB.Scanline[j];
    Pixel := Scanline;
    For i := 0 To DIB.Bitmap.Width - 1 Do
    Begin
      With Pixel^ Do
        AddColor(FTree, rgbtRed, rgbtGreen, rgbtBlue,
          FColorBits, 0, FLeafCount, FReducibleNodes);

      While FLeafCount > FMaxColors Do
        ReduceTree(FColorBits, FLeafCount, FReducibleNodes);
      inc(Pixel);
    End;
  End;
End;

Procedure TColorQuantizer.AddColor(Var Node: TOctreeNode; R, g, b: Byte;
  ColorBits: integer; Level: integer; Var LeafCount: integer;
  Var ReducibleNodes: TReducibleNodes);
Const
  Mask: Array[0..7] Of Byte = ($80, $40, $20, $10, $08, $04, $02, $01);
Var
  Index: integer;
  Shift: integer;
Begin
  // If the node doesn't exist, create it.
  If (Node = Nil) Then
    Node := TOctreeNode.Create(Level, ColorBits, LeafCount, ReducibleNodes);

  If (Node.IsLeaf) Then
  Begin
    inc(Node.PixelCount);
    inc(Node.RedSum, R);
    inc(Node.GreenSum, g);
    inc(Node.BlueSum, b);
  End Else
  Begin
    // Recurse a level deeper if the node is not a leaf.
    Shift := 7 - Level;

    Index := (((R And Mask[Level]) Shr Shift) Shl 2) Or
      (((g And Mask[Level]) Shr Shift) Shl 1) Or
      ((b And Mask[Level]) Shr Shift);
    AddColor(Node.Child[Index], R, g, b, ColorBits, Level + 1, LeafCount, ReducibleNodes);
  End;
End;

Procedure TColorQuantizer.DeleteTree(Var Node: TOctreeNode);
Var
  i: integer;
Begin
  For i := High(TReducibleNodes) Downto Low(TReducibleNodes) Do
    If (Node.Child[i] <> Nil) Then
      DeleteTree(Node.Child[i]);

  Node.Free;
  Node := Nil;
End;

Procedure TColorQuantizer.GetPaletteColors(Const Node: TOctreeNode;
  Var RGBQuadArray: TRGBQuadArray; Var Index: integer);
Var
  i: integer;
Begin
  If (Node.IsLeaf) Then
  Begin
    With RGBQuadArray[Index] Do
    Begin
      If (Node.PixelCount <> 0) Then
      Begin
        rgbRed := Byte(Node.RedSum Div Node.PixelCount);
        rgbGreen := Byte(Node.GreenSum Div Node.PixelCount);
        rgbBlue := Byte(Node.BlueSum Div Node.PixelCount);
      End Else
      Begin
        rgbRed := 0;
        rgbGreen := 0;
        rgbBlue := 0;
      End;
      rgbReserved := 0;
    End;
    inc(Index);
  End Else
  Begin
    For i := Low(Node.Child) To High(Node.Child) Do
      If (Node.Child[i] <> Nil) Then
        GetPaletteColors(Node.Child[i], RGBQuadArray, Index);
  End;
End;

Procedure TColorQuantizer.ReduceTree(ColorBits: integer; Var LeafCount: integer;
  Var ReducibleNodes: TReducibleNodes);
Var
  RedSum,
    GreenSum,
    BlueSum: integer;
  Children: integer;
  i: integer;
  Node: TOctreeNode;
Begin
  // Find the deepest level containing at least one reducible node
  i := ColorBits - 1;
  While (i > 0) And (ReducibleNodes[i] = Nil) Do
    Dec(i);

  // Reduce the node most recently added to the list at level i.
  Node := ReducibleNodes[i];
  ReducibleNodes[i] := Node.Next;

  RedSum := 0;
  GreenSum := 0;
  BlueSum := 0;
  Children := 0;

  For i := Low(ReducibleNodes) To High(ReducibleNodes) Do
    If (Node.Child[i] <> Nil) Then
    Begin
      inc(RedSum, Node.Child[i].RedSum);
      inc(GreenSum, Node.Child[i].GreenSum);
      inc(BlueSum, Node.Child[i].BlueSum);
      inc(Node.PixelCount, Node.Child[i].PixelCount);
      Node.Child[i].Free;
      Node.Child[i] := Nil;
      inc(Children);
    End;

  Node.IsLeaf := True;
  Node.RedSum := RedSum;
  Node.GreenSum := GreenSum;
  Node.BlueSum := BlueSum;
  Dec(LeafCount, Children - 1);
End;

////////////////////////////////////////////////////////////////////////////////
//
//			Octree Color Quantization Wrapper
//
////////////////////////////////////////////////////////////////////////////////
//	Adapted from Earl F. Glynn's PaletteLibrary, March 1998
////////////////////////////////////////////////////////////////////////////////

// Wrapper for internal use - uses TDIBReader for bitmap access
Function doCreateOptimizedPaletteFromSingleBitmap(Const DIB: TDIBReader;
  Colors, ColorBits: integer; Windows: Boolean): HPalette;
Var
  SystemPalette: HPalette;
  ColorQuantizer: TColorQuantizer;
  i: integer;
  LogicalPalette: TMaxLogPalette;
  RGBQuadArray: TRGBQuadArray;
  Offset: integer;
Begin
  LogicalPalette.palVersion := $0300;
  LogicalPalette.palNumEntries := Colors;
// 2003.03.06 ->
  {reset palette to black}
  FillChar(LogicalPalette.palPalEntry, SizeOf(LogicalPalette.palPalEntry), 0);
  For i := 0 To 255 Do
    LogicalPalette.palPalEntry[i].peFlags := PC_NOCOLLAPSE;
// 2003.03.06 <-

  If (Windows) Then
  Begin
    // Get the windows 20 color system palette
    SystemPalette := GetStockObject(DEFAULT_PALETTE);
    GetPaletteEntries(SystemPalette, 0, 10, LogicalPalette.palPalEntry[0]);
    //GetPaletteEntries(SystemPalette, 10, 10, LogicalPalette.palPalEntry[245]);  // wrong offset
    GetPaletteEntries(SystemPalette, 10, 10, LogicalPalette.palPalEntry[246]); // 2003.03.06
    Colors := 236;
    Offset := 10;
    LogicalPalette.palNumEntries := 256;
{ Test code
// 2003.03.06 ->
    // Get the windows 20 color system palette
    SystemPalette := GetStockObject(DEFAULT_PALETTE);
    GetPaletteEntries(SystemPalette, 0, 10, LogicalPalette.palPalEntry[0]);
    GetPaletteEntries(SystemPalette, 10, 10, LogicalPalette.palPalEntry[10]);
    Colors := 236;
    Offset := 20;
    LogicalPalette.palNumEntries := 256;
// 2003.03.06 <-
}
  End Else
    Offset := 0;

  // Normally for 24-bit images, use ColorBits of 5 or 6.  For 8-bit images
  // use ColorBits = 8.
  ColorQuantizer := TColorQuantizer.Create(Colors, ColorBits);
  Try
    ColorQuantizer.ProcessImage(DIB);
    ColorQuantizer.GetColorTable(RGBQuadArray);
  Finally
    ColorQuantizer.Free;
  End;

  For i := 0 To Colors - 1 Do
    With LogicalPalette.palPalEntry[i + Offset] Do
    Begin
      peRed := RGBQuadArray[i].rgbRed;
      peGreen := RGBQuadArray[i].rgbGreen;
      peBlue := RGBQuadArray[i].rgbBlue;
      peFlags := RGBQuadArray[i].rgbReserved;
    End;
  Result := CreatePalette(PLogPalette(@LogicalPalette)^);
End;

Function CreateOptimizedPaletteFromSingleBitmap(Const Bitmap: TBitmap;
  Colors, ColorBits: integer; Windows: Boolean): HPalette;
Var
  DIB: TDIBReader;
Begin
  DIB := TDIBReader.Create(Bitmap, pf24bit);
  Try
    Result := doCreateOptimizedPaletteFromSingleBitmap(DIB, Colors, ColorBits, Windows);
  Finally
    DIB.Free;
  End;
End;

Function CreateOptimizedPaletteFromManyBitmaps(Bitmaps: TList; Colors, ColorBits: integer;
  Windows: Boolean): HPalette;
Var
  SystemPalette: HPalette;
  ColorQuantizer: TColorQuantizer;
  i: integer;
  LogicalPalette: TMaxLogPalette;
  RGBQuadArray: TRGBQuadArray;
  Offset: integer;
  DIB: TDIBReader;
Begin
  If (Bitmaps = Nil) Or (Bitmaps.Count = 0) Then
    Error(sInvalidBitmapList);

  LogicalPalette.palVersion := $0300;
  LogicalPalette.palNumEntries := Colors;
// 2003.03.06 ->
  {reset palette to black}
  FillChar(LogicalPalette.palPalEntry, SizeOf(LogicalPalette.palPalEntry), 0);
  For i := 0 To 255 Do
    LogicalPalette.palPalEntry[i].peFlags := PC_NOCOLLAPSE;
// 2003.03.06 <-

  If (Windows) Then
  Begin
    // Get the windows 20 color system palette
    SystemPalette := GetStockObject(DEFAULT_PALETTE);
    GetPaletteEntries(SystemPalette, 0, 10, LogicalPalette.palPalEntry[0]);
    //GetPaletteEntries(SystemPalette, 10, 10, LogicalPalette.palPalEntry[245]);  // wrong offset
    GetPaletteEntries(SystemPalette, 10, 10, LogicalPalette.palPalEntry[246]); // 2003.03.06
    Colors := 236;
    Offset := 10;
    LogicalPalette.palNumEntries := 256;
{ Test code
// 2003.03.06 ->
    // Get the windows 20 color system palette
    SystemPalette := GetStockObject(DEFAULT_PALETTE);
    GetPaletteEntries(SystemPalette, 0, 10, LogicalPalette.palPalEntry[0]);
    GetPaletteEntries(SystemPalette, 10, 10, LogicalPalette.palPalEntry[10]);
    Colors := 236;
    Offset := 20;
    LogicalPalette.palNumEntries := 256;
// 2003.03.06 <-
}
  End Else
    Offset := 0;

  // Normally for 24-bit images, use ColorBits of 5 or 6.  For 8-bit images
  // use ColorBits = 8.
  ColorQuantizer := TColorQuantizer.Create(Colors, ColorBits);
  Try
    For i := 0 To Bitmaps.Count - 1 Do
    Begin
      DIB := TDIBReader.Create(TBitmap(Bitmaps[i]), pf24bit);
      Try
        ColorQuantizer.ProcessImage(DIB);
      Finally
        DIB.Free;
      End;
    End;
    ColorQuantizer.GetColorTable(RGBQuadArray);
  Finally
    ColorQuantizer.Free;
  End;

  For i := 0 To Colors - 1 Do
    With LogicalPalette.palPalEntry[i + Offset] Do
    Begin
      peRed := RGBQuadArray[i].rgbRed;
      peGreen := RGBQuadArray[i].rgbGreen;
      peBlue := RGBQuadArray[i].rgbBlue;
      peFlags := RGBQuadArray[i].rgbReserved;
    End;
  Result := CreatePalette(PLogPalette(@LogicalPalette)^);
End;

////////////////////////////////////////////////////////////////////////////////
//
//			Color reduction
//
////////////////////////////////////////////////////////////////////////////////
{$IFOPT R+}
{$DEFINE R_PLUS}
{$RANGECHECKS OFF}
{$ENDIF}
//: Reduces the color depth of a bitmap using color quantization and dithering.
Function ReduceColors(Bitmap: TBitmap; ColorReduction: TColorReduction;
  DitherMode: TDitherMode; ReductionBits: integer; CustomPalette: HPalette): TBitmap;
Var
  Palette: HPalette;
  ColorLookup: TColorLookup;
  Ditherer: TDitherEngine;
  Row: integer;
  DIBResult: TDIBWriter;
  DIBSource: TDIBReader;
  SrcScanLine,
    Src: PRGBTriple;
  DstScanLine,
    Dst: PChar;
  BGR: TRGBTriple;
{$IFDEF DEBUG_DITHERPERFORMANCE}
  TimeStart,
    TimeStop: DWORD;
{$ENDIF}

  Function GrayScalePalette: HPalette;
  Var
    i: integer;
    Pal: TMaxLogPalette;
  Begin
    Pal.palVersion := $0300;
    Pal.palNumEntries := 256;
    For i := 0 To 255 Do
    Begin
      With (Pal.palPalEntry[i]) Do
      Begin
        peRed := i;
        peGreen := i;
        peBlue := i;
        peFlags := PC_NOCOLLAPSE;
      End;
    End;
    Result := CreatePalette(PLogPalette(@Pal)^);
  End;

  Function MonochromePalette: HPalette;
  Var
    i: integer;
    Pal: TMaxLogPalette;
  Const
    Values: Array[0..1] Of Byte
    = (0, 255);
  Begin
    Pal.palVersion := $0300;
    Pal.palNumEntries := 2;
    For i := 0 To 1 Do
    Begin
      With (Pal.palPalEntry[i]) Do
      Begin
        peRed := Values[i];
        peGreen := Values[i];
        peBlue := Values[i];
        peFlags := PC_NOCOLLAPSE;
      End;
    End;
    Result := CreatePalette(PLogPalette(@Pal)^);
  End;

  Function WindowsGrayScalePalette: HPalette;
  Var
    i: integer;
    Pal: TMaxLogPalette;
  Const
    Values: Array[0..3] Of Byte
    = (0, 128, 192, 255);
  Begin
    Pal.palVersion := $0300;
    Pal.palNumEntries := 4;
    For i := 0 To 3 Do
    Begin
      With (Pal.palPalEntry[i]) Do
      Begin
        peRed := Values[i];
        peGreen := Values[i];
        peBlue := Values[i];
        peFlags := PC_NOCOLLAPSE;
      End;
    End;
    Result := CreatePalette(PLogPalette(@Pal)^);
  End;

  Function WindowsHalftonePalette: HPalette;
  Var
    DC: HDC;
  Begin
    DC := GDICheck(GetDC(0));
    Try
      Result := CreateHalftonePalette(DC);
    Finally
      ReleaseDC(0, DC);
    End;
  End;

Begin
{$IFDEF DEBUG_DITHERPERFORMANCE}
  timeBeginPeriod(5);
  TimeStart := timeGetTime;
{$ENDIF}

  Result := TBitmap.Create;
  Try

    If (ColorReduction = rmNone) Then
    Begin
      Result.Assign(Bitmap);
{$IFNDEF VER9x}
      SetPixelFormat(Result, pf24bit);
{$ENDIF}
      Exit;
    End;

{$IFNDEF VER9x}
    If (Bitmap.Width * Bitmap.Height > BitmapAllocationThreshold) Then
      SetPixelFormat(Result, pf1bit); // To reduce resource consumption of resize
{$ENDIF}

    ColorLookup := Nil;
    Ditherer := Nil;
    DIBResult := Nil;
    DIBSource := Nil;
    Palette := 0;
    Try // Protect above resources

      // Dithering and color mapper only supports 24 bit bitmaps,
      // so we have convert the source bitmap to the appropiate format.
      DIBSource := TDIBReader.Create(Bitmap, pf24bit);

      // Create a palette based on current options
      Case (ColorReduction) Of
        rmQuantize:
          Palette := doCreateOptimizedPaletteFromSingleBitmap(DIBSource, 1 Shl ReductionBits, 8, False);
        rmQuantizeWindows:
          Palette := CreateOptimizedPaletteFromSingleBitmap(Bitmap, 256, 8, True);
        rmNetscape:
          Palette := WebPalette;
        rmGrayScale:
          Palette := GrayScalePalette;
        rmMonochrome:
          Palette := MonochromePalette;
        rmWindowsGray:
          Palette := WindowsGrayScalePalette;
        rmWindows20:
          Palette := GetStockObject(DEFAULT_PALETTE);
        rmWindows256:
          Palette := WindowsHalftonePalette;
        rmPalette:
          Palette := CopyPalette(CustomPalette);
      Else
        Exit;
      End;

      { TODO -oanme -cImprovement : Gray scale conversion should be done prior to dithering/mapping. Otherwise corrected values will be converted multiple times. }

      // Create a color mapper based on current options
      Case (ColorReduction) Of
        // For some strange reason my fast and dirty color lookup
        // is more precise that Windows GetNearestPaletteIndex...
        // rmWindows20:
        //  ColorLookup := TSlowColorLookup.Create(Palette);
        // rmWindowsGray:
        //  ColorLookup := TGrayWindowsLookup.Create(Palette);
        rmQuantize:
//          ColorLookup := TFastColorLookup.Create(Palette);
          ColorLookup := TSlowColorLookup.Create(Palette); // 2003-03-06
        rmNetscape:
          ColorLookup := TNetscapeColorLookup.Create(Palette);
        rmGrayScale:
          ColorLookup := TGrayScaleLookup.Create(Palette);
        rmMonochrome:
          ColorLookup := TMonochromeLookup.Create(Palette);
      Else
//        ColorLookup := TFastColorLookup.Create(Palette);
        ColorLookup := TSlowColorLookup.Create(Palette); // 2003-03-06
      End;

      // Nothing to do if palette doesn't contain any colors
      If (ColorLookup.Colors = 0) Then
        Exit;

      // Create a ditherer based on current options
      Case (DitherMode) Of
        dmNearest:
          Ditherer := TDitherEngine.Create(Bitmap.Width, ColorLookup);
        dmFloydSteinberg:
          Ditherer := TFloydSteinbergDitherer.Create(Bitmap.Width, ColorLookup);
        dmStucki:
          Ditherer := TStuckiDitherer.Create(Bitmap.Width, ColorLookup);
        dmSierra:
          Ditherer := TSierraDitherer.Create(Bitmap.Width, ColorLookup);
        dmJaJuNI:
          Ditherer := TJaJuNiDitherer.Create(Bitmap.Width, ColorLookup);
        dmSteveArche:
          Ditherer := TSteveArcheDitherer.Create(Bitmap.Width, ColorLookup);
        dmBurkes:
          Ditherer := TBurkesDitherer.Create(Bitmap.Width, ColorLookup);
      Else
        Exit;
      End;

      // The processed bitmap is returned in pf8bit format
      DIBResult := TDIBWriter.Create(Result, pf8bit, Bitmap.Width, Bitmap.Height,
        Palette);

      // Process the image
      Row := 0;
      While (Row < Bitmap.Height) Do
      Begin
        SrcScanLine := DIBSource.Scanline[Row];
        DstScanLine := DIBResult.Scanline[Row];
        Src := Pointer(longInt(SrcScanLine) + Ditherer.Column * SizeOf(TRGBTriple));
        Dst := Pointer(longInt(DstScanLine) + Ditherer.Column);

        While (Ditherer.Column < Ditherer.Width) And (Ditherer.Column >= 0) Do
        Begin
          BGR := Src^;
          // Dither and map a single pixel
          Dst^ := Ditherer.Dither(BGR.rgbtRed, BGR.rgbtGreen, BGR.rgbtBlue,
            BGR.rgbtRed, BGR.rgbtGreen, BGR.rgbtBlue);

          inc(Src, Ditherer.Direction);
          inc(Dst, Ditherer.Direction);
        End;

        inc(Row);
        Ditherer.NextLine;
      End;
    Finally
      If (ColorLookup <> Nil) Then
        ColorLookup.Free;
      If (Ditherer <> Nil) Then
        Ditherer.Free;
      If (DIBResult <> Nil) Then
        DIBResult.Free;
      If (DIBSource <> Nil) Then
        DIBSource.Free;
      // Must delete palette after TDIBWriter since TDIBWriter uses palette
      If (Palette <> 0) Then
        DeleteObject(Palette);
    End;
  Except
    Result.Free;
    Raise;
  End;

{$IFDEF DEBUG_DITHERPERFORMANCE}
  TimeStop := timeGetTime;
  ShowMessage(Format('Dithered %d pixels in %d mS, Rate %d pixels/mS (%d pixels/S)',
    [Bitmap.Height * Bitmap.Width, TimeStop - TimeStart,
    MulDiv(Bitmap.Height, Bitmap.Width, TimeStop - TimeStart + 1),
      MulDiv(Bitmap.Height, Bitmap.Width * 1000, TimeStop - TimeStart + 1)]));
  timeEndPeriod(5);
{$ENDIF}
End;
{$IFDEF R_PLUS}
{$RANGECHECKS ON}
{$UNDEF R_PLUS}
{$ENDIF}

////////////////////////////////////////////////////////////////////////////////
//
//			TGIFColorMap
//
////////////////////////////////////////////////////////////////////////////////
Const
  InitColorMapSize = 16;
  DeltaColorMapSize = 32;

//: Creates an instance of a TGIFColorMap object.
Constructor TGIFColorMap.Create;
Begin
  Inherited Create;
  FColorMap := Nil;
  FCapacity := 0;
  FCount := 0;
  FOptimized := False;
End;

//: Destroys an instance of a TGIFColorMap object.
Destructor TGIFColorMap.Destroy;
Begin
  Clear;
  Changed;
  Inherited Destroy;
End;

//: Empties the color map.
Procedure TGIFColorMap.Clear;
Begin
  If (FColorMap <> Nil) Then
    FreeMem(FColorMap);
  FColorMap := Nil;
  FCapacity := 0;
  FCount := 0;
  FOptimized := False;
End;

//: Converts a Windows color value to a RGB value.
Class Function TGIFColorMap.Color2RGB(Color: TColor): TGIFColor;
Begin
  Result.Blue := (Color Shr 16) And $FF;
  Result.Green := (Color Shr 8) And $FF;
  Result.Red := Color And $FF;
End;

//: Converts a RGB value to a Windows color value.
Class Function TGIFColorMap.RGB2Color(Color: TGIFColor): TColor;
Begin
  Result := (Color.Blue Shl 16) Or (Color.Green Shl 8) Or Color.Red;
End;

//: Saves the color map to a stream.
Procedure TGIFColorMap.SaveToStream(Stream: TStream);
Var
  Dummies: integer;
  Dummy: TGIFColor;
Begin
  If (FCount = 0) Then
    Exit;
  Stream.WriteBuffer(FColorMap^, FCount * SizeOf(TGIFColor));
  Dummies := (1 Shl BitsPerPixel) - FCount;
  Dummy.Red := 0;
  Dummy.Green := 0;
  Dummy.Blue := 0;
  While (Dummies > 0) Do
  Begin
    Stream.WriteBuffer(Dummy, SizeOf(TGIFColor));
    Dec(Dummies);
  End;
End;

//: Loads the color map from a stream.
Procedure TGIFColorMap.LoadFromStream(Stream: TStream; Count: integer);
Begin
  Clear;
  SetCapacity(Count);
  ReadCheck(Stream, FColorMap^, Count * SizeOf(TGIFColor));
  FCount := Count;
End;

//: Returns the position of a color in the color map.
Function TGIFColorMap.IndexOf(Color: TColor): integer;
Var
  RGB: TGIFColor;
Begin
  RGB := Color2RGB(Color);
  If (FOptimized) Then
  Begin
    // Optimized palette has most frequently occuring entries first
    Result := 0;
    // Reverse search to (hopefully) check latest colors first
    While (Result < FCount) Do
      With (FColorMap^[Result]) Do
      Begin
        If (RGB.Red = Red) And (RGB.Green = Green) And (RGB.Blue = Blue) Then
          Exit;
        inc(Result);
      End;
    Result := -1;
  End Else
  Begin
    Result := FCount - 1;
    // Reverse search to (hopefully) check latest colors first
    While (Result >= 0) Do
      With (FColorMap^[Result]) Do
      Begin
        If (RGB.Red = Red) And (RGB.Green = Green) And (RGB.Blue = Blue) Then
          Exit;
        Dec(Result);
      End;
  End;
End;

Procedure TGIFColorMap.SetCapacity(Size: integer);
Begin
  If (Size >= FCapacity) Then
  Begin
    If (Size <= InitColorMapSize) Then
      FCapacity := InitColorMapSize
    Else
      FCapacity := (Size + DeltaColorMapSize - 1) Div DeltaColorMapSize * DeltaColorMapSize;
    If (FCapacity > GIFMaxColors) Then
      FCapacity := GIFMaxColors;
    ReAllocMem(FColorMap, FCapacity * SizeOf(TGIFColor));
  End;
End;

//: Imports a Windows palette into the color map.
Procedure TGIFColorMap.ImportPalette(Palette: HPalette);
Type
  PalArray = Array[Byte] Of TPaletteEntry;
Var
  Pal: PalArray;
  NewCount: integer;
  i: integer;
Begin
  Clear;
  NewCount := GetPaletteEntries(Palette, 0, 256, Pal);
  If (NewCount = 0) Then
    Exit;
  SetCapacity(NewCount);
  For i := 0 To NewCount - 1 Do
    With FColorMap[i], Pal[i] Do
    Begin
      Red := peRed;
      Green := peGreen;
      Blue := peBlue;
    End;
  FCount := NewCount;
  Changed;
End;

//: Imports a color map structure into the color map.
Procedure TGIFColorMap.ImportColorMap(Map: TColorMap; Count: integer);
Begin
  Clear;
  If (Count = 0) Then
    Exit;
  SetCapacity(Count);
  FCount := Count;

  System.Move(Map, FColorMap^, FCount * SizeOf(TGIFColor));

  Changed;
End;

//: Imports a Windows palette structure into the color map.
Procedure TGIFColorMap.ImportColorTable(Pal: Pointer; Count: integer);
Var
  i: integer;
Begin
  Clear;
  If (Count = 0) Then
    Exit;
  SetCapacity(Count);
  For i := 0 To Count - 1 Do
    With FColorMap[i], PRGBQuadArray(Pal)[i] Do
    Begin
      Red := rgbRed;
      Green := rgbGreen;
      Blue := rgbBlue;
    End;
  FCount := Count;
  Changed;
End;

//: Imports the color table of a DIB into the color map.
Procedure TGIFColorMap.ImportDIBColors(Handle: HDC);
Var
  Pal: Pointer;
  NewCount: integer;
Begin
  Clear;
  GetMem(Pal, SizeOf(TRGBQuad) * 256);
  Try
    NewCount := GetDIBColorTable(Handle, 0, 256, Pal^);
    ImportColorTable(Pal, NewCount);
  Finally
    FreeMem(Pal);
  End;
  Changed;
End;

//: Creates a Windows palette from the color map.
Function TGIFColorMap.ExportPalette: HPalette;
Var
  Pal: TMaxLogPalette;
  i: integer;
Begin
  If (Count = 0) Then
  Begin
    Result := 0;
    Exit;
  End;
  Pal.palVersion := $300;
  Pal.palNumEntries := Count;
  For i := 0 To Count - 1 Do
    With FColorMap[i], Pal.palPalEntry[i] Do
    Begin
      peRed := Red;
      peGreen := Green;
      peBlue := Blue;
      peFlags := PC_NOCOLLAPSE; { TODO -oanme -cImprovement : Verify that PC_NOCOLLAPSE is the correct value to use. }
    End;
  Result := CreatePalette(PLogPalette(@Pal)^);
End;

//: Adds a color to the color map.
Function TGIFColorMap.Add(Color: TColor): integer;
Begin
  If (FCount >= GIFMaxColors) Then
    // Color map full
    Error(sTooManyColors);

  Result := FCount;
  If (Result >= FCapacity) Then
    SetCapacity(FCount + 1);
  FColorMap^[FCount] := Color2RGB(Color);
  inc(FCount);
  FOptimized := False;
  Changed;
End;

Function TGIFColorMap.AddUnique(Color: TColor): integer;
Begin
  // Look up color before add (same as IndexOf)
  Result := IndexOf(Color);
  If (Result >= 0) Then
    // Color already in map
    Exit;

  Result := Add(Color);
End;

//: Removes a color from the color map.
Procedure TGIFColorMap.Delete(Index: integer);
Begin
  If (Index < 0) Or (Index >= FCount) Then
    // Color index out of range
    Error(sBadColorIndex);
  Dec(FCount);
  If (Index < FCount) Then
    System.Move(FColorMap^[Index + 1], FColorMap^[Index], (FCount - Index) * SizeOf(TGIFColor));
  FOptimized := False;
  Changed;
End;

Function TGIFColorMap.GetColor(Index: integer): TColor;
Begin
  If (Index < 0) Or (Index >= FCount) Then
  Begin
    // Color index out of range
    Warning(gsWarning, sBadColorIndex);
    // Raise an exception if the color map is empty
    If (FCount = 0) Then
      Error(sEmptyColorMap);
    // Default to color index 0
    Index := 0;
  End;
  Result := RGB2Color(FColorMap^[Index]);
End;

Procedure TGIFColorMap.SetColor(Index: integer; Value: TColor);
Begin
  If (Index < 0) Or (Index >= FCount) Then
    // Color index out of range
    Error(sBadColorIndex);
  FColorMap^[Index] := Color2RGB(Value);
  Changed;
End;

Function TGIFColorMap.DoOptimize: Boolean;
Var
  Usage: TColormapHistogram;
  TempMap: Array[0..255] Of TGIFColor;
  ReverseMap: TColormapReverse;
  i: integer;
  LastFound: Boolean;
  NewCount: integer;
  T: TUsageCount;
  Pivot: integer;

  Procedure QuickSort(iLo, iHi: integer);
  Var
    Lo, Hi: integer;
  Begin
    Repeat
      Lo := iLo;
      Hi := iHi;
      Pivot := Usage[(iLo + iHi) Shr 1].Count;
      Repeat
        While (Usage[Lo].Count - Pivot > 0) Do inc(Lo);
        While (Usage[Hi].Count - Pivot < 0) Do Dec(Hi);
        If (Lo <= Hi) Then
        Begin
          T := Usage[Lo];
          Usage[Lo] := Usage[Hi];
          Usage[Hi] := T;
          inc(Lo);
          Dec(Hi);
        End;
      Until (Lo > Hi);
      If (iLo < Hi) Then
        QuickSort(iLo, Hi);
      iLo := Lo;
    Until (Lo >= iHi);
  End;

Begin
  If (FCount <= 1) Then
  Begin
    Result := False;
    Exit;
  End;

  FOptimized := True;
  Result := True;

  BuildHistogram(Usage);

  (*
  **  Sort according to usage count
  *)
  QuickSort(0, FCount - 1);

  (*
  ** Test for table already sorted
  *)
  For i := 0 To FCount - 1 Do
    If (Usage[i].Index <> i) Then
      Break;
  If (i = FCount) Then
    Exit;

  (*
  ** Build old to new map
  *)
  For i := 0 To FCount - 1 Do
    ReverseMap[Usage[i].Index] := i;


  MapImages(ReverseMap);

  (*
  **  Reorder colormap
  *)
  LastFound := False;
  NewCount := FCount;
  Move(FColorMap^, TempMap, FCount * SizeOf(TGIFColor));
  For i := 0 To FCount - 1 Do
  Begin
    FColorMap^[ReverseMap[i]] := TempMap[i];
    // Find last used color index
    If (Usage[i].Count = 0) And Not (LastFound) Then
    Begin
      LastFound := True;
      NewCount := i;
    End;
  End;

  FCount := NewCount;

  Changed;
End;

Function TGIFColorMap.GetBitsPerPixel: integer;
Begin
  Result := Colors2bpp(FCount);
End;

//: Copies one color map to another.
Procedure TGIFColorMap.Assign(Source: TPersistent);
Begin
  If (Source Is TGIFColorMap) Then
  Begin
    Clear;
    FCapacity := TGIFColorMap(Source).FCapacity;
    FCount := TGIFColorMap(Source).FCount;
    FOptimized := TGIFColorMap(Source).FOptimized;
    FColorMap := AllocMem(FCapacity * SizeOf(TGIFColor));
    System.Move(TGIFColorMap(Source).FColorMap^, FColorMap^, FCount * SizeOf(TGIFColor));
    Changed;
  End Else
    Inherited Assign(Source);
End;

////////////////////////////////////////////////////////////////////////////////
//
//			TGIFItem
//
////////////////////////////////////////////////////////////////////////////////
Constructor TGIFItem.Create(GIFImage: TGIFImage);
Begin
  Inherited Create;

  FGIFImage := GIFImage;
End;

Procedure TGIFItem.Warning(Severity: TGIFSeverity; Message: String);
Begin
  FGIFImage.Warning(self, Severity, Message);
End;

Function TGIFItem.GetVersion: TGIFVersion;
Begin
  Result := gv87a;
End;

Procedure TGIFItem.LoadFromFile(Const Filename: String);
Var
  Stream: TStream;
Begin
  Stream := TFileStream.Create(Filename, fmOpenRead Or fmShareDenyWrite);
  Try
    LoadFromStream(Stream);
  Finally
    Stream.Free;
  End;
End;

Procedure TGIFItem.SaveToFile(Const Filename: String);
Var
  Stream: TStream;
Begin
  Stream := TFileStream.Create(Filename, fmCreate);
  Try
    SaveToStream(Stream);
  Finally
    Stream.Free;
  End;
End;

////////////////////////////////////////////////////////////////////////////////
//
//			TGIFList
//
////////////////////////////////////////////////////////////////////////////////
Constructor TGIFList.Create(Image: TGIFImage);
Begin
  Inherited Create;
  FImage := Image;
  FItems := TList.Create;
End;

Destructor TGIFList.Destroy;
Begin
  Clear;
  FItems.Free;
  Inherited Destroy;
End;

Function TGIFList.GetItem(Index: integer): TGIFItem;
Begin
  Result := TGIFItem(FItems[Index]);
End;

Procedure TGIFList.SetItem(Index: integer; Item: TGIFItem);
Begin
  FItems[Index] := Item;
End;

Function TGIFList.GetCount: integer;
Begin
  Result := FItems.Count;
End;

Function TGIFList.Add(Item: TGIFItem): integer;
Begin
  Result := FItems.Add(Item);
End;

Procedure TGIFList.Clear;
Begin
  While (FItems.Count > 0) Do
    Delete(0);
End;

Procedure TGIFList.Delete(Index: integer);
Var
  Item: TGIFItem;
Begin
  Item := TGIFItem(FItems[Index]);
  // Delete before item is destroyed to avoid recursion
  FItems.Delete(Index);
  Item.Free;
End;

Procedure TGIFList.Exchange(Index1, Index2: integer);
Begin
  FItems.Exchange(Index1, Index2);
End;

Function TGIFList.First: TGIFItem;
Begin
  Result := TGIFItem(FItems.First);
End;

Function TGIFList.IndexOf(Item: TGIFItem): integer;
Begin
  Result := FItems.IndexOf(Item);
End;

Procedure TGIFList.Insert(Index: integer; Item: TGIFItem);
Begin
  FItems.Insert(Index, Item);
End;

Function TGIFList.Last: TGIFItem;
Begin
  Result := TGIFItem(FItems.Last);
End;

Procedure TGIFList.Move(CurIndex, NewIndex: integer);
Begin
  FItems.Move(CurIndex, NewIndex);
End;

Function TGIFList.Remove(Item: TGIFItem): integer;
Begin
  // Note: TGIFList.Remove must not destroy item
  Result := FItems.Remove(Item);
End;

Procedure TGIFList.SaveToStream(Stream: TStream);
Var
  i: integer;
Begin
  For i := 0 To FItems.Count - 1 Do
    TGIFItem(FItems[i]).SaveToStream(Stream);
End;

Procedure TGIFList.Warning(Severity: TGIFSeverity; Message: String);
Begin
  Image.Warning(self, Severity, Message);
End;

////////////////////////////////////////////////////////////////////////////////
//
//			TGIFGlobalColorMap
//
////////////////////////////////////////////////////////////////////////////////
Type
  TGIFGlobalColorMap = Class(TGIFColorMap)
  Private
    FHeader: TGIFHeader;
  Protected
    Procedure Warning(Severity: TGIFSeverity; Message: String); Override;
    Procedure BuildHistogram(Var Histogram: TColormapHistogram); Override;
    Procedure MapImages(Var Map: TColormapReverse); Override;
  Public
    Constructor Create(HeaderItem: TGIFHeader);
    Function Optimize: Boolean; Override;
    Procedure Changed; Override;
  End;

Constructor TGIFGlobalColorMap.Create(HeaderItem: TGIFHeader);
Begin
  Inherited Create;
  FHeader := HeaderItem;
End;

Procedure TGIFGlobalColorMap.Warning(Severity: TGIFSeverity; Message: String);
Begin
  FHeader.Image.Warning(self, Severity, Message);
End;

Procedure TGIFGlobalColorMap.BuildHistogram(Var Histogram: TColormapHistogram);
Var
  Pixel,
    LastPixel: PChar;
  i: integer;
Begin
  (*
  ** Init histogram
  *)
  For i := 0 To Count - 1 Do
  Begin
    Histogram[i].Index := i;
    Histogram[i].Count := 0;
  End;

  For i := 0 To FHeader.Image.Images.Count - 1 Do
    If (FHeader.Image.Images[i].ActiveColorMap = self) Then
    Begin
      Pixel := FHeader.Image.Images[i].Data;
      LastPixel := Pixel + FHeader.Image.Images[i].Width * FHeader.Image.Images[i].Height;

      (*
      ** Sum up usage count for each color
      *)
      While (Pixel < LastPixel) Do
      Begin
        inc(Histogram[Ord(Pixel^)].Count);
        inc(Pixel);
      End;
    End;
End;

Procedure TGIFGlobalColorMap.MapImages(Var Map: TColormapReverse);
Var
  Pixel,
    LastPixel: PChar;
  i: integer;
Begin
  For i := 0 To FHeader.Image.Images.Count - 1 Do
    If (FHeader.Image.Images[i].ActiveColorMap = self) Then
    Begin
      Pixel := FHeader.Image.Images[i].Data;
      LastPixel := Pixel + FHeader.Image.Images[i].Width * FHeader.Image.Images[i].Height;

      (*
      **  Reorder all pixel to new map
      *)
      While (Pixel < LastPixel) Do
      Begin
        Pixel^ := Chr(Map[Ord(Pixel^)]);
        inc(Pixel);
      End;

      (*
      **  Reorder transparent colors
      *)
      If (FHeader.Image.Images[i].Transparent) Then
        FHeader.Image.Images[i].GraphicControlExtension.TransparentColorIndex :=
          Map[FHeader.Image.Images[i].GraphicControlExtension.TransparentColorIndex];
    End;
End;

Function TGIFGlobalColorMap.Optimize: Boolean;
Begin
  { Optimize with first image, Remove unused colors if only one image }
  If (FHeader.Image.Images.Count > 0) Then
    Result := DoOptimize
  Else
    Result := False;
End;

Procedure TGIFGlobalColorMap.Changed;
Begin
  FHeader.Image.Palette := 0;
End;

////////////////////////////////////////////////////////////////////////////////
//
//			TGIFHeader
//
////////////////////////////////////////////////////////////////////////////////
Constructor TGIFHeader.Create(GIFImage: TGIFImage);
Begin
  Inherited Create(GIFImage);
  FColorMap := TGIFGlobalColorMap.Create(self);
  Clear;
End;

Destructor TGIFHeader.Destroy;
Begin
  FColorMap.Free;
  Inherited Destroy;
End;

Procedure TGIFHeader.Clear;
Begin
  FColorMap.Clear;
  FLogicalScreenDescriptor.ScreenWidth := 0;
  FLogicalScreenDescriptor.ScreenHeight := 0;
  FLogicalScreenDescriptor.PackedFields := 0;
  FLogicalScreenDescriptor.BackgroundColorIndex := 0;
  FLogicalScreenDescriptor.AspectRatio := 0;
End;

Procedure TGIFHeader.Assign(Source: TPersistent);
Begin
  If (Source Is TGIFHeader) Then
  Begin
    ColorMap.Assign(TGIFHeader(Source).ColorMap);
    FLogicalScreenDescriptor := TGIFHeader(Source).FLogicalScreenDescriptor;
  End Else
    If (Source Is TGIFColorMap) Then
    Begin
      Clear;
      ColorMap.Assign(TGIFColorMap(Source));
    End Else
      Inherited Assign(Source);
End;

Type
  TGIFHeaderRec = Packed Record
    Signature: Array[0..2] Of char; { contains 'GIF' }
    Version: TGIFVersionRec; { '87a' or '89a' }
  End;

Const
  { logical screen descriptor packed field masks }
  lsdGlobalColorTable = $80; { set if global color table follows L.S.D. }
  lsdColorResolution = $70; { Color resolution - 3 bits }
  lsdSort = $08; { set if global color table is sorted - 1 bit }
  lsdColorTableSize = $07; { size of global color table - 3 bits }
       { Actual size = 2^value+1    - value is 3 bits }
Procedure TGIFHeader.Prepare;
Var
  Pack: Byte;
Begin
  Pack := $00;
  If (ColorMap.Count > 0) Then
  Begin
    Pack := lsdGlobalColorTable;
    If (ColorMap.Optimized) Then
      Pack := Pack Or lsdSort;
  End;
  // Note: The SHL below was SHL 5 in the original source, but that looks wrong
  Pack := Pack Or ((Image.ColorResolution Shl 4) And lsdColorResolution);
  Pack := Pack Or ((Image.BitsPerPixel - 1) And lsdColorTableSize);
  FLogicalScreenDescriptor.PackedFields := Pack;
End;

Procedure TGIFHeader.SaveToStream(Stream: TStream);
Var
  GifHeader: TGIFHeaderRec;
  v: TGIFVersion;
Begin
  v := Image.Version;
  If (v = gvUnknown) Then
    Error(sBadVersion);

  GifHeader.Signature := 'GIF';
  GifHeader.Version := GIFVersions[v];

  Prepare;
  Stream.Write(GifHeader, SizeOf(GifHeader));
  Stream.Write(FLogicalScreenDescriptor, SizeOf(FLogicalScreenDescriptor));
  If (FLogicalScreenDescriptor.PackedFields And lsdGlobalColorTable = lsdGlobalColorTable) Then
    ColorMap.SaveToStream(Stream);
End;

Procedure TGIFHeader.LoadFromStream(Stream: TStream);
Var
  GifHeader: TGIFHeaderRec;
  ColorCount: integer;
  Position: integer;
Begin
  Position := Stream.Position;

  ReadCheck(Stream, GifHeader, SizeOf(GifHeader));
  If (UpperCase(GifHeader.Signature) <> 'GIF') Then
  Begin
    // Attempt recovery in case we are reading a GIF stored in a form by rxLib
    Stream.Position := Position;
    // Seek past size stored in stream
    Stream.Seek(SizeOf(longInt), soFromCurrent);
    // Attempt to read signature again
    ReadCheck(Stream, GifHeader, SizeOf(GifHeader));
    If (UpperCase(GifHeader.Signature) <> 'GIF') Then
      Error(sBadSignature);
  End;

  ReadCheck(Stream, FLogicalScreenDescriptor, SizeOf(FLogicalScreenDescriptor));

  If (FLogicalScreenDescriptor.PackedFields And lsdGlobalColorTable = lsdGlobalColorTable) Then
  Begin
    ColorCount := 2 Shl (FLogicalScreenDescriptor.PackedFields And lsdColorTableSize);
    If (ColorCount < 2) Or (ColorCount > 256) Then
      Error(sScreenBadColorSize);
    ColorMap.LoadFromStream(Stream, ColorCount)
  End Else
    ColorMap.Clear;
End;

Function TGIFHeader.GetVersion: TGIFVersion;
Begin
  If (FColorMap.Optimized) Or (AspectRatio <> 0) Then
    Result := gv89a
  Else
    Result := Inherited GetVersion;
End;

Function TGIFHeader.GetBackgroundColor: TColor;
Begin
  Result := FColorMap[BackgroundColorIndex];
End;

Procedure TGIFHeader.SetBackgroundColor(Color: TColor);
Begin
  BackgroundColorIndex := FColorMap.AddUnique(Color);
End;

Procedure TGIFHeader.SetBackgroundColorIndex(Index: Byte);
Begin
  If ((Index >= FColorMap.Count) And (FColorMap.Count > 0)) Then
  Begin
    Warning(gsWarning, sBadColorIndex);
    Index := 0;
  End;
  FLogicalScreenDescriptor.BackgroundColorIndex := Index;
End;

Function TGIFHeader.GetBitsPerPixel: integer;
Begin
  Result := FColorMap.BitsPerPixel;
End;

Function TGIFHeader.GetColorResolution: integer;
Begin
  Result := FColorMap.BitsPerPixel - 1;
End;

////////////////////////////////////////////////////////////////////////////////
//
//			TGIFLocalColorMap
//
////////////////////////////////////////////////////////////////////////////////
Type
  TGIFLocalColorMap = Class(TGIFColorMap)
  Private
    FSubImage: TGIFSubImage;
  Protected
    Procedure Warning(Severity: TGIFSeverity; Message: String); Override;
    Procedure BuildHistogram(Var Histogram: TColormapHistogram); Override;
    Procedure MapImages(Var Map: TColormapReverse); Override;
  Public
    Constructor Create(SubImage: TGIFSubImage);
    Function Optimize: Boolean; Override;
    Procedure Changed; Override;
  End;

Constructor TGIFLocalColorMap.Create(SubImage: TGIFSubImage);
Begin
  Inherited Create;
  FSubImage := SubImage;
End;

Procedure TGIFLocalColorMap.Warning(Severity: TGIFSeverity; Message: String);
Begin
  FSubImage.Image.Warning(self, Severity, Message);
End;

Procedure TGIFLocalColorMap.BuildHistogram(Var Histogram: TColormapHistogram);
Var
  Pixel,
    LastPixel: PChar;
  i: integer;
Begin
  Pixel := FSubImage.Data;
  LastPixel := Pixel + FSubImage.Width * FSubImage.Height;

  (*
  ** Init histogram
  *)
  For i := 0 To Count - 1 Do
  Begin
    Histogram[i].Index := i;
    Histogram[i].Count := 0;
  End;

  (*
  ** Sum up usage count for each color
  *)
  While (Pixel < LastPixel) Do
  Begin
    inc(Histogram[Ord(Pixel^)].Count);
    inc(Pixel);
  End;
End;

Procedure TGIFLocalColorMap.MapImages(Var Map: TColormapReverse);
Var
  Pixel,
    LastPixel: PChar;
Begin
  Pixel := FSubImage.Data;
  LastPixel := Pixel + FSubImage.Width * FSubImage.Height;

  (*
  **  Reorder all pixel to new map
  *)
  While (Pixel < LastPixel) Do
  Begin
    Pixel^ := Chr(Map[Ord(Pixel^)]);
    inc(Pixel);
  End;

  (*
  **  Reorder transparent colors
  *)
  If (FSubImage.Transparent) Then
    FSubImage.GraphicControlExtension.TransparentColorIndex :=
      Map[FSubImage.GraphicControlExtension.TransparentColorIndex];
End;

Function TGIFLocalColorMap.Optimize: Boolean;
Begin
  Result := DoOptimize;
End;

Procedure TGIFLocalColorMap.Changed;
Begin
  FSubImage.Palette := 0;
End;


////////////////////////////////////////////////////////////////////////////////
//
//			LZW Decoder
//
////////////////////////////////////////////////////////////////////////////////
Const
  GIFCodeBits = 12; // Max number of bits per GIF token code
  GIFCodeMax = (1 Shl GIFCodeBits) - 1; // Max GIF token code
        // 12 bits = 4095
  StackSize = (2 Shl GIFCodeBits); // Size of decompression stack
  TableSize = (1 Shl GIFCodeBits); // Size of decompression table

Procedure TGIFSubImage.Decompress(Stream: TStream);
Var
  table0: Array[0..TableSize - 1] Of integer;
  table1: Array[0..TableSize - 1] Of integer;
  firstcode, oldcode: integer;
  Buf: Array[0..257] Of Byte;

  Dest: PChar;
  v,
    xpos, ypos, pass: integer;

  stack: Array[0..StackSize - 1] Of integer;
  Source: ^integer;
  BitsPerCode: integer; // number of CodeTableBits/code
  InitialBitsPerCode: Byte;

  MaxCode: integer; // maximum code, given BitsPerCode
  MaxCodeSize: integer;
  ClearCode: integer; // Special code to signal "Clear table"
  EOFCode: integer; // Special code to signal EOF
  step: integer;
  i: integer;

  StartBit, // Index of bit buffer start
    LastBit, // Index of last bit in buffer
    LastByte: integer; // Index of last byte in buffer
  get_done,
    return_clear,
    ZeroBlock: Boolean;
  ClearValue: Byte;
{$IFDEF DEBUG_DECOMPRESSPERFORMANCE}
  TimeStartDecompress,
    TimeStopDecompress: DWORD;
{$ENDIF}

  Function nextCode(BitsPerCode: integer): integer;
  Const
    masks: Array[0..15] Of integer =
    ($0000, $0001, $0003, $0007,
      $000F, $001F, $003F, $007F,
      $00FF, $01FF, $03FF, $07FF,
      $0FFF, $1FFF, $3FFF, $7FFF);
  Var
    StartIndex, EndIndex: integer;
    ret: integer;
    EndBit: integer;
    Count: Byte;
  Begin
    If (return_clear) Then
    Begin
      return_clear := False;
      Result := ClearCode;
      Exit;
    End;

    EndBit := StartBit + BitsPerCode;

    If (EndBit >= LastBit) Then
    Begin
      If (get_done) Then
      Begin
        If (StartBit >= LastBit) Then
          Warning(gsWarning, sDecodeTooFewBits);
        Result := -1;
        Exit;
      End;
      Buf[0] := Buf[LastByte - 2];
      Buf[1] := Buf[LastByte - 1];

      If (Stream.Read(Count, 1) <> 1) Then
      Begin
        Result := -1;
        Exit;
      End;
      If (Count = 0) Then
      Begin
        ZeroBlock := True;
        get_done := True;
      End Else
      Begin
        // Handle premature end of file
        If (Stream.Size - Stream.Position < Count) Then
        Begin
          Warning(gsWarning, sOutOfData);
          // Not enough data left - Just read as much as we can get
          Count := Stream.Size - Stream.Position;
        End;
        If (Count <> 0) Then
          ReadCheck(Stream, Buf[2], Count);
      End;

      LastByte := 2 + Count;
      StartBit := (StartBit - LastBit) + 16;
      LastBit := LastByte * 8;

      EndBit := StartBit + BitsPerCode;
    End;

    EndIndex := EndBit Div 8;
    StartIndex := StartBit Div 8;

    ASSERT(StartIndex <= High(Buf), 'StartIndex too large');
    If (StartIndex = EndIndex) Then
      ret := Buf[StartIndex]
    Else
      If (StartIndex + 1 = EndIndex) Then
        ret := Buf[StartIndex] Or (Buf[StartIndex + 1] Shl 8)
      Else
        ret := Buf[StartIndex] Or (Buf[StartIndex + 1] Shl 8) Or (Buf[StartIndex + 2] Shl 16);

    ret := (ret Shr (StartBit And $0007)) And masks[BitsPerCode];

    inc(StartBit, BitsPerCode);

    Result := ret;
  End;

  Function NextLZW: integer;
  Var
    code, incode: integer;
    i: integer;
    b: Byte;
  Begin
    code := nextCode(BitsPerCode);
    While (code >= 0) Do
    Begin
      If (code = ClearCode) Then
      Begin
        ASSERT(ClearCode < TableSize, 'ClearCode too large');
        For i := 0 To ClearCode - 1 Do
        Begin
          table0[i] := 0;
          table1[i] := i;
        End;
        For i := ClearCode To TableSize - 1 Do
        Begin
          table0[i] := 0;
          table1[i] := 0;
        End;
        BitsPerCode := InitialBitsPerCode + 1;
        MaxCodeSize := 2 * ClearCode;
        MaxCode := ClearCode + 2;
        Source := @stack;
        Repeat
          firstcode := nextCode(BitsPerCode);
          oldcode := firstcode;
        Until (firstcode <> ClearCode);

        Result := firstcode;
        Exit;
      End;
      If (code = EOFCode) Then
      Begin
        Result := -2;
        If (ZeroBlock) Then
          Exit;
        // Eat rest of data blocks
        If (Stream.Read(b, 1) <> 1) Then
          Exit;
        While (b <> 0) Do
        Begin
          Stream.Seek(b, soFromCurrent);
          If (Stream.Read(b, 1) <> 1) Then
            Exit;
        End;
        Exit;
      End;

      incode := code;

      If (code >= MaxCode) Then
      Begin
        Source^ := firstcode;
        inc(Source);
        code := oldcode;
      End;

      ASSERT(code < TableSize, 'Code too large');
      While (code >= ClearCode) Do
      Begin
        Source^ := table1[code];
        inc(Source);
        If (code = table0[code]) Then
          Error(sDecodeCircular);
        code := table0[code];
        ASSERT(code < TableSize, 'Code too large');
      End;

      firstcode := table1[code];
      Source^ := firstcode;
      inc(Source);

      code := MaxCode;
      If (code <= GIFCodeMax) Then
      Begin
        table0[code] := oldcode;
        table1[code] := firstcode;
        inc(MaxCode);
        If ((MaxCode >= MaxCodeSize) And (MaxCodeSize <= GIFCodeMax)) Then
        Begin
          MaxCodeSize := MaxCodeSize * 2;
          inc(BitsPerCode);
        End;
      End;

      oldcode := incode;

      If (longInt(Source) > longInt(@stack)) Then
      Begin
        Dec(Source);
        Result := Source^;
        Exit;
      End
    End;
    Result := code;
  End;

  Function readLZW: integer;
  Begin
    If (longInt(Source) > longInt(@stack)) Then
    Begin
      Dec(Source);
      Result := Source^;
    End Else
      Result := NextLZW;
  End;

Begin
  NewImage;

  // Clear image data in case decompress doesn't complete
  If (Transparent) Then
    // Clear to transparent color
    ClearValue := GraphicControlExtension.GetTransparentColorIndex
  Else
    // Clear to first color
    ClearValue := 0;

  FillChar(FData^, FDataSize, ClearValue);

{$IFDEF DEBUG_DECOMPRESSPERFORMANCE}
  TimeStartDecompress := timeGetTime;
{$ENDIF}

  (*
  ** Read initial code size in bits from stream
  *)
  If (Stream.Read(InitialBitsPerCode, 1) <> 1) Then
    Exit;

  (*
  **  Initialize the Compression routines
  *)
  BitsPerCode := InitialBitsPerCode + 1;
  ClearCode := 1 Shl InitialBitsPerCode;
  EOFCode := ClearCode + 1;
  MaxCodeSize := 2 * ClearCode;
  MaxCode := ClearCode + 2;

  StartBit := 0;
  LastBit := 0;
  LastByte := 2;

  ZeroBlock := False;
  get_done := False;
  return_clear := True;

  Source := @stack;

  Try
    If (Interlaced) Then
    Begin
      ypos := 0;
      pass := 0;
      step := 8;

      For i := 0 To Height - 1 Do
      Begin
        Dest := FData + Width * ypos;
        For xpos := 0 To Width - 1 Do
        Begin
          v := readLZW;
          If (v < 0) Then
            Exit;
          Dest^ := char(v);
          inc(Dest);
        End;
        inc(ypos, step);
        If (ypos >= Height) Then
          Repeat
            If (pass > 0) Then
              step := step Div 2;
            inc(pass);
            ypos := step Div 2;
          Until (ypos < Height);
      End;
    End Else
    Begin
      Dest := FData;
      For ypos := 0 To (Height * Width) - 1 Do
      Begin
        v := readLZW;
        If (v < 0) Then
          Exit;
        Dest^ := char(v);
        inc(Dest);
      End;
    End;
  Finally
    If (readLZW >= 0) Then
      ;
//      raise GIFException.Create('Too much input data, ignoring extra...');
  End;
{$IFDEF DEBUG_DECOMPRESSPERFORMANCE}
  TimeStopDecompress := timeGetTime;
  ShowMessage(Format('Decompressed %d pixels in %d mS, Rate %d pixels/mS',
    [Height * Width, TimeStopDecompress - TimeStartDecompress,
    (Height * Width) Div (TimeStopDecompress - TimeStartDecompress + 1)]));
{$ENDIF}
End;

////////////////////////////////////////////////////////////////////////////////
//
//			LZW Encoder stuff
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//			LZW Encoder THashTable
////////////////////////////////////////////////////////////////////////////////
Const
  HashKeyBits = 13; // Max number of bits per Hash Key

  HashSize = 8009; // Size of hash table
        // Must be prime
                                                // Must be > than HashMaxCode
                                                // Must be < than HashMaxKey

  HashKeyMax = (1 Shl HashKeyBits) - 1; // Max hash key value
        // 13 bits = 8191

  HashKeyMask = HashKeyMax; // $1FFF
  GIFCodeMask = GIFCodeMax; // $0FFF

  HashEmpty = $000FFFFF; // 20 bits

Type
  // A Hash Key is 20 bits wide.
  // - The lower 8 bits are the postfix character (the new pixel).
  // - The upper 12 bits are the prefix code (the GIF token).
  // A KeyInt must be able to represent the integer values -1..(2^20)-1
  KeyInt = longInt; // 32 bits
  CodeInt = SmallInt; // 16 bits

  THashArray = Array[0..HashSize - 1] Of KeyInt;
  PHashArray = ^THashArray;

  THashTable = Class
{$IFDEF DEBUG_HASHPERFORMANCE}
    CountLookupFound: longInt;
    CountMissFound: longInt;
    CountLookupNotFound: longInt;
    CountMissNotFound: longInt;
{$ENDIF}
    HashTable: PHashArray;
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Procedure Clear;
    Procedure Insert(Key: KeyInt; code: CodeInt);
    Function Lookup(Key: KeyInt): CodeInt;
  End;

Function HashKey(Key: KeyInt): CodeInt;
Begin
  Result := ((Key Shr (GIFCodeBits - 8)) Xor Key) Mod HashSize;
End;

Function NextHashKey(HKey: CodeInt): CodeInt;
Var
  disp: CodeInt;
Begin
  (*
  ** secondary hash (after G. Knott)
  *)
  disp := HashSize - HKey;
  If (HKey = 0) Then
    disp := 1;
//  disp := 13;		// disp should be prime relative to HashSize, but
   // it doesn't seem to matter here...
  Dec(HKey, disp);
  If (HKey < 0) Then
    inc(HKey, HashSize);
  Result := HKey;
End;


Constructor THashTable.Create;
Begin
  ASSERT(longInt($FFFFFFFF) = -1, 'TGIFImage implementation assumes $FFFFFFFF = -1');

  Inherited Create;
  GetMem(HashTable, SizeOf(THashArray));
  Clear;
{$IFDEF DEBUG_HASHPERFORMANCE}
  CountLookupFound := 0;
  CountMissFound := 0;
  CountLookupNotFound := 0;
  CountMissNotFound := 0;
{$ENDIF}
End;

Destructor THashTable.Destroy;
Begin
{$IFDEF DEBUG_HASHPERFORMANCE}
  ShowMessage(
    Format('Found: %d  HitRate: %.2f',
    [CountLookupFound, (CountLookupFound + 1) / (CountMissFound + 1)]) + #13 +
    Format('Not found: %d  HitRate: %.2f',
    [CountLookupNotFound, (CountLookupNotFound + 1) / (CountMissNotFound + 1)]));
{$ENDIF}
  FreeMem(HashTable);
  Inherited Destroy;
End;

// Clear hash table and fill with empty slots (doh!)
Procedure THashTable.Clear;
{$IFDEF DEBUG_HASHFILLFACTOR}
Var
  i,
    Count: longInt;
{$ENDIF}
Begin
{$IFDEF DEBUG_HASHFILLFACTOR}
  Count := 0;
  For i := 0 To HashSize - 1 Do
    If (HashTable[i] Shr GIFCodeBits <> HashEmpty) Then
      inc(Count);
  ShowMessage(Format('Size: %d, Filled: %d, Rate %.4f',
    [HashSize, Count, Count / HashSize]));
{$ENDIF}

  FillChar(HashTable^, SizeOf(THashArray), $FF);
End;

// Insert new key/value pair into hash table
Procedure THashTable.Insert(Key: KeyInt; code: CodeInt);
Var
  HKey: CodeInt;
Begin
  // Create hash key from prefix string
  HKey := HashKey(Key);

  // Scan for empty slot
  // while (HashTable[HKey] SHR GIFCodeBits <> HashEmpty) do { Unoptimized }
  While (HashTable[HKey] And (HashEmpty Shl GIFCodeBits) <> (HashEmpty Shl GIFCodeBits)) Do { Optimized }
    HKey := NextHashKey(HKey);
  // Fill slot with key/value pair
  HashTable[HKey] := (Key Shl GIFCodeBits) Or (code And GIFCodeMask);
End;

// Search for key in hash table.
// Returns value if found or -1 if not
Function THashTable.Lookup(Key: KeyInt): CodeInt;
Var
  HKey: CodeInt;
  HTKey: KeyInt;
{$IFDEF DEBUG_HASHPERFORMANCE}
  n: longInt;
{$ENDIF}
Begin
  // Create hash key from prefix string
  HKey := HashKey(Key);

{$IFDEF DEBUG_HASHPERFORMANCE}
  n := 0;
{$ENDIF}
  // Scan table for key
  // HTKey := HashTable[HKey] SHR GIFCodeBits; { Unoptimized }
  Key := Key Shl GIFCodeBits; { Optimized }
  HTKey := HashTable[HKey] And (HashEmpty Shl GIFCodeBits); { Optimized }
  // while (HTKey <> HashEmpty) do { Unoptimized }
  While (HTKey <> HashEmpty Shl GIFCodeBits) Do { Optimized }
  Begin
    If (Key = HTKey) Then
    Begin
      // Extract and return value
      Result := HashTable[HKey] And GIFCodeMask;
{$IFDEF DEBUG_HASHPERFORMANCE}
      inc(CountLookupFound);
      inc(CountMissFound, n);
{$ENDIF}
      Exit;
    End;
{$IFDEF DEBUG_HASHPERFORMANCE}
    inc(n);
{$ENDIF}
    // Try next slot
    HKey := NextHashKey(HKey);
    // HTKey := HashTable[HKey] SHR GIFCodeBits; { Unoptimized }
    HTKey := HashTable[HKey] And (HashEmpty Shl GIFCodeBits); { Optimized }
  End;
  // Found empty slot - key doesn't exist
  Result := -1;
{$IFDEF DEBUG_HASHPERFORMANCE}
  inc(CountLookupNotFound);
  inc(CountMissNotFound, n);
{$ENDIF}
End;

////////////////////////////////////////////////////////////////////////////////
//		TGIFStream - Abstract GIF block stream
//
// Descendants from TGIFStream either reads or writes data in blocks
// of up to 255 bytes. These blocks are organized as a leading byte
// containing the number of bytes in the block (exclusing the count
// byte itself), followed by the data (up to 254 bytes of data).
////////////////////////////////////////////////////////////////////////////////
Type
  TGIFStream = Class(TStream)
  Private
    FOnWarning: TGIFWarning;
    FStream: TStream;
    FOnProgress: TNotifyEvent;
    FBuffer: Array[Byte] Of char;
    FBufferCount: integer;

  Protected
    Constructor Create(Stream: TStream);

    Function Read(Var Buffer; Count: longInt): longInt; Override;
    Function Write(Const Buffer; Count: longInt): longInt; Override;
    Function Seek(Offset: longInt; Origin: Word): longInt; Override;

    Procedure Progress(Sender: TObject); Dynamic;
    Property OnProgress: TNotifyEvent Read FOnProgress Write FOnProgress;
  Public
    Property Warning: TGIFWarning Read FOnWarning Write FOnWarning;
  End;

Constructor TGIFStream.Create(Stream: TStream);
Begin
  Inherited Create;
  FStream := Stream;
  FBufferCount := 1; // Reserve first byte of buffer for length
End;

Procedure TGIFStream.Progress(Sender: TObject);
Begin
  If Assigned(FOnProgress) Then
    FOnProgress(Sender);
End;

Function TGIFStream.Write(Const Buffer; Count: longInt): longInt;
Begin
  Raise Exception.Create(sInvalidStream);
End;

Function TGIFStream.Read(Var Buffer; Count: longInt): longInt;
Begin
  Raise Exception.Create(sInvalidStream);
End;

Function TGIFStream.Seek(Offset: longInt; Origin: Word): longInt;
Begin
  Raise Exception.Create(sInvalidStream);
End;

////////////////////////////////////////////////////////////////////////////////
//		TGIFReader - GIF block reader
////////////////////////////////////////////////////////////////////////////////
Type
  TGIFReader = Class(TGIFStream)
  Public
    Constructor Create(Stream: TStream);

    Function Read(Var Buffer; Count: longInt): longInt; Override;
  End;

Constructor TGIFReader.Create(Stream: TStream);
Begin
  Inherited Create(Stream);
  FBufferCount := 0;
End;

Function TGIFReader.Read(Var Buffer; Count: longInt): longInt;
Var
  n: integer;
  Dst: PChar;
  Size: Byte;
Begin
  Dst := @Buffer;
  Result := 0;

  While (Count > 0) Do
  Begin
    // Get data from buffer
    While (FBufferCount > 0) And (Count > 0) Do
    Begin
      If (FBufferCount > Count) Then
        n := Count
      Else
        n := FBufferCount;
      Move(FBuffer, Dst^, n);
      Dec(FBufferCount, n);
      Dec(Count, n);
      inc(Result, n);
      inc(Dst, n);
    End;

    // Refill buffer when it becomes empty
    If (FBufferCount <= 0) Then
    Begin
      FStream.Read(Size, 1);
      { TODO -oanme -cImprovement : Should be handled as a warning instead of an error. }
      If (Size >= 255) Then
        Error('GIF block too large');
      FBufferCount := Size;
      If (FBufferCount > 0) Then
      Begin
        n := FStream.Read(FBuffer, Size);
        If (n = FBufferCount) Then
        Begin
          Warning(self, gsWarning, sOutOfData);
          Break;
        End;
      End Else
        Break;
    End;
  End;
End;

////////////////////////////////////////////////////////////////////////////////
//		TGIFWriter - GIF block writer
////////////////////////////////////////////////////////////////////////////////
Type
  TGIFWriter = Class(TGIFStream)
  Private
    FOutputDirty: Boolean;

  Protected
    Procedure FlushBuffer;

  Public
    Constructor Create(Stream: TStream);
    Destructor Destroy; Override;

    Function Write(Const Buffer; Count: longInt): longInt; Override;
    Function WriteByte(Value: Byte): longInt;
  End;

Constructor TGIFWriter.Create(Stream: TStream);
Begin
  Inherited Create(Stream);
  FBufferCount := 1; // Reserve first byte of buffer for length
  FOutputDirty := False;
End;

Destructor TGIFWriter.Destroy;
Begin
  Inherited Destroy;
  If (FOutputDirty) Then
    FlushBuffer;
End;

Procedure TGIFWriter.FlushBuffer;
Begin
  If (FBufferCount <= 0) Then
    Exit;

  FBuffer[0] := char(FBufferCount - 1); // Block size excluding the count
  FStream.WriteBuffer(FBuffer, FBufferCount);
  FBufferCount := 1; // Reserve first byte of buffer for length
  FOutputDirty := False;
End;

Function TGIFWriter.Write(Const Buffer; Count: longInt): longInt;
Var
  n: integer;
  Src: PChar;
Begin
  Result := Count;
  FOutputDirty := True;
  Src := @Buffer;
  While (Count > 0) Do
  Begin
    // Move data to the internal buffer in 255 byte chunks
    While (FBufferCount < SizeOf(FBuffer)) And (Count > 0) Do
    Begin
      n := SizeOf(FBuffer) - FBufferCount;
      If (n > Count) Then
        n := Count;
      Move(Src^, FBuffer[FBufferCount], n);
      inc(Src, n);
      inc(FBufferCount, n);
      Dec(Count, n);
    End;

    // Flush the buffer when it is full
    If (FBufferCount >= SizeOf(FBuffer)) Then
      FlushBuffer;
  End;
End;

Function TGIFWriter.WriteByte(Value: Byte): longInt;
Begin
  Result := Write(Value, 1);
End;

////////////////////////////////////////////////////////////////////////////////
//		TGIFEncoder - Abstract encoder
////////////////////////////////////////////////////////////////////////////////
Type
  TGIFEncoder = Class(TObject)
  Protected
    FOnWarning: TGIFWarning;
    MaxColor: integer;
    BitsPerPixel: Byte; // Bits per pixel of image
    Stream: TStream; // Output stream
    Width, // Width of image in pixels
      Height: integer; // height of image in pixels
    Interlace: Boolean; // Interlace flag (True = interlaced image)
    Data: PChar; // Pointer to pixel data
    GIFStream: TGIFWriter; // Output buffer

    OutputBucket: longInt; // Output bit bucket
    OutputBits: integer; // Current # of bits in bucket

    ClearFlag: Boolean; // True if dictionary has just been cleared
    BitsPerCode, // Current # of bits per code
      InitialBitsPerCode: integer; // Initial # of bits per code after
       // dictionary has been cleared
    MaxCode: CodeInt; // maximum code, given BitsPerCode
    ClearCode: CodeInt; // Special output code to signal "Clear table"
    EOFCode: CodeInt; // Special output code to signal EOF
    BaseCode: CodeInt; // ...

    Pixel: PChar; // Pointer to current pixel

    cX, // Current X counter (Width - X)
      y: integer; // Current Y
    pass: integer; // Interlace pass

    Function MaxCodesFromBits(Bits: integer): CodeInt;
    Procedure Output(Value: integer); Virtual;
    Procedure Clear; Virtual;
    Function BumpPixel: Boolean;
    Procedure DoCompress; Virtual; Abstract;
  Public
    Procedure Compress(AStream: TStream; ABitsPerPixel: integer;
      AWidth, AHeight: integer; AInterlace: Boolean; AData: PChar; AMaxColor: integer);
    Property Warning: TGIFWarning Read FOnWarning Write FOnWarning;
  End;

// Calculate the maximum number of codes that a given number of bits can represent
// MaxCodes := (1^bits)-1
Function TGIFEncoder.MaxCodesFromBits(Bits: integer): CodeInt;
Begin
  Result := (CodeInt(1) Shl Bits) - 1;
End;

// Stuff bits (variable sized codes) into a buffer and output them
// a byte at a time
Procedure TGIFEncoder.Output(Value: integer);
Const
  BitBucketMask: Array[0..16] Of longInt =
  ($0000,
    $0001, $0003, $0007, $000F,
    $001F, $003F, $007F, $00FF,
    $01FF, $03FF, $07FF, $0FFF,
    $1FFF, $3FFF, $7FFF, $FFFF);
Begin
  If (OutputBits > 0) Then
    OutputBucket :=
      (OutputBucket And BitBucketMask[OutputBits]) Or (longInt(Value) Shl OutputBits)
  Else
    OutputBucket := Value;

  inc(OutputBits, BitsPerCode);

  While (OutputBits >= 8) Do
  Begin
    GIFStream.WriteByte(OutputBucket And $FF);
    OutputBucket := OutputBucket Shr 8;
    Dec(OutputBits, 8);
  End;

  If (Value = EOFCode) Then
  Begin
    // At EOF, write the rest of the buffer.
    While (OutputBits > 0) Do
    Begin
      GIFStream.WriteByte(OutputBucket And $FF);
      OutputBucket := OutputBucket Shr 8;
      Dec(OutputBits, 8);
    End;
  End;
End;

Procedure TGIFEncoder.Clear;
Begin
  // just_cleared = 1;
  ClearFlag := True;
  Output(ClearCode);
End;

// Bump (X,Y) and data pointer to point to the next pixel
Function TGIFEncoder.BumpPixel: Boolean;
Begin
  // Bump the current X position
  Dec(cX);

  // If we are at the end of a scan line, set cX back to the beginning
  // If we are interlaced, bump Y to the appropriate spot, otherwise,
  // just increment it.
  If (cX <= 0) Then
  Begin

    If Not (Interlace) Then
    Begin
      // Done - no more data
      Result := False;
      Exit;
    End;

    cX := Width;
    Case (pass) Of
      0:
        Begin
          inc(y, 8);
          If (y >= Height) Then
          Begin
            inc(pass);
            y := 4;
          End;
        End;
      1:
        Begin
          inc(y, 8);
          If (y >= Height) Then
          Begin
            inc(pass);
            y := 2;
          End;
        End;
      2:
        Begin
          inc(y, 4);
          If (y >= Height) Then
          Begin
            inc(pass);
            y := 1;
          End;
        End;
      3:
        inc(y, 2);
    End;

    If (y >= Height) Then
    Begin
      // Done - No more data
      Result := False;
      Exit;
    End;
    Pixel := Data + (y * Width);
  End;
  Result := True;
End;


Procedure TGIFEncoder.Compress(AStream: TStream; ABitsPerPixel: integer;
  AWidth, AHeight: integer; AInterlace: Boolean; AData: PChar; AMaxColor: integer);
Const
  EndBlockByte = $00; // End of block marker
{$IFDEF DEBUG_COMPRESSPERFORMANCE}
Var
  TimeStartCompress,
    TimeStopCompress: DWORD;
{$ENDIF}
Begin
  MaxColor := AMaxColor;
  Stream := AStream;
  BitsPerPixel := ABitsPerPixel;
  Width := AWidth;
  Height := AHeight;
  Interlace := AInterlace;
  Data := AData;

  If (BitsPerPixel <= 1) Then
    BitsPerPixel := 2;

  InitialBitsPerCode := BitsPerPixel + 1;
  Stream.Write(BitsPerPixel, 1);

  // out_bits_init = init_bits;
  BitsPerCode := InitialBitsPerCode;
  MaxCode := MaxCodesFromBits(BitsPerCode);

  ClearCode := (1 Shl (InitialBitsPerCode - 1));
  EOFCode := ClearCode + 1;
  BaseCode := EOFCode + 1;

  // Clear bit bucket
  OutputBucket := 0;
  OutputBits := 0;

  // Reset pixel counter
  If (Interlace) Then
    cX := Width
  Else
    cX := Width * Height;
  // Reset row counter
  y := 0;
  pass := 0;

  GIFStream := TGIFWriter.Create(AStream);
  Try
    GIFStream.Warning := Warning;
    If (Data <> Nil) And (Height > 0) And (Width > 0) Then
    Begin
{$IFDEF DEBUG_COMPRESSPERFORMANCE}
      TimeStartCompress := timeGetTime;
{$ENDIF}

      // Call compress implementation
      DoCompress;

{$IFDEF DEBUG_COMPRESSPERFORMANCE}
      TimeStopCompress := timeGetTime;
      ShowMessage(Format('Compressed %d pixels in %d mS, Rate %d pixels/mS',
        [Height * Width, TimeStopCompress - TimeStartCompress,
        DWORD(Height * Width) Div (TimeStopCompress - TimeStartCompress + 1)]));
{$ENDIF}
      // Output the final code.
      Output(EOFCode);
    End Else
      // Output the final code (and nothing else).
      TGIFEncoder(self).Output(EOFCode);
  Finally
    GIFStream.Free;
  End;

  WriteByte(Stream, EndBlockByte);
End;

////////////////////////////////////////////////////////////////////////////////
//		TRLEEncoder - RLE encoder
////////////////////////////////////////////////////////////////////////////////
Type
  TRLEEncoder = Class(TGIFEncoder)
  Private
    MaxCodes: integer;
    OutBumpInit,
      OutClearInit: integer;
    Prefix: integer; // Current run color
    RunLengthTableMax,
      RunLengthTablePixel,
      OutCount,
      OutClear,
      OutBump: integer;
  Protected
    Function ComputeTriangleCount(Count: integer; nrepcodes: integer): integer;
    Procedure MaxOutClear;
    Procedure ResetOutClear;
    Procedure FlushFromClear(Count: integer);
    Procedure FlushClearOrRepeat(Count: integer);
    Procedure FlushWithTable(Count: integer);
    Procedure Flush(RunLengthCount: integer);
    Procedure OutputPlain(Value: integer);
    Procedure Clear; Override;
    Procedure DoCompress; Override;
  End;


Procedure TRLEEncoder.Clear;
Begin
  OutBump := OutBumpInit;
  OutClear := OutClearInit;
  OutCount := 0;
  RunLengthTableMax := 0;

  Inherited Clear;

  BitsPerCode := InitialBitsPerCode;
End;

Procedure TRLEEncoder.OutputPlain(Value: integer);
Begin
  ClearFlag := False;
  Output(Value);
  inc(OutCount);

  If (OutCount >= OutBump) Then
  Begin
    inc(BitsPerCode);
    inc(OutBump, 1 Shl (BitsPerCode - 1));
  End;

  If (OutCount >= OutClear) Then
    Clear;
End;

Function TRLEEncoder.ComputeTriangleCount(Count: integer; nrepcodes: integer): integer;
Var
  PerRepeat: integer;
  n: integer;

  Function iSqrt(x: integer): integer;
  Var
    R, v: integer;
  Begin
    If (x < 2) Then
    Begin
      Result := x;
      Exit;
    End Else
    Begin
      v := x;
      R := 1;
      While (v > 0) Do
      Begin
        v := v Div 4;
        R := R * 2;
      End;
    End;

    While (True) Do
    Begin
      v := ((x Div R) + R) Div 2;
      If ((v = R) Or (v = R + 1)) Then
      Begin
        Result := R;
        Exit;
      End;
      R := v;
    End;
  End;

Begin
  Result := 0;
  PerRepeat := (nrepcodes * (nrepcodes + 1)) Div 2;

  While (Count >= PerRepeat) Do
  Begin
    inc(Result, nrepcodes);
    Dec(Count, PerRepeat);
  End;

  If (Count > 0) Then
  Begin
    n := iSqrt(Count);
    While ((n * (n + 1)) >= 2 * Count) Do
      Dec(n);
    While ((n * (n + 1)) < 2 * Count) Do
      inc(n);
    inc(Result, n);
  End;
End;

Procedure TRLEEncoder.MaxOutClear;
Begin
  OutClear := MaxCodes;
End;

Procedure TRLEEncoder.ResetOutClear;
Begin
  OutClear := OutClearInit;
  If (OutCount >= OutClear) Then
    Clear;
End;

Procedure TRLEEncoder.FlushFromClear(Count: integer);
Var
  n: integer;
Begin
  MaxOutClear;
  RunLengthTablePixel := Prefix;
  n := 1;
  While (Count > 0) Do
  Begin
    If (n = 1) Then
    Begin
      RunLengthTableMax := 1;
      OutputPlain(Prefix);
      Dec(Count);
    End Else
      If (Count >= n) Then
      Begin
        RunLengthTableMax := n;
        OutputPlain(BaseCode + n - 2);
        Dec(Count, n);
      End Else
        If (Count = 1) Then
        Begin
          inc(RunLengthTableMax);
          OutputPlain(Prefix);
          Break;
        End Else
        Begin
          inc(RunLengthTableMax);
          OutputPlain(BaseCode + Count - 2);
          Break;
        End;

    If (OutCount = 0) Then
      n := 1
    Else
      inc(n);
  End;
  ResetOutClear;
End;

Procedure TRLEEncoder.FlushClearOrRepeat(Count: integer);
Var
  WithClear: integer;
Begin
  WithClear := 1 + ComputeTriangleCount(Count, MaxCodes);

  If (WithClear < Count) Then
  Begin
    Clear;
    FlushFromClear(Count);
  End Else
    While (Count > 0) Do
    Begin
      OutputPlain(Prefix);
      Dec(Count);
    End;
End;

Procedure TRLEEncoder.FlushWithTable(Count: integer);
Var
  RepeatMax,
    RepeatLeft,
    LeftOver: integer;
Begin
  RepeatMax := Count Div RunLengthTableMax;
  LeftOver := Count Mod RunLengthTableMax;
  If (LeftOver <> 0) Then
    RepeatLeft := 1
  Else
    RepeatLeft := 0;

  If (OutCount + RepeatMax + RepeatLeft > MaxCodes) Then
  Begin
    RepeatMax := MaxCodes - OutCount;
    LeftOver := Count - (RepeatMax * RunLengthTableMax);
    RepeatLeft := 1 + ComputeTriangleCount(LeftOver, MaxCodes);
  End;

  If (1 + ComputeTriangleCount(Count, MaxCodes) < RepeatMax + RepeatLeft) Then
  Begin
    Clear;
    FlushFromClear(Count);
    Exit;
  End;
  MaxOutClear;

  While (RepeatMax > 0) Do
  Begin
    OutputPlain(BaseCode + RunLengthTableMax - 2);
    Dec(RepeatMax);
  End;

  If (LeftOver > 0) Then
  Begin
    If (ClearFlag) Then
      FlushFromClear(LeftOver)
    Else If (LeftOver = 1) Then
      OutputPlain(Prefix)
    Else
      OutputPlain(BaseCode + LeftOver - 2);
  End;
  ResetOutClear;
End;

Procedure TRLEEncoder.Flush(RunLengthCount: integer);
Begin
  If (RunLengthCount = 1) Then
  Begin
    OutputPlain(Prefix);
    Exit;
  End;

  If (ClearFlag) Then
    FlushFromClear(RunLengthCount)
  Else If ((RunLengthTableMax < 2) Or (RunLengthTablePixel <> Prefix)) Then
    FlushClearOrRepeat(RunLengthCount)
  Else
    FlushWithTable(RunLengthCount);
End;

Procedure TRLEEncoder.DoCompress;
Var
  Color: CodeInt;
  RunLengthCount: integer;

Begin
  OutBumpInit := ClearCode - 1;

  // For images with a lot of runs, making OutClearInit larger will
  // give better compression.
  If (BitsPerPixel <= 3) Then
    OutClearInit := 9
  Else
    OutClearInit := OutBumpInit - 1;

  // max_ocodes = (1 << GIFBITS) - ((1 << (out_bits_init - 1)) + 3);
  // <=> MaxCodes := (1 SHL GIFCodeBits) - ((1 SHL (BitsPerCode - 1)) + 3);
  // <=> MaxCodes := (1 SHL GIFCodeBits) - ((1 SHL (InitialBitsPerCode - 1)) + 3);
  // <=> MaxCodes := (1 SHL GIFCodeBits) - (ClearCode + 3);
  // <=> MaxCodes := (1 SHL GIFCodeBits) - (EOFCode + 2);
  // <=> MaxCodes := (1 SHL GIFCodeBits) - (BaseCode + 1);
  // <=> MaxCodes := MaxCodesFromBits(GIFCodeBits) - BaseCode;
  MaxCodes := MaxCodesFromBits(GIFCodeBits) - BaseCode;

  Clear;
  RunLengthCount := 0;

  Pixel := Data;
  Prefix := -1; // Dummy value to make Color <> Prefix
  Repeat
    // Fetch the next pixel
    Color := CodeInt(Pixel^);
    inc(Pixel);

    If (Color >= MaxColor) Then
      Error(sInvalidColor);

    If (RunLengthCount > 0) And (Color <> Prefix) Then
    Begin
      // End of current run
      Flush(RunLengthCount);
      RunLengthCount := 0;
    End;

    If (Color = Prefix) Then
      // Increment run length
      inc(RunLengthCount)
    Else
    Begin
      // Start new run
      Prefix := Color;
      RunLengthCount := 1;
    End;
  Until Not (BumpPixel);
  Flush(RunLengthCount);
End;

////////////////////////////////////////////////////////////////////////////////
//		TLZWEncoder - LZW encoder
////////////////////////////////////////////////////////////////////////////////
Const
  TableMaxMaxCode = (1 Shl GIFCodeBits); //
  TableMaxFill = TableMaxMaxCode - 1; // Clear table when it fills to
        // this point.
        // Note: Must be <= GIFCodeMax
Type
  TLZWEncoder = Class(TGIFEncoder)
  Private
    Prefix: CodeInt; // Current run color
    FreeEntry: CodeInt; // next unused code in table
    HashTable: THashTable;
  Protected
    Procedure Output(Value: integer); Override;
    Procedure Clear; Override;
    Procedure DoCompress; Override;
  End;


Procedure TLZWEncoder.Output(Value: integer);
Begin
  Inherited Output(Value);

  // If the next entry is going to be too big for the code size,
  // then increase it, if possible.
  If (FreeEntry > MaxCode) Or (ClearFlag) Then
  Begin
    If (ClearFlag) Then
    Begin
      BitsPerCode := InitialBitsPerCode;
      MaxCode := MaxCodesFromBits(BitsPerCode);
      ClearFlag := False;
    End Else
    Begin
      inc(BitsPerCode);
      If (BitsPerCode = GIFCodeBits) Then
        MaxCode := TableMaxMaxCode
      Else
        MaxCode := MaxCodesFromBits(BitsPerCode);
    End;
  End;
End;

Procedure TLZWEncoder.Clear;
Begin
  Inherited Clear;
  HashTable.Clear;
  FreeEntry := ClearCode + 2;
End;


Procedure TLZWEncoder.DoCompress;
Var
  Color: char;
  NewKey: KeyInt;
  NewCode: CodeInt;

Begin
  HashTable := THashTable.Create;
  Try
    // clear hash table and sync decoder
    Clear;

    Pixel := Data;
    Prefix := CodeInt(Pixel^);
    inc(Pixel);
    If (Prefix >= MaxColor) Then
      Error(sInvalidColor);
    While (BumpPixel) Do
    Begin
      // Fetch the next pixel
      Color := Pixel^;
      inc(Pixel);
      If (Ord(Color) >= MaxColor) Then
        Error(sInvalidColor);

      // Append Postfix to Prefix and lookup in table...
      NewKey := (KeyInt(Prefix) Shl 8) Or Ord(Color);
      NewCode := HashTable.Lookup(NewKey);
      If (NewCode >= 0) Then
      Begin
        // ...if found, get next pixel
        Prefix := NewCode;
        Continue;
      End;

      // ...if not found, output and start over
      Output(Prefix);
      Prefix := CodeInt(Color);

      If (FreeEntry < TableMaxFill) Then
      Begin
        HashTable.Insert(NewKey, FreeEntry);
        inc(FreeEntry);
      End Else
        Clear;
    End;
    Output(Prefix);
  Finally
    HashTable.Free;
  End;
End;

////////////////////////////////////////////////////////////////////////////////
//
//			TGIFSubImage
//
////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////
//		TGIFSubImage.Compress
/////////////////////////////////////////////////////////////////////////
Procedure TGIFSubImage.Compress(Stream: TStream);
Var
  Encoder: TGIFEncoder;
  BitsPerPixel: Byte;
  MaxColors: integer;
Begin
  If (ColorMap.Count > 0) Then
  Begin
    MaxColors := ColorMap.Count;
    BitsPerPixel := ColorMap.BitsPerPixel
  End Else
  Begin
    BitsPerPixel := Image.BitsPerPixel;
    MaxColors := 1 Shl BitsPerPixel;
  End;

  // Create a RLE or LZW GIF encoder
  If (Image.Compression = gcRLE) Then
    Encoder := TRLEEncoder.Create
  Else
    Encoder := TLZWEncoder.Create;
  Try
    Encoder.Warning := Image.Warning;
    Encoder.Compress(Stream, BitsPerPixel, Width, Height, Interlaced, FData, MaxColors);
  Finally
    Encoder.Free;
  End;
End;

Function TGIFExtensionList.GetExtension(Index: integer): TGIFExtension;
Begin
  Result := TGIFExtension(Items[Index]);
End;

Procedure TGIFExtensionList.SetExtension(Index: integer; Extension: TGIFExtension);
Begin
  Items[Index] := Extension;
End;

Procedure TGIFExtensionList.LoadFromStream(Stream: TStream; Parent: TObject);
Var
  b: Byte;
  Extension: TGIFExtension;
  ExtensionClass: TGIFExtensionClass;
Begin
  // Peek ahead to determine block type
  If (Stream.Read(b, 1) <> 1) Then
    Exit;
  While Not (b In [bsTrailer, bsImageDescriptor]) Do
  Begin
    If (b = bsExtensionIntroducer) Then
    Begin
      ExtensionClass := TGIFExtension.FindExtension(Stream);
      If (ExtensionClass = Nil) Then
        Error(sUnknownExtension);
      Stream.Seek(-1, soFromCurrent);
      Extension := ExtensionClass.Create(Parent As TGIFSubImage);
      Try
        Extension.LoadFromStream(Stream);
        Add(Extension);
      Except
        Extension.Free;
        Raise;
      End;
    End Else
    Begin
      Warning(gsWarning, sBadExtensionLabel);
      Break;
    End;
    If (Stream.Read(b, 1) <> 1) Then
      Exit;
  End;
  Stream.Seek(-1, soFromCurrent);
End;

Const
  { image descriptor bit masks }
  idLocalColorTable = $80; { set if a local color table follows }
  idInterlaced = $40; { set if image is interlaced }
  idSort = $20; { set if color table is sorted }
  idReserved = $0C; { reserved - must be set to $00 }
  idColorTableSize = $07; { size of color table as above }

Constructor TGIFSubImage.Create(GIFImage: TGIFImage);
Begin
  Inherited Create(GIFImage);
  FExtensions := TGIFExtensionList.Create(GIFImage);
  FColorMap := TGIFLocalColorMap.Create(self);
  FImageDescriptor.Separator := bsImageDescriptor;
  FImageDescriptor.Left := 0;
  FImageDescriptor.Top := 0;
  FImageDescriptor.Width := 0;
  FImageDescriptor.Height := 0;
  FImageDescriptor.PackedFields := 0;
  FBitmap := Nil;
  FMask := 0;
  FNeedMask := True;
  FData := Nil;
  FDataSize := 0;
  FTransparent := False;
  FGCE := Nil;
  // Remember to synchronize with TGIFSubImage.Clear
End;

Destructor TGIFSubImage.Destroy;
Begin
  If (FGIFImage <> Nil) Then
    FGIFImage.Images.Remove(self);
  Clear;
  FExtensions.Free;
  FColorMap.Free;
  If (FLocalPalette <> 0) Then
    DeleteObject(FLocalPalette);
  Inherited Destroy;
End;

Procedure TGIFSubImage.Clear;
Begin
  FExtensions.Clear;
  FColorMap.Clear;
  FreeImage;
  Height := 0;
  Width := 0;
  FTransparent := False;
  FGCE := Nil;
  FreeBitmap;
  FreeMask;
  // Remember to synchronize with TGIFSubImage.Create
End;

Function TGIFSubImage.GetEmpty: Boolean;
Begin
  Result := ((FData = Nil) Or (FDataSize = 0) Or (Height = 0) Or (Width = 0));
End;

Function TGIFSubImage.GetPalette: HPalette;
Begin
  If (FBitmap <> Nil) And (FBitmap.Palette <> 0) Then
    // Use bitmaps own palette if possible
    Result := FBitmap.Palette
  Else If (FLocalPalette <> 0) Then
    // Or a previously exported local palette
    Result := FLocalPalette
  Else If (Image.DoDither) Then
  Begin
    // or create a new dither palette
    FLocalPalette := WebPalette;
    Result := FLocalPalette;
  End
  Else If (ColorMap.Count > 0) Then
  Begin
    // or create a new if first time
    FLocalPalette := ColorMap.ExportPalette;
    Result := FLocalPalette;
  End Else
    // Use global palette if everything else fails
    Result := Image.Palette;
End;

Procedure TGIFSubImage.SetPalette(Value: HPalette);
Var
  NeedNewBitmap: Boolean;
Begin
  If (Value <> FLocalPalette) Then
  Begin
    // Zap old palette
    If (FLocalPalette <> 0) Then
      DeleteObject(FLocalPalette);
    // Zap bitmap unless new palette is same as bitmaps own
    NeedNewBitmap := (FBitmap <> Nil) And (Value <> FBitmap.Palette);

    // Use new palette
    FLocalPalette := Value;
    If (NeedNewBitmap) Then
    Begin
      // Need to create new bitmap and repaint
      FreeBitmap;
      Image.PaletteModified := True;
      Image.Changed(self);
    End;
  End;
End;

Procedure TGIFSubImage.NeedImage;
Begin
  If (FData = Nil) Then
    NewImage;
  If (FDataSize = 0) Then
    Error(sEmptyImage);
End;

Procedure TGIFSubImage.NewImage;
Var
  NewSize: longInt;
Begin
  FreeImage;
  NewSize := Height * Width;
  If (NewSize <> 0) Then
  Begin
    GetMem(FData, NewSize);
    FillChar(FData^, NewSize, 0);
  End Else
    FData := Nil;
  FDataSize := NewSize;
End;

Procedure TGIFSubImage.FreeImage;
Begin
  If (FData <> Nil) Then
    FreeMem(FData);
  FDataSize := 0;
  FData := Nil;
End;

Function TGIFSubImage.GetHasBitmap: Boolean;
Begin
  Result := (FBitmap <> Nil);
End;

Procedure TGIFSubImage.SetHasBitmap(Value: Boolean);
Begin
  If (Value <> (FBitmap <> Nil)) Then
  Begin
    If (Value) Then
      Bitmap // Referencing Bitmap will automatically create it
    Else
      FreeBitmap;
  End;
End;

Procedure TGIFSubImage.NewBitmap;
Begin
  FreeBitmap;
  FBitmap := TBitmap.Create;
End;

Procedure TGIFSubImage.FreeBitmap;
Begin
  If (FBitmap <> Nil) Then
  Begin
    FBitmap.Free;
    FBitmap := Nil;
  End;
End;

Procedure TGIFSubImage.FreeMask;
Begin
  If (FMask <> 0) Then
  Begin
    DeleteObject(FMask);
    FMask := 0;
  End;
  FNeedMask := True;
End;

Function TGIFSubImage.HasMask: Boolean;
Begin
  If (FNeedMask) And (Transparent) Then
  Begin
    // Zap old bitmap
    FreeBitmap;
    // Create new bitmap and mask
    GetBitmap;
  End;
  Result := (FMask <> 0);
End;

Function TGIFSubImage.GetBounds(Index: integer): Word;
Begin
  Case (Index) Of
    1: Result := FImageDescriptor.Left;
    2: Result := FImageDescriptor.Top;
    3: Result := FImageDescriptor.Width;
    4: Result := FImageDescriptor.Height;
  Else
    Result := 0; // To avoid compiler warnings
  End;
End;

Procedure TGIFSubImage.SetBounds(Index: integer; Value: Word);
Begin
  Case (Index) Of
    1: DoSetBounds(Value, FImageDescriptor.Top, FImageDescriptor.Width, FImageDescriptor.Height);
    2: DoSetBounds(FImageDescriptor.Left, Value, FImageDescriptor.Width, FImageDescriptor.Height);
    3: DoSetBounds(FImageDescriptor.Left, FImageDescriptor.Top, Value, FImageDescriptor.Height);
    4: DoSetBounds(FImageDescriptor.Left, FImageDescriptor.Top, FImageDescriptor.Width, Value);
  End;
End;

{$IFOPT R+}
{$DEFINE R_PLUS}
{$RANGECHECKS OFF}
{$ENDIF}
Function TGIFSubImage.DoGetDitherBitmap: TBitmap;
Var
  ColorLookup: TColorLookup;
  Ditherer: TDitherEngine;
  DIBResult: TDIB;
  Src: PChar;
  Dst: PChar;

  Row: integer;
  Color: TGIFColor;
  ColMap: PColorMap;
  Index: Byte;
  TransparentIndex: Byte;
  IsTransparent: Boolean;
  WasTransparent: Boolean;
  MappedTransparentIndex: char;

  MaskBits: PChar;
  MaskDest: PChar;
  MaskRow: PChar;
  MaskRowWidth,
    MaskRowBitWidth: integer;
  Bit,
    RightBit: Byte;

Begin
  Result := TBitmap.Create;
  Try

{$IFNDEF VER9x}
    If (Width * Height > BitmapAllocationThreshold) Then
      SetPixelFormat(Result, pf1bit); // To reduce resource consumption of resize
{$ENDIF}

    If (Empty) Then
    Begin
      // Set bitmap width and height
      Result.Width := Width;
      Result.Height := Height;

      // Build and copy palette to bitmap
      Result.Palette := CopyPalette(Palette);

      Exit;
    End;

    ColorLookup := Nil;
    Ditherer := Nil;
    DIBResult := Nil;
    Try // Protect above resources
      ColorLookup := TNetscapeColorLookup.Create(Palette);
      Ditherer := TFloydSteinbergDitherer.Create(Width, ColorLookup);
      // Get DIB buffer for scanline operations
      // It is assumed that the source palette is the 216 color Netscape palette
      DIBResult := TDIBWriter.Create(Result, pf8bit, Width, Height, Palette);

      // Determine if this image is transparent
      ColMap := ActiveColorMap.Data;
      IsTransparent := FNeedMask And Transparent;
      WasTransparent := False;
      FNeedMask := False;
      TransparentIndex := 0;
      MappedTransparentIndex := #0;
      If (FMask = 0) And (IsTransparent) Then
      Begin
        IsTransparent := True;
        TransparentIndex := GraphicControlExtension.TransparentColorIndex;
        Color := ColMap[Ord(TransparentIndex)];
        MappedTransparentIndex := char(Color.Blue Div 51 +
          MulDiv(6, Color.Green, 51) + MulDiv(36, Color.Red, 51) + 1);
      End;

      // Allocate bit buffer for transparency mask
      MaskDest := Nil;
      Bit := $00;
      If (IsTransparent) Then
      Begin
        MaskRowWidth := ((Width + 15) Div 16) * 2;
        MaskRowBitWidth := (Width + 7) Div 8;
        RightBit := $01 Shl ((8 - (Width And $0007)) And $0007);
        GetMem(MaskBits, MaskRowWidth * Height);
        FillChar(MaskBits^, MaskRowWidth * Height, 0);
      End Else
      Begin
        MaskBits := Nil;
        MaskRowWidth := 0;
        MaskRowBitWidth := 0;
        RightBit := $00;
      End;

      Try
        // Process the image
        Row := 0;
        MaskRow := MaskBits;
        Src := FData;
        While (Row < Height) Do
        Begin
          If ((Row And $1F) = 0) Then
            Image.Progress(self, psRunning, MulDiv(Row, 100, Height),
              False, Rect(0, 0, 0, 0), sProgressRendering);

          Dst := DIBResult.Scanline[Row];
          If (IsTransparent) Then
          Begin
            // Preset all pixels to transparent
            FillChar(Dst^, Width, Ord(MappedTransparentIndex));
            If (Ditherer.Direction = 1) Then
            Begin
              MaskDest := MaskRow;
              Bit := $80;
            End Else
            Begin
              MaskDest := MaskRow + MaskRowBitWidth - 1;
              Bit := RightBit;
            End;
          End;
          inc(Dst, Ditherer.Column);

          While (Ditherer.Column < Ditherer.Width) And (Ditherer.Column >= 0) Do
          Begin
            Index := Ord(Src^);
            Color := ColMap[Ord(Index)];

            If (IsTransparent) And (Index = TransparentIndex) Then
            Begin
              MaskDest^ := char(Byte(MaskDest^) Or Bit);
              WasTransparent := True;
              Ditherer.NextColumn;
            End Else
            Begin
              // Dither and map a single pixel
              Dst^ := Ditherer.Dither(Color.Red, Color.Green, Color.Blue,
                Color.Red, Color.Green, Color.Blue);
            End;

            If (IsTransparent) Then
            Begin
              If (Ditherer.Direction = 1) Then
              Begin
                Bit := Bit Shr 1;
                If (Bit = $00) Then
                Begin
                  Bit := $80;
                  inc(MaskDest, 1);
                End;
              End Else
              Begin
                Bit := Bit Shl 1;
                If (Bit = $00) Then
                Begin
                  Bit := $01;
                  Dec(MaskDest, 1);
                End;
              End;
            End;

            inc(Src, Ditherer.Direction);
            inc(Dst, Ditherer.Direction);
          End;

          If (IsTransparent) Then
            inc(MaskRow, MaskRowWidth);
          inc(Row);
          inc(Src, Width - Ditherer.Direction);
          Ditherer.NextLine;
        End;

        // Transparent paint needs a mask bitmap
        If (IsTransparent) And (WasTransparent) Then
          FMask := CreateBitmap(Width, Height, 1, 1, MaskBits);
      Finally
        If (MaskBits <> Nil) Then
          FreeMem(MaskBits);
      End;
    Finally
      If (ColorLookup <> Nil) Then
        ColorLookup.Free;
      If (Ditherer <> Nil) Then
        Ditherer.Free;
      If (DIBResult <> Nil) Then
        DIBResult.Free;
    End;
  Except
    Result.Free;
    Raise;
  End;
End;
{$IFDEF R_PLUS}
{$RANGECHECKS ON}
{$UNDEF R_PLUS}
{$ENDIF}

Function TGIFSubImage.DoGetBitmap: TBitmap;
Var
  ScanLineRow: integer;
  DIBResult: TDIB;
  DestScanLine,
    Src: PChar;
  TransparentIndex: Byte;
  IsTransparent: Boolean;
  WasTransparent: Boolean;

  MaskBits: PChar;
  MaskDest: PChar;
  MaskRow: PChar;
  MaskRowWidth: integer;
  Col: integer;
  MaskByte: Byte;
  Bit: Byte;
Begin
  Result := TBitmap.Create;
  Try

{$IFNDEF VER9x}
    If (Width * Height > BitmapAllocationThreshold) Then
      SetPixelFormat(Result, pf1bit); // To reduce resource consumption of resize
{$ENDIF}

    If (Empty) Then
    Begin
      // Set bitmap width and height
      Result.Width := Width;
      Result.Height := Height;

      // Build and copy palette to bitmap
      Result.Palette := CopyPalette(Palette);

      Exit;
    End;

    // Get DIB buffer for scanline operations
    DIBResult := TDIBWriter.Create(Result, pf8bit, Width, Height, Palette);
    Try

      // Determine if this image is transparent
      IsTransparent := FNeedMask And Transparent;
      WasTransparent := False;
      FNeedMask := False;
      TransparentIndex := 0;
      If (FMask = 0) And (IsTransparent) Then
      Begin
        IsTransparent := True;
        TransparentIndex := GraphicControlExtension.TransparentColorIndex;
      End;
      // Allocate bit buffer for transparency mask
      If (IsTransparent) Then
      Begin
        MaskRowWidth := ((Width + 15) Div 16) * 2;
        GetMem(MaskBits, MaskRowWidth * Height);
        FillChar(MaskBits^, MaskRowWidth * Height, 0);
        IsTransparent := (MaskBits <> Nil);
      End Else
      Begin
        MaskBits := Nil;
        MaskRowWidth := 0;
      End;

      Try
        ScanLineRow := 0;
        Src := FData;
        MaskRow := MaskBits;
        While (ScanLineRow < Height) Do
        Begin
          DestScanLine := DIBResult.Scanline[ScanLineRow];

          If ((ScanLineRow And $1F) = 0) Then
            Image.Progress(self, psRunning, MulDiv(ScanLineRow, 100, Height),
              False, Rect(0, 0, 0, 0), sProgressRendering);

          Move(Src^, DestScanLine^, Width);
          inc(ScanLineRow);

          If (IsTransparent) Then
          Begin
            Bit := $80;
            MaskDest := MaskRow;
            MaskByte := 0;
            For Col := 0 To Width - 1 Do
            Begin
              // Set a bit in the mask if the pixel is transparent
              If (Src^ = char(TransparentIndex)) Then
                MaskByte := MaskByte Or Bit;

              Bit := Bit Shr 1;
              If (Bit = $00) Then
              Begin
                // Store a mask byte for each 8 pixels
                Bit := $80;
                WasTransparent := WasTransparent Or (MaskByte <> 0);
                MaskDest^ := char(MaskByte);
                inc(MaskDest);
                MaskByte := 0;
              End;
              inc(Src);
            End;
            // Save the last mask byte in case the width isn't divisable by 8
            If (MaskByte <> 0) Then
            Begin
              WasTransparent := True;
              MaskDest^ := char(MaskByte);
            End;
            inc(MaskRow, MaskRowWidth);
          End Else
            inc(Src, Width);
        End;

        // Transparent paint needs a mask bitmap
        If (IsTransparent) And (WasTransparent) Then
          FMask := CreateBitmap(Width, Height, 1, 1, MaskBits);
      Finally
        If (MaskBits <> Nil) Then
          FreeMem(MaskBits);
      End;
    Finally
      // Free DIB buffer used for scanline operations
      DIBResult.Free;
    End;
  Except
    Result.Free;
    Raise;
  End;
End;

{$IFDEF DEBUG_RENDERPERFORMANCE}
Var
  ImageCount: DWORD = 0;
  RenderTime: DWORD = 0;
{$ENDIF}
Function TGIFSubImage.GetBitmap: TBitmap;
Var
  n: integer;
{$IFDEF DEBUG_RENDERPERFORMANCE}
  RenderStartTime: DWORD;
{$ENDIF}
Begin
{$IFDEF DEBUG_RENDERPERFORMANCE}
  If (GetAsyncKeyState(VK_CONTROL) <> 0) Then
  Begin
    ShowMessage(Format('Render %d images in %d mS, Rate %d mS/image (%d images/S)',
      [ImageCount, RenderTime,
      RenderTime Div (ImageCount + 1),
        MulDiv(ImageCount, 1000, RenderTime + 1)]));
  End;
{$ENDIF}
  Result := FBitmap;
  If (Result <> Nil) Or (Empty) Then
    Exit;

{$IFDEF DEBUG_RENDERPERFORMANCE}
  inc(ImageCount);
  RenderStartTime := timeGetTime;
{$ENDIF}
  Try
    Image.Progress(self, psStarting, 0, False, Rect(0, 0, 0, 0), sProgressRendering);
    Try

      If (Image.DoDither) Then
        // Create dithered bitmap
        FBitmap := DoGetDitherBitmap
      Else
        // Create "regular" bitmap
        FBitmap := DoGetBitmap;

      Result := FBitmap;

    Finally
      If ExceptObject = Nil Then
        n := 100
      Else
        n := 0;
      Image.Progress(self, psEnding, n, Image.PaletteModified, Rect(0, 0, 0, 0),
        sProgressRendering);
      // Make sure new palette gets realized, in case OnProgress event didn't.
      If Image.PaletteModified Then
        Image.Changed(self);
    End;
  Except
    On EAbort Do ; // OnProgress can raise EAbort to cancel image load
  End;
{$IFDEF DEBUG_RENDERPERFORMANCE}
  inc(RenderTime, timeGetTime - RenderStartTime);
{$ENDIF}
End;

Procedure TGIFSubImage.SetBitmap(Value: TBitmap);
Begin
  FreeBitmap;
  If (Value <> Nil) Then
    Assign(Value);
End;

Function TGIFSubImage.GetActiveColorMap: TGIFColorMap;
Begin
  If (ColorMap.Count > 0) Or (Image.GlobalColorMap.Count = 0) Then
    Result := ColorMap
  Else
    Result := Image.GlobalColorMap;
End;

Function TGIFSubImage.GetInterlaced: Boolean;
Begin
  Result := (FImageDescriptor.PackedFields And idInterlaced) <> 0;
End;

Procedure TGIFSubImage.SetInterlaced(Value: Boolean);
Begin
  If (Value) Then
    FImageDescriptor.PackedFields := FImageDescriptor.PackedFields Or idInterlaced
  Else
    FImageDescriptor.PackedFields := FImageDescriptor.PackedFields And Not (idInterlaced);
End;

Function TGIFSubImage.GetVersion: TGIFVersion;
Var
  v: TGIFVersion;
  i: integer;
Begin
  If (ColorMap.Optimized) Then
    Result := gv89a
  Else
    Result := Inherited GetVersion;
  i := 0;
  While (Result < High(TGIFVersion)) And (i < FExtensions.Count) Do
  Begin
    v := FExtensions[i].Version;
    If (v > Result) Then
      Result := v;
  End;
End;

Function TGIFSubImage.GetColorResolution: integer;
Begin
  Result := ColorMap.BitsPerPixel - 1;
End;

Function TGIFSubImage.GetBitsPerPixel: integer;
Begin
  Result := ColorMap.BitsPerPixel;
End;

Function TGIFSubImage.GetBoundsRect: TRect;
Begin
  Result := Rect(FImageDescriptor.Left,
    FImageDescriptor.Top,
    FImageDescriptor.Left + FImageDescriptor.Width,
    FImageDescriptor.Top + FImageDescriptor.Height);
End;

Procedure TGIFSubImage.DoSetBounds(ALeft, ATop, AWidth, AHeight: integer);
Var
  TooLarge: Boolean;
  Zap: Boolean;
Begin
  Zap := (FImageDescriptor.Width <> Width) Or (FImageDescriptor.Height <> AHeight);
  FImageDescriptor.Left := ALeft;
  FImageDescriptor.Top := ATop;
  FImageDescriptor.Width := AWidth;
  FImageDescriptor.Height := AHeight;

  // Delete existing image and bitmaps if size has changed
  If (Zap) Then
  Begin
    FreeBitmap;
    FreeMask;
    FreeImage;
    // ...and allocate a new image
    NewImage;
  End;

  TooLarge := False;
  // Set width & height if added image is larger than existing images
{$IFDEF STRICT_MOZILLA}
  // From Mozilla source:
  // Work around broken GIF files where the logical screen
  // size has weird width or height. [...]
  If (Image.Width < AWidth) Or (Image.Height < AHeight) Then
  Begin
    TooLarge := True;
    Image.Width := AWidth;
    Image.Height := AHeight;
    Left := 0;
    Top := 0;
  End;
{$ELSE}
  If (Image.Width < ALeft + AWidth) Then
  Begin
    If (Image.Width > 0) Then
    Begin
      TooLarge := True;
      Warning(gsWarning, sBadWidth)
    End;
    Image.Width := ALeft + AWidth;
  End;
  If (Image.Height < ATop + AHeight) Then
  Begin
    If (Image.Height > 0) Then
    Begin
      TooLarge := True;
      Warning(gsWarning, sBadHeight)
    End;
    Image.Height := ATop + AHeight;
  End;
{$ENDIF}

  If (TooLarge) Then
    Warning(gsWarning, sScreenSizeExceeded);
End;

Procedure TGIFSubImage.SetBoundsRect(Const Value: TRect);
Begin
  DoSetBounds(Value.Left, Value.Top, Value.Right - Value.Left + 1, Value.Bottom - Value.Top + 1);
End;

Function TGIFSubImage.GetClientRect: TRect;
Begin
  Result := Rect(0, 0, FImageDescriptor.Width, FImageDescriptor.Height);
End;

Function TGIFSubImage.GetPixel(x, y: integer): Byte;
Begin
  If (x < 0) Or (x > Width - 1) Then
    Error(sBadPixelCoordinates);
  Result := Byte(PChar(longInt(Scanline[y]) + x)^);
End;

Function TGIFSubImage.GetScanline(y: integer): Pointer;
Begin
  If (y < 0) Or (y > Height - 1) Then
    Error(sBadPixelCoordinates);
  NeedImage;
  Result := Pointer(longInt(FData) + y * Width);
End;

Procedure TGIFSubImage.Prepare;
Var
  Pack: Byte;
Begin
  Pack := FImageDescriptor.PackedFields;
  If (ColorMap.Count > 0) Then
  Begin
    Pack := idLocalColorTable;
    If (ColorMap.Optimized) Then
      Pack := Pack Or idSort;
    Pack := (Pack And Not (idColorTableSize)) Or (ColorResolution And idColorTableSize);
  End Else
    Pack := Pack And Not (idLocalColorTable Or idSort Or idColorTableSize);
  FImageDescriptor.PackedFields := Pack;
End;

Procedure TGIFSubImage.SaveToStream(Stream: TStream);
Begin
  FExtensions.SaveToStream(Stream);
  If (Empty) Then
    Exit;
  Prepare;
  Stream.Write(FImageDescriptor, SizeOf(TImageDescriptor));
  ColorMap.SaveToStream(Stream);
  Compress(Stream);
End;

Procedure TGIFSubImage.LoadFromStream(Stream: TStream);
Var
  ColorCount: integer;
  b: Byte;
Begin
  Clear;
  FExtensions.LoadFromStream(Stream, self);
  // Check for extension without image
  If (Stream.Read(b, 1) <> 1) Then
    Exit;
  Stream.Seek(-1, soFromCurrent);
  If (b = bsTrailer) Or (b = 0) Then
    Exit;

  ReadCheck(Stream, FImageDescriptor, SizeOf(TImageDescriptor));

  // From Mozilla source:
  // Work around more broken GIF files that have zero image
  // width or height
  If (FImageDescriptor.Height = 0) Or (FImageDescriptor.Width = 0) Then
  Begin
    FImageDescriptor.Height := Image.Height;
    FImageDescriptor.Width := Image.Width;
    Warning(gsWarning, sScreenSizeExceeded);
  End;

  If (FImageDescriptor.PackedFields And idLocalColorTable = idLocalColorTable) Then
  Begin
    ColorCount := 2 Shl (FImageDescriptor.PackedFields And idColorTableSize);
    If (ColorCount < 2) Or (ColorCount > 256) Then
      Error(sImageBadColorSize);
    ColorMap.LoadFromStream(Stream, ColorCount);
  End;

  Decompress(Stream);

  // On-load rendering
  If (GIFImageRenderOnLoad) Then
    // Touch bitmap to force frame to be rendered
    Bitmap;
End;

Procedure TGIFSubImage.AssignTo(Dest: TPersistent);
Begin
  If (Dest Is TBitmap) Then
    Dest.Assign(Bitmap)
  Else
    Inherited AssignTo(Dest);
End;

Procedure TGIFSubImage.Assign(Source: TPersistent);
Var
  MemoryStream: TMemoryStream;
  i: integer;
  PixelFormat: TPixelFormat;
  DIBSource: TDIB;
  ABitmap: TBitmap;

  Procedure Import8Bit(Dest: PChar);
  Var
    y: integer;
  Begin
    // Copy colormap
{$IFDEF VER10_PLUS}
    If (FBitmap.HandleType = bmDIB) Then
      FColorMap.ImportDIBColors(FBitmap.Canvas.Handle)
    Else
{$ENDIF}
      FColorMap.ImportPalette(FBitmap.Palette);
    // Copy pixels
    For y := 0 To Height - 1 Do
    Begin
      If ((y And $1F) = 0) Then
        Image.Progress(self, psRunning, MulDiv(y, 100, Height), False, Rect(0, 0, 0, 0), sProgressConverting);
      Move(DIBSource.Scanline[y]^, Dest^, Width);
      inc(Dest, Width);
    End;
  End;

  Procedure Import4Bit(Dest: PChar);
  Var
    x, y: integer;
    Scanline: PChar;
  Begin
    // Copy colormap
    FColorMap.ImportPalette(FBitmap.Palette);
    // Copy pixels
    For y := 0 To Height - 1 Do
    Begin
      If ((y And $1F) = 0) Then
        Image.Progress(self, psRunning, MulDiv(y, 100, Height), False, Rect(0, 0, 0, 0), sProgressConverting);
      Scanline := DIBSource.Scanline[y];
      For x := 0 To Width - 1 Do
      Begin
        If (x And $01 = 0) Then
          Dest^ := Chr(Ord(Scanline^) Shr 4)
        Else
        Begin
          Dest^ := Chr(Ord(Scanline^) And $0F);
          inc(Scanline);
        End;
        inc(Dest);
      End;
    End;
  End;

  Procedure Import1Bit(Dest: PChar);
  Var
    x, y: integer;
    Scanline: PChar;
    Bit: integer;
    Byte: integer;
  Begin
    // Copy colormap
    FColorMap.ImportPalette(FBitmap.Palette);
    // Copy pixels
    For y := 0 To Height - 1 Do
    Begin
      If ((y And $1F) = 0) Then
        Image.Progress(self, psRunning, MulDiv(y, 100, Height), False, Rect(0, 0, 0, 0), sProgressConverting);
      Scanline := DIBSource.Scanline[y];
      x := Width;
      Bit := 0;
      Byte := 0; // To avoid compiler warning
      While (x > 0) Do
      Begin
        If (Bit = 0) Then
        Begin
          Bit := 8;
          Byte := Ord(Scanline^);
          inc(Scanline);
        End;
        Dest^ := Chr((Byte And $80) Shr 7);
        Byte := Byte Shl 1;
        inc(Dest);
        Dec(Bit);
        Dec(x);
      End;
    End;
  End;

  Procedure Import24Bit(Dest: PChar);
  Type
    TCacheEntry = Record
      Color: TColor;
      Index: integer;
    End;
  Const
    // Size of palette cache. Must be 2^n.
    // The cache holds the palette index of the last "CacheSize" colors
    // processed. Hopefully the cache can speed things up a bit... Initial
    // testing shows that this is indeed the case at least for non-dithered
    // bitmaps.
    // All the same, a small hash table would probably be much better.
    CacheSize = 8;
  Var
    i: integer;
    Cache: Array[0..CacheSize - 1] Of TCacheEntry;
    LastEntry: integer;
    Scanline: PRGBTriple;
    Pixel: TColor;
    RGBTriple: TRGBTriple Absolute Pixel;
    x, y: integer;
    ColorMap: PColorMap;
    T: Byte;
  Label
    NextPixel;
  Begin
    For i := 0 To CacheSize - 1 Do
      Cache[i].Index := -1;
    LastEntry := 0;

    // Copy all pixels and build colormap
    For y := 0 To Height - 1 Do
    Begin
      If ((y And $1F) = 0) Then
        Image.Progress(self, psRunning, MulDiv(y, 100, Height), False, Rect(0, 0, 0, 0), sProgressConverting);
      Scanline := DIBSource.Scanline[y];
      For x := 0 To Width - 1 Do
      Begin
        Pixel := 0;
        RGBTriple := Scanline^;
        // Scan cache for color from most recently processed color to last
        // recently processed. This is done because TColorMap.AddUnique is very slow.
        i := LastEntry;
        Repeat
          If (Cache[i].Index = -1) Then
            Break;
          If (Cache[i].Color = Pixel) Then
          Begin
            Dest^ := Chr(Cache[i].Index);
            LastEntry := i;
            Goto NextPixel;
          End;
          If (i = 0) Then
            i := CacheSize - 1
          Else
            Dec(i);
        Until (i = LastEntry);
        // Color not found in cache, do it the slow way instead
        Dest^ := Chr(FColorMap.AddUnique(Pixel));
        // Add color and index to cache
        LastEntry := (LastEntry + 1) And (CacheSize - 1);
        Cache[LastEntry].Color := Pixel;
        Cache[LastEntry].Index := Ord(Dest^);

        NextPixel:
        inc(Dest);
        inc(Scanline);
      End;
    End;
    // Convert colors in colormap from BGR to RGB
    ColorMap := FColorMap.Data;
    i := FColorMap.Count;
    While (i > 0) Do
    Begin
      T := ColorMap^[0].Red;
      ColorMap^[0].Red := ColorMap^[0].Blue;
      ColorMap^[0].Blue := T;
      inc(integer(ColorMap), SizeOf(TGIFColor));
      Dec(i);
    End;
  End;

  Procedure ImportViaDraw(ABitmap: TBitmap; Graphic: TGraphic);
  Begin
    ABitmap.Height := Graphic.Height;
    ABitmap.Width := Graphic.Width;

    // Note: Disable the call to SafeSetPixelFormat below to import
    // in max number of colors with the risk of having to use
    // TCanvas.Pixels to do it (very slow).

    // Make things a little easier for TGIFSubImage.Assign by converting
    // pfDevice to a more import friendly format
{$IFDEF SLOW_BUT_SAFE}
    SafeSetPixelFormat(ABitmap, pf8bit);
{$ELSE}
{$IFNDEF VER9x}
    SetPixelFormat(ABitmap, pf24bit);
{$ENDIF}
{$ENDIF}
    ABitmap.Canvas.Draw(0, 0, Graphic);
  End;

  Procedure AddMask(Mask: TBitmap);
  Var
    DIBReader: TDIBReader;
    TransparentIndex: integer;
    i,
      j: integer;
    GIFPixel,
      MaskPixel: PChar;
    WasTransparent: Boolean;
    GCE: TGIFGraphicControlExtension;
  Begin
    // Optimize colormap to make room for transparent color
    ColorMap.Optimize;
    // Can't make transparent if no color or colormap full
    If (ColorMap.Count = 0) Or (ColorMap.Count = 256) Then
      Exit;

    // Add the transparent color to the color map
    TransparentIndex := ColorMap.Add(TColor(0));
    WasTransparent := False;

    DIBReader := TDIBReader.Create(Mask, pf8bit);
    Try
      For i := 0 To Height - 1 Do
      Begin
        MaskPixel := DIBReader.Scanline[i];
        GIFPixel := Scanline[i];
        For j := 0 To Width - 1 Do
        Begin
          // Change all unmasked pixels to transparent
          If (MaskPixel^ <> #0) Then
          Begin
            GIFPixel^ := Chr(TransparentIndex);
            WasTransparent := True;
          End;
          inc(MaskPixel);
          inc(GIFPixel);
        End;
      End;
    Finally
      DIBReader.Free;
    End;

    // Add a Graphic Control Extension if any part of the mask was transparent
    If (WasTransparent) Then
    Begin
      GCE := TGIFGraphicControlExtension.Create(self);
      GCE.Transparent := True;
      GCE.TransparentColorIndex := TransparentIndex;
      Extensions.Add(GCE);
    End Else
      // Otherwise removed the transparency color since it wasn't used
      ColorMap.Delete(TransparentIndex);
  End;

  Procedure AddMaskOnly(hMask: HBitmap);
  Var
    Mask: TBitmap;
  Begin
    If (hMask = 0) Then
      Exit;

    // Encapsulate the mask
    Mask := TBitmap.Create;
    Try
//      Mask.Handle := hMask;  // 2003.08.04
      Mask.Handle := Windows.CopyImage(hMask, IMAGE_BITMAP, 0, 0, LR_COPYRETURNORG); // 2003.08.04
      AddMask(Mask);
    Finally
//      Mask.ReleaseHandle;  // 2003.08.04
      Mask.Free;
    End;
  End;

  Procedure AddIconMask(Icon: TIcon);
  Var
    IconInfo: TIconInfo;
  Begin
    If (Not GetIconInfo(Icon.Handle, IconInfo)) Then
      Exit;

    // Extract the icon mask
    AddMaskOnly(IconInfo.hbmMask);
  End;

  Procedure AddMetafileMask(Metafile: TMetaFile);
  Var
    Mask1,
      Mask2: TBitmap;

    Procedure DrawMetafile(ABitmap: TBitmap; Background: TColor);
    Begin
      ABitmap.Width := Metafile.Width;
      ABitmap.Height := Metafile.Height;
  {$IFNDEF VER9x}
      SetPixelFormat(ABitmap, pf24bit);
  {$ENDIF}
      ABitmap.Canvas.Brush.Color := Background;
      ABitmap.Canvas.Brush.Style := bsSolid;
      ABitmap.Canvas.FillRect(ABitmap.Canvas.ClipRect);
      ABitmap.Canvas.Draw(0, 0, Metafile);
    End;

  Begin
    // Create the metafile mask
    Mask1 := TBitmap.Create;
    Try
      Mask2 := TBitmap.Create;
      Try
        DrawMetafile(Mask1, clWhite);
        DrawMetafile(Mask2, clBlack);
        Mask1.Canvas.CopyMode := cmSrcInvert;
        Mask1.Canvas.Draw(0, 0, Mask2);
        AddMask(Mask1);
      Finally
        Mask2.Free;
      End;
    Finally
      Mask1.Free;
    End;
  End;

Begin
  If (Source = self) Then
    Exit;
  If (Source = Nil) Then
  Begin
    Clear;
  End Else
  //
  // TGIFSubImage import
  //
    If (Source Is TGIFSubImage) Then
    Begin
    // Zap existing colormap, extensions and bitmap
      Clear;
      If (TGIFSubImage(Source).Empty) Then
        Exit;
    // Copy source data
      FImageDescriptor := TGIFSubImage(Source).FImageDescriptor;
      FTransparent := TGIFSubImage(Source).Transparent;
    // Copy image data
      NewImage;
      If (FData <> Nil) And (TGIFSubImage(Source).Data <> Nil) Then
        Move(TGIFSubImage(Source).Data^, FData^, FDataSize);
    // Copy palette
      FColorMap.Assign(TGIFSubImage(Source).ColorMap);
    // Copy extensions
      If (TGIFSubImage(Source).Extensions.Count > 0) Then
      Begin
        MemoryStream := TMemoryStream.Create;
        Try
          TGIFSubImage(Source).Extensions.SaveToStream(MemoryStream);
          MemoryStream.Seek(0, soFromBeginning);
          Extensions.LoadFromStream(MemoryStream, self);
        Finally
          MemoryStream.Free;
        End;
      End;

    // Copy bitmap representation
    // (Not really nescessary but improves performance if the bitmap is needed
    // later on)
      If (TGIFSubImage(Source).HasBitmap) Then
      Begin
        NewBitmap;
        FBitmap.Assign(TGIFSubImage(Source).Bitmap);
      End;
    End Else
  //
  // Bitmap import
  //
      If (Source Is TBitmap) Then
      Begin
    // Zap existing colormap, extensions and bitmap
        Clear;
        If (TBitmap(Source).Empty) Then
          Exit;

        Width := TBitmap(Source).Width;
        Height := TBitmap(Source).Height;

        PixelFormat := GetPixelFormat(TBitmap(Source));
{$IFDEF VER9x}
    // Delphi 2 TBitmaps are always DDBs. This means that if a 24 bit
    // bitmap is loaded in 8 bit device mode, TBitmap.PixelFormat will
    // be pf8bit, but TBitmap.Palette will be 0!
        If (TBitmap(Source).Palette = 0) Then
          PixelFormat := pfDevice;
{$ENDIF}
        If (PixelFormat > pf8bit) Or (PixelFormat = pfDevice) Then
        Begin
      // Convert image to 8 bits/pixel or less
          FBitmap := ReduceColors(TBitmap(Source), Image.ColorReduction,
            Image.DitherMode, Image.ReductionBits, 0);
          PixelFormat := GetPixelFormat(FBitmap);
        End Else
        Begin
      // Create new bitmap and copy
          NewBitmap;
          FBitmap.Assign(TBitmap(Source));
        End;

    // Allocate new buffer
        NewImage;

        Image.Progress(self, psStarting, 0, False, Rect(0, 0, 0, 0), sProgressConverting);
        Try
{$IFDEF VER9x}
      // This shouldn't happen, but better safe...
          If (FBitmap.Palette = 0) Then
            PixelFormat := pf24bit;
{$ENDIF}
          If (Not (PixelFormat In [pf1bit, pf4bit, pf8bit, pf24bit])) Then
            PixelFormat := pf24bit;
          DIBSource := TDIBReader.Create(FBitmap, PixelFormat);
          Try
        // Copy pixels
            Case (PixelFormat) Of
              pf8bit: Import8Bit(FData);
              pf4bit: Import4Bit(FData);
              pf1bit: Import1Bit(FData);
            Else
//        Error(sUnsupportedBitmap);
              Import24Bit(FData);
            End;

          Finally
            DIBSource.Free;
          End;

{$IFDEF VER10_PLUS}
      // Add mask for transparent bitmaps
          If (TBitmap(Source).Transparent) Then
            AddMaskOnly(TBitmap(Source).MaskHandle);
{$ENDIF}

        Finally
          If ExceptObject = Nil Then
            i := 100
          Else
            i := 0;
          Image.Progress(self, psEnding, i, Image.PaletteModified, Rect(0, 0, 0, 0), sProgressConverting);
        End;
      End Else
  //
  // TGraphic import
  //
        If (Source Is TGraphic) Then
        Begin
    // Zap existing colormap, extensions and bitmap
          Clear;
          If (TGraphic(Source).Empty) Then
            Exit;

          ABitmap := TBitmap.Create;
          Try
      // Import TIcon and TMetafile by drawing them onto a bitmap...
      // ...and then importing the bitmap recursively
            If (Source Is TIcon) Or (Source Is TMetaFile) Then
            Begin
              Try
                ImportViaDraw(ABitmap, TGraphic(Source))
              Except
          // If import via TCanvas.Draw fails (which it shouldn't), we try the
          // Assign mechanism instead
                ABitmap.Assign(Source);
              End;
            End Else
            Try
              ABitmap.Assign(Source);
            Except
          // If automatic conversion to bitmap fails, we try and draw the
          // graphic on the bitmap instead
              ImportViaDraw(ABitmap, TGraphic(Source));
            End;
      // Convert the bitmap to a GIF frame recursively
            Assign(ABitmap);
          Finally
            ABitmap.Free;
          End;

    // Import transparency mask
          If (Source Is TIcon) Then
            AddIconMask(TIcon(Source));
          If (Source Is TMetaFile) Then
            AddMetafileMask(TMetaFile(Source));

        End Else
  //
  // TPicture import
  //
          If (Source Is TPicture) Then
          Begin
    // Recursively import TGraphic
            Assign(TPicture(Source).Graphic);
          End Else
    // Unsupported format - fall back to Source.AssignTo
            Inherited Assign(Source);
End;

// Copied from D3 graphics.pas
// Fixed by Brian Lowe of Acro Technology Inc. 30Jan98
Function TransparentStretchBlt(DstDC: HDC; DstX, DstY, DstW, DstH: integer;
  SrcDC: HDC; SrcX, SrcY, SrcW, SrcH: integer; MaskDC: HDC; MaskX,
  MaskY: integer): Boolean;
Const
  ROP_DstCopy = $00AA0029;
Var
  MemDC,
    OrMaskDC: HDC;
  MemBmp,
    OrMaskBmp: HBitmap;
  Save,
    OrMaskSave: THandle;
  crText, crBack: TColorRef;
  SavePal: HPalette;

Begin
  Result := True;
  If (Win32Platform = VER_PLATFORM_WIN32_NT) And (SrcW = DstW) And (SrcH = DstH) Then
  Begin
    MemBmp := GDICheck(CreateCompatibleBitmap(SrcDC, 1, 1));
    MemBmp := SelectObject(MaskDC, MemBmp);
    Try
      MaskBlt(DstDC, DstX, DstY, DstW, DstH, SrcDC, SrcX, SrcY, MemBmp, MaskX,
        MaskY, MakeRop4(ROP_DstCopy, SrcCopy));
    Finally
      MemBmp := SelectObject(MaskDC, MemBmp);
      DeleteObject(MemBmp);
    End;
    Exit;
  End;

  SavePal := 0;
  MemDC := GDICheck(CreateCompatibleDC(DstDC));
  Try
    { Color bitmap for combining OR mask with source bitmap }
    MemBmp := GDICheck(CreateCompatibleBitmap(DstDC, SrcW, SrcH));
    Try
      Save := SelectObject(MemDC, MemBmp);
      Try
        { This bitmap needs the size of the source but DC of the dest }
        OrMaskDC := GDICheck(CreateCompatibleDC(DstDC));
        Try
          { Need a monochrome bitmap for OR mask!! }
          OrMaskBmp := GDICheck(CreateBitmap(SrcW, SrcH, 1, 1, Nil));
          Try
            OrMaskSave := SelectObject(OrMaskDC, OrMaskBmp);
            Try

              // OrMask := 1
              // Original: BitBlt(OrMaskDC, SrcX, SrcY, SrcW, SrcH, OrMaskDC, SrcX, SrcY, WHITENESS);
              // Replacement, but not needed: PatBlt(OrMaskDC, SrcX, SrcY, SrcW, SrcH, WHITENESS);
              // OrMask := OrMask XOR Mask
              // Not needed: BitBlt(OrMaskDC, SrcX, SrcY, SrcW, SrcH, MaskDC, SrcX, SrcY, SrcInvert);
              // OrMask := NOT Mask
              BitBlt(OrMaskDC, SrcX, SrcY, SrcW, SrcH, MaskDC, SrcX, SrcY, NotSrcCopy);

              // Retrieve source palette (with dummy select)
              SavePal := SelectPalette(SrcDC, SystemPalette16, False);
              // Restore source palette
              SelectPalette(SrcDC, SavePal, False);
              // Select source palette into memory buffer
              If SavePal <> 0 Then
                SavePal := SelectPalette(MemDC, SavePal, True)
              Else
                SavePal := SelectPalette(MemDC, SystemPalette16, True);
              RealizePalette(MemDC);

              // Mem := OrMask
              BitBlt(MemDC, SrcX, SrcY, SrcW, SrcH, OrMaskDC, SrcX, SrcY, SrcCopy);
              // Mem := Mem AND Src
{$IFNDEF GIF_TESTMASK} // Define GIF_TESTMASK if you want to know what it does...
              BitBlt(MemDC, SrcX, SrcY, SrcW, SrcH, SrcDC, SrcX, SrcY, SrcAnd);
{$ELSE}
              StretchBlt(DstDC, DstX, DstY, DstW Div 2, DstH, MemDC, SrcX, SrcY, SrcW, SrcH, SrcCopy);
              StretchBlt(DstDC, DstX + DstW Div 2, DstY, DstW Div 2, DstH, SrcDC, SrcX, SrcY, SrcW, SrcH, SrcCopy);
              Exit;
{$ENDIF}
            Finally
              If (OrMaskSave <> 0) Then
                SelectObject(OrMaskDC, OrMaskSave);
            End;
          Finally
            DeleteObject(OrMaskBmp);
          End;
        Finally
          DeleteDC(OrMaskDC);
        End;

        crText := SetTextColor(DstDC, $00000000);
        crBack := SetBkColor(DstDC, $00FFFFFF);

        { All color rendering is done at 1X (no stretching),
          then final 2 masks are stretched to dest DC }
        // Neat trick!
        // Dst := Dst AND Mask
        StretchBlt(DstDC, DstX, DstY, DstW, DstH, MaskDC, SrcX, SrcY, SrcW, SrcH, SrcAnd);
        // Dst := Dst OR Mem
        StretchBlt(DstDC, DstX, DstY, DstW, DstH, MemDC, SrcX, SrcY, SrcW, SrcH, SrcPaint);

        SetTextColor(DstDC, crText);
        SetTextColor(DstDC, crBack);

      Finally
        If (Save <> 0) Then
          SelectObject(MemDC, Save);
      End;
    Finally
      DeleteObject(MemBmp);
    End;
  Finally
    If (SavePal <> 0) Then
      SelectPalette(MemDC, SavePal, False);
    DeleteDC(MemDC);
  End;
End;

Procedure TGIFSubImage.Draw(ACanvas: TCanvas; Const Rect: TRect;
  DoTransparent, DoTile: Boolean);
Begin
  If (DoTile) Then
    StretchDraw(ACanvas, Rect, DoTransparent, DoTile)
  Else
    StretchDraw(ACanvas, ScaleRect(Rect), DoTransparent, DoTile);
End;

Type
  // Dummy class used to gain access to protected method TCanvas.Changed
  TChangableCanvas = Class(TCanvas)
  End;

Procedure TGIFSubImage.StretchDraw(ACanvas: TCanvas; Const Rect: TRect;
  DoTransparent, DoTile: Boolean);
Var
  MaskDC: HDC;
  Save: THandle;
  Tile: TRect;
{$IFDEF DEBUG_DRAWPERFORMANCE}
  ImageCount,
    TimeStart,
    TimeStop: DWORD;
{$ENDIF}

Begin
{$IFDEF DEBUG_DRAWPERFORMANCE}
  TimeStart := timeGetTime;
  ImageCount := 0;
{$ENDIF}
  If (DoTransparent) And (Transparent) And (HasMask) Then
  Begin
    // Draw transparent using mask
    Save := 0;
    MaskDC := 0;
    Try
      MaskDC := GDICheck(CreateCompatibleDC(0));
      Save := SelectObject(MaskDC, FMask);

      If (DoTile) Then
      Begin
        Tile.Left := Rect.Left + Left;
        Tile.Right := Tile.Left + Width;
        While (Tile.Left < Rect.Right) Do
        Begin
          Tile.Top := Rect.Top + Top;
          Tile.Bottom := Tile.Top + Height;
          While (Tile.Top < Rect.Bottom) Do
          Begin
            TransparentStretchBlt(ACanvas.Handle, Tile.Left, Tile.Top, Width, Height,
              Bitmap.Canvas.Handle, 0, 0, Width, Height, MaskDC, 0, 0);
            Tile.Top := Tile.Top + Image.Height;
            Tile.Bottom := Tile.Bottom + Image.Height;
{$IFDEF DEBUG_DRAWPERFORMANCE}
            inc(ImageCount);
{$ENDIF}
          End;
          Tile.Left := Tile.Left + Image.Width;
          Tile.Right := Tile.Right + Image.Width;
        End;
      End Else
        TransparentStretchBlt(ACanvas.Handle, Rect.Left, Rect.Top,
          Rect.Right - Rect.Left, Rect.Bottom - Rect.Top,
          Bitmap.Canvas.Handle, 0, 0, Width, Height, MaskDC, 0, 0);

      // Since we are not using any of the TCanvas functions (only handle)
      // we need to fire the TCanvas.Changed method "manually".
      TChangableCanvas(ACanvas).Changed;

    Finally
      If (Save <> 0) Then
        SelectObject(MaskDC, Save);
      If (MaskDC <> 0) Then
        DeleteDC(MaskDC);
    End;
  End Else
  Begin
    If (DoTile) Then
    Begin
      Tile.Left := Rect.Left + Left;
      Tile.Right := Tile.Left + Width;
      While (Tile.Left < Rect.Right) Do
      Begin
        Tile.Top := Rect.Top + Top;
        Tile.Bottom := Tile.Top + Height;
        While (Tile.Top < Rect.Bottom) Do
        Begin
          ACanvas.StretchDraw(Tile, Bitmap);
          Tile.Top := Tile.Top + Image.Height;
          Tile.Bottom := Tile.Bottom + Image.Height;
{$IFDEF DEBUG_DRAWPERFORMANCE}
          inc(ImageCount);
{$ENDIF}
        End;
        Tile.Left := Tile.Left + Image.Width;
        Tile.Right := Tile.Right + Image.Width;
      End;
    End Else
      ACanvas.StretchDraw(Rect, Bitmap);
  End;
{$IFDEF DEBUG_DRAWPERFORMANCE}
  If (GetAsyncKeyState(VK_CONTROL) <> 0) Then
  Begin
    TimeStop := timeGetTime;
    ShowMessage(Format('Draw %d images in %d mS, Rate %d images/mS (%d images/S)',
      [ImageCount, TimeStop - TimeStart,
      ImageCount Div (TimeStop - TimeStart + 1),
        MulDiv(ImageCount, 1000, TimeStop - TimeStart + 1)]));
  End;
{$ENDIF}
End;

// Given a destination rect (DestRect) calculates the
// area covered by this sub image
Function TGIFSubImage.ScaleRect(DestRect: TRect): TRect;
Var
  HeightMul,
    HeightDiv: integer;
  WidthMul,
    WidthDiv: integer;
Begin
  HeightDiv := Image.Height;
  HeightMul := DestRect.Bottom - DestRect.Top;
  WidthDiv := Image.Width;
  WidthMul := DestRect.Right - DestRect.Left;

  Result.Left := DestRect.Left + MulDiv(Left, WidthMul, WidthDiv);
  Result.Top := DestRect.Top + MulDiv(Top, HeightMul, HeightDiv);
  Result.Right := DestRect.Left + MulDiv(Left + Width, WidthMul, WidthDiv);
  Result.Bottom := DestRect.Top + MulDiv(Top + Height, HeightMul, HeightDiv);
End;

Procedure TGIFSubImage.Crop;
Var
  TransparentColorIndex: Byte;
  CropLeft,
    CropTop,
    CropRight,
    CropBottom: integer;
  WasTransparent: Boolean;
  i: integer;
  NewSize: integer;
  NewData: PChar;
  NewWidth,
    NewHeight: integer;
  pSource,
    pDest: PChar;
Begin
  If (Empty) Or (Not Transparent) Then
    Exit;
  TransparentColorIndex := GraphicControlExtension.TransparentColorIndex;
  CropLeft := 0;
  CropRight := Width - 1;
  CropTop := 0;
  CropBottom := Height - 1;
  // Find left edge
  WasTransparent := True;
  While (CropLeft <= CropRight) And (WasTransparent) Do
  Begin
    For i := CropTop To CropBottom Do
      If (Pixels[CropLeft, i] <> TransparentColorIndex) Then
      Begin
        WasTransparent := False;
        Break;
      End;
    If (WasTransparent) Then
      inc(CropLeft);
  End;
  // Find right edge
  WasTransparent := True;
  While (CropLeft <= CropRight) And (WasTransparent) Do
  Begin
    For i := CropTop To CropBottom Do
      If (Pixels[CropRight, i] <> TransparentColorIndex) Then
      Begin
        WasTransparent := False;
        Break;
      End;
    If (WasTransparent) Then
      Dec(CropRight);
  End;
  If (CropLeft <= CropRight) Then
  Begin
    // Find top edge
    WasTransparent := True;
    While (CropTop <= CropBottom) And (WasTransparent) Do
    Begin
      For i := CropLeft To CropRight Do
        If (Pixels[i, CropTop] <> TransparentColorIndex) Then
        Begin
          WasTransparent := False;
          Break;
        End;
      If (WasTransparent) Then
        inc(CropTop);
    End;
    // Find bottom edge
    WasTransparent := True;
    While (CropTop <= CropBottom) And (WasTransparent) Do
    Begin
      For i := CropLeft To CropRight Do
        If (Pixels[i, CropBottom] <> TransparentColorIndex) Then
        Begin
          WasTransparent := False;
          Break;
        End;
      If (WasTransparent) Then
        Dec(CropBottom);
    End;
  End;

  If (CropLeft > CropRight) Or (CropTop > CropBottom) Then
  Begin
    // Cropped to nothing - frame is invisible
    Clear;
  End Else
  Begin
    // Crop frame - move data
    NewWidth := CropRight - CropLeft + 1;
    NewHeight := CropBottom - CropTop + 1;
    NewSize := NewWidth * NewHeight;
    GetMem(NewData, NewSize);
    pSource := PChar(integer(FData) + CropTop * Width + CropLeft);
    pDest := NewData;
    For i := 0 To NewHeight - 1 Do
    Begin
      Move(pSource^, pDest^, NewWidth);
      inc(pSource, Width);
      inc(pDest, NewWidth);
    End;
    FreeImage;
    FData := NewData;
    FDataSize := NewSize;
    inc(FImageDescriptor.Left, CropLeft);
    inc(FImageDescriptor.Top, CropTop);
    FImageDescriptor.Width := NewWidth;
    FImageDescriptor.Height := NewHeight;
    FreeBitmap;
    FreeMask
  End;
End;

Procedure TGIFSubImage.Merge(Previous: TGIFSubImage);
Var
  SourceIndex,
    DestIndex: Byte;
  SourceTransparent: Boolean;
  NeedTransparentColorIndex: Boolean;
  PreviousRect,
    ThisRect,
    MergeRect: TRect;
  PreviousY,
    x,
    y: integer;
  pSource,
    pDest: PChar;
  pSourceMap,
    pDestMap: PColorMap;
  GCE: TGIFGraphicControlExtension;

  Function CanMakeTransparent: Boolean;
  Begin
    // Is there a local color map...
    If (ColorMap.Count > 0) Then
      // ...and is there room in it?
      Result := (ColorMap.Count < 256)
    // Is there a global color map...
    Else If (Image.GlobalColorMap.Count > 0) Then
      // ...and is there room in it?
      Result := (Image.GlobalColorMap.Count < 256)
    Else
      Result := False;
  End;

  Function GetTransparentColorIndex: Byte;
  Var
    i: integer;
  Begin
    If (ColorMap.Count > 0) Then
    Begin
      // Get the transparent color from the local color map
      Result := ColorMap.Add(TColor(0));
    End Else
    Begin
      // Are any other frames using the global color map for transparency
      For i := 0 To Image.Images.Count - 1 Do
        If (Image.Images[i] <> self) And (Image.Images[i].Transparent) And
          (Image.Images[i].ColorMap.Count = 0) Then
        Begin
          // Use the same transparency color as the other frame
          Result := Image.Images[i].GraphicControlExtension.TransparentColorIndex;
          Exit;
        End;
      // Get the transparent color from the global color map
      Result := Image.GlobalColorMap.Add(TColor(0));
    End;
  End;

Begin
  // Determine if it is possible to merge this frame
  If (Empty) Or (Previous = Nil) Or (Previous.Empty) Or
    ((Previous.GraphicControlExtension <> Nil) And
    (Previous.GraphicControlExtension.Disposal In [dmBackground, dmPrevious])) Then
    Exit;

  PreviousRect := Previous.BoundsRect;
  ThisRect := BoundsRect;

  // Cannot merge unless the frames intersect
  If (Not IntersectRect(MergeRect, PreviousRect, ThisRect)) Then
    Exit;

  // If the frame isn't already transparent, determine
  // if it is possible to make it so
  If (Transparent) Then
  Begin
    DestIndex := GraphicControlExtension.TransparentColorIndex;
    NeedTransparentColorIndex := False;
  End Else
  Begin
    If (Not CanMakeTransparent) Then
      Exit;
    DestIndex := 0; // To avoid compiler warning
    NeedTransparentColorIndex := True;
  End;

  SourceTransparent := Previous.Transparent;
  If (SourceTransparent) Then
    SourceIndex := Previous.GraphicControlExtension.TransparentColorIndex
  Else
    SourceIndex := 0; // To avoid compiler warning

  PreviousY := MergeRect.Top - Previous.Top;

  pSourceMap := Previous.ActiveColorMap.Data;
  pDestMap := ActiveColorMap.Data;

  For y := MergeRect.Top - Top To MergeRect.Bottom - Top - 1 Do
  Begin
    pSource := PChar(integer(Previous.Scanline[PreviousY]) + MergeRect.Left - Previous.Left);
    pDest := PChar(integer(Scanline[y]) + MergeRect.Left - Left);

    For x := MergeRect.Left To MergeRect.Right - 1 Do
    Begin
      // Ignore pixels if either this frame's or the previous frame's pixel is transparent
      If (
        Not (
        ((Not NeedTransparentColorIndex) And (pDest^ = char(DestIndex))) Or
        ((SourceTransparent) And (pSource^ = char(SourceIndex)))
        )
        ) And (
            // Replace same colored pixels with transparency
        ((pDestMap = pSourceMap) And (pDest^ = pSource^)) Or
        (CompareMem(@(pDestMap^[Ord(pDest^)]), @(pSourceMap^[Ord(pSource^)]), SizeOf(TGIFColor)))
        ) Then
      Begin
        If (NeedTransparentColorIndex) Then
        Begin
          NeedTransparentColorIndex := False;
          DestIndex := GetTransparentColorIndex;
        End;
        pDest^ := char(DestIndex);
      End;
      inc(pDest);
      inc(pSource);
    End;
    inc(PreviousY);
  End;

  (*
  ** Create a GCE if the frame wasn't already transparent and any
  ** pixels were made transparent
  *)
  If (Not Transparent) And (Not NeedTransparentColorIndex) Then
  Begin
    If (GraphicControlExtension = Nil) Then
    Begin
      GCE := TGIFGraphicControlExtension.Create(self);
      Extensions.Add(GCE);
    End Else
      GCE := GraphicControlExtension;
    GCE.Transparent := True;
    GCE.TransparentColorIndex := DestIndex;
  End;

  FreeBitmap;
  FreeMask
End;

////////////////////////////////////////////////////////////////////////////////
//
//			TGIFTrailer
//
////////////////////////////////////////////////////////////////////////////////
Procedure TGIFTrailer.SaveToStream(Stream: TStream);
Begin
  WriteByte(Stream, bsTrailer);
End;

Procedure TGIFTrailer.LoadFromStream(Stream: TStream);
Var
  b: Byte;
Begin
  If (Stream.Read(b, 1) <> 1) Then
    Exit;
  If (b <> bsTrailer) Then
    Warning(gsWarning, sBadTrailer);
End;

////////////////////////////////////////////////////////////////////////////////
//
//		TGIFExtension registration database
//
////////////////////////////////////////////////////////////////////////////////
Type
  TExtensionLeadIn = Packed Record
    Introducer: Byte; { always $21 }
    ExtensionLabel: Byte;
  End;

  PExtRec = ^TExtRec;
  TExtRec = Record
    ExtClass: TGIFExtensionClass;
    ExtLabel: Byte;
  End;

  TExtensionList = Class(TList)
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Procedure Add(elabel: Byte; eClass: TGIFExtensionClass);
    Function FindExt(elabel: Byte): TGIFExtensionClass;
    Procedure Remove(eClass: TGIFExtensionClass);
  End;

Constructor TExtensionList.Create;
Begin
  Inherited Create;
  Add(bsPlainTextExtension, TGIFTextExtension);
  Add(bsGraphicControlExtension, TGIFGraphicControlExtension);
  Add(bsCommentExtension, TGIFCommentExtension);
  Add(bsApplicationExtension, TGIFApplicationExtension);
End;

Destructor TExtensionList.Destroy;
Var
  i: integer;
Begin
  For i := 0 To Count - 1 Do
    Dispose(PExtRec(Items[i]));
  Inherited Destroy;
End;

Procedure TExtensionList.Add(elabel: Byte; eClass: TGIFExtensionClass);
Var
  NewRec: PExtRec;
Begin
  New(NewRec);
  With NewRec^ Do
  Begin
    ExtLabel := elabel;
    ExtClass := eClass;
  End;
  Inherited Add(NewRec);
End;

Function TExtensionList.FindExt(elabel: Byte): TGIFExtensionClass;
Var
  i: integer;
Begin
  For i := Count - 1 Downto 0 Do
    With PExtRec(Items[i])^ Do
      If ExtLabel = elabel Then
      Begin
        Result := ExtClass;
        Exit;
      End;
  Result := Nil;
End;

Procedure TExtensionList.Remove(eClass: TGIFExtensionClass);
Var
  i: integer;
  P: PExtRec;
Begin
  For i := Count - 1 Downto 0 Do
  Begin
    P := PExtRec(Items[i]);
    If P^.ExtClass.InheritsFrom(eClass) Then
    Begin
      Dispose(P);
      Delete(i);
    End;
  End;
End;

Var
  ExtensionList: TExtensionList = Nil;

Function GetExtensionList: TExtensionList;
Begin
  If (ExtensionList = Nil) Then
    ExtensionList := TExtensionList.Create;
  Result := ExtensionList;
End;

////////////////////////////////////////////////////////////////////////////////
//
//			TGIFExtension
//
////////////////////////////////////////////////////////////////////////////////
Function TGIFExtension.GetVersion: TGIFVersion;
Begin
  Result := gv89a;
End;

Class Procedure TGIFExtension.RegisterExtension(elabel: Byte; eClass: TGIFExtensionClass);
Begin
  GetExtensionList.Add(elabel, eClass);
End;

Class Function TGIFExtension.FindExtension(Stream: TStream): TGIFExtensionClass;
Var
  elabel: Byte;
  SubClass: TGIFExtensionClass;
  Pos: longInt;
Begin
  Pos := Stream.Position;
  If (Stream.Read(elabel, 1) <> 1) Then
  Begin
    Result := Nil;
    Exit;
  End;
  Result := GetExtensionList.FindExt(elabel);
  While (Result <> Nil) Do
  Begin
    SubClass := Result.FindSubExtension(Stream);
    If (SubClass = Result) Then
      Break;
    Result := SubClass;
  End;
  Stream.Position := Pos;
End;

Class Function TGIFExtension.FindSubExtension(Stream: TStream): TGIFExtensionClass;
Begin
  Result := self;
End;

Constructor TGIFExtension.Create(ASubImage: TGIFSubImage);
Begin
  Inherited Create(ASubImage.Image);
  FSubImage := ASubImage;
End;

Destructor TGIFExtension.Destroy;
Begin
  If (FSubImage <> Nil) Then
    FSubImage.Extensions.Remove(self);
  Inherited Destroy;
End;

Procedure TGIFExtension.SaveToStream(Stream: TStream);
Var
  ExtensionLeadIn: TExtensionLeadIn;
Begin
  ExtensionLeadIn.Introducer := bsExtensionIntroducer;
  ExtensionLeadIn.ExtensionLabel := ExtensionType;
  Stream.Write(ExtensionLeadIn, SizeOf(ExtensionLeadIn));
End;

Function TGIFExtension.DoReadFromStream(Stream: TStream): TGIFExtensionType;
Var
  ExtensionLeadIn: TExtensionLeadIn;
Begin
  ReadCheck(Stream, ExtensionLeadIn, SizeOf(ExtensionLeadIn));
  If (ExtensionLeadIn.Introducer <> bsExtensionIntroducer) Then
    Error(sBadExtensionLabel);
  Result := ExtensionLeadIn.ExtensionLabel;
End;

Procedure TGIFExtension.LoadFromStream(Stream: TStream);
Begin
  // Seek past lead-in
  // Stream.Seek(sizeof(TExtensionLeadIn), soFromCurrent);
  If (DoReadFromStream(Stream) <> ExtensionType) Then
    Error(sBadExtensionInstance);
End;

////////////////////////////////////////////////////////////////////////////////
//
//			TGIFGraphicControlExtension
//
////////////////////////////////////////////////////////////////////////////////
Const
  { Extension flag bit masks }
  efInputFlag = $02; { 00000010 }
  efDisposal = $1C; { 00011100 }
  efTransparent = $01; { 00000001 }
  efReserved = $E0; { 11100000 }

Constructor TGIFGraphicControlExtension.Create(ASubImage: TGIFSubImage);
Begin
  Inherited Create(ASubImage);

  FGCExtension.BlockSize := 4;
  FGCExtension.PackedFields := $00;
  FGCExtension.DelayTime := 0;
  FGCExtension.TransparentColorIndex := 0;
  FGCExtension.Terminator := 0;
  If (ASubImage.FGCE = Nil) Then
    ASubImage.FGCE := self;
End;

Destructor TGIFGraphicControlExtension.Destroy;
Begin
  // Clear transparent flag in sub image
  If (Transparent) Then
    SubImage.FTransparent := False;

  If (SubImage.FGCE = self) Then
    SubImage.FGCE := Nil;

  Inherited Destroy;
End;

Function TGIFGraphicControlExtension.GetExtensionType: TGIFExtensionType;
Begin
  Result := bsGraphicControlExtension;
End;

Function TGIFGraphicControlExtension.GetTransparent: Boolean;
Begin
  Result := (FGCExtension.PackedFields And efTransparent) <> 0;
End;

Procedure TGIFGraphicControlExtension.SetTransparent(Value: Boolean);
Begin
  // Set transparent flag in sub image
  SubImage.FTransparent := Value;
  If (Value) Then
    FGCExtension.PackedFields := FGCExtension.PackedFields Or efTransparent
  Else
    FGCExtension.PackedFields := FGCExtension.PackedFields And Not (efTransparent);
End;

Function TGIFGraphicControlExtension.GetTransparentColor: TColor;
Begin
  Result := SubImage.ActiveColorMap[TransparentColorIndex];
End;

Procedure TGIFGraphicControlExtension.SetTransparentColor(Color: TColor);
Begin
  FGCExtension.TransparentColorIndex := SubImage.ActiveColorMap.AddUnique(Color);
End;

Function TGIFGraphicControlExtension.GetTransparentColorIndex: Byte;
Begin
  Result := FGCExtension.TransparentColorIndex;
End;

Procedure TGIFGraphicControlExtension.SetTransparentColorIndex(Value: Byte);
Begin
  If ((Value >= SubImage.ActiveColorMap.Count) And (SubImage.ActiveColorMap.Count > 0)) Then
  Begin
    Warning(gsWarning, sBadColorIndex);
    Value := 0;
  End;
  FGCExtension.TransparentColorIndex := Value;
End;

Function TGIFGraphicControlExtension.GetDelay: Word;
Begin
  Result := FGCExtension.DelayTime;
End;
Procedure TGIFGraphicControlExtension.SetDelay(Value: Word);
Begin
  FGCExtension.DelayTime := Value;
End;

Function TGIFGraphicControlExtension.GetUserInput: Boolean;
Begin
  Result := (FGCExtension.PackedFields And efInputFlag) <> 0;
End;

Procedure TGIFGraphicControlExtension.SetUserInput(Value: Boolean);
Begin
  If (Value) Then
    FGCExtension.PackedFields := FGCExtension.PackedFields Or efInputFlag
  Else
    FGCExtension.PackedFields := FGCExtension.PackedFields And Not (efInputFlag);
End;

Function TGIFGraphicControlExtension.GetDisposal: TDisposalMethod;
Begin
  Result := TDisposalMethod((FGCExtension.PackedFields And efDisposal) Shr 2);
End;

Procedure TGIFGraphicControlExtension.SetDisposal(Value: TDisposalMethod);
Begin
  FGCExtension.PackedFields := FGCExtension.PackedFields And Not (efDisposal)
    Or ((Ord(Value) Shl 2) And efDisposal);
End;

Procedure TGIFGraphicControlExtension.SaveToStream(Stream: TStream);
Begin
  Inherited SaveToStream(Stream);
  Stream.Write(FGCExtension, SizeOf(FGCExtension));
End;

Procedure TGIFGraphicControlExtension.LoadFromStream(Stream: TStream);
Begin
  Inherited LoadFromStream(Stream);
  If (Stream.Read(FGCExtension, SizeOf(FGCExtension)) <> SizeOf(FGCExtension)) Then
  Begin
    Warning(gsWarning, sOutOfData);
    Exit;
  End;
  // Set transparent flag in sub image
  If (Transparent) Then
    SubImage.FTransparent := True;
End;

////////////////////////////////////////////////////////////////////////////////
//
//			TGIFTextExtension
//
////////////////////////////////////////////////////////////////////////////////
Constructor TGIFTextExtension.Create(ASubImage: TGIFSubImage);
Begin
  Inherited Create(ASubImage);
  FText := TStringList.Create;
  FPlainTextExtension.BlockSize := 12;
  FPlainTextExtension.Left := 0;
  FPlainTextExtension.Top := 0;
  FPlainTextExtension.Width := 0;
  FPlainTextExtension.Height := 0;
  FPlainTextExtension.CellWidth := 0;
  FPlainTextExtension.CellHeight := 0;
  FPlainTextExtension.TextFGColorIndex := 0;
  FPlainTextExtension.TextBGColorIndex := 0;
End;

Destructor TGIFTextExtension.Destroy;
Begin
  FText.Free;
  Inherited Destroy;
End;

Function TGIFTextExtension.GetExtensionType: TGIFExtensionType;
Begin
  Result := bsPlainTextExtension;
End;

Function TGIFTextExtension.GetForegroundColor: TColor;
Begin
  Result := SubImage.ColorMap[ForegroundColorIndex];
End;

Procedure TGIFTextExtension.SetForegroundColor(Color: TColor);
Begin
  ForegroundColorIndex := SubImage.ActiveColorMap.AddUnique(Color);
End;

Function TGIFTextExtension.GetBackgroundColor: TColor;
Begin
  Result := SubImage.ActiveColorMap[BackgroundColorIndex];
End;

Procedure TGIFTextExtension.SetBackgroundColor(Color: TColor);
Begin
  BackgroundColorIndex := SubImage.ColorMap.AddUnique(Color);
End;

Function TGIFTextExtension.GetBounds(Index: integer): Word;
Begin
  Case (Index) Of
    1: Result := FPlainTextExtension.Left;
    2: Result := FPlainTextExtension.Top;
    3: Result := FPlainTextExtension.Width;
    4: Result := FPlainTextExtension.Height;
  Else
    Result := 0; // To avoid compiler warnings
  End;
End;

Procedure TGIFTextExtension.SetBounds(Index: integer; Value: Word);
Begin
  Case (Index) Of
    1: FPlainTextExtension.Left := Value;
    2: FPlainTextExtension.Top := Value;
    3: FPlainTextExtension.Width := Value;
    4: FPlainTextExtension.Height := Value;
  End;
End;

Function TGIFTextExtension.GetCharWidthHeight(Index: integer): Byte;
Begin
  Case (Index) Of
    1: Result := FPlainTextExtension.CellWidth;
    2: Result := FPlainTextExtension.CellHeight;
  Else
    Result := 0; // To avoid compiler warnings
  End;
End;

Procedure TGIFTextExtension.SetCharWidthHeight(Index: integer; Value: Byte);
Begin
  Case (Index) Of
    1: FPlainTextExtension.CellWidth := Value;
    2: FPlainTextExtension.CellHeight := Value;
  End;
End;

Function TGIFTextExtension.GetColorIndex(Index: integer): Byte;
Begin
  Case (Index) Of
    1: Result := FPlainTextExtension.TextFGColorIndex;
    2: Result := FPlainTextExtension.TextBGColorIndex;
  Else
    Result := 0; // To avoid compiler warnings
  End;
End;

Procedure TGIFTextExtension.SetColorIndex(Index: integer; Value: Byte);
Begin
  Case (Index) Of
    1: FPlainTextExtension.TextFGColorIndex := Value;
    2: FPlainTextExtension.TextBGColorIndex := Value;
  End;
End;

Procedure TGIFTextExtension.SaveToStream(Stream: TStream);
Begin
  Inherited SaveToStream(Stream);
  Stream.Write(FPlainTextExtension, SizeOf(FPlainTextExtension));
  WriteStrings(Stream, FText);
End;

Procedure TGIFTextExtension.LoadFromStream(Stream: TStream);
Begin
  Inherited LoadFromStream(Stream);
  ReadCheck(Stream, FPlainTextExtension, SizeOf(FPlainTextExtension));
  ReadStrings(Stream, FText);
End;

////////////////////////////////////////////////////////////////////////////////
//
//			TGIFCommentExtension
//
////////////////////////////////////////////////////////////////////////////////
Constructor TGIFCommentExtension.Create(ASubImage: TGIFSubImage);
Begin
  Inherited Create(ASubImage);
  FText := TStringList.Create;
End;

Destructor TGIFCommentExtension.Destroy;
Begin
  FText.Free;
  Inherited Destroy;
End;

Function TGIFCommentExtension.GetExtensionType: TGIFExtensionType;
Begin
  Result := bsCommentExtension;
End;

Procedure TGIFCommentExtension.SaveToStream(Stream: TStream);
Begin
  Inherited SaveToStream(Stream);
  WriteStrings(Stream, FText);
End;

Procedure TGIFCommentExtension.LoadFromStream(Stream: TStream);
Begin
  Inherited LoadFromStream(Stream);
  ReadStrings(Stream, FText);
End;

////////////////////////////////////////////////////////////////////////////////
//
//		TGIFApplicationExtension registration database
//
////////////////////////////////////////////////////////////////////////////////
Type
  PAppExtRec = ^TAppExtRec;
  TAppExtRec = Record
    AppClass: TGIFAppExtensionClass;
    Ident: TGIFApplicationRec;
  End;

  TAppExtensionList = Class(TList)
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Procedure Add(eIdent: TGIFApplicationRec; eClass: TGIFAppExtensionClass);
    Function FindExt(eIdent: TGIFApplicationRec): TGIFAppExtensionClass;
    Procedure Remove(eClass: TGIFAppExtensionClass);
  End;

Constructor TAppExtensionList.Create;
Const
  NSLoopIdent: Array[0..1] Of TGIFApplicationRec =
  ((Identifier: 'NETSCAPE'; Authentication: '2.0'),
    (Identifier: 'ANIMEXTS'; Authentication: '1.0'));
Begin
  Inherited Create;
  Add(NSLoopIdent[0], TGIFAppExtNSLoop);
  Add(NSLoopIdent[1], TGIFAppExtNSLoop);
End;

Destructor TAppExtensionList.Destroy;
Var
  i: integer;
Begin
  For i := 0 To Count - 1 Do
    Dispose(PAppExtRec(Items[i]));
  Inherited Destroy;
End;

Procedure TAppExtensionList.Add(eIdent: TGIFApplicationRec; eClass: TGIFAppExtensionClass);
Var
  NewRec: PAppExtRec;
Begin
  New(NewRec);
  NewRec^.Ident := eIdent;
  NewRec^.AppClass := eClass;
  Inherited Add(NewRec);
End;

Function TAppExtensionList.FindExt(eIdent: TGIFApplicationRec): TGIFAppExtensionClass;
Var
  i: integer;
Begin
  For i := Count - 1 Downto 0 Do
    With PAppExtRec(Items[i])^ Do
      If CompareMem(@Ident, @eIdent, SizeOf(TGIFApplicationRec)) Then
      Begin
        Result := AppClass;
        Exit;
      End;
  Result := Nil;
End;

Procedure TAppExtensionList.Remove(eClass: TGIFAppExtensionClass);
Var
  i: integer;
  P: PAppExtRec;
Begin
  For i := Count - 1 Downto 0 Do
  Begin
    P := PAppExtRec(Items[i]);
    If P^.AppClass.InheritsFrom(eClass) Then
    Begin
      Dispose(P);
      Delete(i);
    End;
  End;
End;

Var
  AppExtensionList: TAppExtensionList = Nil;

Function GetAppExtensionList: TAppExtensionList;
Begin
  If (AppExtensionList = Nil) Then
    AppExtensionList := TAppExtensionList.Create;
  Result := AppExtensionList;
End;

Class Procedure TGIFApplicationExtension.RegisterExtension(eIdent: TGIFApplicationRec;
  eClass: TGIFAppExtensionClass);
Begin
  GetAppExtensionList.Add(eIdent, eClass);
End;

Class Function TGIFApplicationExtension.FindSubExtension(Stream: TStream): TGIFExtensionClass;
Var
  eIdent: TGIFApplicationRec;
  OldPos: longInt;
  Size: Byte;
Begin
  OldPos := Stream.Position;
  Result := Nil;
  If (Stream.Read(Size, 1) <> 1) Then
    Exit;

  // Some old Adobe export filters mistakenly uses a value of 10
  If (Size = 10) Then
  Begin
    { TODO -oanme -cImprovement : replace with seek or read and check contents = 'Adobe' }
    If (Stream.Read(eIdent, 10) <> 10) Then
      Exit;
    Result := TGIFUnknownAppExtension;
    Exit;
  End Else
    If (Size <> SizeOf(TGIFApplicationRec)) Or
      (Stream.Read(eIdent, SizeOf(eIdent)) <> SizeOf(eIdent)) Then
    Begin
      Stream.Position := OldPos;
      Result := Inherited FindSubExtension(Stream);
    End Else
    Begin
      Result := GetAppExtensionList.FindExt(eIdent);
      If (Result = Nil) Then
        Result := TGIFUnknownAppExtension;
    End;
End;

////////////////////////////////////////////////////////////////////////////////
//
//			TGIFApplicationExtension
//
////////////////////////////////////////////////////////////////////////////////
Constructor TGIFApplicationExtension.Create(ASubImage: TGIFSubImage);
Begin
  Inherited Create(ASubImage);
  FillChar(FIdent, SizeOf(FIdent), 0);
End;

Destructor TGIFApplicationExtension.Destroy;
Begin
  Inherited Destroy;
End;

Function TGIFApplicationExtension.GetExtensionType: TGIFExtensionType;
Begin
  Result := bsApplicationExtension;
End;

Function TGIFApplicationExtension.GetAuthentication: String;
Begin
  Result := FIdent.Authentication;
End;

Procedure TGIFApplicationExtension.SetAuthentication(Const Value: String);
Begin
  If (Length(Value) < SizeOf(TGIFAuthenticationCode)) Then
    FillChar(FIdent.Authentication, SizeOf(TGIFAuthenticationCode), 32);
  StrLCopy(@(FIdent.Authentication[0]), PChar(Value), SizeOf(TGIFAuthenticationCode));
End;

Function TGIFApplicationExtension.GetIdentifier: String;
Begin
  Result := FIdent.Identifier;
End;

Procedure TGIFApplicationExtension.SetIdentifier(Const Value: String);
Begin
  If (Length(Value) < SizeOf(TGIFIdentifierCode)) Then
    FillChar(FIdent.Identifier, SizeOf(TGIFIdentifierCode), 32);
  StrLCopy(@(FIdent.Identifier[0]), PChar(Value), SizeOf(TGIFIdentifierCode));
End;

Procedure TGIFApplicationExtension.SaveToStream(Stream: TStream);
Begin
  Inherited SaveToStream(Stream);
  WriteByte(Stream, SizeOf(FIdent)); // Block size
  Stream.Write(FIdent, SizeOf(FIdent));
  SaveData(Stream);
End;

Procedure TGIFApplicationExtension.LoadFromStream(Stream: TStream);
Var
  i: integer;
Begin
  Inherited LoadFromStream(Stream);
  i := ReadByte(Stream);
  // Some old Adobe export filters mistakenly uses a value of 10
  If (i = 10) Then
    FillChar(FIdent, SizeOf(FIdent), 0)
  Else
    If (i < 11) Then
      Error(sBadBlockSize);

  ReadCheck(Stream, FIdent, SizeOf(FIdent));

  Dec(i, SizeOf(FIdent));
  // Ignore extra data
  Stream.Seek(i, soFromCurrent);

  // ***FIXME***
  // If self class is TGIFApplicationExtension, this will cause an "abstract
  // error".
  // TGIFApplicationExtension.LoadData should read and ignore rest of block.
  LoadData(Stream);
End;

////////////////////////////////////////////////////////////////////////////////
//
//			TGIFUnknownAppExtension
//
////////////////////////////////////////////////////////////////////////////////
Constructor TGIFBlock.Create(ASize: integer);
Begin
  Inherited Create;
  FSize := ASize;
  GetMem(FData, FSize);
  FillChar(FData^, FSize, 0);
End;

Destructor TGIFBlock.Destroy;
Begin
  FreeMem(FData);
  Inherited Destroy;
End;

Procedure TGIFBlock.SaveToStream(Stream: TStream);
Begin
  Stream.Write(FSize, 1);
  Stream.Write(FData^, FSize);
End;

Procedure TGIFBlock.LoadFromStream(Stream: TStream);
Begin
  ReadCheck(Stream, FData^, FSize);
End;

Constructor TGIFUnknownAppExtension.Create(ASubImage: TGIFSubImage);
Begin
  Inherited Create(ASubImage);
  FBlocks := TList.Create;
End;

Destructor TGIFUnknownAppExtension.Destroy;
Var
  i: integer;
Begin
  For i := 0 To FBlocks.Count - 1 Do
    TGIFBlock(FBlocks[i]).Free;
  FBlocks.Free;
  Inherited Destroy;
End;


Procedure TGIFUnknownAppExtension.SaveData(Stream: TStream);
Var
  i: integer;
Begin
  For i := 0 To FBlocks.Count - 1 Do
    TGIFBlock(FBlocks[i]).SaveToStream(Stream);
  // Terminating zero
  WriteByte(Stream, 0);
End;

Procedure TGIFUnknownAppExtension.LoadData(Stream: TStream);
Var
  b: Byte;
  Block: TGIFBlock;
  i: integer;
Begin
  // Zap old blocks
  For i := 0 To FBlocks.Count - 1 Do
    TGIFBlock(FBlocks[i]).Free;
  FBlocks.Clear;

  // Read blocks
  If (Stream.Read(b, 1) <> 1) Then
    Exit;
  While (b <> 0) Do
  Begin
    Block := TGIFBlock.Create(b);
    Try
      Block.LoadFromStream(Stream);
    Except
      Block.Free;
      Raise;
    End;
    FBlocks.Add(Block);
    If (Stream.Read(b, 1) <> 1) Then
      Exit;
  End;
End;

////////////////////////////////////////////////////////////////////////////////
//
//                      TGIFAppExtNSLoop
//
////////////////////////////////////////////////////////////////////////////////
Const
  // Netscape sub block types
  nbLoopExtension = 1;
  nbBufferExtension = 2;

Constructor TGIFAppExtNSLoop.Create(ASubImage: TGIFSubImage);
Const
  NSLoopIdent: TGIFApplicationRec = (Identifier: 'NETSCAPE'; Authentication: '2.0');
Begin
  Inherited Create(ASubImage);
  FIdent := NSLoopIdent;
End;

Procedure TGIFAppExtNSLoop.SaveData(Stream: TStream);
Begin
  // Write loop count
  WriteByte(Stream, 1 + SizeOf(FLoops)); // Size of block
  WriteByte(Stream, nbLoopExtension); // Identify sub block as looping extension data
  Stream.Write(FLoops, SizeOf(FLoops)); // Loop count

  // Write buffer size if specified
  If (FBufferSize > 0) Then
  Begin
    WriteByte(Stream, 1 + SizeOf(FBufferSize)); // Size of block
    WriteByte(Stream, nbBufferExtension); // Identify sub block as buffer size data
    Stream.Write(FBufferSize, SizeOf(FBufferSize)); // Buffer size
  End;

  WriteByte(Stream, 0); // Terminating zero
End;

Procedure TGIFAppExtNSLoop.LoadData(Stream: TStream);
Var
  BlockSize: integer;
  BlockType: integer;
Begin
  // Read size of first block or terminating zero
  BlockSize := ReadByte(Stream);
  While (BlockSize <> 0) Do
  Begin
    BlockType := ReadByte(Stream);
    Dec(BlockSize);

    Case (BlockType And $07) Of
      nbLoopExtension:
        Begin
          If (BlockSize < SizeOf(FLoops)) Then
            Error(sInvalidData);
          // Read loop count
          ReadCheck(Stream, FLoops, SizeOf(FLoops));
          Dec(BlockSize, SizeOf(FLoops));
        End;
      nbBufferExtension:
        Begin
          If (BlockSize < SizeOf(FBufferSize)) Then
            Error(sInvalidData);
          // Read buffer size
          ReadCheck(Stream, FBufferSize, SizeOf(FBufferSize));
          Dec(BlockSize, SizeOf(FBufferSize));
        End;
    End;

    // Skip/ignore unread data
    If (BlockSize > 0) Then
      Stream.Seek(BlockSize, soFromCurrent);

    // Read size of next block or terminating zero
    BlockSize := ReadByte(Stream);
  End;
End;


////////////////////////////////////////////////////////////////////////////////
//
//			TGIFImageList
//
////////////////////////////////////////////////////////////////////////////////
Function TGIFImageList.GetImage(Index: integer): TGIFSubImage;
Begin
  Result := TGIFSubImage(Items[Index]);
End;

Procedure TGIFImageList.SetImage(Index: integer; SubImage: TGIFSubImage);
Begin
  Items[Index] := SubImage;
End;

Procedure TGIFImageList.LoadFromStream(Stream: TStream; Parent: TObject);
Var
  b: Byte;
  SubImage: TGIFSubImage;
Begin
  // Peek ahead to determine block type
  Repeat
    If (Stream.Read(b, 1) <> 1) Then
      Exit;
  Until (b <> 0); // Ignore 0 padding (non-compliant)

  While (b <> bsTrailer) Do
  Begin
    Stream.Seek(-1, soFromCurrent);
    If (b In [bsExtensionIntroducer, bsImageDescriptor]) Then
    Begin
      SubImage := TGIFSubImage.Create(Parent As TGIFImage);
      Try
        SubImage.LoadFromStream(Stream);
        Add(SubImage);
        Image.Progress(self, psRunning, MulDiv(Stream.Position, 100, Stream.Size),
          GIFImageRenderOnLoad, Rect(0, 0, 0, 0), sProgressLoading);
      Except
        SubImage.Free;
        Raise;
      End;
    End Else
    Begin
      Warning(gsWarning, sBadBlock);
      Break;
    End;
    Repeat
      If (Stream.Read(b, 1) <> 1) Then
        Exit;
    Until (b <> 0); // Ignore 0 padding (non-compliant)
  End;
  Stream.Seek(-1, soFromCurrent);
End;

Procedure TGIFImageList.SaveToStream(Stream: TStream);
Var
  i: integer;
Begin
  For i := 0 To Count - 1 Do
  Begin
    TGIFItem(Items[i]).SaveToStream(Stream);
    Image.Progress(self, psRunning, MulDiv((i + 1), 100, Count), False, Rect(0, 0, 0, 0), sProgressSaving);
  End;
End;

////////////////////////////////////////////////////////////////////////////////
//
//			TGIFPainter
//
////////////////////////////////////////////////////////////////////////////////
Constructor TGIFPainter.CreateRef(Painter: PGIFPainter; AImage: TGIFImage;
  ACanvas: TCanvas; ARect: TRect; Options: TGIFDrawOptions);
Begin
  Create(AImage, ACanvas, ARect, Options);
  PainterRef := Painter;
  If (PainterRef <> Nil) Then
    PainterRef^ := self;
End;

Constructor TGIFPainter.Create(AImage: TGIFImage; ACanvas: TCanvas; ARect: TRect;
  Options: TGIFDrawOptions);
Var
  i: integer;
  BackgroundColor: TColor;
  Disposals: Set Of TDisposalMethod;
Begin
  Inherited Create(True);
  FreeOnTerminate := True;
  Onterminate := DoOnTerminate;
  FImage := AImage;
  FCanvas := ACanvas;
  FRect := ARect;
  FActiveImage := -1;
  FDrawOptions := Options;
  FStarted := False;
  BackupBuffer := Nil;
  FrameBuffer := Nil;
  Background := Nil;
  FEventHandle := 0;
  // This should be a parameter, but I think I've got enough of them already...
  FAnimationSpeed := FImage.AnimationSpeed;

  // An event handle is used for animation delays
  If (FDrawOptions >= [goAnimate, goAsync]) And (FImage.Images.Count > 1) And
    (FAnimationSpeed >= 0) Then
    FEventHandle := CreateEvent(Nil, False, False, Nil);

  // Preprocessing of extensions to determine if we need frame buffers
  Disposals := [];
  If (FImage.DrawBackgroundColor = clNone) Then
  Begin
    If (FImage.GlobalColorMap.Count > 0) Then
      BackgroundColor := FImage.BackgroundColor
    Else
      BackgroundColor := ColorToRGB(clWindow);
  End Else
    BackgroundColor := ColorToRGB(FImage.DrawBackgroundColor);

  // Need background buffer to clear on loop
  If (goClearOnLoop In FDrawOptions) Then
    Include(Disposals, dmBackground);

  For i := 0 To FImage.Images.Count - 1 Do
    If (FImage.Images[i].GraphicControlExtension <> Nil) Then
      With (FImage.Images[i].GraphicControlExtension) Do
        Include(Disposals, Disposal);

  // Need background buffer to draw transparent on background
  If (dmBackground In Disposals) And (goTransparent In FDrawOptions) Then
  Begin
    Background := TBitmap.Create;
    Background.Height := FRect.Bottom - FRect.Top;
    Background.Width := FRect.Right - FRect.Left;
    // Copy background immediately
    Background.Canvas.CopyMode := cmSrcCopy;
    Background.Canvas.CopyRect(Background.Canvas.ClipRect, FCanvas, FRect);
  End;
  // Need frame- and backup buffer to restore to previous and background
  If ((Disposals * [dmPrevious, dmBackground]) <> []) Then
  Begin
    BackupBuffer := TBitmap.Create;
    BackupBuffer.Height := FRect.Bottom - FRect.Top;
    BackupBuffer.Width := FRect.Right - FRect.Left;
    BackupBuffer.Canvas.CopyMode := cmSrcCopy;
    BackupBuffer.Canvas.Brush.Color := BackgroundColor;
    BackupBuffer.Canvas.Brush.Style := bsSolid;
{$IFDEF DEBUG}
    BackupBuffer.Canvas.Brush.Color := clBlack;
    BackupBuffer.Canvas.Brush.Style := bsDiagCross;
{$ENDIF}
    // Step 1: Copy destination to backup buffer
    //         Always executed before first frame and only once.
    BackupBuffer.Canvas.CopyRect(BackupBuffer.Canvas.ClipRect, FCanvas, FRect);
    FrameBuffer := TBitmap.Create;
    FrameBuffer.Height := FRect.Bottom - FRect.Top;
    FrameBuffer.Width := FRect.Right - FRect.Left;
    FrameBuffer.Canvas.CopyMode := cmSrcCopy;
    FrameBuffer.Canvas.Brush.Color := BackgroundColor;
    FrameBuffer.Canvas.Brush.Style := bsSolid;
{$IFDEF DEBUG}
    FrameBuffer.Canvas.Brush.Color := clBlack;
    FrameBuffer.Canvas.Brush.Style := bsDiagCross;
{$ENDIF}
  End;
End;

Destructor TGIFPainter.Destroy;
Begin
  // OnTerminate isn't called if we are running in main thread, so we must call
  // it manually
  If Not (goAsync In DrawOptions) Then
    DoOnTerminate(self);
  // Reraise any exptions that were eaten in the Execute method
  If (ExceptObject <> Nil) Then
    Raise ExceptObject at ExceptAddress;
  Inherited Destroy;
End;

Procedure TGIFPainter.SetAnimationSpeed(Value: integer);
Begin
  If (Value < 0) Then
    Value := 0
  Else If (Value > 1000) Then
    Value := 1000;
  If (Value <> FAnimationSpeed) Then
  Begin
    FAnimationSpeed := Value;
    // Signal WaitForSingleObject delay to abort
    If (FEventHandle <> 0) Then
      SetEvent(FEventHandle)
    Else
      DoRestart := True;
  End;
End;

Procedure TGIFPainter.SetActiveImage(Const Value: integer);
Begin
  If (Value >= 0) And (Value < FImage.Images.Count) Then
    FActiveImage := Value;
End;

// Conditional Synchronize
Procedure TGIFPainter.DoSynchronize(Method: TThreadMethod);
Begin
  If (Terminated) Then
    Exit;
  If (goAsync In FDrawOptions) Then
    // Execute Synchronized if requested...
    Synchronize(Method)
  Else
    // ...Otherwise just execute in current thread (probably main thread)
    Method;
End;

// Delete frame buffers - Executed in main thread
Procedure TGIFPainter.DoOnTerminate(Sender: TObject);
Begin
  // It shouldn't really be nescessary to protect PainterRef in this manner
  // since we are running in the main thread at this point, but I'm a little
  // paranoid about the way PainterRef is being used...
  If Image <> Nil Then // 2001.02.23
  Begin // 2001.02.23
    With Image.Painters.LockList Do
    Try
        // Zap pointer to self and remove from painter list
      If (PainterRef <> Nil) And (PainterRef^ = self) Then
        PainterRef^ := Nil;
    Finally
      Image.Painters.UnlockList;
    End;
    Image.Painters.Remove(self);
    FImage := Nil;
  End; // 2001.02.23

  // Free buffers
  If (BackupBuffer <> Nil) Then
    BackupBuffer.Free;
  If (FrameBuffer <> Nil) Then
    FrameBuffer.Free;
  If (Background <> Nil) Then
    Background.Free;

  // Delete event handle
  If (FEventHandle <> 0) Then
    CloseHandle(FEventHandle);
End;

// Event "dispatcher" - Executed in main thread
Procedure TGIFPainter.DoEvent;
Begin
  If (Assigned(FEvent)) Then
    FEvent(self);
End;

// Non-buffered paint - Executed in main thread
Procedure TGIFPainter.DoPaint;
Begin
  FImage.Images[ActiveImage].Draw(FCanvas, FRect, (goTransparent In FDrawOptions),
    (goTile In FDrawOptions));
  FStarted := True;
End;

// Buffered paint - Executed in main thread
Procedure TGIFPainter.DoPaintFrame;
Var
  DrawDestination: TCanvas;
  DrawRect: TRect;
  DoStep2,
    DoStep3,
    DoStep5,
    DoStep6: Boolean;
  SavePal,
    SourcePal: HPalette;

  Procedure ClearBackup;
  Var
    R,
      Tile: TRect;
    FrameTop,
      FrameHeight: integer;
    ImageWidth,
      ImageHeight: integer;
  Begin

    If (goTransparent In FDrawOptions) Then
    Begin
      // If the frame is transparent, we must remove it by copying the
      // background buffer over it
      If (goTile In FDrawOptions) Then
      Begin
        FrameTop := FImage.Images[ActiveImage].Top;
        FrameHeight := FImage.Images[ActiveImage].Height;
        ImageWidth := FImage.Width;
        ImageHeight := FImage.Height;

        Tile.Left := FRect.Left + FImage.Images[ActiveImage].Left;
        Tile.Right := Tile.Left + FImage.Images[ActiveImage].Width;
        While (Tile.Left < FRect.Right) Do
        Begin
          Tile.Top := FRect.Top + FrameTop;
          Tile.Bottom := Tile.Top + FrameHeight;
          While (Tile.Top < FRect.Bottom) Do
          Begin
            BackupBuffer.Canvas.CopyRect(Tile, Background.Canvas, Tile);
            Tile.Top := Tile.Top + ImageHeight;
            Tile.Bottom := Tile.Bottom + ImageHeight;
          End;
          Tile.Left := Tile.Left + ImageWidth;
          Tile.Right := Tile.Right + ImageWidth;
        End;
      End Else
      Begin
        R := FImage.Images[ActiveImage].ScaleRect(BackupBuffer.Canvas.ClipRect);
        BackupBuffer.Canvas.CopyRect(R, Background.Canvas, R)
      End;
    End Else
    Begin
      // If the frame isn't transparent, we just clear the area covered by
      // it to the background color.
      // Tile the background unless the frame covers all of the image
      If (goTile In FDrawOptions) And
        ((FImage.Width <> FImage.Images[ActiveImage].Width) And
        (FImage.Height <> FImage.Images[ActiveImage].Height)) Then
      Begin
        FrameTop := FImage.Images[ActiveImage].Top;
        FrameHeight := FImage.Images[ActiveImage].Height;
        ImageWidth := FImage.Width;
        ImageHeight := FImage.Height;
        // ***FIXME*** I don't think this does any difference
        BackupBuffer.Canvas.Brush.Color := FImage.DrawBackgroundColor;

        Tile.Left := FRect.Left + FImage.Images[ActiveImage].Left;
        Tile.Right := Tile.Left + FImage.Images[ActiveImage].Width;
        While (Tile.Left < FRect.Right) Do
        Begin
          Tile.Top := FRect.Top + FrameTop;
          Tile.Bottom := Tile.Top + FrameHeight;
          While (Tile.Top < FRect.Bottom) Do
          Begin
            BackupBuffer.Canvas.FillRect(Tile);

            Tile.Top := Tile.Top + ImageHeight;
            Tile.Bottom := Tile.Bottom + ImageHeight;
          End;
          Tile.Left := Tile.Left + ImageWidth;
          Tile.Right := Tile.Right + ImageWidth;
        End;
      End Else
        BackupBuffer.Canvas.FillRect(FImage.Images[ActiveImage].ScaleRect(FRect));
    End;
  End;

Begin
  If (goValidateCanvas In FDrawOptions) Then
    If (GetObjectType(ValidateDC) <> OBJ_DC) Then
    Begin
      Terminate;
      Exit;
    End;

  DrawDestination := Nil;
  DoStep2 := (goClearOnLoop In FDrawOptions) And (FActiveImage = 0);
  DoStep3 := False;
  DoStep5 := False;
  DoStep6 := False;
{
Disposal mode algorithm:

Step 1: Copy destination to backup buffer
        Always executed before first frame and only once.
        Done in constructor.
Step 2: Clear previous frame (implementation is same as step 6)
        Done implicitly by implementation.
        Only done explicitly on first frame if goClearOnLoop option is set.
Step 3: Copy backup buffer to frame buffer
Step 4: Draw frame
Step 5: Copy buffer to destination
Step 6: Clear frame from backup buffer
+------------+------------------+---------------------+------------------------+
|New  \  Old |  dmNone          |  dmBackground       |  dmPrevious            |
+------------+------------------+---------------------+------------------------+
|dmNone      |                  |                     |                        |
|            |4. Paint on backup|4. Paint on backup   |4. Paint on backup      |
|            |5. Restore        |5. Restore           |5. Restore              |
+------------+------------------+---------------------+------------------------+
|dmBackground|                  |                     |                        |
|            |4. Paint on backup|4. Paint on backup   |4. Paint on backup      |
|            |5. Restore        |5. Restore           |5. Restore              |
|            |6. Clear backup   |6. Clear backup      |6. Clear backup         |
+------------+------------------+---------------------+------------------------+
|dmPrevious  |                  |                     |                        |
|            |                  |3. Copy backup to buf|3. Copy backup to buf   |
|            |4. Paint on dest  |4. Paint on buf      |4. Paint on buf         |
|            |                  |5. Copy buf to dest  |5. Copy buf to dest     |
+------------+------------------+---------------------+------------------------+
}
  Case (Disposal) Of
    dmNone, dmNoDisposal:
      Begin
        DrawDestination := BackupBuffer.Canvas;
        DrawRect := BackupBuffer.Canvas.ClipRect;
        DoStep5 := True;
      End;
    dmBackground:
      Begin
        DrawDestination := BackupBuffer.Canvas;
        DrawRect := BackupBuffer.Canvas.ClipRect;
        DoStep5 := True;
        DoStep6 := True;
      End;
    dmPrevious:
      Case (OldDisposal) Of
        dmNone, dmNoDisposal:
          Begin
            DrawDestination := FCanvas;
            DrawRect := FRect;
          End;
        dmBackground, dmPrevious:
          Begin
            DrawDestination := FrameBuffer.Canvas;
            DrawRect := FrameBuffer.Canvas.ClipRect;
            DoStep3 := True;
            DoStep5 := True;
          End;
      End;
  End;

  // Find source palette
  SourcePal := FImage.Images[ActiveImage].Palette;
  If (SourcePal = 0) Then
    SourcePal := SystemPalette16; // This should never happen

  SavePal := SelectPalette(DrawDestination.Handle, SourcePal, False);
  RealizePalette(DrawDestination.Handle);

  // Step 2: Clear previous frame
  If (DoStep2) Then
    ClearBackup;

  // Step 3: Copy backup buffer to frame buffer
  If (DoStep3) Then
    FrameBuffer.Canvas.CopyRect(FrameBuffer.Canvas.ClipRect,
      BackupBuffer.Canvas, BackupBuffer.Canvas.ClipRect);

  // Step 4: Draw frame
  If (DrawDestination <> Nil) Then
    FImage.Images[ActiveImage].Draw(DrawDestination, DrawRect,
      (goTransparent In FDrawOptions), (goTile In FDrawOptions));

  // Step 5: Copy buffer to destination
  If (DoStep5) Then
  Begin
    FCanvas.CopyMode := cmSrcCopy;
    FCanvas.CopyRect(FRect, DrawDestination, DrawRect);
  End;

  If (SavePal <> 0) Then
    SelectPalette(DrawDestination.Handle, SavePal, False);

  // Step 6: Clear frame from backup buffer
  If (DoStep6) Then
    ClearBackup;

  FStarted := True;
End;

// Prefetch bitmap
// Used to force the GIF image to be rendered as a bitmap
{$IFDEF SERIALIZE_RENDER}
Procedure TGIFPainter.PrefetchBitmap;
Begin
  // Touch current bitmap to force bitmap to be rendered
  If Not ((FImage.Images[ActiveImage].Empty) Or (FImage.Images[ActiveImage].HasBitmap)) Then
    FImage.Images[ActiveImage].Bitmap;
End;
{$ENDIF}

// Main thread execution loop - This is where it all happens...
Procedure TGIFPainter.Execute;
Var
  i: integer;
  LoopCount,
    LoopPoint: integer;
  Looping: Boolean;
  Ext: TGIFExtension;
  Msg: TMsg;
  Delay,
    OldDelay,
    DelayUsed: longInt;
  DelayStart,
    NewDelayStart: DWORD;

  Procedure FireEvent(Event: TNotifyEvent);
  Begin
    If Not (Assigned(Event)) Then
      Exit;
    FEvent := Event;
    Try
      DoSynchronize(DoEvent);
    Finally
      FEvent := Nil;
    End;
  End;

Begin
{
  Disposal:
    dmNone: Same as dmNodisposal
    dmNoDisposal: Do not dispose
    dmBackground: Clear with background color *)
    dmPrevious: Previous image
    *) Note: Background color should either be a BROWSER SPECIFIED Background
       color (DrawBackgroundColor) or the background image if any frames are
       transparent.
}
  Try
    Try
      If (goValidateCanvas In FDrawOptions) Then
        ValidateDC := FCanvas.Handle;
      DoRestart := True;

      // Loop to restart paint
      While (DoRestart) And Not (Terminated) Do
      Begin
        FActiveImage := 0;
        // Fire OnStartPaint event
        // Note: ActiveImage may be altered by the event handler
        FireEvent(FOnStartPaint);

        FStarted := False;
        DoRestart := False;
        LoopCount := 1;
        LoopPoint := FActiveImage;
        Looping := False;
        If (goAsync In DrawOptions) Then
          Delay := 0
        Else
          Delay := 1; // Dummy to process messages
        OldDisposal := dmNoDisposal;
        // Fetch delay start time
        DelayStart := timeGetTime;
        OldDelay := 0;

        // Loop to loop - duh!
        While ((LoopCount <> 0) Or (goLoopContinously In DrawOptions)) And
          Not (Terminated Or DoRestart) Do
        Begin
          FActiveImage := LoopPoint;

          // Fire OnLoopPaint event
          // Note: ActiveImage may be altered by the event handler
          If (FStarted) Then
            FireEvent(FOnLoop);

          // Loop to animate
          While (ActiveImage < FImage.Images.Count) And Not (Terminated Or DoRestart) Do
          Begin
            // Ignore empty images
            If (FImage.Images[ActiveImage].Empty) Then
              Break;
            // Delay from previous image
            If (Delay > 0) Then
            Begin
              // Prefetch frame bitmap
{$IFDEF SERIALIZE_RENDER}
              DoSynchronize(PrefetchBitmap);
{$ELSE}
              FImage.Images[ActiveImage].Bitmap;
{$ENDIF}

              // Calculate inter frame delay
              NewDelayStart := timeGetTime;
              If (FAnimationSpeed > 0) Then
              Begin
                // Calculate number of mS used in prefetch and display
                Try
                  DelayUsed := integer(NewDelayStart - DelayStart) - OldDelay;
                  // Prevent feedback oscillations caused by over/undercompensation.
                  DelayUsed := DelayUsed Div 2;
                  // Convert delay value to mS and...
                  // ...Adjust for time already spent converting GIF to bitmap and...
                  // ...Adjust for Animation Speed factor.
                  Delay := MulDiv(Delay * GIFDelayExp - DelayUsed, 100, FAnimationSpeed);
                  OldDelay := Delay;
                Except
                  Delay := GIFMaximumDelay * GIFDelayExp;
                  OldDelay := 0;
                End;
              End Else
              Begin
                If (goAsync In DrawOptions) Then
                  Delay := longInt(INFINITE)
                Else
                  Delay := GIFMaximumDelay * GIFDelayExp;
              End;
              // Fetch delay start time
              DelayStart := NewDelayStart;

              // Sleep in one chunk if we are running in a thread
              If (goAsync In DrawOptions) Then
              Begin
                // Use of WaitForSingleObject allows TGIFPainter.Stop to wake us up
                If (Delay > 0) Or (FAnimationSpeed = 0) Then
                Begin
                  If (WaitForSingleObject(FEventHandle, DWORD(Delay)) <> WAIT_TIMEOUT) Then
                  Begin
                    // Don't use interframe delay feedback adjustment if delay
                    // were prematurely aborted (e.g. because the animation
                    // speed were changed)
                    OldDelay := 0;
                    DelayStart := longInt(timeGetTime);
                  End;
                End;
              End Else
              Begin
                If (Delay <= 0) Then
                  Delay := 1;
                // Fetch start time
                NewDelayStart := timeGetTime;
                // If we are not running in a thread we Sleep in small chunks
                // and give the user a chance to abort
                While (Delay > 0) And Not (Terminated Or DoRestart) Do
                Begin
                  If (Delay < 100) Then
                    Sleep(Delay)
                  Else
                    Sleep(100);
                  // Calculate number of mS delayed in this chunk
                  DelayUsed := integer(timeGetTime - NewDelayStart);
                  Dec(Delay, DelayUsed);
                  // Reset start time for chunk
                  NewDelayStart := timeGetTime;
                  // Application.ProcessMessages wannabe
                  While (Not (Terminated Or DoRestart)) And
                    (PeekMessage(Msg, 0, 0, 0, PM_REMOVE)) Do
                  Begin
                    If (Msg.Message <> WM_QUIT) Then
                    Begin
                      TranslateMessage(Msg);
                      DispatchMessage(Msg);
                    End Else
                    Begin
                      // Put WM_QUIT back in queue and get out of here fast
                      PostQuitMessage(Msg.WParam);
                      Terminate;
                    End;
                  End;
                End;
              End;
            End Else
              Sleep(0); // Yield
            If (Terminated) Then
              Break;

            // Fire OnPaint event
            // Note: ActiveImage may be altered by the event handler
            FireEvent(FOnPaint);
            If (Terminated) Then
              Break;

            // Pre-draw processing of extensions
            Disposal := dmNoDisposal;
            For i := 0 To FImage.Images[ActiveImage].Extensions.Count - 1 Do
            Begin
              Ext := FImage.Images[ActiveImage].Extensions[i];
              If (Ext Is TGIFAppExtNSLoop) Then
              Begin
                // Recursive loops not supported (or defined)
                If (Looping) Then
                  Continue;
                Looping := True;
                LoopCount := TGIFAppExtNSLoop(Ext).Loops;
                If ((LoopCount = 0) Or (goLoopContinously In DrawOptions)) And
                  (goAsync In DrawOptions) Then
                  LoopCount := -1; // Infinite if running in separate thread
{$IFNDEF STRICT_MOZILLA}
                // Loop from this image and on
                // Note: This is not standard behavior
                LoopPoint := ActiveImage;
{$ENDIF}
              End Else
                If (Ext Is TGIFGraphicControlExtension) Then
                  Disposal := TGIFGraphicControlExtension(Ext).Disposal;
            End;

            // Paint the image
            If (BackupBuffer <> Nil) Then
              DoSynchronize(DoPaintFrame)
            Else
              DoSynchronize(DoPaint);
            OldDisposal := Disposal;

            If (Terminated) Then
              Break;

            Delay := GIFDefaultDelay; // Default delay
            // Post-draw processing of extensions
            If (FImage.Images[ActiveImage].GraphicControlExtension <> Nil) Then
              If (FImage.Images[ActiveImage].GraphicControlExtension.Delay > 0) Then
              Begin
                Delay := FImage.Images[ActiveImage].GraphicControlExtension.Delay;

                // Enforce minimum animation delay in compliance with Mozilla
                If (Delay < GIFMinimumDelay) Then
                  Delay := GIFMinimumDelay;

                // Do not delay more than 10 seconds if running in main thread
                If (Delay > GIFMaximumDelay) And Not (goAsync In DrawOptions) Then
                  Delay := GIFMaximumDelay; // Max 10 seconds
              End;
            // Fire OnAfterPaint event
            // Note: ActiveImage may be altered by the event handler
            i := FActiveImage;
            FireEvent(FOnAfterPaint);
            If (Terminated) Then
              Break;
            // Don't increment frame counter if event handler modified
            // current frame
            If (FActiveImage = i) Then
              inc(FActiveImage);
            // Nothing more to do unless we are animating
            If Not (goAnimate In DrawOptions) Then
              Break;
          End;

          If (LoopCount > 0) Then
            Dec(LoopCount);
          If ([goAnimate, goLoop] * DrawOptions <> [goAnimate, goLoop]) Then
            Break;
        End;
        If (Terminated) Then // 2001.07.23
          Break; // 2001.07.23
      End;
      FActiveImage := -1;
      // Fire OnEndPaint event
      FireEvent(FOnEndPaint);
    Finally
      // If we are running in the main thread we will have to zap our self
      If Not (goAsync In DrawOptions) Then
        Free;
    End;
  Except
    On E: Exception Do
    Begin
      // Eat exception and terminate thread...
      // If we allow the exception to abort the thread at this point, the
      // application will hang since the thread destructor will never be called
      // and the application will wait forever for the thread to die!
      Terminate;
      // Clone exception
      ExceptObject := E.Create(E.Message);
      ExceptAddress := ExceptAddr;
    End;
  End;
End;

Procedure TGIFPainter.Start;
Begin
  If (goAsync In FDrawOptions) Then
    Resume;
End;

Procedure TGIFPainter.Stop;
Begin
  Terminate;
  If (goAsync In FDrawOptions) Then
  Begin
    // Signal WaitForSingleObject delay to abort
    If (FEventHandle <> 0) Then
      SetEvent(FEventHandle);
    Priority := tpNormal;
    If (Suspended) Then
      Resume; // Must be running before we can terminate
  End;
End;

Procedure TGIFPainter.Restart;
Begin
  DoRestart := True;
  If (Suspended) And (goAsync In FDrawOptions) Then
    Resume; // Must be running before we can terminate
End;

////////////////////////////////////////////////////////////////////////////////
//
//			TColorMapOptimizer
//
////////////////////////////////////////////////////////////////////////////////
// Used by TGIFImage to optimize local color maps to a single global color map.
// The following algorithm is used:
// 1) Build a histogram for each image
// 2) Merge histograms
// 3) Sum equal colors and adjust max # of colors
// 4) Map entries > max to entries <= 256
// 5) Build new color map
// 6) Map images to new color map
////////////////////////////////////////////////////////////////////////////////

Type

  POptimizeEntry = ^TOptimizeEntry;
  TColorRec = Record
    Case Byte Of
      0: (Value: integer);
      1: (Color: TGIFColor);
      2: (SameAs: POptimizeEntry); // Used if TOptimizeEntry.Count = 0
  End;

  TOptimizeEntry = Record
    Count: integer; // Usage count
    OldIndex: integer; // Color OldIndex
    NewIndex: integer; // NewIndex color OldIndex
    Color: TColorRec; // Color value
  End;

  TOptimizeEntries = Array[0..255] Of TOptimizeEntry;
  POptimizeEntries = ^TOptimizeEntries;

  THistogram = Class(TObject)
  Private
    PHistogram: POptimizeEntries;
    FCount: integer;
    FColorMap: TGIFColorMap;
    FList: TList;
    FImages: TList;
  Public
    Constructor Create(AColorMap: TGIFColorMap);
    Destructor Destroy; Override;
    Function ProcessSubImage(Image: TGIFSubImage): Boolean;
    Function Prune: integer;
    Procedure MapImages(UseTransparency: Boolean; NewTransparentColorIndex: Byte);
    Property Count: integer Read FCount;
    Property ColorMap: TGIFColorMap Read FColorMap;
    Property List: TList Read FList;
  End;

  TColorMapOptimizer = Class(TObject)
  Private
    FImage: TGIFImage;
    FHistogramList: TList;
    FHistogram: TList;
    FColorMap: TColorMap;
    FFinalCount: integer;
    FUseTransparency: Boolean;
    FNewTransparentColorIndex: Byte;
  Protected
    Procedure ProcessImage;
    Procedure MergeColors;
    Procedure MapColors;
    Procedure ReplaceColorMaps;
  Public
    Constructor Create(AImage: TGIFImage);
    Destructor Destroy; Override;
    Procedure Optimize;
  End;

Function CompareColor(Item1, Item2: Pointer): integer;
Begin
  Result := POptimizeEntry(Item2)^.Color.Value - POptimizeEntry(Item1)^.Color.Value;
End;

Function CompareCount(Item1, Item2: Pointer): integer;
Begin
  Result := POptimizeEntry(Item2)^.Count - POptimizeEntry(Item1)^.Count;
End;

Constructor THistogram.Create(AColorMap: TGIFColorMap);
Var
  i: integer;
Begin
  Inherited Create;

  FCount := AColorMap.Count;
  FColorMap := AColorMap;

  FImages := TList.Create;

  // Allocate memory for histogram
  GetMem(PHistogram, FCount * SizeOf(TOptimizeEntry));
  FList := TList.Create;

  FList.Capacity := FCount;

  // Move data to histogram and initialize
  For i := 0 To FCount - 1 Do
    With PHistogram^[i] Do
    Begin
      FList.Add(@PHistogram^[i]);
      OldIndex := i;
      Count := 0;
      Color.Value := 0;
      Color.Color := AColorMap.Data^[i];
      NewIndex := 256; // Used to signal unmapped
    End;
End;

Destructor THistogram.Destroy;
Begin
  FImages.Free;
  FList.Free;
  FreeMem(PHistogram);
  Inherited Destroy;
End;

//: Build a color histogram
Function THistogram.ProcessSubImage(Image: TGIFSubImage): Boolean;
Var
  Size: integer;
  Pixel: PChar;
  IsTransparent,
    WasTransparent: Boolean;
  OldTransparentColorIndex: Byte;
Begin
  Result := False;
  If (Image.Empty) Then
    Exit;

  FImages.Add(Image);

  Pixel := Image.Data;
  Size := Image.Width * Image.Height;

  IsTransparent := Image.Transparent;
  If (IsTransparent) Then
    OldTransparentColorIndex := Image.GraphicControlExtension.TransparentColorIndex
  Else
    OldTransparentColorIndex := 0; // To avoid compiler warning
  WasTransparent := False;

  (*
  ** Sum up usage count for each color
  *)
  While (Size > 0) Do
  Begin
    // Ignore transparent pixels
    If (Not IsTransparent) Or (Ord(Pixel^) <> OldTransparentColorIndex) Then
    Begin
      // Check for invalid color index
      If (Ord(Pixel^) >= FCount) Then
      Begin
        Pixel^ := #0; // ***FIXME*** Isn't this an error condition?
        Image.Warning(gsWarning, sInvalidColor);
      End;

      With PHistogram^[Ord(Pixel^)] Do
      Begin
        // Stop if any color reaches the max count
        If (Count = High(integer)) Then
          Break;
        inc(Count);
      End;
    End Else
      WasTransparent := WasTransparent Or IsTransparent;
    inc(Pixel);
    Dec(Size);
  End;

  (*
  ** Clear frames transparency flag if the frame claimed to
  ** be transparent, but wasn't
  *)
  If (IsTransparent And Not WasTransparent) Then
  Begin
    Image.GraphicControlExtension.TransparentColorIndex := 0;
    Image.GraphicControlExtension.Transparent := False;
  End;

  Result := WasTransparent;
End;

//: Removed unused color entries from the histogram
Function THistogram.Prune: integer;
Var
  i, j: integer;
Begin
  (*
  **  Sort by usage count
  *)
  FList.Sort(CompareCount);

  (*
  **  Determine number of used colors
  *)
  For i := 0 To FCount - 1 Do
    // Find first unused color entry
    If (POptimizeEntry(FList[i])^.Count = 0) Then
    Begin
      // Zap unused colors
      For j := i To FCount - 1 Do
        POptimizeEntry(FList[j])^.Count := -1; // Use -1 to signal unused entry
      // Remove unused entries
      FCount := i;
      FList.Count := FCount;
      Break;
    End;

  Result := FCount;
End;

//: Convert images from old color map to new color map
Procedure THistogram.MapImages(UseTransparency: Boolean; NewTransparentColorIndex: Byte);
Var
  i: integer;
  Size: integer;
  Pixel: PChar;
  ReverseMap: Array[Byte] Of Byte;
  IsTransparent: Boolean;
  OldTransparentColorIndex: Byte;
Begin
  (*
  ** Build NewIndex map
  *)
  For i := 0 To List.Count - 1 Do
    ReverseMap[POptimizeEntry(List[i])^.OldIndex] := POptimizeEntry(List[i])^.NewIndex;

  (*
  **  Reorder all images using this color map
  *)
  For i := 0 To FImages.Count - 1 Do
    With TGIFSubImage(FImages[i]) Do
    Begin
      Pixel := Data;
      Size := Width * Height;

      // Determine frame transparency
      IsTransparent := (Transparent) And (UseTransparency);
      If (IsTransparent) Then
      Begin
        OldTransparentColorIndex := GraphicControlExtension.TransparentColorIndex;
        // Map transparent color
        GraphicControlExtension.TransparentColorIndex := NewTransparentColorIndex;
      End Else
        OldTransparentColorIndex := 0; // To avoid compiler warning

      // Map all pixels to new color map
      While (Size > 0) Do
      Begin
        // Map transparent pixels to the new transparent color index and...
        If (IsTransparent) And (Ord(Pixel^) = OldTransparentColorIndex) Then
          Pixel^ := char(NewTransparentColorIndex)
        Else
          // ... all other pixels to their new color index
          Pixel^ := char(ReverseMap[Ord(Pixel^)]);
        Dec(Size);
        inc(Pixel);
      End;
    End;
End;

Constructor TColorMapOptimizer.Create(AImage: TGIFImage);
Begin
  Inherited Create;
  FImage := AImage;
  FHistogramList := TList.Create;
  FHistogram := TList.Create;
End;

Destructor TColorMapOptimizer.Destroy;
Var
  i: integer;
Begin
  FHistogram.Free;

  For i := FHistogramList.Count - 1 Downto 0 Do
    THistogram(FHistogramList[i]).Free;
  FHistogramList.Free;

  Inherited Destroy;
End;

Procedure TColorMapOptimizer.ProcessImage;
Var
  Hist: THistogram;
  i: integer;
  ProcessedImage: Boolean;
Begin
  FUseTransparency := False;
  (*
  ** First process images using global color map
  *)
  If (FImage.GlobalColorMap.Count > 0) Then
  Begin
    Hist := THistogram.Create(FImage.GlobalColorMap);
    ProcessedImage := False;
    // Process all images that are using the global color map
    For i := 0 To FImage.Images.Count - 1 Do
      If (FImage.Images[i].ColorMap.Count = 0) And (Not FImage.Images[i].Empty) Then
      Begin
        ProcessedImage := True;
      // Note: Do not change order of statements. Shortcircuit evaluation not desired!
        FUseTransparency := Hist.ProcessSubImage(FImage.Images[i]) Or FUseTransparency;
      End;
    // Keep the histogram if any images used the global color map...
    If (ProcessedImage) Then
      FHistogramList.Add(Hist)
    Else // ... otherwise delete it
      Hist.Free;
  End;

  (*
  ** Next process images that have a local color map
  *)
  For i := 0 To FImage.Images.Count - 1 Do
    If (FImage.Images[i].ColorMap.Count > 0) And (Not FImage.Images[i].Empty) Then
    Begin
      Hist := THistogram.Create(FImage.Images[i].ColorMap);
      FHistogramList.Add(Hist);
      // Note: Do not change order of statements. Shortcircuit evaluation not desired!
      FUseTransparency := Hist.ProcessSubImage(FImage.Images[i]) Or FUseTransparency;
    End;
End;

Procedure TColorMapOptimizer.MergeColors;
Var
  Entry, SameEntry: POptimizeEntry;
  i: integer;
Begin
  (*
  **  Sort by color value
  *)
  FHistogram.Sort(CompareColor);

  (*
  **  Merge same colors
  *)
  SameEntry := POptimizeEntry(FHistogram[0]);
  For i := 1 To FHistogram.Count - 1 Do
  Begin
    Entry := POptimizeEntry(FHistogram[i]);
    ASSERT(Entry^.Count > 0, 'Unused entry exported from THistogram');
    If (Entry^.Color.Value = SameEntry^.Color.Value) Then
    Begin
      // Transfer usage count to first entry
      inc(SameEntry^.Count, Entry^.Count);
      Entry^.Count := 0; // Use 0 to signal merged entry
      Entry^.Color.SameAs := SameEntry; // Point to master
    End Else
      SameEntry := Entry;
  End;
End;

Procedure TColorMapOptimizer.MapColors;
Var
  i, j: integer;
  Delta, BestDelta: integer;
  BestIndex: integer;
  MaxColors: integer;
Begin
  (*
  **  Sort by usage count
  *)
  FHistogram.Sort(CompareCount);

  (*
  ** Handle transparency
  *)
  If (FUseTransparency) Then
    MaxColors := 255
  Else
    MaxColors := 256;

  (*
  **  Determine number of colors used (max 256)
  *)
  FFinalCount := FHistogram.Count;
  For i := 0 To FFinalCount - 1 Do
    If (i >= MaxColors) Or (POptimizeEntry(FHistogram[i])^.Count = 0) Then
    Begin
      FFinalCount := i;
      Break;
    End;

  (*
  **  Build color map and reverse map for final entries
  *)
  For i := 0 To FFinalCount - 1 Do
  Begin
    POptimizeEntry(FHistogram[i])^.NewIndex := i;
    FColorMap[i] := POptimizeEntry(FHistogram[i])^.Color.Color;
  End;

  (*
  **  Map colors > 256 to colors <= 256 and build NewIndex color map
  *)
  For i := FFinalCount To FHistogram.Count - 1 Do
    With POptimizeEntry(FHistogram[i])^ Do
    Begin
      // Entries with a usage count of -1 is unused
      ASSERT(Count <> -1, 'Internal error: Unused entry exported');
      // Entries with a usage count of 0 has been merged with another entry
      If (Count = 0) Then
      Begin
        // Use mapping of master entry
        ASSERT(Color.SameAs.NewIndex < 256, 'Internal error: Mapping to unmapped color');
        NewIndex := Color.SameAs.NewIndex;
      End Else
      Begin
        // Search for entry with nearest color value
        BestIndex := 0;
        BestDelta := 255 * 3;
        For j := 0 To FFinalCount - 1 Do
        Begin
          Delta := abs((POptimizeEntry(FHistogram[j])^.Color.Color.Red - Color.Color.Red) +
            (POptimizeEntry(FHistogram[j])^.Color.Color.Green - Color.Color.Green) +
            (POptimizeEntry(FHistogram[j])^.Color.Color.Blue - Color.Color.Blue));
          If (Delta < BestDelta) Then
          Begin
            BestDelta := Delta;
            BestIndex := j;
          End;
        End;
        NewIndex := POptimizeEntry(FHistogram[BestIndex])^.NewIndex; ;
      End;
    End;

  (*
  ** Add transparency color to new color map
  *)
  If (FUseTransparency) Then
  Begin
    FNewTransparentColorIndex := FFinalCount;
    FColorMap[FFinalCount].Red := 0;
    FColorMap[FFinalCount].Green := 0;
    FColorMap[FFinalCount].Blue := 0;
    inc(FFinalCount);
  End;
End;

Procedure TColorMapOptimizer.ReplaceColorMaps;
Var
  i: integer;
Begin
  // Zap all local color maps
  For i := 0 To FImage.Images.Count - 1 Do
    If (FImage.Images[i].ColorMap <> Nil) Then
      FImage.Images[i].ColorMap.Clear;
  // Store optimized global color map
  FImage.GlobalColorMap.ImportColorMap(FColorMap, FFinalCount);
  FImage.GlobalColorMap.Optimized := True;
End;

Procedure TColorMapOptimizer.Optimize;
Var
  Total: integer;
  i, j: integer;
Begin
  // Stop all painters during optimize...
  FImage.PaintStop;
  // ...and prevent any new from starting while we are doing our thing
  FImage.Painters.LockList;
  Try

    (*
    **  Process all sub images
    *)
    ProcessImage;

    // Prune histograms and calculate total number of colors
    Total := 0;
    For i := 0 To FHistogramList.Count - 1 Do
      inc(Total, THistogram(FHistogramList[i]).Prune);

    // Allocate global histogram
    FHistogram.Clear;
    FHistogram.Capacity := Total;

    // Move data pointers from local histograms to global histogram
    For i := 0 To FHistogramList.Count - 1 Do
      With THistogram(FHistogramList[i]) Do
        For j := 0 To Count - 1 Do
        Begin
          ASSERT(POptimizeEntry(List[j])^.Count > 0, 'Unused entry exported from THistogram');
          FHistogram.Add(List[j]);
        End;

    (*
    **  Merge same colors
    *)
    MergeColors;

    (*
    **  Build color map and NewIndex map for final entries
    *)
    MapColors;

    (*
    **  Replace local colormaps with global color map
    *)
    ReplaceColorMaps;

    (*
    **  Process images for each color map
    *)
    For i := 0 To FHistogramList.Count - 1 Do
      THistogram(FHistogramList[i]).MapImages(FUseTransparency, FNewTransparentColorIndex);

    (*
    **  Delete the frame's old bitmaps and palettes
    *)
    For i := 0 To FImage.Images.Count - 1 Do
    Begin
      FImage.Images[i].HasBitmap := False;
      FImage.Images[i].Palette := 0;
    End;

  Finally
    FImage.Painters.UnlockList;
  End;
End;

////////////////////////////////////////////////////////////////////////////////
//
//			TGIFImage
//
////////////////////////////////////////////////////////////////////////////////
Constructor TGIFImage.Create;
Begin
  Inherited Create;
  FImages := TGIFImageList.Create(self);
  FHeader := TGIFHeader.Create(self);
  FPainters := TThreadList.Create;
  FGlobalPalette := 0;
  // Load defaults
  FDrawOptions := GIFImageDefaultDrawOptions;
  ColorReduction := GIFImageDefaultColorReduction;
  FReductionBits := GIFImageDefaultColorReductionBits;
  FDitherMode := GIFImageDefaultDitherMode;
  FCompression := GIFImageDefaultCompression;
  FThreadPriority := GIFImageDefaultThreadPriority;
  FAnimationSpeed := GIFImageDefaultAnimationSpeed;

  FDrawBackgroundColor := clNone;
  IsDrawing := False;
  IsInsideGetPalette := False;
  FForceFrame := -1; // 2004.03.09
  NewImage;
End;

Destructor TGIFImage.Destroy;
Var
  i: integer;
Begin
  PaintStop;
  With FPainters.LockList Do
  Try
    For i := Count - 1 Downto 0 Do
      TGIFPainter(Items[i]).FImage := Nil;
  Finally
    FPainters.UnlockList;
  End;

  Clear;
  FPainters.Free;
  FImages.Free;
  FHeader.Free;
  Inherited Destroy;
End;

Procedure TGIFImage.Clear;
Begin
  PaintStop;
  FreeBitmap;
  FImages.Clear;
  FHeader.ColorMap.Clear;
  FHeader.Height := 0;
  FHeader.Width := 0;
  FHeader.Prepare;
  Palette := 0;
End;

Procedure TGIFImage.NewImage;
Begin
  Clear;
End;

Function TGIFImage.GetVersion: TGIFVersion;
Var
  v: TGIFVersion;
  i: integer;
Begin
  Result := gvUnknown;
  For i := 0 To FImages.Count - 1 Do
  Begin
    v := FImages[i].Version;
    If (v > Result) Then
      Result := v;
    If (v >= High(TGIFVersion)) Then
      Break;
  End;
End;

Function TGIFImage.GetColorResolution: integer;
Var
  i: integer;
Begin
  Result := FHeader.ColorResolution;
  For i := 0 To FImages.Count - 1 Do
    If (FImages[i].ColorResolution > Result) Then
      Result := FImages[i].ColorResolution;
End;

Function TGIFImage.GetBitsPerPixel: integer;
Var
  i: integer;
Begin
  Result := FHeader.BitsPerPixel;
  For i := 0 To FImages.Count - 1 Do
    If (FImages[i].BitsPerPixel > Result) Then
      Result := FImages[i].BitsPerPixel;
End;

Function TGIFImage.GetBackgroundColorIndex: Byte;
Begin
  Result := FHeader.BackgroundColorIndex;
End;

Procedure TGIFImage.SetBackgroundColorIndex(Const Value: Byte);
Begin
  FHeader.BackgroundColorIndex := Value;
End;

Function TGIFImage.GetBackgroundColor: TColor;
Begin
  Result := FHeader.BackgroundColor;
End;

Procedure TGIFImage.SetBackgroundColor(Const Value: TColor);
Begin
  FHeader.BackgroundColor := Value;
End;

Function TGIFImage.GetAspectRatio: Byte;
Begin
  Result := FHeader.AspectRatio;
End;

Procedure TGIFImage.SetAspectRatio(Const Value: Byte);
Begin
  FHeader.AspectRatio := Value;
End;

Procedure TGIFImage.SetDrawOptions(Value: TGIFDrawOptions);
Begin
  If (FDrawOptions = Value) Then
    Exit;

  If (DrawPainter <> Nil) Then
    DrawPainter.Stop;

  FDrawOptions := Value;
  // Zap all bitmaps
  Pack;
  Changed(self);
End;

Function TGIFImage.GetAnimate: Boolean;
Begin // 2002.07.07
  Result := goAnimate In DrawOptions;
End;

Procedure TGIFImage.SetAnimate(Const Value: Boolean);
Begin // 2002.07.07
  If Value Then
    DrawOptions := DrawOptions + [goAnimate]
  Else
    DrawOptions := DrawOptions - [goAnimate];
End;

Procedure TGIFImage.SetForceFrame(Const Value: integer);
Begin // 2004.03.09
  FForceFrame := Value;
  Changed(self);
End;

Procedure TGIFImage.SetAnimationSpeed(Value: integer);
Begin
  If (Value < 0) Then
    Value := 0
  Else If (Value > 1000) Then
    Value := 1000;
  If (Value <> FAnimationSpeed) Then
  Begin
    FAnimationSpeed := Value;
    // Use the FPainters threadlist to protect FDrawPainter from being modified
    // by the thread while we mess with it
    With FPainters.LockList Do
    Try
      If (FDrawPainter <> Nil) Then
        FDrawPainter.AnimationSpeed := FAnimationSpeed;
    Finally
        // Release the lock on FPainters to let paint thread kill itself
      FPainters.UnlockList;
    End;
  End;
End;

Procedure TGIFImage.SetReductionBits(Value: integer);
Begin
  If (Value < 3) Or (Value > 8) Then
    Error(sInvalidBitSize);
  FReductionBits := Value;
End;

Procedure TGIFImage.OptimizeColorMap;
Var
  ColorMapOptimizer: TColorMapOptimizer;
Begin
  ColorMapOptimizer := TColorMapOptimizer.Create(self);
  Try
    ColorMapOptimizer.Optimize;
  Finally
    ColorMapOptimizer.Free;
  End;
End;

Procedure TGIFImage.Optimize(Options: TGIFOptimizeOptions;
  ColorReduction: TColorReduction; DitherMode: TDitherMode;
  ReductionBits: integer);
Var
  i,
    j: integer;
  Delay: integer;
  GCE: TGIFGraphicControlExtension;
  ThisRect,
    NextRect,
    MergeRect: TRect;
  Prog,
    MaxProg: integer;

  Function Scan(Buf: PChar; Value: Byte; Count: integer): Boolean; Assembler;
  Asm
    PUSH	EDI
    MOV		EDI, Buf
    MOV		ECX, Count
    MOV		AL, Value
    REPNE	SCASB
    MOV		EAX, False
    JNE		@@1
    MOV		EAX, True
@@1:POP		EDI
  End;

Begin
  If (Empty) Then
    Exit;
  // Stop all painters during optimize...
  PaintStop;
  // ...and prevent any new from starting while we are doing our thing
  FPainters.LockList;
  Try
    Progress(self, psStarting, 0, False, Rect(0, 0, 0, 0), sProgressOptimizing);
    Try

      Prog := 0;
      MaxProg := Images.Count * 6;

      // Sort color map by usage and remove unused entries
      If (ooColorMap In Options) Then
      Begin
        // Optimize global color map
        If (GlobalColorMap.Count > 0) Then
          GlobalColorMap.Optimize;
        // Optimize local color maps
        For i := 0 To Images.Count - 1 Do
        Begin
          inc(Prog);
          If (Images[i].ColorMap.Count > 0) Then
          Begin
            Images[i].ColorMap.Optimize;
            Progress(self, psRunning, MulDiv(Prog, 100, MaxProg), False,
              Rect(0, 0, 0, 0), sProgressOptimizing);
          End;
        End;
      End;

      // Remove passive elements, pass 1
      If (ooCleanup In Options) Then
      Begin
        // Check for transparency flag without any transparent pixels
        For i := 0 To Images.Count - 1 Do
        Begin
          inc(Prog);
          If (Images[i].Transparent) Then
          Begin
            If Not (Scan(Images[i].Data,
              Images[i].GraphicControlExtension.TransparentColorIndex,
              Images[i].DataSize)) Then
            Begin
              Images[i].GraphicControlExtension.Transparent := False;
              Progress(self, psRunning, MulDiv(Prog, 100, MaxProg), False,
                Rect(0, 0, 0, 0), sProgressOptimizing);
            End;
          End;
        End;

        // Change redundant disposal modes
        For i := 0 To Images.Count - 2 Do
        Begin
          inc(Prog);
          If (Images[i].GraphicControlExtension <> Nil) And
            (Images[i].GraphicControlExtension.Disposal In [dmPrevious, dmBackground]) And
            (Not Images[i + 1].Transparent) Then
          Begin
            ThisRect := Images[i].BoundsRect;
            NextRect := Images[i + 1].BoundsRect;
            If (Not IntersectRect(MergeRect, ThisRect, NextRect)) Then
              Continue;
            // If the next frame completely covers the current frame,
            // change the disposal mode to dmNone
            If (EqualRect(MergeRect, NextRect)) Then
              Images[i].GraphicControlExtension.Disposal := dmNone;
            Progress(self, psRunning, MulDiv(Prog, 100, MaxProg), False,
              Rect(0, 0, 0, 0), sProgressOptimizing);
          End;
        End;
      End Else
        inc(Prog, 2 * Images.Count);

      // Merge layers of equal pixels (remove redundant pixels)
      If (ooMerge In Options) Then
      Begin
        // Merge from last to first to avoid intefering with merge
        For i := Images.Count - 1 Downto 1 Do
        Begin
          inc(Prog);
          j := i - 1;
          // If the "previous" frames uses dmPrevious disposal mode, we must
          // instead merge with the frame before the previous
          While (j > 0) And
            ((Images[j].GraphicControlExtension <> Nil) And
            (Images[j].GraphicControlExtension.Disposal = dmPrevious)) Do
            Dec(j);
          // Merge
          Images[i].Merge(Images[j]);
          Progress(self, psRunning, MulDiv(Prog, 100, MaxProg), False,
            Rect(0, 0, 0, 0), sProgressOptimizing);
        End;
      End Else
        inc(Prog, Images.Count);

      // Crop transparent areas
      If (ooCrop In Options) Then
      Begin
        For i := Images.Count - 1 Downto 0 Do
        Begin
          inc(Prog);
          If (Not Images[i].Empty) And (Images[i].Transparent) Then
          Begin
            // Remember frames delay in case frame is deleted
            Delay := Images[i].GraphicControlExtension.Delay;
            // Crop
            Images[i].Crop;
            // If the frame was completely transparent we remove it
            If (Images[i].Empty) Then
            Begin
              // Transfer delay to previous frame in case frame was deleted
              If (i > 0) And (Images[i - 1].Transparent) Then
                Images[i - 1].GraphicControlExtension.Delay :=
                  Images[i - 1].GraphicControlExtension.Delay + Delay;
              Images.Delete(i);
            End;
            Progress(self, psRunning, MulDiv(Prog, 100, MaxProg), False,
              Rect(0, 0, 0, 0), sProgressOptimizing);
          End;
        End;
      End Else
        inc(Prog, Images.Count);

      // Remove passive elements, pass 2
      inc(Prog, Images.Count);
      If (ooCleanup In Options) Then
      Begin
        For i := Images.Count - 1 Downto 0 Do
        Begin
          // Remove comments and application extensions
          For j := Images[i].Extensions.Count - 1 Downto 0 Do
            If (Images[i].Extensions[j] Is TGIFCommentExtension) Or
              (Images[i].Extensions[j] Is TGIFTextExtension) Or
              (Images[i].Extensions[j] Is TGIFUnknownAppExtension) Or
              ((Images[i].Extensions[j] Is TGIFAppExtNSLoop) And
              ((i > 0) Or (Images.Count = 1))) Then
              Images[i].Extensions.Delete(j);
          If (Images[i].GraphicControlExtension <> Nil) Then
          Begin
            GCE := Images[i].GraphicControlExtension;
            // Zap GCE if all of the following are true:
            // * No delay or only one image
            // * Not transparent
            // * No prompt
            // * No disposal or only one image
            If ((GCE.Delay = 0) Or (Images.Count = 1)) And
              (Not GCE.Transparent) And
              (Not GCE.UserInput) And
              ((GCE.Disposal In [dmNone, dmNoDisposal]) Or (Images.Count = 1)) Then
            Begin
              GCE.Free;
            End;
          End;
          // Zap frame if it has become empty
          If (Images[i].Empty) And (Images[i].Extensions.Count = 0) Then
            Images[i].Free;
        End;
        Progress(self, psRunning, MulDiv(Prog, 100, MaxProg), False,
          Rect(0, 0, 0, 0), sProgressOptimizing);
      End Else

      // Reduce color depth
        If (ooReduceColors In Options) Then
        Begin
          If (ColorReduction = rmPalette) Then
            Error(sInvalidReduction);
        { TODO -oanme -cFeature : Implement ooReduceColors option. }
        // Not implemented!
        End;
    Finally
      If ExceptObject = Nil Then
        i := 100
      Else
        i := 0;
      Progress(self, psEnding, i, False, Rect(0, 0, 0, 0), sProgressOptimizing);
    End;
  Finally
    FPainters.UnlockList;
  End;
End;

Procedure TGIFImage.Pack;
Var
  i: integer;
Begin
  // Zap bitmaps and palettes
  FreeBitmap;
  Palette := 0;
  For i := 0 To FImages.Count - 1 Do
  Begin
    FImages[i].Bitmap := Nil;
    FImages[i].Palette := 0;
  End;

  // Only pack if no global colormap and a single image
  If (FHeader.ColorMap.Count > 0) Or (FImages.Count <> 1) Then
    Exit;

  // Copy local colormap to global
  FHeader.ColorMap.Assign(FImages[0].ColorMap);
  // Zap local colormap
  FImages[0].ColorMap.Clear;
End;

Procedure TGIFImage.SaveToStream(Stream: TStream);
Var
  n: integer;
Begin
  Progress(self, psStarting, 0, False, Rect(0, 0, 0, 0), sProgressSaving);
  Try
    // Write header
    FHeader.SaveToStream(Stream);
    // Write images
    FImages.SaveToStream(Stream);
    // Write trailer
    With TGIFTrailer.Create(self) Do
    Try
      SaveToStream(Stream);
    Finally
      Free;
    End;
  Finally
    If ExceptObject = Nil Then
      n := 100
    Else
      n := 0;
    Progress(self, psEnding, n, True, Rect(0, 0, 0, 0), sProgressSaving);
  End;
End;

Procedure TGIFImage.LoadFromStream(Stream: TStream);
Var
  n: integer;
  Position: integer;
Begin
  Progress(self, psStarting, 0, False, Rect(0, 0, 0, 0), sProgressLoading);
  Try
    // Zap old image
    Clear;
    Position := Stream.Position;
    Try
      // Read header
      FHeader.LoadFromStream(Stream);
      // Read images
      FImages.LoadFromStream(Stream, self);
      // Read trailer
      With TGIFTrailer.Create(self) Do
      Try
        LoadFromStream(Stream);
      Finally
        Free;
      End;
    Except
      // Restore stream position in case of error.
      // Not required, but "a nice thing to do"
      Stream.Position := Position;
      Raise;
    End;
  Finally
    If ExceptObject = Nil Then
      n := 100
    Else
      n := 0;
    Progress(self, psEnding, n, True, Rect(0, 0, 0, 0), sProgressLoading);
  End;
End;

Procedure TGIFImage.LoadFromResourceName(Instance: THandle; Const ResName: String; ResType: PChar);
// 2002.07.07
Var
  Stream: TCustomMemoryStream;
Begin
  Stream := TResourceStream.Create(Instance, ResName, ResType);
  Try
    LoadFromStream(Stream);
  Finally
    Stream.Free;
  End;
End;

Procedure TGIFImage.LoadFromResourceID(Instance: THandle; ResID: integer; ResType: PChar);
Var
  Stream: TCustomMemoryStream;
Begin
  Stream := TResourceStream.CreateFromID(Instance, ResID, ResType);
  Try
    LoadFromStream(Stream);
  Finally
    Stream.Free;
  End;
End;

Function TGIFImage.GetBitmap: TBitmap;
Begin
  If Not (Empty) Then
  Begin
    Result := FBitmap;
    If (Result <> Nil) Then
      Exit;
    FBitmap := TBitmap.Create;
    Result := FBitmap;
    FBitmap.OnChange := Changed;
    // Use first image as default
    If (Images.Count > 0) Then
    Begin
      If (Images[0].Width = Width) And (Images[0].Height = Height) Then
      Begin
        // Use first image as it has same dimensions
        FBitmap.Assign(Images[0].Bitmap);
      End Else
      Begin
        // Draw first image on bitmap
        FBitmap.Palette := CopyPalette(Palette);
        FBitmap.Height := Height;
        FBitmap.Width := Width;
        Images[0].Draw(FBitmap.Canvas, FBitmap.Canvas.ClipRect, False, False);
      End;
    End;
  End Else
    Result := Nil
End;

// Create a new (empty) bitmap
Function TGIFImage.NewBitmap: TBitmap;
Begin
  Result := FBitmap;
  If (Result <> Nil) Then
    Exit;
  FBitmap := TBitmap.Create;
  Result := FBitmap;
  FBitmap.OnChange := Changed;
  // Draw first image on bitmap
  FBitmap.Palette := CopyPalette(Palette);
  FBitmap.Height := Height;
  FBitmap.Width := Width;
End;

Procedure TGIFImage.FreeBitmap;
Begin
  If (DrawPainter <> Nil) Then
    DrawPainter.Stop;

  If (FBitmap <> Nil) Then
  Begin
    FBitmap.Free;
    FBitmap := Nil;
  End;
End;

Function TGIFImage.Add(Source: TPersistent): integer;
Var
  Image: TGIFSubImage;
Begin
  Image := Nil; // To avoid compiler warning - not needed.
  If (Source Is TGraphic) Then
  Begin
    Image := TGIFSubImage.Create(self);
    Try
      Image.Assign(Source);
      // ***FIXME*** Documentation should explain the inconsistency here:
      // TGIFimage does not take ownership of Source after TGIFImage.Add() and
      // therefore does not delete Source.
    Except
      Image.Free;
      Raise;
    End;
  End Else
    If (Source Is TGIFSubImage) Then
      Image := TGIFSubImage(Source)
    Else
      Error(sUnsupportedClass);

  Result := FImages.Add(Image);

  FreeBitmap;
  Changed(self);
End;

Function TGIFImage.GetEmpty: Boolean;
Begin
  Result := (FImages.Count = 0);
End;

Function TGIFImage.GetHeight: integer;
Begin
  Result := FHeader.Height;
End;

Function TGIFImage.GetWidth: integer;
Begin
  Result := FHeader.Width;
End;

Function TGIFImage.GetIsTransparent: Boolean;
Var
  i: integer;
Begin
  Result := False;
  For i := 0 To Images.Count - 1 Do
    If (Images[i].GraphicControlExtension <> Nil) And
      (Images[i].GraphicControlExtension.Transparent) Then
    Begin
      Result := True;
      Exit;
    End;
End;

Function TGIFImage.Equals(Graphic: TGraphic): Boolean;
Begin
  Result := (Graphic = self);
End;

Function TGIFImage.GetPalette: HPalette;
Begin
  // Check for recursion
  // (TGIFImage.GetPalette->TGIFSubImage.GetPalette->TGIFImage.GetPalette etc...)
  If (IsInsideGetPalette) Then
    Error(sNoColorTable);
  IsInsideGetPalette := True;
  Try
    Result := 0;
    If (FBitmap <> Nil) And (FBitmap.Palette <> 0) Then
      // Use bitmaps own palette if possible
      Result := FBitmap.Palette
    Else If (FGlobalPalette <> 0) Then
      // Or a previously exported global palette
      Result := FGlobalPalette
    Else If (DoDither) Then
    Begin
      // or create a new dither palette
      FGlobalPalette := WebPalette;
      Result := FGlobalPalette;
    End Else
      If (FHeader.ColorMap.Count > 0) Then
      Begin
      // or create a new if first time
        FGlobalPalette := FHeader.ColorMap.ExportPalette;
        Result := FGlobalPalette;
      End Else
        If (FImages.Count > 0) Then
      // This can cause a recursion if no global palette exist and image[0]
      // hasn't got one either. Checked by the IsInsideGetPalette semaphor.
          Result := FImages[0].Palette;
  Finally
    IsInsideGetPalette := False;
  End;
End;

Procedure TGIFImage.SetPalette(Value: HPalette);
Var
  NeedNewBitmap: Boolean;
Begin
  If (Value <> FGlobalPalette) Then
  Begin
    // Zap old palette
    If (FGlobalPalette <> 0) Then
      DeleteObject(FGlobalPalette);

    // Zap bitmap unless new palette is same as bitmaps own
    NeedNewBitmap := (FBitmap <> Nil) And (Value <> FBitmap.Palette);

    // Use new palette
    FGlobalPalette := Value;

    If (NeedNewBitmap) Then
    Begin
      // Need to create new bitmap and repaint
      FreeBitmap;
      PaletteModified := True;
      Changed(self);
    End;
  End;
End;

// Obsolete
// procedure TGIFImage.Changed(Sender: TObject);
// begin
//  inherited Changed(Sender);
// end;

Procedure TGIFImage.SetHeight(Value: integer);
Var
  i: integer;
Begin
  For i := 0 To Images.Count - 1 Do
    If (Images[i].Top + Images[i].Height > Value) Then
      Error(sBadHeight);
  If (Value <> Header.Height) Then
  Begin
    Header.Height := Value;
    FreeBitmap;
    Changed(self);
  End;
End;

Procedure TGIFImage.SetWidth(Value: integer);
Var
  i: integer;
Begin
  For i := 0 To Images.Count - 1 Do
    If (Images[i].Left + Images[i].Width > Value) Then
      Error(sBadWidth);
  If (Value <> Header.Width) Then
  Begin
    Header.Width := Value;
    FreeBitmap;
    Changed(self);
  End;
End;

Procedure TGIFImage.WriteData(Stream: TStream);
Begin
  If (GIFImageOptimizeOnStream) Then
    Optimize([ooCrop, ooMerge, ooCleanup, ooColorMap, ooReduceColors], rmNone, dmNearest, 8);

  Inherited WriteData(Stream);
End;

Procedure TGIFImage.AssignTo(Dest: TPersistent);
Begin
  If (Dest Is TBitmap) Then
    Dest.Assign(Bitmap)
  Else
    Inherited AssignTo(Dest);
End;

{ TODO 1 -oanme -cImprovement : Better handling of TGIFImage.Assign(Empty TBitmap). }
Procedure TGIFImage.Assign(Source: TPersistent);
Var
  i: integer;
  Image: TGIFSubImage;
Begin
  If (Source = self) Then
    Exit;
  If (Source = Nil) Then
  Begin
    Clear;
  End Else
  //
  // TGIFImage import
  //
    If (Source Is TGIFImage) Then
    Begin
      Clear;
    // Temporarily copy event handlers to be able to generate progress events
    // during the copy and handle copy errors
      OnProgress := TGIFImage(Source).OnProgress;
      Try
        FOnWarning := TGIFImage(Source).OnWarning;
        Progress(self, psStarting, 0, False, Rect(0, 0, 0, 0), sProgressCopying);
        Try
          FHeader.Assign(TGIFImage(Source).Header);
          FThreadPriority := TGIFImage(Source).ThreadPriority;
          FDrawBackgroundColor := TGIFImage(Source).DrawBackgroundColor;
          FDrawOptions := TGIFImage(Source).DrawOptions;
          FColorReduction := TGIFImage(Source).ColorReduction;
          FDitherMode := TGIFImage(Source).DitherMode;
          FForceFrame := TGIFImage(Source).ForceFrame; // 2004.03.09
// 2002.07.07 ->
          FOnWarning := TGIFImage(Source).FOnWarning;
          FOnStartPaint := TGIFImage(Source).FOnStartPaint;
          FOnPaint := TGIFImage(Source).FOnPaint;
          FOnEndPaint := TGIFImage(Source).FOnEndPaint;
          FOnAfterPaint := TGIFImage(Source).FOnAfterPaint;
          FOnLoop := TGIFImage(Source).FOnLoop;
// 2002.07.07 <-
          For i := 0 To TGIFImage(Source).Images.Count - 1 Do
          Begin
            Image := TGIFSubImage.Create(self);
            Image.Assign(TGIFImage(Source).Images[i]);
            Add(Image);
            Progress(self, psRunning, MulDiv((i + 1), 100, TGIFImage(Source).Images.Count),
              False, Rect(0, 0, 0, 0), sProgressCopying);
          End;
        Finally
          If ExceptObject = Nil Then
            i := 100
          Else
            i := 0;
          Progress(self, psEnding, i, False, Rect(0, 0, 0, 0), sProgressCopying);
        End;
      Finally
      // Reset event handlers
        FOnWarning := Nil;
        OnProgress := Nil;
      End;
    End Else
  //
  // Import via TGIFSubImage.Assign
  //
    Begin
      Clear;
      Image := TGIFSubImage.Create(self);
      Try
        Image.Assign(Source);
        Add(Image);
      Except
        On E: EConvertError Do
        Begin
          Image.Free;
        // Unsupported format - fall back to Source.AssignTo
          Inherited Assign(Source);
        End;
      Else
      // Unknown conversion error
        Image.Free;
        Raise;
      End;
    End;
End;

Procedure TGIFImage.LoadFromClipboardFormat(AFormat: Word; AData: THandle;
  APalette: HPalette);
{$IFDEF REGISTER_TGIFIMAGE}
Var
  Size: longInt;
  Buffer: Pointer;
  Stream: TMemoryStream;
  Bmp: TBitmap;
{$ENDIF} // 2002.07.07
Begin // 2002.07.07
{$IFDEF REGISTER_TGIFIMAGE} // 2002.07.07
  If (AData = 0) Then
    AData := GetClipboardData(AFormat);
  If (AData <> 0) And (AFormat = CF_GIF) Then
  Begin
    // Get size and pointer to data
    Size := GlobalSize(AData);
    Buffer := GlobalLock(AData);
    Try
      Stream := TMemoryStream.Create;
      Try
        // Copy data to a stream
        Stream.SetSize(Size);
        Move(Buffer^, Stream.Memory^, Size);
        // Load GIF from stream
        LoadFromStream(Stream);
      Finally
        Stream.Free;
      End;
    Finally
      GlobalUnlock(AData);
    End;
  End Else
    If (AData <> 0) And (AFormat = CF_BITMAP) Then
    Begin
    // No GIF on clipboard - try loading a bitmap instead
      Bmp := TBitmap.Create;
      Try
        Bmp.LoadFromClipboardFormat(AFormat, AData, APalette);
        Assign(Bmp);
      Finally
        Bmp.Free;
      End;
    End Else
      Error(sUnknownClipboardFormat);
{$ELSE} // 2002.07.07
  Error(sGIFToClipboard); // 2002.07.07
{$ENDIF} // 2002.07.07
End;

Procedure TGIFImage.SaveToClipboardFormat(Var AFormat: Word; Var AData: THandle;
  Var APalette: HPalette);
{$IFDEF REGISTER_TGIFIMAGE}
Var
  Stream: TMemoryStream;
  Data: THandle;
  Buffer: Pointer;
{$ENDIF} // 2002.07.07
Begin // 2002.07.07
{$IFDEF REGISTER_TGIFIMAGE} // 2002.07.07
  If (Empty) Then
    Exit;
  // First store a bitmap version on the clipboard...
  Bitmap.SaveToClipboardFormat(AFormat, AData, APalette);
  // ...then store a GIF
  Stream := TMemoryStream.Create;
  Try
    // Save the GIF to a memory stream
    SaveToStream(Stream);
    Stream.Position := 0;
    // Allocate some memory for the GIF data
    Data := GlobalAlloc(HeapAllocFlags, Stream.Size);
    Try
      If (Data <> 0) Then
      Begin
        Buffer := GlobalLock(Data);
        Try
          // Copy GIF data from stream memory to clipboard memory
          Move(Stream.Memory^, Buffer^, Stream.Size);
        Finally
          GlobalUnlock(Data);
        End;
        // Transfer data to clipboard
        If (SetClipboardData(CF_GIF, Data) = 0) Then
          Error(sFailedPaste);
      End;
    Except
      GlobalFree(Data);
      Raise;
    End;
  Finally
    Stream.Free;
  End;
{$ELSE} // 2002.07.07
  Error(sGIFToClipboard); // 2002.07.07
{$ENDIF} // 2002.07.07
End;

Function TGIFImage.GetColorMap: TGIFColorMap;
Begin
  Result := FHeader.ColorMap;
End;

Function TGIFImage.GetDoDither: Boolean;
Begin
  Result := (goDither In DrawOptions) And
    (((goAutoDither In DrawOptions) And DoAutoDither) Or
    Not (goAutoDither In DrawOptions));
End;

{$IFDEF VER9x}
Procedure TGIFImage.Progress(Sender: TObject; Stage: TProgressStage;
  PercentDone: Byte; RedrawNow: Boolean; Const R: TRect; Const Msg: String);
Begin
  If Assigned(FOnProgress) Then
    FOnProgress(Sender, Stage, PercentDone, RedrawNow, R, Msg);
End;
{$ENDIF}

Procedure TGIFImage.StopDraw;
{$IFNDEF VER14_PLUS} // 2001.07.23
Var
  Msg: TMsg;
  ThreadWindow: HWND;
{$ENDIF} // 2001.07.23
Begin
  Repeat
    // Use the FPainters threadlist to protect FDrawPainter from being modified
    // by the thread while we mess with it
    With FPainters.LockList Do
    Try
      If (FDrawPainter = Nil) Then
        Break;

        // Tell thread to terminate
      FDrawPainter.Stop;

        // No need to wait for "thread" to terminate if running in main thread
      If Not (goAsync In FDrawPainter.DrawOptions) Then
        Break;

    Finally
        // Release the lock on FPainters to let paint thread kill itself
      FPainters.UnlockList;
    End;

{$IFDEF VER14_PLUS}
// 2002.07.07
    If (GetCurrentThreadId = MainThreadID) Then
      While CheckSynchronize Do {loop};
{$ELSE}
    // Process Messages to make Synchronize work
    // (Instead of Application.ProcessMessages)
//{$IFDEF VER14_PLUS}  // 2001.07.23
//    Break;  // 2001.07.23
//    Sleep(0); // Yield  // 2001.07.23
//{$ELSE}  // 2001.07.23
    ThreadWindow := FindWindow('TThreadWindow', Nil);
    While PeekMessage(Msg, ThreadWindow, CM_DESTROYWINDOW, CM_EXECPROC, PM_REMOVE) Do
    Begin
      If (Msg.Message <> WM_QUIT) Then
      Begin
        TranslateMessage(Msg);
        DispatchMessage(Msg);
      End Else
      Begin
        PostQuitMessage(Msg.WParam);
        Exit;
      End;
    End;
{$ENDIF} // 2001.07.23
    Sleep(0); // Yield

  Until (False);
  FreeBitmap;
End;

Procedure TGIFImage.Draw(ACanvas: TCanvas; Const Rect: TRect);
Var
  Canvas: TCanvas;
  DestRect: TRect;
{$IFNDEF VER14_PLUS} // 2001.07.23
  Msg: TMsg;
  ThreadWindow: HWND;
{$ENDIF} // 2001.07.23

  Procedure DrawTile(Rect: TRect; Bitmap: TBitmap);
  Var
    Tile: TRect;
  Begin
    If (goTile In FDrawOptions) Then
    Begin
      // Note: This design does not handle transparency correctly!
      Tile.Left := Rect.Left;
      Tile.Right := Tile.Left + Width;
      While (Tile.Left < Rect.Right) Do
      Begin
        Tile.Top := Rect.Top;
        Tile.Bottom := Tile.Top + Height;
        While (Tile.Top < Rect.Bottom) Do
        Begin
          ACanvas.StretchDraw(Tile, Bitmap);
          Tile.Top := Tile.Top + Height;
          Tile.Bottom := Tile.Top + Height;
        End;
        Tile.Left := Tile.Left + Width;
        Tile.Right := Tile.Left + Width;
      End;
    End Else
      ACanvas.StretchDraw(Rect, Bitmap);
  End;

Begin
  // Prevent recursion(s(s(s)))
  If (IsDrawing) Or (FImages.Count = 0) Then
    Exit;

  IsDrawing := True;
  Try
    // Copy bitmap to canvas if we are already drawing
    // (or have drawn but are finished)
    If (FImages.Count = 1) Or // Only one image
      (Not (goAnimate In FDrawOptions)) Then // Don't animate
    Begin
      // 2004.03.09 ->
      If (FForceFrame >= 0) And (FForceFrame < FImages.Count) Then
        FImages[FForceFrame].Draw(ACanvas, Rect, (goTransparent In FDrawOptions), (goTile In FDrawOptions))
      Else
      // 2004.03.09 <-
        FImages[0].Draw(ACanvas, Rect, (goTransparent In FDrawOptions), (goTile In FDrawOptions));
      Exit;
    End Else
      If (FBitmap <> Nil) And Not (goDirectDraw In FDrawOptions) Then
      Begin
        DrawTile(Rect, Bitmap);
        Exit;
      End;

    // Use the FPainters threadlist to protect FDrawPainter from being modified
    // by the thread while we mess with it
    With FPainters.LockList Do
    Try
      // If we are already painting on the canvas in goDirectDraw mode
      // and at the same location, just exit and let the painter do
      // its thing when it's ready
      If (FDrawPainter <> Nil) And (FDrawPainter.Canvas = ACanvas) And
        EqualRect(FDrawPainter.Rect, Rect) Then
        Exit;

      // Kill the current paint thread
      StopDraw;

      If Not (goDirectDraw In FDrawOptions) Then
      Begin
        // Create a bitmap to draw on
        NewBitmap;
        Canvas := FBitmap.Canvas;
        DestRect := Canvas.ClipRect;
        // Initialize bitmap canvas with background image
        Canvas.CopyRect(DestRect, ACanvas, Rect);
      End Else
      Begin
        Canvas := ACanvas;
        DestRect := Rect;
      End;

      // Create new paint thread
      InternalPaint(@FDrawPainter, Canvas, DestRect, FDrawOptions);

      If (FDrawPainter <> Nil) Then
      Begin
        // Launch thread
        FDrawPainter.Start;

        If Not (goDirectDraw In FDrawOptions) Then
        Begin
{$IFDEF VER14_PLUS}
// 2002.07.07
          While (FDrawPainter <> Nil) And (Not FDrawPainter.Terminated) And
            (Not FDrawPainter.Started) Do
          Begin
            If Not CheckSynchronize Then
              Sleep(0); // Yield
          End;
{$ELSE}
//{$IFNDEF VER14_PLUS}  // 2001.07.23
          ThreadWindow := FindWindow('TThreadWindow', Nil);
          // Wait for thread to render first frame
          While (FDrawPainter <> Nil) And (Not FDrawPainter.Terminated) And
            (Not FDrawPainter.Started) Do
            // Process Messages to make Synchronize work
            // (Instead of Application.ProcessMessages)
            If PeekMessage(Msg, ThreadWindow, CM_DESTROYWINDOW, CM_EXECPROC, PM_REMOVE) Then
            Begin
              If (Msg.Message <> WM_QUIT) Then
              Begin
                TranslateMessage(Msg);
                DispatchMessage(Msg);
              End Else
              Begin
                PostQuitMessage(Msg.WParam);
                Exit;
              End;
            End Else
              Sleep(0); // Yield
{$ENDIF} // 2001.07.23
          // Draw frame to destination
          DrawTile(Rect, Bitmap);
        End;
      End;
    Finally
      FPainters.UnlockList;
    End;

  Finally
    IsDrawing := False;
  End;
End;

// Internal pain(t) routine used by Draw()
Function TGIFImage.InternalPaint(Painter: PGIFPainter; ACanvas: TCanvas;
  Const Rect: TRect; Options: TGIFDrawOptions): TGIFPainter;
Begin
  If (Empty) Or (Rect.Left >= Rect.Right) Or (Rect.Top >= Rect.Bottom) Then
  Begin
    Result := Nil;
    If (Painter <> Nil) Then
      Painter^ := Result;
    Exit;
  End;

  // Draw in main thread if only one image
  If (Images.Count = 1) Then
    Options := Options - [goAsync, goAnimate];

  Result := TGIFPainter.CreateRef(Painter, self, ACanvas, Rect, Options);
  FPainters.Add(Result);
  Result.OnStartPaint := FOnStartPaint;
  Result.OnPaint := FOnPaint;
  Result.OnAfterPaint := FOnAfterPaint;
  Result.OnLoop := FOnLoop;
  Result.OnEndPaint := FOnEndPaint;

  If Not (goAsync In Options) Then
  Begin
    // Run in main thread
    Result.Execute;
    // Note: Painter threads executing in the main thread are freed upon exit
    // from the Execute method, so no need to do it here.
    Result := Nil;
    If (Painter <> Nil) Then
      Painter^ := Result;
  End Else
    Result.Priority := FThreadPriority;
End;

Function TGIFImage.Paint(ACanvas: TCanvas; Const Rect: TRect;
  Options: TGIFDrawOptions): TGIFPainter;
Begin
  Result := InternalPaint(Nil, ACanvas, Rect, Options);
  If (Result <> Nil) Then
    // Run in separate thread
    Result.Start;
End;

Procedure TGIFImage.PaintStart;
Var
  i: integer;
Begin
  With FPainters.LockList Do
  Try
    For i := 0 To Count - 1 Do
      TGIFPainter(Items[i]).Start;
  Finally
    FPainters.UnlockList;
  End;
End;

Procedure TGIFImage.PaintStop;
Var
  Ghosts: integer;
  i: integer;
{$IFNDEF VER14_PLUS} // 2001.07.23
  Msg: TMsg;
  ThreadWindow: HWND;
{$ENDIF} // 2001.07.23

{$IFNDEF VER14_PLUS} // 2001.07.23
  Procedure KillThreads;
  Var
    i: integer;
  Begin
    With FPainters.LockList Do
    Try
      For i := Count - 1 Downto 0 Do
        If (goAsync In TGIFPainter(Items[i]).DrawOptions) Then
        Begin
          TerminateThread(TGIFPainter(Items[i]).Handle, 0);
          Delete(i);
        End;
    Finally
      FPainters.UnlockList;
    End;
  End;
{$ENDIF} // 2001.07.23

Begin
  Try
    // Loop until all have died
    Repeat
      With FPainters.LockList Do
      Try
        If (Count = 0) Then
          Exit;

          // Signal painters to terminate
          // Painters will attempt to remove them self from the
          // painter list when they die
        Ghosts := Count;
        For i := Ghosts - 1 Downto 0 Do
        Begin
          If Not (goAsync In TGIFPainter(Items[i]).DrawOptions) Then
            Dec(Ghosts);
          TGIFPainter(Items[i]).Stop;
        End;
      Finally
        FPainters.UnlockList;
      End;

      // If all painters were synchronous, there's no purpose waiting for them
      // to terminate, because they are running in the main thread.
      If (Ghosts = 0) Then
        Exit;
{$IFDEF VER14_PLUS}
// 2002.07.07
      If (GetCurrentThreadId = MainThreadID) Then
        While CheckSynchronize Do {loop};
{$ELSE}
      // Process Messages to make TThread.Synchronize work
      // (Instead of Application.ProcessMessages)
//{$IFDEF VER14_PLUS}  // 2001.07.23
//      Exit;  // 2001.07.23
//{$ELSE}  // 2001.07.23
      ThreadWindow := FindWindow('TThreadWindow', Nil);
      If (ThreadWindow = 0) Then
      Begin
        KillThreads;
        Exit;
      End;
      While PeekMessage(Msg, ThreadWindow, CM_DESTROYWINDOW, CM_EXECPROC, PM_REMOVE) Do
      Begin
        If (Msg.Message <> WM_QUIT) Then
        Begin
          TranslateMessage(Msg);
          DispatchMessage(Msg);
        End Else
        Begin
          KillThreads;
          Exit;
        End;
      End;
{$ENDIF} // 2001.07.23
      Sleep(0);
    Until (False);
  Finally
    FreeBitmap;
  End;
End;

Procedure TGIFImage.PaintPause;
Var
  i: integer;
Begin
  With FPainters.LockList Do
  Try
    For i := 0 To Count - 1 Do
      TGIFPainter(Items[i]).Suspend;
  Finally
    FPainters.UnlockList;
  End;
End;

Procedure TGIFImage.PaintResume;
Var
  i: integer;
Begin
  // Implementation is currently same as PaintStart, but don't call PaintStart
  // in case its implementation changes
  With FPainters.LockList Do
  Try
    For i := 0 To Count - 1 Do
      TGIFPainter(Items[i]).Start;
  Finally
    FPainters.UnlockList;
  End;
End;

Procedure TGIFImage.PaintRestart;
Var
  i: integer;
Begin
  With FPainters.LockList Do
  Try
    For i := 0 To Count - 1 Do
      TGIFPainter(Items[i]).Restart;
  Finally
    FPainters.UnlockList;
  End;
End;

Procedure TGIFImage.Warning(Sender: TObject; Severity: TGIFSeverity; Message: String);
Begin
  If (Assigned(FOnWarning)) Then
    FOnWarning(Sender, Severity, Message);
End;

{$IFDEF VER12_PLUS}
{$IFNDEF VER14_PLUS} // not anymore need for Delphi 6 and up  // 2001.07.23
Type
  TDummyThread = Class(TThread)
  Protected
    Procedure Execute; Override;
  End;
Procedure TDummyThread.Execute;
Begin
End;
{$ENDIF} // 2001.07.23
{$ENDIF}

Var
  DesktopDC: HDC;
{$IFDEF VER12_PLUS}
{$IFNDEF VER14_PLUS} // not anymore need for Delphi 6 and up  // 2001.07.23
  DummyThread: TThread;
{$ENDIF} // 2001.07.23
{$ENDIF}

////////////////////////////////////////////////////////////////////////////////
//
//			Initialization
//
////////////////////////////////////////////////////////////////////////////////

Initialization
{$IFDEF REGISTER_TGIFIMAGE}
  TPicture.RegisterFileFormat('GIF', sGIFImageFile, TGIFImage);
  CF_GIF := RegisterClipboardFormat(PChar(sGIFImageFile));
  TPicture.RegisterClipboardFormat(CF_GIF, TGIFImage);
{$ENDIF}
  DesktopDC := GetDC(0);
  Try
    PaletteDevice := (GetDeviceCaps(DesktopDC, BITSPIXEL) * GetDeviceCaps(DesktopDC, PLANES) <= 8);
    DoAutoDither := PaletteDevice;
  Finally
    ReleaseDC(0, DesktopDC);
  End;

{$IFDEF VER9x}
  // Note: This doesn't return the same palette as the Delphi 3 system palette
  // since the true system palette contains 20 entries and the Delphi 3 system
  // palette only contains 16.
  // For our purpose this doesn't matter since we do not care about the actual
  // colors (or their number) in the palette.
  // Stock objects doesn't have to be deleted.
  SystemPalette16 := GetStockObject(DEFAULT_PALETTE);
{$ENDIF}
{$IFDEF VER12_PLUS}
  // Make sure that at least one thread always exist.
  // This is done to circumvent a race condition bug in Delphi 4.x and later:
  // When threads are deleted and created in rapid succesion, a situation might
  // arise where the thread window is deleted *after* the threads it controls
  // has been created. See the Delphi Bug Lists for more information.
{$IFNDEF VER14_PLUS} // not anymore need for Delphi 6 and up  // 2001.07.23
  DummyThread := TDummyThread.Create(True);
{$ENDIF} // 2001.07.23
{$ENDIF}

////////////////////////////////////////////////////////////////////////////////
//
//			Finalization
//
////////////////////////////////////////////////////////////////////////////////
Finalization
  ExtensionList.Free;
  AppExtensionList.Free;
{$IFNDEF VER9x}
{$IFDEF REGISTER_TGIFIMAGE}
  TPicture.UnregisterGraphicClass(TGIFImage);
{$ENDIF}
{$IFDEF VER100}
  If (pf8BitBitmap <> Nil) Then
    pf8BitBitmap.Free;
{$ENDIF}
{$ENDIF}
{$IFDEF VER12_PLUS}
{$IFNDEF VER14_PLUS} // not anymore need for Delphi 6 and up  // 2001.07.23
  If (DummyThread <> Nil) Then
    DummyThread.Free;
{$ENDIF} // 2001.07.23
{$ENDIF}
End.

