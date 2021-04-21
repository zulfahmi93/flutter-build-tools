enum BuildFlavour {
  unknown,
  development,
  production,
}

extension BuildFlavourExtensions on BuildFlavour {
  String get buildCommand {
    switch (this) {
      case BuildFlavour.development:
        return 'development';
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
      case BuildFlavour.production:
        return 'Live';
      default:
        throw UnimplementedError();
    }
  }
}
