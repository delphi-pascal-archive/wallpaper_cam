program wallpapcamer;

uses
  Forms,
  wallpapcam in 'wallpapcam.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'wallpapcam';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
