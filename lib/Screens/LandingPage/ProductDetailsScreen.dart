import 'dart:convert';

import 'package:apparel_options/Constants/constantColors.dart';
import 'package:apparel_options/Constants/myColors.dart';
import 'package:apparel_options/Database/ProductDetailsDB.dart';
import 'package:apparel_options/Database/ProductSpecificationDB.dart';
import 'package:apparel_options/Database/ProductVariantDB.dart';
import 'package:apparel_options/Model/ProductSpecificationModel.dart';
import 'package:apparel_options/Model/ProductVariantModel.dart';
import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Components/ProgressDialog.dart';
import '../../Constants/Colors.dart';
import '../../Constants/Constants.dart';
import '../../Database/BranchDB.dart';
import '../../Database/DB_Helper.dart';
import '../../Database/LikesDB.dart';
import '../../Database/MenuDB.dart';
import '../../Database/RatingDB.dart';
import '../../Database/UserDB.dart';
import '../../Model/AppData.dart';
import '../../Model/BranchModel.dart';
import '../../Model/FullCartModel.dart';
import '../../Model/LikeModel.dart';
import '../../Model/MenuModel.dart';
import '../../Model/ProductDetailsModel.dart';
import '../../Model/ProductModel.dart';
import '../../Model/Questions.dart';
import '../../Model/RatingModel.dart';
import '../../Model/UserProfileModel.dart';
import '../../Utils/NetworkUtility.dart';
import '../../Utils/Utility.dart';
import '../../Utils/paths.dart';
import '../CartScreen.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';


class ProductDetailsScreen extends StatefulWidget {
  final MenuModel? menuItem;
  final ProductVariantModel? productVariantModelItem;
  final int? productID;

  ProductDetailsScreen({
    this.menuItem,
    this.productVariantModelItem,
    this.productID
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState(
        menuItem: menuItem!,

        productID: productID!
      );
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {

  Color? currentColor = Colors.amber;
  List<Color?> currentColors = [Colors.yellow, Colors.green];

  void changeColor(Color color) => setState(() => currentColor = color);

  final int productID;
  final MenuModel menuItem;
  ProductVariantModel? productVariantModelItem;
  ProductSpecificationModel? productSpecificationModelItem;
  ProductDetailsModel? productDetailsModelItem;
  ProductDetailsModel? productDetailsHeaderModel;
  ProductVariantModel? productVariantModelByID;
  late List<ProductVariantModel?> productVariantsByID;

  int? selectedImage = -1;
  int? selectedQuantity = -1;
  bool? isTapped = false;
  bool? isClicked = false;

  String? availableSizes;
  List<MenuModel?> selectedValue = [];

  List<dynamic>? productList = [];
  List<dynamic>? cartItems = [];
  List<ProductVariantModel?> productVariantsList = [];
  List<ProductVariantModel?> productVariantsListByID = [];
  List<ProductSpecificationModel> productSpecificationListByID = [];
  List<ProductSpecificationModel> productSpecificationList = [];
  List<ProductDetailsModel> productDetailsListByID = [];
  List<ProductDetailsModel> productDetailsHeaderByIDList = [];
  List<ProductDetailsModel> productDetailsValueByIDList = [];
  List<ProductDetailsModel> productDetailsList = [];

  // final List<MenuModel?> optionsList;


  List<int?> cartItemCount = [1, 1, 1, 1];
  double? totalPrice = 0;
  LikesDB? likeDB = LikesDB();
  LikeModel? likeModel = LikeModel();
  RatingDB? ratingDB = RatingDB();
  RatingModel? ratingModel = RatingModel();
  UserProfileModel? userProfileModel = UserProfileModel();
  ProductVariantModel? productVariantModel = ProductVariantModel();
  MenuModel? optionsModel = MenuModel(productVariants: []);
  MenuModel? menuModel = MenuModel(productVariants: []);
  DBHelper? dbHelper = DBHelper();
  bool? isGreaterThanZero = false;
  int? _itemCount = 1;
  int? cartCounter = 1;
  bool? _hasBeenLiked = false;
  String? branch;
  bool? showLoader = false;

  // final _items = AddOns.getAddOns();
  UserDB? userDB = UserDB();
  BranchDB? branchDB = BranchDB();
  MenuDB? menuDB = MenuDB();
  ProductVariantDB? productVariantDB = ProductVariantDB();
  ProductSpecificationDB? productSpecificationDB = ProductSpecificationDB();
  ProductDetailsDB? productDetailsDB = ProductDetailsDB();
  double? ratingNew;
  bool? isEmpty;
  List<MultiSelectCard>? sizesList = [];
  List<String?> headers = [];
  List<String?> prodDetailList = [];
  Map<String?, dynamic> headerDetailMap = {};
  String? header;


  final MultiSelectController<String> _controller = MultiSelectController();
  // int actualRating;

  // Obtain shared preferences.

  _ProductDetailsScreenState({
    required this.menuItem,
    required this.productID,
  });
  @override
  void initState() {

    super.initState();
    EasyLoading.show(status: 'loading...');
    initDB();
    EasyLoading.dismiss();


  }

  void initDB() async {
    await userDB!.initialize();
    await menuDB!.initialize();
    await likeDB!.initialize();
    await ratingDB!.initialize();
    await productVariantDB!.initialize();
    await productSpecificationDB!.initialize();
    await productDetailsDB!.initialize();


    await loadUserFromLocalStorage();
    await loadAllLikes();
    await loadProductVariantsFromDB();
    await loadProductVariantsByProductID();
    await loadProductSpecificationsByProductID();
    await loadProductSpecificationsFromDB();
    await loadProductDetailsByProductID();
    await loadProductDetailsHeadersByProductID();

    headers = await productDetailsDB!.getProductDetailHeaders(productID);
    print('List of headers: ${headers}');
    // if(headers.isNotEmpty){
    //   for(String header in headers){
    //     List<String> details = await productDetailsDB.getProductDetailsByHeader(productID, header);
    //     headerDetailMap.update(header, (value) => details);
    //   }
    // }
    //
    // print('List of map data: ${headerDetailMap}');

  }

  double? newPrice;

  Future<void> loadUserFromLocalStorage() async {
    List<UserProfileModel> users = await userDB!.getAllUsers();
    if (users.isNotEmpty) {
      setState(() {
        userProfileModel = users.first;
      });
    }
  }

  Future<void> loadProductVariantsFromDB() async {
    List<ProductVariantModel> productVariants = await productVariantDB!.getAllVariants();
    if (productVariants.isNotEmpty) {
      setState(() {
        productVariantsList = productVariants;

        for(ProductVariantModel? productVariantsList in productVariantsList){
          productVariantModelItem = productVariantsList;
        }
      });
    }
    print("Product Variant Item ID new: ${productVariantModelItem!.id}");
    print("Product Variants from the DB: ${productVariantsList.length}");
  }

  Future<void> loadProductVariantsByProductID() async {
    List<ProductVariantModel?> productVariantsByID = await productVariantDB!.getProductVariantById(productID.toString());
    print("Product Variant Item BY ID *******: $productVariantsByID");

    if (productVariantsByID.isNotEmpty) {
      setState(() {
        productVariantsListByID = productVariantsByID;
        for(ProductVariantModel? productVariantsListByID in productVariantsListByID){
          productVariantModelItem = productVariantsListByID;
        }
      });
    }
    print("Product Variant Item ID: ${productVariantModelItem}");
    print("Product Variants BY ID from the DB: ${productVariantsListByID.length}");
    print("ONE COLOR :${productVariantModelItem!.colorCode!.substring(1)}");

    // print("Product Variants from the DB By ID: ${productVariantsList.length}");
  }


  Future<void> loadProductSpecificationsFromDB() async {
    List<ProductSpecificationModel> productSpecifications = await productSpecificationDB!.getAllProductSpecification();
    if (productSpecifications.isNotEmpty) {
      setState(() {
        productSpecificationList = productSpecifications;

        for(ProductSpecificationModel productSpecificationList in productSpecificationList){
          productSpecificationModelItem = productSpecificationList;
        }
      });
    }
    print("Product Specification ALL Item: ${productSpecificationModelItem!.specification}");
    print("Product Specification ALL from the DB LENGTH: ${productSpecificationList.length}");
  }


  Future<void> loadProductSpecificationsByProductID() async {
    List<ProductSpecificationModel> productSpecificationsByID = await productSpecificationDB!.getProductSpecificationById(productID.toString());
    print("Product Specifications Item BY ID *******: $productSpecificationsByID");

      try{
        if (productSpecificationsByID.isNotEmpty) {
          setState(() {
            productSpecificationListByID = productSpecificationsByID;
            for(ProductSpecificationModel productSpecificationListByID in productSpecificationListByID){
              productSpecificationModelItem = productSpecificationListByID;
            }
          });
        }
      }catch(e){
        print("NO SPECS AVAILABLE");
      }


    print("Product Specification Item: ${productSpecificationModelItem!.specification}");
    print("Product Specification BY ID from the DB: ${productSpecificationListByID.length}");

  }

  Future<void> loadProductDetailsByProductID() async {
    List<ProductDetailsModel> productDetailsByID = await productDetailsDB!.getProductDetailsById(productID.toString());
    print("Product Details Item BY ID *******: $productDetailsByID");

    if (productDetailsByID.isNotEmpty) {
      setState(() {
        productDetailsListByID = productDetailsByID;
        for(ProductDetailsModel productDetailsListByID in productDetailsListByID){
          productDetailsModelItem = productDetailsListByID;
        }
      });
    }
    print("Product Details Item: ${productDetailsModelItem!.details}");
    print("Product Details BY ID from the DB: ${productDetailsListByID.length}");

  }

  Future<void> loadProductDetailsHeadersByProductID() async {
    List<ProductDetailsModel> productDetailsHeaderByID = await productDetailsDB!.getProductDetailsByHeader(productID, productDetailsModelItem!.header!);
    print("Product Details HEADER Item BY ID *******: $productDetailsHeaderByID");

    if (productDetailsHeaderByID.isNotEmpty) {
      setState(() {
        productDetailsHeaderByIDList = productDetailsHeaderByID;
        for(ProductDetailsModel productDetailsHeaderByIDList in productDetailsHeaderByIDList){
          productDetailsHeaderModel = productDetailsHeaderByIDList;
        }
      });
    }
    print("Product Details HEADER Item: ${productDetailsHeaderModel!.details}");
    print("Product Details HEADER BY ID and Header from the DB: ${productDetailsListByID.length}");

  }

  Future<void> loadAllLikes() async {
    print('menu on load up: $menuItem');
    List<LikeModel> list = await likeDB!.getAllLikes();
    print('likes on load up: ${list.length} | $list');
    if (list.isNotEmpty) {
      for (LikeModel model in list) {
        if (model.menuId == menuItem.id) {
          setState(() {
            likeModel = model;
            _hasBeenLiked = true;
          });
        }
      }
    }
    print('_hasBeenLiked after load up: $_hasBeenLiked | $likeModel');
  }

  Future<void> loadAllRatings() async {
    MenuModel newMenuModel = MenuModel(id: menuItem.id, productVariants: []);
    // List<MenuModel> list = await menuDB.getAllMenu();
    // print('MenuModel list: ${list.length} | ${newMenuModel.id} | $list');
    MenuModel menu = await menuDB!.getMenuById(newMenuModel);
    if (menu != null) {
      setState(() {
        menuModel = menu;
      });
    }
    print('Cumulative Rating after load up: ${menuModel!.cumulativeRating}');

    int actualRating = double.parse(menuModel!.cumulativeRating!) ~/
        double.parse(menuModel!.ratingFrequency!);
    print("The actual rating: ${actualRating}");
  }

  List<Questions> myquestions = [
    Questions(
      index: 1,
      question: "Small",
    ),
    Questions(
      index: 2,
      question: "Medium",
    ),
  ];


  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<AppData>(context);
    final pricing = Provider.of<AppData>(context);
    return Scaffold(
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: MaterialButton(
            onPressed: () async {
              List<MenuModel> allOptions = [];

              if(selectedImage !< 0
              ){
                UtilityService().showMessage(
                  message: 'Please choose available variant and a size',
                  context: context,
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.redAccent,
                  ),
                );
              }
              else{
                ProductModel newMainCartItem = ProductModel(
                    id: productVariantsListByID[selectedImage!]!.id,
                    colorCode: productVariantsListByID[selectedImage!]!.colorCode,
                    productName: menuItem.product,
                    productCategory: menuItem.category,
                    imageUrl: productVariantsListByID[selectedImage!]!.imageUrl,
                    price: double.parse(menuItem.price!),
                    total: (double.parse(menuItem.price!) * _itemCount!),
                    quantity: _itemCount!,
                    sizes: menuItem.size,
                    color: productVariantsListByID[selectedImage!]!.color,
                    productVariantId: productVariantsListByID[selectedImage!]!.id,
                    productId: menuItem.id
                );

                // print('selected options: ${allOptions.length} | $allOptions');
                print('Product Variant to Cart: ${ productVariantsList[selectedImage!]!.productId}');

                //Add item to provider object
                Provider.of<AppData>(context, listen: false).addCartItem(newMainCartItem);

                // Add items to shared pref as well
                final prefs = await SharedPreferences.getInstance();
                List<ProductModel> cartList = Provider.of<AppData>(context, listen: false).cartItemNew;
                prefs.setString(CART_ITEM_SHARED_PREF, jsonEncode(cartList));
                prefs.setInt(COUNT_CART_ITEM_SHARED_PREF, Provider.of<AppData>(context, listen: false).getCartCount());

                //Read shared pref value
                Object? storedValue = prefs.get(CART_ITEM_SHARED_PREF);
                print('Stored value: $storedValue');

                final snackBar = SnackBar(
                  content: const Text("Item added to cart"),
                  duration: Duration(seconds: 5),
                  action: SnackBarAction(
                    textColor: Colors.teal,
                    label: 'View',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartScreen(),
                        ),
                      );
                    },
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }

              // FullCartModel mainCartItem = FullCartModel(
              //   organization: 'Apparel',
              //   branch: branch,
              //   menuItem: menuItem.menuItem,
              //   description: menuItem.description,
              //   category: menuItem.category,
              //   type: menuItem.type,
              //   tagName: menuItem.tagName,
              //   imageUrl: menuItem.imageUrl,
              //   price: double.parse(menuItem.price).toString(),
              //   total: (double.parse(menuItem.price) * _itemCount),
              //   quantity: _itemCount,
              //   size: menuItem.size,
              //   product: menuItem.product,
              //   likes: menuItem.likes,
              //   brand: menuItem.brand,
              //   manufacturer: menuItem.manufacturer,
              //   color: productVariantsList[selectedImage].color,
              // );


            },
            height: 48,
            elevation: 0,
            splashColor: Colors.yellow[700],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.black,
            child: Center(
              child: Text(
                "Add to Cart",
                style: GoogleFonts.lato(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        )
      ],
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(53.0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.4,
          title: Center(
            child: Text(
              (menuItem != null && menuItem.tagName != null)
                  ? menuItem.category!
                  : "Details",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 19,
              color: Colors.black,
            ),
          ),
          actions: [
            Center(
              child: badges.Badge(
                badgeContent: Consumer<AppData>(builder: (context, value, child) {
                  return Text(
                    value.getCartCount().toString() != null ? value.getCartCount().toString() : "0",
                    style: TextStyle(color: Colors.white),
                  );
                }),
                badgeAnimation: badges.BadgeAnimation.slide(
                  toAnimate: true,
                  animationDuration: Duration(milliseconds: 300),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartScreen(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            SizedBox(
              width: 238,
              child: AspectRatio(
                aspectRatio: 1,
                child: Hero(
                  tag: widget.menuItem!.id.toString(),
                  child: selectedImage! < 0
                  ?Image.network(widget.menuItem!.imageUrl!):  Image.network(productVariantsListByID[selectedImage!]!.imageUrl!)
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              child: Text("Available Variants",
                  style: GoogleFonts.raleway(
                      fontSize: 13,
                      color: Colors.orange,
                      fontWeight: FontWeight.w600)),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(productVariantsListByID.length,
                        (index) => buildSmallProductPreview(index)),
              ],
            ),
            // Column(
            //   children: [
            //     CachedNetworkImage(
            //       imageUrl: menuItem.imageUrl.toString(),
            //       imageBuilder: (context, imageProvider) => Container(
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(0),
            //           border: Border.all(
            //             color: Colors
            //                 .black12, //                   <--- border color
            //             width: 1.0,
            //           ),
            //           image: DecorationImage(
            //             image: imageProvider,
            //             fit: BoxFit.cover,
            //           ),
            //         ),
            //       ),
            //       height: MediaQuery.of(context).size.height / 2.5,
            //       width: MediaQuery.of(context).size.width,
            //       fit: BoxFit.cover,
            //       color: Colors.black12,
            //       colorBlendMode: BlendMode.darken,
            //       placeholder: (context, url) => Container(
            //         height: 91,
            //         width: 91,
            //         child: Image.asset("assets/images/fork.png"),
            //       ),
            //       errorWidget: (context, url, error) => Image.asset(
            //         "assets/images/fork.png",
            //         height: 41,
            //         width: 41,
            //       ),
            //     ),
            //     // Padding(
            //     //   padding: const EdgeInsets.only(left: 0, right: 0),
            //     //   child: Container(
            //     //     height: MediaQuery.of(context).size.height / 3,
            //     //     width: MediaQuery.of(context).size.width,
            //     //     decoration: BoxDecoration(
            //     //         borderRadius: BorderRadius.circular(0),
            //     //         image: DecorationImage(
            //     //           fit: BoxFit.cover,
            //     //           image: NetworkImage(menuItem.imageUrl.toString()),
            //     //         )),
            //     //   ),
            //     // ),
            //   ],
            // ),
            Container(
                // height: MediaQuery.of(context).size.height * 0.65,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 0,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                        color: Colors.black54,
                        thickness: 0.2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                child: Text("Category: ",
                                    style: GoogleFonts.raleway(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600)),
                              ),
                              Container(
                                child: Text(
                                    (menuItem != null &&
                                            menuItem.category != null)
                                        ? menuItem.category!
                                        : '-',
                                    style: GoogleFonts.raleway(
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                child: Text("Likes:",
                                    style: GoogleFonts.raleway(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500)),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              (showLoader!)
                                  ? Container(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1.5,
                                        color: Colors.black,
                                      ),
                                    )
                                  : IconButton(
                                      onPressed: () async {
                                        // await addLikes(context, menuItem);
                                      },
                                      icon: Icon(
                                        Icons.favorite,
                                        size: 25,
                                        color: _hasBeenLiked!
                                            ? Colors.redAccent
                                            : Colors.grey,
                                      ),
                                    ),
                              // Container(
                              //   child: Text(
                              //     likeModel.likes.toString() != null
                              //         ? likeModel.likes.toString()
                              //         : "-",
                              //     style: GoogleFonts.raleway(
                              //         fontSize: 12,
                              //         color: Colors.black,
                              //         fontWeight: FontWeight.w300),
                              //   ),
                              // ),

                              // RatingBar.builder(
                              //   updateOnDrag: true,
                              //   itemSize: 20,
                              //   glow: true,
                              //   glowRadius: 20,
                              //   initialRating: 3.5,
                              //   minRating: 3,
                              //   maxRating: 5,
                              //   direction: Axis.horizontal,
                              //   allowHalfRating: true,
                              //   itemCount: 5,
                              //   itemPadding:
                              //       EdgeInsets.symmetric(horizontal: 1.0),
                              //   itemBuilder: (context, _) => Icon(
                              //     Icons.star,
                              //     color: Colors.amber,
                              //     size: 5,
                              //   ),
                              //   onRatingUpdate: (rating) {
                              //     print("The rating sent:${rating}");
                              //     setState(() {
                              //       ratingNew = rating;
                              //       MenuModel model = MenuModel(
                              //         id: menuItem.id,
                              //         cumulativeRating: ratingNew.toString(),
                              //       );
                              //       addRating(context, model);
                              //     });
                              //   },
                              // ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        child: Text("Description: ",
                            style: GoogleFonts.raleway(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w600)),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Container(
                        child: Text(
                            menuItem != null && menuItem.description != null
                                ? menuItem.description!
                                : '-',
                            style: GoogleFonts.raleway(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w400)),
                      ),
                      SizedBox(
                        height: 22,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text("Item Name: ",
                                    style: GoogleFonts.raleway(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600)),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Container(
                                child: Text(
                                    menuItem != null && menuItem.tagName != null
                                        ? menuItem.tagName!
                                        : '-',
                                    style: GoogleFonts.raleway(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                child: Text("Price(GHS): ",
                                    style: GoogleFonts.raleway(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600)),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Container(
                                child: Text(
                                    menuItem != null && menuItem.price != null
                                        ? double.parse(menuItem.price!)
                                            .toStringAsFixed(2)
                                        : '-',
                                    style: GoogleFonts.raleway(
                                        fontSize: 13,
                                        color: Colors.teal,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text("Available Sizes: ",
                                    style: GoogleFonts.raleway(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600)),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Container(
                                child: selectedImage !< 0
                                    ? Container(
                                        child: Text("Choose variants to see sizes",
                                    style: GoogleFonts.raleway(
                                        fontSize: 13,
                                        color: Colors.teal,
                                        fontWeight: FontWeight.w500)),)
                                    :Column(
                                      children: [
                                        Container(
                                          child: Text("Choose size from the options below ",
                                              style: GoogleFonts.raleway(
                                                  fontSize: 13,
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.w400)),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        MultiSelectContainer(
                                        maxSelectableCount: 1,
                                        itemsDecoration: MultiSelectDecorations(
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(colors: [
                                                Colors.green.withOpacity(0.1),
                                                Colors.yellow.withOpacity(0.1),
                                              ]),
                                              border: Border.all(color: Colors.green[200]!),
                                              borderRadius: BorderRadius.circular(20)),
                                          selectedDecoration: BoxDecoration(
                                              gradient: const LinearGradient(colors: [
                                                Colors.green,
                                                Colors.lightGreen
                                              ]),
                                              border: Border.all(color: Colors.green[700]!),
                                              borderRadius: BorderRadius.circular(5)),
                                          disabledDecoration: BoxDecoration(
                                              color: Colors.grey,
                                              border: Border.all(color: Colors.grey[500]!),
                                              borderRadius: BorderRadius.circular(10)),
                                        ),
                                        items: sizesList!,
                                        onChange: (allSelectedItems, selectedItem) {
                                          setState(() {
                                            menuItem.size = selectedItem.toString();
                                          });
                                        }),
                                      ],
                                    ),
                              ),

                              // MultiSelectCheckList(
                              //   maxSelectableCount: 2,
                              //   textStyles: const MultiSelectTextStyles(
                              //       selectedTextStyle: TextStyle(
                              //           color: Colors.black,
                              //           fontWeight: FontWeight.w400)),
                              //   itemsDecoration: MultiSelectDecorations(
                              //       decoration: BoxDecoration(
                              //         borderRadius:
                              //         BorderRadius.circular(10),
                              //       ),
                              //       selectedDecoration: BoxDecoration(
                              //           borderRadius:
                              //           BorderRadius.circular(4),
                              //           color:
                              //           Colors.orangeAccent.shade100)),
                              //   listViewSettings: ListViewSettings(
                              //     separatorBuilder: (context, index) =>
                              //     const Divider(
                              //       height: 0,
                              //     ),
                              //   ),
                              //   controller: _controller,
                              //   items:[
                              //     CheckListCard(
                              //         value:"kkk",
                              //         title: Text(
                              //           "hhhh",
                              //           style: GoogleFonts.raleway(
                              //               fontSize: 13,
                              //               fontWeight: FontWeight.w400,
                              //               color: Colors.black),
                              //         ),
                              //         selectedColor: Colors.white,
                              //         checkColor: Colors.black,
                              //         // selected: index == 3,
                              //         // enabled: !(index == 5),
                              //         checkBoxBorderSide:
                              //         BorderSide(color: primaryColor),
                              //         shape: RoundedRectangleBorder(
                              //             borderRadius:
                              //             BorderRadius.circular(5))),
                              //
                              //   ],
                              //   onChange: (allSelectedItems, selectedItem) {
                              //     print(
                              //         "The selected item: ${allSelectedItems}");
                              //     setState(() {
                              //       selectedOptions = allSelectedItems;
                              //     });
                              //   },
                              //   onMaximumSelected:
                              //       (allSelectedItems, selectedItem) {
                              //     // CustomSnackBar.showInSnackBar(
                              //     //     'The limit has been reached', context);
                              //   },
                              // ),

                            ],
                          ),

                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text("Brand: ",
                                    style: GoogleFonts.raleway(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600)),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Container(
                                child: Text(
                                    menuItem != null && menuItem.brand != null
                                        ? menuItem.brand!
                                        : '-'.toUpperCase(),
                                    style: GoogleFonts.raleway(
                                        fontSize: 13,
                                        color: primaryColor,
                                        fontWeight: FontWeight.w500)),
                              ),


                              // MultiSelectCheckList(
                              //   maxSelectableCount: 2,
                              //   textStyles: const MultiSelectTextStyles(
                              //       selectedTextStyle: TextStyle(
                              //           color: Colors.black,
                              //           fontWeight: FontWeight.w400)),
                              //   itemsDecoration: MultiSelectDecorations(
                              //       decoration: BoxDecoration(
                              //         borderRadius:
                              //         BorderRadius.circular(10),
                              //       ),
                              //       selectedDecoration: BoxDecoration(
                              //           borderRadius:
                              //           BorderRadius.circular(4),
                              //           color:
                              //           Colors.orangeAccent.shade100)),
                              //   listViewSettings: ListViewSettings(
                              //     separatorBuilder: (context, index) =>
                              //     const Divider(
                              //       height: 0,
                              //     ),
                              //   ),
                              //   controller: _controller,
                              //   items:[
                              //     CheckListCard(
                              //         value:"kkk",
                              //         title: Text(
                              //           "hhhh",
                              //           style: GoogleFonts.raleway(
                              //               fontSize: 13,
                              //               fontWeight: FontWeight.w400,
                              //               color: Colors.black),
                              //         ),
                              //         selectedColor: Colors.white,
                              //         checkColor: Colors.black,
                              //         // selected: index == 3,
                              //         // enabled: !(index == 5),
                              //         checkBoxBorderSide:
                              //         BorderSide(color: primaryColor),
                              //         shape: RoundedRectangleBorder(
                              //             borderRadius:
                              //             BorderRadius.circular(5))),
                              //
                              //   ],
                              //   onChange: (allSelectedItems, selectedItem) {
                              //     print(
                              //         "The selected item: ${allSelectedItems}");
                              //     setState(() {
                              //       selectedOptions = allSelectedItems;
                              //     });
                              //   },
                              //   onMaximumSelected:
                              //       (allSelectedItems, selectedItem) {
                              //     // CustomSnackBar.showInSnackBar(
                              //     //     'The limit has been reached', context);
                              //   },
                              // ),

                            ],
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 0, right: 0, top: 10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Quantity: ",
                                          style: GoogleFonts.raleway(
                                            height: 1.5,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                          ),
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
                                              _itemCount != 1
                                                  ? IconButton(
                                                  icon: new Icon(
                                                    Icons.remove,
                                                    size: 15,
                                                  ),
                                                  onPressed: () {
                                                    print("OnRemove");
                                                    int quantity = _itemCount!;
                                                    setState(() {
                                                      cart.setQuantity(
                                                          int.parse(_itemCount
                                                              .toString()));
                                                      setState(
                                                              () => _itemCount = _itemCount!-1);
                                                    });
                                                    double price = double.parse(
                                                        menuItem.price
                                                            .toString());
                                                    // cartCounter--;
                                                    double newPrice =
                                                        price * cartCounter!;

                                                    if (quantity > 1) {
                                                      dbHelper!.updateQuantity(
                                                        MenuModel(
                                                          type: menuItem.type
                                                              .toString(),
                                                          imageUrl: menuItem
                                                              .imageUrl
                                                              .toString(),
                                                          price: menuItem.price
                                                              .toString(),
                                                          size: menuItem.size
                                                              .toString(),
                                                          description: menuItem
                                                              .description
                                                              .toString(),
                                                          branch: menuItem
                                                              .branch
                                                              .toString(),
                                                          tagName: menuItem
                                                              .tagName
                                                              .toString(),
                                                          cumulativeRating:
                                                          menuItem
                                                              .cumulativeRating
                                                              .toString(),
                                                          category: menuItem
                                                              .category
                                                              .toString(),
                                                          ratingFrequency:
                                                          menuItem
                                                              .ratingFrequency
                                                              .toString(),
                                                          menuItem: menuItem
                                                              .menuItem
                                                              .toString(),
                                                          likes: menuItem.likes
                                                              .toString(), productVariants: [],
                                                        ),
                                                      )
                                                          .then((value) {
                                                        newPrice = 0;
                                                        quantity = 0;
                                                        cart.removeTotalPrice(
                                                            double.parse(menuItem
                                                                .price
                                                                .toString()));
                                                      }).onError((error,
                                                          stackTrace) {
                                                        print(error.toString());
                                                      });
                                                    }
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
                                                  _itemCount.toString(),
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
                                                    print("After tap");
                                                    setState(() {
                                                      cart.setQuantity(int.parse(
                                                          _itemCount.toString()));

                                                      int quantity = _itemCount!;
                                                      _itemCount = _itemCount !+ 1;
                                                    });
                                                    double price = double.parse(
                                                        menuItem.price.toString());
                                                    // quantity++;
                                                    double newPrice =
                                                        price * cartCounter!;

                                                    dbHelper
                                                        !.updateQuantity(
                                                      MenuModel(
                                                        type: menuItem.type
                                                            .toString(),
                                                        imageUrl: menuItem.imageUrl
                                                            .toString(),
                                                        price: menuItem.price
                                                            .toString(),
                                                        size: menuItem.size
                                                            .toString(),
                                                        description: menuItem
                                                            .description
                                                            .toString(),
                                                        branch: menuItem.branch
                                                            .toString(),
                                                        tagName: menuItem.tagName
                                                            .toString(),
                                                        cumulativeRating: menuItem
                                                            .cumulativeRating
                                                            .toString(),
                                                        category: menuItem.category
                                                            .toString(),
                                                        ratingFrequency: menuItem
                                                            .ratingFrequency
                                                            .toString(),
                                                        menuItem: menuItem.menuItem
                                                            .toString(),
                                                        likes: menuItem.likes
                                                            .toString(), productVariants: [],
                                                      ),
                                                    )
                                                        .then((value) {
                                                      newPrice = 0;
                                                      cartCounter = 0;
                                                      cart.addTotalPrice(
                                                          double.parse(menuItem
                                                              .price
                                                              .toString()));
                                                    }).onError((error, stackTrace) {
                                                      print(error.toString());
                                                    });
                                                  }),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                const SizedBox(
                                  height: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text("Available Quantity: ",
                                    style: GoogleFonts.raleway(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600)),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Column(
                                children: [
                                  Container(
                                    child:  selectedImage !< 0
                                        ?Container(
                                      child: Text("Choose variants to see quantity",
                                          style: GoogleFonts.raleway(
                                              fontSize: 13,
                                              color: Colors.teal,
                                              fontWeight: FontWeight.w500)),
                                    )
                                        :Container(child: Text((productVariantsListByID[selectedImage!]!.quantity.toString() != null && productVariantsListByID[selectedImage!]!.quantity.toString() != 0 ) ?
                                    (productVariantsListByID[selectedImage!]!.quantity.toString() ) : "Out of Stock",
                                          style: GoogleFonts.raleway(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ),

                                ],
                              ),




                              // MultiSelectCheckList(
                              //   maxSelectableCount: 2,
                              //   textStyles: const MultiSelectTextStyles(
                              //       selectedTextStyle: TextStyle(
                              //           color: Colors.black,
                              //           fontWeight: FontWeight.w400)),
                              //   itemsDecoration: MultiSelectDecorations(
                              //       decoration: BoxDecoration(
                              //         borderRadius:
                              //         BorderRadius.circular(10),
                              //       ),
                              //       selectedDecoration: BoxDecoration(
                              //           borderRadius:
                              //           BorderRadius.circular(4),
                              //           color:
                              //           Colors.orangeAccent.shade100)),
                              //   listViewSettings: ListViewSettings(
                              //     separatorBuilder: (context, index) =>
                              //     const Divider(
                              //       height: 0,
                              //     ),
                              //   ),
                              //   controller: _controller,
                              //   items:[
                              //     CheckListCard(
                              //         value:"kkk",
                              //         title: Text(
                              //           "hhhh",
                              //           style: GoogleFonts.raleway(
                              //               fontSize: 13,
                              //               fontWeight: FontWeight.w400,
                              //               color: Colors.black),
                              //         ),
                              //         selectedColor: Colors.white,
                              //         checkColor: Colors.black,
                              //         // selected: index == 3,
                              //         // enabled: !(index == 5),
                              //         checkBoxBorderSide:
                              //         BorderSide(color: primaryColor),
                              //         shape: RoundedRectangleBorder(
                              //             borderRadius:
                              //             BorderRadius.circular(5))),
                              //
                              //   ],
                              //   onChange: (allSelectedItems, selectedItem) {
                              //     print(
                              //         "The selected item: ${allSelectedItems}");
                              //     setState(() {
                              //       selectedOptions = allSelectedItems;
                              //     });
                              //   },
                              //   onMaximumSelected:
                              //       (allSelectedItems, selectedItem) {
                              //     // CustomSnackBar.showInSnackBar(
                              //     //     'The limit has been reached', context);
                              //   },
                              // ),

                            ],
                          ),

                        ],
                      ),

                      SizedBox(height: 10,),
                      Divider(
                        color: Colors.black,
                        thickness: 0.12,
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 0, right: 0, top: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Product Specifications",
                                      style: GoogleFonts.raleway(
                                        height: 1.5,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap:(){
                                        setState(() {
                                          isTapped = !isTapped!;
                                        });
                                        print("Is tapped");
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: 25,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: Colors.black,
                                          ),

                                          child: Center(
                                            child: Text(
                                              "View",
                                              style: GoogleFonts.raleway(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        )
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Container(
                              child: isTapped!
                                  ? Container(
                                    child: Card(
                                color: Colors.white,
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 14.0, left: 10, right: 10, bottom: 14),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Specification",
                                              style: GoogleFonts.raleway(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13,
                                                  color: Colors.teal),
                                            ),
                                            Container(
                                              child: Text("Specification Value",
                                                  style: GoogleFonts.raleway(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 13,
                                                      color: Colors.teal)),
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          color: Colors.black,
                                          thickness: 0.2,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                       Container(
                                         child: productSpecificationListByID.length != 0
                                         ?  Container(
                                           child: ListView.builder(
                                             shrinkWrap: true,
                                             scrollDirection: Axis.vertical,
                                             itemCount: productSpecificationListByID.length,
                                             itemBuilder: (context, index) {
                                               return Padding(
                                                 padding: const EdgeInsets.only(
                                                     left: 7, top: 7, right: 3),
                                                 child:
                                                 Row(
                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                   crossAxisAlignment: CrossAxisAlignment.start,
                                                   children: [
                                                     Text(productSpecificationListByID[index].specification ?? " ",
                                                       style: GoogleFonts.raleway(
                                                           fontWeight: FontWeight.w400,
                                                           fontSize: 13,
                                                           color: Colors.black),
                                                     ),
                                                     const SizedBox(
                                                       height: 3,
                                                     ),
                                                     Text(productSpecificationListByID[index].value ?? " ",
                                                       style: GoogleFonts.poppins(
                                                           fontWeight: FontWeight.w300,
                                                           fontSize: 12,
                                                           color: Colors.black),
                                                     ),
                                                   ],
                                                 ),
                                               );
                                             },
                                           ),
                                         )
                                             :Container(
                                           child: Center(
                                             child: Text("Product specifications not available!",
                                               style: GoogleFonts.raleway(
                                                   fontWeight: FontWeight.w400,
                                                   fontSize: 12,
                                                   color: Colors.redAccent.shade100),
                                             ),
                                           ),
                                         ),
                                       ),
                                        // Row(
                                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //   crossAxisAlignment: CrossAxisAlignment.start,
                                        //   children: [
                                        //     Text(productSpecificationModelItem.specification ?? " ",
                                        //       style: GoogleFonts.raleway(
                                        //           fontWeight: FontWeight.w400,
                                        //           fontSize: 13,
                                        //           color: Colors.black),
                                        //     ),
                                        //     const SizedBox(
                                        //       height: 3,
                                        //     ),
                                        //     Text(productSpecificationModelItem.value ?? " ",
                                        //       style: GoogleFonts.lato(
                                        //           fontWeight: FontWeight.w300,
                                        //           fontSize: 12,
                                        //           color: Colors.black),
                                        //     ),
                                        //   ],
                                        // ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Divider(
                                          color: Colors.black,
                                          thickness: 0.2,
                                        ),
                                      ],
                                    ),
                                ),
                              ),
                                  )
                                  : Container(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 1,),
                      Divider(
                        thickness: 0.15,
                        color: Colors.black45,
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 0, right: 0, top: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Product Details",
                                      style: GoogleFonts.raleway(
                                        height: 1.5,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:  [
                                    GestureDetector(
                                      onTap:() {
                                        setState(() {
                                          isClicked = !isClicked!;
                                        });
                                      },
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: 25,
                                            width: 60,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: Colors.black,
                                            ),

                                            child: Center(
                                              child: Text(
                                                "View",
                                                style: GoogleFonts.raleway(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          )
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                           Container(
                             child: isClicked!
                             ?  Container(
                               child: Card(
                                 color: Colors.white,
                                 child: Padding(
                                   padding: const EdgeInsets.only(
                                       top: 10.0, left: 10, right: 10, bottom: 5),
                                   child:  Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Row(
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [
                                           Expanded(
                                             child: Text(
                                               "Feature",
                                               style: GoogleFonts.raleway(
                                                   fontWeight: FontWeight.w600,
                                                   fontSize: 13,
                                                   color: Colors.teal),
                                             ),
                                           ),
                                           Expanded(
                                             child: Container(
                                               child: Text("Details",
                                                   style: GoogleFonts.raleway(
                                                       fontWeight: FontWeight.w600,
                                                       fontSize: 13,
                                                       color: Colors.teal)),
                                             ),
                                           ),
                                         ],
                                       ),
                                       Divider(
                                         color: Colors.black45,
                                         thickness: 0.15,
                                       ),
                                       //load details here
                                       Container(
                                         child: productDetailsListByID.length != 0
                                             ? Container(
                                           child: ListView.builder(
                                             shrinkWrap: true,
                                             scrollDirection: Axis.vertical,
                                             itemCount: productDetailsListByID.length,
                                             itemBuilder: (context, index) {

                                               return Padding(
                                                 padding: const EdgeInsets.only(
                                                     left: 7, top: 7, right: 3),
                                                 child:
                                                 Row(
                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                   crossAxisAlignment: CrossAxisAlignment.start,
                                                   children: [
                                                     Expanded(
                                                       child: Text(productDetailsListByID[index].header ?? " ",
                                                         style: GoogleFonts.raleway(
                                                             fontWeight: FontWeight.w400,
                                                             fontSize: 13,
                                                             color: primaryColor),
                                                       ),
                                                     ),
                                                     SizedBox(width: 10,),
                                                     Expanded(
                                                       child: Text(productDetailsListByID[index].details ?? " ",
                                                         style: GoogleFonts.raleway(
                                                             fontWeight: FontWeight.w300,
                                                             fontSize: 12,
                                                             color: Colors.black),
                                                       ),
                                                     ),
                                                   ],
                                                 ),
                                               );
                                             },
                                           ),
                                         )
                                             :Container(
                                           child: Center(
                                             child: Text("Product details not available!",
                                               style: GoogleFonts.raleway(
                                                   fontWeight: FontWeight.w400,
                                                   fontSize: 12,
                                                   color: Colors.redAccent.shade100),
                                             ),
                                           ),
                                         ),
                                       ),



                                       // Container(
                                       //   child: ListView.builder(
                                       //     scrollDirection: Axis.vertical,
                                       //     itemCount: headers.length,
                                       //     itemBuilder: (context, index) {
                                       //       return Padding(
                                       //         padding: const EdgeInsets.only(
                                       //             left: 0, top: 7, right: 3),
                                       //         child:
                                       //         Row(
                                       //           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       //           crossAxisAlignment: CrossAxisAlignment.start,
                                       //           children: [
                                       //             Text(productDetailsList[index] ?? " ",
                                       //               style: GoogleFonts.raleway(
                                       //                   fontWeight: FontWeight.w400,
                                       //                   fontSize: 13,
                                       //                   color: Colors.black),
                                       //             ),
                                       //           ],
                                       //         ),
                                       //       );
                                       //     },
                                       //   ),
                                       // ),
                                       Divider(
                                         color: Colors.black54,
                                         thickness: 0.1,
                                       ),

                                     ],
                                   ),
                                 ),
                               ),
                             )
                                 :Container(),
                           ),
                            SizedBox(height: 20,),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Future<bool> likeProduct(status) async {
    //your code
    try {
      NetworkUtility networkUtility = NetworkUtility();
      Response? response = await networkUtility.putDataWithAuth(
          url: '${LIKE_FOOD_ITEM}', auth: ACCESS_TOKEN_FOR_REQUEST);

      if (response!.statusCode == 200 && response != null) {
        print("Hey");
      }
    } catch (e) {
      print("There is an error");
    }

    return Future.value(!status);
  }

  void addLikes(BuildContext context, MenuModel model) async {
    try {
      setState(() {
        showLoader = true;
      });

      LikeModel likeMod = LikeModel(
        email: userProfileModel!.email,
        branch: "HQ",
        organization: 'Apparel',
        menuId: model.id,
        likes: (_hasBeenLiked!) ? 0 : 1,
      );

      print('likeMenuModel request: $likeMod');
      var jsonBody = jsonEncode(likeMod);
      NetworkUtility networkUtility = NetworkUtility();
      Response? response = await networkUtility.putDataWithAuth(
          url: '${ADD_LIKES}', auth: 'Bearer $ACCESS_TOKEN', body: jsonBody);

      print('addLikes response: ${response!.body}');
      if (response.statusCode == 200 && response != null) {
        //parse data received
        var data = jsonDecode(response.body);
        LikeModel likeData = LikeModel(
          menuId: model.id,
          likes: data['data']['likes'],
          branch: "HQ",
          organization: 'Apparel',
          email: userProfileModel!.email,
        );
        print('likeData to be saved: $likeData');
        if (likeData.likes == 0) {
          await likeDB!.deleteLikes(likeModel!.id!);
          // await likeDB.insertObject(likeData);
        } else {
          await likeDB!.insertObject(likeData);
        }
        List<LikeModel> lm = await likeDB!.getAllLikes();
        print('lm: ${lm.length} | $lm');
        if (_hasBeenLiked!) {
          setState(() {
            _hasBeenLiked = false;
          });
        } else {
          setState(() {
            _hasBeenLiked = true;
          });
        }
      }

      setState(() {
        showLoader = false;
      });
    } catch (e) {
      debugPrint('add likes error: $e');
      setState(() {
        showLoader = false;
      });
    }
  }

  void addRating(BuildContext context, MenuModel model) async {
    try {
      showDialog(
        context: context,
        builder: (context) {
          return ProgressDialog(displayMessage: 'Sending rating...');
        },
      );
      var jsonBody = jsonEncode(model);
      print("The json Body: $jsonBody");
      NetworkUtility networkUtility = NetworkUtility();
      Response? response = await networkUtility.putDataWithAuth(
          url: '${ADD_RATINGS}', auth: 'Bearer $ACCESS_TOKEN', body: jsonBody);

      debugPrint('Rating response: ${response!.body}');
      debugPrint('Rating statusCode: ${response.statusCode}');

      if (response.statusCode == 200 && response != null) {
        //parse data received
        var data = jsonDecode(response.body);

        print("The menu data: ${data}");
        print("ID for  body : ${model.id}");
        print("The printed menu item: ${data['data']['menuItem'].toString()}");
        // print("The email:")
        if (data.isNotEmpty) {
          //clear db
          // await ratingDB.deleteAll();
          RatingModel ratingModel = RatingModel(
            id: menuItem.id,
            cumulativeRating: ratingNew.toString(),
            email: userProfileModel!.email,
          );
          print("The email: ${userProfileModel!.email}");
          print("After insertion: ${ratingModel}");
          //update the local db
          await ratingDB!.insertObject(ratingModel);
        }

        Navigator.of(context).pop();
      } else {
        UtilityService().showMessage(
          message: 'Sorry, an error occurred while fetching data',
          context: context,
          icon: const Icon(
            Icons.cancel,
            color: Colors.redAccent,
          ),
        );
      }
      // Navigator.of(context).pop();
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => BillsScreen(
      //       billList: billList,
      //     ),
      //   ),
      // );
    } catch (e) {
      debugPrint('fetch category data error: $e');
      UtilityService().showMessage(
        message: 'Sorry, an error occurred while order list',
        context: context,
        icon: const Icon(
          Icons.cancel,
          color: Colors.redAccent,
        ),
      );
      // Navigator.of(context, rootNavigator: true).pop();
    }
  }

  GestureDetector buildSmallProductPreview(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = index;
          selectedQuantity = index;

          //process size dynamically
          String sizeString = productVariantsList[index]!.sizes!;
          if(sizeString!=null){

            List<String> list = sizeString.split(",");
            if(list.isNotEmpty){
              sizesList!.clear();
              for(String size in list){
                sizesList!.add(MultiSelectCard(value: size, label: size));
              }
            }
          }
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        margin: EdgeInsets.only(right: 15),
        padding: EdgeInsets.all(8),
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: Colors.orange.withOpacity(selectedImage == index ? 1 : 0)),
        ),
        child: Image.network(productVariantsListByID[index]!.imageUrl!),
      ),
    );
  }

  Future<List<Column>> loadProductDetails(BuildContext context) async {
    List<Column> list = [];
    try {
      if (headers.isNotEmpty) {
        // for (String header in headers) {
        //   List<String> productDetailsList = await getDetails(header);
        //   list.add(
        //     Column(
        //       children: [
        //         ProductDetailComponent(productDetailsList: productDetailsList, header: header),
        //       ],
        //     ),
        //   );
        // }
      }

      return list;
    } catch (e) {
      debugPrint('Error loadProductDetails List: $e');
      return null!;
    }
  }

  // Future<List<String>> getDetails(String header) async {
  //   List<String> list = await productDetailsDB.getProductDetailsByHeader(productID, header);
  //   return list;
  // }

}

class ProductDetailComponent extends StatelessWidget {
  const ProductDetailComponent({
    Key? key,
    required this.productDetailsList,
    required this.header,
  }) : super(key: key);

  final List<String> productDetailsList;
  final String header;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              header,
              style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Colors.teal),
            ),
            Container(
              child: Text("",
                  style: GoogleFonts.raleway(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Colors.black)),
            ),
          ],
        ),
        Container(
          height: 30,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: productDetailsList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                    left: 0, top: 7, right: 3),
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(productDetailsList[index] ?? " ",
                      style: GoogleFonts.raleway(
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                          color: Colors.black),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
