(*
  Brook Project Intf unit.

  Copyright (C) 2013 Silvio Clecio.

  http://silvioprog.github.io/brookframework

  All contributors:
  Plase see the file CONTRIBUTORS.txt, included in this
  distribution.

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit BrookProjectIntf;

{$i brook.inc}

interface

uses
  frmBrookNewProject, frmBrookNewBroker, frmBrookActEdit, frmBrookTable2HTMLForm,
  ProjectIntf, NewItemIntf, LazIDEIntf, Classes, SysUtils, Controls, ComCtrls,
  Forms, Dialogs;

type
  TBrookBrokersFileDescPascalUnit = class;

  { TBrookCustomSimpleCGIProjectDescriptor }

  TBrookCustomSimpleCGIProjectDescriptor = class(TProjectDescriptor)
  public
    constructor Create; override;
    function CreateStartFiles({%H-}AProject: TLazProject): TModalResult; override;
    function InitProject(AProject: TLazProject): TModalResult; override;
    function GetLocalizedName: string; override;
    function GetLocalizedDescription: string; override;
  end;

  { TBrookSimpleCGIProjectDescriptor }

  TBrookSimpleCGIProjectDescriptor = class(TBrookCustomSimpleCGIProjectDescriptor)
  protected
    procedure ConfigureBrokerItem(AItem: TBrookBrokersFileDescPascalUnit); virtual;
    procedure CreateProjectFile(AProject: TLazProject); virtual;
  public
    constructor Create; override;
    function InitProject(AProject: TLazProject): TModalResult; override;
    function CreateStartFiles({%H-}AProject: TLazProject): TModalResult; override;
    function GetLocalizedName: string; override;
    function GetLocalizedDescription: string; override;
  end;

  { TBrookSimpleFastCGIProjectDescriptor }

  TBrookSimpleFastCGIProjectDescriptor = class(TBrookSimpleCGIProjectDescriptor)
  protected
    procedure ConfigureBrokerItem(AItem: TBrookBrokersFileDescPascalUnit); override;
  public
    constructor Create; override;
    function InitProject(AProject: TLazProject): TModalResult; override;
    function GetLocalizedName: string; override;
    function GetLocalizedDescription: string; override;
  end;

  { TBrookHTTPAppProjectDescriptor }

  TBrookHTTPAppProjectDescriptor = class(TBrookSimpleCGIProjectDescriptor)
  protected
    procedure ConfigureBrokerItem(AItem: TBrookBrokersFileDescPascalUnit); override;
    procedure CreateProjectFile(AProject: TLazProject); override;
  public
    constructor Create; override;
    function InitProject(AProject: TLazProject): TModalResult; override;
    function GetLocalizedName: string; override;
    function GetLocalizedDescription: string; override;
  end;

  { TBrookHTTPDaemonProjectDescriptor }

  TBrookHTTPDaemonProjectDescriptor = class(TBrookHTTPAppProjectDescriptor)
  protected
    procedure ConfigureBrokerItem(AItem: TBrookBrokersFileDescPascalUnit); override;
  public
    constructor Create; override;
    function InitProject(AProject: TLazProject): TModalResult; override;
    function GetLocalizedName: string; override;
    function GetLocalizedDescription: string; override;
  end;

  { TBrookProjectDescriptor }

  TBrookProjectDescriptor = class(TProjectDescriptor)
  public
    constructor Create; override;
    function CreateStartFiles({%H-}AProject: TLazProject): TModalResult; override;
    function InitProject(AProject: TLazProject): TModalResult; override;
    function DoInitDescriptor: TModalResult; override;
    function GetLocalizedName: string; override;
    function GetLocalizedDescription: string; override;
  end;

  { TBrookTable2HTMLFormDescriptor }

  TBrookTable2HTMLFormDescriptor = class(TProjectDescriptor)
  public
    constructor Create; override;
    function DoInitDescriptor: TModalResult; override;
    function GetLocalizedName: string; override;
    function GetLocalizedDescription: string; override;
  end;

  { TBrookFileDescPascalUnit }

  TBrookFileDescPascalUnit = class(TFileDescPascalUnit)
  private
    FQuiet: Boolean;
  end;

  { TBrookBrokersFileDescPascalUnit }

  TBrookBrokersFileDescPascalUnit = class(TBrookFileDescPascalUnit)
  private
    FAppType: Integer;
    FAppDefCharset: Integer;
    FFullBrk: Boolean;
  public
    constructor Create; override;
    function Init(var ANewFilename: string; ANewOwner: TObject;
       var ANewSource: string; AQuiet: Boolean): TModalResult; override;
    function CreateSource({%H-}const AFileName,{%H-}ASourceName,
      {%H-}AResourceName: string): string; override;
    function GetLocalizedName: string; override;
    function GetLocalizedDescription: string; override;
  end;

  { TBrookActionFileDescPascalUnit }

  TBrookActionFileDescPascalUnit = class(TBrookFileDescPascalUnit)
  private
    FActName: string;
    FActPattern: string;
    FActDefault: Boolean;
  public
    constructor Create; override;
    function Init(var ANewFilename: string; ANewOwner: TObject;
       var ANewSource: string;{%H-}AQuiet: Boolean): TModalResult; override;
    function CreateSource({%H-}const AFileName,{%H-}ASourceName,
      {%H-}AResourceName: string): string; override;
    function GetLocalizedName: string; override;
    function GetLocalizedDescription: string; override;
    property ActName: string read FActName write FActName;
    property ActPattern: string read FActPattern write FActPattern;
    property ActDefault: Boolean read FActDefault write FActDefault;
  end;

const
  le = LineEnding;

resourcestring
  SBrookIDEItemCategoryName = 'Brook framework';
  SBrookAppName = 'Full CGI/FastCGI Application';
  SBrookAppDesc = 'Create a full CGI or FastCGI application.';
  SBrookHTTPAppName = 'Embedded server';
  SBrookHTTPAppDesc = 'Create a embedded HTTP webserver.';
  SBrookHTTPDaemonName = 'Embedded daemon server';
  SBrookHTTPDaemonDesc = 'Create a embedded daemon HTTP webserver.';
  SBrookSimpleCGIAppName = 'Simple CGI application';
  SBrookSimpleCGIAppDesc = 'Create a simple CGI application.';
  SBrookSimpleFastCGIAppName = 'Simple FastCGI application';
  SBrookSimpleFastCGIAppDesc = 'Create a simple FastCGI application.';
  SBrookTable2HTMLFormName = 'Table to HTML form';
  SBrookTable2HTMLFormDesc = 'Create a HTML form from a database table.';
  SBrookBrokersName = 'Brokers unit';
  SBrookBrokersDesc = 'Create a brokers unit.';
  SBrookActionName = 'Action unit';
  SBrookActionDesc = 'Create a action unit.';

procedure Register;
function BrookNewProjectDlg: TfrBrookNewProject;
function BrookGetExpertsConfigPath: string;
function BrookGetExpertsConfigFileName: string;

implementation

var
  _NewProjectDlg: TfrBrookNewProject;

const
  PAGE_404_TPL =
    '<html><head><title>Page not found</title><style>body{margin:0;'+
    'padding:30px;font:12px/1.5 Helvetica,Arial,Verdana,sans-serif;}h1{mar'+
    'gin:0;font-size:48px;font-weight:normal;line-height:48px;}strong{disp'+
    'lay:inline-block;width:65px;}</style></head><body><h1>404 - Page not '+
    'found</h1><br />Go to <a href="%s">home page</a> ...'+
    '</body></html>';
  PAGE_500_TPL =
    '<html><head><title>Internal server error</title><style>body{margin:0;'+
    'padding:30px;font:12px/1.5 Helvetica,Arial,Verdana,sans-serif;}h1{mar'+
    'gin:0;font-size:48px;font-weight:normal;line-height:48px;}strong{disp'+
    'lay:inline-block;width:65px;}</style></head><body><h1>500 - Internal '+
    'server error</h1><br />@error'+
    '</body></html>';

procedure Register;
begin
  RegisterNewItemCategory(TNewIDEItemCategory.Create(SBrookIDEItemCategoryName));
  RegisterProjectDescriptor(TBrookSimpleCGIProjectDescriptor.Create,
    SBrookIDEItemCategoryName);
  RegisterProjectDescriptor(TBrookSimpleFastCGIProjectDescriptor.Create,
    SBrookIDEItemCategoryName);
  RegisterProjectDescriptor(TBrookHTTPAppProjectDescriptor.Create,
    SBrookIDEItemCategoryName);
  RegisterProjectDescriptor(TBrookHTTPDaemonProjectDescriptor.Create,
    SBrookIDEItemCategoryName);
  RegisterProjectDescriptor(TBrookProjectDescriptor.Create,
    SBrookIDEItemCategoryName);
  RegisterProjectDescriptor(TBrookTable2HTMLFormDescriptor.Create,
    SBrookIDEItemCategoryName);
  RegisterProjectFileDescriptor(TBrookBrokersFileDescPascalUnit.Create,
    SBrookIDEItemCategoryName);
  RegisterProjectFileDescriptor(TBrookActionFileDescPascalUnit.Create,
    SBrookIDEItemCategoryName);
end;

function BrookNewProjectDlg: TfrBrookNewProject;
begin
  if not Assigned(_NewProjectDlg) then
    _NewProjectDlg := TfrBrookNewProject.Create(Application);
  Result := _NewProjectDlg;
end;

procedure BrookFreeNewProjectDlg;
begin
  FreeAndNil(_NewProjectDlg);
end;

function BrookGetExpertsConfigPath: string;
begin
  if Assigned(LazarusIDE) then
    Result := IncludeTrailingPathDelimiter(
{$IFDEF MSWINDOWS}Utf8ToAnsi({$ENDIF}LazarusIDE.GetPrimaryConfigPath
{$IFDEF MSWINDOWS}){$ENDIF})
  else
    Result := '';
end;

function BrookGetExpertsConfigFileName: string;
begin
  Result := BrookGetExpertsConfigPath + 'brook.xml';
end;

{ TBrookCustomSimpleCGIProjectDescriptor }

constructor TBrookCustomSimpleCGIProjectDescriptor.Create;
begin
  inherited Create;
  Name := '';
end;

function TBrookCustomSimpleCGIProjectDescriptor.CreateStartFiles(
  AProject: TLazProject): TModalResult;
var
  VActItem: TBrookActionFileDescPascalUnit;
begin
  VActItem := ProjectFileDescriptors.FindByName(
    SBrookActionName) as TBrookActionFileDescPascalUnit;
  VActItem.FQuiet := True;
  VActItem.ActName := 'MyAction';
  VActItem.ActPattern := '*';
  VActItem.ActDefault := False;
  LazarusIDE.DoNewEditorFile(VActItem, '', '',
    [nfIsPartOfProject, nfOpenInEditor, nfCreateDefaultSrc]);
  Result := mrOK;
end;

function TBrookCustomSimpleCGIProjectDescriptor.InitProject(
  AProject: TLazProject): TModalResult;
begin
  AProject.AddPackageDependency('BrookRT');
  AProject.Flags := AProject.Flags -
    [pfMainUnitHasCreateFormStatements, pfRunnable];
  AProject.LazCompilerOptions.Win32GraphicApp := False;
  AProject.LazCompilerOptions.TargetFilenameApplyConventions := False;
  AProject.SessionStorage := pssInProjectInfo;
  AProject.MainFileID := 0;
  AProject.Title := '';
  Result := mrOK;
end;

function TBrookCustomSimpleCGIProjectDescriptor.GetLocalizedName: string;
begin
  Result := '';
end;

function TBrookCustomSimpleCGIProjectDescriptor.GetLocalizedDescription: string;
begin
  Result := '';
end;

{ TBrookSimpleCGIProjectDescriptor }

constructor TBrookSimpleCGIProjectDescriptor.Create;
begin
  inherited Create;
  Name := SBrookSimpleCGIAppName;
end;

function TBrookSimpleCGIProjectDescriptor.InitProject(
  AProject: TLazProject): TModalResult;
begin
  CreateProjectFile(AProject);
  Result := inherited InitProject(AProject);
  AProject.MainFile.SetSourceText(
    'program cgi1;'+le+
    ''+le+
    '{$mode objfpc}{$H+}'+le+
    ''+le+
    'uses'+le+
    '  BrookApplication, Brokers;'+le+
    ''+le+
    'begin'+le+
    '  BrookApp.Run;'+le+
    'end.');
  AProject.LazCompilerOptions.TargetFileName := 'cgi1.bf';
end;

function TBrookSimpleCGIProjectDescriptor.CreateStartFiles(
  AProject: TLazProject): TModalResult;
var
  VBrkItem: TBrookBrokersFileDescPascalUnit;
begin
  Result := inherited CreateStartFiles(AProject);
  VBrkItem := ProjectFileDescriptors.FindByName(
    SBrookBrokersName) as TBrookBrokersFileDescPascalUnit;
  ConfigureBrokerItem(VBrkItem);
  LazarusIDE.DoNewEditorFile(VBrkItem, '', '',
    [nfIsPartOfProject, nfOpenInEditor, nfCreateDefaultSrc]);
end;

procedure TBrookSimpleCGIProjectDescriptor.ConfigureBrokerItem(
  AItem: TBrookBrokersFileDescPascalUnit);
begin
  AItem.FQuiet := True;
  AItem.FFullBrk := False;
  AItem.FAppType := 0;
  AItem.FAppDefCharset := 0;
end;

procedure TBrookSimpleCGIProjectDescriptor.CreateProjectFile(
  AProject: TLazProject);
var
  VProject: TLazProjectFile;
begin
  VProject := AProject.CreateProjectFile('cgi1.lpr');
  VProject.IsPartOfProject := True;
  AProject.AddFile(VProject, False);
end;

function TBrookSimpleCGIProjectDescriptor.GetLocalizedName: string;
begin
  Result := SBrookSimpleCGIAppName;
end;

function TBrookSimpleCGIProjectDescriptor.GetLocalizedDescription: string;
begin
  Result := SBrookSimpleCGIAppDesc;
end;

{ TBrookSimpleFastCGIProjectDescriptor }

constructor TBrookSimpleFastCGIProjectDescriptor.Create;
begin
  inherited Create;
  Name := SBrookSimpleFastCGIAppName;
end;

function TBrookSimpleFastCGIProjectDescriptor.InitProject(
  AProject: TLazProject): TModalResult;
begin
  Result := inherited InitProject(AProject);
  AProject.Flags := AProject.Flags + [pfRunnable];
  AProject.LazCompilerOptions.TargetFileName := 'cgi1.fbf';
end;

procedure TBrookSimpleFastCGIProjectDescriptor.ConfigureBrokerItem(
  AItem: TBrookBrokersFileDescPascalUnit);
begin
  inherited;
  AItem.FAppType := 1;
end;

function TBrookSimpleFastCGIProjectDescriptor.GetLocalizedName: string;
begin
  Result := SBrookSimpleFastCGIAppName;
end;

function TBrookSimpleFastCGIProjectDescriptor.GetLocalizedDescription: string;
begin
  Result := SBrookSimpleFastCGIAppDesc;
end;

{ TBrookHTTPAppProjectDescriptor }

constructor TBrookHTTPAppProjectDescriptor.Create;
begin
  inherited Create;
  Name := SBrookHTTPAppName;
end;

function TBrookHTTPAppProjectDescriptor.InitProject(
  AProject: TLazProject): TModalResult;
begin
  Result := inherited InitProject(AProject);
  AProject.Flags := AProject.Flags + [pfRunnable];
  AProject.LazCompilerOptions.TargetFilenameApplyConventions := True;
  AProject.MainFile.SetSourceText(
    'program project1;'+le+
    ''+le+
    '{$mode objfpc}{$H+}'+le+
    ''+le+
    'uses'+le+
    '  BrookApplication, Brokers;'+le+
    ''+le+
    'begin'+le+
    '  BrookApp.Run;'+le+
    'end.');
  AProject.LazCompilerOptions.TargetFileName := 'project1';
end;

procedure TBrookHTTPAppProjectDescriptor.ConfigureBrokerItem(
  AItem: TBrookBrokersFileDescPascalUnit);
begin
  inherited;
  AItem.FAppType := 2;
end;

procedure TBrookHTTPAppProjectDescriptor.CreateProjectFile(
  AProject: TLazProject);
var
  VProject: TLazProjectFile;
begin
  VProject := AProject.CreateProjectFile('project1.lpr');
  VProject.IsPartOfProject := True;
  AProject.AddFile(VProject, False);
end;

function TBrookHTTPAppProjectDescriptor.GetLocalizedName: string;
begin
  Result := SBrookHTTPAppName;
end;

function TBrookHTTPAppProjectDescriptor.GetLocalizedDescription: string;
begin
  Result := SBrookHTTPAppDesc;
end;

{ TBrookHTTPDaemonProjectDescriptor }

constructor TBrookHTTPDaemonProjectDescriptor.Create;
begin
  inherited Create;
  Name := SBrookHTTPDaemonName;
end;

function TBrookHTTPDaemonProjectDescriptor.InitProject(
  AProject: TLazProject): TModalResult;
begin
  Result := inherited InitProject(AProject);
  AProject.LazCompilerOptions.Win32GraphicApp := True;
end;

procedure TBrookHTTPDaemonProjectDescriptor.ConfigureBrokerItem(
  AItem: TBrookBrokersFileDescPascalUnit);
begin
  inherited;
  AItem.FAppType := 3;
end;

function TBrookHTTPDaemonProjectDescriptor.GetLocalizedName: string;
begin
  Result := SBrookHTTPDaemonName;
end;

function TBrookHTTPDaemonProjectDescriptor.GetLocalizedDescription: string;
begin
  Result := SBrookHTTPDaemonDesc;
end;

{ TBrookProjectDescriptor }

constructor TBrookProjectDescriptor.Create;
begin
  inherited Create;
  Name := SBrookAppName;
end;

function TBrookProjectDescriptor.CreateStartFiles(
  AProject: TLazProject): TModalResult;

  procedure CreateHTMLFile(const F, S: string);
  begin
    if FileExists(F) and (MessageDlg('Confirmation', Format('Replace file "%s"?',
      [F]), mtConfirmation, mbYesNo, 0) <> mrYes) then
      Exit;
    with TFileStream.Create(F, fmCreate) do
      try
        Write(Pointer(S)^, Length(S));
      finally
        Free;
      end;
  end;

var
  I: Integer;
  VItem: TListItem;
  VHTMLsDir: string;
  VDlg: TfrBrookNewProject;
  VPage404, VPage500: TFileName;
  VActItem: TBrookActionFileDescPascalUnit;
  VBrkItem: TBrookBrokersFileDescPascalUnit;
begin
  VDlg := BrookNewProjectDlg;
  VActItem := ProjectFileDescriptors.FindByName(
    SBrookActionName) as TBrookActionFileDescPascalUnit;
  for I := 0 to Pred(VDlg.lvActions.Items.Count) do
  begin
    VActItem.FQuiet := True;
    VItem := VDlg.lvActions.Items[I];
    VActItem.ActName := VItem.Caption;
    VActItem.ActPattern := VItem.SubItems[0];
    VActItem.ActDefault := StrToBool(VItem.SubItems[1]);
    LazarusIDE.DoNewEditorFile(VActItem, '', '',
      [nfIsPartOfProject, nfOpenInEditor, nfCreateDefaultSrc]);
  end;
  VBrkItem := ProjectFileDescriptors.FindByName(
    SBrookBrokersName) as TBrookBrokersFileDescPascalUnit;
  VBrkItem.FQuiet := True;
  VBrkItem.FFullBrk := True;
  VBrkItem.FAppType := VDlg.rgAppType.ItemIndex;
  VBrkItem.FAppDefCharset := VDlg.rgCharset.ItemIndex;
  LazarusIDE.DoNewEditorFile(VBrkItem, '', '',
    [nfIsPartOfProject, nfOpenInEditor, nfCreateDefaultSrc]);
  if VDlg.edPubHTMLDir.Text <> '' then
  begin
    VHTMLsDir := IncludeTrailingPathDelimiter(VDlg.edPubHTMLDir.Text);
    VPage404 := VHTMLsDir + '404.html';
    VPage500 := VHTMLsDir + '500.html';
    CreateHTMLFile(VPage404, PAGE_404_TPL);
    CreateHTMLFile(VPage500, PAGE_500_TPL);
    LazarusIDE.DoOpenEditorFile(VPage404, -1, -1,
      [ofProjectLoading, ofRegularFile, ofAddToProject]);
    LazarusIDE.DoOpenEditorFile(VPage500, -1, -1,
      [ofProjectLoading, ofRegularFile, ofAddToProject]);
  end;
  Result := LazarusIDE.DoOpenEditorFile(AProject.MainFile.FileName, -1, -1,
    [ofProjectLoading, ofRegularFile]);
  BrookFreeNewProjectDlg;
end;

function TBrookProjectDescriptor.DoInitDescriptor: TModalResult;
begin
  Result := BrookNewProjectDlg.ShowModal;
  if Result <> mrOK then
    BrookFreeNewProjectDlg;
end;

function TBrookProjectDescriptor.InitProject(
  AProject: TLazProject): TModalResult;
var
  S: string;
  VDlg: TfrBrookNewProject;
  VProject: TLazProjectFile;
begin
  VDlg := BrookNewProjectDlg;
  VProject := AProject.CreateProjectFile(VDlg.edAppName.Text + '.lpr');
  VProject.IsPartOfProject := True;
  AProject.AddFile(VProject, False);
  AProject.AddPackageDependency('BrookRT');
  AProject.Flags := AProject.Flags - [pfMainUnitHasCreateFormStatements];
  AProject.LazCompilerOptions.TargetFileName := VDlg.edAppName.Text;
  AProject.LazCompilerOptions.TargetFilenameApplyConventions := False;
  AProject.LazCompilerOptions.Win32GraphicApp := False;
  case VDlg.rgAppType.ItemIndex of
    0:
      begin
        AProject.Flags := AProject.Flags - [pfRunnable];
        AProject.LazCompilerOptions.TargetFileName := VDlg.edAppName.Text + '.bf';
      end;
    1: AProject.LazCompilerOptions.TargetFileName := VDlg.edAppName.Text + '.fbf';
    2: AProject.LazCompilerOptions.TargetFilenameApplyConventions := True;
    3:
      begin
        AProject.LazCompilerOptions.TargetFilenameApplyConventions := True;
        AProject.LazCompilerOptions.Win32GraphicApp := True;
      end;
  end;
  AProject.SessionStorage := pssInProjectInfo;
  AProject.MainFileID := 0;
  S :=
    'program '+VDlg.edAppName.Text+';'+le+
    ''+le+
    '{$mode objfpc}{$H+}'+le+
    ''+le+
    'uses'+le+
    '  BrookApplication, Brokers;'+le+
    ''+le+
    'begin'+le+
    '  BrookApp.Run;'+le+
    'end.';
  AProject.MainFile.SetSourceText(S);
  Result := mrOK;
end;

function TBrookProjectDescriptor.GetLocalizedName: string;
begin
  Result := SBrookAppName;
end;

function TBrookProjectDescriptor.GetLocalizedDescription: string;
begin
  Result := SBrookAppDesc;
end;

{ TBrookTable2HTMLFormDescriptor }

constructor TBrookTable2HTMLFormDescriptor.Create;
begin
  inherited Create;
  Name := SBrookTable2HTMLFormName;
end;

function TBrookTable2HTMLFormDescriptor.DoInitDescriptor: TModalResult;
begin
  TfrBrookTable2HTMLForm.Execute;
  Result := mrCancel;
end;

function TBrookTable2HTMLFormDescriptor.GetLocalizedName: string;
begin
  Result := SBrookTable2HTMLFormName;
end;

function TBrookTable2HTMLFormDescriptor.GetLocalizedDescription: string;
begin
  Result := SBrookTable2HTMLFormDesc;
end;

{ TBrookBrokersFileDescPascalUnit }

constructor TBrookBrokersFileDescPascalUnit.Create;
begin
  inherited Create;
  Name := SBrookBrokersName;
  DefaultFileName := 'brokers.pas';
  DefaultSourceName := 'Brokers';
  FQuiet := True;
end;

function TBrookBrokersFileDescPascalUnit.Init(var ANewFilename: string;
  ANewOwner: TObject; var ANewSource: string; AQuiet: Boolean): TModalResult;
begin
  Result := inherited Init(ANewFilename, ANewOwner, ANewSource, AQuiet);
  if AQuiet or FQuiet then
    Exit;
  FAppType := TfrBrookNewBroker.Execute;
  if FAppType = -1 then
    Result := mrCancel;
end;

function TBrookBrokersFileDescPascalUnit.CreateSource(const AFileName,
  ASourceName, AResourceName: string): string;
var
  VDlg: TfrBrookNewProject;
  VCharset, VBroker: string;
begin
  case FAppType of
    0: VBroker := 'BrookFCLCGIBroker';
    1: VBroker := 'BrookFCLFCGIBroker';
    2: VBroker := 'BrookFCLHTTPAppBroker';
    3: VBroker := 'BrookFCLHTTPDaemonBroker';
  end;
  case FAppDefCharset of
    0: VCharset := 'BROOK_HTTP_CHARSET_UTF_8';
    1: VCharset := 'BROOK_HTTP_CHARSET_ISO_8859_1';
  end;
  if FFullBrk then
  begin
    VDlg := BrookNewProjectDlg;
    Result :=
    'unit Brokers;'+le+
    ''+le+
    '{$mode objfpc}{$H+}'+le+
    ''+le+
    'interface'+le+
    ''+le+
    'uses'+le+
    '  '+VBroker+', BrookHTTPConsts, BrookUtils, Classes, SysUtils;'+le+
    ''+le+
    'const'+le+
    '  PUBLIC_HTML = '+QuotedStr(IncludeTrailingPathDelimiter(VDlg.edPubHTMLDir.Text))+';'+le+
    ''+le+
    'implementation'+le+
    ''+le+
    'initialization'+le+
    '  BrookSettings.Charset := ' + VCharset + ';'+le+
    '  BrookSettings.Page404File := PUBLIC_HTML + ''404.html'';'+le+
    '  BrookSettings.Page500File := PUBLIC_HTML + ''500.html'';'+le+
    ''+le+
    'end.';
  end
  else
    Result :=
    'unit Brokers;'+le+
    ''+le+
    '{$mode objfpc}{$H+}'+le+
    ''+le+
    'interface'+le+
    ''+le+
    'uses'+le+
    '  '+VBroker+';'+le+
    ''+le+
    'implementation'+le+
    ''+le+
    'end.';
  FAppType := 0;
  FAppDefCharset := 0;
  FFullBrk := False;
  FQuiet := False;
end;

function TBrookBrokersFileDescPascalUnit.GetLocalizedName: string;
begin
  Result := SBrookBrokersName;
end;

function TBrookBrokersFileDescPascalUnit.GetLocalizedDescription: string;
begin
  Result := SBrookBrokersDesc;
end;

{ TBrookActionFileDescPascalUnit }

constructor TBrookActionFileDescPascalUnit.Create;
begin
  inherited Create;
  Name := SBrookActionName;
end;

function TBrookActionFileDescPascalUnit.Init(var ANewFilename: string;
  ANewOwner: TObject; var ANewSource: string; AQuiet: Boolean): TModalResult;
begin
  Result := inherited Init(ANewFilename, ANewOwner, ANewSource, AQuiet);
  if AQuiet or FQuiet then
    Exit;
  if not TfrBrookActEdit.Execute('Add', FActName, FActPattern,
    FActDefault, True) then
    Result := mrCancel;
end;

function TBrookActionFileDescPascalUnit.CreateSource(const AFileName,
  ASourceName, AResourceName: string): string;
var
  VActDefault: ShortString = '';
begin
  if FActName = '' then
    FActName := ASourceName;
  FActName := UpperCase(Copy(FActName, 1, 1)) + Copy(FActName, 2, MaxInt);
  if FActPattern = '' then
    FActPattern := '/' + LowerCase(ASourceName) + '/';
  if FActDefault then
    VActDefault := ', True';
  Result :=
    'unit '+ASourceName+';'+le+
    ''+le+
    '{$mode objfpc}{$H+}'+le+
    ''+le+
    'interface'+le+
    ''+le+
    'uses'+le+
    '  BrookAction;'+le+
    ''+le+
    'type'+le+
    '  T'+FActName+' = class(TBrookAction)'+le+
    '  public'+le+
    '    procedure Get; override;'+le+
    '  end;'+le+
    ''+le+
    'implementation'+le+
    ''+le+
    'procedure T'+FActName+'.Get;'+le+
    'begin'+le+
    '  Write(''Your content here ...'');'+le+
    'end;'+le+
    ''+le+
    'initialization'+le+
    '  T'+FActName+'.Register('+QuotedStr(FActPattern)+VActDefault+');'+le+
    ''+le+
    'end.';
  FActName := '';
  FActPattern := '';
  FActDefault := False;
  FQuiet := False;
end;

function TBrookActionFileDescPascalUnit.GetLocalizedName: string;
begin
  Result := SBrookActionName;
end;

function TBrookActionFileDescPascalUnit.GetLocalizedDescription: string;
begin
  Result := SBrookActionDesc;
end;

finalization
  BrookFreeNewProjectDlg;

end.
