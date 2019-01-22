//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("DsgnCPortCB4.res");
USEPACKAGE("vcl40.bpi");
USEPACKAGE("CPortLibCB4.bpi");
USEUNIT("CPortReg.pas");
USEUNIT("CPortAbout.pas");
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
