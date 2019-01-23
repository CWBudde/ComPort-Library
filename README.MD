# ComPort Library

The ComPort Library contains code to access COM Ports. Originally, the COM port was the name of the serial port interface of IBM-PC compatible computers.
While nowadays COM ports get less important for communication in favor for USB access, it is still in use as virtual ports, especially as simple communication protocol for maker boards.

This library is a fork of the original ComPort Library 4.10, which can found here:  https://sourceforge.net/projects/comport/

As it is a fork, some of the original commit messages are still accessible.

## Requirements

**Delphi:** (3, 4, 5, 6,) 7, 2005, 2006, 2007, 2010, XE, XE2, XE3, XE4, XE5, XE6, XE7, XE8, RS10, RS10.1, RS10.2, RS10.3

**C++ Builder:** 3, 4, 5, 6 (not actively supported)

## Authors

**Original Author:** Dejan Crnila 1998-2002 (dejancrn@yahoo.com)

**Former Maintainers:** Lars Dybdahl (Lars@dybdahl.dk), Paul Doland (cport@pauld.ml1.net), Brian Gochnauer (brian@gochanuer.net)

## Package names

| Delphi Version | Design-Time | Run-Time | State |
|---|---|---|---|
| Delphi 3 | .\Packages\D3\DsgnCPort3.dpk | .\Packages\D3\CPortLib3.dpk | not officially supported |
| Delphi 4 | .\Packages\D4\DsgnCPort4.dpk | .\Packages\D4\CPortLib4.dpk | not officially supported |
| Delphi 5 | .\Packages\D5\DsgnCPort5.dpk | .\Packages\D5\CPortLib5.dpk | not officially supported |
| Delphi 6 | .\Packages\D6\DsgnCPort6.dpk | .\Packages\D6\CPortLib6.dpk | not officially supported |
| Delphi 7 | .\Packages\D7\DsgnCPort7.dpk | .\Packages\D7\CPortLib7.dpk | not sufficiently tested |
| Delphi 8 | .\Packages\D8\DsgnCPort8.dpk | .\Packages\D8\CPortLib8.dpk | not sufficiently tested |
| Delphi 2005 | .\Packages\D2005\DsgnCPort2005.dpk | .\Packages\D2005\CPortLib2005.dpk | not sufficiently tested |
| Delphi 2006 | .\Packages\D2006\DsgnCPort2006.dpk | .\Packages\D2006\CPortLib2006.dpk | not sufficiently tested |
| Delphi 2007 | .\Packages\D2007\DsgnCPort2007.dpk | .\Packages\D2007\CPortLib2007.dpk | not sufficiently tested |
| Delphi 2009 | .\Packages\D2009\DsgnCPort2009.dpk | .\Packages\D2009\CPortLib2009.dpk | not sufficiently tested |
| Delphi 2010 | .\Packages\2010\CPort_R.dpk | .\Packages\2010\CPort_D.dpk | should work |
| Delphi XE | .\Packages\XE\CPort_R.dpk | .\Packages\XE\CPort_D.dpk | should work |
| Delphi XE2 | .\Packages\XE2\CPort_R.dpk | .\Packages\XE2\CPort_D.dpk | tested |
| Delphi XE3 | .\Packages\XE3\CPort_R.dpk | .\Packages\XE3\CPort_D.dpk | should work |
| Delphi XE4 | .\Packages\XE4\CPort_R.dpk | .\Packages\XE4\.dpk | should work |
| Delphi XE5 | .\Packages\XE5\CPort_R.dpk | .\Packages\XE5\CPort_D.dpk | should work |
| Delphi XE6 | .\Packages\XE6\CPort_R.dpk | .\Packages\XE6\CPort_D.dpk | should work |
| Delphi XE7 | .\Packages\XE7\CPort_R.dpk | .\Packages\XE7\CPort_D.dpk | tested |
| Delphi XE8 | .\Packages\XE8\CPort_R.dpk | .\Packages\XE8\CPort_D.dpk | should work |
| Delphi RS 10 | .\Packages\10S\CPort_R.dpk | .\Packages\10S\CPort_D.dpk | should work |
| Delphi RS 10.1 | .\Packages\101B\CPort_R.dpk | .\Packages\101B\CPort_D.dpk | tested |
| Delphi RS 10.2 | .\Packages\102T\CPort_R.dpk | .\Packages\102T\CPort_D.dpk | tested |
| Delphi RS 10.3 | .\Packages\103R\CPort_R.dpk | .\Packages\103R\CPort_D.dpk | tested |
| C++ Builder 3 | .\Packages\CB3\DsgnCPortCB3.bpk | .\Packages\CB3\CPortLibCB3.bpk | not officially supported |
| C++ Builder 4 | .\Packages\CB4\DsgnCPortCB4.bpk | .\Packages\CB4\CPortLibCB4.bpk | not officially supported |
| C++ Builder 5 | .\Packages\CB5\DsgnCPortCB5.bpk | .\Packages\CB5\CPortLibCB5.bpk | not officially supported |
| C++ Builder 6 | .\Packages\CB6\DsgnCPortCB6.bpk | .\Packages\CB6\CPortLibCB6.bpk | not officially supported |



## Installation

Remove all previously installed files of ComPort Library (TComPort component). Create a new folder under Delphi directory and extract sources zip file into new folder. Add to the Library Path the new ComPort folder (Tools-Environment Options-Library-Library Path).

#### For Delphi 2006:

Use the instructions below for all other Delphi versions.  But, note that Delphi 2006 supports both Delphi and C++ Builder. I recommend installing CPort while running Delphi 2006 in the "all personalities" mode of Delphi, rather than in the Delphi only personality. That helps make sure CPort gets installed dual-mode, with both Delphi and C++ Builder support.  Note that for some reason, I find the .LIB files get stored into the CPort directory instead of the $BDSPROJECTS/BPL directory.  So, after you install CPort, double check to make sure the .LIB files are in the right spot.  

Finally, the .HPP files also get stored in the  CPort directory. Either move them to a folder already in the C++ source path, or add the CPort directory to the C++ source path.

Otherwise, follow the directions below, and also read the C++ Builder notes:

For Delphi 3, 4, 5, 6, 7, 2005 & C++ Builder 4, 5, 6: Delphi version earlier than version 5 have not been tested recently. (C++ Builder users also need to read the C++ Builder notes)

Use "File/Open" menu item in Delphi/C++ Builder IDE to open ComPort run-time package source file (see above). Click "Compile" button in Package window to compile the library. Now move run-time package library file or files (see above) from ComPort folder to a folder that is accessible through the search PATH (e.g. WinNT\System32).

Now you have to install design-time package. Use File/Open menu item to open design-time package source file (see above). Click "Compile" button in Package window to compile the package and "Install" button to register ComPort into the IDE. ComPort components appear in "CPortLib" page of component pallete.  If it complains that it can't install it because it can't find a library, you probably did not put the run-time package in the search path. You might not get this error until the next time you try to start Delphi/C++ Builder.

Note: Do not save packages under Delphi/C++ Builder IDE.

#### For C++ Builder 3
(C++ Builder users also need to read the C++ Builder notes)

C++ Builder 3 does not have a "Package window" like the other products. So, installation is slightly different.

Use "File/Open" menu item in Delphi/C++ Builder IDE to open ComPort run-time package source file (see above). Compile the package from the project menu or Ctrl-F9. Now move run-time package library files (see above) from ComPort folder to a folder that is accessible through the search PATH (e.g. WinNT\System32).

Now you have to install design-time package. Use File/Open menu item to open design-time package source file (see above). Compile the package from the project menu or Ctrl-F9. To install the package into the IDE, go to the Component menu, "Install Packages" option. Click the Add button.  Browse to the design-time library and select it. If it complains that it can't install it because it can't find a library, you probably did not put the run-time package in the search path as described above.

## Examples

  ComExample.dpr,
  ComExampleCB*.bpr  - shows some basic send-recieve features

  ModTest.dpr        - modem test console application

  MiniTerm.dpr,
  MiniTermCB*.bpr    - simple terminal application

  CPortMonitor.pas   - TCPortMonitor component for monitoring incoming and 
                       outgoing data. This example shows how to link to 
                       TCustomComPort component. Author: Roelof Y. Ensing 
                       (e-mail: ensingroel@msn.com).

  BarCodeScanner.pas - TBarCodeScanner component. An example of simple 
                       TCustomComPort descendant. 


## C++ Builder Notes
The .hpp file C++ Builder creates for cport.pas will have a bug in it. The first time you compile a project, you will get one or two duplicate  definitions within the EComPort exception class.  It seems to be safe to delete or comment out the duplicates.

Also, the CPortCtl.HPP may have a bug in it.  If you get an error about the following being ambiguous;

    typedef TBitmap TLedBitmap;

Change it to:

    typedef Graphics::TBitmap TLedBitmap;

If someone knows how to fix these more cleanly, please post what you find to the CPort Forum so that we can incorporate your findings in future revisions.


## Installing help file (not available for Delphi2005)
In Delphi/C++ Builder, go to the Help menu, customize item. You should be presented with a tabbed notebook, "Contents" tab selected. Click the + (Add Files)  button. Browse to the CPort directory. Select CPort.toc. 

Click on the "Index" tab. Click Add Files. Select CPort.hlp. Click on the "Link" tab. Click Add Files. Select CPort.hlp. Select File Menu/Save Project Item. Exit program. Note that Borland's OpenHelp utility does not prompt you if you close the program and forget to save your changes, so you must remember to do so yourself. 


## Known problems and issues
  1.) OnRxBuf event handler problem in Delphi IDE

     If user double clicks on OnRxBuf event in Delphi IDE, message pops up
     saying: "Property and Method ComPort1RxBuf are not compatible".
     This is a Delphi IDE bug, since it can't handle untyped parameters
     like Buffer parameter of OnRxBuf event.
      
     Solution: Application has to assign OnRxBuf handler manually in code.    

  2.) Two serial ports sharing the same IRQ address

    Some users of Windows 95/98 have reported that application can't have two TComPort components open simultaneouslly if serial ports share the same IRQ address. This usually COM1/COM3 and COM2/COM4.
    
    Solution: Not known yet.

  3.) No integrated help for Delphi 2005 or 2006.

     Solution:  Manually open .HLP file with Windows Help.