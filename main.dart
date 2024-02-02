import 'dart:io';

import 'package:args/args.dart';

import 'config.dart';
import 'constants/constants.dart';
import 'runners/runners.dart';

typedef _Combination = (BuildType, BuildFlavour, bool);

Future<int> main(List<String> arguments) async {
  final parser = _buildParser();
  final result = parser.parse(arguments);

  if (!result.wasParsed('tools-location') ||
      !result.wasParsed('project-dir') ||
      !result.wasParsed('artifacts-dir') ||
      !result.wasParsed('app-name') ||
      !result.wasParsed('build-version') ||
      !result.wasParsed('build-number')) {
    print(parser.usage);
    return -1;
  }

  final userInput = BuildConfig(
    toolsLocation: result['tools-location'],
    projectDirectory: result['project-dir'],
    artifactsDirectory: result['artifacts-dir'],
    appName: result['app-name'],
    buildVersion: result['build-version'],
    buildNumber: int.parse(result['build-number']),
    verbose: result['verbose'],
  );

  if (result['apk']) {
    final combinations = <_Combination>[
      (BuildType.debug, BuildFlavour.development, true),
      (BuildType.profile, BuildFlavour.development, false),
      (BuildType.release, BuildFlavour.development, false),
      (BuildType.debug, BuildFlavour.production, false),
      (BuildType.profile, BuildFlavour.production, false),
      (BuildType.release, BuildFlavour.production, false),
    ];
    for (final combination in combinations) {
      final config = userInput.copyWith(
        buildType: combination.$1,
        flavour: combination.$2,
        cleanBeforeBuild: combination.$3,
      );
      final runner = AndroidApkBuildRunner(config: config);
      final exitCode = await runner.startBuild();
      if (exitCode != 0) {
        return exitCode;
      }
    }
  }

  if (result['aab']) {
    final combinations = <_Combination>[
      (BuildType.release, BuildFlavour.production, true),
    ];
    for (final combination in combinations) {
      final config = userInput.copyWith(
        buildType: combination.$1,
        flavour: combination.$2,
        cleanBeforeBuild: combination.$3,
      );
      final runner = AndroidAppBundleBuildRunner(config: config);
      final exitCode = await runner.startBuild();
      if (exitCode != 0) {
        return exitCode;
      }
    }
  }

  if (result['web']) {
    final combinations = <_Combination>[
      (BuildType.profile, BuildFlavour.development, true),
      (BuildType.release, BuildFlavour.development, false),
      (BuildType.profile, BuildFlavour.production, false),
      (BuildType.release, BuildFlavour.production, false),
    ];
    for (final combination in combinations) {
      final config = userInput.copyWith(
        buildType: combination.$1,
        flavour: combination.$2,
        cleanBeforeBuild: combination.$3,
      );
      final runner = WebBuildRunner(config: config);
      final exitCode = await runner.startBuild();
      if (exitCode != 0) {
        return exitCode;
      }
    }
  }

  if (result['mac']) {
    final combinations = <_Combination>[
      (BuildType.debug, BuildFlavour.development, true),
      (BuildType.release, BuildFlavour.development, false),
      (BuildType.debug, BuildFlavour.production, false),
      (BuildType.release, BuildFlavour.production, false),
    ];
    for (final combination in combinations) {
      final config = userInput.copyWith(
        buildType: combination.$1,
        flavour: combination.$2,
        cleanBeforeBuild: combination.$3,
      );
      final runner = MacOSBuildRunner(config: config);
      final exitCode = await runner.startBuild();
      if (exitCode != 0) {
        return exitCode;
      }
    }
  }

  if (result['windows']) {
    final combinations = <_Combination>[
      (BuildType.debug, BuildFlavour.development, true),
      (BuildType.release, BuildFlavour.development, false),
      (BuildType.debug, BuildFlavour.production, false),
      (BuildType.release, BuildFlavour.production, false),
    ];
    for (final combination in combinations) {
      final config = userInput.copyWith(
        buildType: combination.$1,
        flavour: combination.$2,
        cleanBeforeBuild: combination.$3,
      );
      final runner = WindowsBuildRunner(config: config);
      final exitCode = await runner.startBuild();
      if (exitCode != 0) {
        return exitCode;
      }
    }
  }

  return 0;
}

ArgParser _buildParser() {
  final parser = ArgParser();
  parser.addOption('tools-location', abbr: 'f');
  parser.addOption('project-dir', abbr: 'p');
  parser.addOption('artifacts-dir', abbr: 'o');
  parser.addOption('app-name', abbr: 'a');
  parser.addOption('build-version', abbr: 'b');
  parser.addOption('build-number', abbr: 'n');
  parser.addFlag('verbose', abbr: 'v', defaultsTo: false);
  parser.addFlag('apk', defaultsTo: true);
  parser.addFlag('aab', defaultsTo: true);
  parser.addFlag('web', defaultsTo: true);
  parser.addFlag('mac', defaultsTo: Platform.isMacOS);
  parser.addFlag('windows', defaultsTo: Platform.isWindows);
  return parser;
}
