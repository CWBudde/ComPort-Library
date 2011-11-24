
(******************************************************
 * ComPort Library ver. 4.11                          *
 *   for Delphi 5, 6, 7, 2007-2010,XE  and            *
 * written by Dejan Crnila, 1998 - 2002               *
 * maintained by Lars B. Dybdahl, 2003                *
 *  and Warren Postma, 2008                           *
 *                                                    *
 * Fixed up for Delphi 2009 by W.Postma.  Oct 2008    *
 * More like completely rewritten, actually.          *
 *****************************************************)

  { Communications Port Setup Options Form }

unit CPortSetup;

{$I CPort.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, CPort, CPortCtl;

type
  // TComPort setup dialog
  TComSetupFrm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Combo2: TComComboBox;
    Combo3: TComComboBox;
    Combo4: TComComboBox;
    Combo5: TComComboBox;
    Combo6: TComComboBox;
    Combo1: TComComboBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure EditComPort(ComPort: TCustomComPort);

implementation

{$R *.DFM}

// show setup dialog
procedure EditComPort(ComPort: TCustomComPort);
begin
  with TComSetupFrm.Create(nil) do
  begin
    Combo1.ComPort := ComPort;
    Combo2.ComPort := ComPort;
    Combo3.ComPort := ComPort;
    Combo4.ComPort := ComPort;
    Combo5.ComPort := ComPort;
    Combo6.ComPort := ComPort;
    Combo1.UpdateSettings;
    Combo2.UpdateSettings;
    Combo3.UpdateSettings;
    Combo4.UpdateSettings;
    Combo5.UpdateSettings;
    Combo6.UpdateSettings;
    if ShowModal = mrOK then
    begin
      ComPort.BeginUpdate;
      Combo1.ApplySettings;
      Combo2.ApplySettings;
      Combo3.ApplySettings;
      Combo4.ApplySettings;
      Combo5.ApplySettings;
      Combo6.ApplySettings;
      ComPort.EndUpdate;
    end;
    Free;
  end;
end;

end.
