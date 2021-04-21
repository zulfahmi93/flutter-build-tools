enum BuildType {
  unknown,
  debug,
  profile,
  release,
}

extension BuildTypeExtensions on BuildType {
  String get buildCommand {
    return this.outputName.toLowerCase();
  }

  String get outputName {
    switch (this) {
      case BuildType.debug:
        return 'Debug';
      case BuildType.profile:
        return 'Profile';
      case BuildType.release:
        return 'Release';
      default:
        throw UnimplementedError();
    }
  }
}
