import '../config.dart';
import '../constants/constants.dart';
import 'interface.dart';

class MacOSBuildRunner extends BuildRunner {
  // ---------------------------- CONSTRUCTORS ----------------------------
  const MacOSBuildRunner({
    required BuildConfig config,
  }) : super(config: config);

  // ----------------------------- PROPERTIES -----------------------------
  @override
  String get platformName => 'macos';

  @override
  String get platformNameForHuman => 'macOS';

  @override
  String get platformNameForOutput => 'macOS';

  @override
  String get toolsChannel => 'stable';

  @override
  bool get includeBuildNumber => true;

  @override
  bool get includeBuildVersion => true;

  @override
  String? get outputDirectoryPath =>
      'build/macos/Build/Products/${config.buildType.outputName}/'
      '${config.appName}.app/';

  // ------------------------------- METHODS ------------------------------
  @override
  String getOutputName(BuildConfig config) {
    final name = super.getOutputName(config);
    return '$name.app';
  }
}
