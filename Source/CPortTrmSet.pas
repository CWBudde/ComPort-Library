(******************************************************
 * ComPort Library ver. 4.11                          *
 *   for Delphi 5, 6, 7, 2007-2010,XE  and            *
 *   C++ Builder 3, 4, 5, 6                           *
 * written by Dejan Crnila, 1998 - 2002               *
 * maintained by Lars B. Dybdahl, 2003                *
 * Homepage: http://comport.sf.net/                   *
 *****************************************************)

unit CPortTrmSet;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CPortCtl;

type
  TComTrmSetForm = class(TForm)
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    ComboBox2: TComboBox;
    Label2: TLabel;
    ComboBox3: TComboBox;
    Label5: TLabel;
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure EditComTerminal(ComTerminal: TCustomComTerminal);

implementation

{$R *.DFM}

// show terminal setup dialog
procedure EditComTerminal(ComTerminal: TCustomComTerminal);
begin
  with TComTrmSetForm.Create(nil) do
  begin
    CheckBox1.Checked := ComTerminal.LocalEcho;
    CheckBox2.Checked := ComTerminal.SendLF;
    CheckBox3.Checked := ComTerminal.WrapLines;
    CheckBox4.Checked := ComTerminal.Force7Bit;
    CheckBox5.Checked := ComTerminal.AppendLF;
    ComboBox1.ItemIndex := Integer(ComTerminal.Caret);
    ComboBox2.ItemIndex := Integer(ComTerminal.Emulation);
    Edit1.Text := IntToStr(ComTerminal.Columns);
    Edit2.Text := IntToStr(ComTerminal.Rows);
    ComboBox3.ItemIndex := Integer(ComTerminal.ArrowKeys);
    if ShowModal = mrOK then
    begin
      ComTerminal.LocalEcho := CheckBox1.Checked;
      ComTerminal.SendLF := CheckBox2.Checked;
      ComTerminal.WrapLines := CheckBox3.Checked;
      ComTerminal.Force7Bit := CheckBox4.Checked;
      ComTerminal.AppendLF := CheckBox5.Checked;
      ComTerminal.Caret := TTermCaret(ComboBox1.ItemIndex);
      ComTerminal.Emulation := TTermEmulation(ComboBox2.ItemIndex);
      try
        ComTerminal.Columns := StrToInt(Edit1.Text);
      except
        ComTerminal.Columns := 80;
      end;
      try
        ComTerminal.Rows := StrToInt(Edit2.Text);
      except
        ComTerminal.Rows := 24;
      end;
      ComTerminal.ArrowKeys := TArrowKeys(ComboBox3.ItemIndex);
    end;
    Free;
  end;
end;

end.
