import 'constants/constants.dart';

class BuildConfig {
  // ---------------------------- CONSTRUCTORS ----------------------------
  const BuildConfig({
    this.toolsLocation,
    this.projectDirectory,
    this.artifactsDirectory,
    this.appName,
    this.buildType,
    this.flavour,
    this.buildVersion,
    this.buildNumber,
    this.verbose,
    this.cleanBeforeBuild,
    this.webBuildConfig,
  });

  // ------------------------------- FIELDS -------------------------------
  final String toolsLocation;
  final String projectDirectory;
  final String artifactsDirectory;
  final String appName;
  final BuildType buildType;
  final BuildFlavour flavour;
  final String buildVersion;
  final int buildNumber;
  final bool verbose;
  final bool cleanBeforeBuild;
  final WebBuildConfig webBuildConfig;

  // ------------------------------- METHODS ------------------------------
  BuildConfig copyWith({
    final BuildType buildType,
    final BuildFlavour flavour,
    final bool cleanBeforeBuild,
  }) {
    return BuildConfig(
      toolsLocation: toolsLocation,
      projectDirectory: projectDirectory,
      artifactsDirectory: artifactsDirectory,
      appName: appName,
      buildType: buildType,
      flavour: flavour,
      buildVersion: buildVersion,
      buildNumber: buildNumber,
      verbose: verbose,
      cleanBeforeBuild: cleanBeforeBuild,
      webBuildConfig: webBuildConfig,
    );
  }
}

class WebBuildConfig {
  // ---------------------------- CONSTRUCTORS ----------------------------
  const WebBuildConfig({
    this.useSkia,
    this.useCanvasText,
  });

  // ------------------------------- FIELDS -------------------------------
  final bool useSkia;
  final bool useCanvasText;
}
