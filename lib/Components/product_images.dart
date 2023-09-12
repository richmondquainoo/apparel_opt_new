import 'package:apparel_options/Model/ProductCardModel.dart';
import 'package:flutter/material.dart';

class ProductImages extends StatefulWidget {
  const ProductImages({
    Key? key,
    @required this.product,
  }) : super(key: key);

  final ProductCardModel? product;

  @override
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  int selectedImage = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: (238),
          child: AspectRatio(
            aspectRatio: 1,
            child: Hero(
              tag: widget.product!.id.toString(),
              child: Image.asset(widget.product!.images![selectedImage]),
            ),
          ),
        ),
        // SizedBox(height: getProportionateScreenWidth(20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(widget.product!.images!.length,
                (index) => buildSmallProductPreview(index)),
          ],
        )
      ],
    );
  }

  GestureDetector buildSmallProductPreview(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = index;
        });
      },
      child: AnimatedContainer(
        // duration: ,
        margin: EdgeInsets.only(right: 15),
        padding: EdgeInsets.all(8),
        height: (48),
        width: (48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: Colors.teal.withOpacity(selectedImage == index ? 1 : 0)),
        ),
        duration: null!,
        child: Image.asset(widget.product!.images![index]),
      ),
    );
  }
}
