class StarCategoryModel {
  String? lightModeImage;
  String? darkModeImage;
  String? name;

  StarCategoryModel(this.lightModeImage, this.name, this.darkModeImage);

  // Override == to compare by id or name
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StarCategoryModel && other.name == name;
  }

  // Override hashCode
  @override
  int get hashCode => name.hashCode;
}
