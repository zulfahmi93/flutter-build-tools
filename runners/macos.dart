import '../config.dart';
import '../constants/constants.dart';
import 'interface.dart';

class MacOSBuildRunner extends BuildRunner {
  // ---------------------------- CONSTRUCTORS ----------------------------
  const MacOSBuildRunner({
    BuildConfig config,
  }) : super(config: config);

  // ----------------------------- PROPERTIES -----------------------------
  @override
  String get platformName => 'macos';

  @override
  String get platformNameForHuman => 'macOS';

  @override
  String get platformNameForOutput => 'macOS';

  @override
  String get toolsChannel => 'dev';

  @override
  bool get includeBuildNumber => true;

  @override
  bool get includeBuildVersion => true;

  @override
  String get outputFilePath =>
      'build/macos/Build/Products/${config.buildType.outputName}/'
      '${config.appName}.app';
}
