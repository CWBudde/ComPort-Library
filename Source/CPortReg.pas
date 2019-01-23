(******************************************************
 * ComPort Library ver. 4.11                          *
 *   for Delphi 5, 6, 7, 2007-2010,XE  and            *
 *   C++ Builder 3, 4, 5, 6                           *
 * written by Dejan Crnila, 1998 - 2002               *
 * maintained by Lars B. Dybdahl, 2003                *
 * Homepage: http://comport.sf.net/                   *
 *****************************************************)

unit CPortReg;

{$I CPort.inc}

interface

uses
  DesignIntf, DesignEditors, DesignMenus, PropertyCategories,
  Classes, Menus;

type
  // default ComPort Library component editor
  TComLibraryEditor = class(TComponentEditor)
  public
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
    procedure ExecuteVerb(Index: Integer); override;
  end;

  // TComPort component editor
  TComPortEditor = class(TComLibraryEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
    procedure Edit; override;
  end;

  // TComTerminal component editor
  TComTerminalEditor = class(TComLibraryEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
    procedure Edit; override;
  end;

  // TComPort.Port property editor
  TComPortProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  // a special font property editor to allow only fixed picth fonts to be selected
  // TComTerminal font property editor
  TComFontProperty = class(TClassProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

procedure Register;

implementation

{$R CPortImg.res}

uses
  CPort, CPortCtl, CPortSetup, CPortTrmSet, CPortAbout,
  Forms, Dialogs, Graphics;

(*****************************************
 * TComLibraryEditor editor              *
 *****************************************)

procedure TComLibraryEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then
    ShowAbout;
end;

function TComLibraryEditor.GetVerb(Index: Integer): string;
begin
  if Index = 0 then
    Result := 'ComPort Library version ' + CPortLibraryVersion;
end;

function TComLibraryEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

(*****************************************
 * TComPortEditor editor                 *
 *****************************************)

procedure TComPortEditor.Edit;
begin
  (Component as TCustomComPort).ShowSetupDialog;
  Designer.Modified;
end;

procedure TComPortEditor.ExecuteVerb(Index: Integer);
begin
  inherited ExecuteVerb(Index);
  if Index = 1 then
    Edit;
end;

function TComPortEditor.GetVerb(Index: Integer): string;
begin
  Result := inherited GetVerb(Index);
  if Index = 1 then
    Result := 'Port settings';
end;

function TComPortEditor.GetVerbCount: Integer;
begin
  Result := inherited GetVerbCount + 1;
end;

(*****************************************
 * TComTerminalEditor editor             *
 *****************************************)

procedure TComTerminalEditor.Edit;
begin
  (Component as TComTerminal).ShowSetupDialog;
  Designer.Modified;
end;

procedure TComTerminalEditor.ExecuteVerb(Index: Integer);
begin
  inherited ExecuteVerb(Index);
  if Index = 1 then
    Edit;
end;

function TComTerminalEditor.GetVerb(Index: Integer): string;
begin
  Result := inherited GetVerb(Index);
  if Index = 1 then
    Result := 'Terminal and ASCII settings';
end;

function TComTerminalEditor.GetVerbCount: Integer;
begin
  Result := inherited GetVerbCount + 1;
end;

(*****************************************
 * TComPortProperty editor               *
 *****************************************)

function TComPortProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paRevertable, paSortList, paValueList];
end;

procedure TComPortProperty.GetValues(Proc: TGetStrProc);
var
  List: TStringList;
  I: Integer;
begin
  List := TStringList.Create;
  EnumComPorts(List);
  for I := 0 to List.Count - 1 do
    Proc(List[I]);
  List.Free;
end;

(*****************************************
 * TComFontProperty editor               *
 *****************************************)

procedure TComFontProperty.Edit;
var
  FontDialog: TFontDialog;
begin
  FontDialog := TFontDialog.Create(Application);
  try
    FontDialog.Font := TFont(GetOrdValue);
    FontDialog.Options := FontDialog.Options + [fdFixedPitchOnly, fdForceFontExist];
    if FontDialog.Execute then SetOrdValue(Longint(FontDialog.Font));
  finally
    FontDialog.Free;
  end;
end;

function TComFontProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paSubProperties, paDialog, paReadOnly];
end;

procedure Register;
begin
  RegisterComponents('CPortLib', [TComPort, TComDataPacket,
    TComComboBox, TComRadioGroup, TComLed, TComTerminal]);
  RegisterComponentEditor(TComPort, TComPortEditor);
  RegisterComponentEditor(TComTerminal, TComTerminalEditor);
  RegisterComponentEditor(TComDataPacket, TComLibraryEditor);
  RegisterComponentEditor(TComLed, TComLibraryEditor);
  RegisterComponentEditor(TComRadioGroup, TComLibraryEditor);
  RegisterComponentEditor(TComComboBox, TComLibraryEditor);
  RegisterPropertyEditor(TypeInfo(TPort), TCustomComPort, 'Port', TComPortProperty);
  RegisterPropertyEditor(TypeInfo(TFont), TCustomComTerminal, 'Font', TComFontProperty);
  RegisterPropertiesInCategory('Serial communication', TComPort, ['BaudRate', 'StopBits',
    'DataBits', 'Port', 'EventChar', 'Connected', 'DiscardNull', 'Events',
    'FlowControl', 'Timeouts', 'Parity', 'Buffer', 'OnAfterOpen', 'OnBeforeOpen',
    'OnAfterClose', 'OnBeforeClose', 'OnRxChar', 'OnTxEmpty', 'OnCTSChange',
    'OnRLSDChange', 'OnDSRChange', 'OnError', 'OnRing', 'OnRxBuf', 'OnRxFlag',
    'OnRx80Full', 'OnBreak']);
  RegisterPropertiesInCategory('Packet setup', TComDataPacket, ['CaseInsensitive',
    'IncludeStrings', 'MaxBufferSize', 'Size', 'StartString', 'StopString']);
  RegisterPropertiesInCategory('ASCII setup', TComTerminal, ['AppendLF',
    'SendLF', 'Force7Bit', 'WrapLines', 'LocalEcho']);
  RegisterPropertiesInCategory('Packets', TComDataPacket,
    ['OnPacket', 'OnDiscard']);
  RegisterPropertiesInCategory('Terminal setup', TComTerminal,
    ['Columns', 'Rows', 'Emulation', 'Caret', 'Connected', 'Font', 'ArrowKeys',
    'OnGetEscapeCodes', 'OnUnhandledCode', 'OnStrRecieved']);
end;

end.
