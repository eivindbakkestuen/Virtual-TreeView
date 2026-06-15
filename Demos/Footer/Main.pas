unit Main;

// Demonstration project for the TVirtualStringTree footer band.
//
// The footer (Tree.Footer) is a band at the bottom of the control that mirrors the header: it shows one cell per
// column, aligned to and horizontally scrolled in sync with the header columns. This demo fills the footer with
// column totals via OnGetFooterText, lets you toggle the footer options at run time, reports footer clicks and
// shows how to owner-draw an individual footer cell.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls,
  VirtualTrees, VirtualTrees.Types, VirtualTrees.Header, VirtualTrees.BaseTree,
  VirtualTrees.BaseAncestorVCL, VirtualTrees.AncestorVCL;

type
  TMainForm = class(TForm)
    pnlTop: TPanel;
    chkVisible: TCheckBox;
    chkHotTrack: TCheckBox;
    chkBorders: TCheckBox;
    chkOwnerDraw: TCheckBox;
    lblClick: TLabel;
    lblHint: TLabel;
    VST: TVirtualStringTree;
    procedure FormCreate(Sender: TObject);
    procedure OptionClick(Sender: TObject);
    procedure VSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType; var CellText: string);
    procedure VSTInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode;
      var InitialStates: TVirtualNodeInitStates);
    procedure VSTFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VSTGetFooterText(Sender: TVTFooter; Column: TColumnIndex; var Text: string);
    procedure VSTFooterClick(Sender: TVTFooter; Column: TColumnIndex; Button: TMouseButton;
      Shift: TShiftState; X, Y: TDimension);
    procedure VSTFooterDrawQueryElements(Sender: TVTFooter; var PaintInfo: TVTFooterPaintInfo;
      var Elements: TVTFooterPaintElements);
    procedure VSTAdvancedFooterDraw(Sender: TVTFooter; var PaintInfo: TVTFooterPaintInfo;
      const Elements: TVTFooterPaintElements);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

const
  // The column indices, named for readability.
  colProduct = 0;
  colQuantity = 1;
  colUnitPrice = 2;
  colTotal = 3;

type
  // Data stored per node.
  PProduct = ^TProduct;
  TProduct = record
    Name: string;
    Quantity: Integer;
    UnitPrice: Double;
  end;

//----------------------------------------------------------------------------------------------------------------------

procedure TMainForm.FormCreate(Sender: TObject);
begin
  VST.NodeDataSize := SizeOf(TProduct);
  VST.RootNodeCount := 30;

  // Footer text two ways. The Product/Quantity/Total cells are filled dynamically by OnGetFooterText
  // (see VSTGetFooterText below). A cell can also be given static text directly on its column - with no
  // event handler at all - via Column.FooterText. We use that here for the Unit Price column, which has
  // no running total. FooterText works at run time and at design time (it streams to the .dfm); when
  // OnGetFooterText is also assigned, the handler receives this text and may override it.
  VST.Header.Columns[colUnitPrice].FooterText := 'n/a';

  // Reflect the design-time footer options in the check boxes.
  chkVisible.Checked := foVisible in VST.Footer.Options;
  chkHotTrack.Checked := foHotTrack in VST.Footer.Options;
  chkBorders.Checked := foShowButtonBorder in VST.Footer.Options;
  chkOwnerDraw.Checked := foOwnerDraw in VST.Footer.Options;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TMainForm.OptionClick(Sender: TObject);
// One shared handler for all four option check boxes; the check box Tag selects the option to toggle.
var
  Option: TVTFooterOption;
  Options: TVTFooterOptions;
begin
  case (Sender as TCheckBox).Tag of
    0: Option := foVisible;
    1: Option := foHotTrack;
    2: Option := foShowButtonBorder;
  else
    Option := foOwnerDraw;
  end;

  Options := VST.Footer.Options;
  if (Sender as TCheckBox).Checked then
    Include(Options, Option)
  else
    Exclude(Options, Option);
  // Assigning Options recalculates the non-client area (when foVisible changes) and repaints the footer.
  VST.Footer.Options := Options;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TMainForm.VSTInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode;
  var InitialStates: TVirtualNodeInitStates);
var
  Data: PProduct;
  Index: Integer;
begin
  Data := Sender.GetNodeData(Node);
  Index := Integer(Node.Index);
  Data.Name := Format('Product %.2d', [Index + 1]);
  Data.Quantity := 1 + (Index mod 9) * 2;
  Data.UnitPrice := 4.5 + (Index mod 7) * 1.25;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TMainForm.VSTFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PProduct;
begin
  Data := Sender.GetNodeData(Node);
  Finalize(Data^);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TMainForm.VSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType; var CellText: string);
var
  Data: PProduct;
begin
  Data := Sender.GetNodeData(Node);
  if not Assigned(Data) then
    Exit;
  case Column of
    colProduct:   CellText := Data.Name;
    colQuantity:  CellText := IntToStr(Data.Quantity);
    colUnitPrice: CellText := Format('%.2f', [Data.UnitPrice]);
    colTotal:     CellText := Format('%.2f', [Data.Quantity * Data.UnitPrice]);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TMainForm.VSTGetFooterText(Sender: TVTFooter; Column: TColumnIndex; var Text: string);
// Provide the footer cell text. Here we aggregate the column values into totals.
var
  Node: PVirtualNode;
  Data: PProduct;
  TotalQuantity: Integer;
  TotalAmount: Double;
begin
  case Column of
    colProduct:
      Text := Format('%d products', [VST.RootNodeCount]);
    colQuantity:
      begin
        TotalQuantity := 0;
        Node := VST.GetFirst;
        while Assigned(Node) do
        begin
          Data := VST.GetNodeData(Node);
          if Assigned(Data) then
            Inc(TotalQuantity, Data.Quantity);
          Node := VST.GetNext(Node);
        end;
        Text := IntToStr(TotalQuantity);
      end;
    colTotal:
      begin
        TotalAmount := 0;
        Node := VST.GetFirst;
        while Assigned(Node) do
        begin
          Data := VST.GetNodeData(Node);
          if Assigned(Data) then
            TotalAmount := TotalAmount + Data.Quantity * Data.UnitPrice;
          Node := VST.GetNext(Node);
        end;
        Text := Format('%.2f', [TotalAmount]);
      end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TMainForm.VSTFooterClick(Sender: TVTFooter; Column: TColumnIndex; Button: TMouseButton;
  Shift: TShiftState; X, Y: TDimension);
begin
  if Column >= 0 then
    lblClick.Caption := Format('Footer clicked: column %d (%s)', [Column, VST.Header.Columns[Column].Text])
  else
    lblClick.Caption := 'Footer clicked: outside any column';
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TMainForm.VSTFooterDrawQueryElements(Sender: TVTFooter; var PaintInfo: TVTFooterPaintInfo;
  var Elements: TVTFooterPaintElements);
// Only called when foOwnerDraw is set. We ask to draw the background of the "Total" cell ourselves; the tree still
// draws the default text on top.
begin
  if Assigned(PaintInfo.Column) and (PaintInfo.Column.Index = colTotal) then
    Elements := [fpeBackground];
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TMainForm.VSTAdvancedFooterDraw(Sender: TVTFooter; var PaintInfo: TVTFooterPaintInfo;
  const Elements: TVTFooterPaintElements);
begin
  if fpeBackground in Elements then
  begin
    // A light green wash behind the grand total. $00E6FFE6 is BGR.
    PaintInfo.TargetCanvas.Brush.Style := bsSolid;
    PaintInfo.TargetCanvas.Brush.Color := $00E6FFE6;
    PaintInfo.TargetCanvas.FillRect(PaintInfo.PaintRectangle);
  end;
end;

end.
