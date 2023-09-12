// List<FullCartModel> fullCartModelFromJson(String str) =>
//     List<FullCartModel>.from(
//         json.decode(str).map((x) => FullCartModel.fromJson(x)));

import 'MenuModel.dart';
import 'ProductVariantModel.dart';

class FullCartModel {
  int? id;
  String? type;
  String? price;
  String? size;
  String? imageUrl;
  String? tagName;
  String? description;
  String? ratingFrequency;
  String? cumulativeRating;
  String? branch;
  String? category;
  String? menuItem;
  String? likes;
  String? organization;
  String? publish;
  int? quantity;
  String? product;
  String? brand;
  String? manufacturer;
  String? newArrivals;
  late List<ProductVariantModel> productVariants;
  double? total;
  String? color;
  String? productCategory;

  FullCartModel({
    this.id,
    this.type,
    this.price,
    this.size,
    this.imageUrl,
    this.tagName,
    this.description,
    this.ratingFrequency,
    this.cumulativeRating,
    this.branch,
    this.category,
    this.menuItem,
    this.likes,
    this.organization,
    this.publish,
    this.quantity,
    this.product,
    this.brand,
    this.manufacturer,
    this.newArrivals,
    required this.productVariants,
    this.total,
    this.color,
    this.productCategory
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'price': price,
      'size': size,
      'imageUrl': imageUrl,
      'tagName': tagName,
      'description': description,
      'branch': branch,
      'cumulativeRating': cumulativeRating,
      'ratingFrequency': ratingFrequency,
      'category': category,
      'menuItem': menuItem,
      'organization': organization,
      'publish': publish,
      'quantity': quantity,
      'product': product,
      'productVariants':productVariants,
      'brand':brand,
      'manufacturer':manufacturer,
      'newArrivals':newArrivals,
      'total':total,
      'color':color,
      'productCategory': productCategory,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'price': price,
      'size': size,
      'imageUrl': imageUrl,
      'tagName': tagName,
      'description': description,
      'branch': branch,
      'cumulativeRating': cumulativeRating,
      'ratingFrequency': ratingFrequency,
      'category': category,
      'menuItem': menuItem,
      'organization': organization,
      'publish': publish,
      'quantity': quantity,
      'product': product,
      'productVariants':productVariants,
      'brand':brand,
      'manufacturer':manufacturer,
      'newArrivals':newArrivals,
      'total':total,
      'color':color,
      'productCategory': productCategory,
    };
  }

  FullCartModel.fromJson(Map<dynamic, dynamic> res)
      : id = res['id'],
        type = res["type"],
        price = res["price"],
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
        publish = res["publish"],
        quantity = res["quantity"],
        product = res["product"],
        brand = res["brand"],
        manufacturer = res["manufacturer"],
        newArrivals = res["newArrivals"],
        total = res['total'],
        color = res['color'],
        productVariants = List<ProductVariantModel>.from(res["productVariants"].map((x) => x));

  FullCartModel.fromMap(Map<dynamic, dynamic> res)
      : id = res['id'],
        type = res["type"],
        price = res["price"],
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
        publish = res["publish"],
        quantity = res["quantity"],
        product = res["product"],
        brand = res["brand"],
        manufacturer = res["manufacturer"],
        newArrivals = res["newArrivals"],
        total = res['total'],
        color = res['color'],
        productVariants = List<ProductVariantModel>.from(res["productVariants"].map((x) => x));

  @override
  String toString() {
    return 'FullCartModel{id: $id, type: $type, price: $price, size: $size, imageUrl: $imageUrl, tagName: $tagName, description: $description, ratingFrequency: $ratingFrequency, cumulativeRating: $cumulativeRating, branch: $branch, category: $category, menuItem: $menuItem, likes: $likes, organization: $organization, publish: $publish, quantity: $quantity, product: $product, brand: $brand, manufacturer: $manufacturer, newArrivals: $newArrivals, productVariants: $productVariants, total: $total, color: $color}';
  }
}
