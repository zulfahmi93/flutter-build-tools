import 'dart:io';

import 'package:path/path.dart' as path;

import '../config.dart';
import '../constants/constants.dart';
import 'interface.dart';

class WindowsBuildRunner extends BuildRunner {
  // ---------------------------- CONSTRUCTORS ----------------------------
  const WindowsBuildRunner({
    required BuildConfig config,
  }) : super(config: config);

  // ----------------------------- PROPERTIES -----------------------------
  @override
  String get platformName => 'windows';

  @override
  String get platformNameForHuman => 'Windows';

  @override
  String get platformNameForOutput => 'Windows';

  @override
  String get toolsChannel => 'stable';

  @override
  bool get includeBuildNumber => false;

  @override
  bool get includeBuildVersion => false;

  @override
  String? get outputDirectoryPath =>
      'build/windows/runner/${config.buildType.outputName}/';

  // ------------------------------- METHODS ------------------------------
  @override
  Future<int> preBuild() async {
    await super.preBuild();
    await _configureWindowsRunnerRcFile(config);
    return 0;
  }

  Future<void> _configureWindowsRunnerRcFile(BuildConfig config) async {
    final versionAsNumber = config.buildVersion.replaceAll('.', ',');
    final versionAsString = config.buildVersion;

    final fileContent = _windowsRunnerRcFileTemplate
        .replaceAll('%s1', versionAsNumber)
        .replaceAll('%s2', versionAsString)
        .replaceAll('%s3', config.appName)
        .replaceAll('%s4', config.appName.replaceAll(' ', '-'));

    final filePath = path.join(
      config.projectDirectory,
      'windows/runner/Runner.rc',
    );

    await File(filePath).writeAsString(
      fileContent,
      flush: true,
    );
  }
}

const _windowsRunnerRcFileTemplate =
    r'''// Microsoft Visual C++ generated resource script.
//
#pragma code_page(65001)
#include "resource.h"

#define APSTUDIO_READONLY_SYMBOLS
/////////////////////////////////////////////////////////////////////////////
//
// Generated from the TEXTINCLUDE 2 resource.
//
#include "winres.h"

/////////////////////////////////////////////////////////////////////////////
#undef APSTUDIO_READONLY_SYMBOLS

/////////////////////////////////////////////////////////////////////////////
// English (United States) resources

#if !defined(AFX_RESOURCE_DLL) || defined(AFX_TARG_ENU)
LANGUAGE LANG_ENGLISH, SUBLANG_ENGLISH_US

#ifdef APSTUDIO_INVOKED
/////////////////////////////////////////////////////////////////////////////
//
// TEXTINCLUDE
//

1 TEXTINCLUDE
BEGIN
    "resource.h\0"
END

2 TEXTINCLUDE
BEGIN
    "#include ""winres.h""\r\n"
    "\0"
END

3 TEXTINCLUDE
BEGIN
    "\r\n"
    "\0"
END

#endif    // APSTUDIO_INVOKED


/////////////////////////////////////////////////////////////////////////////
//
// Icon
//

// Icon with lowest ID value placed first to ensure application icon
// remains consistent on all systems.
IDI_APP_ICON            ICON                    "resources\\app_icon.ico"


/////////////////////////////////////////////////////////////////////////////
//
// Version
//

#ifdef FLUTTER_BUILD_NUMBER
#define VERSION_AS_NUMBER FLUTTER_BUILD_NUMBER
#else
#define VERSION_AS_NUMBER %s1
#endif

#ifdef FLUTTER_BUILD_NAME
#define VERSION_AS_STRING #FLUTTER_BUILD_NAME
#else
#define VERSION_AS_STRING "%s2"
#endif

VS_VERSION_INFO VERSIONINFO
 FILEVERSION VERSION_AS_NUMBER
 PRODUCTVERSION VERSION_AS_NUMBER
 FILEFLAGSMASK VS_FFI_FILEFLAGSMASK
#ifdef _DEBUG
 FILEFLAGS VS_FF_DEBUG
#else
 FILEFLAGS 0x0L
#endif
 FILEOS VOS__WINDOWS32
 FILETYPE VFT_APP
 FILESUBTYPE 0x0L
BEGIN
    BLOCK "StringFileInfo"
    BEGIN
        BLOCK "040904e4"
        BEGIN
            VALUE "CompanyName", "SOCOE" "\0"
            VALUE "FileDescription", "%s3" "\0"
            VALUE "FileVersion", VERSION_AS_STRING "\0"
            VALUE "InternalName", "%s3" "\0"
            VALUE "LegalCopyright", "Copyright © 2020 SOCOE. All rights reserved." "\0"
            VALUE "OriginalFilename", "%s4.exe" "\0"
            VALUE "ProductName", "%s3" "\0"
            VALUE "ProductVersion", VERSION_AS_STRING "\0"
        END
    END
    BLOCK "VarFileInfo"
    BEGIN
        VALUE "Translation", 0x409, 1252
    END
END

#endif    // English (United States) resources
/////////////////////////////////////////////////////////////////////////////



#ifndef APSTUDIO_INVOKED
/////////////////////////////////////////////////////////////////////////////
//
// Generated from the TEXTINCLUDE 3 resource.
//


/////////////////////////////////////////////////////////////////////////////
#endif    // not APSTUDIO_INVOKED
''';
