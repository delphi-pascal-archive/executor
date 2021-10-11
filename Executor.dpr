program Executor;

uses
  Forms,
  NP in 'NP.pas' {MainForm},
  PP in 'PP.pas' {SettingsForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Executor';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TSettingsForm, SettingsForm);
  Application.Run;
end.
