import '../config.dart';
import '../constants/constants.dart';
import 'interface.dart';

class AndroidAppBundleBuildRunner extends BuildRunner {
  // ---------------------------- CONSTRUCTORS ----------------------------
  const AndroidAppBundleBuildRunner({
    BuildConfig config,
  }) : super(config: config);

  // ----------------------------- PROPERTIES -----------------------------
  @override
  String get platformName => 'appbundle';

  @override
  String get platformNameForHuman => 'Android App Bundle';

  @override
  String get platformNameForOutput => 'AndroidBundle';

  @override
  String get toolsChannel => 'stable';

  @override
  bool get includeBuildNumber => true;

  @override
  bool get includeBuildVersion => true;

  @override
  String get outputFilePath {
    final buildType = config.buildType.buildCommand;
    return 'build/app/outputs/bundle/${buildType}/app-${buildType}.aab';
  }
}
