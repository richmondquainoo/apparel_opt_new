import 'dart:convert';

List<ProductSpecificationModel> productSpecificationModelFromJson(String str) => List<ProductSpecificationModel>.from(json.decode(str).map((x) => ProductSpecificationModel.fromJson(x)));

String productSpecificationModelToJson(List<ProductSpecificationModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductSpecificationModel {
  ProductSpecificationModel({
    this.id,
    this.organization,
    this.specification,
    this.value,
    this.createdBy,
    this.productId,
  });

  int id;
  String organization;
  String specification;
  String value;
  String createdBy;
  int productId;

  factory ProductSpecificationModel.fromJson(Map<String, dynamic> json) => ProductSpecificationModel(
    id: json["id"],
    organization: json["organization"],
    specification: json["specification"],
    value: json["value"],
    createdBy: json["createdBy"],
    productId: json["productId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "organization": organization,
    "specification": specification,
    "value": value,
    "createdBy": createdBy,
    "productId": productId,
  };

  Map<String, dynamic> toMap() => {
    "id": id,
    "organization": organization,
    "specification": specification,
    "value": value,
    "createdBy": createdBy,
    "productId": productId,
  };

  @override
  String toString() {
    return 'ProductSpecificationModel{id: $id, organization: $organization, specification: $specification, value: $value, createdBy: $createdBy, productId: $productId}';
  }
}