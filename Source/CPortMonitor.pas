{***************************************************************
 *
 * Unit Name: CPortMonitor
 * Purpose  : Addition to ComPort 2.60 Communication Library
 *						TMemo to monitor incoming and outgoing data
 * Author   :	Roelof Y. Ensing (ensingroel@msn.com)
 * History  : June 2000, first edition
 *
 ****************************************************************}

unit CPortMonitor;
{$I CPort.inc}

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	StdCtrls, Math, CPortCtl, CPort;

type

	TMonitorStyle = (msAscii,msHex,msHexC,msHexVB,msHexPascal,msDecimal,msBinary);
	TMonitorEvent = procedure (var DisplayValue:string;const Data:string; ComPort: TComPort) of object;
	TMonitorInfo = (miCommPort, miDate, miTime, miDirection);
	TMonitorInfoSet = set of TMonitorInfo;

	TCPortMonitor = class(TCustomMemo)
	private
		FLines:TStringList;
		FBackColorOutput: TColor;
		FBackColorInput: TColor;
		FForeColorOutput: TColor;
		FForeColorInput: TColor;
		FColIncrement: integer;
		FRowIncrement: integer;
		FMonitorShow:TMonitorInfoSet;
		FUpdating:integer;
		FMonitorStyle:TMonitorStyle;
		FSpacing:integer;
		FEnclosed:boolean;
		FComLink:TComLink;
		FComPort:TComPort;
		FMaxLines:integer;
		FReverse:boolean;
		FOnInput:TMonitorEvent;
		FOnOutput:TMonitorEvent;
		procedure SetBackColorOutput (Value: TColor);
		procedure SetBackColorInput (Value: TColor);
		procedure SetForeColorOutput (Value: TColor);
		procedure SetForeColorInput (Value: TColor);
		procedure SetMonitorStyle(Value:TMonitorStyle);
		procedure SetSpacing(Value:integer);
		procedure SetEnclosed(Value:boolean);
		procedure SetComPort(Value:TComPort);
		procedure SetMaxLines(Value:integer);
		procedure SetReverse(Value:boolean);
		procedure SetMonitorShow(Value:TMonitorInfoSet);
		procedure WMPAINT (var Message: TMessage); message WM_PAINT;
		procedure WMHSCROLL (var Message: TMessage); message WM_HSCROLL;
		procedure WMVSCROLL (var Message: TMessage); message WM_VSCROLL;
		procedure WMLBUTTONDOWN (var Message: TMessage); message WM_LBUTTONDOWN;
		procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LButtonDblClk;
		procedure SetLines(AValue:TStringList);
		procedure TxBuf(Sender: TObject; const Buffer; Count: Integer);
		procedure RxBuf(Sender: TObject; const Buffer; Count: Integer);
		function StrToPrint(const s: string;spacing:integer): string;
		function StrToDecimal(const s: string;spacing:integer): string;
		function StrToBinary(const s: string;spacing:integer): string;
		function BufToHex(ABuf:pointer;const ALength,Spacing:integer;Prefix:string):string;
		function StrToHex(const s:string;spacing:integer;prefix:string):string;
		procedure AddLineToBuffer(const ALine:string;const AType:integer);
		function GetDisplayValue(const AValue:string;const AType:integer):string;
		procedure LinesChanging(Sender:TObject);
	protected
		procedure Change; override;
		procedure Notification(AComponent: TComponent; Operation: TOperation); override;
	public
		constructor Create (AOwner: TComponent); override;
		destructor Destroy; override;
		procedure CreateWnd; override;
		procedure Loaded; override;
	published
		property Align;
		//property Alignment;
{$IFDEF DELPHI_4_OR_HIGHER}
		property Anchors;
		property BiDiMode;
		property Constraints;
		property ParentBiDiMode;
{$ENDIF}
		property BorderStyle;
		property Color;
		property Ctl3D;
		//property DragCursor;
		//property DragKind;
		//property DragMode;
		//property Enabled;
		property Font;
		property HideSelection;
		//property ImeMode;
		//property ImeName;
		//property Lines;
		property MaxLength;
		//property OEMConvert;
		property ParentColor;
		property ParentCtl3D;
		property ParentFont;
		property ParentShowHint;
		property PopupMenu;
		//property ReadOnly;
		//property ScrollBars;
		property ShowHint;
		property TabOrder;
		property TabStop;
		property Visible;
		//property WantReturns;
		//property WantTabs;
		//property WordWrap;
		property OnChange;
		//property OnClick;
		//property OnDblClick;
		//property OnDragDrop;
		//property OnDragOver;
		//property OnEndDock;
		//property OnEndDrag;
		//property OnEnter;
		//property OnExit;
		//property OnKeyDown;
		//property OnKeyPress;
		//property OnKeyUp;
		//property OnMouseDown;
		//property OnMouseMove;
		//property OnMouseUp;
		//property OnStartDock;
		//property OnStartDrag;
		property BackColorOutput: TColor read FBackColorOutput write SetBackColorOutput default clAqua;
		property BackColorInput: TColor read FBackColorInput write SetBackColorInput default clWhite;
		property ForeColorOutput: TColor read FForeColorOutput write SetForeColorOutput default clNavy;
		property ForeColorInput: TColor read FForeColorInput write SetForeColorInput default clRed;
		property MonitorStyle:TMonitorStyle read FMonitorStyle write SetMonitorStyle default msHex;
		property Spacing:integer read fSpacing write SetSpacing default 0;
		property Enclosed:boolean read fEnclosed write SetEnclosed default true;
		property MaxLines:integer read FMaxLines write SetMaxLines default 1024;
		property Reverse:boolean read FReverse write SetReverse default true;
		property OnInput:TMonitorEvent read fOnInput write fOnInput;
		property OnOutput:TMonitorEvent read fOnOutput write fOnOutput;
		property ComPort: TComPort read FComPort write SetComPort;
		property MonitorShow:TMonitorInfoSet read FMonitorShow write SetMonitorShow;
	end;

procedure Register;

implementation

procedure Register;
begin
	RegisterComponents('CPortLib', [TCPortMonitor]);
end;

function TCPortMonitor.StrToPrint(const s: string;spacing:integer): string;
var
	i1,i3: integer;
begin
	Result := '';
	if Length(S) <= 0 then
		exit;
	for i1 := 1 to Length(s) do
	begin
		if fEnclosed then
			Result:=Result+'[';
		if ( ord(S[I1]) < 32 ) or ( ord(S[i1] ) > 127 ) then
			Result:=Result+format('x%.2x', [ord(S[i1])])
		else
			Result:=Result+s[i1];
		if fEnclosed then
			Result:=Result+']';
		if spacing > 0 then
			for i3 := 1 to spacing do
				result := result + ' ';
	 end;
end;

function TCPortMonitor.StrToDecimal(const s: string;spacing:integer): string;
var
	i1,i3: integer;
begin
	Result := '';
	if Length(S) <= 0 then
		exit;
	for i1 := 1 to Length(s) do
	begin
		if fEnclosed then
			Result:=Result+'[';
		Result:=Result+Format('%.3d',[ord(S[i1])]);
		if fEnclosed then
			Result:=Result+']';
		if spacing > 0 then
			for i3 := 1 to spacing do
				result := result + ' ';
	 end;
end;

function TCPortMonitor.StrToBinary(const s: string;spacing:integer): string;
var
	i1,i2,i3: integer;
	 quotient,pwr,numpres:integer;
	 x1: real;
	 x2: real;
begin
	Result := '';
	if Length(S) <= 0 then
		exit;
	for i1 := 1 to Length(s) do
	begin
		if fEnclosed then
			Result:=Result+'[';
		numpres := ord(s[i1]);
		for i2 := 8 downto 1 do
		begin
			x1			:= i2 - 1;
			x2			:= 2;
			pwr		:= trunc(power(x2,x1));
			quotient	:= numpres div pwr;
			if quotient > 0 then
			begin
				result := result + '1';
				numpres := numpres - pwr;
			end
			else
				result := result + '0';
		end;
		if fEnclosed then
			Result:=Result+']';
		if spacing > 0 then
		for i3 := 1 to spacing do
			result := result + ' ';
	end;
end;

function TCPortMonitor.BufToHex(ABuf:pointer;const ALength,Spacing:integer;Prefix:string):string;
var
	i1,i2:integer;
begin
	Result := '';
	if ALength <= 0 then
		exit;
	try
		for i1 :=0 to ALength -1 do
		begin
			if fEnclosed then
				Result:=Result+'[';
      Result:=Result+ Format(prefix+'%.2x', [ord(char(PChar(ABuf)[i1]))]);
			//AppendStr(Result,Format(prefix+'%.2x', [ord(char(PChar(ABuf)[i1]))] ));
			if fEnclosed then
				Result:=Result+']';
			if spacing > 0 then
				for i2 := 1 to spacing do
					Result:=Result+' ';//AppendStr(Result,' ');
		end;
	except
    Result:=Result+' (out of bounds)';
	end;
end;

function TCPortMonitor.StrToHex(const s:string;spacing:integer;prefix:string):string;
begin
	Result:=BufToHex(Pchar(s),Length(s),Spacing,prefix);
end;

{ **************************************************************************** }

constructor TCPortMonitor.Create (AOwner: TComponent);
begin
	inherited Create (AOwner);
	ReadOnly:=true;
	ScrollBars := ssBoth;
	WantReturns:= false;
	WantTabs := false;
	WordWrap := true;
	Font.Name := 'Courier';
	FBackColorOutput  := clAqua;
	FBackColorInput  := clWhite;
	FForeColorOutput  := clNavy;
	FForeColorInput  := clRed;
	FRowIncrement := 0;
	FMonitorStyle := msHex;
	FSpacing := 0;
	FEnclosed := true;
	FMaxLines := 1024;
	FReverse := true;
	FLines:=TStringList.Create;
	FLines.OnChange:=LinesChanging;
	FComLink := TComLink.Create;
	FComLink.OnRxBuf := RxBuf;
	FComLink.OnTxBuf := TxBuf;
	FMonitorShow := [miDirection];
end;

destructor TCPortMonitor.Destroy;
begin
	if FComPort <> nil then
	try
		FComPort.UnRegisterLink(FComLink);
	finally
		FComLink.Free;
	end;
	FLines.Free;
	inherited;
end;

procedure TCPortMonitor.CreateWnd;
begin
	inherited;
	FLines.Clear;
	inherited Lines.Clear;
	if (csDesigning in ComponentState) then
	begin
		AddLineToBuffer('Input Message',(0));
		AddLineToBuffer('Output Message',(1));
		//SetLines(FLines);
	end;
end;

procedure TCPortMonitor.Loaded;
begin
	FLines.Clear;
	inherited Lines.Clear;
	if (csDesigning in ComponentState) then
	begin
		AddLineToBuffer('Input Message',(0));
		AddLineToBuffer('Output Message',(1));
		//SetLines(FLines);
	end;
end;

procedure TCPortMonitor.Notification(AComponent: TComponent; Operation: TOperation);
begin
	inherited Notification(AComponent, Operation);
	if (AComponent = FComPort) and (Operation = opRemove) then
		ComPort := nil;
end;

procedure TCPortMonitor.AddLineToBuffer(const ALine:string;const AType:integer);
begin
	inc(FUpdating);
	try
		if FReverse then
		begin
			if FLines.Count >= fMaxLines then
			begin
				FLines.Delete(fLines.Count-1);
				inherited Lines.Delete(inherited Lines.Count -1);
			end;
			FLines.Insert(0,ALine);
			FLines.Objects[0]:=pointer(AType);
			inherited Lines.Insert(0,GetDisplayValue(ALine,AType));
		end
		else
		begin
			if FLines.Count >= fMaxLines then
			begin
				FLines.Delete(0);
				inherited Lines.Delete(0);
			end;
			FLines.AddObject(ALine,pointer(AType));
			inherited Lines.Add(GetDisplayValue(ALine,AType));
		end;
	finally
		Dec(FUpdating);
	end;
end;

function TCPortMonitor.GetDisplayValue(const AValue:string;const AType:integer):string;
var
	HH,MM,SS,MS:word;
begin
		case FMonitorStyle of
		msAscii:
			Result :=StrToPrint(AValue,fSpacing);
		msHex:
			Result :=StrToHex(AValue,fSpacing,'');    // NO style Hex
		msHexC:
			Result :=StrToHex(AValue,fSpacing,'0x');  // C style Hex
		msHexVB:
			Result :=StrToHex(AValue,fSpacing,'h');   // VB Style Hex
		msHexPascal:
			Result :=StrToHex(AValue,fSpacing,'$');   // Pascal Style Hex
		msBinary:
			Result :=StrToBinary(AValue,fSpacing);		// Binary
		msDecimal:
			Result :=StrToDecimal(AValue,fSpacing);		// Decimal
		end;
		if fMonitorShow <> [] then
			Result:=': '+Result;
		if (miTime in fMonitorShow) then
		begin
			DecodeTime(Now,HH,MM,SS,MS);
			Result:=Format('%.2d:%.2d:%.2d:%.3d ',[HH,MM,SS,MS])+Result;
		end;
		if (miDate in fMonitorShow) then
			Result:=DateToStr(Now)+' '+Result;
		if (miCommPort in fMonitorShow) then
			Result:=fComPort.Port+' '+Result;
		if (miDirection in fMonitorShow) then
		begin
			if AType <> 0 then
				Result:='-> '+Result
			else
				Result:='<- '+Result;
			end;
		if AType <> 0 then
		begin
			if Assigned(FOnOutput) then
				fOnOutput(Result,AValue,fComPort);
		end
		else
		begin
			if Assigned(FOnInput) then
				fOnInput(Result,AValue,fComPort);
		end;
end;

procedure TCPortMonitor.SetLines(AValue:TStringList);
var
	i:integer;
	S:string;
	iType:integer;
begin
	SelStart	:= SendMessage(handle, EM_LINEINDEX,0,0);
	SendMessage(handle,EM_SCROLLCARET,0,0);
	inc(FUpdating);
	inherited Lines.BeginUpdate;
	FLines.BeginUpdate;
	try
		for i:=0 to FLines.count -1 do
		begin
			S:=FLines[i];
			iType:=integer(FLines.Objects[i]);
			inherited Lines[i]:=GetDisplayValue(S,iType);
		end;
	finally
		FLines.EndUpdate;
		inherited Lines.EndUpdate;
		dec(FUpdating);
	end;
end;

procedure TCPortMonitor.LinesChanging(Sender:TObject);
begin
	if FUpdating <= 0 then
	begin
		SetLines(FLines);
		FUpdating:=0;
	end;
end;

procedure TCPortMonitor.WMLBUTTONDOWN (var Message: TMessage);
begin
	{ nada }
	inherited;
	refresh;
end;

procedure TCPortMonitor.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
	{ nada }
	inherited;
	refresh;
end;

{ **************************************************************************** }

procedure TCPortMonitor.Change;
// When the text changes adjust the highlighted line, if
// necessary, and repaint the control.
begin
	inherited Change;
  if HandleAllocated then begin
		FRowIncrement := GetScrollPos (Handle, SB_VERT);
		FColIncrement := GetScrollPos (Handle, SB_HORZ);
  end;
	Refresh;
end;

{ **************************************************************************** }

procedure TCPortMonitor.WMPAINT (var Message: TMessage);
// Repaint the control ...
var
  DC: HDC;
	RowHeight: integer;
	TextString: string;
	TextMargin: integer;
	ThisFont: TFont;
	iType:integer;
	i:integer;
begin
	inherited;
	// Get a DC for the canvas, and the current font
	DC := GetDC (Handle);
	ThisFont := Font;
	// Paint the highlighted text
	with TCanvas.Create do
	begin
		Handle := DC;
		Font := ThisFont;
		for i:=FRowIncrement to FLines.Count-1 do
		begin
			TextString:=inherited Lines[i];
			// Save the existing font color, then invert the colour
			iType:=integer(FLines.objects[i]);
			if iType <> 0 then
			//if strtointdef(Lines[i],0) mod 2 <> 0 then
			begin
				Font.Color  := FForeColorOutput;//ColorToRGB(FBackColorOutput) xor $02FFFFFF; // $02 value of high order byte is used to
				Brush.Color := FBackColorOutput;
			end
			else
			begin
				Font.Color := FForeColorInput;
				Brush.Color := FBackColorInput;
			end;
			RowHeight := TextHeight (TextString);                 // Get the height of the text
			TextMargin := Integer(Perform (EM_GETMARGINS, 0, 0)); // Offset from left edge of client area
			FillRect (Rect (0, ((i-FRowIncrement)*RowHeight)+1, ClientWidth, (((i-FRowIncrement) + 1)*RowHeight) + 1));
			TextOut (TextMargin + FColIncrement + 1, (i-FRowIncrement)*RowHeight + 1, TextString);
			if ((i-FRowIncrement)+1)*RowHeight > ClipRect.Bottom then
				break;
		end;
		Handle := 0;
		Free;
	end;
	// Release the DC when finished
	ReleaseDC(Handle, DC);

end;

{ **************************************************************************** }

procedure TCPortMonitor.SetBackColorOutput (Value: TColor);
begin
	FBackColorOutput := Value;
	Refresh;
end;

procedure TCPortMonitor.SetBackColorInput (Value: TColor);
begin
	FBackColorInput := Value;
	Refresh;
end;

procedure TCPortMonitor.SetForeColorOutput (Value: TColor);
begin
	FForeColorOutput := Value;
	Refresh;
end;

procedure TCPortMonitor.SetForeColorInput (Value: TColor);
begin
	FForeColorInput := Value;
	Refresh;
end;

procedure TCPortMonitor.SetMonitorStyle(Value:TMonitorStyle);
begin
	FMonitorStyle := Value;
	SetLines(FLines);
end;

procedure TCPortMonitor.SetSpacing(Value:integer);
begin
	if FSpacing >= 0 then
	begin
		FSpacing := Value;
		SetLines(FLines);
	end;
end;

procedure TCPortMonitor.SetEnclosed(Value:boolean);
begin
	FEnclosed := Value;
	SetLines(FLines);
end;

procedure TCPortMonitor.SetMonitorShow(Value:TMonitorInfoSet);
begin
	FMonitorShow := Value;
	SetLines(FLines);
end;

procedure TCPortMonitor.SetComPort(Value:TComPort);
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
		if not (csDesigning in ComponentState) then
			FLines.Clear;
	end;
end;

procedure TCPortMonitor.SetMaxLines(Value:integer);
begin
	if Value <> FMaxLines then
	begin
		FMaxLines:=Value;
		if not (csDesigning in ComponentState) then
			FLines.Clear;
	end;
end;

procedure TCPortMonitor.SetReverse(Value:boolean);
begin
	if Value <> FReverse then
	begin
		FReverse:=Value;
		if not (csDesigning in ComponentState) then
			FLines.Clear;
	end;
end;

procedure TCPortMonitor.TxBuf(Sender: TObject; const Buffer; Count: Integer);
var
	S:string;
begin
	SetLength(S,Count);
	Move(Buffer,s[1],Count);
	AddLineToBuffer(S,1);
end;

procedure TCPortMonitor.RxBuf(Sender: TObject; const Buffer; Count: Integer);
var
	S:string;
begin
	SetLength(S,Count);
	Move(Buffer,s[1],Count);
	AddLineToBuffer(S,0);
end;

{ **************************************************************************** }

procedure TCPortMonitor.WMVSCROLL (var Message: TMessage);
// Set the row increment according to the scroll bar position
begin
  inherited;
	FRowIncrement := GetScrollPos (Handle, SB_VERT);
	Refresh;
end;

{ **************************************************************************** }

procedure TCPortMonitor.WMHSCROLL (var Message: TMessage);
// Set the column increment according to the scroll bar position
begin
	inherited;
	FColIncrement := -GetScrollPos (Handle, SB_HORZ);
	Refresh;
end;



end.

