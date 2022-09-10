class CartModel {
  int id;
  String type;
  double price;
  double total;
  String size;
  String imageUrl;
  String tagName;
  String description;
  double ratingFrequency;
  double cumulativeRating;
  String branch;
  String category;
  String menuItem;
  int likes;
  String organization;
  String kitchen;
  int quantity;

  CartModel({
    this.id,
    this.type,
    this.price,
    this.total,
    this.size,
    this.imageUrl,
    this.tagName,
    this.branch,
    this.cumulativeRating,
    this.ratingFrequency,
    this.description,
    this.category,
    this.menuItem,
    this.likes,
    this.organization,
    this.kitchen,
    this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'price': price,
      'total': total,
      'size': size,
      'imageUrl': imageUrl,
      'tagName': tagName,
      'description': description,
      'branch': branch,
      'cumulativeRating': cumulativeRating,
      'ratingFrequency': ratingFrequency,
      'category': category,
      'menuItem': menuItem,
      'likes': likes,
      'organization': organization,
      'kitchen': kitchen,
      'quantity': quantity,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'price': price,
      'total': total,
      'size': size,
      'imageUrl': imageUrl,
      'tagName': tagName,
      'description': description,
      'branch': branch,
      'cumulativeRating': cumulativeRating,
      'ratingFrequency': ratingFrequency,
      'category': category,
      'menuItem': menuItem,
      'likes': likes,
      'organization': organization,
      'kitchen': kitchen,
      'quantity': quantity,
    };
  }

  CartModel.fromMap(Map<dynamic, dynamic> res)
      : id = res['id'],
        type = res["type"],
        price = res["price"],
        total = res["total"],
        size = res["size"],
        imageUrl = res["imageUrl"],
        tagName = res["tagName"],
        description = res["description"],
        branch = res["branch"],
        cumulativeRating = res["cumulativeRating"],
        ratingFrequency = res["ratingFrequency"],
        category = res["category"],
        menuItem = res["menuItem"],
        likes = res["likes"],
        organization = res["organization"],
        kitchen = res["kitchen"],
        quantity = res["quantity"];

  @override
  String toString() {
    return 'CartModel{id: $id, type: $type, price: $price, total: $total, size: $size, imageUrl: $imageUrl, tagName: $tagName, description: $description, ratingFrequency: $ratingFrequency, cumulativeRating: $cumulativeRating, branch: $branch, category: $category, menuItem: $menuItem, likes: $likes, organization: $organization, kitchen: $kitchen, quantity: $quantity}';
  }
}
