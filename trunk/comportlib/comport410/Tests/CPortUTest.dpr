program CPortUTest;

uses
  Forms,
  CPortUTestMainFm in 'CPortUTestMainFm.pas' {CPortUTestMainForm};

{$R *.res}

begin
  Application.Initialize;
//  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TCPortUTestMainForm, CPortUTestMainForm);
  Application.Run;
end.
