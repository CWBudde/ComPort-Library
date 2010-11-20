//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "ComMainForm.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
  : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Button_OpenClick(TObject *Sender)
{
  if (ComPort->Connected)
    ComPort->Close();
  else
    ComPort->Open();
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Button_SettingsClick(TObject *Sender)
{
  ComPort->ShowSetupDialog();
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Button_SendClick(TObject *Sender)
{
  AnsiString Str;

  Str = Edit_Data->Text;
  if (NewLine_CB->Checked)
    Str = Str + "\r\n";
  ComPort->WriteStr(Str);
}
//---------------------------------------------------------------------------

void __fastcall TForm1::ComPortOpen(TObject *Sender)
{
  Button_Open->Caption = "Close";
}
//---------------------------------------------------------------------------

void __fastcall TForm1::ComPortClose(TObject *Sender)
{
  Button_Open->Caption = "Open";
}
//---------------------------------------------------------------------------

void __fastcall TForm1::ComPortRxChar(TObject *Sender, int Count)
{
  AnsiString Str;

  ComPort->ReadStr(Str, Count);
  Memo->Text = Memo->Text + Str;
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Bt_LoadClick(TObject *Sender)
{
  ComPort->LoadSettings(stRegistry, "HKEY_LOCAL_MACHINE\Software\Dejan");
//  ComPort->LoadSettings(stIniFile, "e:\test.ini");
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Bt_StoreClick(TObject *Sender)
{
  ComPort->StoreSettings(stRegistry, "HKEY_LOCAL_MACHINE\Software\Dejan");
//  ComPort->StoreSettings(stIniFile, "e:\test.ini");
}
//---------------------------------------------------------------------------

