//-------------------------------------------------------------
#ifndef ComMainFormH
#define ComMainFormH
//-------------------------------------------------------------
#include <CPortCtl.hpp>
#include <CPort.hpp>
#include <ExtCtrls.hpp>
#include <StdCtrls.hpp>
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
class TForm1 : public TForm 
{
__published:	// IDE-managed Componets
	TComPort* ComPort;
	TMemo* Memo;
	TButton* Button_Open;
	TButton* Button_Settings;
	TEdit* Edit_Data;
	TButton* Button_Send;
	TCheckBox* NewLine_CB;
	TPanel* Panel1;
	TButton* Bt_Store;
	TButton* Bt_Load;
	TComLed* ComLed1;
	TComLed* ComLed2;
	TComLed* ComLed3;
	TComLed* ComLed4;
	TLabel* Label2;
	TLabel* Label3;
	TLabel* Label4;
	TLabel* Label5;
	TComLed* ComLed5;
	TComLed* ComLed6;
	TLabel* Label1;
	TLabel* Label6;
	void __fastcall Button_OpenClick(TObject* Sender);
	void __fastcall Button_SettingsClick(TObject* Sender);
	void __fastcall Button_SendClick(TObject* Sender);
	void __fastcall ComPortOpen(TObject* Sender);
	void __fastcall ComPortClose(TObject* Sender);
	void __fastcall ComPortRxChar(TObject* Sender, int Count);
	void __fastcall Bt_LoadClick(TObject* Sender);
	void __fastcall Bt_StoreClick(TObject* Sender);
private:	// User declarations
public:		// User declarations
	__fastcall TForm1(TComponent* AOwner);
};
//-------------------------------------------------------------
extern PACKAGE TForm1* Form1;
//-------------------------------------------------------------
#endif
