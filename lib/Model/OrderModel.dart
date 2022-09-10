// To parse this JSON data, do
//
//     final orderModel = orderModelFromJson(jsonString);

import 'dart:convert';

OrderModel orderModelFromJson(String str) => OrderModel.fromJson(json.decode(str));

String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
  OrderModel({
    this.orderNo,
    this.orderBy,
    this.orderPhone,
    this.orderAddress,
    this.orderEmail,
    this.orderDetail,
    this.orderAdditionalInfo,
    this.orderTotalAmount,
    this.orderBranch,
    this.paymentAmount,
    this.paymentMode,
    this.channel,
    this.deliveryOption,
    this.orderLat,
    this.orderLon,
    this.orderItemCost,
    this.orderTakenBy,
    this.organizationName,
    this.organizationCode,
    this.orderQuantity,
    this.products,
  });

  String orderNo;
  String orderBy;
  String orderPhone;
  String orderAddress;
  String orderEmail;
  String orderDetail;
  String orderAdditionalInfo;
  int orderTotalAmount;
  String orderBranch;
  int paymentAmount;
  String paymentMode;
  String channel;
  String deliveryOption;
  double orderLat;
  double orderLon;
  int orderItemCost;
  String orderTakenBy;
  String organizationName;
  String organizationCode;
  int orderQuantity;
  List<Product> products;

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    orderNo: json["orderNo"],
    orderBy: json["orderBy"],
    orderPhone: json["orderPhone"],
    orderAddress: json["orderAddress"],
    orderEmail: json["orderEmail"],
    orderDetail: json["orderDetail"],
    orderAdditionalInfo: json["orderAdditionalInfo"],
    orderTotalAmount: json["orderTotalAmount"],
    orderBranch: json["orderBranch"],
    paymentAmount: json["paymentAmount"],
    paymentMode: json["paymentMode"],
    channel: json["channel"],
    deliveryOption: json["deliveryOption"],
    orderLat: json["orderLat"].toDouble(),
    orderLon: json["orderLon"].toDouble(),
    orderItemCost: json["orderItemCost"],
    orderTakenBy: json["orderTakenBy"],
    organizationName: json["organizationName"],
    organizationCode: json["organizationCode"],
    orderQuantity: json["orderQuantity"],
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "orderNo": orderNo,
    "orderBy": orderBy,
    "orderPhone": orderPhone,
    "orderAddress": orderAddress,
    "orderEmail": orderEmail,
    "orderDetail": orderDetail,
    "orderAdditionalInfo": orderAdditionalInfo,
    "orderTotalAmount": orderTotalAmount,
    "orderBranch": orderBranch,
    "paymentAmount": paymentAmount,
    "paymentMode": paymentMode,
    "channel": channel,
    "deliveryOption": deliveryOption,
    "orderLat": orderLat,
    "orderLon": orderLon,
    "orderItemCost": orderItemCost,
    "orderTakenBy": orderTakenBy,
    "organizationName": organizationName,
    "organizationCode": organizationCode,
    "orderQuantity": orderQuantity,
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
  };
}

class Product {
  Product({
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
    this.selected,
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
  int price;
  int total;
  bool selected;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
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
    selected: json["selected"] == null ? null : json["selected"],
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
    "selected": selected == null ? null : selected,
  };
}
