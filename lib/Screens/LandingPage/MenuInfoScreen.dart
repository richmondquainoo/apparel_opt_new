import 'package:apparel_options/Screens/LandingPage/ProductDetailsScreen.dart';
// import 'package:badges/badges.dart' as bg;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../Constants/myColors.dart';
import '../../Database/DB_Helper.dart';
import '../../Database/MenuDB.dart';
import '../../Database/UserDB.dart';
import '../../Model/AppData.dart';
import '../../Model/CartModel.dart';
import '../../Model/CategoryModel.dart';
import '../../Model/MenuModel.dart';
import '../../Model/UserProfileModel.dart';
import '../CartScreen.dart';
import '../ProductDetails.dart';

class MenuInfoScreen extends StatefulWidget {
  final String? category;
  const MenuInfoScreen({
    Key? key,
    this.category,
  }) : super(key: key);

  @override
  State<MenuInfoScreen> createState() => _MenuInfoScreenState(
        category: category!,
      );
}

class _MenuInfoScreenState extends State<MenuInfoScreen> {
  final String? category;
  List<MenuModel> menuList = [];
  MenuDB menuDB = MenuDB();
  DBHelper dbHelper = DBHelper();
  UserDB userDB = UserDB();
  UserProfileModel user = UserProfileModel();
  int selectedIndex = -1;
  late List<CartModel?> cartList;
  late List<CategoryModel?> categoryList;

  bool checkBoxValue = false;
  _MenuInfoScreenState({this.category});

  @override
  void initState() {
    super.initState();
    initDB();
  }

  void initDB() async {
    await menuDB.initialize();
    await userDB.initialize();

    List<UserProfileModel> list = await userDB.getAllUsers();
    if (list.isNotEmpty) {
      setState(() {
        user = list.first;
      });
    }
    List<MenuModel> menuItems = await menuDB.getByCategory(category!);
    setState(() {
      menuList = menuItems;
    });
    List<MenuModel>? menus = await menuDB.getAllMenu();
    print("All menuList on load up: ${menus!.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundTheme,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey.shade50,
        elevation: 0.2,
        automaticallyImplyLeading: false,
        title: Text(
          "$category Menu",
          style: GoogleFonts.raleway(
            fontSize: 19,
            fontWeight: FontWeight.w300,
            color: Colors.black,
            letterSpacing: 0,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            size: 19,
            color: Colors.black54,
          ),
        ),
        actions: [
          // Center(
          //   child: bg.Badge(
          //     badgeContent: Consumer<AppData>(builder: (context, value, child) {
          //       return Text(
          //         value.getCartCount().toString(),
          //         style: TextStyle(color: Colors.white),
          //       );
          //     }),
          //     animationDuration: Duration(milliseconds: 300),
          //     child: IconButton(
          //       onPressed: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) => CartScreen(),
          //           ),
          //         );
          //       },
          //       icon: const Icon(
          //         Icons.shopping_cart,
          //         color: Colors.black,
          //       ),
          //     ),
          //   ),
          // ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          List<MenuModel> menuItems = await menuDB.getByCategory(category!);
          setState(() {
            menuList = menuItems;
          });
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(children: loadMenuItems(context)),
          ),
        ),
      ),
    );
  }

  List<Column> loadMenuItems(BuildContext context) {
    final cart = Provider.of<AppData>(context);
    List<Column> list = [];
    try {
      if (menuList.isNotEmpty) {
        for (MenuModel menuModel in menuList) {
          list.add(
            Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 2.0, right: 2, top: 5),
                    child: GestureDetector(
                      onTap: () async {
                        await goToProductDetails(menuModel, context);
                      },
                      child: Card(
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              color: Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 5, top: 15, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text(menuModel.product!,
                                                style: GoogleFonts.raleway(
                                                    fontSize: 13,
                                                    color: Colors.black,
                                                    letterSpacing: 0.4,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        thickness: 0.23,
                                        color: Colors.black,
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            child: Text('Price (GHS): ',
                                                style: GoogleFonts.raleway(
                                                    fontSize: 13,
                                                    color: primaryColor,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ),
                                          Container(
                                            child: Text(menuModel.price!,
                                                style: GoogleFonts.lato(
                                                    fontSize: 13,
                                                    color: primaryColor,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                child: Text('Product Type: ',
                                                    style: GoogleFonts.raleway(
                                                        fontSize: 13,
                                                        color: Colors.black,
                                                        letterSpacing: 0.4,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ),
                                              Container(
                                                child: Text(
                                                    menuModel.type?? "-",
                                                    style: GoogleFonts.lato(
                                                        fontSize: 13,
                                                        color: Colors.black,
                                                        letterSpacing: 0.3,
                                                        fontWeight:
                                                            FontWeight.w300)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      Container(
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 41,
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                menuModel.imageUrl.toString(),
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(18),
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
                                            height: 81,
                                            width: 81,
                                            fit: BoxFit.cover,
                                            color: Colors.black12,
                                            colorBlendMode: BlendMode.darken,
                                            placeholder: (context, url) =>
                                                Container(
                                              height: 71,
                                              width: 71,
                                              child: Image.asset(
                                                  "assets/images/fork.png"),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Image.asset(
                                              "assets/images/fork.png",
                                              height: 41,
                                              width: 41,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Container(
                                      //   child: CircleAvatar(
                                      //     radius: 41,
                                      //     backgroundColor: SECOND_COLOR,
                                      //     child: CircleAvatar(
                                      //       backgroundColor: Colors.red,
                                      //       backgroundImage: NetworkImage(
                                      //           foundItem[index]
                                      //               .imageUrl
                                      //               .toString()),
                                      //       radius: 40,
                                      //     ),
                                      //   ),
                                      // ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ))
              ],
            ),
          );
        }
      }

      return list;
    } catch (e) {
      debugPrint('Error pizza list: $e');
      return null!;
    }
  }

  Future<void> goToProductDetails( MenuModel menuModel,  BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(
          menuItem: menuModel,
          productID: menuModel.id,
        ),
      ),
    );
  }
}
