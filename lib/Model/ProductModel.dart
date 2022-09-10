
class ProductModel {
  ProductModel({
    this.id,
    this.productId,
    this.color,
    this.colorCode,
    this.imageUrl,
    this.quantity,
    this.sizes,
    this.productVariantId,
    this.productName,
    this.productCategory,
    this.price,
    this.total,

  });

  int id;
  int productId;
  String color;
  String colorCode;
  String imageUrl;
  int quantity;
  String sizes;
  int productVariantId;
  String productName;
  String productCategory;
  double price;
  double total;
  // bool selected;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json["id"],
    productId: json["productId"],
    color: json["color"],
    colorCode: json["colorCode"],
    imageUrl: json["imageUrl"],
    quantity: json["quantity"],
    sizes: json["sizes"],
    productVariantId: json["productVariantId"],
    productName: json["productName"],
    productCategory: json["productCategory"],
    price: json["price"],
    total: json["total"],
    // selected: json["selected"] == null ? null : json["selected"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "productId": productId,
    "color": color,
    "colorCode": colorCode,
    "imageUrl": imageUrl,
    "quantity": quantity,
    "sizes": sizes,
    "productVariantId": productVariantId,
    "productName": productName,
    "productCategory": productCategory,
    "price": price,
    "total": total,
    // "selected": selected == null ? null : selected,
  };

  Map<String, dynamic> toMap() => {
    "id": id,
    "productId": productId,
    "color": color,
    "colorCode": colorCode,
    "imageUrl": imageUrl,
    "quantity": quantity,
    "sizes": sizes,
    "productVariantId": productVariantId,
    "productName": productName,
    "productCategory": productCategory,
    "price": price,
    "total": total,
    // "selected": selected == null ? null : selected,
  };

  @override
  String toString() {
    return 'ProductModel{id: $id, productId: $productId, color: $color, colorCode: $colorCode, imageUrl: $imageUrl, quantity: $quantity, sizes: $sizes, productVariantId: $productVariantId, productName: $productName, productCategory: $productCategory, price: $price, total: $total}';
  }
}