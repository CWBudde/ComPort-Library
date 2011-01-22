//-------------------------------------------------------------
#ifndef MTMainFormH
#define MTMainFormH
//-------------------------------------------------------------
#include <ExtCtrls.hpp>
#include <CPortCtl.hpp>
#include <StdCtrls.hpp>
#include <CPort.hpp>
#include <Dialogs.hpp>
#include <Forms.hpp>
#include <Controls.hpp>
#include <Graphics.hpp>
#include <Classes.hpp>
#include <SysUtils.hpp>
#include <Messages.hpp>
#include <Windows.hpp>
#include <SysInit.hpp>
#include <System.hpp>
//-------------------------------------------------------------
class TMainForm : public TForm 
{
__published:	// IDE-managed Components
	TPanel* Panel;
	TComTerminal* ComTerminal;
	TButton* ConnButton;
	TComPort* ComPort;
	TButton* PortButton;
	TButton* TermButton;
	TButton* FontButton;
	TComLed* TerminalReady;
	TLabel* Label1;
	TLabel* Label2;
	TComLed* ComLed1;
  void __fastcall ConnButtonClick(TObject *Sender);
  void __fastcall ComPortAfterOpen(TObject *Sender);
  void __fastcall ComPortAfterClose(TObject *Sender);
  void __fastcall PortButtonClick(TObject *Sender);
  void __fastcall TermButtonClick(TObject *Sender);
  void __fastcall FontButtonClick(TObject *Sender);
private:	// User declarations
public:		// User declarations
	__fastcall TMainForm(TComponent* AOwner);
};
//-------------------------------------------------------------
extern PACKAGE TMainForm *MainForm;
//-------------------------------------------------------------
#endif
