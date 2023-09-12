class PromoModel {
  int? id;
  String? category;
  String? imageUrl;

  PromoModel({this.id, this.category, this.imageUrl});

  Map<String, dynamic> toMap() {
    return {'id': id, 'category': category, 'imageUrl': imageUrl};
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'category': category, 'imageUrl': imageUrl};
  }

  @override
  String toString() {
    return 'PromoModel{id: $id, category: $category, imageUrl: $imageUrl}';
  }
}
