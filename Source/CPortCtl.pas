(******************************************************
 * ComPort Library ver. 4.11                          *
 *   for Delphi 5, 6, 7, 2007-2010,XE  and            *
 *   C++ Builder 3, 4, 5, 6                           *
 * written by Dejan Crnila, 1998 - 2002               *
 * maintained by Lars B. Dybdahl, 2003                *
 * Homepage: http://comport.sf.net/                   *
 *                                                    *
 * Brian Gochnauer Oct 2010                           *
 *     Removed ansi references for backward compat    *
 *     Made unicode ready                             *
 *****************************************************)

{Met wijziging door mij aangebracht, zie:
- TAdvanceCaret
  acPage: clear screen added
- procedure TCustomComTerminal.AdvanceCaret(Kind: TAdvanceCaret);
  commando newpage toegevoegd
- procedure TCustomComTerminal.SetAttributes(AParams: TStrings);
  30 ... 49 for foreground and background colors
- function TCustomComTerminal.GetCharAttr: TComTermChar;
  Colorchanging made possible
- procedure TCustomComTerminal.PutChar(Ch: Char);
  splitsing between linefeed and newpage
}
unit CPortCtl;
{$Warnings OFF}
{$I CPort.inc}

interface

uses
  Classes, Controls, StdCtrls, ExtCtrls, Forms,
  Messages, Graphics, Windows, CPort, CPortEsc;

type
  // property types
  TComProperty = (cpNone, cpPort, cpBaudRate, cpDataBits, cpStopBits,
    cpParity, cpFlowControl);

  // assistant class for TComComboBox, TComRadioGroup controls
  TComSelect = class
  private
    FPort: TPort;
    FBaudRate: TBaudRate;
    FDataBits: TDataBits;
    FStopBits: TStopBits;
    FParity: TParityBits;
    FFlowControl: TFlowControl;
    FItems: TStrings;
    FComProperty: TComProperty;
    FComPort: TCustomComPort;
    FAutoApply: Boolean;
  private
    procedure SetComProperty(const Value: TComProperty);
  public
    procedure SelectPort;
    procedure SelectBaudRate;
    procedure SelectParity;
    procedure SelectStopBits;
    procedure SelectDataBits;
    procedure SelectFlowControl;
    procedure Change(const Text: string);
    procedure UpdateSettings(var ItemIndex: Integer);
    procedure ApplySettings;
    property Items: TStrings read FItems write FItems;
    property ComProperty: TComProperty read FComProperty write SetComProperty;
    property ComPort: TCustomComPort read FComPort write FComPort;
    property AutoApply: Boolean read FAutoApply write FAutoApply;
  end;

  // combo control for selecting port properties
  TComComboBox = class(TCustomComboBox)
  private
    FComSelect: TComSelect;
    function GetAutoApply: Boolean;
    function GetComPort: TCustomComPort;
    function GetComProperty: TComProperty;
    function GetText: string;
    procedure SetAutoApply(const Value: Boolean);
    procedure SetComPort(const Value: TCustomComPort);
    procedure SetComProperty(const Value: TComProperty);
    procedure SetText(const Value: string);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Change; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ApplySettings;
    procedure UpdateSettings;
  published
    property ComPort: TCustomComPort read GetComPort write SetComPort;
    property ComProperty: TComProperty read GetComProperty write SetComProperty default cpNone;
    property AutoApply: Boolean read GetAutoApply write SetAutoApply default False;
    property Text: string read GetText write SetText;
    property Style;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property DropDownCount;
    property Enabled;
    property Font;
    property ImeMode;
    property ImeName;
    property ItemHeight;
    property ItemIndex;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
{$IFDEF DELPHI_4_OR_HIGHER}
    property Anchors;
    property BiDiMode;
    property CharCase;
    property Constraints;
    property DragKind;
    property ParentBiDiMode;
{$ENDIF}
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnDropDown;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMeasureItem;
    property OnStartDrag;
{$IFDEF DELPHI_4_OR_HIGHER}
    property OnEndDock;
    property OnStartDock;
{$ENDIF}
{$IFDEF DELPHI_5_OR_HIGHER}
    property OnContextPopup;
{$ENDIF}
  end;

  // radio group control for selecting port properties
  TComRadioGroup = class(TCustomRadioGroup)
  private
    FComSelect: TComSelect;
    FOldIndex: Integer;
    function GetAutoApply: Boolean;
    function GetComPort: TCustomComPort;
    function GetComProperty: TComProperty;
    procedure SetAutoApply(const Value: Boolean);
    procedure SetComPort(const Value: TCustomComPort);
    procedure SetComProperty(const Value: TComProperty);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Click; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ApplySettings;
    procedure UpdateSettings;
  published
    property ComPort: TCustomComPort read GetComPort write SetComPort;
    property ComProperty: TComProperty read GetComProperty write SetComProperty default cpNone;
    property AutoApply: Boolean read GetAutoApply write SetAutoApply default False;
    property Align;
    property Caption;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property ItemIndex;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
{$IFDEF DELPHI_4_OR_HIGHER}
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DockSite;
    property DragKind;
    property ParentBiDiMode;
{$ENDIF}
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnStartDrag;
    property OnEnter;
    property OnExit;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseDown;
{$IFDEF DELPHI_4_OR_HIGHER}
    property OnEndDock;
    property OnStartDock;
    property OnGetSiteInfo;
    property OnDockDrop;
    property OnDockOver;
    property OnUnDock;
{$ENDIF}
{$IFDEF DELPHI_5_OR_HIGHER}
    property OnContextPopup;
{$ENDIF}
  end;

  // property types
  TLedBitmap = Graphics.TBitmap;
  TLedKind = (lkRedLight, lkGreenLight, lkBlueLight, lkYellowLight,
    lkPurpleLight, lkBulb, lkCustom);
  TComLedSignal = (lsConn, lsCTS, lsDSR, lsRLSD, lsRing, lsRx, lsTx);
  TLedState = (lsOff, lsOn);
  TComLedGlyphs = array[TLedState] of TLedBitmap;
  TLedStateEvent = procedure(Sender: TObject; AState: TLedState) of object;

  // led control that shows the state of serial signals
  TComLed = class(TGraphicControl)
  private
    FComPort: TComPort;
    FLedSignal: TComLedSignal;
    FKind: TLedKind;
    FState: TLedState;
    FOnChange: TLedStateEvent;
    FGlyphs: TComLedGlyphs;
    FComLink: TComLink;
    FRingTimer: TTimer;
    function GetGlyph(const Index: Integer): TLedBitmap;
    function GetRingDuration: Integer;
    procedure SetComPort(const Value: TComPort);
    procedure SetKind(const Value: TLedKind);
    procedure SetState(const Value: TLedState);
    procedure SetLedSignal(const Value: TComLedSignal);
    procedure SetGlyph(const Index: Integer; const Value: TLedBitmap);
    procedure SetRingDuration(const Value: Integer);
    function StoredGlyph(const Index: Integer): Boolean;
    procedure SelectLedBitmap(const LedKind: TLedKind);
    procedure SetStateInternal(const Value: TLedState);
    function CalcBitmapPos: TPoint;
    function BitmapToDraw: TLedBitmap;
    procedure BitmapNeeded;
    procedure SignalChange(Sender: TObject; OnOff: Boolean);
    procedure RingDetect(Sender: TObject);
    procedure DoTimer(Sender: TObject);
    function IsStateOn: Boolean;
  protected
    procedure Paint; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DoChange(AState: TLedState); dynamic;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ComPort: TComPort read FComPort write SetComPort;
    property LedSignal: TComLedSignal read FLedSignal write SetLedSignal;
    // kind property must be published before GlyphOn, GlyphOff
    property Kind: TLedKind read FKind write SetKind;
    property GlyphOn: TLedBitmap index 0
      read GetGlyph write SetGlyph stored StoredGlyph;
    property GlyphOff: TLedBitmap index 1
      read GetGlyph write SetGlyph stored StoredGlyph;
    property State: TLedState read FState write SetState default lsOff;
    property RingDuration: Integer read GetRingDuration write SetRingDuration default 1000;
    property Align;
    property DragCursor;
    property DragMode;
    property Enabled;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
{$IFDEF DELPHI_4_OR_HIGHER}
    property Anchors;
    property Constraints;
    property DragKind;
    property ParentBiDiMode;
{$ENDIF}
    property OnChange: TLedStateEvent read FOnChange write FOnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
{$IFDEF DELPHI_4_OR_HIGHER}
    property OnEndDock;
    property OnResize;
    property OnStartDock;
{$ENDIF}
{$IFDEF DELPHI_5_OR_HIGHER}
    property OnContextPopup;
{$ENDIF}
  end;

  TCustomComTerminal = class;  // forward declaration

  // terminal character
  TComTermChar = record
    Ch: Char;
    FrontColor: TColor;
    BackColor: TColor;
    Underline: Boolean;
  end;

  // buffer which holds terminal screen data
  TComTermBuffer = class
  private
    FBuffer: Pointer;
    FTabs: Pointer;
    FOwner: TCustomComTerminal;
  public
    constructor Create(AOwner: TCustomComTerminal);
    destructor Destroy; override;
    procedure Init;
    procedure SetChar(Column, Row: Integer; TermChar: TComTermChar);
    function GetChar(Column, Row: Integer): TComTermChar;
    procedure SetTab(Column: Integer; Put: Boolean);
    function GetTab(Column: Integer): Boolean;
    function NextTab(Column: Integer): Integer;
    procedure ClearAllTabs;
    procedure ScrollDown;
    procedure ScrollUp;
    procedure EraseScreen(Column, Row: Integer);
    procedure EraseLine(Column, Row: Integer);
    function GetLineLength(Line: Integer): Integer;
    function GetLastLine: Integer;
  end;

  // terminal types
  TTermEmulation = (teVT100orANSI, teVT52, teNone);
  TTermCaret = (tcBlock, tcUnderline, tcNone);
  TAdvanceCaret = (acChar, acReturn, acLineFeed, acReverseLineFeed,
    acTab, acBackspace, acPage);
  TArrowKeys = (akTerminal, akWindows);
  TTermAttributes = record
    FrontColor: TColor;
    BackColor: TColor;
    Invert: Boolean;
    AltIntensity: Boolean;
    Underline: Boolean;
  end;
  TTermMode = record
    Keys: TArrowKeys;
  end;

  TEscapeEvent = procedure(Sender: TObject; var EscapeCodes: TEscapeCodes) of object;
  TUnhandledEvent = procedure(Sender: TObject; Code: TEscapeCode; Data: string) of object;
  TStrRecvEvent = procedure(Sender: TObject; var Str: string) of object;
  TChScreenEvent = procedure(Sender: TObject; Ch: Char) of object;

  // communication terminal control
  TCustomComTerminal = class(TCustomControl)
  private
    FComLink: TComLink;
    FComPort: TCustomComPort;
    FBorderStyle: TBorderStyle;
    FScrollBars: TScrollStyle;
    FArrowKeys: TArrowKeys;
    FWantTab: Boolean;
    FColumns: Integer;
    FRows: Integer;
    FAltColor: TColor;
    FLocalEcho: Boolean;
    FSendLF: Boolean;
    FAppendLF: Boolean;
    FForce7Bit: Boolean;
    FWrapLines: Boolean;
    FSmoothScroll: Boolean;
    FFontHeight: Integer;
    FFontWidth: Integer;
    FEmulation: TTermEmulation;
    FCaret: TTermCaret;
    FCaretPos: TPoint;
    FSaveCaret: TPoint;
    FCaretCreated: Boolean;
    FTopLeft: TPoint;
    FCaretHeight: Integer;
    FSaveAttr: TTermAttributes;
    FBuffer: TComTermBuffer;
    FEscapeCodes: TEscapeCodes;
    FTermAttr: TTermAttributes;
    FTermMode: TTermMode;
    FOnChar: TChScreenEvent;
    FOnGetEscapeCodes: TEscapeEvent;
    FOnUnhandledCode: TUnhandledEvent;
    FOnStrRecieved: TStrRecvEvent;
    procedure AdvanceCaret(Kind: TAdvanceCaret);
    function CalculateMetrics: Boolean;
    procedure CreateEscapeCodes;
    procedure CreateTerminalCaret;
    procedure DrawChar(AColumn, ARow: Integer; Ch: TComTermChar);
    function GetCharAttr: TComTermChar;
    function GetConnected: Boolean;
    procedure HideCaret;
    procedure InitCaret;
    procedure InvalidatePortion(ARect: TRect);
    procedure ModifyScrollBar(ScrollBar, ScrollCode, Pos: Integer);
    procedure SetAltColor(const Value: TColor);
    procedure SetBorderStyle(const Value: TBorderStyle);
    procedure SetColumns(const Value: Integer);
    procedure SetComPort(const Value: TCustomComPort);
    procedure SetConnected(const Value: Boolean);
    procedure SetEmulation(const Value: TTermEmulation);
    procedure SetRows(const Value: Integer);
    procedure SetScrollBars(const Value: TScrollStyle);
    procedure SetCaret(const Value: TTermCaret);
    procedure SetAttributes(AParams: TStrings);
    procedure SetMode(AParams: TStrings; OnOff: Boolean);
    procedure ShowCaret;
    procedure StringReceived(Str: string);
    procedure PaintTerminal(Rect: TRect);
    procedure PaintDesign;
    procedure PutChar(Ch: Char);
    function PutEscapeCode(ACode: TEscapeCode; AParams: TStrings): Boolean;
    procedure RestoreAttr;
    procedure RestoreCaretPos;
    procedure RxBuf(Sender: TObject; const Buffer; Count: Integer);
    procedure SaveAttr;
    procedure SaveCaretPos;
    procedure SendChar(Ch: Char);
    procedure SendCode(Code: TEscapeCode; AParams: TStrings);
    procedure SendCodeNoEcho(Code: TEscapeCode; AParams: TStrings);
    procedure PerformTest(ACh: Char);
    procedure UpdateScrollPos;
    procedure UpdateScrollRange;
  protected
    procedure CMCtl3DChanged(var Message: TMessage); message CM_CTL3DCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure WMKillFocus(var Message: TWMSetFocus); message WM_KILLFOCUS;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
{$IFDEF DELPHI_4_OR_HIGHER}
    function CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;
{$ENDIF}
    procedure CreateParams(var Params: TCreateParams); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
    procedure DoChar(Ch: Char); dynamic;
    procedure DoGetEscapeCodes(var EscapeCodes: TEscapeCodes); dynamic;
    procedure DoStrRecieved(var Str: string); dynamic;
    procedure DoUnhandledCode(Code: TEscapeCode; Data: string); dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ClearScreen;
    procedure MoveCaret(AColumn, ARow: Integer);
    procedure Write(const Buffer:string; Size: Integer);
    procedure WriteStr(const Str: string);
    procedure WriteEscCode(ACode: TEscapeCode; AParams: TStrings);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);
    procedure SelectFont;
    procedure ShowSetupDialog;
    property AltColor: TColor read FAltColor write SetAltColor default $00A6A6A6;
    property AppendLF: Boolean read FAppendLF write FAppendLF default False;
    property ArrowKeys: TArrowKeys read FArrowKeys write FArrowKeys default akTerminal;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsSingle;
    property Caret: TTermCaret read FCaret write SetCaret default tcBlock;
    property Connected: Boolean read GetConnected write SetConnected stored False;
    property ComPort: TCustomComPort read FComPort write SetComPort;
    property Columns: Integer read FColumns write SetColumns default 80;
    property Emulation: TTermEmulation read FEmulation write SetEmulation;
    property EscapeCodes: TEscapeCodes read FEscapeCodes;
    property Force7Bit: Boolean read FForce7Bit write FForce7Bit default False;
    property LocalEcho: Boolean read FLocalEcho write FLocalEcho default False;
    property SendLF: Boolean read FSendLF write FSendLF default False;
    property ScrollBars: TScrollStyle read FScrollBars write SetScrollBars;
    property SmoothScroll: Boolean read FSmoothScroll write FSmoothScroll default False;
    property Rows: Integer read FRows write SetRows default 24;
    property WantTab: Boolean read FWantTab write FWantTab default False;
    property WrapLines: Boolean read FWrapLines write FWrapLines default False;
    property OnChar: TChScreenEvent read FOnChar write FOnChar;
    property OnGetEscapeCodes: TEscapeEvent
      read FOnGetEscapeCodes write FOnGetEscapeCodes;
    property OnStrRecieved: TStrRecvEvent
      read FOnStrRecieved write FOnStrRecieved;
    property OnUnhandledCode: TUnhandledEvent
      read FOnUnhandledCode write FOnUnhandledCode;
  end;

  // publish properties
  TComTerminal = class(TCustomComTerminal)
  published
    property Align;
    property AltColor;
    property AppendLF;
    property ArrowKeys;
    property BorderStyle;
    property Color;
    property Columns;
    property ComPort;
    property Connected;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Emulation;
    property Enabled;
    property Font;
    property Force7Bit;
    property Hint;
    property ImeMode;
    property ImeName;
    property LocalEcho;
    property ParentCtl3D;
    property ParentShowHint;
    property PopupMenu;
    property Rows;
    property ScrollBars;
    property SendLF;
    property ShowHint;
    property SmoothScroll;
    property TabOrder;
    property TabStop default True;
    property Caret;
    property Visible;
    property WantTab;
    property WrapLines;
{$IFDEF DELPHI_4_OR_HIGHER}
    property Anchors;
    property AutoSize;
    property Constraints;
    property DragKind;
{$ENDIF}
    property OnChar;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetEscapeCodes;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
    property OnStrRecieved;
    property OnUnhandledCode;
{$IFDEF DELPHI_4_OR_HIGHER}
    property OnCanResize;
    property OnConstrainedResize;
    property OnDockDrop;
    property OnEndDock;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDock;
    property OnUnDock;
{$ENDIF}
{$IFDEF DELPHI_5_OR_HIGHER}
    property OnContextPopup;
{$ENDIF}
  end;

var
  ComTerminalFont: TFont; // default terminal font

implementation

{$R CPortImg.res}

uses
  SysUtils, Dialogs, CPortTrmSet;

(*****************************************
 * auxilary functions                    *
 *****************************************)

function Min(A, B: Integer): Integer;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function Max(A, B: Integer): Integer;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

(*****************************************
 * TComSelect class                      *
 *****************************************)

// select baud rate property
procedure TComSelect.SelectBaudRate;
var
  I: TBaudRate;
begin
  Items.Clear;
  for I := Low(TBaudRate) to High(TBaudRate) do
    Items.Add(BaudRateToStr(I));
end;

// select port property
procedure TComSelect.SelectPort;
begin
  Items.Clear;
  EnumComPorts(Items);
end;

// select data bits property
procedure TComSelect.SelectDataBits;
var
  I: TDataBits;
begin
  Items.Clear;
  for I := Low(TDataBits) to High(TDataBits) do
    Items.Add(DataBitsToStr(I));
end;

// select parity property
procedure TComSelect.SelectParity;
var
  I: TParityBits;
begin
  Items.Clear;
  for I := Low(TParityBits) to High(TParityBits) do
    Items.Add(ParityToStr(I));
end;

// select stop bits property
procedure TComSelect.SelectStopBits;
var
  I: TStopBits;
begin
  Items.Clear;
  for I := Low(TStopBits) to High(TStopBits) do
    Items.Add(StopBitsToStr(I));
end;

// select flow control property
procedure TComSelect.SelectFlowControl;
var
  I: TFlowControl;
begin
  Items.Clear;
  for I := Low(TFlowControl) to High(TFlowControl) do
    Items.Add(FlowControlToStr(I));
end;

// set property port settings for selecting
procedure TComSelect.SetComProperty(const Value: TComProperty);
begin
  FComProperty := Value;
  case FComProperty of
    cpPort: SelectPort;
    cpBaudRate: SelectBaudRate;
    cpDataBits: SelectDataBits;
    cpStopBits: SelectStopBits;
    cpParity: SelectParity;
    cpFlowControl: SelectFlowControl;
  else
    Items.Clear;
  end;
end;

// set selected setting
procedure TComSelect.Change(const Text: string);
begin
  case FComProperty of
    cpPort: FPort := Text;
    cpBaudRate: FBaudRate := StrToBaudRate(Text);
    cpDataBits: FDataBits := StrToDataBits(Text);
    cpStopBits: FStopBits := StrToStopBits(Text);
    cpParity: FParity := StrToParity(Text);
    cpFlowControl: FFlowControl := StrToFlowControl(Text);
  end;
  if FAutoApply then
    ApplySettings;
end;

// apply settings to TCustomComPort
procedure TComSelect.ApplySettings;
begin
  if FComPort <> nil then
  begin
    with FComPort do
    begin
      case FComProperty of
        cpPort: Port := FPort;
        cpBaudRate: BaudRate := FBaudRate;
        cpDataBits: DataBits := FDataBits;
        cpStopBits: StopBits := FStopBits;
        cpParity: Parity.Bits := FParity;
        cpFlowControl: FlowControl.FlowControl := FFlowControl;
      end;
    end;
  end;
end;

// update settings from TCustomComPort
procedure TComSelect.UpdateSettings(var ItemIndex: Integer);
begin
  if FComPort <> nil then
    with FComPort do
      case FComProperty of
        cpPort:
        begin
          ItemIndex := Items.IndexOf(Port);
          if ItemIndex > -1 then
            FPort := Items[ItemIndex];
        end;
        cpBaudRate:
        begin
          ItemIndex := Items.IndexOf(BaudRateToStr(BaudRate));
          if ItemIndex > -1 then
            FBaudRate := StrToBaudRate(Items[ItemIndex]);
        end;
        cpDataBits:
        begin
          ItemIndex := Items.IndexOf(DataBitsToStr(DataBits));
          if ItemIndex > -1 then
            FDataBits := StrToDataBits(Items[ItemIndex]);
        end;
        cpStopBits:
        begin
          ItemIndex := Items.IndexOf(StopBitsToStr(StopBits));
          if ItemIndex > -1 then
            FStopBits := StrToStopBits(Items[ItemIndex]);
        end;
        cpParity:
        begin
          ItemIndex := Items.IndexOf(ParityToStr(Parity.Bits));
          if ItemIndex > -1 then
            FParity := StrToParity(Items[ItemIndex]);
        end;
        cpFlowControl:
        begin
          ItemIndex := Items.IndexOf(FlowControlToStr(FlowControl.FlowControl));
          if ItemIndex > -1 then
            FFlowControl := StrToFlowControl(Items[ItemIndex]);
        end;
      end;
end;

(*****************************************
 * TComComboBox control                  *
 *****************************************)

// create control
constructor TComComboBox.Create(AOwner: TComponent);
begin
  FComSelect := TComSelect.Create;
  inherited Create(AOwner);
  FComSelect.Items := Items;
  Style := csDropDownList;
end;

// destroy control
destructor TComComboBox.Destroy;
begin
  inherited Destroy;
  FComSelect.Free;
end;

// apply settings to TCustomComPort
procedure TComComboBox.ApplySettings;
begin
  FComSelect.ApplySettings;
end;

// update settings from TCustomComPort
procedure TComComboBox.UpdateSettings;
var
  Index: Integer;
begin
  FComSelect.UpdateSettings(Index);
  ItemIndex := Index;
end;

// remove ComPort property if being destroyed
procedure TComComboBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FComSelect.ComPort) and (Operation = opRemove) then
  begin
    FComSelect.ComPort := nil;
    if Items.Count > 0 then
      ItemIndex := 0;
  end;
end;

// perform change when selection is changed
procedure TComComboBox.Change;
begin
  FComSelect.Change(Text);
  inherited Change;
end;

// set ComPort property
procedure TComComboBox.SetComPort(const Value: TCustomComPort);
begin
  if FComSelect.ComPort <> Value then
  begin
    FComSelect.ComPort := Value;
    if FComSelect.ComPort <> nil then
    begin
      FComSelect.ComPort.FreeNotification(Self);
      // transfer settings from ComPort to this control
      UpdateSettings;
    end;
  end;
end;

function TComComboBox.GetComPort: TCustomComPort;
begin
  Result := FComSelect.ComPort;
end;

function TComComboBox.GetAutoApply: Boolean;
begin
  Result := FComSelect.AutoApply;
end;

procedure TComComboBox.SetAutoApply(const Value: Boolean);
begin
  FComSelect.AutoApply := Value;
end;

function TComComboBox.GetText: string;
begin
  if ItemIndex = -1 then
    Result := ''
  else
    Result := Items[ItemIndex];
end;

procedure TComComboBox.SetText(const Value: string);
begin
  if Items.IndexOf(Value) > -1 then
    ItemIndex := Items.IndexOf(Value);
end;

// change property for selecting
procedure TComComboBox.SetComProperty(const Value: TComProperty);
var
  Index: Integer;
begin
  FComSelect.ComProperty := Value;
  if Items.Count > 0 then
    if FComSelect.ComPort <> nil then
    begin
      // transfer settings from ComPort to this control
      FComSelect.UpdateSettings(Index);
      ItemIndex := Index;
    end
    else
      ItemIndex := 0;
end;

function TComComboBox.GetComProperty: TComProperty;
begin
  Result := FComSelect.ComProperty;
end;

(*****************************************
 * TRadioGroup control                   *
 *****************************************)

// create control
constructor TComRadioGroup.Create(AOwner: TComponent);
begin
  FComSelect := TComSelect.Create;
  inherited Create(AOwner);
  FComSelect.Items := Items;
  FOldIndex := -1;
end;

// destroy control
destructor TComRadioGroup.Destroy;
begin
  inherited Destroy;
  FComSelect.Free;
end;

// apply settings to TCustomComPort
procedure TComRadioGroup.ApplySettings;
begin
  FComSelect.ApplySettings;
end;

// update settings from TCustomComPort
procedure TComRadioGroup.UpdateSettings;
var
  Index: Integer;
begin
  FComSelect.UpdateSettings(Index);
  ItemIndex := Index;
  FOldIndex := Index;
end;

// remove ComPort property if being destroyed
procedure TComRadioGroup.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FComSelect.ComPort) and (Operation = opRemove) then
  begin
    FComSelect.ComPort := nil;
    if Items.Count > 0 then
    begin
      ItemIndex := 0;
      FOldIndex := 0;
    end;
  end;
end;

// perform change when radio button is clicked
procedure TComRadioGroup.Click;
begin
  if FOldIndex <> ItemIndex then
  begin
    if ItemIndex > -1 then
      FComSelect.Change(Items[ItemIndex]);
    FOldIndex := ItemIndex;
  end;
  inherited Click;
end;

// set ComPort property
procedure TComRadioGroup.SetComPort(const Value: TCustomComPort);
begin
  if FComSelect.ComPort <> Value then
  begin
    FComSelect.ComPort := Value;
    if FComSelect.ComPort <> nil then
    begin
      FComSelect.ComPort.FreeNotification(Self);
      // transfer settings from ComPort to this control
      UpdateSettings;
    end;
  end;
end;

function TComRadioGroup.GetComPort: TCustomComPort;
begin
  Result := FComSelect.ComPort;
end;

function TComRadioGroup.GetAutoApply: Boolean;
begin
  Result := FComSelect.AutoApply;
end;

procedure TComRadioGroup.SetAutoApply(const Value: Boolean);
begin
  FComSelect.AutoApply := Value;
end;

// change property for selecting
procedure TComRadioGroup.SetComProperty(const Value: TComProperty);
var
  Index: Integer;
begin
  FComSelect.ComProperty := Value;
  if Items.Count > 0 then
    if FComSelect.ComPort <> nil then
    begin
      // transfer settings from ComPort to this control
      FComSelect.UpdateSettings(Index);
      ItemIndex := Index;
    end
    else
      ItemIndex := 0;
end;

function TComRadioGroup.GetComProperty: TComProperty;
begin
  Result := FComSelect.ComProperty;
end;

(*****************************************
 * TComLed control                       *
 *****************************************)

// create control
constructor TComLed.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csSetCaption];
  Height := 25;
  Width := 25;
  FComLink := TComLink.Create;
  FComLink.OnConn := SignalChange;
  FGlyphs[lsOn] := TLedBitmap.Create;
  FGlyphs[lsOn].Transparent := True;
  FGlyphs[lsOn].TransparentMode := tmAuto;
  FGlyphs[lsOff] := TLedBitmap.Create;
  FGlyphs[lsOff].Transparent := True;
  FGlyphs[lsOff].TransparentMode := tmAuto;
  FRingTimer := TTimer.Create(nil);
  FRingTimer.Enabled := False;
  FRingTimer.OnTimer := DoTimer;
end;

// destroy control
destructor TComLed.Destroy;
begin
  FRingTimer.Free;
  FGlyphs[lsOn].Free;
  FGlyphs[lsOff].Free;
  ComPort := nil;
  FComLink.Free;
  inherited Destroy;
end;

// paint control
procedure TComLed.Paint;
var
  Pt: TPoint;
begin
  // get bitmap handle
  BitmapNeeded;
  // calculate position
  Pt := CalcBitmapPos;
  // draw bitmap
  Canvas.Draw(Pt.x, Pt.y, BitmapToDraw);
end;

// remove ComPort if being destroyed
procedure TComLed.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FComPort) then
    ComPort := nil;
end;

// ring timer
procedure TComLed.DoTimer(Sender: TObject);
begin
  FRingTimer.Enabled := False;
  SetStateInternal(lsOff);
end;

procedure TComLed.CMEnabledChanged(var Message: TMessage);
begin
  Invalidate;
end;

// trigger OnChangeEvent
procedure TComLed.DoChange(AState: TLedState);
begin
  if Assigned(FOnChange) then
    FOnChange(Self, AState);
end;

// if bitmap is empty, load it
procedure TComLed.BitmapNeeded;
begin
  if (FGlyphs[lsOn].Empty) or (FGlyphs[lsOff].Empty) then
    SelectLedBitmap(FKind);
end;

procedure TComLed.SelectLedBitmap(const LedKind: TLedKind);
const
  OnBitmaps: array[TLedKind] of string = ('LEDREDON', 'LEDGREENON', 'LEDBLUEON',
    'LEDYELLOWON', 'LEDPURPLEON', 'LEDBULBON', '');
  OffBitmaps: array[TLedKind] of string = ('LEDREDOFF', 'LEDGREENOFF',
    'LEDBLUEOFF', 'LEDYELLOWOFF', 'LEDPURPLEOFF', 'LEDBULBOFF' ,'');
begin
  if LedKind <> lkCustom then
  begin
    FGlyphs[lsOn].LoadFromResourceName(HInstance, OnBitmaps[LedKind]);
    FGlyphs[lsOff].LoadFromResourceName(HInstance, OffBitmaps[LedKind]);
  end;
end;

// calculate bitmap position
function TComLed.CalcBitmapPos: TPoint;
var
  Rect: TRect;
begin
  Rect := GetClientRect;
  Result.x := Rect.Left + Max(0, (Rect.Right - Rect.Left - FGlyphs[FState].Width) div 2);
  Result.y := Rect.Top + Max(0, (Rect.Bottom - Rect.Top - FGlyphs[FState].Height) div 2);
end;

// change led state on signal change
procedure TComLed.SignalChange(Sender: TObject; OnOff: Boolean);
begin
  if OnOff then
    SetStateInternal(lsOn)
  else
    SetStateInternal(lsOff);
  Application.ProcessMessages;
end;

// change led state on ring detection
procedure TComLed.RingDetect(Sender: TObject);
begin
  FRingTimer.Enabled := True;
  SetStateInternal(lsOn);
end;

// detect the state of led
function TComLed.IsStateOn: Boolean;
begin
  case FLedSignal of
    lsCTS: Result := (csCTS in FComPort.Signals);
    lsDSR: Result := (csDSR in FComPort.Signals);
    lsRLSD: Result := (csRLSD in FComPort.Signals);
    lsRing: Result := False;
    lsTx: Result := False;
    lsRx: Result := False;
    lsConn: Result := (FComPort <> nil) and (FComPort.Connected);
  else
    Result := False;
  end;
end;

// set led state
procedure TComLed.SetStateInternal(const Value: TLedState);
begin
  FState := Value;
  if not (csLoading in ComponentState) then
    DoChange(FState);
  Invalidate;
end;

// set led kind
procedure TComLed.SetKind(const Value: TLedKind);
begin
  if FKind <> Value then
  begin
    FKind := Value;
    SelectLedBitmap(FKind);
    Invalidate;
  end;
end;

// set ComPort property
procedure TComLed.SetComPort(const Value: TComPort);
begin
  if Value <> FComPort then
  begin
    if FComPort <> nil then
      FComPort.UnRegisterLink(FComLink);
    FComPort := Value;
    if FComPort <> nil then
    begin
      FComPort.FreeNotification(Self);
      FComPort.RegisterLink(FComLink);
      if (FComPort.Connected) and (not (csDesigning in ComponentState))
          and (not (csLoading in ComponentState)) then
        if IsStateOn then
          SetStateInternal(lsOn)
        else
          SetStateInternal(lsOff);
    end
    else
      SetStateInternal(lsOff);
  end;
end;

// set led state
procedure TComLed.SetState(const Value: TLedState);
begin
  if FComPort <> nil then
    raise EComPort.CreateNoWinCode(CError_LedStateFailed);
  SetStateInternal(Value);
end;

// select which signal to watch
procedure TComLed.SetLedSignal(const Value: TComLedSignal);
begin
  if FLedSignal <> Value then
  begin
    FLedSignal := Value;
    FComLink.OnCTSChange := nil;
    FComLink.OnDSRChange := nil;
    FComLink.OnRLSDChange := nil;
    FComLink.OnRing := nil;
    FComLink.OnTx := nil;
    FComLink.OnRx := nil;
    FComLink.OnConn := nil;
    case FLedSignal of
      lsCTS: FComLink.OnCTSChange := SignalChange;
      lsDSR: FComLink.OnDSRChange := SignalChange;
      lsRLSD: FComLink.OnRLSDChange := SignalChange;
      lsRing: FComLink.OnRing := RingDetect;
      lsTx: FComLink.OnTx := SignalChange;
      lsRx: FComLink.OnRx := SignalChange;
      lsConn: FComLink.OnConn := SignalChange;
    end;
  end;
end;

function TComLed.GetGlyph(const Index: Integer): TLedBitmap;
begin
  case Index of
    0: Result := FGlyphs[lsOn];
    1: Result := FGlyphs[lsOff];
  else
    Result := nil;
  end;
end;

// set custom bitmap
procedure TComLed.SetGlyph(const Index: Integer; const Value: TLedBitmap);
begin
  if FKind = lkCustom then
  begin
    Value.TransparentMode := tmAuto;
    Value.Transparent := True;
    case Index of
      0: FGlyphs[lsOn].Assign(Value);
      1: FGlyphs[lsOff].Assign(Value);
    end;
    Invalidate;
  end;
end;

function TComLed.StoredGlyph(const Index: Integer): Boolean;
begin
  Result := FKind = lkCustom;
end;

// get bitmap for drawing
function TComLed.BitmapToDraw: TLedBitmap;
var
  ToDraw: TLedState;
begin
  if not Enabled then
    ToDraw := lsOff
  else
    ToDraw := FState;
  Result := FGlyphs[ToDraw];
end;

function TComLed.GetRingDuration: Integer;
begin
  Result := FRingTimer.Interval;
end;

procedure TComLed.SetRingDuration(const Value: Integer);
begin
  FRingTimer.Interval := Value;
end;

(*****************************************
 * TComTermBuffer class                  *
 *****************************************)

// create class
constructor TComTermBuffer.Create(AOwner: TCustomComTerminal);
begin
  inherited Create;
  FOwner := AOwner;
end;

// destroy class
destructor TComTermBuffer.Destroy;
begin
  if FBuffer <> nil then
  begin
    FreeMem(FBuffer);
    FreeMem(FTabs);
  end;
  inherited Destroy;
end;

// put char in buffer
procedure TComTermBuffer.SetChar(Column, Row: Integer;
  TermChar: TComTermChar);
var
  Address: Integer;
begin
  Address := (Row - 1) * FOwner.Columns + Column - 1;
  Move(
    TermChar,
    Pointer(Integer(FBuffer) + (SizeOf(TComTermChar) * Address))^,
    SizeOf(TComTermChar));
end;

// get char from buffer
function TComTermBuffer.GetChar(Column, Row: Integer): TComTermChar;
var
  Address: Integer;
begin
  Address := (Row - 1) * FOwner.Columns + Column - 1;
  Move(
    Pointer(Integer(FBuffer) + (SizeOf(TComTermChar) * Address))^,
    Result,
    SizeOf(TComTermChar));
end;

// scroll down up line
procedure TComTermBuffer.ScrollDown;
var
  BytesToMove: Integer;
  SourceAddr: Pointer;
  ScrollRect: TRect;
begin
  BytesToMove := (FOwner.Rows - 1) * FOwner.Columns * SizeOf(TComTermChar);
  SourceAddr := Pointer(Integer(FBuffer) + FOwner.Columns * SizeOf(TComTermChar));
  // scroll in buffer
  Move(SourceAddr^, FBuffer^, BytesToMove);
  SourceAddr := Pointer(Integer(FBuffer) +
    (FOwner.Rows - 1) * FOwner.Columns * SizeOf(TComTermChar));
  FillChar(SourceAddr^, FOwner.Columns * SizeOf(TComTermChar), 0);
  // calculate scrolling rectangle
  with ScrollRect do
  begin
    Left := 0;
    Right := Min(FOwner.ClientWidth, FOwner.Columns * FOwner.FFontWidth);
    Top := 0;
    Bottom := Min(FOwner.ClientHeight, FOwner.Rows * FOwner.FFontHeight);
  end;
  // scroll on screen
{$IFDEF DELPHI_4_OR_HIGHER}
  if FOwner.DoubleBuffered then
    FOwner.Invalidate
  else
{$ENDIF}
    ScrollWindowEx(FOwner.Handle, 0, -FOwner.FFontHeight,
      @ScrollRect, nil, 0, nil, SW_INVALIDATE or SW_ERASE);
end;

// scroll up one line
procedure TComTermBuffer.ScrollUp;
var
  BytesToMove: Integer;
  DestAddr: Pointer;
  ScrollRect: TRect;
begin
  BytesToMove := (FOwner.Rows - 1) * FOwner.Columns * SizeOf(TComTermChar);
  DestAddr := Pointer(Integer(FBuffer) + FOwner.Columns * SizeOf(TComTermChar));
  // scroll in buffer
  Move(FBuffer^, DestAddr^, BytesToMove);
  FillChar(FBuffer^, FOwner.Columns * SizeOf(TComTermChar), 0);
  // calculate scrolling rectangle
  with ScrollRect do
  begin
    Left := 0;
    Right := Min(FOwner.ClientWidth, FOwner.Columns * FOwner.FFontWidth);
    Top := 0;
    Bottom := Min(FOwner.ClientHeight, FOwner.Rows * FOwner.FFontHeight);
  end;
  // scroll on screen
{$IFDEF DELPHI_4_OR_HIGHER}
  if FOwner.DoubleBuffered then
    FOwner.Invalidate
  else
{$ENDIF}
    ScrollWindowEx(FOwner.Handle, 0, FOwner.FFontHeight,
      @ScrollRect, nil, 0, nil, SW_INVALIDATE or SW_ERASE);
end;

// erase line
procedure TComTermBuffer.EraseLine(Column, Row: Integer);
var
  BytesToDelete: Integer;
  SourceAddr: Pointer;
begin
  // in memory
  BytesToDelete := (FOwner.Columns - Column + 1) * SizeOf(TComTermChar);
  SourceAddr := Pointer(Integer(FBuffer) +
    ((Row - 1) * FOwner.Columns + Column - 1) * SizeOf(TComTermChar));
  FillChar(SourceAddr^, BytesToDelete, 0);
  // on screen
{$IFDEF DELPHI_4_OR_HIGHER}
  if FOwner.DoubleBuffered then
    FOwner.Invalidate
  else
{$ENDIF}
    FOwner.InvalidatePortion(Rect(Column, Row, FOwner.Columns, Row));
end;

// erase screen
procedure TComTermBuffer.EraseScreen(Column, Row: Integer);
var
  BytesToDelete: Integer;
  SourceAddr: Pointer;
begin
  // in memory
  BytesToDelete := (FOwner.Columns - Column + 1 +
    (FOwner.Rows - Row) * FOwner.Columns) * SizeOf(TComTermChar);
  SourceAddr := Pointer(Integer(FBuffer) +
    ((Row - 1) * FOwner.Columns + Column - 1) * SizeOf(TComTermChar));
  FillChar(SourceAddr^, BytesToDelete, 0);
  // on screen
{$IFDEF DELPHI_4_OR_HIGHER}
  if FOwner.DoubleBuffered then
    FOwner.Invalidate
  else
{$ENDIF}
    FOwner.InvalidatePortion(Rect(Column, Row, FOwner.Columns, FOwner.Rows))
end;

// init buffer
procedure TComTermBuffer.Init;
var
  I: Integer;
begin
  if FBuffer <> nil then
  begin
    FreeMem(FBuffer);
    FreeMem(FTabs);
  end;
  GetMem(FBuffer, FOwner.Columns * FOwner.Rows * SizeOf(TComTermChar));
  FillChar(FBuffer^, FOwner.Columns * FOwner.Rows * SizeOf(TComTermChar), 0);
  GetMem(FTabs, FOwner.Columns * SizeOf(Boolean));
  FillChar(FTabs^, FOwner.Columns * SizeOf(Boolean), 0);
  I := 1;
  while (I <= FOwner.Columns) do
  begin
    SetTab(I, True);
    Inc(I, 8);
  end;
end;

// get tab at Column
function TComTermBuffer.GetTab(Column: Integer): Boolean;
begin
  Result := Boolean(Pointer(Integer(FTabs) + (Column - 1) * SizeOf(Boolean))^);
end;

// set tab at column
procedure TComTermBuffer.SetTab(Column: Integer; Put: Boolean);
begin
  Boolean(Pointer(Integer(FTabs) + (Column - 1) * SizeOf(Boolean))^) := Put;
end;

// find nexts tab position
function TComTermBuffer.NextTab(Column: Integer): Integer;
var
  I: Integer;
begin
  I := Column;
  while (I <= FOwner.Columns) do
    if GetTab(I) then
      Break
    else
      Inc(I);
  if I > FOwner.Columns then
    Result := 0
  else
    Result := I;
end;

// clear all tabs
procedure TComTermBuffer.ClearAllTabs;
begin
  FillChar(FTabs^, FOwner.Columns * SizeOf(Boolean), 0);
end;

function TComTermBuffer.GetLineLength(Line: Integer): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 1 to FOwner.Columns do
    if GetChar(I, Line).Ch <> #0 then
      Result := I;
end;

function TComTermBuffer.GetLastLine: Integer;
var
  J: Integer;
begin
  Result := 0;
  for J := 1 to FOwner.Rows do
    if GetLineLength(J) > 0 then
      Result := J;
end;

// get last character in buffer
(*****************************************
 * TComCustomTerminal control            *
 *****************************************)

// create control
constructor TCustomComTerminal.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  BorderStyle := bsSingle;
  Color := clBlack;
  TabStop := True;
  Width := 400;
  Height := 250;
  Font := ComTerminalFont;
  FAltColor := $00A6A6A6;
  FComLink := TComLink.Create;
  FComLink.OnRxBuf := RxBuf;
  FEmulation := teVT100orANSI;
  FColumns := 80;
  FRows := 24;
  FCaretPos := Point(1, 1);
  FTopLeft := Point(1, 1);
  FScrollBars := ssBoth;
  FBuffer := TComTermBuffer.Create(Self);
  FTermAttr.FrontColor := Font.Color;
  FTermAttr.BackColor := Color;
end;

// destroy control
destructor TCustomComTerminal.Destroy;
begin
  ComPort := nil;
  FBuffer.Free;
  FEscapeCodes.Free;
  FComLink.Free;
  inherited Destroy;
end;

// clear terminal screen
procedure TCustomComTerminal.ClearScreen;
begin
  FBuffer.Init;
  MoveCaret(1, 1);
  Invalidate;
end;

// move caret
procedure TCustomComTerminal.MoveCaret(AColumn, ARow: Integer);
begin
  if AColumn > FColumns then
    FCaretPos.X := FColumns
  else
    if AColumn < 1 then
      FCaretPos.X := 1
    else
      FCaretPos.X := AColumn;

  if ARow > FRows then
    FCaretPos.Y := FRows
  else
    if ARow < 1 then
      FCaretPos.Y := 1
    else
      FCaretPos.Y := ARow;

  if FCaretCreated then
    SetCaretPos((FCaretPos.X - FTopLeft.X) * FFontWidth,
      (FCaretPos.Y - FTopLeft.Y) * FFontHeight + FFontHeight - FCaretHeight);
end;

// write data to screen
procedure TCustomComTerminal.Write(const Buffer:string; Size: Integer);
var
  I: Integer;
  Res: TEscapeResult;
  Ch: Char;
begin
  HideCaret;
  try
    // show it on screen
    for I := 1 to Size do
    begin
      Ch := Buffer[I];
      if FEscapeCodes <> nil then
      begin
        Res := FEscapeCodes.ProcessChar(Ch);
        if Res = erChar then
          PutChar(FEscapeCodes.Character);
        if Res = erCode then
        begin
          if not PutEscapeCode(FEscapeCodes.Code, FEscapeCodes.Params) then
             DoUnhandledCode(FEscapeCodes.Code, FEscapeCodes.Data);
          FEscapeCodes.Params.Clear;
        end;
      end
      else
        PutChar(Ch);
    end;
  finally
    ShowCaret;
  end;
end;

// write string on screen, but not to port
procedure TCustomComTerminal.WriteStr(const Str: string);
begin
  Write(Str, Length(Str));
end;

// write escape code on screen
procedure TCustomComTerminal.WriteEscCode(ACode: TEscapeCode;
  AParams: TStrings);
begin
  if FEscapeCodes <> nil then
    PutEscapeCode(ACode, AParams);
end;

// load screen buffer from file
procedure TCustomComTerminal.LoadFromStream(Stream: TStream);
var
  I: Integer;
  Ch: Char;
begin
  HideCaret;
  for I := 0 to Stream.Size - 1 do
  begin
    Stream.Read(Ch, 1);
    PutChar(Ch);
  end;
  ShowCaret;
end;

// save screen buffer to file
procedure TCustomComTerminal.SaveToStream(Stream: TStream);
var
  I, J, LastChar, LastLine: Integer;
  Ch: Char;
  EndLine: string;
begin
  EndLine := #13#10;
  LastLine := FBuffer.GetLastLine;
  for J := 1 to LastLine do
  begin
    LastChar := FBuffer.GetLineLength(J);
    if LastChar > 0 then
    begin
      for I := 1 to LastChar do
      begin
        Ch := FBuffer.GetChar(I, J).Ch;
        // replace null characters with blanks
        if Ch = #0 then
          Ch := #32;
        Stream.Write(Ch, 1);
      end;
    end;
    // new line
    if J <> LastLine then
      Stream.Write(EndLine[1], Length(EndLine));
  end;
end;

// select terminal font
procedure TCustomComTerminal.SelectFont;
begin
  with TFontDialog.Create(Application) do
  begin
    Options := Options + [fdFixedPitchOnly];
    Font := Self.Font;
    if Execute then
      Self.Font := Font;
    Free;
  end;
end;

// show terminal setup dialog
procedure TCustomComTerminal.ShowSetupDialog;
begin
  EditComTerminal(Self);
end;

procedure TCustomComTerminal.CMCtl3DChanged(var Message: TMessage);
begin
  if NewStyleControls and (FBorderStyle = bsSingle) then
    RecreateWnd;
  inherited;
end;

// process font change
procedure TCustomComTerminal.CMFontChanged(var Message: TMessage);
begin
  inherited;
  FTermAttr.FrontColor := Font.Color;
  if not CalculateMetrics then
    Font.Name := ComTerminalFont.Name;
  if fsUnderline in Font.Style then
    Font.Style := Font.Style - [fsUnderline];
{$IFDEF DELPHI_4_OR_HIGHER}
  AdjustSize;
{$ENDIF}
  UpdateScrollRange;
end;

procedure TCustomComTerminal.CMColorChanged(var Message: TMessage);
begin
  inherited;
  FTermAttr.BackColor := Color;
end;

procedure TCustomComTerminal.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  // request arrow keys and WM_CHAR message to be handled by the control
  Message.Result := DLGC_WANTARROWS or DLGC_WANTCHARS;
  // tab key
  if FWantTab then
    Message.Result := Message.Result or DLGC_WANTTAB;
end;

// lost focus
procedure TCustomComTerminal.WMKillFocus(var Message: TWMSetFocus);
begin
  // destroy caret because it could be requested by some other control
  DestroyCaret;
  FCaretCreated := False;
  inherited;
end;

// gained focus
procedure TCustomComTerminal.WMSetFocus(var Message: TWMSetFocus);
begin
  inherited;
  // control activated, create caret
  InitCaret;
end;

// left button pressed
procedure TCustomComTerminal.WMLButtonDown(var Message: TWMLButtonDown);
begin
  // set focus when left button down
  if CanFocus and TabStop then
    SetFocus;
  inherited;
end;

// size changed
procedure TCustomComTerminal.WMSize(var Msg: TWMSize);
begin
  inherited;
  UpdateScrollRange;
end;

// vertical scroll
procedure TCustomComTerminal.WMHScroll(var Message: TWMHScroll);
begin
  ModifyScrollBar(SB_HORZ, Message.ScrollCode, Message.Pos);
end;

// horizontal scroll
procedure TCustomComTerminal.WMVScroll(var Message: TWMVScroll);
begin
  ModifyScrollBar(SB_VERT, Message.ScrollCode, Message.Pos);
end;

{$IFDEF DELPHI_4_OR_HIGHER}
// set size to fit whole terminal screen
function TCustomComTerminal.CanAutoSize(var NewWidth,
  NewHeight: Integer): Boolean;
var
  Border: Integer;
begin
  Result := True;
  if Align in [alNone, alLeft, alRight] then
  begin
    NewWidth := FFontWidth * FColumns;
    if FBorderStyle = bsSingle then
    begin
      if Ctl3D then
        Border := SM_CXEDGE
      else
        Border := SM_CXBORDER;
      NewWidth := NewWidth + 2 * GetSystemMetrics(BORDER);
    end;
  end;
  if Align in [alNone, alTop, alBottom] then
  begin
    NewHeight := FFontHeight * FRows;
    if FBorderStyle = bsSingle then
    begin
      if Ctl3D then
        Border := SM_CYEDGE
      else
        Border := SM_CYBORDER;
      NewHeight := NewHeight + 2 * GetSystemMetrics(Border);
    end;
  end;
end;
{$ENDIF}

// set control parameters
procedure TCustomComTerminal.CreateParams(var Params: TCreateParams);
const
  BorderStyles: array[TBorderStyle] of DWORD = (0, WS_BORDER);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or BorderStyles[FBorderStyle];
    if NewStyleControls and Ctl3D and (FBorderStyle = bsSingle) then
    begin
      Style := Style and not WS_BORDER;
      ExStyle := ExStyle or WS_EX_CLIENTEDGE;
    end;
    if FScrollBars in [ssVertical, ssBoth] then
      Style := Style or WS_VSCROLL;
    if FScrollBars in [ssHorizontal, ssBoth] then
      Style := Style or WS_HSCROLL;
  end;
end;

// key down
procedure TCustomComTerminal.KeyDown(var Key: Word; Shift: TShiftState);
var
  Code: TEscapeCode;
begin
  inherited KeyDown(Key, Shift);
  case Key of
    VK_UP: Code := ecCursorUp;
    VK_DOWN: Code := ecCursorDown;
    VK_LEFT: Code := ecCursorLeft;
    VK_RIGHT: Code := ecCursorRight;
    VK_HOME: Code := ecCursorHome;
  else
    Code := ecUnknown;
  end;
  if FTermMode.Keys = akTerminal then
  begin
    if Code <> ecUnknown then
      if FArrowKeys = akTerminal then
        SendCode(Code, nil)
      else
        PutEscapeCode(Code, nil);
  end
  else
    case Code of
      ecCursorUp: SendCode(ecAppCursorUp, nil);
      ecCursorDown: SendCode(ecAppCursorDown, nil);
      ecCursorLeft: SendCode(ecAppCursorLeft, nil);
      ecCursorRight: SendCode(ecAppCursorRight, nil);
    end;
end;

// key pressed
procedure TCustomComTerminal.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  SendChar(Key);
end;

procedure TCustomComTerminal.Loaded;
begin
  inherited Loaded;
  CreateEscapeCodes;
  if not (csDesigning in ComponentState) then
    FBuffer.Init;
end;

procedure TCustomComTerminal.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FComPort) and (Operation = opRemove) then
    ComPort := nil;
end;

// paint characters
procedure TCustomComTerminal.PaintTerminal(Rect: TRect);
var
  I, J, X, Y: Integer;
  Ch: TComTermChar;
begin
  if (Rect.Bottom + FTopLeft.Y - 1) > FRows then
    Dec(Rect.Bottom);
  if (Rect.Right + FTopLeft.X - 1) > FColumns then
    Dec(Rect.Right);
  for J := Rect.Top to Rect.Bottom do
  begin
    Y := J + FTopLeft.Y - 1;
    for I := Rect.Left to Rect.Right do
    begin
      X := I + FTopLeft.X - 1;
      Ch := FBuffer.GetChar(X, Y);
      if Ch.Ch <> Chr(0) then
        DrawChar(I, J, Ch);
    end;
  end;
end;

procedure TCustomComTerminal.PaintDesign;
begin
  Canvas.TextOut(0, 0, 'ComPort Library');
  Canvas.Font.Color := FAltColor;
  Canvas.TextOut(0, FFontHeight, 'ComPort Library');
  Canvas.Font.Color := Font.Color;
  PatBlt(Canvas.Handle, 0, 0, FFontWidth, FFontHeight * 2, DSTINVERT);
end;

procedure TCustomComTerminal.Paint;
var
  ARect: TRect;
begin
  Canvas.Font := Font;
  Canvas.Brush.Color := Color;
  if csDesigning in ComponentState then
    PaintDesign
  else
  begin
    MoveCaret(FCaretPos.X, FCaretPos.Y);
    // don't paint whole screen, but only the invalidated portion
    ARect.Left := Canvas.ClipRect.Left div FFontWidth + 1;
    ARect.Right := Min(Canvas.ClipRect.Right div FFontWidth + 1, FColumns);
    ARect.Top := Canvas.ClipRect.Top div FFontHeight + 1;
    ARect.Bottom := Min(Canvas.ClipRect.Bottom div FFontHeight + 1, FRows);
    PaintTerminal(ARect);
  end;
end;

// creates caret
procedure TCustomComTerminal.CreateTerminalCaret;
begin
  FCaretHeight := 0;
  if FCaret = tcBlock then
    FCaretHeight := FFontHeight
  else
    if FCaret = tcUnderline then
      FCaretHeight := FFontHeight div 8;
  if FCaretHeight > 0 then
  begin
    CreateCaret(Handle, 0, FFontWidth, FCaretHeight);
    FCaretCreated := True;
  end;
end;

// string received from com port
procedure TCustomComTerminal.StringReceived(Str: string);
begin
  DoStrRecieved(Str);
  WriteStr(Str);
end;

// draw one character on screen, but do not put it in buffer
procedure TCustomComTerminal.DrawChar(AColumn, ARow: Integer;
  Ch: TComTermChar);
var
  OldBackColor, OldFrontColor: Integer;
begin
  OldBackColor := Canvas.Brush.Color;
  OldFrontColor := Canvas.Font.Color;
  Canvas.Brush.Color := Ch.BackColor;
  Canvas.Font.Color := Ch.FrontColor;
  if Ch.Underline then
    Canvas.Font.Style := Canvas.Font.Style + [fsUnderline]
  else
    Canvas.Font.Style := Canvas.Font.Style - [fsUnderline];
  Canvas.TextOut((AColumn - 1) * FFontWidth, (ARow - 1) * FFontHeight, Ch.Ch);
  Canvas.Brush.Color := OldBackColor;
  Canvas.Font.Color := OldFrontColor;
end;

// move caret after new char is put on screen
procedure TCustomComTerminal.AdvanceCaret(Kind: TAdvanceCaret);
var
  I: Integer;
begin
  case Kind of
    acChar:
      begin
        if FCaretPos.X = FColumns then
        begin
          if FWrapLines then
            if FCaretPos.Y = FRows then
            begin
              FBuffer.ScrollDown;
              MoveCaret(1, FCaretPos.Y);
            end
            else
              MoveCaret(1, FCaretPos.Y + 1)
        end
        else
          MoveCaret(FCaretPos.X + 1, FCaretPos.Y);
      end;
    acReturn: MoveCaret(1, FCaretPos.Y);
    acLineFeed:
      begin
        if FCaretPos.Y = FRows then
          FBuffer.ScrollDown
        else
          MoveCaret(FCaretPos.X, FCaretPos.Y + 1);
      end;
    acReverseLineFeed:
      begin
        if FCaretPos.Y = 1 then
          FBuffer.ScrollUp
        else
          MoveCaret(FCaretPos.X, FCaretPos.Y - 1);
      end;
    acBackSpace: MoveCaret(FCaretPos.X - 1, FCaretPos.Y);
    acTab:
      begin
        I := FBuffer.NextTab(FCaretPos.X + 1);
        if I > 0 then
          MoveCaret(I, FCaretPos.Y);
      end;
    // NEW: pagecommando: scherm schoonmaken
    acPage:
      ClearScreen;
    //ENDNEW
  end;
end;

// set character attributes
procedure TCustomComTerminal.SetAttributes(AParams: TStrings);
var
  I, Value: Integer;

  procedure AllOff;
  begin
    FTermAttr.FrontColor := Font.Color;
    FTermAttr.BackColor := Color;
    FTermAttr.Invert := False;
    FTermAttr.AltIntensity := False;
    FTermAttr.Underline := False;
  end;

begin
  if AParams.Count = 0 then
    AllOff;
  for I := 1 to AParams.Count do
  begin
    Value := FEscapeCodes.GetParam(I, AParams);
    case Value of
      0:  AllOff;
      1:  FTermAttr.AltIntensity := True;
      4:  FTermAttr.Underline := True;
      7:  FTermAttr.Invert := True;
      21: FTermAttr.AltIntensity := False;
      24: FTermAttr.Underline := False;
      27: FTermAttr.Invert := False;
      // NEW forground colors
      30: FTermAttr.FrontColor := clBlack;
      31: FTermAttr.FrontColor := clRed;
      32: FTermAttr.FrontColor := clGreen;
      33: FTermAttr.FrontColor := clYellow;
      34: FTermAttr.FrontColor := clBlue;
      35: FTermAttr.FrontColor := clPurple;         // Official Magenta
      36: FTermAttr.FrontColor := $0080FF;          // Orange, official Cyan
      37: FTermAttr.FrontColor := clWhite;
      38: FTermAttr.FrontColor := clMaroon;         // Not official
      39: FTermAttr.FrontColor := clGray;           // Not official
      // NEW background colors
      40: FTermAttr.BackColor := clBlack;
      41: FTermAttr.BackColor := clRed;
      42: FTermAttr.BackColor := clGreen;
      43: FTermAttr.BackColor := clYellow;
      44: FTermAttr.BackColor := clBlue;
      45: FTermAttr.BackColor := clPurple;         // Magenta
      46: FTermAttr.BackColor := $0080FF;          // now Orange, Cyan
      47: FTermAttr.BackColor := clWhite;
      48: FTermAttr.BackColor := clMaroon;         // Not official
      49: FTermAttr.BackColor := clGray;           // Not official
      // NEW end
    end;
  end;
end;

procedure TCustomComTerminal.SetMode(AParams: TStrings; OnOff: Boolean);
var
  Str: string;
begin
  if AParams.Count = 0 then
    Exit;
  Str := AParams[0];
  if Str = '?1' then
    if OnOff then
      FTermMode.Keys := akWindows
    else
      FTermMode.Keys := akTerminal;
  if Str = '7' then
    FWrapLines := OnOff;
  if Str = '?3' then
    if OnOff then
      Columns := 132
    else
      Columns := 80;
end;

// invalidate portion of screen
procedure TCustomComTerminal.InvalidatePortion(ARect: TRect);
var
  Rect: TRect;
begin
  Rect.Left := Max((ARect.Left - FTopLeft.X) * FFontWidth, 0);
  Rect.Right := Max((ARect.Right - FTopLeft.X + 1) * FFontWidth, 0);
  Rect.Top := Max((ARect.Top - FTopLeft.Y) * FFontHeight, 0);
  Rect.Bottom := Max((ARect.Bottom - FTopLeft.Y + 1) * FFontHeight, 0);
  InvalidateRect(Handle, @Rect, True);
end;

// modify scroll bar
procedure TCustomComTerminal.ModifyScrollBar(ScrollBar, ScrollCode,
  Pos: Integer);
var
  CellSize, OldPos, APos, Dx, Dy: Integer;
begin
  if (ScrollCode = SB_ENDSCROLL) or
    ((ScrollCode = SB_THUMBTRACK) and not FSmoothScroll)
  then
    Exit;
  if ScrollBar = SB_HORZ then
    CellSize := FFontWidth
  else
    CellSize := FFontHeight;
  APos := GetScrollPos(Handle, ScrollBar);
  OldPos := APos;
  case ScrollCode of
    SB_LINEUP: Dec(APos);
    SB_LINEDOWN: Inc(APos);
    SB_PAGEUP: Dec(APos, ClientHeight div CellSize);
    SB_PAGEDOWN: Inc(APos, ClientHeight div CellSize);
    SB_THUMBPOSITION,
    SB_THUMBTRACK: APos := Pos;
  end;
  SetScrollPos(Handle, ScrollBar, APos, True);
  APos := GetScrollPos(Handle, ScrollBar);
  if ScrollBar = SB_HORZ then
  begin
    FTopLeft.X := APos + 1;
    Dx := (OldPos - APos) * FFontWidth;
    Dy := 0;
  end else
  begin
    FTopLeft.Y := APos + 1;
    Dx := 0;
    Dy := (OldPos - APos) * FFontHeight;
  end;
{$IFDEF DELPHI_4_OR_HIGHER}
  if DoubleBuffered then
    Invalidate
  else
{$ENDIF}
    ScrollWindowEx(Handle, Dx, Dy, nil, nil, 0, nil, SW_ERASE or SW_INVALIDATE);
end;

// calculate scroll position
procedure TCustomComTerminal.UpdateScrollPos;
begin
  if FScrollBars in [ssBoth, ssHorizontal] then
  begin
    FTopLeft.X := GetScrollPos(Handle, SB_HORZ) + 1;
    SetScrollPos(Handle, SB_HORZ, FTopLeft.X - 1, True);
  end;
  if FScrollBars in [ssBoth, ssVertical] then
  begin
    FTopLeft.Y := GetScrollPos(Handle, SB_VERT) + 1;
    SetScrollPos(Handle, SB_VERT, FTopLeft.Y - 1, True);
  end;
end;

// calculate scroll range
procedure TCustomComTerminal.UpdateScrollRange;
var
  OldScrollBars: TScrollStyle;
  AHeight, AWidth: Integer;

  // is scroll bar visible?
  function ScrollBarVisible(Code: Word): Boolean;
  var
    Min, Max: Integer;
  begin
    Result := False;
    if (ScrollBars = ssBoth) or
      ((Code = SB_HORZ) and (ScrollBars = ssHorizontal)) or
      ((Code = SB_VERT) and (ScrollBars = ssVertical)) then
    begin
      GetScrollRange(Handle, Code, Min, Max);
      Result := Min <> Max;
    end;
  end;

  procedure SetRange(Code, Max: Integer);
  begin
    SetScrollRange(Handle, Code, 0, Max - 1, False);
  end;

  // set horizontal range
  procedure SetHorzRange;
  var
    Max: Integer;
    AColumns: Integer;
  begin
    if OldScrollBars in [ssBoth, ssHorizontal] then
    begin
      AColumns := AWidth div FFontWidth;
      if AColumns >= FColumns then
        SetRange(SB_HORZ, 1) // screen is wide enough, hide scroll bar
      else
      begin
        Max := FColumns - (AColumns - 1);
        SetRange(SB_HORZ, Max);
      end;
    end;
  end;

  // set vertical range
  procedure SetVertRange;
  var
    Max, ARows: Integer;
  begin
    if OldScrollBars in [ssBoth, ssVertical] then
    begin
      ARows := AHeight div FFontHeight;
      if ARows >= FRows then
        SetRange(SB_VERT, 1)  // screen is high enough, hide scroll bar
      else
      begin
        Max := FRows - (ARows - 1);
        SetRange(SB_VERT, Max);
      end;
    end;
  end;

begin
  if (FScrollBars = ssNone) then
    Exit;
  AHeight := ClientHeight;
  AWidth := ClientWidth;
  if ScrollBarVisible(SB_HORZ) then
    Inc(AHeight, GetSystemMetrics(SM_CYHSCROLL));
  if ScrollBarVisible(SB_VERT) then
    Inc(AWidth, GetSystemMetrics(SM_CXVSCROLL));
  // Temporarily mark us as not having scroll bars to avoid recursion
  OldScrollBars := FScrollBars;
  FScrollBars := ssNone;
  try
    SetHorzRange;
    AHeight := ClientHeight;
    SetVertRange;
    if AWidth <> ClientWidth then
    begin
      AWidth := ClientWidth;
      SetHorzRange;
    end;
  finally
    FScrollBars := OldScrollBars;
  end;
  // range changed, update scroll bar position
  UpdateScrollPos;
end;

// hide caret
procedure TCustomComTerminal.HideCaret;
begin
  if FCaretCreated then
    Windows.HideCaret(Handle);
end;

// show caret
procedure TCustomComTerminal.ShowCaret;
begin
  if FCaretCreated then
    Windows.ShowCaret(Handle);
end;

// send character to com port
procedure TCustomComTerminal.SendChar(Ch: Char);
begin
  if (FComPort <> nil) and (FComPort.Connected) then
  begin
    FComPort.WriteStr(Ch);
    if FLocalEcho then
    begin
      // local echo is on, show character on screen
      HideCaret;
      PutChar(Ch);
      ShowCaret;
    end;
    // send line feeds after carriage return
    if (Ch = Chr(13)) and FSendLF then
      SendChar(Chr(10));
  end;
end;

// send escape code
procedure TCustomComTerminal.SendCode(Code: TEscapeCode; AParams: TStrings);
begin
  if (FComPort <> nil) and (FComPort.Connected) and (FEscapeCodes <> nil) then
  begin
    FComPort.WriteStr(FEscapeCodes.EscCodeToStr(Code, AParams));
    if FLocalEcho then
    begin
      // local echo is on, show character on screen
      HideCaret;
      PutEscapeCode(Code, AParams);
      ShowCaret;
    end;
  end;
end;

// send escape code to port
procedure TCustomComTerminal.SendCodeNoEcho(Code: TEscapeCode; AParams: TStrings);
begin
  if (FComPort <> nil) and (FComPort.Connected) and (FEscapeCodes <> nil) then
    FComPort.WriteStr(FEscapeCodes.EscCodeToStr(Code, AParams));
end;

// process escape code on screen
function TCustomComTerminal.PutEscapeCode(ACode: TEscapeCode; AParams: TStrings): Boolean;
begin
  Result := True;
  with FEscapeCodes do
    case ACode of
      ecCursorUp,
      ecAppCursorUp: MoveCaret(FCaretPos.X, FCaretPos.Y - GetParam(1, AParams));
      ecCursorDown: MoveCaret(FCaretPos.X, FCaretPos.Y + GetParam(1, AParams));
      ecCursorRight: MoveCaret(FCaretPos.X + GetParam(1, AParams), FCaretPos.Y);
      ecCursorLeft: MoveCaret(FCaretPos.X - GetParam(1, AParams), FCaretPos.Y);
      ecCursorHome,
      ecCursorMove: MoveCaret(GetParam(2, AParams), GetParam(1, AParams));
      ecReverseLineFeed: AdvanceCaret(acReverseLineFeed);
      ecEraseLineFrom: FBuffer.EraseLine(FCaretPos.X, FCaretPos.Y);
      ecEraseScreenFrom: FBuffer.EraseScreen(FCaretPos.X, FCaretPos.Y);
      ecEraseScreen: begin FBuffer.EraseScreen(1, 1); MoveCaret(1, 1) end;
      ecEraseLine:
      begin
        FBuffer.EraseLine(1, FCaretPos.Y);
        MoveCaret(1, FCaretPos.Y)
      end;
      ecIdentify:
      begin
        AParams.Clear;
        AParams.Add('2');
        SendCodeNoEcho(ecIdentResponse, AParams);
      end;
      ecSetTab: FBuffer.SetTab(FCaretPos.X, True);
      ecClearTab: FBuffer.SetTab(FCaretPos.X, False);
      ecClearAllTabs: FBuffer.ClearAllTabs;
      ecAttributes: SetAttributes(AParams);
      ecSetMode: SetMode(AParams, True);
      ecResetMode: SetMode(AParams, False);
      ecReset:
      begin
        AParams.Clear;
        AParams.Add('0');
        SetAttributes(AParams);
      end;
      ecSaveCaret: SaveCaretPos;
      ecRestoreCaret: RestoreCaretPos;
      ecSaveCaretAndAttr: begin SaveCaretPos; SaveAttr; end;
      ecRestoreCaretAndAttr: begin RestoreCaretPos; RestoreAttr; end;
      ecQueryCursorPos:
      begin
        AParams.Clear;
        AParams.Add(IntToStr(FCaretPos.Y));
        AParams.Add(IntToStr(FCaretPos.X));
        SendCodeNoEcho(ecReportCursorPos, AParams);
      end;
      ecQueryDevice: SendCodeNoEcho(ecReportDeviceOK, nil);
      ecTest: PerformTest('E');
    else
      Result := False;
    end;
end;

// calculate font height and width
function TCustomComTerminal.CalculateMetrics: Boolean;
var
  SaveFont, DC: THandle;
  Metrics: TTextMetric;
begin
  DC := GetDC(0);
  SaveFont := SelectObject(DC, Font.Handle);
  GetTextMetrics(DC, Metrics);
  SelectObject(DC, SaveFont);
  ReleaseDC(0, DC);
  FFontHeight := Metrics.tmHeight;
  FFontWidth := Metrics.tmMaxCharWidth;
  // allow only fixed pitch fonts
  Result := (Metrics.tmPitchAndFamily and TMPF_FIXED_PITCH) = 0;
end;

// visual character is appears on screen
procedure TCustomComTerminal.DoChar(Ch: Char);
begin
  if Assigned(FOnChar) then
    FOnChar(Self, Ch);
end;

// get custom escape codes processor
procedure TCustomComTerminal.DoGetEscapeCodes(
  var EscapeCodes: TEscapeCodes);
begin
  if Assigned(FOnGetEscapeCodes) then
    FOnGetEscapeCodes(Self, EscapeCodes);
end;

// string recieved
procedure TCustomComTerminal.DoStrRecieved(var Str: string);
begin
  if Assigned(FOnStrRecieved) then
    FOnStrRecieved(Self, Str);
end;

// let application handle unhandled escape code
procedure TCustomComTerminal.DoUnhandledCode(Code: TEscapeCode;
  Data: string);
begin
  if Assigned(FOnUnhandledCode) then
    FOnUnhandledCode(Self, Code, Data);
end;

// create escape codes processor
procedure TCustomComTerminal.CreateEscapeCodes;
begin
  if csDesigning in ComponentState then
    Exit;
  case FEmulation of
    teVT52: FEscapeCodes := TEscapeCodesVT52.Create;
    teVT100orANSI: FEscapeCodes := TEscapeCodesVT100.Create;
  else
    begin
      FEscapeCodes := nil;
      DoGetEscapeCodes(FEscapeCodes);
    end;
  end;
end;

// perform screen test
procedure TCustomComTerminal.PerformTest(ACh: Char);
var
  I, J: Integer;
  TermCh: TComTermChar;
begin
  with TermCh do
  begin
    Ch := ACh;
    FrontColor := Font.Color;
    BackColor := Color;
    Underline := False;
  end;
  for I := 1 to FColumns do
    for J := 1 to FRows do
      FBuffer.SetChar(I, J, TermCh);
  Invalidate;
end;

// get current character properties
function TCustomComTerminal.GetCharAttr: TComTermChar;
begin
  // NEW made changes to solve colorchanging problem
  if FTermAttr.AltIntensity then
    Result.FrontColor := FAltColor
  else
    if FTermAttr.Invert then
      // Result.FrontColor := Color
      Result.FrontColor := FTermAttr.BackColor
    else
      // Result.BackColor := Font.Color;
      Result.FrontColor := FTermAttr.FrontColor;
  if FTermAttr.Invert then
    // Result.BackColor := Font.Color
    Result.BackColor := FTermAttr.FrontColor
  else
    // Result.FrontColor := Color
    Result.BackColor := FTermAttr.BackColor;
  // NEW end changes
  Result.Underline := FTermAttr.Underline;
  Result.Ch := #0;
end;

// put one character on screen
procedure TCustomComTerminal.PutChar(Ch: Char);
var
  TermCh: TComTermChar;

begin
  case Ch of
    #8: AdvanceCaret(acBackspace);
    #9: AdvanceCaret(acTab);
// ORIGINAL
//    #10, #12: AdvanceCaret(acLineFeed);
// NEW, difference between LF en Page
    #10: AdvanceCaret(acLineFeed);
    #12: AdvanceCaret(acPage);               {Page commando}
// END NEW
    #13: AdvanceCaret(acReturn);
    #32..#255:
      begin
        TermCh := GetCharAttr;
        TermCh.Ch := Ch;
        FBuffer.SetChar(FCaretPos.X, FCaretPos.Y, TermCh);
        DrawChar(FCaretPos.X - FTopLeft.X + 1,
          FCaretPos.Y - FTopLeft.Y + 1, TermCh);
        AdvanceCaret(acChar);
      end;
  end;
  DoChar(Ch);
end;

// init caret
procedure TCustomComTerminal.InitCaret;
begin
  CreateTerminalCaret;
  MoveCaret(FCaretPos.X, FCaretPos.Y);
  ShowCaret;
end;

// restore caret position
procedure TCustomComTerminal.RestoreCaretPos;
begin
  MoveCaret(FSaveCaret.X, FSaveCaret.Y);
end;

// save caret position
procedure TCustomComTerminal.SaveCaretPos;
begin
  FSaveCaret := FCaretPos;
end;

// restore attributes
procedure TCustomComTerminal.RestoreAttr;
begin
  FTermAttr := FSaveAttr;
end;

// save attributes
procedure TCustomComTerminal.SaveAttr;
begin
  FSaveAttr := FTermAttr;
end;

procedure TCustomComTerminal.RxBuf(Sender: TObject; const Buffer;  Count: Integer);
var
  Str: String;
  sa : Ansistring;

  // append line feeds to carriage return
  procedure AppendLineFeeds;
  var
    I: Integer;
  begin
    I := 1;
    while I <= Length(Str) do
    begin
      if Str[I] = Chr(13) then
        Str := Copy(Str, 1, I) + Chr(10) + Copy(Str, I + 1, Length(Str) - I);
      Inc(I);
    end;
  end;

  // convert to 7 bit data
  procedure Force7BitData;
  var
    I: Integer;
  begin
    SetLength(Str, Count);
    for I := 1 to Length(Str) do
      Str[I] := Char(Byte(Sa[I]) and $0FFFFFFF);
  end;

  procedure Force8BitData;
  var
    I: Integer;
  begin
    SetLength(Str, Count);
    for I := 1 to Length(Str) do
      Str[I] := Char(Byte(Sa[I]));
  end;

begin
  SetLength(sa,count);
  Move(Buffer, Sa[1], Count);
//  Move(Buffer, Str[1], Count);
//  Str := AnsiString(sa);
  if FForce7Bit then
    Force7BitData
  else Force8BitData;
  if FAppendLF then
    AppendLineFeeds;
  StringReceived(Str);
end;

function TCustomComTerminal.GetConnected: Boolean;
begin
  Result := False;
  if FComPort <> nil then
    Result := FComPort.Connected;
end;

procedure TCustomComTerminal.SetConnected(const Value: Boolean);
begin
  if FComPort <> nil then
    FComPort.Connected := Value;
end;

procedure TCustomComTerminal.SetBorderStyle(const Value: TBorderStyle);
begin
  if FBorderStyle <> Value then
  begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

procedure TCustomComTerminal.SetScrollBars(const Value: TScrollStyle);
begin
  if FScrollBars <> Value then
  begin
    FScrollBars := Value;
    RecreateWnd;
  end;
end;

procedure TCustomComTerminal.SetColumns(const Value: Integer);
begin
  if Value <> FColumns then
  begin
    FColumns := Min(Max(2, Value), 256);
{$IFDEF DELPHI_4_OR_HIGHER}
    AdjustSize;
{$ENDIF}
    UpdateScrollRange;
    if not ((csLoading in ComponentState) or (csDesigning in ComponentState)) then
    begin
      FBuffer.Init;
      Invalidate;
    end;
  end;
end;

procedure TCustomComTerminal.SetRows(const Value: Integer);
begin
  if Value <> FRows then
  begin
    FRows := Min(Max(2, Value), 100);
{$IFDEF DELPHI_4_OR_HIGHER}
    AdjustSize;
{$ENDIF}
    UpdateScrollRange;
    if not ((csLoading in ComponentState) or (csDesigning in ComponentState)) then
    begin
      FBuffer.Init;
      Invalidate;
    end;
  end;
end;

procedure TCustomComTerminal.SetEmulation(const Value: TTermEmulation);
begin
  if FEmulation <> Value then
  begin
    FEmulation := Value;
    if not (csLoading in ComponentState) then
    begin
      FEscapeCodes.Free;
      CreateEscapeCodes;
    end;
  end;
end;

procedure TCustomComTerminal.SetCaret(const Value: TTermCaret);
begin
  if Value <> FCaret then
  begin
    FCaret := Value;
    if Focused then
    begin
      DestroyCaret;
      InitCaret;
    end;
  end;
end;

procedure TCustomComTerminal.SetComPort(const Value: TCustomComPort);
begin
  if Value <> FComPort then
  begin
    if FComPort <> nil then
      FComPort.UnRegisterLink(FComLink);
    FComPort := Value;
    if FComPort <> nil then
    begin
      FComPort.FreeNotification(Self);
      FComPort.RegisterLink(FComLink);
    end;
  end;
end;

procedure TCustomComTerminal.SetAltColor(const Value: TColor);
begin
  if FAltColor <> Value then
  begin
    FAltColor := Value;
    if csDesigning in ComponentState then
      Invalidate;
  end;
end;

initialization
  // initialize default terminal font
  ComTerminalFont := TFont.Create;
  ComTerminalFont.Name := 'Fixedsys';
  ComTerminalFont.Color := clWhite;
  ComTerminalFont.Size := 9;

finalization
  ComTerminalFont.Free;

end.
