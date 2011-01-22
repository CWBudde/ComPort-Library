//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("CportLibCB5.res");
USEPACKAGE("vcl50.bpi");
USEUNIT("CPort.pas");
USEUNIT("CPortSetup.pas");
USEUNIT("CPortCtl.pas");
USEUNIT("CPortEsc.pas");
USEUNIT("CPortTrmSet.pas");
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
