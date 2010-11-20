//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("DsgnCPortCB3.res");
USEPACKAGE("vcl35.bpi");
USEPACKAGE("CPortLibCB3.bpi");
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
