// import 'dart:async';
// import 'dart:convert';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../../Constants/myColors.dart';
// import '../../Database/RequestListDB.dart';
// import '../../Model/AppData.dart';
// import '../../Model/RequestModel.dart';
// import '../../Services/services/api/api_service.dart';
// import '../../Utils/NetworkUtility.dart';
// import '../../Utils/Utility.dart';
// // import '../../Utils/paths.dart';
// import '../../config/Config.env.dart';
// import '../../main.dart';
// import '../../services/api/api_service.dart';
//
// class StatusScreen extends StatefulWidget {
//   final RequestModel? requestModel;
//
//   const StatusScreen({Key? key, this.requestModel}) : super(key: key);
//   @override
//   _StatusScreenState createState() =>
//       _StatusScreenState(requestModel: requestModel);
// }
//
// class _StatusScreenState extends State<StatusScreen> {
//   LatLng? currentLocation;
//   final RequestModel? requestModel;
//
//   double? newLatitude;
//   double? newLongitude;
//   LatLng? newCord;
//   double cameraZoom = 14;
//   RequestModel? requestId;
//   RequestListDB requestListDB = RequestListDB();
//   RequestModel? newRequestModel;
//   BitmapDescriptor? _customSource;
//   BitmapDescriptor? _customDestination;
//
//   _StatusScreenState({this.currentLocation, this.requestModel});
//
//   late final FirebaseMessaging _messaging;
//   Set<Marker> _markers = {};
//   Map<PolylineId, Polyline> polylines = {};
//   PolylinePoints polylinePoints = PolylinePoints();
//   double updateLat = 0.0, updadatelong = 0.0;
//   late final Timer _timer;
//   int? time;
//   final LocationSettings locationSettings = LocationSettings(
//     accuracy: LocationAccuracy.high,
//     distanceFilter: 100,
//   );
//
//   double? distance;
//   String? newToken;
//
//   double updateAgentLatitude = 0.0;
//   double updateAgentLongitude = 0.0;
//
//   String originPlaceName = '', destinationPlaceName = '';
//
//   // LatLng? currentLocation;
//   final Completer<GoogleMapController> mapController = Completer();
//   GoogleMapController? newGoogleMapController;
//
//   LatLng? initialPosition;
//   RequestModel? jobDetailsModel;
//
//   bool? showSpinner = true;
//   bool? showLoader = true;
//
//   @override
//   void initState() {
//     BitmapDescriptor.fromAssetImage(
//             ImageConfiguration(size: Size(60, 60)), 'assets/images/source.png')
//         .then((customMarker) {
//       _customSource = customMarker;
//     });
//     BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(60, 60)),
//             'assets/images/destination.png')
//         .then((customMarkerDestination) {
//       _customDestination = customMarkerDestination;
//     });
//     print("THE REQUEST DETAILS FROM PREV PAGE: ${widget.requestModel}");
//     registerNotification(context);
//     print(
//         "THE PROVIDER WITH JOB DETAILS:${Provider.of<AppData>(context, listen: false).requestModel}");
//
//     jobDetailsModel =
//         Provider.of<AppData>(context, listen: false).requestModel!;
//
//     print(
//         "THE JOB DETAILS FROM PROVIDER: ${Provider.of<AppData>(context, listen: false).requestModel}");
//
//     print("THE COORD:${currentLocation}");
//     print(
//         "THE AGENT COORDINATES:${Provider.of<AppData>(context, listen: false).agentLatLng}");
//     newCord = Provider.of<AppData>(context, listen: false).agentLatLng;
//
//     // newLatitude = newCord!.latitude;
//     // newLongitude = newCord!.longitude;
//
//     print("LATITUDE:${newLatitude}");
//     getUserLocation();
//     _getUpdatePosition();
//     super.initState();
//   }
//
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   void getUserLocation() async {
//     var position = await GeolocatorPlatform.instance.getCurrentPosition(
//         locationSettings: const LocationSettings(
//             accuracy: LocationAccuracy.bestForNavigation));
//
//     setState(() {
//       initialPosition = LatLng(position.latitude, position.longitude);
//       currentLocation = initialPosition;
//       print(currentLocation);
//     });
//     await agentLocation(context);
//
//     _setMarker();
//     await getDirections();
//     final GoogleMapController controller = await mapController.future;
//     controller.animateCamera(
//       CameraUpdate.newLatLng(currentLocation!),
//     );
//   }
//
//   // void getUserAndTrackingAgentLocation() async {
//   //   var position = await GeolocatorPlatform.instance.getCurrentPosition(
//   //       locationSettings: const LocationSettings(
//   //           accuracy: LocationAccuracy.bestForNavigation));
//   //   setState(() {
//   //     initialPosition = LatLng(position.latitude, position.longitude);
//   //     currentLocation = initialPosition;
//   //     print("This is the current Location for the customer $currentLocation");
//   //   });
//   //   final GoogleMapController controller = await mapController.future;
//   //   controller.animateCamera(
//   //     CameraUpdate.newLatLng(currentLocation!),
//   //   );
//   //   await agentLocation(context);
//
//   //   _setMarker();
//   //   await getDirections();
//   // return await context
//   //     .read<ApiService>()
//   //     .trackingAgent(widget.requestModel!, context)
//   //     .then(
//   //   (value) {
//   //     print(value);
//   //     setState(() {
//   //       updateAgentLatitude = value.last.currentLatitude!;
//   //       updateAgentLongitude = value.last.currentLongitude!;
//   //     });
//   //     _setMarker();
//   //     getDirections();
//   //     _timer = Timer.periodic(Duration(seconds: 2), (_) async {
//   //       await context
//   //           .read<ApiService>()
//   //           .trackingAgent(widget.requestModel!, context)
//   //           .then(
//   //         (value) {
//   //           print(value);
//   //           setState(() {
//   //             updateAgentLatitude = value.last.currentLatitude!;
//   //             updateAgentLongitude = value.last.currentLongitude!;
//   //           });
//   //           // _setMarker();
//   //           // getDirections();
//   //         },
//   //       );
//   //     });
//   //   },
//   // );
//   // }
//
//   Future<void> agentLocation(BuildContext context) async {
//     var response =
//         await context.read<ApiService>().trackingAgent(requestModel!, context);
//     setState(() {
//       updateAgentLatitude = response.last.currentLatitude!;
//       updateAgentLongitude = response.last.currentLongitude!;
//     });
//
//     print("This is the current Location of the agent $updadatelong ");
//
//     trackingAgent();
//   }
//
//   Future<void> trackingAgent() async {
//     _timer = Timer.periodic(Duration(seconds: 1), (_) async {
//       await context
//           .read<ApiService>()
//           .trackingAgent(widget.requestModel!, context)
//           .then(
//         (value) {
//           print(value);
//           setState(() {
//             updateAgentLatitude = value.last.currentLatitude!;
//             updateAgentLongitude = value.last.currentLongitude!;
//           });
//           _setMarker();
//           getDirections();
//         },
//       );
//     });
//   }
//
//   Future<void> confirmArrival(
//     BuildContext context,
//     RequestModel dataModel,
//   ) async {
//     final config = await AppConfig.forEnvironment(envVar);
//     try {
//       EasyLoading.show(status: 'Confirming arrival...');
//       var jsonBody = jsonEncode(dataModel);
//       NetworkUtility networkUtility = NetworkUtility();
//       Response? response = await networkUtility.putDataWithAuth(
//         url: config.confirmArrivalUrl!,
//         auth: 'Bearer ${config.token}',
//         body: jsonBody,
//       );
//       if (response == null) {
//         EasyLoading.dismiss();
//         //error handling
//         ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
//           SnackBar(
//             content: Row(
//               children: [
//                 const Icon(
//                   Icons.error,
//                   color: Colors.orange,
//                 ),
//                 SizedBox(
//                   width: 5,
//                 ),
//                 Text(
//                   "An error occurred while confirming arrival",
//                   style: GoogleFonts.raleway(
//                       fontSize: 14,
//                       color: Colors.orangeAccent,
//                       fontWeight: FontWeight.w600),
//                 ),
//               ],
//             ),
//           ),
//         );
//       } else {
//         var data = jsonDecode(response.body);
//         int status = data['status'];
//         print('Status: $status');
//
//         if (status == 500 || status == 404 || status == 403) {
//           Navigator.of(context, rootNavigator: true).pop();
//           EasyLoading.dismiss();
//           ScaffoldMessenger.of(_scaffoldKey.currentContext!)
//               .showSnackBar(SnackBar(
//             content: Row(
//               children: [
//                 const Icon(
//                   Icons.error,
//                   color: Colors.orange,
//                 ),
//                 SizedBox(
//                   width: 5,
//                 ),
//                 Text(
//                   "An error occurred while fetching car data",
//                   style: GoogleFonts.raleway(
//                       fontSize: 14,
//                       color: Colors.orangeAccent,
//                       fontWeight: FontWeight.w600),
//                 ),
//               ],
//             ),
//           ));
//         } else if (status == 400) {
//           EasyLoading.dismiss();
//           showSuccess(context, message: 'Site arrival already confirmed');
//           Navigator.of(context, rootNavigator: true).pop();
//         } else if (status == 200) {
//           showSuccess(context, message: 'Site arrival confirmed');
//           EasyLoading.showSuccess('Done!');
//           Navigator.of(this.context, rootNavigator: true).pop();
//
//           var data = jsonDecode(response.body);
//           var request = data['data'];
//
//           RequestModel requestModel = RequestModel(
//               serviceId: request['serviceId'],
//               service: request['service'],
//               description: request['description'],
//               deliveryType: request['deliveryType'],
//               deliveryAddress: request['deliveryAddress'],
//               requestImage: request['requestImage'],
//               customerName: request['customerName'],
//               customerEmail: request['customerEmail'],
//               customerPhone: request['customerPhone'],
//               agentName: request['agentName'],
//               agentPhoto: request['agentPhoto'],
//               agentPhone: request['agentPhone'],
//               companyName: request['companyName'],
//               calloutFee: request['calloutFee'].toString(),
//               professionalFee: request['professionalFee'].toString(),
//               requestStatus: request['requestStatus'],
//               dateCreated: request['dateCreated'],
//               additionalInfo: request['additionalInfo'],
//               vehicleNumber: request['vehicleNumber'],
//               requestId: request['requestId'].toString(),
//               deliveryLatitude: request['deliveryLatitude'],
//               deliveryLongitude: request['deliveryLongitude']);
//           print("Re Model: $requestModel");
//
//           setState(() {
//             newRequestModel = requestModel;
//           });
//
//           print("JOB DETAILS:${newRequestModel}");
//
//           setState(() {
//             dynamic request = widget.requestModel!.requestId;
//             setState(() {
//               requestId = request;
//             });
//           });
//           if (mounted) {
//             Navigator.of(this.context, rootNavigator: true).pop();
//           }
//
//           EasyLoading.dismiss();
//           ScaffoldMessenger.of(_scaffoldKey.currentContext!)
//               .showSnackBar(SnackBar(
//             backgroundColor: Colors.white,
//             content: Row(
//               children: [
//                 const Icon(
//                   Icons.check_circle,
//                   color: Colors.lightGreenAccent,
//                 ),
//                 SizedBox(
//                   width: 5,
//                 ),
//                 Text(
//                   "Arrival Confirmed",
//                   style: GoogleFonts.raleway(
//                       fontSize: 14,
//                       color: Colors.black54,
//                       fontWeight: FontWeight.w600),
//                 ),
//               ],
//             ),
//           ));
//         }
//         // Navigator.of(context, rootNavigator: true).pop();
//         EasyLoading.dismiss();
//       }
//
//       // Navigator.of(context, rootNavigator: true).pop();
//     } catch (e) {
//       EasyLoading.dismiss();
//       // debugPrint('fetch car data error: $e');
//       // ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(SnackBar(
//       //   content: Row(
//       //     children: [
//       //       const Icon(Icons.error,color: Colors.orange,),
//       //       SizedBox(width: 5,),
//       //       Text("An error occurred",style: GoogleFonts.raleway(fontSize: 14,color: Colors.orangeAccent,fontWeight: FontWeight.w600),),
//       //     ],
//       //   ),
//       // ));
//       // Navigator.of(context, rootNavigator: true).pop();
//     }
//   }
//
//   //fcm setup
//   void registerNotification(BuildContext context) async {
//     // 2. Instantiate Firebase Messaging
//     _messaging = FirebaseMessaging.instance;
//     // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//     // 3. On iOS, this helps to take the user permissions
//     NotificationSettings settings = await _messaging.requestPermission(
//       alert: true,
//       badge: true,
//       provisional: false,
//       sound: true,
//     );
//
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       // For handling the received notifications
//       FirebaseMessaging.onMessage.listen((
//         RemoteMessage message,
//       ) {
//         print('FCM_ON_REQUEST_PAGE: ${message.data}');
//         var requestId = message.data["requestId"];
//         if (requestId != null) {
//           showLoader = false;
//           showSpinner = false;
//         }
//       });
//     } else {
//       print('User declined or has not accepted permission');
//     }
// // For handling notification when the app is in background
//     // but not terminated
//     FirebaseMessaging.onMessageOpenedApp.listen((
//       RemoteMessage message,
//     ) {
//       debugPrint("RemoteMessage background message: $message");
//     });
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     _timer.cancel();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Stack(
//       children: [
//         currentLocation == null
//             ? const Center(child: Text("Please Wait..."))
//             : GoogleMap(
//                 initialCameraPosition: CameraPosition(
//                   target: initialPosition!,
//                   zoom: cameraZoom,
//                 ),
//                 myLocationEnabled: false,
//                 polylines: Set<Polyline>.of(polylines.values),
//                 markers: _markers,
//                 myLocationButtonEnabled: true,
//                 onMapCreated: (GoogleMapController controller) {
//                   mapController.complete(controller);
//
//                   newGoogleMapController = controller;
//                   // newGoogleMapController!
//                   //     .showMarkerInfoWindow(MarkerId("source"));
//                   newGoogleMapController!
//                       .showMarkerInfoWindow(MarkerId("destination"));
//
//                   // //for black theme google map
//                   newGoogleMapController!.setMapStyle('''
//                     [
//     {
//         "featureType": "all",
//         "elementType": "all",
//         "stylers": [
//             {
//                 "saturation": -100
//             },
//             {
//                 "gamma": 0.5
//             }
//         ]
//     }
// ]
//                 ''');
//                 },
//               ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Container(
//               alignment: Alignment.topLeft,
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 33.0),
//                 child: IconButton(
//                     onPressed: () {
//                      Navigator.pop(context);
//                     },
//                     icon: const Icon(
//                       Icons.arrow_back_ios,
//                       size: 26,
//                       color: Colors.black,
//                     )),
//               ),
//             ),
//           ],
//         ),
//         DraggableScrollableSheet(
//             maxChildSize: 0.5,
//             initialChildSize: 0.35,
//             minChildSize: 0.33,
//             builder: (context, scrollController) =>
//                 StatefulBuilder(builder: (context, setState) {
//                   return SingleChildScrollView(
//                     physics: AlwaysScrollableScrollPhysics(),
//                     controller: scrollController,
//                     child: Column(
//                       children: [
//                         Container(
//                           height: MediaQuery.of(context).size.height * 0.50,
//                           width: MediaQuery.of(context).size.width,
//                           decoration: const BoxDecoration(
//                             borderRadius: BorderRadius.only(
//                               topRight: Radius.circular(20),
//                               topLeft: Radius.circular(20),
//                             ),
//                             color: Colors.white,
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(15.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: <Widget>[
//                                     const SizedBox(
//                                       height: 4,
//                                     ),
//                                     SizedBox(
//                                       height: 18,
//                                     ),
//                                     Divider(
//                                         color: Colors.black54, thickness: 0.24),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   "Agent Name:  ",
//                                                   style: GoogleFonts.lato(
//                                                     color: Colors.black54,
//                                                     fontSize: 14,
//                                                     fontWeight: FontWeight.w700,
//                                                   ),
//                                                 ),
//                                                 Text(
//                                                   requestModel!.agentName !=
//                                                           null
//                                                       ? requestModel!.agentName!
//                                                       : "-",
//                                                   style: GoogleFonts.lato(
//                                                     color: Colors.black,
//                                                     fontSize: 13,
//                                                     fontWeight: FontWeight.w500,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   "Agent Phone: ",
//                                                   style: GoogleFonts.lato(
//                                                     color: Colors.black54,
//                                                     fontSize: 14,
//                                                     fontWeight: FontWeight.w700,
//                                                   ),
//                                                 ),
//                                                 Text(
//                                                   requestModel!.agentPhone !=
//                                                           null
//                                                       ? requestModel!
//                                                           .agentPhone!
//                                                       : "-",
//                                                   style: GoogleFonts.lato(
//                                                     color: Colors.black,
//                                                     fontSize: 13,
//                                                     fontWeight: FontWeight.w500,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   "Company: ",
//                                                   style: GoogleFonts.lato(
//                                                     color: Colors.black54,
//                                                     fontSize: 14,
//                                                     fontWeight: FontWeight.w700,
//                                                   ),
//                                                 ),
//                                                 Text(
//                                                   requestModel!.companyName !=
//                                                           null
//                                                       ? requestModel!
//                                                           .companyName!
//                                                       : "-",
//                                                   style: GoogleFonts.lato(
//                                                     color: Colors.black,
//                                                     fontSize: 13,
//                                                     fontWeight: FontWeight.w500,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: GestureDetector(
//                                                 onTap: () {
//                                                   _makePhoneCall(requestModel!
//                                                       .agentPhone
//                                                       .toString());
//                                                 },
//                                                 child: Align(
//                                                   alignment: Alignment.topLeft,
//                                                   child: Container(
//                                                     height: 37,
//                                                     width: 120,
//                                                     child: Center(
//                                                       child: Row(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .center,
//                                                         children: [
//                                                           Icon(
//                                                             Icons.call,
//                                                             size: 18,
//                                                             color: Colors.white,
//                                                           ),
//                                                           SizedBox(
//                                                             width: 5,
//                                                           ),
//                                                           Text(
//                                                             "Call Agent",
//                                                             style: GoogleFonts
//                                                                 .raleway(
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .w600,
//                                                                     fontSize:
//                                                                         14,
//                                                                     color: Colors
//                                                                         .white),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                     decoration: BoxDecoration(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(5),
//                                                         color: Colors.teal),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         Column(
//                                           children: [
//                                             Container(
//                                                 child: requestModel!
//                                                             .agentPhoto !=
//                                                         null
//                                                     ? CircleAvatar(
//                                                         radius: 40,
//                                                         backgroundImage:
//                                                             NetworkImage(
//                                                                 requestModel!
//                                                                     .agentPhoto
//                                                                     .toString()),
//                                                       )
//                                                     : CircleAvatar(
//                                                         radius: 45,
//                                                         backgroundImage: AssetImage(
//                                                             "assets/images/no_user.jpg"),
//                                                       )),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                     Divider(
//                                         color: Colors.black54, thickness: 0.24),
//                                     SizedBox(
//                                       height: 20,
//                                     ),
//                                     Container(
//                                       child: showLoader == true
//                                           ? Container()
//                                           : Container(
//                                               height: 50,
//                                               width: MediaQuery.of(context)
//                                                       .size
//                                                       .height *
//                                                   0.4,
//                                               child: ElevatedButton(
//                                                 style: ElevatedButton.styleFrom(
//                                                     backgroundColor:
//                                                         Colors.green),
//                                                 onPressed: () async {
//                                                   _timer.cancel();
//                                                   RequestModel requestNewModel =
//                                                       RequestModel(
//                                                           requestId:
//                                                               requestModel!
//                                                                   .requestId);
//                                                   await confirmArrival(
//                                                       context, requestNewModel);
//                                                   // Navigator.push(context, MaterialPageRoute(builder: (context)=>HistoryDetailsScreen(requestModel: newRequestModel,)));
//                                                   // Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfessionalPaymentScreen(requestId: requestNewModel.requestId,)));
//                                                 },
//                                                 child: Text(
//                                                   "Confirm Arrival"
//                                                       .toUpperCase(),
//                                                   style: GoogleFonts.raleway(
//                                                     color: Colors.white,
//                                                     fontWeight: FontWeight.w600,
//                                                     fontSize: 13.0,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                     ),
//                                     // Column(
//                                     //   children: (showSpinner!)
//                                     //       ? [
//                                     //     Column(
//                                     //       children: [
//                                     //         Padding(
//                                     //           padding:
//                                     //           const EdgeInsets
//                                     //               .only(
//                                     //               top:
//                                     //               24.0),
//                                     //           child:
//                                     //           CircularProgressIndicator(
//                                     //             strokeWidth:
//                                     //             1.8,
//                                     //             color: Colors
//                                     //                 .teal,
//                                     //           ),
//                                     //         ),
//                                     //         SizedBox(
//                                     //           height: 12,
//                                     //         ),
//                                     //         Container(
//                                     //           height: 50,
//                                     //           child:
//                                     //           ElevatedButton(
//                                     //             style: ElevatedButton
//                                     //                 .styleFrom(
//                                     //                 backgroundColor:
//                                     //                 Colors.grey),
//                                     //             onPressed:
//                                     //                 () async {
//                                     //               showDialog(
//                                     //                   context:
//                                     //                   this
//                                     //                       .context,
//                                     //                   builder:
//                                     //                       (context) {
//                                     //                     return AlertDialog(
//                                     //                       title:
//                                     //                       Center(
//                                     //                         child: Text(
//                                     //                           "Confirmation",
//                                     //                           style: GoogleFonts.raleway(
//                                     //                             fontSize: 16,
//                                     //                             fontWeight: FontWeight.w600,
//                                     //                             color: Colors.black,
//                                     //                             letterSpacing: 0.3,
//                                     //                           ),
//                                     //                         ),
//                                     //                       ),
//                                     //                       content:
//                                     //                       Text(
//                                     //                         "Are you sure you cancel request?",
//                                     //                         style: GoogleFonts.raleway(
//                                     //                           fontSize: 13,
//                                     //                           fontWeight: FontWeight.w500,
//                                     //                           color: Colors.black,
//                                     //                           letterSpacing: 0.3,
//                                     //                         ),
//                                     //                       ),
//                                     //                       actions: <Widget>[
//                                     //                         Padding(
//                                     //                           padding: const EdgeInsets.only(bottom: 8.0),
//                                     //                           child: SizedBox(
//                                     //                             height: 34,
//                                     //                             child: ElevatedButton(
//                                     //                               style: ElevatedButton.styleFrom(
//                                     //                                 backgroundColor: Colors.red.shade200,
//                                     //                               ),
//                                     //                               onPressed: () async {
//                                     //
//                                     //                               },
//                                     //                               child: Text(
//                                     //                                 "Yes",
//                                     //                                 style: GoogleFonts.raleway(
//                                     //                                   fontSize: 14,
//                                     //                                   fontWeight: FontWeight.w700,
//                                     //                                   color: Colors.white,
//                                     //                                   letterSpacing: 0.0,
//                                     //                                 ),
//                                     //                               ),
//                                     //                             ),
//                                     //                           ),
//                                     //                         ),
//                                     //                         Padding(
//                                     //                           padding: const EdgeInsets.only(bottom: 8.0, right: 8),
//                                     //                           child: SizedBox(
//                                     //                             height: 34,
//                                     //                             child: ElevatedButton(
//                                     //                                 style: ElevatedButton.styleFrom(
//                                     //                                   backgroundColor: kPrimaryTheme,
//                                     //                                 ),
//                                     //                                 onPressed: () {
//                                     //                                   Navigator.pop(context); //close Dialog
//                                     //                                 },
//                                     //                                 child: Text(
//                                     //                                   "No",
//                                     //                                   style: GoogleFonts.raleway(
//                                     //                                     fontSize: 14,
//                                     //                                     fontWeight: FontWeight.w700,
//                                     //                                     color: Colors.white,
//                                     //                                     letterSpacing: 0.0,
//                                     //                                   ),
//                                     //                                 )),
//                                     //                           ),
//                                     //                         )
//                                     //                       ],
//                                     //                     );
//                                     //                   });
//                                     //             },
//                                     //             child: Row(
//                                     //               mainAxisAlignment:
//                                     //               MainAxisAlignment
//                                     //                   .center,
//                                     //               children: [
//                                     //                 Icon(
//                                     //                   Icons
//                                     //                       .clear,
//                                     //                   size:
//                                     //                   20,
//                                     //                   color: Colors
//                                     //                       .white,
//                                     //                 ),
//                                     //                 SizedBox(
//                                     //                   width:
//                                     //                   5,
//                                     //                 ),
//                                     //                 Center(
//                                     //                   child:
//                                     //                   Text(
//                                     //                     "Cancel Request"
//                                     //                         .toUpperCase(),
//                                     //                     style:
//                                     //                     GoogleFonts.raleway(
//                                     //                       color:
//                                     //                       Colors.white,
//                                     //                       fontWeight:
//                                     //                       FontWeight.w600,
//                                     //                       fontSize:
//                                     //                       13.0,
//                                     //                     ),
//                                     //                   ),
//                                     //                 ),
//                                     //               ],
//                                     //             ),
//                                     //           ),
//                                     //         ),
//                                     //       ],
//                                     //     ),
//                                     //   ]
//                                     //       : [
//                                     //     Container(
//                                     //       height: 50,
//                                     //       width:
//                                     //       MediaQuery.of(context)
//                                     //           .size
//                                     //           .height *
//                                     //           0.4,
//                                     //       child: ElevatedButton(
//                                     //         style: ElevatedButton
//                                     //             .styleFrom(
//                                     //             backgroundColor:
//                                     //             Colors.green),
//                                     //         onPressed: () async {
//                                     //           _timer.cancel();
//                                     //           RequestModel requestNewModel = RequestModel(requestId: requestModel!.requestId);
//                                     //           await  confirmArrival(context, requestNewModel);
//                                     //           // Navigator.push(context, MaterialPageRoute(builder: (context)=>HistoryDetailsScreen(requestModel: newRequestModel,)));
//                                     //           // Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfessionalPaymentScreen(requestId: requestNewModel.requestId,)));
//                                     //         },
//                                     //         child: Text(
//                                     //           "Confirm Arrival"
//                                     //               .toUpperCase(),
//                                     //           style:
//                                     //           GoogleFonts.raleway(
//                                     //             color: Colors.white,
//                                     //             fontWeight:
//                                     //             FontWeight.w600,
//                                     //             fontSize: 13.0,
//                                     //           ),
//                                     //         ),
//                                     //       ),
//                                     //     ),
//                                     //   ],
//                                     // ),
//                                     //
//                                     // Container(
//                                     //     child: showSpinner == false
//                                     //         ? Padding(
//                                     //       padding: const EdgeInsets.only(top: 24.0),
//                                     //       child: CircularProgressIndicator(
//                                     //         strokeWidth: 2.0,
//                                     //         color: Colors.teal,
//                                     //       ),
//                                     //     )
//                                     //         :   Padding(
//                                     //       padding: const EdgeInsets.all(0),
//                                     //       child: Row(
//                                     //         mainAxisAlignment:
//                                     //         MainAxisAlignment.center,
//                                     //         children: [
//                                     //           Container(
//                                     //             height: 50,
//                                     //             width:
//                                     //             MediaQuery.of(context)
//                                     //                 .size
//                                     //                 .height *
//                                     //                 0.4,
//                                     //             child: ElevatedButton(
//                                     //               style: ElevatedButton
//                                     //                   .styleFrom(
//                                     //                   backgroundColor:
//                                     //                   Colors.green),
//                                     //               onPressed: () async {
//                                     //                 _timer.cancel();
//                                     //                 RequestModel requestNewModel = RequestModel(requestId: requestModel!.requestId);
//                                     //                 await  confirmArrival(context, requestNewModel);
//                                     //                 // Navigator.push(context, MaterialPageRoute(builder: (context)=>HistoryDetailsScreen(requestModel: newRequestModel,)));
//                                     //                 // Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfessionalPaymentScreen(requestId: requestNewModel.requestId,)));
//                                     //               },
//                                     //               child: Text(
//                                     //                 "Confirm Arrival"
//                                     //                     .toUpperCase(),
//                                     //                 style:
//                                     //                 GoogleFonts.raleway(
//                                     //                   color: Colors.white,
//                                     //                   fontWeight:
//                                     //                   FontWeight.w600,
//                                     //                   fontSize: 13.0,
//                                     //                 ),
//                                     //               ),
//                                     //             ),
//                                     //           ),
//                                     //         ],
//                                     //       ),
//                                     //     ),
//                                     // ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 })),
//       ],
//     )
//     );
//   }
//
//   // void getUserLocation() async {
//   //   var position = await GeolocatorPlatform.instance.getCurrentPosition(
//   //       locationSettings: const LocationSettings(
//   //           accuracy: LocationAccuracy.bestForNavigation));
//
//   //   setState(() {
//   //     initialPosition = LatLng(position.latitude, position.longitude);
//   //     currentLocation = initialPosition;
//
//   //     print(currentLocation);
//   //   });
//
//   //   final GoogleMapController controller = await mapController.future;
//   //   controller.animateCamera(
//   //     CameraUpdate.newLatLng(currentLocation!),
//   //   );
//   //   getUserAndTrackingAgentLocation();
//   // }
//
//   getDirections() async {
//     final config = await AppConfig.forEnvironment(envVar);
//     List<LatLng> polylineCoordinates = [];
//     List<dynamic> points = [];
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//         config.mapApiKey!,
//         PointLatLng(currentLocation!.latitude, currentLocation!.longitude),
//         PointLatLng(updateAgentLatitude, updateAgentLongitude),
//         travelMode: TravelMode.driving);
//     if (result.points.isNotEmpty) {
//       result.points.forEach((PointLatLng point) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//         points.add({'lat': point.latitude, 'lng': point.longitude});
//       });
//     } else {
//       print(result.errorMessage);
//     }
//     addPolyLine(polylineCoordinates);
//   }
//
//   addPolyLine(List<LatLng> polylineCoordinates) {
//     PolylineId id = PolylineId('poly');
//     Polyline polyline = Polyline(
//       polylineId: id,
//       color: primaryColor,
//       points: polylineCoordinates,
//       width: 3,
//     );
//     polylines[id] = polyline;
//     setState(() {});
//   }
//
//   _setMarker() async {
//     Set<Marker> newMarker = new Set<Marker>();
//     newMarker.add(Marker(
//       markerId: MarkerId('source'),
//       infoWindow: InfoWindow(
//         title: 'Source',
//       ),
//       position: LatLng(currentLocation!.latitude, currentLocation!.longitude),
//       icon: _customSource!,
//     ));
//     newMarker.add(Marker(
//       markerId: MarkerId('destination'),
//       position: LatLng(updateAgentLatitude, updateAgentLongitude),
//       icon: _customDestination!,
//       infoWindow: InfoWindow(
//         title: 'Destinaton',
//       ),
//     ));
//     setState(() {
//       _markers = newMarker;
//     });
//     print("This is the $updateAgentLatitude and $updateAgentLongitude");
//   }
//
//   _getUpdatePosition() async {
//     await Geolocator.getPositionStream(locationSettings: locationSettings)
//         .listen((Position position) async {
//       Set<Marker> newMarker = new Set<Marker>();
//       newMarker.add(Marker(
//         markerId: MarkerId('maker'),
//         position: LatLng(updateAgentLatitude, updateAgentLongitude),
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//       ));
//       setState(() {
//         _markers = newMarker;
//       });
//       print(position.altitude);
//     });
//   }
//
//   Future<void> _makePhoneCall(String phoneNumber) async {
//     final Uri launchUri = Uri(
//       scheme: 'tel',
//       path: phoneNumber,
//     );
//     await canLaunchUrl(Uri.parse(launchUri.toString()));
//   }
// }
