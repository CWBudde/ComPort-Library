# ComPort Library

The ComPort Library contains code to access COM Ports. Originally, the COM port was the name of the serial port interface of IBM-PC compatible computers.
While nowadays COM ports get less important for communication in favor for USB access, it is still in use as virtual ports, especially as simple communication protocol for maker boards.

This library is a fork of the original ComPort Library 4.10, which can found here:  https://sourceforge.net/projects/comport/

As it is a fork, some of the original commit messages are still accessible.

The master branch is focused on Delphi and all CBuilder support has been removed. However, the old CBuilder code is still accessible in the [LegacyCBuilderSupport branch](../../tree/LegacyCBuilderSupport/)

## Requirements

**Delphi:** 7, 2005, 2006, 2007, 2010, XE, XE2, XE3, XE4, XE5, XE6, XE7, XE8, RS10, RS10.1, RS10.2, RS10.3

## Authors

**Original Author:** Dejan Crnila 1998-2002 (dejancrn@yahoo.com)

**Former Maintainers:** Lars Dybdahl (Lars@dybdahl.dk), Paul Doland (cport@pauld.ml1.net), Brian Gochnauer (brian@gochanuer.net)

## Package names

| Delphi Version | Run-Time | Design-Time | State |
|---|---|---|---|
| Delphi 7 | .\Packages\D7\CPortLib7.dpk | .\Packages\D7\DsgnCPort7.dpk | not sufficiently tested |
| Delphi 8 | .\Packages\D8\CPortLib8.dpk | .\Packages\D8\DsgnCPort8.dpk | not sufficiently tested |
| Delphi 2005 | .\Packages\D2005\CPortLib2005.dpk | .\Packages\D2005\DsgnCPort2005.dpk | not sufficiently tested |
| Delphi 2006 | .\Packages\D2006\CPortLib2006.dpk | .\Packages\D2006\DsgnCPort2006.dpk | not sufficiently tested |
| Delphi 2007 | .\Packages\D2007\CPort_R.dpk | .\Packages\D2007\CPort_D.dpk | not sufficiently tested |
| Delphi 2009 | .\Packages\D2009\CPort_R.dpk | .\Packages\D2009\CPort_D.dpk | not sufficiently tested |
| Delphi 2010 | .\Packages\D2010\CPort_R.dpk | .\Packages\D2010\CPort_D.dpk | should work |
| Delphi XE | .\Packages\XE\CPort_R.dpk | .\Packages\XE\CPort_D.dpk | should work |
| Delphi XE2 | .\Packages\XE2\CPort_R.dpk | .\Packages\XE2\CPort_D.dpk | tested |
| Delphi XE3 | .\Packages\XE3\CPort_R.dpk | .\Packages\XE3\CPort_D.dpk | should work |
| Delphi XE4 | .\Packages\XE4\CPort_R.dpk | .\Packages\XE4\.dpk | should work |
| Delphi XE5 | .\Packages\XE5\CPort_R.dpk | .\Packages\XE5\CPort_D.dpk | should work |
| Delphi XE6 | .\Packages\XE6\CPort_R.dpk | .\Packages\XE6\CPort_D.dpk | should work |
| Delphi XE7 | .\Packages\XE7\CPort_R.dpk | .\Packages\XE7\CPort_D.dpk | tested |
| Delphi XE8 | .\Packages\XE8\CPort_R.dpk | .\Packages\XE8\CPort_D.dpk | should work |
| Delphi RS 10 | .\Packages\10S\CPort_R.dpk | .\Packages\10S\CPort_D.dpk | should work |
| Delphi RS 10.1 | .\Packages\101B\CPort_R.dpk | .\Packages\101B\CPort_D.dpk | should work |
| Delphi RS 10.2 | .\Packages\102T\CPort_R.dpk | .\Packages\102T\CPort_D.dpk | tested |
| Delphi RS 10.3 | .\Packages\103R\CPort_R.dpk | .\Packages\103R\CPort_D.dpk | should work |



## Installation

Remove all previously installed files of ComPort Library (TComPort component). Create a new folder under Delphi directory and extract sources zip file into new folder. Add to the Library Path the new ComPort folder (Tools-Environment Options-Library-Library Path).

#### For Delphi 2006:

Use the instructions below for all other Delphi versions. I recommend installing CPort while running Delphi 2006 in the "all personalities" mode of Delphi, rather than in the Delphi only personality. That helps make sure CPort gets installed dual-mode.

Use "File/Open" menu item in Delphi IDE to open ComPort run-time package source file (see above). Click "Compile" button in Package window to compile the library. Now move run-time package library file or files (see above) from ComPort folder to a folder that is accessible through the search PATH (e.g. Windows\System32).

Now you have to install design-time package. Use File/Open menu item to open design-time package source file (see above). Click "Compile" button in Package window to compile the package and "Install" button to register ComPort into the IDE. ComPort components appear in "CPortLib" page of component pallete.  If it complains that it can't install it because it can't find a library, you probably did not put the run-time package in the search path. You might not get this error until the next time you try to start Delphi.

Note: Do not save packages under Delphi IDE.

## Examples

  ComExample.dpr - shows some basic send-recieve features

  ModTest.dpr - modem test console application

  MiniTerm.dpr - simple terminal application

  CPortMonitor.pas - TCPortMonitor component for monitoring incoming and  outgoing data. This example shows how to link to TCustomComPort component. Author: Roelof Y. Ensing (e-mail: ensingroel@msn.com).

  BarCodeScanner.pas - TBarCodeScanner component. An example of simple TCustomComPort descendant. 


## Installing help file (not available for Delphi2005)
In Delphi, go to the Help menu, customize item. You should be presented with a tabbed notebook, "Contents" tab selected. Click the + (Add Files)  button. Browse to the CPort directory. Select CPort.toc. 

Click on the "Index" tab. Click Add Files. Select CPort.hlp. Click on the "Link" tab. Click Add Files. Select CPort.hlp. Select File Menu/Save Project Item. Exit program. Note that Borland's OpenHelp utility does not prompt you if you close the program and forget to save your changes, so you must remember to do so yourself. 


## Known problems and issues
  1.) OnRxBuf event handler problem in Delphi IDE

     If user double clicks on OnRxBuf event in Delphi IDE, message pops up
     saying: "Property and Method ComPort1RxBuf are not compatible".
     This is a Delphi IDE bug, since it can't handle untyped parameters
     like Buffer parameter of OnRxBuf event.
      
     Solution: Application has to assign OnRxBuf handler manually in code.    

  2.) No integrated help for Delphi 2005 or 2006.

     Solution:  Manually open .HLP file with Windows Help.