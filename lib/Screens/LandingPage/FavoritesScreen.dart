import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constants/constantColors.dart';
import '../../Constants/myColors.dart';
import '../../Database/LikesDB.dart';
import '../../Database/MenuDB.dart';
import '../../Model/LikeModel.dart';
import '../../Model/MenuModel.dart';
import 'ProductDetailsScreen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  LikesDB likesDB = LikesDB();
  MenuDB menuDB = MenuDB();
  bool dataAvailable = false;
  List<MenuModel> menuList = [];
  List<MenuModel> originalMenuList = [];

  @override
  void initState() {
    super.initState();

    initDB();
  }

  void initDB() async {
    try {
      await menuDB.initialize();
      await likesDB.initialize();

      List<LikeModel> list = await likesDB.getAllLikes();
      if (list.isNotEmpty) {
        for (LikeModel li in list) {
          MenuModel menuModel = await menuDB.getMenuByIdOnly(li.menuId);
          if (menuModel != null) {
            setState(() {
              menuList.add(menuModel);
            });
          }
        }
      }
      print('menu list: ${menuList.length}');
      if (menuList.isNotEmpty) {
        setState(() {
          dataAvailable = true;
          originalMenuList = menuList;
        });
      }
    } catch (e) {
      print('Init error on favorite screen: $e');
    }
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<MenuModel> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      // results = categoryList;

    } else {
      results = menuList
          .where((item) => item.product
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      setState(() {
        menuList = results;
      });
    }

    // Refresh the UI
    print('menuList after search: $menuList');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            "My Favorites",
            style: GoogleFonts.raleway(
              fontSize: 17,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              letterSpacing: .75,
            ),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            (!dataAvailable)
                ? Center(
              child: Container(
                child: Text(
                  (!dataAvailable) ? "No favorite items found" : '',
                  style: GoogleFonts.raleway(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                ),
              ),
            )
                : Padding(
              padding: const EdgeInsets.only(
                  top: 1, left: 1, right: 1, bottom: 4),
              child: Container(
                height: 40,
                child: TextField(
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      _runFilter(value);
                    } else {
                      setState(() {
                        menuList = originalMenuList;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Search...",
                    hintStyle: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w300),
                    suffixIcon: const Icon(
                      Icons.search,
                      color: Colors.black87,
                      size: 21,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.all(15),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(19),
                        borderSide: const BorderSide(
                          width: 0.4,
                          color: Colors.black38,
                        )),
                    focusedBorder:  OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(19)),
                      borderSide:
                      BorderSide(color: Colors.orange, width: 0.3),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 1,
            ),
            Expanded(
              child: menuList.isNotEmpty
                  ? ListView.builder(
                itemCount: menuList.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () async {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen(
                          menuItem: menuList[index],
                          productID: menuList[index].id,
                        ),
                      ),
                    );
                    // fetchProductDetails(context, menuModel.category);
                    // fetchMenuData(context, category.category);
                    // debugPrint("pizzaType: ${menuModel.pizzaType}");
                  },
                  child: Card(
                    key: ValueKey(menuList[index].id),
                    elevation: 1,
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
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
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                            menuList[index].product,
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
                                        child: Text(menuList[index].price,
                                            style: GoogleFonts.lato(
                                                fontSize: 13,
                                                color: primaryColor,
                                                fontWeight:
                                                FontWeight.w400)),
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
                                                style:
                                                GoogleFonts.raleway(
                                                    fontSize: 13,
                                                    color:
                                                    Colors.black,
                                                    letterSpacing:
                                                    0.4,
                                                    fontWeight:
                                                    FontWeight
                                                        .w600)),
                                          ),
                                          Container(
                                            child: Text(
                                                menuList[index].type ??
                                                    "-",
                                                style: GoogleFonts.lato(
                                                    fontSize: 13,
                                                    color: Colors.black,
                                                    letterSpacing: 0.3,
                                                    fontWeight:
                                                    FontWeight.w400)),
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
                                        imageUrl: menuList[index]
                                            .imageUrl
                                            .toString(),
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
                                  //           menuList[index]
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
                ),
              )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No results found',
                        style: GoogleFonts.raleway(
                            fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        child: Image(
                          image: AssetImage("assets/images/search.png"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
