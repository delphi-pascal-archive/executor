unit PP;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, XPLabel, XPGroupBox, XPButton, Registry, Spin,
  StdCtrls,  XPCheckBox, IniFiles, XPEdit, ActiveX, ComObj, ShellApi, ShlObj,
  jpeg;

  const
   AlignCenter = Wm_User + 1024;

 type
   TSettingsForm = class(TForm)
    PageControl: TPageControl;
    Tab1: TTabSheet;
    Tab2: TTabSheet;
    Tab3: TTabSheet;
    txt9: TXPLabel;
    txt11: TXPLabel;
    txt10: TXPLabel;
    txt13: TXPLabel;
    txt12: TXPLabel;
    txt24: TXPLabel;
    txt25: TXPLabel;
    txt23: TXPLabel;
    txt21: TXPLabel;
    Cancel: TXPButton;
    LicenseText: TRichEdit;
    fr1: TXPGroupBox;
    ch1: TXPCheckBox;
    ch2: TXPCheckBox;
    ch3: TXPCheckBox;
    ch4: TXPCheckBox;
    ch5: TXPCheckBox;
    ch6: TXPCheckBox;
    fr3: TXPGroupBox;
    ch7: TXPCheckBox;
    ch8: TXPCheckBox;
    ch9: TXPCheckBox;
    fr2: TXPGroupBox;
    txt2: TXPLabel;
    txt3: TXPLabel;
    txt4: TXPLabel;
    txt5: TXPLabel;
    txt6: TXPLabel;
    txt1: TXPLabel;
    TextName: TXPEdit;
    fr4: TXPGroupBox;
    txt8: TXPLabel;
    txt7: TXPLabel;
    fr5: TXPGroupBox;
    LangCombo: TComboBox;
    fr6: TXPGroupBox;
    DblClkCombo: TComboBox;
    txt26: TXPLabel;
    txt20: TXPLabel;
    txt19: TXPLabel;
    ColorDlg1: TColorDialog;
    ColorDlg2: TColorDialog;
    fr7: TBevel;
    txt14: TXPLabel;
    txt15: TXPLabel;
    txt16: TXPLabel;
    txt18: TXPLabel;
    txt17: TXPLabel;
    fr8: TBevel;
    txt22: TXPLabel;
    logo: TImage;
    OK: TXPButton;
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
    procedure CancelClick(Sender: TObject);
    procedure txt8Click(Sender: TObject);
    procedure txt7Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure txt2Click(Sender: TObject);
    procedure txt3Click(Sender: TObject);
    procedure txt4Click(Sender: TObject);
    procedure txt5Click(Sender: TObject);
    procedure txt6Click(Sender: TObject);
    procedure LangComboChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure txt19Click(Sender: TObject);
    procedure ch7Click(Sender: TObject);
    procedure TextNameChange(Sender: TObject);
    procedure txt21MouseUp(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
    procedure txt21MouseLeave(Sender: TObject);
    procedure txt21MouseMove(Sender: TObject; Shift: TShiftState; X,
    Y: Integer);
    procedure txt21Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
    Shift: TShiftState);
    procedure txt26Click(Sender: TObject);
    procedure DblClkComboCloseUp(Sender: TObject);
    procedure txt20Click(Sender: TObject);
    procedure txt20MouseLeave(Sender: TObject);
    procedure txt20MouseUp(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
    procedure txt20MouseMove(Sender: TObject; Shift: TShiftState; X,
    Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure txt19MouseLeave(Sender: TObject);
    procedure txt19MouseUp(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
    procedure txt19MouseMove(Sender: TObject; Shift: TShiftState; X,
    Y: Integer);
    procedure txt26MouseLeave(Sender: TObject);
    procedure txt26MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure txt26MouseMove(Sender: TObject; Shift: TShiftState; X,
    Y: Integer);
    procedure txt22Click(Sender: TObject);
    procedure OKClick(Sender: TObject);
    procedure txt22MouseLeave(Sender: TObject);
    procedure txt22MouseUp(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
    procedure txt22MouseMove(Sender: TObject; Shift: TShiftState; X,
    Y: Integer);

  private

    r: TRegistry;

    Ini: TIniFile;

    LinkFile: IPersistFile;

    ShellObject: IUnknown;

    ShellLink: IShellLink;

    FileName, ShortcutPosition: string;

    WShortcutPosition: WideString;

    P: PItemIDList;

    C: array[0..1000] of char;

    procedure CMMouseLeave(var msg: TMessage);
    message CM_MOUSELEAVE;

    procedure ChangeMessageBoxPosition(var Msg: TMessage);
    message AlignCenter;

  public

  end;

var
  SettingsForm: TSettingsForm;

  msgCaption: PChar;

implementation

uses NP;

{$R *.dfm}

procedure TSettingsForm.FormCreate(Sender: TObject);
var
Size: DWord;
MS: TMemoryStatus;
NameUser: array[0..255] of char;
NameComp: array[0..255] of char;
begin
Ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
try
ch1.Checked := Ini.ReadBool('Settings', 'Close Program After Each Word', ch1.Checked);
ch2.Checked := Ini.ReadBool('Settings', 'Minimized to Tray After Word', ch2.Checked);
ch3.Checked := Ini.ReadBool('Settings', 'Always on Top', ch3.Checked);
ch4.Checked := Ini.ReadBool('Settings', 'Start with Windows OS Startup', ch4.Checked);
ch5.Checked := Ini.ReadBool('Settings', 'Write Items in Bold', ch5.Checked);
ch6.Checked := Ini.ReadBool('Settings', 'Save Window Position', ch6.Checked);
ch7.Checked := Ini.ReadBool('Settings', 'Use of XP Menu', ch7.Checked);
ch8.Checked := Ini.ReadBool('Settings', 'Confirmation Exit', ch8.Checked);
ch9.Checked := Ini.ReadBool('Settings', 'Invisible Images in the Menu', ch9.Checked);
LangCombo.ItemIndex := Ini.ReadInteger('Language', 'Int', LangCombo.ItemIndex);
DblClkCombo.ItemIndex := Ini.ReadInteger('DblClk', 'Int', DblClkCombo.ItemIndex);
ColorDlg1.Color := Ini.ReadInteger('Color', 'Window', ColorDlg1.Color);
ColorDlg2.Color := Ini.ReadInteger('Color', 'Font', ColorDlg2.Color);
TextName.Text := Ini.ReadString('Shortcut name', 'Name', TextName.Text);
except
end;
r:=TRegistry.Create;
r.RootKey:=HKEY_LOCAL_MACHINE;
r.OpenKey('\Software\Microsoft\Windows NT\CurrentVersion', True);
txt24.Caption := r.ReadString('ProductName');
GlobalMemoryStatus(MS);
txt25.Caption := 'Memory Available to Windows: ' + FormatFloat('#,###" KB"', MS.dwTotalPhys / 1024);
Size:= 55;
if getcomputername(NameComp, Size) then
txt18.Caption := NameComp else
txt18.Caption := '';
Size:= 55;
if getusername(NameUser, Size) then
txt17.Caption := NameUser else
txt17.Caption := '';
end;

procedure TSettingsForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
Shift: TShiftState; X, Y: Integer);
begin
ReleaseCapture;
Perform(Wm_SysCommand, $f012, 0);
end;

procedure TSettingsForm.CancelClick(Sender: TObject);
begin
Ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
try
ch1.Checked := Ini.ReadBool('Settings', 'Close Program After Each Word', ch1.Checked);
ch2.Checked := Ini.ReadBool('Settings', 'Minimized to Tray After Word', ch2.Checked);
ch3.Checked := Ini.ReadBool('Settings', 'Always on Top', ch3.Checked);
ch4.Checked := Ini.ReadBool('Settings', 'Start with Windows OS Startup', ch4.Checked);
ch5.Checked := Ini.ReadBool('Settings', 'Write Items in Bold', ch5.Checked);
ch6.Checked := Ini.ReadBool('Settings', 'Save Window Position', ch6.Checked);
ch7.Checked := Ini.ReadBool('Settings', 'Use of XP Menu', ch7.Checked);
ch8.Checked := Ini.ReadBool('Settings', 'Confirmation Exit', ch8.Checked);
ch9.Checked := Ini.ReadBool('Settings', 'Invisible Images in the Menu', ch9.Checked);
LangCombo.ItemIndex := Ini.ReadInteger('Language', 'Int', LangCombo.ItemIndex);
DblClkCombo.ItemIndex := Ini.ReadInteger('DblClk', 'Int', DblClkCombo.ItemIndex);
ColorDlg1.Color := Ini.ReadInteger('Color', 'Window', ColorDlg1.Color);
ColorDlg2.Color := Ini.ReadInteger('Color', 'Font', ColorDlg2.Color);
TextName.Text := Ini.ReadString('Shortcut name', 'Name', TextName.Text);
except
end;
end;

procedure TSettingsForm.txt8Click(Sender: TObject);
begin
PostMessage(Handle, WM_USER + 1024, 0, 0);
if ColorDlg2.Execute then
begin
MainForm.lb1.Font.Color := ColorDlg2.Color;
MainForm.ed.Font.Color := ColorDlg2.Color;
txt8.ForegroundColor := ColorDlg2.Color;
end;
end;

procedure TSettingsForm.txt7Click(Sender: TObject);
begin
PostMessage(Handle, WM_USER + 1024, 0, 0);
if ColorDlg1.Execute then
begin
MainForm.Color := ColorDlg1.Color;
txt7.ForegroundColor := ColorDlg1.Color;
end;
end;

procedure TSettingsForm.FormShow(Sender: TObject);
begin
MainForm.SettingsItem.Enabled := False;
MainForm.AboutItem.Enabled := False;
MainForm.LicenseItem.Enabled := False;
if Length(TextName.Text) = 0 then
begin
txt2.Enabled := False;
txt3.Enabled := False;
txt4.Enabled := False;
txt5.Enabled := False;
txt6.Enabled := False;
end else
begin
txt2.Enabled := True;
txt3.Enabled := True;
txt4.Enabled := True;
txt5.Enabled := True;
txt6.Enabled := True;
end;
if LangCombo.ItemIndex  = -1 then
LangCombo.ItemIndex := 0;
if DblClkCombo.ItemIndex  = -1 then
DblClkCombo.ItemIndex := 0;
end;

procedure TSettingsForm.txt2Click(Sender: TObject);
begin
ShellObject:=CreateComObject(CLSID_ShellLink);
LinkFile:=ShellObject as IPersistFile;
ShellLink:=ShellObject as IShellLink;
FileName:=ParamStr(0);
ShellLink.SetPath(pchar(FileName));
ShellLink.SetWorkingDirectory(pchar(ExtractFilePath(FileName)));
if SHGetSpecialFolderLocation(Handle,CSIDL_DESKTOP,P)=NOERROR then begin
SHGetPathFromIDList(P,C);
ShortcutPosition:=StrPas(C);
PostMessage(Handle, WM_USER + 1024, 0, 0);
if LangCombo.ItemIndex = 0 then
if Application.MessageBox(PChar('Do you want a shortcut "' + TextName.Text + '" to your Desktop?'),
'Executor',
Mb_IconQuestion + mb_YesNo) = IdYes then
ShortcutPosition:=ShortcutPosition+'\'+ TextName.Text + '.lnk';
if LangCombo.ItemIndex = 1 then
if Application.MessageBox(PChar('Вы хотите разместить ярлык "' + TextName.Text + '" на Рабочем Столе?'),
'Executor',
Mb_IconQuestion + mb_YesNo) = IdYes then
ShortcutPosition:=ShortcutPosition+'\'+ TextName.Text + '.lnk';
WShortcutPosition:=ShortcutPosition;
LinkFile.Save(PWChar(WShortcutPosition),False);
end;
end;

procedure TSettingsForm.txt3Click(Sender: TObject);
begin
ShellObject:=CreateComObject(CLSID_ShellLink);
LinkFile:=ShellObject as IPersistFile;
ShellLink:=ShellObject as IShellLink;
FileName:=ParamStr(0);
ShellLink.SetPath(pchar(FileName));
ShellLink.SetWorkingDirectory(pchar(ExtractFilePath(FileName)));
if SHGetSpecialFolderLocation(Handle,CSIDL_STARTMENU,P)=NOERROR then begin
SHGetPathFromIDList(P,C);
ShortcutPosition:=StrPas(C);
PostMessage(Handle, WM_USER + 1024, 0, 0);
if LangCombo.ItemIndex = 0 then
if Application.MessageBox(PChar('Do you want a shortcut "' + TextName.Text + '" to your Start Menu?'),
'Executor',
Mb_IconQuestion + mb_YesNo) = IdYes then
ShortcutPosition:=ShortcutPosition+'\'+ TextName.Text + '.lnk';
if LangCombo.ItemIndex = 1 then
if Application.MessageBox(PChar('Вы хотите разместить ярлык "' + TextName.Text + '" в Главном Меню?'),
'Executor',
Mb_IconQuestion + mb_YesNo) = IdYes then
ShortcutPosition:=ShortcutPosition+'\'+ TextName.Text + '.lnk';
WShortcutPosition:=ShortcutPosition;
LinkFile.Save(PWChar(WShortcutPosition),False);
end;
end;

procedure TSettingsForm.txt4Click(Sender: TObject);
begin
ShellObject:=CreateComObject(CLSID_ShellLink);
LinkFile:=ShellObject as IPersistFile;
ShellLink:=ShellObject as IShellLink;
FileName:=ParamStr(0);
ShellLink.SetPath(pchar(FileName));
ShellLink.SetWorkingDirectory(pchar(ExtractFilePath(FileName)));
if SHGetSpecialFolderLocation(Handle,CSIDL_PROGRAMS,P)=NOERROR then begin
SHGetPathFromIDList(P,C);
ShortcutPosition:=StrPas(C);
PostMessage(Handle, WM_USER + 1024, 0, 0);
if LangCombo.ItemIndex = 0 then
if Application.MessageBox(PChar('Do you want a shortcut "' + TextName.Text + '" to your Programs Menu?'),
'Executor',
Mb_IconQuestion + mb_YesNo) = IdYes then
ShortcutPosition:=ShortcutPosition+'\'+ TextName.Text + '.lnk';
if LangCombo.ItemIndex = 1 then
if Application.MessageBox(PChar('Вы хотите разместить ярлык "' + TextName.Text + '" в Меню Программы?'),
'Executor',
Mb_IconQuestion + mb_YesNo) = IdYes then
ShortcutPosition:=ShortcutPosition+'\'+ TextName.Text + '.lnk';
WShortcutPosition:=ShortcutPosition;
LinkFile.Save(PWChar(WShortcutPosition),False);
end;
end;

procedure TSettingsForm.txt5Click(Sender: TObject);
begin
ShellObject:=CreateComObject(CLSID_ShellLink);
LinkFile:=ShellObject as IPersistFile;
ShellLink:=ShellObject as IShellLink;
FileName:=ParamStr(0);
ShellLink.SetPath(pchar(FileName));
ShellLink.SetWorkingDirectory(pchar(ExtractFilePath(FileName)));
if SHGetSpecialFolderLocation(Handle,CSIDL_STARTUP,P)=NOERROR then begin
SHGetPathFromIDList(P,C);
ShortcutPosition:=StrPas(C);
PostMessage(Handle, WM_USER + 1024, 0, 0);
if LangCombo.ItemIndex = 0 then
if Application.MessageBox(PChar('Do you want a shortcut "' + TextName.Text + '" to your Startup folder?'),
'Executor',
Mb_IconQuestion + mb_YesNo) = IdYes then
ShortcutPosition:=ShortcutPosition+'\'+ TextName.Text + '.lnk';
if LangCombo.ItemIndex = 1 then
if Application.MessageBox(PChar('Вы хотите разместить ярлык "' + TextName.Text + '" в папке Автозагрузки?'),
'Executor',
Mb_IconQuestion + mb_YesNo) = IdYes then
ShortcutPosition:=ShortcutPosition+'\'+ TextName.Text + '.lnk';
WShortcutPosition:=ShortcutPosition;
LinkFile.Save(PWChar(WShortcutPosition),False);
end;
end;

procedure TSettingsForm.txt6Click(Sender: TObject);
begin
ShellObject:=CreateComObject(CLSID_ShellLink);
LinkFile:=ShellObject as IPersistFile;
ShellLink:=ShellObject as IShellLink;
FileName:=ParamStr(0);
ShellLink.SetPath(pchar(FileName));
ShellLink.SetWorkingDirectory(pchar(ExtractFilePath(FileName)));
if SHGetSpecialFolderLocation(Handle,CSIDL_FAVORITES,P)=NOERROR then begin
SHGetPathFromIDList(P,C);
ShortcutPosition:=StrPas(C);
PostMessage(Handle, WM_USER + 1024, 0, 0);
if LangCombo.ItemIndex = 0 then
if Application.MessageBox(PChar('Do you want a shortcut "' + TextName.Text + '" to your Favorites?'),
'Executor',
Mb_IconQuestion + mb_YesNo) = IdYes then
ShortcutPosition:=ShortcutPosition+'\'+ TextName.Text + '.lnk';
if LangCombo.ItemIndex = 1 then
if Application.MessageBox(PChar('Вы хотите разместить ярлык "' + TextName.Text + '" в Избранном?'),
'Executor',
Mb_IconQuestion + mb_YesNo) = IdYes then
ShortcutPosition:=ShortcutPosition+'\'+ TextName.Text + '.lnk';
WShortcutPosition:=ShortcutPosition;
LinkFile.Save(PWChar(WShortcutPosition),False);
end;
end;

procedure TSettingsForm.LangComboChange(Sender: TObject);
begin
Ini.WriteInteger('DblClk', 'Int', SettingsForm.DblClkCombo.ItemIndex);
if SettingsForm.LangCombo.ItemIndex = 1 then
begin
MainForm.txt1.Caption := 'Командная строка:';
MainForm.txt2.Caption := 'Основные параметры:';
MainForm.txt3.Caption := 'Ваши сохраненные параметры:';
MainForm.ShowWindowItem.Caption := 'Показать окно';
MainForm.HideWindowItem.Caption := 'Спрятать окно';
MainForm.HideParamItem.Caption := 'Спрятать параметры';
MainForm.SettingsItem.Caption := 'Настройки...';
MainForm.BrowseItem.Caption := 'Обзор...';
MainForm.MoreItem.Caption := 'Еще';
MainForm.ImportMainParametersItem.Caption := 'Импорт основных параметров';
MainForm.QuickPrintItem.Caption := 'Быстрая печать...';
MainForm.ImportAdditionalParametersItem.Caption := 'Импорт ваших параметров';
MainForm.QuickPrint2Item.Caption := 'Быстрая печать...';
MainForm.MinimizedItem.Caption := 'Свернуть';
MainForm.RunItem.Caption := 'Выполнить...';
MainForm.DeleteallyourParametersItem.Caption := 'Удалить все ваши сохраненные параметры';
MainForm.DeleteselectStringinyourParametersItem.Caption := 'Удалить выделенную строку из ваших параметров';
MainForm.AboutItem.Caption := 'О программе...';
MainForm.SysInfoItem.Caption := 'Сведения о системе...';
MainForm.LicenseItem.Caption := 'Лицензия';
MainForm.SourceCodeItem.Caption := 'Исходный код...';
MainForm.SendItem.Caption := 'Обратная связь';
MainForm.MemoryStatItem.Caption := 'Статистика памяти';
MainForm.ExitItem.Caption := 'Выход';
SettingsForm.Caption := 'Параметры';
SettingsForm.Tab1.Caption := 'Настройка';
SettingsForm.Tab2.Caption := 'Лицензионное соглашение';
SettingsForm.Tab3.Caption := 'О программе';
SettingsForm.fr1.Caption := 'Настройка окон';
SettingsForm.fr2.Caption := 'Ярлык';
SettingsForm.fr3.Caption := 'Общие';
SettingsForm.fr4.Caption := 'Цвет';
SettingsForm.fr5.Caption := 'Выбрать язык';
SettingsForm.fr6.Caption := 'При двойном щелчке';
SettingsForm.ch1.Caption := 'Закрыть после выполнения';
SettingsForm.ch2.Caption := 'Сворачить после выполнения';
SettingsForm.ch3.Caption := 'Всегда впереди';
SettingsForm.ch4.Caption := 'Запускать вместе с Windows';
SettingsForm.ch5.Caption := 'Жирный цвет шрифта';
SettingsForm.ch6.Caption := 'Сохранять позицию окна';
SettingsForm.ch7.Caption := 'Использовать XP меню';
SettingsForm.ch8.Caption := 'Подтверждение выхода';
SettingsForm.ch9.Caption := 'Убрать рисунки из меню';
SettingsForm.txt1.Caption := 'Введите имя:';
SettingsForm.txt2.Caption := 'На Рабочем Столе';
SettingsForm.txt3.Caption := 'В Меню Пуск';
SettingsForm.txt4.Caption := 'В Меню Программы';
SettingsForm.txt5.Caption := 'В Автозагрузку';
SettingsForm.txt6.Caption := 'В Избранном';
SettingsForm.txt7.Caption := 'Цвет окна';
SettingsForm.txt8.Caption := 'Цвет шрифта';
SettingsForm.txt11.Caption := 'для Windows 95/98/NT/2000/XP/Vista';
SettingsForm.txt12.Caption := 'Copyright @2009 Домани Олег (aka ?КТО_Я?)';
SettingsForm.txt13.Caption := 'Пермская область, г. Чайковский';
SettingsForm.txt14.Caption := 'Обладателем лицензии на этот продукт является:';
SettingsForm.txt19.Caption := 'Лицензионное соглашение';
SettingsForm.txt15.Caption := 'Ф.И.О:';
SettingsForm.txt16.Caption := 'Имя компьютера:';
SettingsForm.txt26.Caption := 'Восстановить все настройки по умолчанию';
DblClkCombo.Clear;
DblClkCombo.Items.Add('Нет действия');
DblClkCombo.Items.Add('Открыть настройки');
DblClkCombo.Items.Add('Скрыть\показать параметры');
DblClkCombo.ItemIndex := Ini.ReadInteger('DblClk', 'Int', DblClkCombo.ItemIndex);
OK.Caption := 'OK';
Cancel.Caption := 'Отмена';
end;
if SettingsForm.LangCombo.ItemIndex = 0 then
begin
MainForm.txt1.Caption := 'Command Line:';
MainForm.txt2.Caption := 'Main parameters program:';
MainForm.txt3.Caption := 'Save your parameters:';
MainForm.ShowWindowItem.Caption := 'Show Window';
MainForm.HideWindowItem.Caption := 'Hide Window';
MainForm.HideParamItem.Caption := 'Hide Parameters';
MainForm.SettingsItem.Caption := 'Preferences...';
MainForm.BrowseItem.Caption := 'Browse...';
MainForm.MoreItem.Caption := 'More';
MainForm.ImportMainParametersItem.Caption := 'Import Main Parameters';
MainForm.QuickPrintItem.Caption := 'Quick Print...';
MainForm.ImportAdditionalParametersItem.Caption := 'Import your Parameters';
MainForm.QuickPrint2Item.Caption := 'Quick Print...';
MainForm.MinimizedItem.Caption := 'Minimize';
MainForm.RunItem.Caption := 'Run...';
MainForm.DeleteallyourParametersItem.Caption := 'Delete all your Parameters';
MainForm.DeleteselectStringinyourParametersItem.Caption := 'Delete select string in your Parameters';
MainForm.AboutItem.Caption := 'About...';
MainForm.SysInfoItem.Caption := 'System Information...';
MainForm.LicenseItem.Caption := 'License';
MainForm.SourceCodeItem.Caption := 'Source Code...';
MainForm.SendItem.Caption := 'Send feedback';
MainForm.MemoryStatItem.Caption := 'Memory statistics';
MainForm.ExitItem.Caption := 'Exit';
SettingsForm.Caption := 'Preferences';
SettingsForm.Tab1.Caption := 'Preferences';
SettingsForm.Tab2.Caption := 'License agreement';
SettingsForm.Tab3.Caption := 'About "Executor"';
SettingsForm.fr1.Caption := 'Windows Settings';
SettingsForm.fr2.Caption := 'Shortcut';
SettingsForm.fr3.Caption := 'General';
SettingsForm.fr4.Caption := 'Color';
SettingsForm.fr5.Caption := 'Choose language';
SettingsForm.fr6.Caption := 'On Double Click';
SettingsForm.ch1.Caption := 'Close program after each word';
SettingsForm.ch2.Caption := 'Minimize to tray after word';
SettingsForm.ch3.Caption := 'Always on Top';
SettingsForm.ch4.Caption := 'Start with Windows OS Startup';
SettingsForm.ch5.Caption := 'Write Items in Bold';
SettingsForm.ch6.Caption := 'Invisible images in the menu';
SettingsForm.ch7.Caption := 'Use of XP Menu';
SettingsForm.ch8.Caption := 'Confirmation exit';
SettingsForm.ch9.Caption := 'Invisible Images in the Menu';
SettingsForm.txt1.Caption := 'Input a Name:';
SettingsForm.txt2.Caption := 'Add to Desktop';
SettingsForm.txt3.Caption := 'Add to Start Menu';
SettingsForm.txt4.Caption := 'Add to Programs Menu';
SettingsForm.txt5.Caption := 'Add to Startup';
SettingsForm.txt6.Caption := 'Add to Favorites';
SettingsForm.txt7.Caption := 'Window Color';
SettingsForm.txt8.Caption := 'Text Color';
SettingsForm.txt11.Caption := 'for Windows 95/98/NT/2000/XP/Vista';
SettingsForm.txt12.Caption := 'Copyright @2009 Domani Oleg (aka ?КТО_Я?)';
SettingsForm.txt13.Caption := 'Perm region, Chaykovskiy city';
SettingsForm.txt14.Caption := 'Possessor of license on this product is given:';
SettingsForm.txt19.Caption := 'License Agreement';
SettingsForm.txt15.Caption := 'Name:';
SettingsForm.txt16.Caption := 'Computer name:';
SettingsForm.txt26.Caption := 'Reset all Settings';
DblClkCombo.Clear;
DblClkCombo.Items.Add('None');
DblClkCombo.Items.Add('Open the Preferences');
DblClkCombo.Items.Add('Show\Hide Paramters');
DblClkCombo.ItemIndex := Ini.ReadInteger('DblClk', 'Int', DblClkCombo.ItemIndex);
OK.Caption := 'OK';
Cancel.Caption := 'Cancel';
end;
end;

procedure TSettingsForm.FormDestroy(Sender: TObject);
begin
SettingsForm.OnActivate := nil;
DblClkCombo.Free;
PageControl.Free;
LicenseText.Free;
LangCombo.Free;
ColorDlg2.Free;
ColorDlg1.Free;
TextName.Free;
logo.Free;
tab1.Free;
tab2.Free;
tab3.Free;
Cancel.Free;
OK.Free;
Ini.Free;
fr1.Free;
fr2.Free;
fr3.Free;
fr4.Free;
fr5.Free;
fr6.Free;
fr7.Free;
fr8.Free;
ch1.Free;
ch2.Free;
ch3.Free;
ch4.Free;
ch5.Free;
ch6.Free;
ch7.Free;
ch8.Free;
ch9.Free;
txt1.Free;
txt2.Free;
txt3.Free;
txt4.Free;
txt5.Free;
txt6.Free;
txt7.Free;
txt8.Free;
txt9.Free;
txt10.Free;
txt11.Free;
txt12.Free;
txt13.Free;
txt14.Free;
txt15.Free;
txt16.Free;
txt17.Free;
txt18.Free;
txt19.Free;
txt20.Free;
txt21.Free;
txt22.Free;
txt23.Free;
txt24.Free;
txt25.Free;
txt26.Free;
end;

procedure TSettingsForm.txt19Click(Sender: TObject);
begin
PageControl.ActivePageIndex := 1;
end;

procedure TSettingsForm.ch7Click(Sender: TObject);
begin
if SettingsForm.LangCombo.ItemIndex = 1 then
begin
PostMessage(Handle, WM_USER + 1024, 0, 0);
Application.MessageBox('Изменения темы вступят в силу, когда Вы перезапустите Executor!',
'Применение Темы',
mb_IconExclamation + mb_OK);
end;
if SettingsForm.LangCombo.ItemIndex = 0 then
begin
PostMessage(Handle, WM_USER + 1024, 0, 0);
Application.MessageBox('Theme changes will take effect when you restart Executor!',
'Apply Theme',
mb_IconExclamation + mb_OK);
end;
end;

procedure TSettingsForm.TextNameChange(Sender: TObject);
begin
if Length(TextName.Text) = 0 then
begin
txt2.Enabled := False;
txt3.Enabled := False;
txt4.Enabled := False;
txt5.Enabled := False;
txt6.Enabled := False;
end else
begin
txt2.Enabled := True;
txt3.Enabled := True;
txt4.Enabled := True;
txt5.Enabled := True;
txt6.Enabled := True;
end;
end;

procedure TSettingsForm.CMMouseLeave(var msg: TMessage);
begin
txt19.ForegroundColor := $00FF8000;
txt19.Font.Style:= [];
txt20.ForegroundColor := $00FF8000;
txt20.Font.Style:= [];
txt21.ForegroundColor := $00FF8000;
txt21.Font.Style:= [];
txt22.ForegroundColor := $00FF8000;
txt22.Font.Style:= [];
txt26.ForegroundColor := $00FF8000;
txt26.Font.Style:= [];
end;

procedure TSettingsForm.txt21MouseUp(Sender: TObject; Button: TMouseButton;
Shift: TShiftState; X, Y: Integer);
begin
txt21.ForegroundColor := $00FF8000;
txt21.Font.Style:= [];
end;

procedure TSettingsForm.txt21MouseLeave(Sender: TObject);
begin
txt21.ForegroundColor := $00FF8000;
txt21.Font.Style:= [];
end;

procedure TSettingsForm.txt21MouseMove(Sender: TObject; Shift: TShiftState;
X, Y: Integer);
begin
txt21.ForegroundColor := clRed;
txt21.Font.Style:= [fsUnderline];
end;

procedure TSettingsForm.txt21Click(Sender: TObject);
begin
ShellExecute(Handle, nil, 'Mailto:GoodWinNix@mail.ru',
nil, nil, Sw_ShowNormal);
end;

procedure TSettingsForm.FormKeyDown(Sender: TObject; var Key: Word;
Shift: TShiftState);
begin
if Key = vk_Escape then
SettingsForm.Close;
end;

procedure TSettingsForm.ChangeMessageBoxPosition(var Msg: TMessage);
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
x := SettingsForm.Left + ((SettingsForm.Width - w) div 2);
if x < 0 then
x := 0
else if x + w > Screen.Width then x := Screen.Width - w;
y := SettingsForm.Top + ((SettingsForm.Height - h) div 2);
if y < 0 then y := 0
else if y + h > Screen.Height then y := Screen.Height - h;
SetWindowPos(MBHWnd, 0, x, y, 0, 0, SWP_NOACTIVATE or SWP_NOSIZE or SWP_NOZORDER);
end;
end;

procedure TSettingsForm.txt26Click(Sender: TObject);
begin
try
PostMessage(Handle, WM_USER + 1024, 0, 0);
if LangCombo.ItemIndex = 0 then
if Application.MessageBox('Are you sure, what do you want to restore all settings?',
'Executor',
mb_IconQuestion + mb_YesNo) = idYes then
begin
Ch1.Checked := False;
Ch2.Checked := True;
Ch3.Checked := False;
Ch4.Checked := False;
Ch5.Checked := False;
Ch6.Checked := True;
Ch7.Checked := True;
Ch8.Checked := False;
Ch9.Checked := False;
ColorDlg1.Color := clSilver;
ColorDlg2.Color := clBlack;
MainForm.Color := clSilver;
MainForm.Lb1.Font.Color := clBlack;
MainForm.ed.Font.Color := clBlack;
txt7.ForegroundColor := ColorDlg1.Color;
txt8.ForegroundColor := ColorDlg2.Color;
LangCombo.ItemIndex := 0;
LangCombo.OnChange(Self);
DblClkCombo.ItemIndex := 0;
DblClkCombo.OnChange(nil);
TextName.Text := 'Executor';
end;
if LangCombo.ItemIndex = 1 then
if Application.MessageBox('Вы уверены, что хотите восстановить все настройки по умолчанию?',
'Executor',
mb_IconQuestion + mb_YesNo) = idYes then
begin
Ch1.Checked := False;
Ch2.Checked := True;
Ch3.Checked := False;
Ch4.Checked := False;
Ch5.Checked := False;
Ch6.Checked := True;
Ch7.Checked := True;
Ch8.Checked := False;
Ch9.Checked := False;
ColorDlg1.Color := clSilver;
ColorDlg2.Color := clBlack;
MainForm.Color := clSilver;
MainForm.Lb1.Font.Color := clBlack;
MainForm.ed.Font.Color := clBlack;
txt7.ForegroundColor := ColorDlg1.Color;
txt8.ForegroundColor := ColorDlg2.Color;
LangCombo.ItemIndex := 0;
LangCombo.OnChange(Self);
DblClkCombo.ItemIndex := 0;
DblClkCombo.OnChange(nil);
TextName.Text := 'Executor';
end;
except
end;
end;

procedure TSettingsForm.DblClkComboCloseUp(Sender: TObject);
begin
Ini.WriteInteger('DblClk', 'Int', SettingsForm.DblClkCombo.ItemIndex);
end;

procedure TSettingsForm.txt20Click(Sender: TObject);
begin
ShellExecute(Handle, nil, 'http://www.viacoding.mylivepage.ru/', nil,nil, Sw_ShowNormal);
end;

procedure TSettingsForm.txt20MouseLeave(Sender: TObject);
begin
txt20.ForegroundColor := $00FF8000;
txt20.Font.Style:= [];
end;

procedure TSettingsForm.txt20MouseUp(Sender: TObject;
Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
txt20.ForegroundColor := $00FF8000;
txt20.Font.Style:= [];
end;

procedure TSettingsForm.txt20MouseMove(Sender: TObject;
Shift: TShiftState; X, Y: Integer);
begin
txt20.ForegroundColor := clRed;
txt20.Font.Style:= [fsUnderline];
end;

procedure TSettingsForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
try
MainForm.SettingsItem.Enabled := True;
MainForm.AboutItem.Enabled := True;
MainForm.LicenseItem.Enabled := True;
Cancel.OnClick(Self);
Cancel.SetFocus;
except
end;
end;

procedure TSettingsForm.txt19MouseLeave(Sender: TObject);
begin
txt19.ForegroundColor := $00FF8000;
txt19.Font.Style:= [];
end;

procedure TSettingsForm.txt19MouseUp(Sender: TObject; Button: TMouseButton;
Shift: TShiftState; X, Y: Integer);
begin
txt19.ForegroundColor := $00FF8000;
txt19.Font.Style:= [];
end;

procedure TSettingsForm.txt19MouseMove(Sender: TObject; Shift: TShiftState;
X, Y: Integer);
begin
txt19.ForegroundColor := clRed;
txt19.Font.Style:= [fsUnderline];
end;

procedure TSettingsForm.txt26MouseLeave(Sender: TObject);
begin
txt26.ForegroundColor := $00FF8000;
txt26.Font.Style:= [];
end;

procedure TSettingsForm.txt26MouseUp(Sender: TObject; Button: TMouseButton;
Shift: TShiftState; X, Y: Integer);
begin
txt26.ForegroundColor := $00FF8000;
txt26.Font.Style:= [];
end;

procedure TSettingsForm.txt26MouseMove(Sender: TObject; Shift: TShiftState;
X, Y: Integer);
begin
txt26.ForegroundColor := clRed;
txt26.Font.Style:= [fsUnderline];
end;

procedure TSettingsForm.txt22Click(Sender: TObject);
begin
ShellExecute(Handle, nil, 'viacoding:GoodWinNix@mail.ru',
nil, nil, Sw_ShowNormal);
end;

procedure TSettingsForm.OKClick(Sender: TObject);
var
R: TRegistry;
begin
R := TRegistry.Create;
R.RootKey := HKEY_LOCAL_MACHINE;
R.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', false);
if Ch4.Checked then
R.WriteString(Application.Title, ParamStr(0)) else
R.DeleteValue(Application.Title);
R.Free;
if ch5.Checked then
begin
MainForm.lb1.Font.Style := [fsBold];
end else
MainForm.lb1.Font.Style := [];
if Ch9.Checked then
MainForm.PopupMenu.Images := MainForm.ImageList2 else
MainForm.PopupMenu.Images := MainForm.ImageList1;
MainForm.T1.Enabled := True;
SettingsForm.Close;
end;

procedure TSettingsForm.txt22MouseLeave(Sender: TObject);
begin
txt22.ForegroundColor := $00FF8000;
txt22.Font.Style:= [];
end;

procedure TSettingsForm.txt22MouseUp(Sender: TObject;
Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
txt22.ForegroundColor := $00FF8000;
txt22.Font.Style:= [];
end;

procedure TSettingsForm.txt22MouseMove(Sender: TObject;
Shift: TShiftState; X, Y: Integer);
begin
txt22.ForegroundColor := clRed;
txt22.Font.Style:= [fsUnderline];
end;

end.
