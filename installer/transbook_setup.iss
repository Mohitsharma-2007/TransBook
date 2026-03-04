; TransBook Inno Setup Installer Script
; Requires Inno Setup 6.x

[Setup]
AppName=Trans Book
AppVersion=1.0.0
AppPublisher=JSV Technologies
AppSupportURL=https://transbook.app
DefaultDirName={autopf}\TransBook
DefaultGroupName=Trans Book
OutputDir=..\dist
OutputBaseFilename=TransBook_Setup_v1.0.0
Compression=lzma2/ultra64
SolidCompression=yes
SetupIconFile=..\windows\runner\resources\app_icon.ico
MinVersion=10.0.19041
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
WizardStyle=modern
PrivilegesRequired=lowest

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "..\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs createallsubdirs

[Icons]
Name: "{group}\Trans Book"; Filename: "{app}\trans_book.exe"
Name: "{userdesktop}\Trans Book"; Filename: "{app}\trans_book.exe"; Tasks: desktopicon

[Tasks]
Name: "desktopicon"; Description: "Create a desktop shortcut"; GroupDescription: "Additional icons:"

[Run]
Filename: "{app}\trans_book.exe"; Description: "Launch Trans Book"; Flags: postinstall nowait skipifsilent

[Registry]
; Register .tbk file association for backup files
Root: HKCU; Subkey: "Software\Classes\.tbk"; ValueType: string; ValueData: "TransBookBackup"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\TransBookBackup"; ValueType: string; ValueData: "TransBook Backup File"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\TransBookBackup\DefaultIcon"; ValueType: string; ValueData: "{app}\trans_book.exe,0"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\TransBookBackup\shell\open\command"; ValueType: string; ValueData: """{app}\trans_book.exe"" ""%1"""; Flags: uninsdeletekey
