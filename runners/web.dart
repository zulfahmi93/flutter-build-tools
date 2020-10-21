import '../config.dart';
import 'interface.dart';

class WebBuildRunner extends BuildRunner {
  // ---------------------------- CONSTRUCTORS ----------------------------
  const WebBuildRunner({
    BuildConfig config,
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
  String get outputDirectoryPath => 'build/web/';

  @override
  List<String> get buildArguments {
    final args = super.buildArguments;

    if (config.webBuildConfig.useSkia) {
      args.add('--dart-define=FLUTTER_WEB_USE_SKIA=true');
    }
    if (config.webBuildConfig.useCanvasText) {
      args.add('--dart-define=FLUTTER_WEB_USE_EXPERIMENTAL_CANVAS_TEXT=true');
    }

    return args;
  }
}
