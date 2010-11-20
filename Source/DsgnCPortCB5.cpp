//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("DsgnCPortCB5.res");
USEPACKAGE("vcl50.bpi");
USEPACKAGE("CportLibCB5.bpi");
USEUNIT("CPortReg.pas");
USEFORMNS("CPortAbout.pas", Cportabout, AboutBox);
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------

//   Package source.
//---------------------------------------------------------------------------

#pragma argsused
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
        return 1;
}
//---------------------------------------------------------------------------
