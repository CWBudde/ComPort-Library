(******************************************************
 * ComPort Library ver. 3.0                           *
 *   for Delphi 3, 4, 5, 6, 7 and                     *
 *   C++ Builder 3, 4, 5, 6                           *
 * written by Dejan Crnila, 1998 - 2002               *
 * maintained by Lars B. Dybdahl, 2003                *
 * Homepage: http://comport.sf.net/                   *
 *****************************************************)

unit CPortAbout;

{$I CPort.inc}

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  // ComPort Library about box
  TAboutBox = class(TForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Version: TLabel;
    Copyright: TLabel;
    OKButton: TButton;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

// show about box
procedure ShowAbout;

const
  CPortLibraryVersion = '4.11';

implementation

{$R *.DFM}

procedure ShowAbout;
begin
  with TAboutBox.Create(nil) do
  begin
    ShowModal;
    Free;
  end;
end;

procedure TAboutBox.FormCreate(Sender: TObject);
begin
  Version.Caption := 'version ' + CPortLibraryVersion;
end;

end.

