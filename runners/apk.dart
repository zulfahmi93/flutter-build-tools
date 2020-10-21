import '../config.dart';
import '../constants/constants.dart';
import 'interface.dart';

class AndroidApkBuildRunner extends BuildRunner {
  // ---------------------------- CONSTRUCTORS ----------------------------
  const AndroidApkBuildRunner({
    BuildConfig config,
  }) : super(config: config);

  // ----------------------------- PROPERTIES -----------------------------
  @override
  String get platformName => 'apk';

  @override
  String get platformNameForHuman => 'Android APK';

  @override
  String get platformNameForOutput => 'APK';

  @override
  String get toolsChannel => 'stable';

  @override
  bool get includeBuildNumber => true;

  @override
  bool get includeBuildVersion => true;

  @override
  String get outputFilePath {
    final buildType = config.buildType.buildCommand;
    return 'build/app/outputs/apk/${buildType}/app-${buildType}.apk';
  }
}
