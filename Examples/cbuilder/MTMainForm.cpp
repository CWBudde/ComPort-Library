//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "MTMainForm.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TMainForm *MainForm;
//---------------------------------------------------------------------------
__fastcall TMainForm::TMainForm(TComponent* Owner)
  : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TMainForm::ConnButtonClick(TObject *Sender)
{
  ComTerminal->Connected = !ComTerminal->Connected;
}
//---------------------------------------------------------------------------

void __fastcall TMainForm::ComPortAfterOpen(TObject *Sender)
{
  ConnButton->Caption = "Disconnect";
}
//---------------------------------------------------------------------------

void __fastcall TMainForm::ComPortAfterClose(TObject *Sender)
{
  ConnButton->Caption = "Connect";
}
//---------------------------------------------------------------------------

void __fastcall TMainForm::PortButtonClick(TObject *Sender)
{
  ComPort->ShowSetupDialog();
}
//---------------------------------------------------------------------------

void __fastcall TMainForm::TermButtonClick(TObject *Sender)
{
  ComTerminal->ShowSetupDialog();
}
//---------------------------------------------------------------------------

void __fastcall TMainForm::FontButtonClick(TObject *Sender)
{
  ComTerminal->SelectFont();
}
//---------------------------------------------------------------------------

