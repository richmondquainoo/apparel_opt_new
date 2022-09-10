class Product {
  final String name;
  final String brand;
  final String imageURL;
  final String size;
  final String price;

  Product(this.name, this.brand, this.imageURL, this.size, this.price);

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(json["name"], json["brand"], json["imageURL"], json["size"],
        json["price"]);
  }
}
