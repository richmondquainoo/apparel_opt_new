import 'package:flutter/material.dart';

import '../../Model/ProductNew.dart';
import 'components/body.dart';

class DetailsScreen extends StatelessWidget {
  static String routeName = "/details";

  @override
  Widget build(BuildContext context) {
    final ProductDetailsArguments agrs =
        ModalRoute.of(context)?.settings.arguments as ProductDetailsArguments;
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: AppBar(),
      body: Body(product: agrs.product!),
    );
  }
}

class ProductDetailsArguments {
  final ProductNew? product;

  ProductDetailsArguments({@required this.product});
}
