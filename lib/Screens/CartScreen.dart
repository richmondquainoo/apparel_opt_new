import 'dart:convert';

import 'package:apparel_options/Screens/CheckoutScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../Constants/constantColors.dart';
import '../Constants/myColors.dart';
import '../Model/AppData.dart';
import '../Model/FullCartModel.dart';
import '../Model/ProductModel.dart';
import '../Model/ProductNew.dart';
import '../Utils/Utility.dart';
import '../animation/FadeAnimation.dart';
import 'ProductDetails.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with TickerProviderStateMixin {
  List<dynamic> productList = [];
  List<dynamic> cartItems = [];
  List<int> cartItemCount = [1, 1, 1, 1];
  double totalPrice = 0;

  Future<void> fetchItems() async {
    final String response = await rootBundle.loadString('assets/products.json');
    final data = await json.decode(response);

    setState(() {
      cartItems = demoProducts;
    });

    sumTotal();
  }

  sumTotal() {
    cartItems.forEach((item) {
      totalPrice = item.price + totalPrice;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchItems().whenComplete(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBackgroundTheme,
        persistentFooterButtons: [
          Consumer<AppData>(builder: (context, value, child) {
            return Visibility(
              visible: value.getCartCount() > 0 ? true : false,
              child: Column(
                children: [
                  ReusableWidget(
                    title: 'Total',
                    value: r'GHS ' + value.getCartTotal().toStringAsFixed(2),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  FadeAnimation(
                      0,
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10),
                        child: MaterialButton(
                          onPressed: () {
                            // debugPrint("Day: ${product}");
                            // dbHelper.getCartSummary();
                            // new UtilityService().confirmationBox(
                            //     title: 'Confirmation',
                            //     message:
                            //         'Are you sure you want to proceed with purchase?',
                            //     context: context,
                            //     yesButtonColor: Colors.amber,
                            //     noButtonColor: Colors.amber,
                            //     // color: Colors.blueAccent,
                            //     onYes: () {
                            //       Navigator.pop(context);
                            //       Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //           builder: (context) => CheckOutScreen(),
                            //         ),
                            //       );
                            //     },
                            //     onNo: () {
                            //       Navigator.pop(context);
                            //     });

                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Center(
                                      child: Text(
                                        "Confirmation",
                                        style: GoogleFonts.raleway(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ),
                                    content: Text(
                                      "Are you sure you want to proceed to checkout?",
                                      style: GoogleFonts.raleway(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        child: FlatButton(
                                          height: 34,
                                          color: Colors.teal.shade400,
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => CheckOutScreen(),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            "Yes",
                                            style: GoogleFonts.raleway(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                              letterSpacing: 0.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(bottom: 8.0, right: 8),
                                        child: FlatButton(
                                            height: 34,
                                            color: LABEL_COLOR,
                                            onPressed: () {
                                              Navigator.pop(context); //close Dialog
                                            },
                                            child: Text(
                                              "No",
                                              style: GoogleFonts.raleway(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                                letterSpacing: 0.0,
                                              ),
                                            )),
                                      ),
                                      SizedBox(width: 35,),
                                    ],
                                  );
                                });

                          },
                          height: 50,
                          elevation: 0,
                          splashColor: Colors.yellow[700],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Colors.black,
                          child: Center(
                            child: Text(
                              "Next",
                              style: GoogleFonts.raleway(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            );
          }),
          SizedBox(
            height: 4,
          ),
        ],
        appBar: AppBar(
          backgroundColor: Colors.grey.shade50,
          elevation: 0.5,
          automaticallyImplyLeading: false,
          title: Center(
            child: Text(
              "Cart",
              style: GoogleFonts.raleway(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                letterSpacing: .75,
              ),
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: kPrimaryTextColor,
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: loadCartListNew(context, 1),
        )));
  }

  List<Padding> loadCartListNew(
    BuildContext context,
    int index,
  ) {
    final cartItems = Provider.of<AppData>(context).cartItemNew;
    List<Padding> list = [];
    try {
      if (cartItems.isNotEmpty) {
        for (ProductModel cart in cartItems) {
          list.add(
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: GestureDetector(
                onTap: () {},
                child: Card(
                  child: Container(
                    height: 155,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 1.0, right: 5, top: 0, bottom: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 35,
                                ),
                                CachedNetworkImage(
                                  imageUrl: cart.imageUrl.toString(),
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(58),
                                      border: Border.all(
                                        color: Colors
                                            .black12, //                   <--- border color
                                        width: 1.0,
                                      ),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  height: 90,
                                  width: 90,
                                  fit: BoxFit.cover,
                                  color: Colors.black12,
                                  colorBlendMode: BlendMode.darken,
                                  placeholder: (context, url) => Container(
                                    height: 30,
                                    width: 30,
                                    child: Image.asset(
                                        "assets/images/cachedShirt.png"),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    "assets/images/cachedShirt.png",
                                    height: 30,
                                    width: 30,
                                  ),
                                )
                                // Container(
                                //   child: CircleAvatar(
                                //     radius: 41,
                                //     backgroundColor: SECOND_COLOR,
                                //     child: CircleAvatar(
                                //       backgroundColor: Colors.red,
                                //       backgroundImage:
                                //           NetworkImage(cart.imageUrl),
                                //       radius: 40,
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            child: Text(cart.productName,
                                                style: GoogleFonts.raleway(
                                                    fontSize: 12  ,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500)),
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                                Divider(
                                  thickness: 0.23,
                                  color: Colors.black,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  child: Text("Size:  ",
                                                      style: GoogleFonts.lato(
                                                          fontSize: 13,
                                                          color: primaryColor,
                                                          fontWeight:
                                                          FontWeight.w500)),
                                                ),
                                                Container(
                                                  child: Text(cart.sizes,
                                                      style: GoogleFonts.lato(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              child: Text(
                                                'Price: ',
                                                style: GoogleFonts.raleway(
                                                    fontSize: 13,
                                                    color: Colors.teal,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                "${cart.quantity.toString()} x ${cart.price} | GHS ${cart.total.toStringAsFixed(2)}",
                                                style: GoogleFonts.lato(
                                                    fontSize: 13,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 36,
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.teal.shade100),
                                      child: Row(
                                        children: [
                                          cart.quantity != 1
                                              ? IconButton(
                                                  icon: new Icon(
                                                    Icons.remove,
                                                    size: 15,
                                                  ),
                                                  onPressed: () {
                                                    cart.quantity -= 1;
                                                    cart.total = cart.quantity * cart.price;
                                                    Provider.of<AppData>(
                                                            context,
                                                            listen: false)
                                                        .updateCartItem(cart);
                                                  })
                                              : Text(""),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 3),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                                color: Colors.white),
                                            child: Text(
                                              cart.quantity.toString(),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15),
                                            ),
                                          ),
                                          IconButton(
                                              icon: Icon(
                                                Icons.add,
                                                size: 15,
                                              ),
                                              onPressed: () {
                                                cart.quantity += 1;
                                                cart.total =
                                                    cart.quantity * cart.price;
                                                Provider.of<AppData>(context,
                                                        listen: false)
                                                    .updateCartItem(cart);
                                              }),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Provider.of<AppData>(context,
                                                      listen: false)
                                                  .removeCartItem(cart);
                                              final snackBar = SnackBar(
                                                content: const Text(
                                                    "Item removed from cart"),
                                                duration: Duration(seconds: 2),
                                                action: SnackBarAction(
                                                  label: "",
                                                  textColor: Colors.black,
                                                  onPressed: () {},
                                                ),
                                              );

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            },
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.redAccent.shade100,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      }

      return list;
    } catch (e) {
      debugPrint('Error pizza list: $e');
      return null;
    }
  }

  cartItem(ProductNew product, int index, animation) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetails(product: product)));
      },
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
            .animate(animation),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(0, 2),
                blurRadius: 6,
              ),
            ],
          ),
          child: Row(children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  product.images[0],
                  fit: BoxFit.contain,
                  height: 90,
                  width: 100,
                ),
              ),
            ),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 7,
                    ),
                    Text(
                      product.brand,
                      style: GoogleFonts.raleway(
                        color: LABEL_COLOR,
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Text(
                      product.title,
                      style: GoogleFonts.raleway(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      "GHS " + product.price.toString(),
                      style: GoogleFonts.lato(
                          fontSize: 14,
                          color: LABEL_COLOR,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 10),
                  ]),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MaterialButton(
                  minWidth: 10,
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    setState(() {
                      if (cartItemCount[index] > 1) {
                        cartItemCount[index]--;
                        totalPrice = totalPrice - product.price;
                      }
                    });
                  },
                  shape: const CircleBorder(),
                  child: Icon(
                    Icons.remove_circle_outline,
                    color: Colors.grey.shade400,
                    size: 27,
                  ),
                ),
                Container(
                  child: Center(
                    child: Text(
                      cartItemCount[index].toString(),
                      style: GoogleFonts.raleway(
                          fontSize: 16, color: Colors.grey.shade800),
                    ),
                  ),
                ),
                MaterialButton(
                  padding: EdgeInsets.all(0),
                  minWidth: 10,
                  splashColor: Colors.yellow[700],
                  onPressed: () {
                    setState(() {
                      cartItemCount[index]++;
                      totalPrice = totalPrice + product.price;
                    });
                  },
                  shape: CircleBorder(),
                  child: const Icon(
                    Icons.add_circle,
                    size: 27,
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;
  const ReusableWidget({this.title, this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            title.toString(),
            style: GoogleFonts.ibmPlexSans(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Text(
            value.toString(),
            style: GoogleFonts.ibmPlexSans(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
