//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("CPortLibCB4.res");
USEPACKAGE("vcl40.bpi");
USEUNIT("Cport.pas");
USEUNIT("CportCtl.pas");
USEUNIT("CPortSetup.pas");
USEUNIT("CPortEsc.pas");
USEUNIT("CPortTrmSet.pas");
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------
//   Package source.
//---------------------------------------------------------------------------
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
  return 1;
}
//---------------------------------------------------------------------------
