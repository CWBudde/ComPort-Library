unit CPortUTestMainFm;

{ Unit Test Code for CPort Component - main form used by all delphi versions }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, CPort, CPortCtl;

type
  TCPortUTestMainForm = class(TForm)
    TraceMemo: TMemo;
    PanelTop: TPanel;
    ComComboBox1: TComComboBox;
    Label1: TLabel;
    Button1: TButton;
    LabelResult: TLabel;
    ComPort1: TComPort;
    procedure Button1Click(Sender: TObject);
    procedure ComPort1AfterClose(Sender: TObject);
    procedure ComPort1AfterOpen(Sender: TObject);
    procedure ComPort1BeforeClose(Sender: TObject);
    procedure ComPort1BeforeOpen(Sender: TObject);
    procedure ComPort1Break(Sender: TObject);
    procedure ComPort1CTSChange(Sender: TObject; OnOff: Boolean);
    procedure ComPort1DSRChange(Sender: TObject; OnOff: Boolean);
    procedure ComPort1Error(Sender: TObject; Errors: TComErrors);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    procedure Trace(msg:String);
    procedure Fail;
  public
    { Public declarations }
  end;

var
  CPortUTestMainForm: TCPortUTestMainForm;

implementation

{$R *.dfm}

{START: Suff needed for early Delphi <=5}
var
  TrueBoolStrs: array of String;
  FalseBoolStrs: array of String;

const
  DefaultTrueBoolStr = 'True';   // DO NOT LOCALIZE
  DefaultFalseBoolStr = 'False'; // DO NOT LOCALIZE

procedure VerifyBoolStrArray;
begin
  if Length(TrueBoolStrs) = 0 then
  begin
    SetLength(TrueBoolStrs, 1);
    TrueBoolStrs[0] := DefaultTrueBoolStr;
  end;
  if Length(FalseBoolStrs) = 0 then
  begin
    SetLength(FalseBoolStrs, 1);
    FalseBoolStrs[0] := DefaultFalseBoolStr;
  end;
end;

function BoolToStr(B: Boolean; UseBoolStrs: Boolean = False): string;

const
  cSimpleBoolStrs: array [boolean] of String = ('0', '-1');
begin
  if UseBoolStrs then
  begin
    VerifyBoolStrArray;
    if B then
      Result := TrueBoolStrs[0]
    else
      Result := FalseBoolStrs[0];
  end
  else
    Result := cSimpleBoolStrs[B];
end;
{END: Stuff needed for early Delphi <5}


procedure TCPortUTestMainForm.Fail;
begin
   LabelResult.Caption := 'Result:Fail';
   LabelResult.Font.Color := clRed;
end;

procedure TCPortUTestMainForm.FormCloseQuery(Sender: TObject;  var CanClose: Boolean);
begin
  ComPort1.Connected := false;
  Application.ProcessMessages;
  CanClose :=  not ComPort1.Connected;
  if not CanClose then Trace('Failed closing COM port.')
end;

procedure TCPortUTestMainForm.Button1Click(Sender: TObject);
begin
  TraceMemo.Lines.Add('');
  ComComboBox1.ApplySettings; { writes itself out to the com port object }
  ComPort1.Connected := true;
  if ComPort1.Connected then
      Trace('Starting tests.')
  else begin
      Fail;
      exit;
  end;

  Sleep(100);
  Trace('Tests completed. Closing com port.');
  ComPort1.Connected := false;
end;

procedure TCPortUTestMainForm.ComPort1AfterClose(Sender: TObject);
begin
  Trace('event:AfterClose');
end;

procedure TCPortUTestMainForm.ComPort1AfterOpen(Sender: TObject);
begin
  Trace('event:AfterOpen');
end;

procedure TCPortUTestMainForm.ComPort1BeforeClose(Sender: TObject);
begin
  Trace('event:BeforeClose');
end;

procedure TCPortUTestMainForm.ComPort1BeforeOpen(Sender: TObject);
begin
  Trace('event:BeforeOpen');
end;

procedure TCPortUTestMainForm.ComPort1Break(Sender: TObject);
begin
  Trace('event:OnBreak');
end;

procedure TCPortUTestMainForm.ComPort1CTSChange(Sender: TObject; OnOff: Boolean);
begin
  Trace('event:OnCtsChange: State:'+BoolToStr(OnOff,true));
end;

procedure TCPortUTestMainForm.ComPort1DSRChange(Sender: TObject; OnOff: Boolean);
begin
  Trace('event:OnDSRChange: State:'+BoolToStr(OnOff,true));
end;

procedure TCPortUTestMainForm.ComPort1Error(Sender: TObject; Errors: TComErrors);
begin
  Trace('event:Error: '+ComErrorsToStr(Errors));
end;

procedure TCPortUTestMainForm.Trace(msg: String);
begin
  TraceMemo.Lines.Add(FormatDateTime('hh:nn:ss',now)+' : '+msg);
  if TraceMemo.Lines.Count>500 then
      TraceMemo.Lines.Delete(0);
end;

end.
