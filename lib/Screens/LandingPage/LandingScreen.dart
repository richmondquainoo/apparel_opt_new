// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../../Components/HorizontalTextComponent.dart';
// import '../../Constants/Colors.dart';
//
// class LandingScreen extends StatefulWidget {
//   const LandingScreen({Key key}) : super(key: key);
//
//   @override
//   State<LandingScreen> createState() => _LandingScreenState();
// }
//
// class _LandingScreenState extends State<LandingScreen>
//     with TickerProviderStateMixin {
//   bool _isScrolled = false;
//   ScrollController _scrollController;
//
//   List<dynamic> productList = [];
//   List<String> size = [
//     "S",
//     "M",
//     "L",
//     "XL",
//   ];
//
//   List<Color> colors = [
//     Colors.black,
//     Colors.purple,
//     Colors.orange.shade200,
//     Colors.blueGrey,
//     Color(0xFFFFC1D9),
//   ];
//
//   int _selectedColor = 0;
//   int _selectedSize = 1;
//
//   var selectedRange = const RangeValues(150.00, 1500.00);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: WHITE_COLOR,
//         elevation: 0,
//         leadingWidth: 110,
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 18.0),
//           child: Center(
//             child: Text(
//               "Discover",
//               style: GoogleFonts.raleway(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 color: Colors.black,
//                 letterSpacing: .75,
//               ),
//             ),
//           ),
//         ),
//         title: Text(
//           "",
//           style: GoogleFonts.raleway(
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//             color: APPBAR_GREEN,
//             letterSpacing: .75,
//           ),
//         ),
//         actions: const [
//           Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Icon(
//                 Icons.shopping_cart,
//                 color: Colors.black,
//                 size: 23,
//               )),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 8.0, right: 8, top: 12),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Categories",
//                       style: GoogleFonts.lato(
//                         color: Colors.black,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 15,
//                       ),
//                     ),
//                     Text(
//                       "VIEW ALL",
//                       style: GoogleFonts.lato(
//                           color: Colors.black,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 13,
//                           letterSpacing: 0.4),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 height: 8,
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 child: Container(
//                   height: 40,
//                   child: ListView(
//                     scrollDirection: Axis.horizontal,
//                     children: [
//                       HorizontalTextComponent(
//                         label: 'Products',
//                       ),
//                       const SizedBox(
//                         width: 10,
//                       ),
//                       HorizontalTextComponent(
//                         label: 'Brands',
//                       ),
//                       const SizedBox(
//                         width: 10,
//                       ),
//                       HorizontalTextComponent(
//                         label: 'Style',
//                       ),
//                       const SizedBox(
//                         width: 10,
//                       ),
//                       HorizontalTextComponent(
//                         label: 'Mens',
//                       ),
//                       const SizedBox(
//                         width: 10,
//                       ),
//                       HorizontalTextComponent(
//                         label: 'Ladies',
//                       ),
//                       const SizedBox(
//                         width: 10,
//                       ),
//                       HorizontalTextComponent(
//                         label: 'Kids',
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 12,
//               ),
//               const Divider(
//                 color: Colors.black54,
//                 thickness: 0.1,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
