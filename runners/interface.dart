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
  List<String> get cleanArguments {
    final arguments = <String>[];
    arguments.add('clean');

    if (config.verbose == true) {
      arguments.add('--verbose');
    }

    return arguments;
  }

  @mustCallSuper
  @protected
  List<String> get getPackagesArguments {
    final arguments = <String>[];
    arguments.add('pub');
    arguments.add('get');

    if (config.verbose == true) {
      arguments.add('--verbose');
    }

    return arguments;
  }

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

    // 1: CLEAN
    if (config.cleanBeforeBuild) {
      try {
        final result = await clean();
        exitCode = result.exitCode;
        if (exitCode != 0) {
          stderr.writeln('FAILED: Clean action for $platformNameForHuman.');
          stderr.writeln(result.toolsErrorOutput);
          return exitCode;
        }
      } catch (e) {
        stderr.writeln('FAILED: Clean action for $platformNameForHuman.');
        return ExitCodes.buildRunnerCleanFailed;
      }
    }

    // 3: GET PACKAGES
    if (config.cleanBeforeBuild) {
      try {
        final result = await getPackages();
        exitCode = result.exitCode;
        if (exitCode != 0) {
          stderr.writeln('FAILED: Get-Packages action for $platformNameForHuman.');
          stderr.writeln(result.toolsErrorOutput);
          return exitCode;
        }
      } catch (e) {
        stderr.writeln('FAILED: Get-Packages action for $platformNameForHuman.');
        return ExitCodes.buildRunnerGetPackagesFailed;
      }
    }

    // 3: PRE-BUILD
    try {
      exitCode = await preBuild();
      if (exitCode != 0) {
        stderr.writeln('FAILED: Pre-Build action for $platformNameForHuman.');
        return exitCode;
      }
    } catch (e) {
      stderr.writeln('FAILED: Pre-Build action for $platformNameForHuman.');
      return ExitCodes.buildRunnerPreBuildFailed;
    }

    // 4: BUILD
    try {
      final result = await build();
      exitCode = result.exitCode;
      if (exitCode != 0) {
        stderr.writeln('FAILED: Build action for $platformNameForHuman.');
        stderr.writeln(result.toolsErrorOutput);
        return exitCode;
      }
    } catch (e) {
      stderr.writeln('FAILED: Build action for $platformNameForHuman.');
      return ExitCodes.buildRunnerBuildFailed;
    }

    // 5: COPY OUTPUT FILE
    try {
      exitCode = await copyOutputFile();
      if (exitCode != 0) {
        stderr.writeln('FAILED: Post-Build action for $platformNameForHuman.');
        return exitCode;
      }
    } catch (e) {
      stderr.writeln('FAILED: Post-Build action for $platformNameForHuman.');
      return ExitCodes.buildRunnerCopyOutputFileFailed;
    }

    // 6: COPY OUTPUT FOLDER
    try {
      exitCode = await copyOutputDirectory();
      if (exitCode != 0) {
        stderr.writeln('FAILED: Post-Build action for $platformNameForHuman.');
        return exitCode;
      }
    } catch (e) {
      stderr.writeln('FAILED: Post-Build action for $platformNameForHuman.');
      return ExitCodes.buildRunnerCopyOutputDirectoryFailed;
    }

    return exitCode;
  }

  @mustCallSuper
  @protected
  Future<BuildResult> clean() async {
    print('$platformNameForHuman: Running Clean action.');

    final result = await Process.run(
      toolsLocation,
      cleanArguments,
      workingDirectory: config.projectDirectory,
    );

    final exitCode = result.exitCode;
    if (exitCode != 0) {
      return BuildResult(exitCode: exitCode, toolsErrorOutput: result.stderr);
    }

    return BuildResult(exitCode: exitCode);
  }

  @mustCallSuper
  @protected
  Future<BuildResult> getPackages() async {
    print('$platformNameForHuman: Running Get-Packages action.');

    final result = await Process.run(
      toolsLocation,
      getPackagesArguments,
      workingDirectory: config.projectDirectory,
    );

    final exitCode = result.exitCode;
    if (exitCode != 0) {
      return BuildResult(exitCode: exitCode, toolsErrorOutput: result.stderr);
    }

    return BuildResult(exitCode: exitCode);
  }

  @mustCallSuper
  @protected
  Future<int> preBuild() async {
    print('$platformNameForHuman: Running Pre-Build action.');
    return 0;
  }

  @mustCallSuper
  @protected
  Future<BuildResult> build() async {
    print('$platformNameForHuman: Running Build action.');

    final result = await Process.run(
      toolsLocation,
      buildArguments,
      workingDirectory: config.projectDirectory,
    );

    final exitCode = result.exitCode;
    if (exitCode != 0) {
      return BuildResult(exitCode: exitCode, toolsErrorOutput: result.stderr);
    }

    return BuildResult(exitCode: exitCode);
  }

  @mustCallSuper
  @protected
  Future<int> copyOutputFile() async {
    print('$platformNameForHuman: Running Post-Build action.');

    if (outputFilePath == null) {
      return 0;
    }

    final fullPath = path.join(config.projectDirectory, outputFilePath);
    final file = File(fullPath);
    final ext = path.extension(outputFilePath);
    final outputName = '${getOutputName(config)}$ext';
    final outputPath = path.join(config.artifactsDirectory, outputName);

    await file.copy(outputPath);
    return 0;
  }

  @mustCallSuper
  @protected
  Future<int> copyOutputDirectory() async {
    print('$platformNameForHuman: Running Post-Build action.');

    if (outputDirectoryPath == null) {
      return 0;
    }

    final fullPath = path.join(config.projectDirectory, outputDirectoryPath);
    await for (final file in Directory(fullPath).list(recursive: true)) {
      if (file is File) {
        final fileRelativePath = path.relative(file.path, from: fullPath);
        final outputFolderName = getOutputName(config);
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

  @mustCallSuper
  @protected
  String getOutputName(BuildConfig config) {
    var name = config.appName.replaceAll(' ', '-');
    name += '-v${config.buildVersion}b${config.buildNumber}';
    name += '-${config.flavour.outputName}';
    name += '-${config.buildType.outputName}';
    name += '-${platformNameForOutput}';

    return name;
  }
}

class BuildResult {
  // ---------------------------- CONSTRUCTORS ----------------------------
  const BuildResult({
    this.toolsErrorOutput,
    this.exitCode,
  });

  // ------------------------------- FIELDS -------------------------------
  final dynamic toolsErrorOutput;
  final int exitCode;
}
