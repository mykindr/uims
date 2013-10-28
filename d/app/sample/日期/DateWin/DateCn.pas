unit DateCn;

interface

uses Windows, SysUtils, Controls;
//download by http://www.codefans.net
const
  BaseAnimalDate = '1972';
  BaseSkyStemDate = '1974';
  START_YEAR = 1901;
  END_YEAR = 2050;

  gLunarHolDay: array[0..1799] of Byte = (
    $96, $B4, $96, $A6, $97, $97, $78, $79, $79, $69, $78, $77,
    $96, $A4, $96, $96, $97, $87, $79, $79, $79, $69, $78, $78,
    $96, $A5, $87, $96, $87, $87, $79, $69, $69, $69, $78, $78,
    $86, $A5, $96, $A5, $96, $97, $88, $78, $78, $79, $78, $87,
    $96, $B4, $96, $A6, $97, $97, $78, $79, $79, $69, $78, $77,
    $96, $A4, $96, $96, $97, $97, $79, $79, $79, $69, $78, $78,
    $96, $A5, $87, $96, $87, $87, $79, $69, $69, $69, $78, $78,
    $86, $A5, $96, $A5, $96, $97, $88, $78, $78, $69, $78, $87,
    $96, $B4, $96, $A6, $97, $97, $78, $79, $79, $69, $78, $77,
    $96, $A4, $96, $96, $97, $97, $79, $79, $79, $69, $78, $78,
    $96, $A5, $87, $96, $87, $87, $79, $69, $69, $69, $78, $78,
    $86, $A5, $96, $A5, $96, $97, $88, $78, $78, $69, $78, $87,
    $95, $B4, $96, $A6, $97, $97, $78, $79, $79, $69, $78, $77,
    $96, $B4, $96, $A6, $97, $97, $79, $79, $79, $69, $78, $78,
    $96, $A5, $97, $96, $97, $87, $79, $79, $69, $69, $78, $78,
    $96, $A5, $96, $A5, $96, $97, $88, $78, $78, $79, $77, $87,
    $95, $B4, $96, $A6, $96, $97, $78, $79, $78, $69, $78, $87,
    $96, $B4, $96, $A6, $97, $97, $79, $79, $79, $69, $78, $77,
    $96, $A5, $97, $96, $97, $87, $79, $79, $69, $69, $78, $78,
    $96, $A5, $96, $A5, $96, $97, $88, $78, $78, $79, $77, $87,
    $95, $B4, $96, $A5, $96, $97, $78, $79, $78, $69, $78, $87,
    $96, $B4, $96, $A6, $97, $97, $79, $79, $79, $69, $78, $77,
    $96, $A4, $96, $96, $97, $87, $79, $79, $69, $69, $78, $78,
    $96, $A5, $96, $A5, $96, $97, $88, $78, $78, $79, $77, $87,
    $95, $B4, $96, $A5, $96, $97, $78, $79, $78, $69, $78, $87,
    $96, $B4, $96, $A6, $97, $97, $78, $79, $79, $69, $78, $77,
    $96, $A4, $96, $96, $97, $87, $79, $79, $79, $69, $78, $78,
    $96, $A5, $96, $A5, $96, $96, $88, $78, $78, $78, $87, $87,
    $95, $B4, $96, $A5, $96, $97, $88, $78, $78, $79, $77, $87,
    $96, $B4, $96, $A6, $97, $97, $78, $79, $79, $69, $78, $77,
    $96, $A4, $96, $96, $97, $87, $79, $79, $79, $69, $78, $78,
    $96, $A5, $96, $A5, $96, $96, $88, $78, $78, $78, $87, $87,
    $95, $B4, $96, $A5, $96, $97, $88, $78, $78, $69, $78, $87,
    $96, $B4, $96, $A6, $97, $97, $78, $79, $79, $69, $78, $77,
    $96, $A4, $96, $96, $97, $97, $79, $79, $79, $69, $78, $78,
    $96, $A5, $96, $A5, $96, $96, $88, $78, $78, $78, $87, $87,
    $95, $B4, $96, $A5, $96, $97, $88, $78, $78, $69, $78, $87,
    $96, $B4, $96, $A6, $97, $97, $78, $79, $79, $69, $78, $77,
    $96, $A4, $96, $96, $97, $97, $79, $79, $79, $69, $78, $78,
    $96, $A5, $96, $A5, $96, $96, $88, $78, $78, $78, $87, $87, 
    $95, $B4, $96, $A5, $96, $97, $88, $78, $78, $69, $78, $87,
    $96, $B4, $96, $A6, $97, $97, $78, $79, $79, $69, $78, $77,
    $96, $A4, $96, $96, $97, $97, $79, $79, $79, $69, $78, $78,
    $96, $A5, $96, $A5, $A6, $96, $88, $78, $78, $78, $87, $87,
    $95, $B4, $96, $A5, $96, $97, $88, $78, $78, $79, $77, $87,
    $95, $B4, $96, $A6, $97, $97, $78, $79, $78, $69, $78, $77,
    $96, $B4, $96, $A6, $97, $97, $79, $79, $79, $69, $78, $78,
    $96, $A5, $A6, $A5, $A6, $96, $88, $88, $78, $78, $87, $87,
    $A5, $B4, $96, $A5, $96, $97, $88, $79, $78, $79, $77, $87,
    $95, $B4, $96, $A5, $96, $97, $78, $79, $78, $69, $78, $77,
    $96, $B4, $96, $A6, $97, $97, $79, $79, $79, $69, $78, $78,
    $96, $A5, $A6, $A5, $A6, $96, $88, $88, $78, $78, $87, $87,
    $A5, $B4, $96, $A5, $96, $97, $88, $78, $78, $79, $77, $87,
    $95, $B4, $96, $A5, $96, $97, $78, $79, $78, $68, $78, $87,
    $96, $B4, $96, $A6, $97, $97, $78, $79, $79, $69, $78, $77,
    $96, $A5, $A5, $A5, $A6, $96, $88, $88, $78, $78, $87, $87,
    $A5, $B4, $96, $A5, $96, $97, $88, $78, $78, $79, $77, $87,
    $95, $B4, $96, $A5, $96, $97, $88, $78, $78, $69, $78, $87,
    $96, $B4, $96, $A6, $97, $97, $78, $79, $79, $69, $78, $77,
    $96, $A4, $A5, $A5, $A6, $96, $88, $88, $88, $78, $87, $87,
    $A5, $B4, $96, $A5, $96, $96, $88, $78, $78, $78, $87, $87,
    $96, $B4, $96, $A5, $96, $97, $88, $78, $78, $69, $78, $87,
    $96, $B4, $96, $A6, $97, $97, $78, $79, $79, $69, $78, $77,
    $96, $A4, $A5, $A5, $A6, $96, $88, $88, $88, $78, $87, $87,
    $A5, $B4, $96, $A5, $96, $96, $88, $78, $78, $78, $87, $87,
    $95, $B4, $96, $A5, $96, $97, $88, $78, $78, $69, $78, $87,
    $96, $B4, $96, $A6, $97, $97, $78, $79, $79, $69, $78, $77,
    $96, $A4, $A5, $A5, $A6, $A6, $88, $88, $88, $78, $87, $87,
    $A5, $B4, $96, $A5, $96, $96, $88, $78, $78, $78, $87, $87,
    $95, $B4, $96, $A5, $96, $97, $88, $78, $78, $69, $78, $87,
    $96, $B4, $96, $A6, $97, $97, $78, $79, $79, $69, $78, $77,
    $96, $A4, $A5, $A5, $A6, $A6, $88, $88, $88, $78, $87, $87,
    $A5, $B5, $96, $A5, $A6, $96, $88, $78, $78, $78, $87, $87,
    $95, $B4, $96, $A5, $96, $97, $88, $78, $78, $69, $78, $87,
    $96, $B4, $96, $A6, $97, $97, $78, $79, $78, $69, $78, $77,
    $96, $A4, $A5, $B5, $A6, $A6, $88, $89, $88, $78, $87, $87,
    $A5, $B4, $96, $A5, $96, $96, $88, $88, $78, $78, $87, $87,
    $95, $B4, $96, $A5, $96, $97, $88, $78, $78, $79, $78, $87,
    $96, $B4, $96, $A6, $96, $97, $78, $79, $78, $69, $78, $77,
    $96, $A4, $A5, $B5, $A6, $A6, $88, $88, $88, $78, $87, $87,
    $A5, $B4, $96, $A5, $A6, $96, $88, $88, $78, $78, $77, $87,
    $95, $B4, $96, $A5, $96, $97, $88, $78, $78, $79, $77, $87,
    $95, $B4, $96, $A5, $96, $97, $78, $79, $78, $69, $78, $77,
    $96, $B4, $A5, $B5, $A6, $A6, $87, $88, $88, $78, $87, $87,
    $A5, $B4, $A6, $A5, $A6, $96, $88, $88, $78, $78, $87, $87,
    $A5, $B4, $96, $A5, $96, $97, $88, $78, $78, $79, $77, $87,
    $95, $B4, $96, $A5, $96, $97, $88, $79, $78, $69, $78, $87,
    $96, $B4, $A5, $B5, $A6, $A6, $87, $88, $88, $78, $87, $86,
    $A5, $B4, $A5, $A5, $A6, $96, $88, $88, $88, $78, $87, $87,
    $A5, $B4, $96, $A5, $96, $96, $88, $78, $78, $79, $77, $87,
    $95, $B4, $96, $A5, $86, $97, $88, $78, $78, $69, $78, $87,
    $96, $B4, $A5, $B5, $A6, $A6, $87, $88, $88, $78, $87, $86,
    $A5, $B3, $A5, $A5, $A6, $96, $88, $88, $88, $78, $87, $87,
    $A5, $B4, $96, $A5, $96, $96, $88, $78, $78, $78, $87, $87,
    $95, $B4, $96, $A5, $96, $97, $88, $76, $78, $69, $78, $87,
    $96, $B4, $A5, $B5, $A6, $A6, $87, $88, $88, $78, $87, $86,
    $A5, $B3, $A5, $A5, $A6, $A6, $88, $88, $88, $78, $87, $87,
    $A5, $B4, $96, $A5, $96, $96, $88, $78, $78, $78, $87, $87,
    $95, $B4, $96, $A5, $96, $97, $88, $78, $78, $69, $78, $87,
    $96, $B4, $A5, $B5, $A6, $A6, $87, $88, $88, $78, $87, $86,
    $A5, $B3, $A5, $A5, $A6, $A6, $88, $88, $88, $78, $87, $87,
    $A5, $B4, $96, $A5, $96, $96, $88, $78, $78, $78, $87, $87,
    $95, $B4, $96, $A5, $96, $97, $88, $78, $78, $69, $78, $87,
    $96, $B4, $A5, $B5, $A6, $A6, $87, $88, $88, $78, $87, $86,
    $A5, $B3, $A5, $A5, $A6, $A6, $88, $88, $88, $78, $87, $87,
    $A5, $B4, $96, $A5, $A6, $96, $88, $88, $78, $78, $87, $87,
    $95, $B4, $96, $A5, $96, $97, $88, $78, $78, $69, $78, $87,
    $96, $B4, $A5, $B5, $A6, $A6, $87, $88, $87, $78, $87, $86,
    $A5, $B3, $A5, $B5, $A6, $A6, $88, $88, $88, $78, $87, $87,
    $A5, $B4, $96, $A5, $A6, $96, $88, $88, $78, $78, $87, $87,
    $95, $B4, $96, $A5, $96, $97, $88, $78, $78, $79, $78, $87,
    $96, $B4, $A5, $B5, $A5, $A6, $87, $88, $87, $78, $87, $86,
    $A5, $B3, $A5, $B5, $A6, $A6, $87, $88, $88, $78, $87, $87,
    $A5, $B4, $96, $A5, $A6, $96, $88, $88, $78, $78, $87, $87,
    $95, $B4, $96, $A5, $96, $97, $88, $78, $78, $79, $77, $87,
    $95, $B4, $A5, $B4, $A5, $A6, $87, $88, $87, $78, $87, $86,
    $A5, $C3, $A5, $B5, $A6, $A6, $87, $88, $88, $78, $87, $87,
    $A5, $B4, $A6, $A5, $A6, $96, $88, $88, $78, $78, $87, $87,
    $A5, $B4, $96, $A5, $96, $96, $88, $78, $78, $79, $77, $87,
    $95, $B4, $A5, $B4, $A5, $A6, $97, $87, $87, $78, $87, $86,
    $A5, $C3, $A5, $B5, $A6, $A6, $87, $88, $88, $78, $87, $86,
    $A5, $B4, $A5, $A5, $A6, $96, $88, $88, $88, $78, $87, $87,
    $A5, $B4, $96, $A5, $96, $96, $88, $78, $78, $79, $77, $87,
    $95, $B4, $A5, $B4, $A5, $A6, $97, $87, $87, $78, $87, $96,
    $A5, $C3, $A5, $B5, $A6, $A6, $87, $88, $88, $78, $87, $86,
    $A5, $B3, $A5, $A5, $A6, $A6, $88, $88, $88, $78, $87, $87,
    $A5, $B4, $96, $A5, $96, $96, $88, $78, $78, $78, $87, $87,
    $95, $B4, $A5, $B4, $A5, $A6, $97, $87, $87, $78, $87, $96,
    $A5, $C3, $A5, $B5, $A6, $A6, $87, $88, $88, $78, $87, $86,
    $A5, $B3, $A5, $A5, $A6, $A6, $88, $88, $88, $78, $87, $87,
    $A5, $B4, $96, $A5, $96, $96, $88, $78, $78, $78, $87, $87,
    $95, $B4, $A5, $B4, $A5, $A6, $97, $87, $87, $78, $87, $96,
    $A5, $C3, $A5, $B5, $A6, $A6, $88, $88, $88, $78, $87, $86,
    $A5, $B3, $A5, $A5, $A6, $A6, $88, $78, $88, $78, $87, $87,
    $A5, $B4, $96, $A5, $A6, $96, $88, $88, $78, $78, $87, $87,
    $95, $B4, $A5, $B4, $A5, $A6, $97, $87, $87, $78, $87, $96,
    $A5, $C3, $A5, $B5, $A6, $A6, $87, $88, $88, $78, $87, $86,
    $A5, $B3, $A5, $A5, $A6, $A6, $88, $88, $88, $78, $87, $87,
    $A5, $B4, $96, $A5, $A6, $96, $88, $88, $78, $78, $87, $87,
    $95, $B4, $A5, $B4, $A5, $A6, $97, $87, $87, $78, $87, $96,
    $A5, $C3, $A5, $B5, $A5, $A6, $87, $88, $87, $78, $87, $86,
    $A5, $B3, $A5, $B5, $A6, $A6, $88, $88, $88, $78, $87, $87,
    $A5, $B4, $96, $A5, $A6, $96, $88, $88, $78, $78, $87, $87,
    $95, $B4, $A5, $B4, $A5, $A6, $97, $87, $87, $88, $87, $96,
    $A5, $C3, $A5, $B4, $A5, $A6, $87, $88, $87, $78, $87, $86,
    $A5, $B3, $A5, $B5, $A6, $A6, $87, $88, $88, $78, $87, $87,
    $A5, $B4, $96, $A5, $A6, $96, $88, $88, $78, $78, $87, $87,
    $95, $B4, $A5, $B4, $A5, $A5, $97, $87, $87, $88, $86, $96,
    $A4, $C3, $A5, $A5, $A5, $A6, $97, $87, $87, $78, $87, $86,
    $A5, $C3, $A5, $B5, $A6, $A6, $87, $88, $78, $78, $87, $87);


  CnData: array[0..599] of Byte = (
    $0B, $52, $BA, $00, $16, $A9, $5D, $00, $83, $A9, $37, $05, $0E, $74, $9B, $00,
    $1A, $B6, $55, $00, $87, $B5, $55, $04, $11, $55, $AA, $00, $1C, $A6, $B5, $00,
    $8A, $A5, $75, $02, $14, $52, $BA, $00, $81, $52, $6E, $06, $0D, $E9, $37, $00,
    $18, $74, $97, $00, $86, $EA, $96, $05, $10, $6D, $55, $00, $1A, $35, $AA, $00,
    $88, $4B, $6A, $02, $13, $A5, $6D, $00, $1E, $D2, $6E, $07, $0B, $D2, $5E, $00,
    $17, $E9, $2E, $00, $84, $D9, $2D, $05, $0F, $DA, $95, $00, $19, $5B, $52, $00,
    $87, $56, $D4, $04, $11, $4A, $DA, $00, $1C, $A5, $5D, $00, $89, $A4, $BD, $02,
    $15, $D2, $5D, $00, $82, $B2, $5B, $06, $0D, $B5, $2B, $00, $18, $BA, $95, $00,
    $86, $B6, $A5, $05, $10, $56, $B4, $00, $1A, $4A, $DA, $00, $87, $49, $BA, $03,
    $13, $A4, $BB, $00, $1E, $B2, $5B, $07, $0B, $72, $57, $00, $16, $75, $2B, $00,
    $84, $6D, $2A, $06, $0F, $AD, $55, $00, $19, $55, $AA, $00, $86, $55, $6C, $04,
    $12, $C9, $76, $00, $1C, $64, $B7, $00, $8A, $E4, $AE, $02, $15, $EA, $56, $00,
    $83, $DA, $55, $07, $0D, $5B, $2A, $00, $18, $AD, $55, $00, $85, $AA, $D5, $05,
    $10, $53, $6A, $00, $1B, $A9, $6D, $00, $88, $A9, $5D, $03, $13, $D4, $AE, $00,
    $81, $D4, $AB, $08, $0C, $BA, $55, $00, $16, $5A, $AA, $00, $83, $56, $AA, $06,
    $0F, $AA, $D5, $00, $19, $52, $DA, $00, $86, $52, $BA, $04, $11, $A9, $5D, $00,
    $1D, $D4, $9B, $00, $8A, $74, $9B, $03, $15, $B6, $55, $00, $82, $AD, $55, $07,
    $0D, $55, $AA, $00, $18, $A5, $B5, $00, $85, $A5, $75, $05, $0F, $52, $B6, $00,
    $1B, $69, $37, $00, $89, $E9, $37, $04, $13, $74, $97, $00, $81, $EA, $96, $08,
    $0C, $6D, $52, $00, $16, $2D, $AA, $00, $83, $4B, $6A, $06, $0E, $A5, $6D, $00,
    $1A, $D2, $6E, $00, $87, $D2, $5E, $04, $12, $E9, $2E, $00, $1D, $EC, $96, $0A,
    $0B, $DA, $95, $00, $15, $5B, $52, $00, $82, $56, $D2, $06, $0C, $2A, $DA, $00,
    $18, $A4, $DD, $00, $85, $A4, $BD, $05, $10, $D2, $5D, $00, $1B, $D9, $2D, $00,
    $89, $B5, $2B, $03, $14, $BA, $95, $00, $81, $B5, $95, $08, $0B, $56, $B2, $00,
    $16, $2A, $DA, $00, $83, $49, $B6, $05, $0E, $64, $BB, $00, $19, $B2, $5B, $00,
    $87, $6A, $57, $04, $12, $75, $2B, $00, $1D, $B6, $95, $00, $8A, $AD, $55, $02,
    $15, $55, $AA, $00, $82, $55, $6C, $07, $0D, $C9, $76, $00, $17, $64, $B7, $00,
    $86, $E4, $AE, $05, $11, $EA, $56, $00, $1B, $6D, $2A, $00, $88, $5A, $AA, $04,
    $14, $AD, $55, $00, $81, $AA, $D5, $09, $0B, $52, $EA, $00, $16, $A9, $6D, $00,
    $84, $A9, $5D, $06, $0F, $D4, $AE, $00, $1A, $EA, $4D, $00, $87, $BA, $55, $04,
    $12, $5A, $AA, $00, $1D, $AB, $55, $00, $8A, $A6, $D5, $02, $14, $52, $DA, $00,
    $82, $52, $BA, $06, $0D, $A9, $3B, $00, $18, $B4, $9B, $00, $85, $74, $9B, $05,
    $11, $B5, $4D, $00, $1C, $D6, $A9, $00, $88, $35, $AA, $03, $13, $A5, $B5, $00,
    $81, $A5, $75, $0B, $0B, $52, $B6, $00, $16, $69, $37, $00, $84, $E9, $2F, $06,
    $10, $F4, $97, $00, $1A, $75, $4B, $00, $87, $6D, $52, $05, $11, $2D, $69, $00,
    $1D, $95, $B5, $00, $8A, $A5, $6D, $02, $15, $D2, $6E, $00, $82, $D2, $5E, $07,
    $0E, $E9, $2E, $00, $19, $EA, $96, $00, $86, $DA, $95, $05, $10, $5B, $4A, $00,
    $1C, $AB, $69, $00, $88, $2A, $D8, $03);

function DaysNumberOfDate(Date: TDate): Integer;
function CnMonthOfDate(Date: TDate; Days: Integer): string; OverLoad;
function CnMonthOfDate(Date: TDate): string; OverLoad;
function CnMonth(Date: TDate): Integer;
function CnDay(Date: TDate): Integer;
function CnDayOfDate(Date: TDate): string; overload;
function CnDayOfDate(Year, Month, Day: integer): string; overload;
function CnDayOfDate(Date: TDate; Days: integer; ShowDate: Boolean = false): string; overload;
function CnDateOfDateStr(Date: TDate): string;
function CnDayOfDatePH(Date: TDate): string;
function CnDateOfDateStrPH(Date: TDate): string;
function CnDayOfDateJr(Date: TDate): string; overload;
function CnDayOfDateJr(Date: TDate; Days: Integer): string; overload;
function CnanimalOfYear(Date: TDate): string;
function CnSkyStemOfYear(Date: TDate): string;
function CnSolarTerm(Date: TDate): string;
function GetLunarHolDay(InDate: TDateTime): string; overload;
function GetLunarHolDay(InDate: TDateTime; Days: Integer): string; overload;
function l_GetLunarHolDay(iYear, iMonth, iDay: Word): Word;
function GetAnimal(Date: TDate): integer;
function GetCnDateToDate(dDate: TDateTime): TDateTime; overload;
function GetCnDateToDate(cYear, cMonth, cDay: word): TDateTime; overload;
function OtherHoliday(Month, Day: integer): string;
function Holiday(Date: TDateTime; Day: integer): string;
function GetDays(ADate: TDate): Extended;
function Constellation(Date: TDateTime; Day: integer): string; overload;
function Constellation(ADate: TDate): string; overload;

implementation

function Year(MyDate: TDateTime): Word;
begin
  result := StrToInt(FormatDateTime('yyyy', MyDate)); //SetDates(MyDate, 1);
end;

function Month(MyDate: TDateTime): Word;
begin
  result := StrToInt(FormatDateTime('mm', MyDate)); //SetDates(MyDate, 2);
end;

function day(MyDate: TDateTime): Word;
begin
  result := StrToInt(FormatDateTime('dd', MyDate)); //SetDates(MyDate, 3);
end;

function DaysNumberOfDate(Date: TDate): Integer;
var
  DaysNumber: Integer;
  I: Integer;
  yyyy, mm, dd: Word;
begin
  DecodeDate(Date, yyyy, mm, dd);
  DaysNumber := 0;
  for I := 1 to mm - 1 do
    Inc(DaysNumber, MonthDays[IsLeapYear(yyyy), I]);
  Inc(DaysNumber, dd);
  Result := DaysNumber;
end;

function GetAnimal(Date: TDate): integer;
var
  Animal: string;
begin
  Animal := CnanimalOfYear(Date);
  if Animal = '����' then result := 0;
  if Animal = '��ţ' then result := 1;
  if Animal = '����' then result := 2;
  if Animal = 'î��' then result := 3;
  if Animal = '����' then result := 4;
  if Animal = '����' then result := 5;
  if Animal = '����' then result := 6;
  if Animal = 'δ��' then result := 7;
  if Animal = '���' then result := 8;
  if Animal = '�ϼ�' then result := 9;
  if Animal = '�繷' then result := 10;
  if Animal = '����' then result := 11;
end;

function CnDateOfDate(Date: TDate): Integer;
var
  CnMonth, CnMonthDays: array[0..15] of Integer;
  CnBeginDay, LeapMonth: Integer;
  yyyy, mm, dd: Word;
  Bytes: array[0..3] of Byte;
  I: Integer;
  CnMonthData: Word;
  DaysCount, CnDaysCount, ResultMonth, ResultDay: Integer;
begin
  DecodeDate(Date, yyyy, mm, dd);
  if (yyyy < 1901) or (yyyy > 2050) then
  begin
    Result := 0;
    Exit;
  end;
  Bytes[0] := CnData[(yyyy - 1901) * 4];
  Bytes[1] := CnData[(yyyy - 1901) * 4 + 1];
  Bytes[2] := CnData[(yyyy - 1901) * 4 + 2];
  Bytes[3] := CnData[(yyyy - 1901) * 4 + 3];
  if (Bytes[0] and $80) <> 0 then
    CnMonth[0] := 12
  else
    CnMonth[0] := 11;
  CnBeginDay := (Bytes[0] and $7F);
  CnMonthData := Bytes[1];
  CnMonthData := CnMonthData shl 8;
  CnMonthData := CnMonthData or Bytes[2];
  LeapMonth := Bytes[3];
  for I := 15 downto 0 do
  begin
    CnMonthDays[15 - I] := 29;
    if ((1 shl I) and CnMonthData) <> 0 then
      Inc(CnMonthDays[15 - I]);
    if CnMonth[15 - I] = LeapMonth then
      CnMonth[15 - I + 1] := -LeapMonth
    else
    begin
      if CnMonth[15 - I] < 0 then
        CnMonth[15 - I + 1] := -CnMonth[15 - I] + 1
      else
        CnMonth[15 - I + 1] := CnMonth[15 - I] + 1;
      if CnMonth[15 - I + 1] > 12 then CnMonth[15 - I + 1] := 1;
    end;
  end;
  DaysCount := DaysNumberOfDate(Date) - 1;
  if DaysCount <= (CnMonthDays[0] - CnBeginDay) then
  begin
    if (yyyy > 1901) and
      (CnDateOfDate(EncodeDate(yyyy - 1, 12, 31)) < 0) then
      ResultMonth := -CnMonth[0]
    else
      ResultMonth := CnMonth[0];
    ResultDay := CnBeginDay + DaysCount;
  end
  else
  begin
    CnDaysCount := CnMonthDays[0] - CnBeginDay;
    I := 1;
    while (CnDaysCount < DaysCount) and
      (CnDaysCount + CnMonthDays[I] < DaysCount) do
    begin
      Inc(CnDaysCount, CnMonthDays[I]);
      Inc(I);
    end;
    ResultMonth := CnMonth[I];
    ResultDay := DaysCount - CnDaysCount;
  end;
  if ResultMonth > 0 then
    Result := ResultMonth * 100 + ResultDay
  else
    Result := ResultMonth * 100 - ResultDay
end;

function CnMonth(Date: TDate): Integer;
begin
  Result := Abs(CnDateOfDate(Date) div 100);
end;

function CnMonthOfDate(Date: TDate; Days: Integer): string;
var
  Year, Month, Day: word;
begin
  DecodeDate(Date, Year, Month, Day);
  Result := CnMonthOfDate(EncodeDate(Year, Month, Days));

end;

function CnMonthOfDate(Date: TDate): string;
const
  CnMonthStr: array[1..12] of string = ('��', '��', '��', '��', '��', '��', '��', '��', '��', 'ʮ','��', '��');
var
  Month: Integer;
begin
  Month := CnDateOfDate(Date) div 100;
  if Month < 0 then
    Result := '��' + CnMonthStr[-Month]
  else
    Result := CnMonthStr[Month] + '��';
end;

function CnDayOfDatePH(Date: TDate): string;
const
  CnDayStr: array[1..30] of string = (
    '��һ', '����', '����', '����', '����',
    '����', '����', '����', '����', '��ʮ',
    'ʮһ', 'ʮ��', 'ʮ��', 'ʮ��', 'ʮ��',
    'ʮ��', 'ʮ��', 'ʮ��', 'ʮ��', '��ʮ',
    'إһ', 'إ��', 'إ��', 'إ��', 'إ��',
    'إ��', 'إ��', 'إ��', 'إ��', '��ʮ');
var
  Day: Integer;
begin
  Day := Abs(CnDateOfDate(Date)) mod 100;
  Result := CnDayStr[Day];
end;

function CnDateOfDateStr(Date: TDate): string;
begin
  Result := CnMonthOfDate(Date) + CnDayOfDatePH(Date);
end;

function CnDayOfDate(Date: TDate; Days: integer; ShowDate: Boolean = false): string; //ָ�����ڵ�ũ���հ�������
var
  Year, Month, Day: word;
begin
  DecodeDate(Date, Year, Month, Day);
  Result := CnDayOfDate(EncodeDate(Year, Month, Days));
end;

function CnDayOfDate(Year, Month, Day: integer): string; overload; //ָ�����ڵ�ũ���հ�������
begin
  Result := CnDayOfDate(EncodeDate(Year, Month, Day));
end;


function CnDay(Date: TDate): Integer;
begin
  Result := Abs(CnDateOfDate(Date)) mod 100;
end;

function CnDayOfDate(Date: TDate): string;
const
  CnDayStr: array[1..30] of string = (
    '��һ', '����', '����', '����', '����',
    '����', '����', '����', '����', '��ʮ',
    'ʮһ', 'ʮ��', 'ʮ��', 'ʮ��', 'ʮ��',
    'ʮ��', 'ʮ��', 'ʮ��', 'ʮ��', '��ʮ',
    'إһ', 'إ��', 'إ��', 'إ��', 'إ��',
    'إ��', 'إ��', 'إ��', 'إ��', '��ʮ');
var
  Day: Integer;
begin
  Day := Abs(CnDateOfDate(Date)) mod 100;
  Result := CnDayStr[Day];
end;

function CnDateOfDateStrPH(Date: TDate): string;
begin
  Result := CnMonthOfDate(Date) + CnDayOfDate(Date);
end;

function CnDayOfDateJr(Date: TDate; Days: Integer): string;
var
  Year, Month, Day: word;
begin
  DecodeDate(Date, Year, Month, Day);
  Result := CnDayOfDateJr(EncodeDate(Year, Month, Days));

end;

function CnDayOfDateJr(Date: TDate): string;
var
  Day: Integer;
begin
  Result := '';
  Day := Abs(CnDateOfDate(Date)) mod 100;
  case Day of
    1:  if (CnMonthOfDate(Date) = '����') then  Result := '����';
    5:  if CnMonthOfDate(Date) = '����' then    Result := '�����';
    7:  if CnMonthOfDate(Date) = '����' then    Result := '��Ϧ��';
    15: if CnMonthOfDate(Date) = '����' then    Result := '�����' else  if (CnMonthOfDate(Date) = '����') then Result := 'Ԫ����';
    9:  if CnMonthOfDate(Date) = '����' then    Result := '������';
    8:  if CnMonthOfDate(Date) = '����' then    Result := '���˽�';
  else
    if (CnMonthOfDate(Date + 1) = '����') and (CnMonthOfDate(Date) <> '����') then
      Result := '��Ϧ';
  end; {case}
end;

function CnanimalOfYear(Date: TDate): string;
var
  i: integer;
  DateStr: string;
begin
  DateStr := FormatDateTime('yyyy/mm/dd', Date);
  i := length(inttostr(month(date)));
  case (StrToInt(Copy(DateStr, 1, 4)) - StrToInt(BaseAnimalDate))
    mod 12 of
    0:
      if (StrToInt(Copy(DateStr, 6, i)) < 4) and ((Pos('��', CnMonthOfDate(Date)) = 0) and (Pos('��', CnMonthOfDate(Date)) = 0)) then
        Result := '����'
      else
      begin
        if StrToInt(Copy(DateStr, 6, i)) < 4 then
          Result := '����'
        else
          Result := '����';
      end;
    1, -11:
      if (StrToInt(Copy(DateStr, 6, i)) < 4) and ((Pos('��',
        CnMonthOfDate(Date)) = 0) and (Pos('��', CnMonthOfDate(Date)) = 0)) then
        Result := '��ţ'
      else
      begin
        if StrToInt(Copy(DateStr, 6, i)) < 4 then
          Result := '����'
        else
          Result := '��ţ';
      end;
    2, -10:
      if (StrToInt(Copy(DateStr, 6, i)) < 4) and ((Pos('��',
        CnMonthOfDate(Date)) = 0) and (Pos('��', CnMonthOfDate(Date)) = 0)) then
        Result := '����'
      else
      begin
        if StrToInt(Copy(DateStr, 6, i)) < 4 then
          Result := '��ţ'
        else
          Result := '����';
      end;
    3, -9:
      if (StrToInt(Copy(DateStr, 6, i)) < 4) and ((Pos('��',
        CnMonthOfDate(Date)) = 0) and (Pos('��', CnMonthOfDate(Date)) = 0)) then
        Result := 'î��'
      else
      begin
        if StrToInt(Copy(DateStr, 6, i)) < 4 then
          Result := '����'
        else
          Result := 'î��';
      end;
    4, -8:
      if (StrToInt(Copy(DateStr, 6, i)) < 4) and ((Pos('��',
        CnMonthOfDate(Date)) = 0) and (Pos('��', CnMonthOfDate(Date)) = 0)) then
        Result := '����'
      else
      begin
        if StrToInt(Copy(DateStr, 6, i)) < 4 then
          Result := 'î��'
        else
          Result := '����';
      end;
    5, -7:
      if (StrToInt(Copy(DateStr, 6, i)) < 4) and ((Pos('��',
        CnMonthOfDate(Date)) = 0) and (Pos('��', CnMonthOfDate(Date)) = 0)) then
        Result := '����'
      else
      begin
        if StrToInt(Copy(DateStr, 6, i)) < 4 then
          Result := '����'
        else
          Result := '����';
      end;
    6, -6:
      if (StrToInt(Copy(DateStr, 6, i)) < 4) and ((Pos('��',
        CnMonthOfDate(Date)) = 0) and (Pos('��', CnMonthOfDate(Date)) = 0)) then
        Result := '����'
      else
      begin
        if StrToInt(Copy(DateStr, 6, i)) < 4 then
          Result := '����'
        else
          Result := '����';
      end;
    7, -5:
      if (StrToInt(Copy(DateStr, 6, i)) < 4) and ((Pos('��',
        CnMonthOfDate(Date)) = 0) and (Pos('��', CnMonthOfDate(Date)) = 0)) then
        Result := 'δ��'
      else
      begin
        if StrToInt(Copy(DateStr, 6, i)) < 4 then
          Result := '����'
        else
          Result := 'δ��';
      end;
    8, -4:
      if (StrToInt(Copy(DateStr, 6, i)) < 4) and ((Pos('��',
        CnMonthOfDate(Date)) = 0) and (Pos('��', CnMonthOfDate(Date)) = 0)) then
        Result := '���'
      else
      begin
        if StrToInt(Copy(DateStr, 6, i)) < 4 then
          Result := 'δ��'
        else
          Result := '���';
      end;
    9, -3:
      if (StrToInt(Copy(DateStr, 6, i)) < 4) and ((Pos('��',
        CnMonthOfDate(Date)) = 0) and (Pos('��', CnMonthOfDate(Date)) = 0)) then
        Result := '�ϼ�'
      else
      begin
        if StrToInt(Copy(DateStr, 6, i)) < 4 then
          Result := '���'
        else
          Result := '�ϼ�';
      end;
    10, -2:
      if (StrToInt(Copy(DateStr, 6, i)) < 4) and ((Pos('��',
        CnMonthOfDate(Date)) = 0) and (Pos('��', CnMonthOfDate(Date)) = 0)) then
        Result := '�繷'
      else
      begin
        if StrToInt(Copy(DateStr, 6, i)) < 4 then
          Result := '�ϼ�'
        else
          Result := '�繷';
      end;
    11, -1:
      if (StrToInt(Copy(DateStr, 6, i)) < 4) and ((Pos('��',
        CnMonthOfDate(Date)) = 0) and (Pos('��', CnMonthOfDate(Date)) = 0)) then
        Result := '����'
      else
      begin
        if StrToInt(Copy(DateStr, 6, i)) < 4 then
          Result := '�繷'
        else
          Result := '����';
      end;
  end;
end;

function CnSkyStemOfYear(Date: TDate): string;
var
  i: integer;
  DateStr: string;
begin
  DateStr := FormatDateTime('yyyy/mm/dd', Date);
  i := length(inttostr(month(date)));
  case (StrToInt(Copy(DateStr, 1, 4)) - StrToInt(BaseSkyStemDate))
    mod 10 of
    0:
      if (StrToInt(Copy(DateStr, 6, i)) < 4) and ((Pos('��',
        CnMonthOfDate(Date)) = 0) and (Pos('��', CnMonthOfDate(Date)) = 0)) then
        Result := '��'
      else
      begin
        if StrToInt(Copy(DateStr, 6, i)) < 4 then
          Result := '��'
        else
          Result := '��';
      end;
    1, -9:
      if (StrToInt(Copy(DateStr, 6, i)) < 4) and ((Pos('��',
        CnMonthOfDate(Date)) = 0) and (Pos('��', CnMonthOfDate(Date)) = 0)) then
        Result := '��'
      else
      begin
        if StrToInt(Copy(DateStr, 6, i)) < 4 then
          Result := '��'
        else
          Result := '��';
      end;
    2, -8:
      if (StrToInt(Copy(DateStr, 6, i)) < 4) and ((Pos('��',
        CnMonthOfDate(Date)) = 0) and (Pos('��', CnMonthOfDate(Date)) = 0)) then
        Result := '��'
      else
      begin
        if StrToInt(Copy(DateStr, 6, i)) < 4 then
          Result := '��'
        else
          Result := '��';
      end;
    3, -7:
      if (StrToInt(Copy(DateStr, 6, i)) < 4) and ((Pos('��',
        CnMonthOfDate(Date)) = 0) and (Pos('��', CnMonthOfDate(Date)) = 0)) then
        Result := '��'
      else
      begin
        if StrToInt(Copy(DateStr, 6, i)) < 4 then
          Result := '��'
        else
          Result := '��';
      end;
    4, -6:
      if (StrToInt(Copy(DateStr, 6, i)) < 4) and ((Pos('��',
        CnMonthOfDate(Date)) = 0) and (Pos('��', CnMonthOfDate(Date)) = 0)) then
        Result := '��'
      else
      begin
        if StrToInt(Copy(DateStr, 6, i)) < 4 then
          Result := '��'
        else
          Result := '��';
      end;
    5, -5:
      if (StrToInt(Copy(DateStr, 6, i)) < 4) and ((Pos('��',
        CnMonthOfDate(Date)) = 0) and (Pos('��', CnMonthOfDate(Date)) = 0)) then
        Result := '��'
      else
      begin
        if StrToInt(Copy(DateStr, 6, i)) < 4 then
          Result := '��'
        else
          Result := '��';
      end;
    6, -4:
      if (StrToInt(Copy(DateStr, 6, i)) < 4) and ((Pos('��',
        CnMonthOfDate(Date)) = 0) and (Pos('��', CnMonthOfDate(Date)) = 0)) then
        Result := '��'
      else
      begin
        if StrToInt(Copy(DateStr, 6, i)) < 4 then
          Result := '��'
        else
          Result := '��';
      end;
    7, -3:
      if (StrToInt(Copy(DateStr, 6, i)) < 4) and ((Pos('��',
        CnMonthOfDate(Date)) = 0) and (Pos('��', CnMonthOfDate(Date)) = 0)) then
        Result := '��'
      else
      begin
        if StrToInt(Copy(DateStr, 6, i)) < 4 then
          Result := '��'
        else
          Result := '��';
      end;
    8, -2:
      if (StrToInt(Copy(DateStr, 6, i)) < 4) and ((Pos('��',
        CnMonthOfDate(Date)) = 0) and (Pos('��', CnMonthOfDate(Date)) = 0)) then
        Result := '��'
      else
      begin
        if StrToInt(Copy(DateStr, 6, i)) < 4 then
          Result := '��'
        else
          Result := '��';
      end;
    9, -1:
      if (StrToInt(Copy(DateStr, 6, i)) < 4) and ((Pos('��',
        CnMonthOfDate(Date)) = 0) and (Pos('��', CnMonthOfDate(Date)) = 0)) then
        Result := '��'
      else
      begin
        if StrToInt(Copy(DateStr, 6, i)) < 4 then
          Result := '��'
        else
          Result := '��';
      end;
  end;
  Result := Result + Copy(CnanimalOfYear(Date), 1, 3);
end;

function CnSolarTerm(Date: TDate): string;
var
  Year, Month, Day, Hour: Word;
begin
  DecodeDate(Date, Year, Month, Day);
end;

function GetLunarHolDay(InDate: TDateTime; Days: Integer): string;
var
  Year, Month, Day, Hour: Word;
begin
  DecodeDate(Date, Year, Month, Day);
  Result := GetLunarHolDay(EncodeDate(Year, Month, Days));

end;

function GetLunarHolDay(InDate: TDateTime): string;
var
  i, iYear, iMonth, iDay: Word;
begin
  Result := '';
  DecodeDate(InDate, iYear, iMonth, iDay);
  i := l_GetLunarHolDay(iYear, iMonth, iDay);
  case i of
    1: Result := 'С��';
    2: Result := '��';
    3: Result := '����';
    4: Result := '��ˮ';
    5: Result := '����';
    6: Result := '����';
    7: Result := '����';
    8: Result := '����';
    9: Result := '����';
    10: Result := 'С��';
    11: Result := 'â��';
    12: Result := '����';
    13: Result := 'С��';
    14: Result := '����';
    15: Result := '����';
    16: Result := '����';
    17: Result := '��¶';
    18: Result := '���';
    19: Result := '��¶';
    20: Result := '˪��';
    21: Result := '����';
    22: Result := 'Сѩ';
    23: Result := '��ѩ';
    24: Result := '����';
  end;
end;

function l_GetLunarHolDay(iYear, iMonth, iDay: Word): Word;
var
  Flag: Byte;
  Day: Word;
begin
  Flag := gLunarHolDay[(iYear - START_YEAR) * 12 + iMonth - 1];
  if iDay < 15 then
    Day := 15 - ((Flag shr 4) and $0F)
  else
    Day := (Flag and $0F) + 15;
  if iDay = Day then
    if iDay > 15 then
      Result := (iMonth - 1) * 2 + 2
    else
      Result := (iMonth - 1) * 2 + 1
  else
    Result := 0;
end;


function OtherHoliday(Month, Day: integer): string;
begin
end;

function Holiday(Date: TDateTime; Day: integer): string; //�ɹ������ھ����Ľڼ���
var
  dDate: TDate;
begin
  result := '';
  case Month(Date) of
    1:
      begin
        if day = 1 then result := 'Ԫ����';
      end;
    2:
      begin
        if day = 2 then  result := 'ʪ����';
        if day = 10 then result := '�����';
        if day = 14 then result := '���˽�';
      end;
    3:
      begin
        if day = 3 then  result := '������';
        if day = 8 then  result := '��Ů��';
        if day = 12 then result := 'ֲ����';
        if day = 14 then result := '������';
        if day = 15 then result := '���ѽ�';
        if day = 21 then result := 'ɭ����';
        if day = 22 then result := 'ˮ��';
        if day = 23 then result := '������';
      end;
    4:
      begin
        if day = 1 then  result := '���˽�';
        if day = 7 then  result := '������';
        if day = 22 then result := '������';
      end;
    5:
      begin
        if day = 1 then  result := '�Ͷ���';
        if day = 4 then  result := '�����';
        if day = 8 then  result := '��ʮ��';
        if day = 12 then result := '��ʿ��';
        if day = 15 then result := '��ͥ��';
        if day = 17 then result := '������';
        if day = 18 then result := '�����';
        if day = 19 then result := '������';
        if day = 23 then result := 'ţ����';
        if day = 31 then result := '������';
        dDate := EnCodeDate(Year(Date), Month(Date), Day);
        if (DayOfWeek(dDate) = 1) then if (Trunc((Day - 1) / 7) = 1) then result := 'ĸ�׽�';
      end;
    6:
      begin
        if day = 1 then  result := '��ͯ��';
        if day = 5 then  result := '������';
        if day = 6 then  result := '������';
        if day = 23 then result := '������';
        if day = 25 then result := '������';
        if day = 26 then result := '����Ʒ';
        dDate := EnCodeDate(Year(Date), Month(Date), Day);
        if (DayOfWeek(dDate) = 1) then if (Trunc((Day - 1) / 7) = 2) then result := '���׽�';
      end;
    7:
      begin
        if day = 1 then  result := '������';
        if day = 11 then result := '�˿���';
      end;
    8:
      begin
        if day = 1 then result := '������';
      end;
    9:
      begin
        if day = 8 then  result := 'ɨä��';
        if day = 10 then result := '��ʦ��';
        if day = 17 then result := '��ƽ��';
        if day = 20 then result := '������';
        if day = 22 then result := '���˽�';
        if day = 27 then result := '������';
      end;
    10:
      begin
        if day = 1 then  result := '�����';
        if day = 4 then  result := '������';
        if day = 6 then  result := '���˽�';
        if day = 7 then  result := 'ס����';
        if day = 9 then  result := '������';
        if day = 15 then result := 'ä�˽�';
        if day = 16 then result := '��ʳ��';
        if day = 31 then result := '��ʥ��';
      end;
    11:
      begin
        if day = 8 then  result := '������';
        if day = 9 then  result := '������';
        if day = 17 then result := '��ѧ��';
        dDate := EnCodeDate(Year(Date), Month(Date), Day);
        if (DayOfWeek(dDate) = 5) then if (Trunc((Day - 1) / 7) = 3) then result := '�ж���';
      end;
    12:
      begin
        if day = 9 then  result := '������';
        if day = 24 then result := 'ƽ��ҹ';
        if day = 25 then result := 'ʥ����';
      end;
  end;
end;

function GetCnDateToDate(dDate: TDateTime): TDateTime;
begin
  Result := GetCnDateToDate(Year(Now), CnMonth(dDate), CnDay(dDate));
end;

function GetCnDateToDate(cYear, cMonth, cDay: word): TDateTime;
var
  tempDate: TDateTime;
  tempDay, tempMonth: Integer;

begin
  if cMonth > 11 then
    tempDate := EnCodeDate(cYear - 1, cMonth, cDay)
  else
    tempDate := EnCodeDate(cYear, cMonth, cDay);
  Result := 0;
  tempMonth := 0;
  tempDay := 0;
  while Result = 0 do
  begin
    tempDate := tempDate + 1;
    if CnMonth(tempDate) = cMonth then
      if CnDay(tempDate) = cDay then
      begin
        Result := tempDate;
        exit;
      end
      else
        if (cDay = 30) and (CnDay(tempDate) = 29)
          and (CnDay(tempDate + 1) <> 30) then
        begin
          Result := tempDate;
          exit;
        end;

  end;
end;

function GetDays(ADate: TDate): Extended;
var
  FirstOfYear: TDateTime;
begin
  FirstOfYear := EncodeDate(StrToInt(FormatDateTime('yyyy', now)) - 1, 12, 31);
  Result := ADate - FirstOfYear;
end;

function Constellation(Date: TDateTime; Day: integer): string; overload;
var
  Year, Month, Days, Hour: Word;
begin
  DecodeDate(Date, Year, Month, Days);
  Result := Constellation(EncodeDate(Year, Month, Day));
end;

function Constellation(ADate: TDate): string;  //�ɹ����������������
begin
  case Month(ADate) of
    1:
      begin
        if day(ADate) <= 19 then result := 'Ħ����';
        if day(ADate) >= 20 then result := 'ˮƿ��';
      end;
    2:
      begin
        if day(ADate) <= 18 then result := 'ˮƿ��';
        if day(ADate) >= 19 then result := '˫����';
      end;
    3:
      begin
        if day(ADate) <= 20 then result := '˫����';
        if day(ADate) >= 21 then result := '������';
      end;
    4:
      begin
        if day(ADate) <= 19 then result := '������';
        if day(ADate) >= 20 then result := '��ţ��';
      end;
    5:
      begin
        if day(ADate) <= 20 then result := '��ţ��';
        if day(ADate) >= 21 then result := '˫����';
      end;
    6:
      begin
        if day(ADate) <= 21 then result := '˫����';
        if day(ADate) >= 22 then result := '��з��';
      end;
    7:
      begin
        if day(ADate) <= 22 then result := '��з��';
        if day(ADate) >= 23 then result := 'ʨ����';
      end;
    8:
      begin
        if day(ADate) <= 22 then result := 'ʨ����';
        if day(ADate) >= 24 then result := '��Ů��';
      end;

    9:
      begin
        if day(ADate) <= 22 then result := '��Ů��';
        if day(ADate) >= 23 then result := '�����';
      end;
    10:
      begin
        if day(ADate) <= 23 then result := '�����';
        if day(ADate) >= 24 then result := '��Ы��';
      end;
    11:
      begin
        if day(ADate) <= 21 then result := '��Ы��';
        if day(ADate) >= 22 then result := '������';
      end;
    12:
      begin
        if day(ADate) <= 21 then result := '������';
        if day(ADate) >= 22 then result := 'Ħ����';
      end;
  end;
end;

end.

