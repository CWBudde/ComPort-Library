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
{$IFDEF DELPHI_6_OR_HIGHER}
  DesignIntf, DesignEditors, DesignMenus, PropertyCategories,
{$ELSE}
  DsgnIntf,
{$ENDIF}
  Classes, Menus;

type
  // default ComPort Library component editor
  TComLibraryEditor = class(TComponentEditor)
  public
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
    procedure ExecuteVerb(Index: Integer); override;
{$IFDEF DELPHI_5}
    procedure PrepareItem(Index: Integer; const AItem: TMenuItem); override;
{$ENDIF}
  end;

  // TComPort component editor
  TComPortEditor = class(TComLibraryEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
{$IFDEF DELPHI_5}
    procedure PrepareItem(Index: Integer; const AItem: TMenuItem); override;
{$ENDIF}
    procedure Edit; override;
  end;

  // TComTerminal component editor
  TComTerminalEditor = class(TComLibraryEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
{$IFDEF DELPHI_5}
    procedure PrepareItem(Index: Integer; const AItem: TMenuItem); override;
{$ENDIF}
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

{$IFDEF DELPHI_5}
  TComCat = class(TPropertyCategory)
  public
    class function Name: string; override;
    class function Description: string; override;
  end;

  TComPacketCat = class(TPropertyCategory)
  public
    class function Name: string; override;
    class function Description: string; override;
  end;

  TComAsciiSetupCat = class(TPropertyCategory)
  public
    class function Name: string; override;
    class function Description: string; override;
  end;

  TComPacketEventsCat = class(TPropertyCategory)
  public
    class function Name: string; override;
    class function Description: string; override;
  end;

  TComTerminalCat = class(TPropertyCategory)
  public
    class function Name: string; override;
    class function Description: string; override;
  end;

{$ENDIF}

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

{$IFDEF DELPHI_5}
procedure TComLibraryEditor.PrepareItem(Index: Integer;
  const AItem: TMenuItem);
begin
  if Index = 0 then
    AItem.Bitmap.LoadFromResourceName(HInstance, 'CPORTLIB');
end;
{$ENDIF}

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

{$IFDEF DELPHI_5}
procedure TComPortEditor.PrepareItem(Index: Integer;
  const AItem: TMenuItem);
begin
  if Index = 1 then
    AItem.Default := True;
  inherited PrepareItem(Index, AItem);
end;
{$ENDIF}

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

{$IFDEF DELPHI_5}
procedure TComTerminalEditor.PrepareItem(Index: Integer;
  const AItem: TMenuItem);
begin
  if Index = 1 then
    AItem.Default := True;
  inherited PrepareItem(Index, AItem);
end;
{$ENDIF}

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

{$IFDEF DELPHI_5}

(*****************************************
 * TComCategory property category        *
 *****************************************)

class function TComCat.Description: string;
begin
  Result := 'Serial communication settings';
end;

class function TComCat.Name: string;
begin
  Result := 'Serial Communication';
end;

(*****************************************
 * TComCategoryCat property category     *
 *****************************************)

class function TComPacketCat.Description: string;
begin
  Result := 'Setup packet properties';
end;

class function TComPacketCat.Name: string;
begin
  Result := 'Packet setup';
end;

(*****************************************
 * TComAsciiSetupCat property category   *
 *****************************************)

class function TComAsciiSetupCat.Description: string;
begin
  Result := 'Setup ASCII recieving and sending';
end;

class function TComAsciiSetupCat.Name: string;
begin
  Result := 'ASCII Setup';
end;

(*****************************************
 * TComPacketEventsCat property category *
 *****************************************)

class function TComPacketEventsCat.Description: string;
begin
  Result := 'Packet events';
end;

class function TComPacketEventsCat.Name: string;
begin
  Result := 'Packet';
end;

(*****************************************
 * TComTerminalCat property category     *
 *****************************************)

class function TComTerminalCat.Description: string;
begin
  Result := 'Setup terminal settings';
end;

class function TComTerminalCat.Name: string;
begin
  Result := 'Terminal Setup';
end;

{$ENDIF}

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
{$IFDEF DELPHI_5}
  RegisterPropertiesInCategory(TComCat, TComPort, ['BaudRate', 'StopBits',
    'DataBits', 'Port', 'EventChar', 'Connected', 'DiscardNull', 'Events',
    'FlowControl', 'Timeouts', 'Parity', 'Buffer', 'OnAfterOpen', 'OnBeforeOpen',
    'OnAfterClose', 'OnBeforeClose', 'OnRxChar', 'OnTxEmpty', 'OnCTSChange',
    'OnRLSDChange', 'OnDSRChange', 'OnError', 'OnRing', 'OnRxBuf', 'OnRxFlag',
    'OnRx80Full', 'OnBreak']);
  RegisterPropertiesInCategory(TComPacketCat, TComDataPacket, ['CaseInsensitive',
    'IncludeStrings', 'MaxBufferSize', 'Size', 'StartString', 'StopString']);
  RegisterPropertiesInCategory(TComAsciiSetupCat, TComTerminal, ['AppendLF',
    'SendLF', 'Force7Bit', 'WrapLines', 'LocalEcho']);
  RegisterPropertiesInCategory(TComPacketEventsCat, TComDataPacket,
    ['OnPacket', 'OnDiscard']);
  RegisterPropertiesInCategory(TComTerminalCat, TComTerminal,
    ['Columns', 'Rows', 'Emulation', 'Caret', 'Connected', 'Font', 'ArrowKeys',
    'OnGetEscapeCodes', 'OnUnhandledCode', 'OnStrRecieved']);
  RegisterPropertiesInCategory(TVisualCategory, TComLed, ['Kind']);
{$ENDIF}
{$IFDEF DELPHI_6_OR_HIGHER}
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
{$ENDIF}
end;

end.
