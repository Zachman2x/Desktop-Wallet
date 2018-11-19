; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!
; Download Inno Setup from: http://www.jrsoftware.org/isdl.php to build this setup file

; !!!NOTICE FOR ANYONE TRYING TO BUILD THE SETUP!!!
;
;
; Anywhere below, when building the setup, make sure to replace "C:\Projects\aion_ui" with the actual path where you clone the `aion_ui`
;
; Before using the signtool, Windows 10 SDK should be installed - https://developer.microsoft.com/en-us/windows/downloads/windows-10-sdk
; A certificate needs to be added in Tools->Configure Sign Tools->Add
; Name=signtool
; Value="C:\Program Files (x86)\Windows Kits\10\App Certification Kit\signtool.exe"  sign /f "C:\Projects\aion_ui\scripts\cert.pfx" /p superaion /t http://timestamp.verisign.com/scripts/timstamp.dll $f
;
; If the current certificate has expired, a new one can be issued from powershell:
; > New-SelfSignedCertificate -certstorelocation cert:\localmachine\my -dnsname aion.network -type CodeSigning
; > certutil -exportPFX ${cert_hash_from_above_certificate} ${path_to_new_pfx_file}


#define MyAppName "AionWallet"
#define MyAppVersion "1.1"
#define MyAppPublisher "Aion"
#define MyAppURL "http://www.aion.network/"
#define MyAppExeName "AionWallet.exe"
#define MyAppUserDataDirName ".aion"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{49D782D3-43D8-47F2-914A-3DEA3D29CB62}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf64}\{#MyAppName}
DisableProgramGroupPage=yes
OutputBaseFilename=AionWalletSetup
Compression=lzma
SolidCompression=yes
;PrivilegesRequired=admin
SignTool=signtool $p

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "C:\Projects\aion_ui\pack\aion_ui\*"; DestDir: "{app}"; Excludes: "cert.pfx, unzip.exe, cygwin1.dll, cygbz2-1.dll, cygintl-8.dll, Bat_To_Exe.exe, *.zip, "; Flags: ignoreversion recursesubdirs createallsubdirs;
Source: "C:\Projects\aion_ui\pack\aion_ui\unzip.exe"; DestDir: "{tmp}"; Flags: ignoreversion
Source: "C:\Projects\aion_ui\pack\aion_ui\cert.pfx"; DestDir: "{tmp}"; Flags: ignoreversion
Source: "C:\Projects\aion_ui\pack\aion_ui\*.dll"; DestDir: "{tmp}"; Flags: ignoreversion
Source: "C:\Projects\aion_ui\pack\aion_ui\java.zip"; DestDir: "{tmp}"; Flags: ignoreversion
Source: "C:\Projects\aion_ui\pack\aion_ui\native\win\ledger\Aion-HID.zip"; DestDir: "{tmp}";  Flags: deleteafterinstall
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{commonprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "certutil.exe"; Parameters: "-addstore ""TrustedPublisher"" {tmp}\cert.pfx"; StatusMsg: "Adding trusted publisher..."
Filename: "{tmp}\unzip.exe"; Parameters: "-n ""{tmp}\Aion-HID.zip"" ""-d"" ""{app}\native\win\ledger"""; Flags: runhidden; StatusMsg: "Installing additional resources..."
Filename: "{tmp}\unzip.exe"; Parameters: "-n ""{tmp}\java.zip"" ""-d"" ""{%USERPROFILE}\{#MyAppUserDataDirName}"""; Flags: runhidden; StatusMsg: "Installing additional resources..."
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[UninstallRun]
Filename: "PowerShell.exe"; Parameters: "-windowstyle hidden -Command ""& {{robocopy /MIR '{app}\lib' '{app}\native'}""";

[UninstallDelete]
Type: filesandordirs; Name:"{app}";

[Code]

var
  UninstallFirstPage: TNewNotebookPage;
  UninstallNextButton: TNewButton;
  RemoveDataCheckBox: TNewCheckBox;

procedure UninstallNextButtonClick(Sender: TObject);
begin
  UninstallProgressForm.InnerNotebook.ActivePage := UninstallProgressForm.InstallingPage;
  { Make the "Uninstall" button break the ShowModal loop }
  UninstallNextButton.Caption := 'Uninstall';
  UninstallNextButton.ModalResult := mrOK;
  UninstallNextButton.Enabled := False;
  UninstallProgressForm.CancelButton.Enabled := True;
end;

procedure InitializeUninstallProgressForm();
var
  PageText: TNewStaticText;
  PageNameLabel: string;
  PageDescriptionLabel: string;
  CancelButtonEnabled: Boolean;
  CancelButtonModalResult: Integer;
begin
  if not UninstallSilent then
  begin
    { Create the first page and make it active }
    UninstallFirstPage := TNewNotebookPage.Create(UninstallProgressForm);
    UninstallFirstPage.Notebook := UninstallProgressForm.InnerNotebook;
    UninstallFirstPage.Parent := UninstallProgressForm.InnerNotebook;
    UninstallFirstPage.Align := alClient;

    PageText := TNewStaticText.Create(UninstallProgressForm);
    PageText.Parent := UninstallFirstPage;
    PageText.Top := UninstallProgressForm.StatusLabel.Top;
    PageText.Left := UninstallProgressForm.StatusLabel.Left;
    PageText.Width := UninstallProgressForm.StatusLabel.Width;
    PageText.Height := UninstallProgressForm.StatusLabel.Height;
    PageText.AutoSize := False;
    PageText.ShowAccelChar := False;
    PageText.Caption := 'Press Uninstall to proceeed with uninstallation.';

    UninstallProgressForm.InnerNotebook.ActivePage := UninstallFirstPage;

    PageNameLabel := UninstallProgressForm.PageNameLabel.Caption;
    PageDescriptionLabel := UninstallProgressForm.PageDescriptionLabel.Caption;

    UninstallNextButton := TNewButton.Create(UninstallProgressForm);
    UninstallNextButton.Parent := UninstallProgressForm;
    UninstallNextButton.Left := UninstallProgressForm.CancelButton.Left - UninstallProgressForm.CancelButton.Width - ScaleX(10);
    UninstallNextButton.Top := UninstallProgressForm.CancelButton.Top;
    UninstallNextButton.Width := UninstallProgressForm.CancelButton.Width;
    UninstallNextButton.Height := UninstallProgressForm.CancelButton.Height;
    UninstallNextButton.Caption := 'Uninstall';
    UninstallNextButton.OnClick := @UninstallNextButtonClick;

    RemoveDataCheckBox := TNewCheckBox.Create(UninstallProgressForm);
    RemoveDataCheckBox.Parent := UninstallProgressForm.InnerNotebook.ActivePage;
    RemoveDataCheckBox.Top := UninstallProgressForm.StatusLabel.Top + ScaleY(20);
    RemoveDataCheckBox.Left := UninstallProgressForm.StatusLabel.Left;
    RemoveDataCheckBox.Width := UninstallProgressForm.StatusLabel.Width;
    RemoveDataCheckBox.Caption := 'Remove application data';

    { Run our wizard pages }
    UninstallNextButton.Caption := 'Uninstall';
    UninstallNextButton.ModalResult := mrOK;

    CancelButtonEnabled := UninstallProgressForm.CancelButton.Enabled
    UninstallProgressForm.CancelButton.Enabled := True;
    CancelButtonModalResult := UninstallProgressForm.CancelButton.ModalResult;
    UninstallProgressForm.CancelButton.ModalResult := mrCancel;

    if UninstallProgressForm.ShowModal = mrCancel then Abort;

    { Restore the standard page payout }
    UninstallProgressForm.CancelButton.Enabled := CancelButtonEnabled;
    UninstallProgressForm.CancelButton.ModalResult := CancelButtonModalResult;

    UninstallProgressForm.PageNameLabel.Caption := PageNameLabel;
    UninstallProgressForm.PageDescriptionLabel.Caption := PageDescriptionLabel;

    UninstallProgressForm.InnerNotebook.ActivePage := UninstallProgressForm.InstallingPage;
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usUninstall then { or usPostUninstall }
  begin
    if RemoveDataCheckBox.Checked then
    begin
      Log('Deleting user data');
      DelTree(ExpandConstant('{%USERPROFILE}') + '\' + + ExpandConstant('{#MyAppUserDataDirName}'), True, True, True);
    end;
  end;
end;