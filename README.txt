+-------------------------------------------------+
| ComPort Library version 4.10                    |
| for Delphi 5, 6, 7, 2005, 2006, 2007, 2010, XE  |
| and C++ Builder 3, 4, 5, 6                      |
|                                                 |
| by Dejan Crnila 1998-2002                       |
| maintained by Lars Dybdahl and Paul Doland      |
| maintained by Brian Gochnauer Nov 2010          |
+-------------------------------------------------+

Contents
1. Author information
2. Support
3. Files in archive
4. Examples
5. Package names
6. Installing ComPort Library
7. C++ Builder notes
8. Installing help file
9. Known problems and issues


1. Author information
---------------------------------------------------------------------------------
Name: Dejan Crnila
E-mail: dejancrn@yahoo.com
Year of birth: 1978
Occupation: Student of computer science at University of Ljubljana


Current maintainers
------------------
Name: Lars B. Dybdahl
E-mail: Lars@dybdahl.dk
Homepage: http://dybdahl.dk/lars/
Year of birth: 1971
Occupation: Freelance programmer

Paul Doland
E-mail: cport@pauld.ml1.net

Brian Gochnauer
email:brian@gochanuer.net

2. Support
--------------------------------------------------------------------------------
If you have any questions, suggestions, opinion or any other messages, please
visit the sourceforge forums.


3. Files in archive
--------------------------------------------------------------------------------
  ReadMe.Txt      - this file
  Sources.zip     - ComPort Library sources
  Help.zip        - Delphi context-sensitive help file for library
  Examples.zip    - Example projects for Delphi & C++ Builder


4. Examples
--------------------------------------------------------------------------------
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


5. Package names
--------------------------------------------------------------------------------
		Design-Time Source	Run-Time Source
                ----------------	---------------
Delphi 3	DsgnCPort3.dpk		CPortLib3.dpk
Delphi 4	DsgnCPort4.dpk		CPortLib4.dpk
Delphi 5	DsgnCPort5.dpk		CPortLib5.dpk
Delphi 6	DsgnCPort6.dpk		CPortLib6.dpk
Delphi 7	DsgnCPort7.dpk		CPortLib7.dpk
Delphi 8	DsgnCPort8.dpk		CPortLib8.dpk
Delphi 2005	DsgnCPortD2005.dpk	CPortLibD2005.dpk
Delphi 2006	DsgnCPortD2006.dpk	CPortLibD2006.dpk
Delphi 2007	DsgnCPortD2007.dpk	CPortLibD2007.dpk
Delphi 2008	DsgnCPortD2008.dpk	CPortLibD2008.dpk
Delphi 2009	DsgnCPortD2009.dpk	CPortLibD2009.dpk
Delphi XE	DsgnCPortDXE.dpk	CPortLibDXE.dpk
C++ Builder 3	DsgnCPortCB3.bpk	CPortLibCB3.bpk
C++ Builder 4	DsgnCPortCB4.bpk	CPortLibCB4.bpk
C++ Builder 5	DsgnCPortCB5.bpk	CPortLibCB5.bpk
C++ Builder 6	DsgnCPortCB6.bpk	CPortLibCB6.bpk



6. Installation
--------------------------------------------------------------------------------
Remove all previously installed files of ComPort Library (TComPort
component). Create a new folder under Delphi directory and extract 
Sources zip file into new folder. Add to the Library Path the new 
ComPort folder (Tools-Environment Options-Library-Library Path).

For Delphi 2006:  

Use the instructions below for all other Delphi
versions.  But, note that Delphi 2006 supports both Delphi and
C++ Builder.  I recommend installing CPort while running Delphi 2006
in the "all personalities" mode of Delphi, rather than in the Delphi
only personality.  That helps make sure CPort gets installed dual-mode,
with both Delphi and C++ Builder support.  Note that for some reason,
I find the .LIB files get stored into the CPort directory instead of
the $BDSPROJECTS/BPL directory.  So, after you install CPort, double
check to make sure the .LIB files are in the right spot.  

Finally, the .HPP files also get stored in the  CPort directory. Either
move them to a folder already in the C++ source path, or add the CPort 
directory to the C++ source path.

Otherwise, follow the directions below, and also read the C++ Builder
notes:

For Delphi 3, 4, 5, 6, 7, 2005 & C++ Builder 4, 5, 6:
Delphi version earlier than version 5 have not been tested recently.
(C++ Builder users also need to read the C++ Builder notes)

Use "File/Open" menu item in Delphi/C++ Builder IDE to open 
ComPort run-time package source file (see above). Click "Compile" 
button in Package window to compile the library. Now move run-time
package library file or files (see above) from ComPort folder to a
folder that is accessible through the search PATH (e.g. WinNT\System32).

Now you have to install design-time package. Use File/Open menu item
to open design-time package source file (see above). Click "Compile" 
button in Package window to compile the package and "Install" button
to register ComPort into the IDE. ComPort components appear in 
"CPortLib" page of component pallete.  If it complains that it 
can't install it because it can't find a library, you probably
did not put the run-time package in the search path. You might
not get this error until the next time you try to start
Delphi/C++ Builder.

Note: Do not save packages under Delphi/C++ Builder IDE.

For C++ Builder 3
(C++ Builder users also need to read the C++ Builder notes)

C++ Builder 3 does not have a "Package window" like the other products.
So, installation is slightly different.

Use "File/Open" menu item in Delphi/C++ Builder IDE to open 
ComPort run-time package source file (see above). Compile the
package from the project menu or Ctrl-F9. Now move run-time
package library files (see above) from ComPort folder to a folder
that is accessible through the search PATH (e.g. WinNT\System32).

Now you have to install design-time package. Use File/Open menu item
to open design-time package source file (see above).  Compile the
package from the project menu or Ctrl-F9.  To install the package
into the IDE, go to the Component menu, "Install Packages" option.
Click the Add button.  Browse to the design-time library and select
it.  If it complains that it can't install it because it can't find
a library, you probably did not put the run-time package in the
search path as described above.

Note about Delphi 2:

Note: Delphi 2 is no longer suported, however, with some minor changes, 
it should compile under Delphi 2 as well.

Use "Component/Install" menu item to add "CPortReg.pas" unit to the 
component library. This unit registers ComPort components on 
"CPortLib" page of component pallete.


7. C++ Builder Notes
------------------------------------------------------------------------------
The .hpp file C++ Builder creates for cport.pas will have a bug in it.
The first time you compile a project, you will get one or two duplicate 
definitions within the EComPort exception class.  It seems to be safe to
delete or comment out the duplicates.

Also, the CPortCtl.HPP may have a bug in it.  If you get an error about
the following being ambiguous;

typedef TBitmap TLedBitmap;

Change it to:

typedef Graphics::TBitmap TLedBitmap;

If someone knows how to fix these more cleanly, please post what you
find to the CPort Forum so that we can incorporate your findings in
future revisions.


8. Installing help file (not available for Delphi2005)
------------------------------------------------------------------------------
In Delphi/C++ Builder, go to the Help menu, customize item. You should be 
presented with a tabbed notebook, "Contents" tab selected. Click the + (Add Files) 
button. Browse to the CPort directory. Select CPort.toc. 

Click on the "Index" tab. Click Add Files. Select CPort.hlp. Click on the 
"Link" tab. Click Add Files. Select CPort.hlp. Select File Menu/Save Project 
Item. Exit program. Note that Borland's OpenHelp utility does not prompt you 
if you close the program and forget to save your changes, so you must remember 
to do so yourself. 


9. Known problems and issues
-----------------------------------------------------------------------------
  1.) OnRxBuf event handler problem in Delphi IDE

      If user double clicks on OnRxBuf event in Delphi IDE, message pops up
      saying: "Property and Method ComPort1RxBuf are not compatible".
      This is a Delphi IDE bug, since it can't handle untyped parameters
      like Buffer parameter of OnRxBuf event.

      Solution: Application has to assign OnRxBuf handler manually in code.    

  2.) Two serial ports sharing the same IRQ address

      Some users of Windows 95/98 have reported that application can't have
      two TComPort components open simultaneouslly if serial ports share the
      same IRQ address. This usually COM1/COM3 and COM2/COM4.

      Solution: Not known yet.

  3.) No integrated help for Delphi 2005 or 2006.

      Solution:  Manually open .HLP file with Windows Help.
