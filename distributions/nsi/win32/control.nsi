Name "FBReader for Windows"

!include "MUI2.nsh"

Unicode true
ManifestDPIAware true
ManifestDPIAwareness "PerMonitorV2,System"

OutFile "FBReaderSetup-${VERSION}.exe"

!ifdef X64
InstallDir $PROGRAMFILES64\FBReader
!else
InstallDir $PROGRAMFILES\FBReader
!endif

InstallDirRegKey HKCU "Software\FBReader" ""

RequestExecutionLevel user

SetCompressor /FINAL lzma

!define MUI_LANGDLL_ALLLANGUAGES

;--------------------------------
;Pages
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH

  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH

;--------------------------------
;Languages

  !insertmacro MUI_LANGUAGE "English" ; The first language is the default language
  !insertmacro MUI_LANGUAGE "French"
  !insertmacro MUI_LANGUAGE "German"
  !insertmacro MUI_LANGUAGE "Spanish"
  !insertmacro MUI_LANGUAGE "SpanishInternational"
  !insertmacro MUI_LANGUAGE "SimpChinese"
  !insertmacro MUI_LANGUAGE "TradChinese"
  !insertmacro MUI_LANGUAGE "Japanese"
  !insertmacro MUI_LANGUAGE "Korean"
  !insertmacro MUI_LANGUAGE "Italian"
  !insertmacro MUI_LANGUAGE "Dutch"
  !insertmacro MUI_LANGUAGE "Danish"
  !insertmacro MUI_LANGUAGE "Swedish"
  !insertmacro MUI_LANGUAGE "Norwegian"
  !insertmacro MUI_LANGUAGE "NorwegianNynorsk"
  !insertmacro MUI_LANGUAGE "Finnish"
  !insertmacro MUI_LANGUAGE "Greek"
  !insertmacro MUI_LANGUAGE "Russian"
  !insertmacro MUI_LANGUAGE "Portuguese"
  !insertmacro MUI_LANGUAGE "PortugueseBR"
  !insertmacro MUI_LANGUAGE "Polish"
  !insertmacro MUI_LANGUAGE "Ukrainian"
  !insertmacro MUI_LANGUAGE "Czech"
  !insertmacro MUI_LANGUAGE "Slovak"
  !insertmacro MUI_LANGUAGE "Croatian"
  !insertmacro MUI_LANGUAGE "Bulgarian"
  !insertmacro MUI_LANGUAGE "Hungarian"
  !insertmacro MUI_LANGUAGE "Thai"
  !insertmacro MUI_LANGUAGE "Romanian"
  !insertmacro MUI_LANGUAGE "Latvian"
  !insertmacro MUI_LANGUAGE "Macedonian"
  !insertmacro MUI_LANGUAGE "Estonian"
  !insertmacro MUI_LANGUAGE "Turkish"
  !insertmacro MUI_LANGUAGE "Lithuanian"
  !insertmacro MUI_LANGUAGE "Slovenian"
  !insertmacro MUI_LANGUAGE "Serbian"
  !insertmacro MUI_LANGUAGE "SerbianLatin"
  !insertmacro MUI_LANGUAGE "Arabic"
  !insertmacro MUI_LANGUAGE "Farsi"
  !insertmacro MUI_LANGUAGE "Hebrew"
  !insertmacro MUI_LANGUAGE "Indonesian"
  !insertmacro MUI_LANGUAGE "Mongolian"
  !insertmacro MUI_LANGUAGE "Luxembourgish"
  !insertmacro MUI_LANGUAGE "Albanian"
  !insertmacro MUI_LANGUAGE "Breton"
  !insertmacro MUI_LANGUAGE "Belarusian"
  !insertmacro MUI_LANGUAGE "Icelandic"
  !insertmacro MUI_LANGUAGE "Malay"
  !insertmacro MUI_LANGUAGE "Bosnian"
  !insertmacro MUI_LANGUAGE "Kurdish"
  !insertmacro MUI_LANGUAGE "Irish"
  !insertmacro MUI_LANGUAGE "Uzbek"
  !insertmacro MUI_LANGUAGE "Galician"
  !insertmacro MUI_LANGUAGE "Afrikaans"
  !insertmacro MUI_LANGUAGE "Catalan"
  !insertmacro MUI_LANGUAGE "Esperanto"
  !insertmacro MUI_LANGUAGE "Asturian"
  !insertmacro MUI_LANGUAGE "Basque"
  !insertmacro MUI_LANGUAGE "Pashto"
  !insertmacro MUI_LANGUAGE "ScotsGaelic"
  !insertmacro MUI_LANGUAGE "Georgian"
  !insertmacro MUI_LANGUAGE "Vietnamese"
  !insertmacro MUI_LANGUAGE "Welsh"
  !insertmacro MUI_LANGUAGE "Armenian"
  !insertmacro MUI_LANGUAGE "Corsican"
  !insertmacro MUI_LANGUAGE "Tatar"
  !insertmacro MUI_LANGUAGE "Hindi"
  !insertmacro MUI_RESERVEFILE_LANGDLL

!ifdef LANGDISPLAY
Function .onInit
  !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

Function un.onInit
  !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd
!endif

Section "FBReader"
  SectionIn RO

  SetOutPath "$INSTDIR"

  WriteRegStr HKCU "Software\FBReader" "" $INSTDIR

  File /oname=fbreader.exe fbreader.exe
  File /r share

  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\FBReader for Windows" "DisplayName" "FBReader for Windows"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\FBReader for Windows" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\FBReader for Windows" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\FBReader for Windows" "NoRepair" 1
  WriteUninstaller "uninstall.exe"

  CreateDirectory "$SMPROGRAMS\FBReader for Windows"
  CreateShortCut "$SMPROGRAMS\FBReader for Windows\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  CreateShortCut "$SMPROGRAMS\FBReader for Windows\FBReader.lnk" "$INSTDIR\fbreader.exe" "" "$INSTDIR\fbreader.exe" 0

  ReadRegStr $0 HKCU "Software\FBReader\options\Options" "Base:fontFamily"
  StrCmp $0 "" 0 +2
  WriteRegStr HKCU "Software\FBReader\options\Style" "Base:fontFamily" "Georgia" 
  ReadRegStr $0 HKCU "Software\FBReader\options\Options" "Base:fontSize"
  StrCmp $0 "" 0 +2
  WriteRegStr HKCU "Software\FBReader\options\Style" "Base:fontSize" "20" 
  ReadRegStr $0 HKCU "Software\FBReader\options\Options" "BookPath"
  StrCmp $0 "" 0 +2
  WriteRegStr HKCU "Software\FBReader\options\Options" "BookPath" "C:\Books;$PROFILE\Books" 
  ReadRegStr $0 HKCU "Software\FBReader\options\Options" "DownloadDirectory"
  StrCmp $0 "" 0 +2
  WriteRegStr HKCU "Software\FBReader\options\Options" "DownloadDirectory" "$PROFILE\Books" 
  WriteRegStr HKCU "Software\FBReader\options\PlatformOptions" "TouchScreenPresented" "true" 
  WriteRegStr HKCU "Software\FBReader\options\PlatformOptions" "MousePresented" "true" 
  WriteRegStr HKCU "Software\FBReader\options\PlatformOptions" "KeyboardPresented" "true" 
  WriteRegStr HKCU "Software\FBReader\options\Options" "LeftMargin" "50" 
  WriteRegStr HKCU "Software\FBReader\options\Options" "RightMargin" "50" 
  WriteRegStr HKCU "Software\FBReader\options\Options" "KeyDelay" "0" 
  WriteRegStr HKCU "Software\FBReader\options\Scrollings" "Delay" "0" 
  WriteRegStr HKCU "Software\FBReader\options\TapScrolling" "Enabled" "true" 
SectionEnd

Section "Create Shortcut on Desktop"
  CreateShortCut "$DESKTOP\fbreader.lnk" "$INSTDIR\fbreader.exe" "" "$INSTDIR\fbreader.exe" 0
SectionEnd

Section "Uninstall"
  ClearErrors
  Delete "$INSTDIR\fbreader.exe"
  IfErrors 0 ContinueUninstallation
    MessageBox MB_OK "Cannot uninstall FBReader while the program is running.$\nPlease quit FBReader and try again."
    Quit
  ContinueUninstallation:
  RMDir /r "$INSTDIR\share"
  Delete "$INSTDIR\*.dll"
  Delete "$INSTDIR\*.license"
  Delete "$INSTDIR\uninstall.exe"
  RMDir "$INSTDIR"

  RMDir /r "$SMPROGRAMS\FBReader for Windows"
  Delete "$DESKTOP\FBReader.lnk"

  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\FBReader for Windows"
  DeleteRegKey /ifempty HKCU "Software\FBReader"

  MessageBox MB_YESNO "Remove FBReader configuration from registry?" IDNO SkipConfigDeletion
    DeleteRegKey HKCU "Software\FBReader"
  SkipConfigDeletion:

  MessageBox MB_YESNO "Remove FBReader library information?" IDNO SkipLibraryDeletion
    RMDir /r "$PROFILE\.FBReader"
  SkipLibraryDeletion:
SectionEnd
