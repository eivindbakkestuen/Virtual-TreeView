object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Virtual Treeview - Footer demo'
  ClientHeight = 460
  ClientWidth = 812
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 812
    Height = 96
    Align = alTop
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 0
    object lblHint: TLabel
      Left = 12
      Top = 10
      Width = 364
      Height = 13
      Caption = 
        'Tree.Footer shows one cell per column, aligned to the header col' +
        'umns.'
    end
    object lblClick: TLabel
      Left = 12
      Top = 66
      Width = 111
      Height = 13
      Caption = 'Footer clicked: (none)'
    end
    object chkVisible: TCheckBox
      Left = 12
      Top = 36
      Width = 110
      Height = 17
      Caption = 'Footer visible'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = OptionClick
    end
    object chkHotTrack: TCheckBox
      Tag = 1
      Left = 128
      Top = 36
      Width = 90
      Height = 17
      Caption = 'Hot track'
      TabOrder = 1
      OnClick = OptionClick
    end
    object chkBorders: TCheckBox
      Tag = 2
      Left = 224
      Top = 36
      Width = 100
      Height = 17
      Caption = 'Cell borders'
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnClick = OptionClick
    end
    object chkOwnerDraw: TCheckBox
      Tag = 3
      Left = 330
      Top = 36
      Width = 150
      Height = 17
      Caption = 'Owner-draw Total cell'
      TabOrder = 3
      OnClick = OptionClick
    end
  end
  object VST: TVirtualStringTree
    AlignWithMargins = True
    Left = 8
    Top = 104
    Width = 796
    Height = 348
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 8
    Align = alClient
    Colors.BorderColor = clLime
    Colors.DisabledColor = clOlive
    Colors.GridLineColor = clMaroon
    Colors.TreeLineColor = clBlue
    Colors.UnfocusedSelectionColor = clRed
    Colors.UnfocusedSelectionBorderColor = clRed
    DefaultNodeHeight = 17
    Header.AutoSizeIndex = -1
    Header.Height = 17
    Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
    Footer.Height = 17
    Footer.Options = [foVisible, foShowButtonBorder]
    TabOrder = 1
    TreeOptions.SelectionOptions = [toFullRowSelect]
    OnAdvancedFooterDraw = VSTAdvancedFooterDraw
    OnFooterClick = VSTFooterClick
    OnFooterDrawQueryElements = VSTFooterDrawQueryElements
    OnGetFooterText = VSTGetFooterText
    OnFreeNode = VSTFreeNode
    OnGetText = VSTGetText
    OnInitNode = VSTInitNode
    Touch.InteractiveGestures = [igPan, igPressAndTap]
    Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
    Columns = <
      item
        Position = 0
        Text = 'Product'
        Width = 240
      end
      item
        Alignment = taRightJustify
        CaptionAlignment = taRightJustify
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 1
        Text = 'Quantity'
        Width = 90
      end
      item
        Alignment = taRightJustify
        CaptionAlignment = taRightJustify
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 2
        Text = 'Unit Price'
        Width = 110
      end
      item
        Alignment = taRightJustify
        CaptionAlignment = taRightJustify
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 3
        Text = 'Total'
        Width = 130
      end>
  end
end
