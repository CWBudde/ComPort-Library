unit BarCodeScaner;
{$I CPort.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CPort;

type
  TBarCodeEvent = procedure (var BarCode: String) of Object;

  TBarCodeScaner = class(TCustomComPort)
  private
    FOnBarCode: TBarCodeEvent;
    FTempStr: String;
    FTermChar: Char;
  protected
    procedure DoAfterOpen; override;
    procedure DoError(Errors: TComErrors); override;
    procedure DoRxChar(Count: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Connected;
    property BaudRate;
    property Port;
    property Parity;
    property StopBits;
    property DataBits;
    property DiscardNull;
    property EventChar;
    property Events;
    property Buffer;
    property FlowControl;
    property Timeouts;
    property SyncMethod;
{    property OnAfterOpen;
    property OnAfterClose;
    property OnBeforeOpen;
    property OnBeforeClose;
    property OnRxChar;
    property OnRxBuf;
    property OnTxEmpty;
    property OnBreak;
    property OnRing;
    property OnCTSChange;
    property OnDSRChange;
    property OnRLSDChange;
    property OnRxFlag;
    property OnError;
    property OnRx80Full;}
    property TermChar: Char read FTermChar write FTermChar default #0;
    property OnBarCode: TBarCodeEvent read FOnBarCode write FOnBarCode;
  end;

procedure Register;

implementation

uses CPortReg, DsgnIntf;

procedure Register;
begin
  RegisterComponents('CPortLib', [TBarCodeScaner]);
  RegisterComponentEditor(TBarCodeScaner, TComPortEditor);
end;

constructor TBarCodeScaner.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTermChar := #0;
end;

procedure TBarCodeScaner.DoAfterOpen;
begin
  inherited DoAfterOpen;
  FTempStr := '';
end;

procedure TBarCodeScaner.DoRxChar(Count: Integer);
var
  Str: String;
  CurPos : Integer;
begin
  inherited DoRxChar(Count);
  if not Assigned(FOnBarCode) then Exit;
  ReadStr(Str, Count);
  CurPos := Pos( FTermChar ,Str);
  if CurPos = 0 then begin
    FTempStr := FTempStr + Str;
  end
  else begin
    FTempStr := FTempStr + Copy( Str, 1, CurPos-1);
    FOnBarCode(FTempStr);
    FTempStr := '';
  end;
end;

procedure TBarCodeScaner.DoError(Errors: TComErrors);
begin
//  Application.ProcessMessages;
  if Errors = [] then Exit;
  inherited DoError(Errors);
  if ceFrame in Errors then
     Application.MessageBox('The hardware detected a framing error.', 'Ошибка', MB_ICONERROR+MB_OK);
  if ceOverrun in Errors then
     Application.MessageBox('A charachter buffer overrun has occured.'+#13+'The next charachter is lost.', 'Ошибка', MB_ICONERROR+MB_OK);
  if ceRxParity in Errors  then
     Application.MessageBox('The hardware detected a parity error.', 'Ошибка', MB_ICONERROR+MB_OK);
  if ceBreak in Errors  then
     Application.MessageBox('The hardware detected a break condition.', 'Ошибка', MB_ICONERROR+MB_OK);
  if ceIO in Errors  then
     Application.MessageBox('An I/O error occured during communication with the device.', 'Ошибка', MB_ICONERROR+MB_OK);
  if ceMode in Errors  then
     Application.MessageBox('The requested mode is not supported.', 'Ошибка', MB_ICONERROR+MB_OK);
  if ceRxOver in Errors  then
     Application.MessageBox('An input buffer overflow has occured.', 'Ошибка', MB_ICONERROR+MB_OK);
  if ceTxFull in Errors  then
     Application.MessageBox('The output buffer is full.', 'Ошибка', MB_ICONERROR+MB_OK);
end;

end.
