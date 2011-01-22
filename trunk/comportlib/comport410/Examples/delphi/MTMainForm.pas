unit MTMainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CPort, StdCtrls, CPortCtl, ExtCtrls, Menus,IniFiles, ComCtrls;

type
  TMainForm = class(TForm)
    Panel: TPanel;
    ComTerminal: TComTerminal;
    ConnButton: TButton;
    ComPort: TComPort;
    PortButton: TButton;
    TermButton: TButton;
    FontButton: TButton;
    TerminalReady: TComLed;
    Label1: TLabel;
    Label2: TLabel;
    ComLed1: TComLed;
    PopupMenu1: TPopupMenu;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    Button1: TButton;
    ComDataPacket1: TComDataPacket;
    StatusBar1: TStatusBar;
    procedure ConnButtonClick(Sender: TObject);
    procedure ComPortAfterOpen(Sender: TObject);
    procedure ComPortAfterClose(Sender: TObject);
    procedure PortButtonClick(Sender: TObject);
    procedure TermButtonClick(Sender: TObject);
    procedure FontButtonClick(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure ComDataPacket1Packet(Sender: TObject; const Str: string);
    procedure ComDataPacket1CustomStart(Sender: TObject; const Str: string;
      var Pos: Integer);
    procedure ComDataPacket1CustomStop(Sender: TObject; const Str: string;
      var Pos: Integer);
  private
    { Private declarations }
    FInitFlag:Boolean;
    FIni:TMemIniFile;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

uses Clipbrd;
procedure TMainForm.ConnButtonClick(Sender: TObject);
begin
  ComTerminal.Connected := not ComTerminal.Connected;
end;

procedure TMainForm.ComPortAfterOpen(Sender: TObject);
begin
  ConnButton.Caption := 'Disconnect';
end;

procedure TMainForm.ComDataPacket1CustomStart(Sender: TObject;
                                          const Str: string; var Pos: Integer);
begin
  if pos >= 0 then
    StatusBar1.Panels[1].Text := 'Start @'+IntToSTr(pos);
end;

procedure TMainForm.ComDataPacket1CustomStop(Sender: TObject; const Str: string;
                                                            var Pos: Integer);
begin
  if Pos >=0 then
    StatusBar1.Panels[2].Text  := 'Stop @'+IntToSTr(pos);
end;

procedure TMainForm.ComDataPacket1Packet(Sender: TObject; const Str: string);
begin
  StatusBar1.Panels[0].Text := 'FOUND: '+str+  '                                  '  ;
  ComDataPacket1.ResetBuffer;
end;

procedure TMainForm.ComPortAfterClose(Sender: TObject);
begin
  ConnButton.Caption := 'Connect';
end;

procedure TMainForm.Paste1Click(Sender: TObject);
var s:string;
begin
  s  := Clipboard.AsText;
  ComPort.WriteStr(s);
end;

procedure TMainForm.PortButtonClick(Sender: TObject);
begin
  ComPort.ShowSetupDialog;
end;

procedure TMainForm.TermButtonClick(Sender: TObject);
begin
  ComTerminal.ShowSetupDialog;
end;

procedure TMainForm.FontButtonClick(Sender: TObject);
begin
  ComTerminal.SelectFont;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   if Assigned(FIni) then begin
     FIni.WriteString('ComPort', 'ComPort', ComPort.Port );
     FIni.WriteString('ComPort','BaudRate', BaudRateToStr( ComPort.BaudRate ) );
     FIni.WriteString('ComPort','FlowControl', FlowControlToStr(ComPort.FlowControl.FlowControl ));
     FIni.UpdateFile;
     FIni.Free;
   end;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
 if not FInitFlag then begin
   FInitFlag := true;
   FIni := TMemIniFile.Create( ExtractFilePath(Application.ExeName)+'terminal.ini');
   ComPort.Port := FIni.ReadString('ComPort', 'ComPort',ComPort.Port);
   ComPort.BaudRate := StrToBaudRate( FIni.ReadString('ComPort','BaudRate', '19200'));
   ComPort.FlowControl.FlowControl := StrToFlowControl( FIni.ReadString('ComPort','FlowControl', 'Hardware'));
   ConnButton.Click;
 end;
end;

procedure TMainForm.Button1Click(Sender: TObject);
var  s:String;
begin
   ComPort.Connected := false;
   ComTerminal.Connected := false;
   Application.ProcessMessages;
   ComPort.Connected := true;
   ComPort.WriteStr('AT'+CHR(13));  {Send modem Command}
   Sleep(200);
   ComPort.ReadStr(S,80); {Get modem response.}
   if Pos('OK',s)>0 then
     Application.MessageBox( PChar('Modem is responding normally '+ComPort.Port), 'Test', MB_OK)
   else
     Application.MessageBox( PChar('No modem responding on '+ComPort.Port), 'Test', MB_OK);
   ComPort.Connected := false;
end;

end.
