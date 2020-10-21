import 'dart:io';

import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;

import '../config.dart';
import '../constants/constants.dart';

abstract class BuildRunner {
  // ---------------------------- CONSTRUCTORS ----------------------------
  const BuildRunner({
    this.config,
  });

  // ------------------------------- FIELDS -------------------------------
  final BuildConfig config;

  // ----------------------------- PROPERTIES -----------------------------
  @protected
  String get platformName;

  @protected
  String get platformNameForHuman;

  @protected
  String get platformNameForOutput;

  @protected
  String get toolsChannel;

  @protected
  bool get includeBuildVersion;

  @protected
  bool get includeBuildNumber;

  @protected
  String get outputFilePath => null;

  @protected
  String get outputDirectoryPath => null;

  @protected
  String get toolsLocation =>
      config.toolsLocation.replaceFirst('%s', toolsChannel);

  @mustCallSuper
  @protected
  List<String> get buildArguments {
    final arguments = <String>[];
    arguments.add('build');
    arguments.add(platformName);
    arguments.add('--${config.buildType.buildCommand}');
    arguments.add('--target=lib/main.${config.flavour.buildCommand}.dart');

    if (config.verbose == true) {
      arguments.add('--verbose');
    }

    if (includeBuildVersion) {
      arguments.add('--build-name=${config.buildVersion}');
    }

    if (includeBuildNumber) {
      arguments.add('--build-number=${config.buildNumber}');
    }

    if (config.toolsLocation == 'web' && config.webBuildConfig != null) {
      final w1 = config.webBuildConfig.useSkia.toString();
      final w2 = config.webBuildConfig.useCanvasText.toString();
      arguments.add('--dart-define=FLUTTER_WEB_USE_SKIA=$w1');
      arguments
          .add('--dart-define=FLUTTER_WEB_USE_EXPERIMENTAL_CANVAS_TEXT=$w2');
    }

    return arguments;
  }

  // ------------------------------- METHODS ------------------------------
  Future<int> startBuild() async {
    final flavour = config.flavour.buildCommand.toUpperCase();
    final releaseType = config.buildType.buildCommand.toUpperCase();
    print('Building $platformNameForHuman | $flavour | $releaseType');

    int exitCode = 0;

    // 1: PRE-BUILD
    try {
      exitCode = await preBuild();
      if (exitCode != 0) {
        return exitCode;
      }
    } catch (e) {
      return ExitCodes.buildRunnerPreBuildFailed;
    }

    // 2: BUILD
    try {
      final result = await Process.run(
        toolsLocation,
        buildArguments,
        workingDirectory: config.projectDirectory,
      );

      exitCode = result.exitCode;
      if (exitCode != 0) {
        return exitCode;
      }
    } catch (e) {
      return ExitCodes.buildRunnerBuildFailed;
    }

    // 3: COPY OUTPUT FILE
    try {
      exitCode = await copyOutputFile();
      if (exitCode != 0) {
        return exitCode;
      }
    } catch (e) {
      return ExitCodes.buildRunnerCopyOutputFileFailed;
    }

    // 4: COPY OUTPUT FOLDER
    try {
      exitCode = await copyOutputDirectory();
      if (exitCode != 0) {
        return exitCode;
      }
    } catch (e) {
      return ExitCodes.buildRunnerCopyOutputDirectoryFailed;
    }

    return exitCode;
  }

  @protected
  Future<int> preBuild() async => 0;

  @protected
  Future<int> copyOutputFile() async {
    if (outputFilePath == null) {
      return 0;
    }

    final fullPath = path.join(config.projectDirectory, outputFilePath);
    final file = File(fullPath);
    final ext = path.extension(outputFilePath);
    final outputName = '${_getOutputName(config)}.$ext';
    final outputPath = path.join(config.artifactsDirectory, outputName);

    await file.copy(outputPath);
    return 0;
  }

  @protected
  Future<int> copyOutputDirectory() async {
    if (outputDirectoryPath == null) {
      return 0;
    }

    final fullPath = path.join(config.projectDirectory, outputDirectoryPath);
    await for (final file in Directory(fullPath).list(recursive: true)) {
      if (file is File) {
        final fileRelativePath = path.relative(file.path, from: fullPath);
        final outputFolderName = _getOutputName(config);
        final newFilePath = path.join(
          config.artifactsDirectory,
          outputFolderName,
          fileRelativePath,
        );

        await Directory(path.dirname(newFilePath)).create(recursive: true);
        await file.copy(newFilePath);
      }
    }

    return 0;
  }

  String _getOutputName(BuildConfig config) {
    var name = config.appName.replaceAll(' ', '-');
    name += '-v${config.buildVersion}b${config.buildNumber}';
    name += '-${config.flavour.outputName}';
    name += '-${config.buildType.outputName}';
    name += '-${platformNameForOutput}';

    return name;
  }
}
