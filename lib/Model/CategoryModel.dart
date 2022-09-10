class CategoryModel {
  int id;
  String category;
  String imageUrl;

  CategoryModel({this.id, this.category, this.imageUrl});

  Map<String, dynamic> toMap() {
    return {'id': id, 'category': category, 'imageUrl': imageUrl};
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'category': category, 'imageUrl': imageUrl};
  }

  @override
  String toString() {
    return 'CategoryModel{id: $id, category: $category, imageUrl: $imageUrl}';
  }
}
