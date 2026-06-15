program FooterDemo;

// Demonstration project for the TVirtualStringTree footer band (Tree.Footer).
// Shows per-column footer cells (totals) aligned to the header columns, the footer options
// (visible / hot-track / cell borders / owner-draw), the OnFooterClick event and an
// owner-drawn footer cell via OnFooterDrawQueryElements + OnAdvancedFooterDraw.

uses
  Vcl.Forms,
  Main in 'Main.pas' {MainForm},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows Modern');
  Application.Title := 'Virtual Treeview Footer Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
