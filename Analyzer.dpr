program Analyzer;

uses
  Forms,
  AnalyzerU in 'AnalyzerU.pas' {AForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'SONY VAIO 0x57 Analyzer';
  Application.CreateForm(TAForm, AForm);
  Application.Run;
end.
