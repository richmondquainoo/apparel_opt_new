import 'package:flutter/material.dart';

import '../../../Model/ProductNew.dart';
import 'product_images.dart';

class Body extends StatelessWidget {
  final ProductNew product;

  const Body({Key key, @required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ProductImages(product: product),
      ],
    );
  }
}
