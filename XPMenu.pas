unit XPMenu;

interface

uses Windows, SysUtils, Classes, Messages, Graphics, ImgList, Menus,
     Forms, Controls, Commctrl;

type
  TRyMenu = class(TObject)
  private
    FFont: TFont;
    FGutterColor: TColor;
    FMenuColor: TColor;
    FSelectedColor: TColor;
    FSelLightColor: TColor;
    FMinWidth: Integer;       
    FMinHeight: Integer;
    procedure SetFont(const Value: TFont);
    procedure SetSelectedColor(const Value: TColor);
    procedure SetMinHeight(const Value: Integer);
  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(Menu: TMenu; Item: TMenuItem);
    procedure MeasureItem(Sender: TObject; ACanvas: TCanvas;
              var Width, Height: Integer);
    procedure AdvancedDrawItem(Sender: TObject; ACanvas: TCanvas;
              ARect: TRect; State: TOwnerDrawState);
  public
    property  MenuColor: TColor read FMenuColor write FMenuColor;
    property  GutterColor: TColor read FGutterColor write FGutterColor;
    property  SelectedColor: TColor read FSelectedColor write SetSelectedColor;
    property  Font: TFont read FFont write SetFont;
    property  MinHeight: Integer read FMinHeight write SetMinHeight;
    property  MinWidth: Integer read FMinWidth write FMinWidth;
  end;

var
  RyMenu: TRyMenu;

implementation

{$IFDEF RY}
uses RyUtils, RyClassesUtils;
{$ELSE}
type
  TRGB = packed record
    R, G, B: Byte;
  end;
{$ENDIF RY}

var
{$IFNDEF RY}
  FMonoBitmap : TBitmap;
{$ENDIF RY}
  BmpCheck: array[Boolean] of TBitmap;

{$IFNDEF RY}
function Max(A, B: Integer): Integer;
begin
  if A < B then Result := B
  else Result := A
end;

function GetRGB(const Color: TColor): TRGB;
var
  iColor: TColor;
begin
  iColor := ColorToRGB(Color);
  Result.R := GetRValue(iColor);
  Result.G := GetGValue(iColor);
  Result.B := GetBValue(iColor);
end;

function GetLightColor(const Color: TColor; const Light: Byte) : TColor;
var
  fFrom: TRGB;
begin
  FFrom := GetRGB(Color);

  Result := RGB(
    Round(FFrom.R + (255 - FFrom.R) * (Light / 100)),
    Round(FFrom.G + (255 - FFrom.G) * (Light / 100)),
    Round(FFrom.B + (255 - FFrom.B) * (Light / 100))
  );
end;
{$ENDIF RY}

constructor TRyMenu.Create;
begin
  FGutterColor := clBtnFace;
  FMenuColor := GetLightColor(clBtnFace, 85);
  FSelectedColor := GetLightColor(clHighlight, 65);
  FSelLightColor := GetLightColor(clMoneyGreen, 5);
  FMinWidth := 0;
  FMinHeight:= 21;
  FFont := TFont.Create;
  Font := Screen.MenuFont;
end;

destructor TRyMenu.Destroy;
begin
  FFont.Free;
  inherited;
end;

procedure TRyMenu.Add(Menu: TMenu; Item: TMenuItem);

  procedure InitItem(Item : TMenuItem);
  begin
    Item.OnAdvancedDrawItem := Self.AdvancedDrawItem;
    if not (Item.GetParentComponent is TMainMenu) then
      Item.OnMeasureItem := Self.MeasureItem;
  end;

  procedure InitItems(Item : TMenuItem);
  var
    I: Word;
  begin
    I := 0;
    while I < Item.Count do
    begin
      InitItem(Item[I]);
      if Item[I].Count > 0 then InitItems(Item[I]);
      Inc(I);
    end;
  end;

begin
  if Assigned(Menu) then
  begin
    InitItems(Menu.Items);
    Menu.OwnerDraw := True;
  end;
  if Assigned(Item) then
  begin
    InitItem(Item);
    InitItems(Item);
  end;
end;

procedure TRyMenu.AdvancedDrawItem(Sender: TObject; ACanvas: TCanvas;
          ARect: TRect; State: TOwnerDrawState);

  {$IFNDEF RY}
  procedure GetBmpFromImgList(ABmp: TBitmap; AImgList: TCustomImageList;
            const ImageIndex: Word);
  begin
    with ABmp do
    begin
      Width := AImgList.Width;
      Height := AImgList.Height;
      Canvas.Brush.Color := clWhite;
      Canvas.FillRect(Rect(0, 0, Width, Height));
      ImageList_DrawEx(AImgList.Handle, ImageIndex,
        Canvas.Handle, 0, 0, 0, 0, CLR_DEFAULT, 0, ILD_NORMAL);
    end
  end;

  procedure DoDrawMonoBmp(ACanvas: TCanvas; const AMonoColor: TColor;
            const ALeft, ATop: Integer);
  const
    ROP_DSPDxax = $00E20746;
  begin
    with ACanvas do
    begin
      Brush.Color := AMonoColor;
      Windows.SetTextColor(Handle, clWhite);
      Windows.SetBkColor(Handle, clBlack);
      BitBlt(Handle, ALeft, ATop, FMonoBitmap.Width, FMonoBitmap.Height,
             FMonoBitmap.Canvas.Handle, 0, 0, ROP_DSPDxax);
    end
  end;
  {$ENDIF RY}

const
  _Flags: LongInt = DT_NOCLIP or DT_VCENTER or DT_END_ELLIPSIS or DT_SINGLELINE;
  _FlagsTopLevel: array[Boolean] of Longint = (DT_LEFT, DT_CENTER);
  _FlagsShortCut: Longint = (DT_RIGHT);
  _RectEl: array[Boolean] of Byte = (0, 6);
var
  TopLevel: Boolean;
  Gutter: Integer;
  ImageList: TCustomImageList;
begin
  with TMenuItem(Sender), ACanvas do
  begin
    TopLevel := GetParentComponent is TMainMenu;

    ImageList := GetImageList;

    Font := FFont;

    if Assigned(ImageList) then
      Gutter := ImageList.Width + 9
    else
    if IsLine then
      Gutter := Max(TextHeight('W'), FMinHeight) + 4
    else
      Gutter := ARect.Bottom - ARect.Top + 4;

    Pen.Color := clBlack;
    if (odSelected in State) then
    begin
      Brush.Color := SelectedColor;
      Rectangle(ARect.Left, ARect.Top, ARect.Right, ARect.Bottom);
    end else
    if TopLevel then
    begin
      if (odHotLight in State) then
      begin
        Pen.Color := clBtnShadow;
        Brush.Color := FSelectedColor;
        Rectangle(ARect.Left, ARect.Top, ARect.Right, ARect.Bottom);
      end else
      begin
        Brush.Color := clBtnFace;
        FillRect(ARect);
      end
    end else
      begin
        Brush.Color := GutterColor;
        FillRect(Rect(ARect.Left, ARect.Top, Gutter, ARect.Bottom));
        Brush.Color := MenuColor;
        FillRect(Rect(Gutter, ARect.Top, ARect.Right, ARect.Bottom));
      end;

    if Checked then
    begin
      Brush.Color := FSelLightColor;
      if Assigned(ImageList) and (ImageIndex > -1) then
        RoundRect(ARect.Left + 2, ARect.Top, Gutter - 2 - 1,
          ARect.Bottom, _RectEl[RadioItem], _RectEl[RadioItem])
      else
      begin
        Rectangle((ARect.Left + 2 + Gutter - 1 - 2) div 2 - 8,
          (ARect.Top + ARect.Bottom) div 2 - 8,
          (ARect.Left + 2 + Gutter - 1 - 2) div 2 + 8,
          (ARect.Top + ARect.Bottom) div 2 + 8);
        Draw((ARect.Left + 2 + Gutter - 1 - 2 - BmpCheck[RadioItem].Width) div 2,
          (ARect.Top + ARect.Bottom - BmpCheck[RadioItem].Height) div 2,
          BmpCheck[RadioItem]);
      end
    end;

    if Assigned(ImageList) and ((ImageIndex > -1) and (not TopLevel)) then
      if Enabled then
        ImageList.Draw(ACanvas, ARect.Left + 4,
          (ARect.Top + ARect.Bottom - ImageList.Height) div 2,
          ImageIndex, True)
      else begin
        GetBmpFromImgList(FMonoBitmap, ImageList, ImageIndex);
        DoDrawMonoBmp(ACanvas, clBtnShadow, ARect.Left + 4,
          (ARect.Top + ARect.Bottom - ImageList.Height) div 2);
      end;

    with Font do
    begin
      if (odDefault in State) then Style := [fsBold];
      if (odDisabled in State) then Color := clGray
      else Color := clBlack;
    end;

    Brush.Style := bsClear;
    if TopLevel then
    else Inc(ARect.Left, Gutter + 5);

    if IsLine then
    begin
      Pen.Color := clBtnShadow;
      MoveTo(ARect.Left, ARect.Top + (ARect.Bottom - ARect.Top) div 2);
      LineTo(ARect.Right, ARect.Top + (ARect.Bottom - ARect.Top) div 2);
    end else
    begin
      Windows.DrawText(Handle, PChar(Caption), Length(Caption), ARect,
        _Flags or _FlagsTopLevel[TopLevel]);
      if ShortCut <> 0 then
      begin
        Dec(ARect.Right, 5);
        Windows.DrawText(Handle, PChar(ShortCutToText(ShortCut)),
          Length(ShortCutToText(ShortCut)), ARect,
          _Flags or _FlagsShortCut);
      end
    end
  end
end;

procedure TRyMenu.MeasureItem(Sender: TObject; ACanvas: TCanvas;
          var Width, Height: Integer);
var
  ImageList: TCustomImageList;
begin
  with TMenuItem(Sender) do
  begin
    ImageList := GetImageList;
    ACanvas.Font := FFont;
    if Assigned(ImageList) then
    begin
      if IsLine then
        if Max(FMinHeight, ImageList.Height) > 20 then
           Height := 11 else Height := 5
      else
        with ACanvas do
        begin
          Width := ImageList.Width;
          if Width < 8 then Width := 16 else Width := Width + 8;
          Width := Width + TextWidth(Caption + ShortCutToText(ShortCut)) + 15;
          Width := Max(Width, FMinWidth);
          Height := Max(ACanvas.TextHeight('W'), ImageList.Height);
          Height := Max(Height + 4, FMinHeight);
        end
    end else
      with ACanvas do
      begin
        Height := Max(TextHeight('W'), FMinHeight);
        if IsLine then
          if Height > 20 then
             Height := 11 else Height := 5;
        Width := 20 + 15 +
          TextWidth(Caption + ShortCutToText(ShortCut));
        Width := Max(Width, FMinWidth);
      end
  end
end;

procedure TRyMenu.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TRyMenu.SetSelectedColor(const Value: TColor);
begin
  FSelectedColor := Value;
  FSelLightColor := GetLightColor(Value, 75);
end;

procedure InitBmp(Bmp: TBitmap; Radio: Boolean);
const
  pr : array[0..17] of array[0..1] of Byte = (
    (2, 6), (3, 7), (4, 8), (5, 9), (6, 8), (7, 7),
    (3, 6), (4, 7), (5, 8), (6, 7), (7, 6), (8, 5), (9, 4), (10, 3), (11, 2),
    (3, 5), (4, 6), (5, 7)
  );
  pc : array[0..23] of array[0..1] of Byte = (
    (3, 5), (3, 6), (4, 7), (5, 8), (6, 8), (7, 7), (8, 6), (8, 5),
    (7, 4), (6, 3), (5, 3), (4, 4), (4, 5), (4, 6), (5, 7), (6, 7),
    (7, 6), (7, 5), (6, 4), (5, 4), (5, 5), (5, 6), (6, 6), (6, 5)
  );
var
  I: Byte;
begin
  with Bmp, Canvas do
  begin
    Width := 12;
    Height := 12;
    Monochrome := True;
    Transparent := True;
    Brush.Color := clWhite;
    FillRect(Rect(0, 0, Width, Height));
    if Radio then
      for I := Low(pc) to High(pc) do
        Pixels[pc[I, 0], pc[I, 1]] := clBlack
    else
      for I := Low(pr) to High(pr) do
        Pixels[pr[I, 0], pr[I, 1]] := clBlack;
  end
end;

procedure TRyMenu.SetMinHeight(const Value: Integer);
begin
  FMinHeight := Max(18, Value);
end;

initialization
  BmpCheck[False]:= TBitmap.Create;
  BmpCheck[True]:= TBitmap.Create;
  InitBmp(BmpCheck[False], False);
  InitBmp(BmpCheck[True], True);
  {$IFNDEF RY}
  FMonoBitmap := TBitmap.Create;
  FMonoBitmap.Monochrome := True;
  {$ENDIF RY}
  RyMenu := TRyMenu.Create;

finalization
  {$IFNDEF RY}
  FMonoBitmap.Free;
  {$ENDIF RY}
  BmpCheck[False].Free;
  BmpCheck[True].Free;
  RyMenu.Free;

end.
