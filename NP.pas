unit NP;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, XpMan, ShellApi, XPEdit, XPPanel, Menus,
  LbSpeedButton, IniFiles, Buttons, XPLabel, ExtCtrls, XPMenu, ImgList,
  Registry, OleCtrls, AppEvnts, ComObj, Printers;

  function OpenSaveFileDialog(ParentHandle: THandle; const DefExt, Filter, InitialDir,
  Title: string; var FileName: string; IsOpenDialog: Boolean): Boolean;

  const
   Tray      = Wm_User + 1;
   Cherta    = Wm_User + 2;
   About     = Wm_User + 3;
   AlignCenter = Wm_User + 1024;

  type
   TWmMoving = record
   Msg: Cardinal;
   fwSide: Cardinal;
   lpRect: PRect;
   Result: Integer;
  end;

type
  TMainForm = class(TForm)
    fr1: TXPPanel;
    ed: TXPEdit;
    fr2: TXPPanel;
    lb1: TListBox;
    PopupMenu: TPopupMenu;
    HideWindowItem: TMenuItem;
    SettingsItem: TMenuItem;
    AboutItem: TMenuItem;
    SendItem: TMenuItem;
    SysInfoItem: TMenuItem;
    ExitItem: TMenuItem;
    sp6: TMenuItem;
    sp5: TMenuItem;
    sp7: TMenuItem;
    RunParam: TLbSpeedButton;
    BrowseItem: TMenuItem;
    txt2: TXPLabel;
    txt1: TXPLabel;
    fr3: TXPPanel;
    lb2: TListBox;
    txt3: TXPLabel;
    SaveParam: TLbSpeedButton;
    LicenseItem: TMenuItem;
    T1: TTimer;
    HideParamItem: TMenuItem;
    ImageList1: TImageList;
    ImageList2: TImageList;
    ShowWindowItem: TMenuItem;
    sp1: TMenuItem;
    sp2: TMenuItem;
    MoreItem: TMenuItem;
    DeleteallyourParametersItem: TMenuItem;
    DeleteselectStringinyourParametersItem: TMenuItem;
    sp3: TMenuItem;
    MinimizedItem: TMenuItem;
    RunItem: TMenuItem;
    sp4: TMenuItem;
    SourceCodeItem: TMenuItem;
    ImportMainParametersItem: TMenuItem;
    ImportAdditionalParametersItem: TMenuItem;
    QuickPrintItem: TMenuItem;
    QuickPrint2Item: TMenuItem;
    sp8: TMenuItem;
    MemoryStatItem: TMenuItem;
    N1: TMenuItem;
    AppEvent: TApplicationEvents;
    PrinterSetupDlg: TPrinterSetupDialog;
    procedure FormShow(Sender: TObject);
    procedure edKeyDown(Sender: TObject; var Key: Word;
    Shift: TShiftState);
    procedure lb1DblClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
    procedure ExitItemClick(Sender: TObject);
    procedure SysInfoItemClick(Sender: TObject);
    procedure SendItemClick(Sender: TObject);
    procedure edChange(Sender: TObject);
    procedure lb1KeyDown(Sender: TObject; var Key: Word;
    Shift: TShiftState);
    procedure edKeyPress(Sender: TObject; var Key: Char);
    procedure RunParamClick(Sender: TObject);
    procedure edDblClick(Sender: TObject);
    procedure BrowseItemClick(Sender: TObject);
    procedure SaveParamClick(Sender: TObject);
    procedure SettingsItemClick(Sender: TObject);
    procedure AboutItemClick(Sender: TObject);
    procedure LicenseItemClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure T1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure lb2DblClick(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
    procedure HideParamItemClick(Sender: TObject);
    procedure ShowWindowItemClick(Sender: TObject);
    procedure HideWindowItemClick(Sender: TObject);
    procedure DeleteselectStringinyourParametersItemClick(Sender: TObject);
    procedure DeleteallyourParametersItemClick(Sender: TObject);
    procedure MinimizedItemClick(Sender: TObject);
    procedure RunItemClick(Sender: TObject);
    procedure SourceCodeItemClick(Sender: TObject);
    procedure ImportMainParametersItemClick(Sender: TObject);
    procedure ImportAdditionalParametersItemClick(Sender: TObject);
    procedure QuickPrintItemClick(Sender: TObject);
    procedure QuickPrint2ItemClick(Sender: TObject);
    procedure MemoryStatItemClick(Sender: TObject);
    procedure AppEventIdle(Sender: TObject; var Done: Boolean);

  private

    Ini: TIniFile;

    f: TFileStream;

    Icon: TNotifyIconData;

    procedure MinimizeApplication(Sender: TObject);

    procedure SystemTrayMenu(var Oleg: TMessage);
    message Tray;

    procedure WMMoving(var msg: TWMMoving);
    message WM_MOVING;

    procedure ChangeMessageBoxPosition(var Msg: TMessage);
    message AlignCenter;

  public

  end;

var
  MainForm: TMainForm;
  
  msgCaption: PChar;

implementation

uses PP;

 type
   POpenFilenameA = ^TOpenFilenameA;
   POpenFilename = POpenFilenameA;
   tagOFNA = packed record
   lStructSize: DWORD;
   hWndOwner: HWND;
   hInstance: HINST;
   lpstrFilter: PAnsiChar;
   lpstrCustomFilter: PAnsiChar;
   nMaxCustFilter: DWORD;
   nFilterIndex: DWORD;
   lpstrFile: PAnsiChar;
   nMaxFile: DWORD;
   lpstrFileTitle: PAnsiChar;
   nMaxFileTitle: DWORD;
   lpstrInitialDir: PAnsiChar;
   lpstrTitle: PAnsiChar;
   Flags: DWORD;
   nFileOffset: Word;
   nFileExtension: Word;
   lpstrDefExt: PAnsiChar;
   lCustData: LPARAM;
   lpfnHook: function(Wnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): UINT stdcall;
   lpTemplateName: PAnsiChar;
   end;
   TOpenFilenameA = tagOFNA;
   TOpenFilename = TOpenFilenameA;

   function GetOpenFileName(var OpenFile: TOpenFilename): Bool; stdcall; external 'comdlg32.dll'
   name 'GetOpenFileNameA';
   function GetSaveFileName(var OpenFile: TOpenFilename): Bool; stdcall; external 'comdlg32.dll'
   name 'GetSaveFileNameA';

  const
   OFN_DONTADDTORECENT = $02000000;
   OFN_FILEMUSTEXIST = $00001000;
   OFN_HIDEREADONLY = $00000004;
   OFN_PATHMUSTEXIST = $00000800;

 function CharReplace(const Source: string; oldChar, newChar: Char): string;
 var
 i: Integer;
 begin
 Result := Source;
 for i := 1 to Length(Result) do
 if Result[i] = oldChar then
 Result[i] := newChar;
 end;

{$R *.dfm}

function OpenSaveFileDialog(ParentHandle: THandle; const DefExt, Filter, InitialDir, Title: string; var FileName: string; IsOpenDialog: Boolean): Boolean;
var
ofn: TOpenFileName;
szFile: array[0..MAX_PATH] of Char;
begin
Result := False;
FillChar(ofn, SizeOf(TOpenFileName), 0);
with ofn do
begin
lStructSize := SizeOf(TOpenFileName);
hwndOwner := ParentHandle;
lpstrFile := szFile;
nMaxFile := SizeOf(szFile);
if (Title <> '') then
lpstrTitle := PChar(Title);
if (InitialDir <> '') then
lpstrInitialDir := PChar(InitialDir);
StrPCopy(lpstrFile, FileName);
lpstrFilter := PChar(CharReplace(Filter, '|', #0)+#0#0);
if DefExt <> '' then
lpstrDefExt := PChar(DefExt);
end;
if IsOpenDialog then
begin
if GetOpenFileName(ofn) then
begin
Result := True;
FileName := StrPas(szFile);
end;
end else
begin
if GetSaveFileName(ofn) then
begin
Result := True;
FileName := StrPas(szFile);
end;
end
end;

function MyExitWindows(RebootParam: Longword): Boolean;
var
TTokenHd: THandle;
TTokenPvg: TTokenPrivileges;
cbtpPrevious: DWORD;
rTTokenPvg: TTokenPrivileges;
pcbtpPreviousRequired: DWORD;
tpResult: Boolean;
const 
SE_SHUTDOWN_NAME = 'SeShutdownPrivilege';
begin 
if Win32Platform = VER_PLATFORM_WIN32_NT then
begin
tpResult := OpenProcessToken(GetCurrentProcess(),
TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY,
TTokenHd);
if tpResult then
begin
tpResult := LookupPrivilegeValue(nil,
SE_SHUTDOWN_NAME,
TTokenPvg.Privileges[0].Luid);
TTokenPvg.PrivilegeCount := 1;
TTokenPvg.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
cbtpPrevious := SizeOf(rTTokenPvg);
pcbtpPreviousRequired := 0;
if tpResult then
Windows.AdjustTokenPrivileges(TTokenHd, False,
TTokenPvg, cbtpPrevious, rTTokenPvg, pcbtpPreviousRequired);
end;
end;
Result := ExitWindowsEx(RebootParam, 0);
end;

procedure TMainForm.FormShow(Sender: TObject);
var
f: TFileStream;
R: TRegistry;
begin
try
ed.Height := 22;
f := TFileStream.Create('ListFavorites.ipf', fmOpenRead);
f.ReadComponent(lb2);
f.Free;
except 
end;
R := TRegistry.Create;
R.RootKey := HKEY_LOCAL_MACHINE;
R.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', false);
if SettingsForm.Ch4.Checked then
R.WriteString(Application.Title, ParamStr(0)) else
R.DeleteValue(Application.Title);
R.Free;
SettingsForm.LangCombo.OnChange(Self);
T1.Enabled := True;
if SettingsForm.ch5.Checked then
begin
MainForm.lb1.Font.Style := [fsBold];
end else
MainForm.lb1.Font.Style := [];
if SettingsForm.ch7.Checked then
begin
RyMenu.Add(PopupMenu, nil);
end;
if SettingsForm.ch9.Checked then
PopupMenu.Images := ImageList2 else
PopupMenu.Images := ImageList1;
MainForm.Color := SettingsForm.ColorDlg1.Color;
SettingsForm.txt7.ForegroundColor := SettingsForm.ColorDlg1.Color;
MainForm.lb1.Font.Color := SettingsForm.ColorDlg2.Color;
MainForm.ed.Font.Color := SettingsForm.ColorDlg2.Color;
SettingsForm.txt8.ForegroundColor := SettingsForm.ColorDlg2.Color;
if HideParamItem.Checked then
ClientHeight := 71 else
ClientHeight := 447;
end;

procedure TMainForm.edKeyDown(Sender: TObject; var Key: Word;
Shift: TShiftState);
var
w1: Word;
p1, p2: array[0..255] of Char;
begin
if Key = vk_Return then
begin
StrPcopy(p1, ed.Text);
if GetModuleHandle(p1) = 0 then
begin
StrPcopy(p2, ed.Text);
w1 := WinExec(p2, SW_Restore);
end;
if ed.Text = 'ADDREMOVE' then
WinExec('CONTROL.EXE appwiz.cpl',sw_ShowNormal);
if ed.Text = 'ADMIN' then
WinExec('CONTROL.EXE admintools',sw_ShowNormal);
if ed.Text = 'DEVICES' then
ShellExecute(Handle, nil, 'devmgmt.msc', nil, nil, Sw_ShowNormal);
if ed.Text = 'DISPLAY' then
WinExec('CONTROL.EXE desk.cpl',sw_ShowNormal);
if ed.Text = 'COMMAND LINE WINDOWS' then
ShellExecute(Handle, nil, 'cmd.exe', nil, nil, Sw_ShowNormal);
if ed.Text = 'FIREWALL' then
WinExec('CONTROL.EXE firewall.cpl',sw_ShowNormal);
if ed.Text = 'GOOGLE' then
ShellExecute(Handle, nil, 'www.google.com/search?hl=en&q=$U$', nil, nil, Sw_Restore);
if ed.Text = 'IE' then
ShellExecute(Handle, nil, 'iexplore.exe', nil, nil, Sw_Restore);
if ed.Text = 'OPENS SHUTDOWN DIALOG' then
SendMessage(FindWindow('Progman','Program Manager'),
WM_CLOSE, 0, 0);
if ed.Text = 'RESTART COMPUTER' then
MyExitWindows(EWX_REBOOT or EWX_FORCE);
if ed.Text = 'SCREENSAVER' then
sendmessage(handle, wm_syscommand, sc_screensave, 2);
if ed.Text = 'SERVICES' then
ShellExecute(Handle, nil, 'services.msc', nil, nil, Sw_Restore);
if ed.Text = 'SHUTDOWN COMPUTER' then
MyExitWindows(EWX_POWEROFF or EWX_FORCE);
if ed.Text = 'SYSTEM' then
WinExec('CONTROL.EXE sysdm.cpl',sw_ShowNormal);
if ed.Text = 'TASK' then
ShellExecute(Handle, nil, 'taskmgr.exe', nil, nil, Sw_Restore);
if ed.Text = 'WILL LOGOFF CURRENT USER' then
ExitWindowsEx(EWX_Force, 0);
if SettingsForm.ch1.Checked then
begin
Close;;
end;
if ed.Text = '' then
begin

end else
if SettingsForm.ch2.Checked then
begin
Application.Minimize;
end;
end;
end;

procedure TMainForm.lb1DblClick(Sender: TObject);
var
i: Integer;
begin
try
i := lb1.ItemIndex;
Ed.Text := lb1.Items.Strings[i];
except
end;
end;

procedure TMainForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
Shift: TShiftState; X, Y: Integer);
begin
ReleaseCapture;
Perform(Wm_SysCommand, $f012, 0);
end;

procedure TMainForm.ExitItemClick(Sender: TObject);
begin
Close;
end;

procedure TMainForm.SysInfoItemClick(Sender: TObject);
begin
ShellExecute(handle, nil, 'msInfo32', nil,nil, Sw_ShowNormal);
end;

procedure TMainForm.SendItemClick(Sender: TObject);
var
EMailDestinationString, SubjectString,
mailstring: string;
begin
EMailDestinationString := 'GoodWinNix@mail.ru';
SubjectString := 'Executor v 1.0';
mailstring := 'mailto:' + EMailDestinationString +
'?subject=' + SubjectString +
'&body=';
if (ShellExecute(0, 'open', PChar(mailstring), '', '',
SW_SHOWNORMAL) <= 32) then
ShowMessage('Auto method failed.');
end;

procedure TMainForm.edChange(Sender: TObject);
begin
lb1.Perform(LB_SELECTSTRING, -1, longint(Pchar(ed.text)));
lb2.Perform(LB_SELECTSTRING, -1, longint(Pchar(ed.text)));
end;

procedure TMainForm.lb1KeyDown(Sender: TObject; var Key: Word;
Shift: TShiftState);
var
i: Integer;
begin
try
if key = vk_Return then
begin
i := lb1.ItemIndex;
Ed.Text := lb1.Items.Strings[i];
end;
except
end;
end;

procedure TMainForm.edKeyPress(Sender: TObject; var Key: Char);
begin
with Sender as TXPEdit do
if Key in ['a'..'z'] then
Key := UpCase(Key);
end;

procedure TMainForm.RunParamClick(Sender: TObject);
var
w1: Word;
p1, p2: array[0..255] of Char;
begin
StrPcopy(p1, ed.Text);
if GetModuleHandle(p1) = 0 then
begin
StrPcopy(p2, ed.Text);
w1 := WinExec(p2, SW_Restore);
if ed.Text = 'ADDREMOVE' then
WinExec('CONTROL.EXE appwiz.cpl',sw_ShowNormal);
if ed.Text = 'ADMIN' then
WinExec('CONTROL.EXE admintools',sw_ShowNormal);
if ed.Text = 'DEVICES' then
ShellExecute(Handle, nil, 'devmgmt.msc', nil, nil, Sw_ShowNormal);
if ed.Text = 'DISPLAY' then
WinExec('CONTROL.EXE desk.cpl',sw_ShowNormal);
if ed.Text = 'COMMAND LINE WINDOWS' then
ShellExecute(Handle, nil, 'cmd.exe', nil, nil, Sw_ShowNormal);
if ed.Text = 'FIREWALL' then
WinExec('CONTROL.EXE firewall.cpl',sw_ShowNormal);
if ed.Text = 'GOOGLE SEARCH' then
ShellExecute(Handle, nil, 'www.google.com/search?hl=en&q=$U$', nil, nil, Sw_Restore);
if ed.Text = 'IE' then
ShellExecute(Handle, nil, 'iexplore.exe', nil, nil, Sw_Restore);
if ed.Text = 'OPENS SHUTDOWN DIALOG' then
SendMessage(FindWindow('Progman','Program Manager'),
WM_CLOSE, 0, 0);
if ed.Text = 'RESTART COMPUTER' then
MyExitWindows(EWX_REBOOT or EWX_FORCE);
if ed.Text = 'SCREENSAVER' then
SendMessage(Handle, Wm_SysCommand, Sc_ScreenSave, 2);
if ed.Text = 'SERVICES' then
ShellExecute(Handle, nil, 'services.msc', nil, nil, Sw_Restore);
if ed.Text = 'SHUTDOWN COMPUTER' then
MyExitWindows(EWX_POWEROFF or EWX_FORCE);
if ed.Text = 'SYSTEM' then
WinExec('CONTROL.EXE sysdm.cpl',sw_ShowNormal);
if ed.Text = 'TASK' then
ShellExecute(Handle, nil, 'taskmgr.exe', nil, nil, Sw_Restore);
if ed.Text = 'WILL LOGOFF CURRENT USER' then
ExitWindowsEx(EWX_Force, 0);
end;
if SettingsForm.ch1.Checked then
begin
Close;;
end;
if ed.Text = '' then
exit else
if SettingsForm.ch2.Checked then
begin
ShowWindowItem.Visible := True;
HideWindowItem.Visible := False;
Application.Minimize;
end;
end;

procedure TMainForm.edDblClick(Sender: TObject);
begin
ed.Text := '';
end;

procedure TMainForm.BrowseItemClick(Sender: TObject);
var
s: String;
begin
try
if OpenSaveFileDialog(MainForm.Handle, '*.exe', 'Executable Files (*.exe)|*.exe|All Files (*.*)|*.*',
s, 'Executor', s, True) then
begin
ed.Text := s;
end;
except
end;
end;

procedure TMainForm.SaveParamClick(Sender: TObject);
begin
try
if ed.Text = '' then
begin
PostMessage(Handle, WM_USER + 1024, 0, 0);
if SettingsForm.LangCombo.ItemIndex = 0 then
Application.MessageBox('Input your parameters!', 'Executor',
mb_IconAsterisk + mb_Ok);
if SettingsForm.LangCombo.ItemIndex = 1 then
Application.MessageBox('Введите ваши параметры!', 'Executor',
mb_IconAsterisk + mb_Ok);
end else
begin
lb2.Items.Add(ed.Text);
f := TFileStream.Create('ListFavorites.ipf', fmcreate);
f.WriteComponent(lb2);
f.Free;
end;
except
end;
end;

procedure TMainForm.SettingsItemClick(Sender: TObject);
begin
try
SettingsForm.Position := poDesktopCenter;
SettingsForm.PageControl.ActivePageIndex := 0;
SettingsForm.Position := poDesktopCenter;
SettingsForm.ShowModal;
except
end;
end;

procedure TMainForm.AboutItemClick(Sender: TObject);
begin
try
SettingsForm.Position := poDesktopCenter;
SettingsForm.PageControl.ActivePageIndex := 2;
SettingsForm.Position := poDesktopCenter;
SettingsForm.ShowModal;
except
end;
end;

procedure TMainForm.LicenseItemClick(Sender: TObject);
begin
try
SettingsForm.Position := poDesktopCenter;
SettingsForm.PageControl.ActivePageIndex := 1;
SettingsForm.Position := poDesktopCenter;
SettingsForm.ShowModal;
except
end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
hMutex: HWND;
begin
DragAcceptFiles(lb2.Handle, True);
Ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
try
HideParamItem.Checked := Ini.ReadBool('Parameters Bar', 'Visible', HideParamItem.Checked);
Top := Ini.ReadInteger('Position', 'Top', 100);
Left := Ini.ReadInteger('Position', 'Left', 100);
except
end;
with Icon do
begin
Wnd := Handle;
SzTip := 'Executor v 1.0';
HIcon := Application.Icon.Handle;
UCallBackMessage := Tray;
UFlags := Nif_Tip + nIf_Message or Nif_Icon;
Shell_NotifyIcon(Nim_Add, @Icon);
end;
Application.OnMinimize := MinimizeApplication;
hMutex := CreateMutex(nil, True , 'Executor');
if GetLastError = ERROR_ALREADY_EXISTS then
halt;
end;

procedure TMainForm.MinimizeApplication(Sender: TObject);
begin
ShowWindowItem.Visible := True;
HideWindowItem.Visible := False;
ShowWindow(Application.Handle, Sw_Hide);
end;

procedure TMainForm.SystemTrayMenu(var Oleg: TMessage);
var
Ico: TPoint;
begin
case Oleg.LParam of
Wm_LButtonDblClk:
begin
ShowWindowItem.Visible := False;
HideWindowItem.Visible := True;
ShowWindow(Application.Handle, Sw_Show);
Application.Restore;
end;
Wm_RButtonDown:
begin
SetForegroundWindow(Handle);
GetCursorPos(Ico);
PopupMenu.Popup(Ico.X, Ico.Y); 
end;
end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
Shell_NotifyIcon(Nim_Delete, @Icon);
MainForm.OnActivate := nil;
ImageList1.Free;
ImageList2.Free;
SaveParam.Free;
PopupMenu.Free;
RunParam.Free;
AppEvent.Free;
txt1.Free;
txt2.Free;
txt3.Free;
fr1.Free;
fr2.Free;
fr3.Free;
Ini.Free;
lb1.Free;
lb2.Free;
ed.Free;
T1.Free;
end;

procedure TMainForm.T1Timer(Sender: TObject);
begin
T1.Enabled := False;
if SettingsForm.ch3.Checked then
SetWindowPos(MainForm.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE+SWP_NOSIZE) else
SetWindowPos(MainForm.Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE+SWP_NOSIZE);
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if SettingsForm.ch6.Checked then
begin
Ini.WriteInteger('Position', 'Top', Top);
Ini.WriteInteger('Position', 'Left', Left);
end;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
if SettingsForm.ch8.Checked then
if SettingsForm.LangCombo.ItemIndex = 0 then
CanClose :=
Application.MessageBox('Are you sure, what do you want to exit Executor?',
'Exit',
mb_IconQuestion + mb_YesNo) = mrYes;
if SettingsForm.ch8.Checked then
if SettingsForm.LangCombo.ItemIndex = 1 then
CanClose :=
Application.MessageBox('Вы уверены, что хотите выйти из Executor?',
'Выход',
mb_IconQuestion + mb_YesNo) = mrYes;
end;

procedure TMainForm.lb2DblClick(Sender: TObject);
var
i: Integer;
begin
try
i := lb2.ItemIndex;
Ed.Text := lb2.Items.Strings[i];
except
end;
end;

procedure TMainForm.FormDblClick(Sender: TObject);
begin
try
if SettingsForm.DblClkCombo.ItemIndex = 0 then
begin
exit;
end;
if SettingsForm.DblClkCombo.ItemIndex = 1 then
begin
SettingsForm.Position := poDesktopCenter;
SettingsForm.PageControl.ActivePageIndex := 0;
SettingsForm.ShowModal;
end;
if SettingsForm.DblClkCombo.ItemIndex = 2 then
begin
HideParamItem.Click;
end;
except
end;
end;

procedure TMainForm.HideParamItemClick(Sender: TObject);
begin
HideParamItem.Checked := not HideParamItem.Checked;
if HideParamItem.Checked then
ClientHeight := 71 else
ClientHeight := 447;
end;

procedure TMainForm.ShowWindowItemClick(Sender: TObject);
begin
ShowWindow(Application.Handle, Sw_Show);
Application.Restore;
ShowWindowItem.Visible := False;
HideWindowItem.Visible := True;
end;

procedure TMainForm.HideWindowItemClick(Sender: TObject);
begin
HideWindowItem.Visible := False;
ShowWindowItem.Visible := True;
Application.Minimize;
end;

procedure TMainForm.ChangeMessageBoxPosition(var Msg: TMessage);
var
MbHwnd: longword;
MbRect: TRect;
x, y, w, h: integer;
begin
MbHwnd := FindWindow(MAKEINTRESOURCE(WC_DIALOG), msgCaption);
if (MbHwnd <> 0) then
begin
GetWindowRect(MBHWnd, MBRect);
with MbRect do
begin
w := Right - Left;
h := Bottom - Top;
end;
x := MainForm.Left + ((MainForm.Width - w) div 2);
if x < 0 then
x := 0
else if x + w > Screen.Width then x := Screen.Width - w;
y := MainForm.Top + ((MainForm.Height - h) div 2);
if y < 0 then y := 0
else if y + h > Screen.Height then y := Screen.Height - h;
SetWindowPos(MBHWnd, 0, x, y, 0, 0, SWP_NOACTIVATE or SWP_NOSIZE or SWP_NOZORDER);
end;
end;

procedure TMainForm.WMMoving(var msg: TWMMoving);
var
r: TRect;
begin
r := Screen.WorkareaRect;
if msg.lprect^.left < r.left then
OffsetRect(msg.lprect^, r.left - msg.lprect^.left, 0);
if msg.lprect^.top < r.top then
OffsetRect(msg.lprect^, 0, r.top - msg.lprect^.top);
if msg.lprect^.right > r.right then
OffsetRect(msg.lprect^, r.right - msg.lprect^.right, 0);
if msg.lprect^.bottom > r.bottom then
OffsetRect(msg.lprect^, 0, r.bottom - msg.lprect^.bottom);
inherited;
end;

procedure TMainForm.DeleteselectStringinyourParametersItemClick(
Sender: TObject);
begin
try
lb2.Items.Delete(lb2.ItemIndex);
f := TFileStream.Create('ListFavorites.ipf', fmcreate);
f.WriteComponent(lb2);
f.Free;
except
end;
end;

procedure TMainForm.DeleteallyourParametersItemClick(Sender: TObject);
begin
lb2.Clear;
f := TFileStream.Create('ListFavorites.ipf', fmcreate);
f.WriteComponent(lb2);
f.Free;
end;

procedure TMainForm.MinimizedItemClick(Sender: TObject);
begin
Application.Minimize;
end;

procedure TMainForm.RunItemClick(Sender: TObject);
var
ShellApplication: Variant;
begin
ShellApplication := CreateOleObject('Shell.Application');
ShellApplication.FileRun;
end;

procedure TMainForm.SourceCodeItemClick(Sender: TObject);
begin
PostMessage(Handle, WM_USER + 1024, 0, 0);
if SettingsForm.LangCombo.ItemIndex = 0 then
begin
if Application.MessageBox(
'Copyright @2009 Domani Oleg (aka ?КТО_Я?)' + #13 +
'=====================================' + #13 + #13 + '' +
'If you want give of Source Code of Executor Project' + #13
+ '(archives with components library by wish user) and'
+ #13 + 'also all next new version then send e-mail to the author.' + #13 +
'' +  #13 + '=====================================' +  #13 +
'' +  #13 +
'Send mail now?',
'Executor',
mb_IconAsterisk + mb_YesNo) = idYes then
begin
ShellExecute(Handle, 'open',
'mailto:GoodWinNix@mail.ru?Subject=Executor Project' +
'&Body=Hello, please send me the source code program. Thanks!',
'', '', SW_SHOW);
end;
end;
if SettingsForm.LangCombo.ItemIndex = 1 then
begin
if Application.MessageBox(
'Copyright @2009 Домани Олег (aka ?КТО_Я?)' + #13 +
'======================================' + #13 + #13 + '' +
'Если Вы хотите получить исходный код проекта (архив ' + #13
+ 'с компонентами по желанию пользователя), а также'
+ #13 + 'все последующие новые версии программы, то' + #13 +
'отправьте электронное письмо автору.' + #13 +
'' +  #13 + '======================================' +  #13 +
'' +  #13 +
'Отправить письмо сейчас?',
'Executor',
mb_IconAsterisk + mb_YesNo) = idYes then
begin
ShellExecute(Handle, 'open',
'mailto:GoodWinNix@mail.ru?Subject=Executor Project' +
'&Body=Hello, please send me the source code program. Thanks!',
'', '', SW_SHOW);
end;
end;
end;

procedure TMainForm.ImportMainParametersItemClick(Sender: TObject);
var
s: String;
begin
try
if SettingsForm.LangCombo.ItemIndex = 0 then
begin
if OpenSaveFileDialog(MainForm.Handle, '*.txt', 'Normal text files (*.txt)|*.txt',
s, 'Executor', s, False) then
begin
PostMessage(Handle, WM_USER + 1024, 0, 0);
if FileExists(s) then
if Application.MessageBox(PChar('File "' + s +
'" already exists.' +
#13 + 'Replace file?'),
'Confirmation', MB_ICONQUESTION + mb_YesNo)
<> idYes then  else
lb1.Items.SaveToFile(s);
if not FileExists(s) then
lb1.Items.SaveToFile(s);
end;
end;
if SettingsForm.LangCombo.ItemIndex = 1 then
begin
if OpenSaveFileDialog(MainForm.Handle, '*.txt', 'Normal text files (*.txt)|*.txt',
s, 'Executor', s, False) then
begin
PostMessage(Handle, WM_USER + 1024, 0, 0);
if FileExists(s) then
if Application.MessageBox(PChar('Файл "' + s +
'" уже существует.' +
#13 + 'Заменить файл?'),
'Подтверждение', MB_ICONQUESTION + mb_YesNo)
<> idYes then  else
lb1.Items.SaveToFile(s);
if not FileExists(s) then
lb1.Items.SaveToFile(s);
end;
end;
except
end;
end;

procedure TMainForm.ImportAdditionalParametersItemClick(Sender: TObject);
var
s: String;
begin
try
if lb2.Items.Count = 0 then
begin
Exit;
end else
begin
if SettingsForm.LangCombo.ItemIndex = 0 then
begin
if OpenSaveFileDialog(MainForm.Handle, '*.txt', 'Normal text files (*.txt)|*.txt',
s, 'Executor', s, False) then
begin
PostMessage(Handle, WM_USER + 1024, 0, 0);
if FileExists(s) then
if Application.MessageBox(PChar('File "' + s +
'" already exists.' +
#13 + 'Replace file?'),
'Confirmation', MB_ICONQUESTION + mb_YesNo)
<> idYes then  else
lb2.Items.SaveToFile(s);
if not FileExists(s) then
lb2.Items.SaveToFile(s);
end;
end;
if SettingsForm.LangCombo.ItemIndex = 1 then
begin
if OpenSaveFileDialog(MainForm.Handle, '*.txt', 'Normal text files (*.txt)|*.txt',
s, 'Executor', s, False) then
begin
PostMessage(Handle, WM_USER + 1024, 0, 0);
if FileExists(s) then
if Application.MessageBox(PChar('Файл "' + s +
'" уже существует.' +
#13 + 'Заменить файл?'),
'Подтверждение', MB_ICONQUESTION + mb_YesNo)
<> idYes then  else
lb2.Items.SaveToFile(s);
if not FileExists(s) then
lb2.Items.SaveToFile(s);
end;
end;
end;
except
end;
end;

procedure TMainForm.QuickPrintItemClick(Sender: TObject);
var
sMemo : String;
filename : TextFile;
x : Integer;
begin
try
PostMessage(Handle, WM_USER + 1024, 0, 0);
sMemo := lb1.Items.Text;
If Length(Trim(sMemo)) = 0 Then
exit;
If Length(Trim(sMemo)) <> 0 Then
if PrinterSetupDlg.Execute then begin
AssignPrn(filename);
Rewrite(filename);
for x := 0 to lb1.Items.Count - 1 do
Writeln(filename, lb1.Items[x]);
CloseFile(filename);
end;
except
end;
end;

procedure TMainForm.QuickPrint2ItemClick(Sender: TObject);
var
sMemo : String;
filename : TextFile;
x : Integer;
begin
try
if lb2.Items.Count = 0 then
begin
Exit;
end else
begin
PostMessage(Handle, WM_USER + 1024, 0, 0);
sMemo := lb2.Items.Text;
If Length(Trim(sMemo)) = 0 Then
exit;
If Length(Trim(sMemo)) <> 0 Then
if PrinterSetupDlg.Execute then begin
AssignPrn(filename);
Rewrite(filename);
for x := 0 to lb2.Items.Count - 1 do
Writeln(filename, lb2.Items[x]);
CloseFile(filename);
end;
end;
except
end;
end;

procedure TMainForm.MemoryStatItemClick(Sender: TObject);
var
Memo : TMemoryStatus;
begin
GlobalMemoryStatus(Memo);
if SettingsForm.LangCombo.ItemIndex = 1 then
begin
PostMessage(Handle, WM_USER + 1024, 0, 0);
Application.MessageBox(PChar(
'Физическая память: ' +
FormatFloat('#,###" KB"', Memo.dwTotalPhys / 1024) + #13 +
'Использовано: ' + Format('%d %%', [Memo.dwMemoryLoad]) + #13 +
'Свободно от всего объема файла подкачки: ' +
Format('%0.0f Мбайт',[Memo.dwAvailPageFile div 1024 / 1024]) + #13 +
'Всего страничной памяти: ' +
Format('%0.0f Мбайт',[Memo.dwTotalPageFile div 1024 / 1024]) + #13 +
'Общее количество: ' +
Format('%0.0f Мбайт',[Memo.dwTotalPhys div 1024 / 1024]) +  #13 +
'Доступная память: ' +
Format('%0.3f Мбайт',[Memo.dwAvailPhys div 1024 / 1024])),
'Статистика памяти', mb_IconAsterisk + Mb_OK);
end;
if SettingsForm.LangCombo.ItemIndex = 0 then
begin
PostMessage(Handle, WM_USER + 1024, 0, 0);
Application.MessageBox(PChar(
'Physical Memory: ' +
FormatFloat('#,###" KB"', Memo.dwTotalPhys / 1024) + #13 +
'Use: ' + Format('%d %%', [Memo.dwMemoryLoad]) + #13 +
'Available Page Memory: ' +
Format('%0.0f Мбайт',[Memo.dwAvailPageFile div 1024 / 1024]) + #13 +
'Total Page Memory: ' +
Format('%0.0f Мбайт',[Memo.dwTotalPageFile div 1024 / 1024]) + #13 +
'Total Memory: ' +
Format('%0.0f Мбайт',[Memo.dwTotalPhys div 1024 / 1024]) +  #13 +
'Available Memory: ' +
Format('%0.3f Мбайт',[Memo.dwAvailPhys div 1024 / 1024])),
'Memory Statistics', mb_IconAsterisk + Mb_OK);
end;
end;

procedure TMainForm.AppEventIdle(Sender: TObject;
var Done: Boolean);
begin
if SettingsForm.LangCombo.ItemIndex  = -1 then
SettingsForm.LangCombo.ItemIndex := 0;
Ini.WriteBool('Settings', 'Close Program After Each Word', SettingsForm.ch1.Checked);
Ini.WriteBool('Settings', 'Minimized to Tray After Word', SettingsForm.ch2.Checked);
Ini.WriteBool('Settings', 'Always on Top', SettingsForm.ch3.Checked);
Ini.WriteBool('Settings', 'Start with Windows OS Startup', SettingsForm.ch4.Checked);
Ini.WriteBool('Settings', 'Write Items in Bold', SettingsForm.ch5.Checked);
Ini.WriteBool('Settings', 'Save Window Position', SettingsForm.ch6.Checked);
Ini.WriteBool('Settings', 'Use of XP Menu', SettingsForm.ch7.Checked);
Ini.WriteBool('Settings', 'Confirmation Exit', SettingsForm.ch8.Checked);
Ini.WriteBool('Settings', 'Invisible Images in the Menu', SettingsForm.ch9.Checked);
Ini.WriteInteger('Language', 'Int', SettingsForm.LangCombo.ItemIndex);
Ini.WriteInteger('DblClk', 'Int', SettingsForm.DblClkCombo.ItemIndex);
Ini.WriteInteger('Color', 'Window', SettingsForm.ColorDlg1.Color);
Ini.WriteInteger('Color', 'Font', SettingsForm.ColorDlg2.Color);
Ini.WriteBool('Parameters Bar', 'Visible', HideParamItem.Checked);
Ini.WriteString('Shortcut name', 'Name', SettingsForm.TextName.Text);
end;

end.
