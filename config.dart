import 'constants/constants.dart';

class BuildConfig {
  // ---------------------------- CONSTRUCTORS ----------------------------
  const BuildConfig({
    required this.toolsLocation,
    required this.projectDirectory,
    required this.artifactsDirectory,
    required this.appName,
    required this.buildVersion,
    required this.buildNumber,
    this.buildType = BuildType.unknown,
    this.flavour = BuildFlavour.unknown,
    this.verbose = false,
    this.cleanBeforeBuild = true,
  });

  // ------------------------------- FIELDS -------------------------------
  final String toolsLocation;
  final String projectDirectory;
  final String artifactsDirectory;
  final String appName;
  final String buildVersion;
  final BuildType buildType;
  final BuildFlavour flavour;
  final int buildNumber;
  final bool verbose;
  final bool cleanBeforeBuild;

  // ------------------------------- METHODS ------------------------------
  BuildConfig copyWith({
    required BuildType buildType,
    required BuildFlavour flavour,
    required bool cleanBeforeBuild,
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
    );
  }
}
