unit ComMainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, CPort, CPortCtl;

type
  TForm1 = class(TForm)
    ComPort: TComPort;
    Memo: TMemo;
    Button_Open: TButton;
    Button_Settings: TButton;
    Edit_Data: TEdit;
    Button_Send: TButton;
    NewLine_CB: TCheckBox;
    Panel1: TPanel;
    Bt_Store: TButton;
    Bt_Load: TButton;
    ComLed1: TComLed;
    ComLed2: TComLed;
    ComLed3: TComLed;
    ComLed4: TComLed;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ComLed5: TComLed;
    ComLed6: TComLed;
    Label1: TLabel;
    Label6: TLabel;
    procedure Button_OpenClick(Sender: TObject);
    procedure Button_SettingsClick(Sender: TObject);
    procedure Button_SendClick(Sender: TObject);
    procedure ComPortOpen(Sender: TObject);
    procedure ComPortClose(Sender: TObject);
    procedure ComPortRxChar(Sender: TObject; Count: Integer);
    procedure Bt_LoadClick(Sender: TObject);
    procedure Bt_StoreClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button_OpenClick(Sender: TObject);
begin
  if ComPort.Connected then
    ComPort.Close
  else
    ComPort.Open;
end;

procedure TForm1.Button_SettingsClick(Sender: TObject);
begin
  ComPort.ShowSetupDialog;
end;

procedure TForm1.Button_SendClick(Sender: TObject);
var
  Str: String;
begin
  Str := Edit_Data.Text;
  if NewLine_CB.Checked then
    Str := Str + #13#10;
  ComPort.WriteStr(Str);
end;

procedure TForm1.ComPortOpen(Sender: TObject);
begin
  Button_Open.Caption := 'Close';
end;

procedure TForm1.ComPortClose(Sender: TObject);
begin
  if Button_Open <> nil then
    Button_Open.Caption := 'Open';
end;

procedure TForm1.ComPortRxChar(Sender: TObject; Count: Integer);
var
  Str: String;
begin
  ComPort.ReadStr(Str, Count);
  Memo.Text := Memo.Text + Str;
end;

procedure TForm1.Bt_LoadClick(Sender: TObject);
begin
  ComPort.LoadSettings(stRegistry, 'HKEY_LOCAL_MACHINE\Software\Dejan');
//  ComPort.LoadSettings(stIniFile, 'e:\Test.ini');
end;

procedure TForm1.Bt_StoreClick(Sender: TObject);
begin
//  ComPort.StoreSettings(stIniFile, 'e:\Test.ini');
  ComPort.StoreSettings(stRegistry, 'HKEY_LOCAL_MACHINE\Software\Dejan');
end;

end.
