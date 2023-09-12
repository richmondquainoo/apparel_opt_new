// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:filter_list/filter_list.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
//
// import '../../Constants/Colors.dart';
// import '../../Constants/myColors.dart';
// import '../../Database/MenuDB.dart';
// import '../../Model/MenuModel.dart';
//
// import 'ProductDetailsScreen.dart';
//
// class SearchScreen extends StatefulWidget {
//   const SearchScreen({Key? key}) : super(key: key);
//
//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//   List<MenuModel?> menuList = [];
//   List<MenuModel?> searchList;
//   List<MenuModel?> foodList;
//   MenuDB? menuDB = MenuDB();
//   MenuModel? menuModel = MenuModel();
//   List<MenuModel?> selectedUserList;
//
//   _SearchScreenState({this.selectedUserList});
//
//   @override
//   void initState() {
//     initDB();
//     super.initState();
//     foundItem = menuList;
//   }
//
//   void initDB() async {
//     await menuDB!.initialize();
//     await loadMenuFromDB();
//   }
//
//   Future<void> loadMenuFromDB() async {
//     List<MenuModel> menu = await menuDB!.getAllMenu();
//     if (menu.isNotEmpty) {
//       setState(() {
//         menuList = menu;
//       });
//     }
//   }
//
//   // This list holds the data for the list view
//   List<MenuModel?> foundItem = [];
//
//   // This function is called whenever the text field changes
//   void _runFilter(String enteredKeyword) {
//     List<MenuModel?> results = [];
//     if (enteredKeyword.isEmpty) {
//       // if the search field is empty or only contains white-space, we'll display all users
//       results = menuList;
//     } else {
//       results = menuList
//           .where((user) => user!.menuItem
//           .toLowerCase()
//           .contains(enteredKeyword.toLowerCase()))
//           .toList();
//       // we use the toLowerCase() method to make it case-insensitive
//     }
//
//     // Refresh the UI
//     setState(() {
//       foundItem = results;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kBackgroundTheme,
//       appBar: AppBar(
//         backgroundColor: Colors.grey.shade50,
//         elevation: 0.2,
//         automaticallyImplyLeading: false,
//         title: Text(
//           "Search for item",
//           style: GoogleFonts.raleway(
//             fontSize: 15,
//             fontWeight: FontWeight.w300,
//             color: Colors.black,
//             letterSpacing: 0,
//           ),
//         ),
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(
//             Icons.arrow_back_ios,
//             color: Colors.black54,
//             size: 18,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           children: [
//             const SizedBox(
//               height: 0,
//             ),
//             Padding(
//               padding:
//               const EdgeInsets.only(top: 1, left: 1, right: 1, bottom: 4),
//               child: Container(
//                 height: 40,
//                 child: TextField(
//                   onChanged: (value) {
//                     _runFilter(value);
//                   },
//                   decoration: InputDecoration(
//                     hintText: "Search...",
//                     hintStyle: const TextStyle(
//                         color: Colors.black87,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w300),
//                     suffixIcon: const Icon(
//                       Icons.search,
//                       color: Colors.black87,
//                       size: 21,
//                     ),
//                     filled: true,
//                     fillColor: Colors.white,
//                     contentPadding: EdgeInsets.all(15),
//                     enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(19),
//                         borderSide: const BorderSide(
//                           width: 0.4,
//                           color: Colors.black38,
//                         )),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(19)),
//                       borderSide: BorderSide(color: Colors.black, width: 0.3),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 1,
//             ),
//             Expanded(
//               child: foundItem.isNotEmpty
//                   ? ListView.builder(
//                 itemCount: foundItem.length,
//                 itemBuilder: (context, index) => GestureDetector(
//                   onTap: () async {
//                     // getInitialMenuOnTap();
//                     print("Menu Item: ${menuModel!.tagName}");
//                     List<MenuModel> optList =
//                     await menuDB!.getApplicableCategoryList(
//                         'Options', foundItem[index]!.category);
//                     List<MenuModel> sauList =
//                     await menuDB!.getApplicableCategoryList(
//                         'Sauces', foundItem[index]!.category);
//                     List<MenuModel> sidList =
//                     await menuDB!.getApplicableCategoryList(
//                         'Sides', foundItem[index]!.category);
//                     List<MenuModel> proList =
//                     await menuDB!.getApplicableCategoryList(
//                         'Proteins', foundItem[index]!.category);
//                     List<MenuModel> driList =
//                     await menuDB!.getByCategory('Drinks');
//                     print('drinks: $driList');
//
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ProductDetailsScreen(
//                           menuItem: foundItem[index]!,
//                         ),
//                       ),
//                     );
//                     // fetchProductDetails(context, menuModel.category);
//                     // fetchMenuData(context, category.category);
//                     // debugPrint("pizzaType: ${menuModel.pizzaType}");
//                   },
//                   child: Card(
//                     key: ValueKey(foundItem[index].id),
//                     elevation: 1,
//                     margin: const EdgeInsets.symmetric(vertical: 3),
//                     child: Container(
//                       height: 120,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(12),
//                           color: Colors.white),
//                       child: Padding(
//                         padding: const EdgeInsets.only(
//                             left: 16.0, right: 5, top: 15, bottom: 10),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               flex: 7,
//                               child: Column(
//                                 crossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.center,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment:
//                                     MainAxisAlignment.start,
//                                     children: [
//                                       Container(
//                                         child: Text(
//                                             foundItem[index]!.product,
//                                             style: GoogleFonts.raleway(
//                                                 fontSize: 13,
//                                                 color: Colors.black,
//                                                 letterSpacing: 0.4,
//                                                 fontWeight:
//                                                 FontWeight.w400)),
//                                       ),
//                                     ],
//                                   ),
//                                   Divider(
//                                     thickness: 0.23,
//                                     color: Colors.black,
//                                   ),
//                                   const SizedBox(
//                                     height: 6,
//                                   ),
//                                   Row(
//                                     children: [
//                                       Container(
//                                         child: Text('Price (GHS): ',
//                                             style: GoogleFonts.raleway(
//                                                 fontSize: 13,
//                                                 color: Colors.black,
//                                                 fontWeight:
//                                                 FontWeight.w400)),
//                                       ),
//                                       Container(
//                                         child: Text(
//                                             foundItem[index]!.price,
//                                             style: GoogleFonts.lato(
//                                                 fontSize: 13,
//                                                 color: Colors.black,
//                                                 fontWeight:
//                                                 FontWeight.w400)),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(
//                                     height: 6,
//                                   ),
//                                   Row(
//                                     children: [
//                                       Row(
//                                         children: [
//                                           Container(
//                                             child: Text('Size: ',
//                                                 style:
//                                                 GoogleFonts.raleway(
//                                                     fontSize: 14,
//                                                     color:
//                                                     Colors.black,
//                                                     letterSpacing:
//                                                     0.4,
//                                                     fontWeight:
//                                                     FontWeight
//                                                         .w500)),
//                                           ),
//                                           Container(
//                                             child: Text(
//                                                 foundItem[index].size ??
//                                                     "-",
//                                                 style: GoogleFonts.lato(
//                                                     fontSize: 14,
//                                                     color: Colors.black,
//                                                     letterSpacing: 0.3,
//                                                     fontWeight:
//                                                     FontWeight.w400)),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Expanded(
//                               flex: 2,
//                               child: Column(
//                                 children: [
//                                   Container(
//                                     child: CircleAvatar(
//                                       backgroundColor: Colors.white,
//                                       radius: 41,
//                                       child: CachedNetworkImage(
//                                         imageUrl: foundItem[index]
//                                             !.imageUrl
//                                             .toString(),
//                                         imageBuilder:
//                                             (context, imageProvider) =>
//                                             Container(
//                                               decoration: BoxDecoration(
//                                                 borderRadius:
//                                                 BorderRadius.circular(18),
//                                                 border: Border.all(
//                                                   color: Colors
//                                                       .black12, //                   <--- border color
//                                                   width: 1.0,
//                                                 ),
//                                                 image: DecorationImage(
//                                                   image: imageProvider,
//                                                   fit: BoxFit.cover,
//                                                 ),
//                                               ),
//                                             ),
//                                         height: 81,
//                                         width: 81,
//                                         fit: BoxFit.cover,
//                                         color: Colors.black12,
//                                         colorBlendMode: BlendMode.darken,
//                                         placeholder: (context, url) =>
//                                             Container(
//                                               height: 71,
//                                               width: 71,
//                                               child: Image.asset(
//                                                   "assets/images/fork.png"),
//                                             ),
//                                         errorWidget:
//                                             (context, url, error) =>
//                                             Image.asset(
//                                               "assets/images/fork.png",
//                                               height: 41,
//                                               width: 41,
//                                             ),
//                                       ),
//                                     ),
//                                   ),
//                                   // Container(
//                                   //   child: CircleAvatar(
//                                   //     radius: 41,
//                                   //     backgroundColor: SECOND_COLOR,
//                                   //     child: CircleAvatar(
//                                   //       backgroundColor: Colors.red,
//                                   //       backgroundImage: NetworkImage(
//                                   //           foundItem[index]
//                                   //               .imageUrl
//                                   //               .toString()),
//                                   //       radius: 40,
//                                   //     ),
//                                   //   ),
//                                   // ),
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//                   : Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         'No results found',
//                         style: GoogleFonts.raleway(
//                             fontSize: 14, fontWeight: FontWeight.w300),
//                       ),
//                       Container(
//                         height: 50,
//                         width: 50,
//                         child: Image(
//                           image: AssetImage("assets/images/search.png"),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void openFilterDialog() async {
//     await FilterListDialog.display<MenuModel>(
//       context,
//       listData: menuList,
//       selectedListData: selectedUserList,
//       choiceChipLabel: (menuModel) => menuModel!.menuItem,
//       validateSelectedItem: (itemList, val) => itemList!.contains(val),
//       onItemSearch: (user, query) {
//         return menuModel!.menuItem.toLowerCase().contains(query.toLowerCase());
//       },
//       onApplyButtonClick: (list) {
//         setState(() {
//           selectedUserList = list!;
//         });
//         Navigator.pop(context);
//       },
//     );
//   }
// }
