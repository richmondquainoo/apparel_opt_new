import 'dart:convert';

List<ProductDetailsModel> productDetailsModelFromJson(String str) => List<ProductDetailsModel>.from(json.decode(str).map((x) => ProductDetailsModel.fromJson(x)));

String productDetailsModelToJson(List<ProductDetailsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductDetailsModel {
  ProductDetailsModel({
    this.id,
    this.organization,
    this.header,
    this.details,
    this.createdBy,
    this.productId,
  });

  int? id;
  String? organization;
  String? header;
  String? details;
  String? createdBy;
  int? productId;

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) => ProductDetailsModel(
    id: json["id"],
    organization: json["organization"],
    header: json["header"],
    details: json["details"],
    createdBy: json["createdBy"],
    productId: json["productId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "organization": organization,
    "header": header,
    "details": details,
    "createdBy": createdBy,
    "productId": productId,
  };

  Map<String, dynamic> toMap() => {
    "id": id,
    "organization": organization,
    "header": header,
    "details": details,
    "createdBy": createdBy,
    "productId": productId,
  };

  @override
  String toString() {
    return 'ProductDetailsModel{id: $id, organization: $organization, header: $header, details: $details, createdBy: $createdBy, productId: $productId}';
  }
}