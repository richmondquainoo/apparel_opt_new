import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Components/CategoryCardComponent.dart';
import '../Constants/Colors.dart';
import '../Constants/constantColors.dart';
import '../Constants/myColors.dart';
import '../Database/MenuDB.dart';
import '../Model/MenuModel.dart';
import 'LandingPage/MenuInfoScreen.dart';

class CategoryScreen extends StatefulWidget {
  final bool? showBackButton;
  const CategoryScreen({Key? key, this.showBackButton}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState(
    showBackButton: showBackButton
  );
}

class _CategoryScreenState extends State<CategoryScreen>
    with TickerProviderStateMixin {
  final bool? showBackButton;
  TabController? _tabController;
  List<MenuModel> categoryList = [];
  MenuDB menuDB = MenuDB();

  _CategoryScreenState({this.showBackButton});

  @override
  void initState() {
    initDB();

    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController!.animateTo(2);
  }

  void initDB() async {
    try {
      //Step 0: initialize db
      await menuDB.initialize();
      //Step 2: Fetch categories
      await getInitialCategoriesData();
    } catch (e) {
      debugPrint('menu page init db error: $e');
    }
  }

  Future<void> getInitialCategoriesData() async {
    //fetch Category data from local storage
    List<MenuModel> list = await menuDB.getAllCategories();
    setState(() {
      categoryList = list;
      foundItem = categoryList;
    });
    print("Get all Categories: ${categoryList.length} | $categoryList");
  }

  // This list holds the data for the list view
  List<MenuModel> foundItem = [];

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<MenuModel> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      // results = categoryList;

    } else {
      results = categoryList
          .where((item) => item.category
          !.toLowerCase()
          .contains(enteredKeyword.toLowerCase()))
          .toList();
      setState(() {
        categoryList = results;
      });
    }

    // Refresh the UI

    print('categoryList after: $categoryList');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        backgroundColor: kBackgroundTheme,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade50,
          elevation: 0.2,
          automaticallyImplyLeading: false,
          leading: (showBackButton != null && showBackButton!)
              ? IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              size: 19,
              color: Colors.black54,
            ),
          )
              : Container(),
          title: Text(
            "MENU",
            style: GoogleFonts.raleway(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              letterSpacing: .75,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(
                height: 0,
              ),
              Padding(
                padding:
                const EdgeInsets.only(top: 1, left: 1, right: 1, bottom: 4),
                child: Container(
                  height: 40,
                  child: TextField(
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        _runFilter(value);
                      } else {
                        setState(() {
                          getInitialCategoriesData();
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
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(19)),
                        borderSide: BorderSide(color: primaryColor, width: 0.3),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 1,
              ),
              Expanded(
                child:
                // foundItem.isNotEmpty
                //     ? ListView.builder(
                //         itemCount: foundItem.length,
                //         itemBuilder: (context, index) => Padding(
                //           padding: const EdgeInsets.only(bottom: 2, top: 2),
                //           child: GestureDetector(
                //             onTap: () {
                //               Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                   builder: (context) => MenuInfoScreen(
                //                     category: foundItem[index].category,
                //                   ),
                //                 ),
                //               );
                //             },
                //             child: Container(
                //               height: 110,
                //               child: Card(
                //                 color: Colors.white,
                //                 child: Row(
                //                   mainAxisAlignment: MainAxisAlignment.start,
                //                   children: [
                //                     Padding(
                //                       padding: const EdgeInsets.only(left: 17.0),
                //                       child: CachedNetworkImage(
                //                         imageUrl:
                //                             foundItem[index].imageUrl.toString(),
                //                         imageBuilder: (context, imageProvider) =>
                //                             Container(
                //                           decoration: BoxDecoration(
                //                             borderRadius:
                //                                 BorderRadius.circular(48),
                //                             border: Border.all(
                //                               color: Colors
                //                                   .black12, //                   <--- border color
                //                               width: 1.0,
                //                             ),
                //                             image: DecorationImage(
                //                               image: imageProvider,
                //                               fit: BoxFit.cover,
                //                             ),
                //                           ),
                //                         ),
                //                         height: 80,
                //                         width: 80,
                //                         fit: BoxFit.cover,
                //                         color: Colors.black12,
                //                         colorBlendMode: BlendMode.darken,
                //                         placeholder: (context, url) => Container(
                //                           child: Image.asset(
                //                             "assets/images/fork.png",
                //                             cacheHeight: 30,
                //                           ),
                //                         ),
                //                         errorWidget: (context, url, error) =>
                //                             Container(
                //                           height: 30,
                //                           child: Image.asset(
                //                             "assets/images/fork.png",
                //                             cacheHeight: 37,
                //                           ),
                //                         ),
                //                       ),
                //                     ),
                //                     Expanded(
                //                       child: Row(
                //                         children: [
                //                           Padding(
                //                             padding:
                //                                 const EdgeInsets.only(left: 15.0),
                //                             child: Container(
                //                               child: Text(
                //                                 foundItem[index].category,
                //                                 style: GoogleFonts.raleway(
                //                                     fontSize: 15,
                //                                     fontWeight: FontWeight.w600,
                //                                     color: Colors.black54,
                //                                     letterSpacing: 1.3),
                //                               ),
                //                             ),
                //                           ),
                //                         ],
                //                       ),
                //                     ),
                //                     IconButton(
                //                         onPressed: () {},
                //                         icon: Icon(
                //                           Icons.arrow_forward_ios,
                //                           size: 15,
                //                         )),
                //                   ],
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ),
                //       )
                //     :
                SingleChildScrollView(
                    child: Column(children: loadCategoryList(context))),
              ),
            ],
          ),
        ),
      ),
    );
  }
  List<Column> loadCategoryList(BuildContext context) {
    List<Column> list = [];
    try {
      if (categoryList.isNotEmpty) {
        for (MenuModel category in categoryList) {
          list.add(
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 2, top: 2),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MenuInfoScreen(
                            category: category.category,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 110,
                      child: Card(
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 17.0),
                              child: CachedNetworkImage(
                                imageUrl: category.imageUrl.toString(),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(48),
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
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                                color: Colors.black12,
                                colorBlendMode: BlendMode.darken,
                                placeholder: (context, url) => Container(
                                  child: Image.asset(
                                    "assets/images/tshirt.png",
                                    cacheHeight: 30,
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  height: 30,
                                  child: Image.asset(
                                    "assets/images/tshirt.png",
                                    cacheHeight: 37,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Container(
                                      child: Text(
                                        category.category!,
                                        style: GoogleFonts.raleway(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: kPrimaryTextColor,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.stretch,
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: [
                //       Padding(
                //         padding: const EdgeInsets.only(left: 5.0, right: 5),
                //         child: GestureDetector(
                //           onTap: () async {
                //             Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                 builder: (context) => MenuInfoScreen(
                //                   category: category.category,
                //                 ),
                //               ),
                //             );
                //           },
                //           child: Container(
                //             height: 168,
                //             width: MediaQuery.of(context).size.width,
                //             decoration: BoxDecoration(
                //                 boxShadow: const [
                //                   BoxShadow(
                //                     offset: Offset(0.3, 0.3),
                //                     color: Colors.black54,
                //                   ),
                //                 ],
                //                 color: Colors.white,
                //                 borderRadius: BorderRadius.circular(14)),
                //             child: Column(
                //               children: [
                //                 Padding(
                //                   padding: const EdgeInsets.all(0.0),
                //                   child: Container(
                //                     height: 130,
                //                     width: MediaQuery.of(context).size.width,
                //                     decoration: BoxDecoration(
                //                       borderRadius: const BorderRadius.only(
                //                           topLeft: Radius.circular(14),
                //                           topRight: Radius.circular(14)),
                //                       image: DecorationImage(
                //                         colorFilter: ColorFilter.mode(
                //                             Colors.black.withOpacity(0.37),
                //                             BlendMode.darken),
                //                         image: NetworkImage(
                //                             category.imageUrl.toString()),
                //                         fit: BoxFit.fitWidth,
                //                       ),
                //                     ),
                //                   ),
                //                 ),
                //                 Padding(
                //                   padding: const EdgeInsets.only(
                //                       top: 8.0, bottom: 5),
                //                   child: Container(
                //                     child: Text(
                //                       category.category,
                //                       style: const TextStyle(
                //                           fontSize: 16,
                //                           fontWeight: FontWeight.w300,
                //                           color: Colors.teal,
                //                           letterSpacing: 1),
                //                     ),
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ),
                //       )
                //     ],
                //   ),
                // )
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
}
