unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ComCtrls, SynEdit, lclintf, StdCtrls, types, ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    ImageList1: TImageList;
    MainMenu1: TMainMenu;
    MenuFiles: TMenuItem;
    MenuEdit: TMenuItem;
    MenuConf: TMenuItem;
    MenuHelp: TMenuItem;
    MenuFileExit: TMenuItem;
    MenuEditCut: TMenuItem;
    MenuEditPaste: TMenuItem;
    MenuEditCopy: TMenuItem;
    MenuConfGeneral: TMenuItem;
    MenuHelpAbout: TMenuItem;
    MenuEditDelete: TMenuItem;
    MenuHelpSite: TMenuItem;
    MenuFileClose: TMenuItem;
    MenuFileNew: TMenuItem;
    MenuFileSave: TMenuItem;
    MenuFileSaveAs: TMenuItem;
    MenuItem1: TMenuItem;
    MenuFileSaveAll: TMenuItem;
    MenuItem2: TMenuItem;
    MenuEditPrint: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuOpenFile: TMenuItem;
    MenuItem8: TMenuItem;
    MenuViewShowBar: TMenuItem;
    MenuView: TMenuItem;
    OpenDialog1: TOpenDialog;
    PageControl: TPageControl;
    PopupMenu1: TPopupMenu;
    SaveDialog1: TSaveDialog;
    SynEdit1: TSynEdit;
    TabSheet1: TTabSheet;
    ToolBar: TToolBar;
    ToolButton1: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton15: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    procedure MenuConfGeneralClick(Sender: TObject);
    procedure MenuFileCloseClick(Sender: TObject);
    procedure MenuFileExitClick(Sender: TObject);
    procedure MenuFileNewClick(Sender: TObject);
    procedure MenuFileSaveAsClick(Sender: TObject);
    procedure MenuFileSaveClick(Sender: TObject);
    procedure MenuHelpAboutClick(Sender: TObject);
    procedure MenuHelpSiteClick(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuOpenFileClick(Sender: TObject);
    procedure MenuViewShowBarClick(Sender: TObject);
    procedure PageControlMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure PageControlMouseLeave(Sender: TObject);
    procedure PageControlMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure PageControlMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

const
  version: string = '0.1 alpha';

var
  dragflag: boolean = False;
  RightTab: integer;

implementation

{$R *.lfm}

// Формы
uses Settings;


{ TForm1 }

procedure TForm1.MenuViewShowBarClick(Sender: TObject);
begin
  if MenuViewShowBar.Checked = False then
    ToolBar.Visible := False
  else
    ToolBar.Visible := True;
end;


/////////////
procedure TForm1.PageControlMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if Button = mbRight then
  begin
    RightTab := PageControl.TabIndexAtClientPos(PageControl.ScreenToClient(Mouse.CursorPos));
    exit;
    //PageControl.BeginDrag(True);
  end;

  dragflag := True;
end;

procedure TForm1.PageControlMouseLeave(Sender: TObject);
begin
  dragflag := False;
end;

procedure TForm1.PageControlMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);

begin
  if dragflag = True then
    if PageControl.TabIndexAtClientPos(Classes.Point(X, Y)) <> -1 then
      PageControl.ActivePage.PageIndex :=
        PageControl.TabIndexAtClientPos(Classes.Point(X, Y));
end;

procedure TForm1.PageControlMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  dragflag := False;
end;

procedure TForm1.MenuFileCloseClick(Sender: TObject);
begin
  if PageControl.PageCount > 1 then
    PageControl.Pages[PageControl.PageIndex].Free;
end;

procedure TForm1.MenuConfGeneralClick(Sender: TObject);
begin
  FormSettings.Show;
end;

procedure TForm1.MenuFileExitClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.MenuFileNewClick(Sender: TObject);
var
  TabSheet: TTabSheet;
  SynEdit: TSynEdit;
begin
  TabSheet := TTabSheet.Create(PageControl);
  TabSheet.Caption := 'New ' + IntToStr(PageControl.PageCount{ + 1});
  TabSheet.PageControl := PageControl;
  SynEdit := TSynEdit.Create(TabSheet);
  SynEdit.Parent := TabSheet;
  SynEdit.Align := alClient;
  PageControl.PageIndex := PageControl.PageCount - 1;
end;

procedure TForm1.MenuFileSaveAsClick(Sender: TObject);
var
  i: integer;
begin
  if SaveDialog1.Execute then
    if (PageControl.ActivePage.ComponentCount > 0) then
      (PageControl.ActivePage.Components[0] as TSynEdit).Lines.SaveToFile(SaveDialog1.FileName)
    else
      SynEdit1.Lines.SaveToFile(ExtractFileName( SaveDialog1.FileName ));
end;

procedure TForm1.MenuFileSaveClick(Sender: TObject);
begin
  //SaveDialog1.Execute;
  SaveDialog1.FileName:=OpenDialog1.FileName;
  if SaveDialog1.Execute then
  //if MessageDlg('Question','Save current file ?',mtConfirmation,mbYesNo,'')=mrYes then
  begin
    SynEdit1.Lines.SaveToFile(SaveDialog1.FileName);
  end;
end;

procedure TForm1.MenuHelpAboutClick(Sender: TObject);
begin
  MessageDlg('NotepadX', 'NotepadX version ' + version + ' - is a text editor.'+#13#10
  +'Author: XakeR.',
    mtInformation, [mbOK], 0);
end;

procedure TForm1.MenuHelpSiteClick(Sender: TObject);
begin
  OpenURL('http://xakz.ru/notepadx/');
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
  //if PageControl.TabIndexAtClientPos(PageControl.ScreenToClient(Mouse.CursorPos)) <> -1 then
  if PageControl.PageCount > 1 then
    PageControl.Pages[RightTab].Free;
end;

procedure TForm1.MenuOpenFileClick(Sender: TObject);
var
  TabSheet: TTabSheet;
  SynEdit: TSynEdit;
begin
  {if OpenDialog1.Execute then
    if (PageControl.PageCount > 1) then
    begin
      TabSheet := TTabSheet.Create(PageControl);
      TabSheet.Caption := ExtractFileName(OpenDialog1.FileName);
      // ;'New ' + IntToStr(PageControl.PageCount{ + 1});
      TabSheet.PageControl := PageControl;
      SynEdit := TSynEdit.Create(TabSheet);
      SynEdit.Parent := TabSheet;
      SynEdit.Align := alClient;
      PageControl.PageIndex := PageControl.PageCount - 1;
      SynEdit.Lines.LoadFromFile(OpenDialog1.FileName);
    end
    else
    begin
      PageControl.ActivePage.Caption := ExtractFileName(OpenDialog1.FileName);
      //(PageControl.ActivePage.Components[0] as TSynEdit).Lines.LoadFromFile(OpenDialog1.FileName);
      SynEdit1.Lines.LoadFromFile(OpenDialog1.FileName);
    end;}
//if OpenDialog1.Execute then
if MessageDlg('Question','Save current file ?',mtConfirmation,mbYesNo,'')=mrYes then
begin
  MenuFileSave.Click;
  if OpenDialog1.Execute then SynEdit1.Lines.LoadFromFile(OpenDialog1.FileName);
end
else
  if OpenDialog1.Execute then SynEdit1.Lines.LoadFromFile(OpenDialog1.FileName);
end;


end.