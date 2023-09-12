// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
// import 'package:geocoding/geocoding.dart';
// // import 'package:flutter_google_places/flutter_google_places.dart';
//
// import 'package:geolocator/geolocator.dart' as geolocator;
// import 'package:geolocator/geolocator.dart';
// import 'package:google_api_headers/google_api_headers.dart';
// // import 'package:google_api_headers/google_api_headers.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice/places.dart';
// // import 'package:map_pin_picker/map_pin_picker.dart';
// // import 'package:google_place/google_place.dart';
// import 'package:provider/provider.dart';
//
// import '../../Components/WidgetFunctions.dart';
// import '../../Constants/Colors.dart';
// import '../../Constants/myColors.dart';
// import '../../Model/AppData.dart';
//
// class SearchPlacesScreen extends StatefulWidget {
//   final String? title;
//   final geolocator.Position? positionLocation;
//   const SearchPlacesScreen({Key? key, this.title, this.positionLocation})
//       : super(key: key);
//
//   @override
//   State<SearchPlacesScreen> createState() => _SearchPlacesScreenState(
//       positionLocation: positionLocation!, title: title!);
// }
//
// const kGoogleApiKey = 'AIzaSyCKM_cLs6dNLYnGn2aS5B599LGepkQlapM';
// final homeScaffoldKey = GlobalKey<ScaffoldState>();
// // GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
//
// class _SearchPlacesScreenState extends State<SearchPlacesScreen> {
//   final geolocator.Position? positionLocation;
//   final String? title;
//   bool? serviceEnabled;
//   List addressList = [];
//
//   CameraPosition cameraPosition = const CameraPosition(
//     target: LatLng(5.511158, -0.18279737),
//     zoom: 14.4746,
//   );
//   var textController = TextEditingController();
//
//   static const CameraPosition initialCameraPosition =
//       CameraPosition(target: LatLng(37.42796, -122.08574), zoom: 14.0);
//
//   @override
//   initState() {
//     print("LOC from prev: ${positionLocation}");
//     _getCurrentLocation();
//     super.initState();
//   }
//
//   void _setMarker(LatLng point) {
//     setState(() {
//       markersList.clear();
//       markersList.add(Marker(
//         markerId: MarkerId('maker'),
//         position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//       ));
//     });
//   }
//
//   _getAddress() async {
//     try {
//       List<Placemark> p = await placemarkFromCoordinates(
//           _currentPosition!.latitude, _currentPosition!.longitude);
//
//       Placemark place = p[0];
//
//       setState(() {
//         _currentAddress = "${place.name}, ${place.locality}";
//         _originController.text = _currentAddress;
//         _startAddress = _currentAddress;
//       });
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   _getCurrentLocation() async {
//     print('Fetching location...');
//     await geolocator.Geolocator
//         .getCurrentPosition(desiredAccuracy: geolocator.LocationAccuracy.high)
//         .then((geolocator.Position position) async {
//       setState(() {
//         _currentPosition = position;
//         Provider.of<AppData>(context, listen: false)
//             .updateActualCoordinates(_currentPosition!);
//         print('CURRENT POS: $_currentPosition');
//         // _setMarker(LatLng(currentPosition.latitude, currentPosition.longitude));
//       });
//       await _getAddress();
//     }).catchError((e) {
//       print(e);
//     });
//   }
//
//   // _getCurrentLocation() async {
//   //   await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
//   //       .then((Position position) async {
//   //     await Geolocator.checkPermission();
//   //     await Geolocator.requestPermission();
//   //
//   //     final GoogleMapController mapController = await _controller.future;
//   //     setState(() {
//   //       _currentPosition = position;
//   //       print('CURRENT POS: ${_currentPosition}');
//   //       _setMarker(
//   //           LatLng(_currentPosition.latitude, _currentPosition.longitude));
//   //     });
//   //     await _getAddress();
//   //   }).catchError((e) {
//   //     print(e);
//   //   });
//   // }
//
//   Set<Marker> markersList = Set<Marker>();
//   // Set<Marker> _markers = {};
//   bool bToggle = true;
//   GoogleMapController? googleMapController;
//   geolocator.Position? _currentPosition;
//   geolocator.Position? searchedLocation;
//   final Mode _mode = Mode.overlay;
//   String _currentAddress = '';
//   String _startAddress = '';
//   String actualLocation = '';
//   bool isAvailable = true;
//
//   TextEditingController _originController = TextEditingController();
//   Completer<GoogleMapController> _controller = Completer();
//   // MapPickerController mapPickerController = MapPickerController();
//
//   _SearchPlacesScreenState({this.positionLocation, this.title});
//
//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     final locationSearch = Provider.of<AppData>(context);
//     return Container(
//         height: height,
//         width: width,
//         child: Scaffold(
//           key: homeScaffoldKey,
//           extendBodyBehindAppBar: true,
//           // body: Consumer<AppData>(builder: (context, locationProvider, child) {
//           //   return Stack(
//           //     children: [
//           //       MapPicker(
//           //         iconWidget: Image.asset(
//           //           "assets/images/loc_marker.png",
//           //           height: 46,
//           //         ),
//           //         //add map picker controller
//           //         mapPickerController: mapPickerController,
//           //         child: GoogleMap(
//           //           initialCameraPosition: CameraPosition(
//           //               target: LatLng(positionLocation.latitude,
//           //                   positionLocation.longitude),
//           //               zoom: 16.2),
//           //           // markers: markersList,
//           //           mapType: MapType.normal,
//           //
//           //           onCameraMoveStarted: () {
//           //             // notify map is moving
//           //             mapPickerController.mapMoving();
//           //             textController.text = "checking ...";
//           //           },
//           //           onCameraMove: (cameraPosition) {
//           //             this.cameraPosition = CameraPosition(
//           //                 target: LatLng(positionLocation.latitude,
//           //                     positionLocation.longitude),
//           //                 zoom: 16.2);
//           //           },
//           //           onCameraIdle: () async {
//           //             // notify map stopped moving
//           //             mapPickerController.mapFinishedMoving();
//           //             //get address name from camera position
//           //             List<Placemark> placemarks = await placemarkFromCoordinates(
//           //               positionLocation.latitude,
//           //               positionLocation.longitude,
//           //             );
//           //
//           //             print("Place:$placemarks");
//           //
//           //             // update the ui with the address
//           //             textController.text =
//           //                 '${placemarks.first.name}, ${placemarks.first.administrativeArea}, ${placemarks.first.country}';
//           //           },
//           //
//           //           onMapCreated: (GoogleMapController controller) {
//           //             googleMapController = controller;
//           //           },
//           //         ),
//           //       ),
//           //       Padding(
//           //         padding: const EdgeInsets.only(
//           //             top: 70, left: 13, right: 13, bottom: 4),
//           //         child: GestureDetector(
//           //           onTap: _handlePressButton,
//           //           child: Container(
//           //             height: 40,
//           //             child: TextField(
//           //               onTap: _handlePressButton,
//           //               decoration: InputDecoration(
//           //                 hintText: "Find Location...",
//           //                 hintStyle: const TextStyle(
//           //                     color: Colors.black87,
//           //                     fontSize: 14,
//           //                     fontWeight: FontWeight.w300),
//           //                 suffixIcon: const Icon(
//           //                   Icons.search,
//           //                   color: Colors.black87,
//           //                   size: 21,
//           //                 ),
//           //                 filled: true,
//           //                 fillColor: Colors.white,
//           //                 contentPadding: EdgeInsets.all(15),
//           //                 enabledBorder: OutlineInputBorder(
//           //                     borderRadius: BorderRadius.circular(19),
//           //                     borderSide: const BorderSide(
//           //                       width: 0.4,
//           //                       color: Colors.black38,
//           //                     )),
//           //                 focusedBorder: OutlineInputBorder(
//           //                   borderRadius: BorderRadius.all(Radius.circular(19)),
//           //                   borderSide:
//           //                       BorderSide(color: primaryColor, width: 0.3),
//           //                 ),
//           //               ),
//           //             ),
//           //           ),
//           //         ),
//           //       ),
//           //       Padding(
//           //         padding: const EdgeInsets.only(top: 33.0),
//           //         child: IconButton(
//           //             onPressed: () {
//           //               Navigator.pop(context);
//           //             },
//           //             icon: Icon(
//           //               Icons.arrow_back_ios,
//           //               size: 20,
//           //               color: Colors.black,
//           //             )),
//           //       ),
//           //       Positioned(
//           //         bottom: 16,
//           //         right: 0,
//           //         left: 0,
//           //         child: Column(
//           //           crossAxisAlignment: CrossAxisAlignment.end,
//           //           children: [
//           //             InkWell(
//           //               onTap: () {
//           //                 locationProvider.getCurrentLocation(
//           //                     mapController: googleMapController);
//           //               },
//           //               child: Container(
//           //                 width: 35,
//           //                 height: 35,
//           //                 margin: const EdgeInsets.only(right: 20),
//           //                 decoration: BoxDecoration(
//           //                   borderRadius: BorderRadius.circular(8),
//           //                   color: Colors.white,
//           //                 ),
//           //                 child: const Icon(
//           //                   Icons.my_location,
//           //                   size: 30,
//           //                 ),
//           //               ),
//           //             ),
//           //           ],
//           //         ),
//           //       ),
//           //       // Positioned(
//           //       //   top: MediaQuery.of(context).viewPadding.top + 20,
//           //       //   width: MediaQuery.of(context).size.width - 50,
//           //       //   height: 50,
//           //       //   child: TextFormField(
//           //       //     maxLines: 3,
//           //       //     textAlign: TextAlign.center,
//           //       //     readOnly: true,
//           //       //     decoration: const InputDecoration(
//           //       //         contentPadding: EdgeInsets.zero,
//           //       //         border: InputBorder.none),
//           //       //     controller: textController,
//           //       //   ),
//           //       // ),
//           //
//           //       //location marker surrounded with the loader
//           //       Container(
//           //           width: MediaQuery.of(context).size.width,
//           //           alignment: Alignment.center,
//           //           height: MediaQuery.of(context).size.height,
//           //           child: Image.asset(
//           //             'assets/images/loc_marker.png',
//           //             width: 0,
//           //             height: 0,
//           //             color: Colors.redAccent,
//           //           )),
//           //       locationProvider.loading
//           //           ? const Center(
//           //               child: CircularProgressIndicator(
//           //                 color: Colors.black54,
//           //                 strokeWidth: 1,
//           //               ),
//           //             )
//           //           : Container(),
//           //       // Padding(
//           //       //   padding: const EdgeInsets.only(top: 130.0),
//           //       //   child: Container(
//           //       //     child: TextFormField(
//           //       //       maxLines: 3,
//           //       //       textAlign: TextAlign.center,
//           //       //       readOnly: true,
//           //       //       decoration: const InputDecoration(
//           //       //           contentPadding: EdgeInsets.zero,
//           //       //           border: InputBorder.none),
//           //       //       controller: textController,
//           //       //     ),
//           //       //   ),
//           //       // ),
//           //       DraggableScrollableSheet(
//           //           maxChildSize: 0.76,
//           //           initialChildSize: 0.20,
//           //           minChildSize: 0.05,
//           //           builder: (context, scrollController) =>
//           //               StatefulBuilder(builder: (context, setState) {
//           //                 return SingleChildScrollView(
//           //                   child: Column(
//           //                     children: [
//           //                       Container(
//           //                         // height: 300,
//           //                         decoration: BoxDecoration(
//           //                           borderRadius: BorderRadius.only(
//           //                             topRight: Radius.circular(20),
//           //                             topLeft: Radius.circular(20),
//           //                           ),
//           //                           color: Colors.white,
//           //                         ),
//           //                         child: Padding(
//           //                           padding: const EdgeInsets.all(15.0),
//           //                           child: Column(
//           //                             crossAxisAlignment:
//           //                                 CrossAxisAlignment.start,
//           //                             children: [
//           //                               Column(
//           //                                 mainAxisSize: MainAxisSize.min,
//           //                                 children: <Widget>[
//           //                                   Text(
//           //                                     'Choose Destination',
//           //                                     style: GoogleFonts.raleway(
//           //                                       fontSize: 14,
//           //                                       color: SECOND_COLOR,
//           //                                       fontWeight: FontWeight.w400,
//           //                                     ),
//           //                                   ),
//           //                                   addVertical(10),
//           //
//           //                                   // _textField(
//           //                                   //     controller: _originController,
//           //                                   //     focusNode: startFocusNode,
//           //                                   //     hint: "Enter location",
//           //                                   //     prefixIcon: Icon(Icons.looks_one),
//           //                                   //     suffixIcon: _originController
//           //                                   //         .text.isNotEmpty
//           //                                   //         ? IconButton(
//           //                                   //       onPressed: () {
//           //                                   //         setState(() {
//           //                                   //           predictions = [];
//           //                                   //           _originController.clear();
//           //                                   //         });
//           //                                   //       },
//           //                                   //       icon:
//           //                                   //       Icon(Icons.clear_outlined),
//           //                                   //     )
//           //                                   //         : null,
//           //                                   //     width: width,
//           //                                   //     locationCallback: (String value) {
//           //                                   //       setState(() {
//           //                                   //         _startAddress = value;
//           //                                   //       });
//           //                                   //     }),
//           //                                   Padding(
//           //                                     padding: const EdgeInsets.only(
//           //                                         left: 20.0,
//           //                                         right: 20,
//           //                                         bottom: 10),
//           //                                     child: MaterialButton(
//           //                                       onPressed: () {
//           //                                         onPressed:
//           //                                         () {
//           //                                           print(
//           //                                               "Location ${_currentPosition.latitude} ${_currentPosition.longitude}");
//           //                                           print(
//           //                                               "Address: ${textController.text}");
//           //                                         };
//           //                                         // Navigator.push(
//           //                                         //     context,
//           //                                         //     MaterialPageRoute(
//           //                                         //         builder: (context) =>
//           //                                         //             NextCheckOutScreen()));
//           //                                       },
//           //                                       height: 40,
//           //                                       elevation: 0,
//           //                                       splashColor: Colors.teal[700],
//           //                                       shape: RoundedRectangleBorder(
//           //                                           borderRadius:
//           //                                               BorderRadius.circular(
//           //                                                   10)),
//           //                                       color: Colors.teal,
//           //                                       child: Center(
//           //                                         child: Text(
//           //                                           "Confirm Location",
//           //                                           style: GoogleFonts.raleway(
//           //                                               color: Colors.white,
//           //                                               fontSize: 15,
//           //                                               fontWeight:
//           //                                                   FontWeight.w500),
//           //                                         ),
//           //                                       ),
//           //                                     ),
//           //                                   ),
//           //                                   SizedBox(height: 10),
//           //                                 ],
//           //                               ),
//           //                             ],
//           //                           ),
//           //                         ),
//           //                       ),
//           //                     ],
//           //                   ),
//           //                 );
//           //               })),
//           //     ],
//           //   );
//           // }),
//           body: Consumer<AppData>(builder: (context, locationProvider, child) {
//             return Stack(
//               alignment: Alignment.topCenter,
//               children: [
//                 // MapPicker(
//                 //   // pass icon widget
//                 //   iconWidget: Image.asset(
//                 //     "assets/images/loc_marker.png",
//                 //     height: 45,
//                 //   ),
//                 //   //add map picker controller
//                 //   mapPickerController: mapPickerController,
//                 //   child: GoogleMap(
//                 //     initialCameraPosition: CameraPosition(
//                 //         target: LatLng(positionLocation.latitude,
//                 //             positionLocation.longitude),
//                 //         zoom: 16.9),
//                 //     // markers: markersList,
//                 //     mapType: MapType.normal,
//                 //
//                 //     onCameraMoveStarted: () {
//                 //       // notify map is moving
//                 //       mapPickerController.mapMoving();
//                 //       textController.text = "Loading...";
//                 //     },
//                 //     onCameraMove: (cameraPosition) {
//                 //       this.cameraPosition = CameraPosition(
//                 //           target: LatLng(positionLocation.latitude,
//                 //               positionLocation.longitude),
//                 //           zoom: 16.8);
//                 //       this.cameraPosition = cameraPosition;
//                 //     },
//                 //     // onCameraIdle: () async {
//                 //     //   // notify map stopped moving
//                 //     //   mapPickerController.mapFinishedMoving();
//                 //     //   //get address name from camera position
//                 //     //   List<Placemark> placemarks = await placemarkFromCoordinates(
//                 //     //     positionLocation.latitude,
//                 //     //     positionLocation.longitude,
//                 //     //   );
//                 //     //
//                 //     //   print("Place:$placemarks");
//                 //     //
//                 //     //   // update the ui with the address
//                 //     //   textController.text =
//                 //     //       '${placemarks.first.name}, ${placemarks.first.administrativeArea}, ${placemarks.first.country}';
//                 //     // },
//                 //
//                 //     onCameraIdle: () async {
//                 //       // notify map stopped moving
//                 //       mapPickerController.mapFinishedMoving();
//                 //       //get address name from camera position
//                 //       List<Placemark> placemarks =
//                 //           await placemarkFromCoordinates(
//                 //         cameraPosition.target.latitude ??
//                 //             positionLocation.latitude,
//                 //         cameraPosition.target.longitude ??
//                 //             positionLocation.longitude,
//                 //       );
//                 //
//                 //       // update the ui with the address
//                 //       textController.text =
//                 //           '${placemarks.first.street}, ${placemarks.first.administrativeArea}';
//                 //     },
//                 //
//                 //     onMapCreated: (GoogleMapController controller) {
//                 //       googleMapController = controller;
//                 //     },
//                 //   ),
//                 // ),
//                 Padding(
//                   padding: const EdgeInsets.only(
//                       top: 70, left: 13, right: 13, bottom: 4),
//                   child: GestureDetector(
//                     // onTap: _handlePressButton,
//                     child: Container(
//                       height: 40,
//                       child: TextField(
//                         // onTap: _handlePressButton,
//                         decoration: InputDecoration(
//                           hintText: "Find Location...",
//                           hintStyle: const TextStyle(
//                               color: Colors.black87,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w300),
//                           suffixIcon: const Icon(
//                             Icons.search,
//                             color: Colors.black87,
//                             size: 21,
//                           ),
//                           filled: true,
//                           fillColor: Colors.white,
//                           contentPadding: EdgeInsets.all(15),
//                           enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(19),
//                               borderSide: const BorderSide(
//                                 width: 0.4,
//                                 color: Colors.black38,
//                               )),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.all(Radius.circular(19)),
//                             borderSide:
//                                 BorderSide(color: primaryColor, width: 0.3),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   alignment: Alignment.topLeft,
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 33.0),
//                     child: IconButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         icon: Icon(
//                           Icons.arrow_back_ios,
//                           size: 22,
//                           color: Colors.black,
//                         )),
//                   ),
//                 ),
//                 DraggableScrollableSheet(
//                     maxChildSize: 0.76,
//                     initialChildSize: 0.20,
//                     minChildSize: 0.05,
//                     builder: (context, scrollController) =>
//                         StatefulBuilder(builder: (context, setState) {
//                           return SingleChildScrollView(
//                             child: Column(
//                               children: [
//                                 Container(
//                                   // height: 300,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.only(
//                                       topRight: Radius.circular(20),
//                                       topLeft: Radius.circular(20),
//                                     ),
//                                     color: Colors.white,
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(15.0),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Column(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: <Widget>[
//                                             Text(
//                                               'Choose Destination',
//                                               style: GoogleFonts.raleway(
//                                                 fontSize: 14,
//                                                 color: Colors.black,
//                                                 fontWeight: FontWeight.w400,
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             Container(
//                                               child: TextFormField(
//                                                 maxLines: 1,
//                                                 textAlign: TextAlign.center,
//                                                 readOnly: true,
//                                                 decoration:
//                                                     const InputDecoration(
//                                                         contentPadding:
//                                                             EdgeInsets.zero,
//                                                         border:
//                                                             InputBorder.none),
//                                                 controller: textController,
//                                               ),
//                                             ),
//                                             addVertical(10),
//                                             Padding(
//                                               padding: const EdgeInsets.only(
//                                                   left: 20.0,
//                                                   right: 20,
//                                                   bottom: 10),
//                                               child: MaterialButton(
//                                                 onPressed: () {
//                                                   print(
//                                                       "Location ${cameraPosition.target.latitude} ${cameraPosition.target.longitude}");
//                                                   print(
//                                                       "Address: ${textController.text}");
//
//                                                   var draggedPosition =
//                                                       // Position(
//                                                       //     latitude:
//                                                       //         cameraPosition
//                                                       //             .target
//                                                       //             .latitude,
//                                                       //     longitude:
//                                                       //         cameraPosition
//                                                       //             .target
//                                                       //             .longitude);
//
//                                                   // print(
//                                                   //     "The dragged Position: ${draggedPosition}");
//                                                   // Provider.of<AppData>(context,
//                                                   //         listen: false)
//                                                   //     .updateActualCoordinates(
//                                                   //         draggedPosition);
//
//                                                   Provider.of<AppData>(context,
//                                                           listen: false)
//                                                       .updateActualLocationName(
//                                                           textController.text);
//                                                   print("The dragged new location from provider: ${Provider.of<AppData>(context, listen: false).locationName}");
//
//                                                   Navigator.pop(context,
//                                                       textController.text);
//                                                 },
//                                                 height: 40,
//                                                 elevation: 0,
//                                                 splashColor: Colors.teal[700],
//                                                 shape: RoundedRectangleBorder(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             10)),
//                                                 color: Colors.teal,
//                                                 child: Center(
//                                                   child: Text(
//                                                     "Confirm Location",
//                                                     style: GoogleFonts.raleway(
//                                                         color: Colors.white,
//                                                         fontSize: 15,
//                                                         fontWeight:
//                                                             FontWeight.w500),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             SizedBox(height: 10),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         })),
//               ],
//             );
//           }),
//         ));
//   }
//
//   // Future<void> _handlePressButton() async {
//   //   Prediction p = await PlacesAutocomplete.show(
//   //       // offset: 0,
//   //       // radius: 1000,
//   //       context: context,
//   //       onError: onError,
//   //       region: "gh",
//   //       mode: _mode,
//   //       language: 'en',
//   //       apiKey: "AIzaSyAo7h5Umz4xhDTpihlaKVngpn-m2wZYLXc",
//   //       strictbounds: false,
//   //       components: [
//   //         Component(Component.country, "gh"),
//   //         Component(Component.country, "gh")
//   //       ],
//   //       types: [],
//   //       hint: "Search Location",
//   //       startText: _currentAddress != null ? _currentAddress : "start"
//   //   );
//   //
//   //   print('prediction: ${p.description}');
//   //   displayPrediction(
//   //     p,
//   //     homeScaffoldKey.currentState,
//   //   );
//   // }
//   //
//   // void onError(PlacesAutocompleteResponse response) {
//   //   // homeScaffoldKey.currentState
//   //   //     .showSnackBar(SnackBar(content: Text(response.errorMessage)));
//   // }
//   //
//   // Future<void> displayPrediction(
//   //     Prediction p, ScaffoldState currentState) async {
//   //   GoogleMapsPlaces places = GoogleMapsPlaces(
//   //       apiKey: kGoogleApiKey,
//   //       apiHeaders: await const GoogleApiHeaders().getHeaders());
//   //
//   //   PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId);
//   //
//   //   final lat = detail.result.geometry.location.lat;
//   //   final lng = detail.result.geometry.location.lng;
//   //   print("Search lat: ${lat}");
//   //   Position searchedLocation = Position(longitude: lng, latitude: lat);
//   //
//   //   print("THE COMBINED: ${searchedLocation}");
//   //   Provider.of<AppData>(context, listen: false)
//   //       .updateActualCoordinates(searchedLocation);
//   //   print(
//   //       "THE ACTUAL Coordinates from provider: ${Provider.of<AppData>(context, listen: false).searchPosition}");
//   //
//   //   String actualLocation = detail.result.name.toString();
//   //   Provider.of<AppData>(context, listen: false)
//   //       .updateActualLocation(actualLocation);
//   //   print("THE ACTUAL LOCATION: ${actualLocation}");
//   //   print(
//   //       "THE ACTUAL LOCATION from provider: ${Provider.of<AppData>(context, listen: false).actualLocation}");
//   //
//   //   Position locationSearch =
//   //       Provider.of<AppData>(context, listen: false).searchPosition;
//   //   print("locationSearch in display prediction: ${locationSearch}");
//   //   // setState(() {
//   //   //   locationSearch.updateSearchedLocation(searchedLocation);
//   //   //   print("Location...: ${locationSearch.searchPosition}");
//   //   // });
//   //
//   //   markersList.clear();
//   //   markersList.add(Marker(
//   //       markerId: MarkerId("0"),
//   //       position: LatLng(lat, lng),
//   //       infoWindow: InfoWindow(title: detail.result.name)));
//   //
//   //   setState(() {});
//   //   googleMapController
//   //       .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 16.6));
//   // }
// }
