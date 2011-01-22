//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("MiniTermCB5.res");
USEFORM("MTMainForm.cpp", MainForm);
//---------------------------------------------------------------------------
WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int)
{
  try
  {
    Application->Initialize();
    Application->CreateForm(__classid(TMainForm), &MainForm);
    Application->Run();
  }
  catch (Exception &exception)
  {
    Application->ShowException(&exception);
  }
  return 0;
}
//---------------------------------------------------------------------------
