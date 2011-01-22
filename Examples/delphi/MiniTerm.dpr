program MiniTerm;

uses
  Forms,
  MTMainForm in 'MTMainForm.pas' {MainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Mini Terminal';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
