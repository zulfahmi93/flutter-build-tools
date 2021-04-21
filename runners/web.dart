import '../config.dart';
import 'interface.dart';

class WebBuildRunner extends BuildRunner {
  // ---------------------------- CONSTRUCTORS ----------------------------
  const WebBuildRunner({
    required BuildConfig config,
  }) : super(config: config);

  // ----------------------------- PROPERTIES -----------------------------
  @override
  String get platformName => 'web';

  @override
  String get platformNameForHuman => 'Web';

  @override
  String get platformNameForOutput => 'Web';

  @override
  String get toolsChannel => 'beta';

  @override
  bool get includeBuildNumber => false;

  @override
  bool get includeBuildVersion => false;

  @override
  String? get outputDirectoryPath => 'build/web/';
}
