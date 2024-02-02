enum BuildFlavour {
  unknown,
  development,
  staging,
  production,
}

extension BuildFlavourExtensions on BuildFlavour {
  String get buildCommand {
    switch (this) {
      case BuildFlavour.development:
        return 'development';
      case BuildFlavour.staging:
        return 'staging';
      case BuildFlavour.production:
        return 'production';
      default:
        throw UnimplementedError();
    }
  }

  String get outputName {
    switch (this) {
      case BuildFlavour.development:
        return 'Dev';
      case BuildFlavour.staging:
        return 'Alpha';
      case BuildFlavour.production:
        return 'Live';
      default:
        throw UnimplementedError();
    }
  }
}
