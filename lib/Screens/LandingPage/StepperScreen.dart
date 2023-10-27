import 'dart:async';
import 'dart:convert';

// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../../Constants/constantColors.dart';
import '../../Constants/myColors.dart';
// import '../../Database/RequestListDB.dart';
import '../../Model/AppData.dart';
// import '../../Model/RequestModel.dart';
import '../../Utils/NetworkUtility.dart';
import '../../Utils/Utility.dart';
// import '../../Utils/paths.dart';
// import '../../config/Config.env.dart';
// import '../../config/config.dart';
import '../../main.dart';
// import '../../services/api/api_service.dart';
// import '../map/status_screen.dart';
// import 'ProfessionalPaymentScreen.dart';

// int currentStep = 0;

// ControlsDetails controlsDetails =ControlsDetails(currentStep: currentStep+=1, stepIndex: 0 );

class StepperScreen extends StatefulWidget {
  final LatLng? currentLocation;
  // final RequestModel? requestModel;

  StepperScreen({
    Key? key,
    this.currentLocation,
    // this.requestModel,
  }) : super(key: key);
  @override
  _StepperScreenState createState() =>
      _StepperScreenState();
}

class _StepperScreenState extends State<StepperScreen> {
  // final RequestModel? requestModel;
  //
  // late final FirebaseMessaging _messaging;

  _StepperScreenState();

  LatLng? currentLocation;
  LatLng? initialPosition;
  Set<Marker> _markers = {};
  Map<PolylineId, Polyline> polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();
  String? buttonText;
  bool? showButton = false;
  bool? showMap = false;
  bool? showSecondButton = false;
  bool? showCallButton = false;
  bool? showSpinner;
  double? agentLatitude;
  double? agentLongitude;
  BitmapDescriptor? _customSource;
  BitmapDescriptor? _customDestination;

  int step1 = 1;
  int step2 = 2;
  int step3 = 3;
  int step4 = 4;
  int step5 = 5;
  int step6 = 6;
  int step7 = 7;

  final Completer<GoogleMapController> mapController = Completer();
  GoogleMapController? newGoogleMapController;

  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(60, 60)), 'assets/images/source.png')
        .then((customMarker) {
      _customSource = customMarker;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(60, 60)),
        'assets/images/destination.png')
        .then((customMarkerDestination) {
      _customDestination = customMarkerDestination;
    });
    super.initState();
    registerNotification(context);

    // fetchRequestByID(context);

    getUserLocation();
    // print("THE AGENT COORDINATES: ${Provider.of<AppData>(context, listen: false).agentLatLng}");
    setState(() {});
  }

  // RequestModel? requestId;
  // RequestModel? newRequestModel;

  // getDirections() async {
  //   List<LatLng> polylineCoordinates = [];
  //   List<dynamic> points = [];
  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //       // ApiConfig.googleApiKey,
  //       // PointLatLng(currentLocation!.latitude, currentLocation!.longitude),
  //       // PointLatLng(agentLatitude!, agentLongitude!),
  //       // travelMode: TravelMode.driving);
  //   // if (result.points.isNotEmpty) {
  //   //   result.points.forEach((PointLatLng point) {
  //   //     polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //   //     points.add({'lat': point.latitude, 'lng': point.longitude});
  //   //   });
  //   // } else {
  //   //   print(result.errorMessage);
  //   // }
  //   // addPolyLine(polylineCoordinates);
  // }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: primaryColor,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  void getUserLocation() async {
    var position = await GeolocatorPlatform.instance.getCurrentPosition(
        locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.bestForNavigation));

    setState(() {
      initialPosition = LatLng(position.latitude, position.longitude);
      currentLocation = initialPosition;
      print(currentLocation);
    });
    // await agentLocation(context);

    _setMarker();
    // await getDirections();
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(
      CameraUpdate.newLatLng(currentLocation!),
    );
  }

  void registerNotification(BuildContext context) async {
    // 2. Instantiate Firebase Messaging
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
//           RemoteMessage message,
//           ) {
//         print('FCM_ON_REQUEST_PAGE: ${message.data}');
//         var requestId = message.data["requestId"];
//         if (requestId != null) {
//           setState(() {
//             _currentStep = _currentStep + 1;
//             if(_currentStep >= 5){
//               _currentStep = 5;
//             }
//             showSpinner = false;
//           });
//         }
//       });
//     } else {
//       print('User declined or has not accepted permission');
//     }
// // For handling notification when the app is in background
//     // but not terminated
//     FirebaseMessaging.onMessageOpenedApp.listen((
//         RemoteMessage message,
//         ) {
//       debugPrint("RemoteMessage background message: $message");
//     });
  }

  int _currentStep = 0;
  int? stepperValue;
  StepperType stepperType = StepperType.vertical;

  // RequestListDB requestListDB = RequestListDB();
  // RequestModel requestDetails = RequestModel();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool complete = false;

  void stepperStatus() {
    // if (requestModel!.requestStatus!.contains("completed")) {
    //   setState(() {
    //     _currentStep == 5;
    //   });
    // } else if (requestModel!.requestStatus!.contains("awaiting_payment")) {
    //   setState(() {
    //     _currentStep == 5;
    //   });
    // } else if (requestModel!.requestStatus!.contains("on_route")) {
    //   setState(() {
    //     _currentStep == 3;
    //   });
    // }
  }

  goTo(int step) {
    // if (requestModel!.requestStatus!.contains("completed")) {
    //   setState(() {
    //     _currentStep == 5;
    //   });
    // } else if (requestModel!.requestStatus!.contains("on_route")) {
    //   setState(() {
    //     _currentStep == 3;
    //   });
    // }
    //
    // setState(() {
    //   _currentStep == getStep() as int;
    // });
  }


  @override
  Widget build(BuildContext context) {
    print("THE CURRENT STEP: $_currentStep");

    // if (requestModel?.requestStatus.toString() == 'completed') {
    //   showButton = true;
    // } else {
    //   showButton = false;
    // }
    // if (requestModel?.requestStatus.toString() == 'on_route') {
    //   showMap = true;
    // } else {
    //   showMap = false;
    // }
    return Scaffold(
      backgroundColor: Color(0xFFEDF1F2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Process",
          style: GoogleFonts.raleway(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: kPrimaryTextColor,
          ),
        ),
        leading: const BackButton(
          color: kPrimaryTextColor,
        ),
        actions: [
          IconButton(
            onPressed: () async {

            },
            icon: Icon(
              Icons.refresh_rounded,
              color: kPrimaryTheme,
              size: 22,
            ),
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Theme(
                data: ThemeData(
                  canvasColor: kPrimaryTheme,
                  colorScheme: Theme
                      .of(context)
                      .colorScheme
                      .copyWith(
                    primary: Colors.green,
                    background: Colors.red,
                    secondary: Colors.red,
                  ),
                ),
                child: Stack(children: [
                  Stepper(
                    type: StepperType.vertical,
                    physics: ScrollPhysics(),
                    controlsBuilder: controlsBuilder,
                    currentStep: _currentStep,
                    onStepTapped: (step) {
                      if (step > _currentStep) {
                        setState(() {
                          _currentStep = step;
                        });
                      }
                    },
                    onStepContinue: () {
                      if (_currentStep == 0) {
                        setState(() => _currentStep += 1);
                      } else if (_currentStep == 1) {
                        _currentStep < 5
                            ? setState(() => _currentStep += 1)
                            : null;
                      } else if (_currentStep == 2) {
                        _currentStep < 5
                            ? setState(() => _currentStep += 1)
                            : null;
                      } else if (_currentStep == 3) {
                        _currentStep < 5
                            ? setState(() => _currentStep += 1)
                            : null;
                      } else if (_currentStep == 4) {
                        _currentStep < 5
                            ? setState(() => _currentStep += 1)
                            : null;
                      } else if (_currentStep == 5 || _currentStep == 6) {
                        _currentStep < 5
                            ? setState(() => _currentStep += 1)
                            : null;
                      } else if (_currentStep == 5 || _currentStep == 7) {
                        _currentStep < 5
                            ? setState(() => _currentStep += 1)
                            : null;
                      }
                    },
                    onStepCancel: cancel,
                    steps: getStep(),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Step> getStep() =>
      [
        Step(
          title:
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Assigned to a dispatch rider",
                      style: GoogleFonts.raleway(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    // Text((requestDetails.dateCreated.toString() == null ||
                    //     requestDetails.dateCreated
                    //         .toString()
                    //         .contains("null"))
                    //     ? "-"
                    //     : requestDetails.dateCreated.toString()),
                  ],
                )),
            Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_circle_down,
                      size: 26,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      _currentStep < 1
                          ? setState(() => _currentStep += 1)
                          : null;
                    },
                  ),
                )),
          ]),
          content: Column(),
          isActive: _currentStep >= 0,
          state: _currentStep == 0
              ? StepState.indexed
              : (_currentStep > 0)
              ? StepState.complete
              : StepState.disabled,
        ),
        Step(
          title:
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Dispatch rider has receive alert",
                      style: GoogleFonts.raleway(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    // Text((requestDetails.matchedDate.toString() == null ||
                    //     requestDetails.matchedDate
                    //         .toString()
                    //         .contains("null"))
                    //     ? "-"
                    //     : requestDetails.matchedDate.toString()),
                  ],
                )),
            Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_circle_down,
                      size: 26,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      _currentStep < 2
                          ? setState(() => _currentStep += 1)
                          : null;
                    },
                  ),
                )),
          ]),
          content: Column(),
          isActive: _currentStep >= 1,
          state: _currentStep == 1
              ? StepState.indexed
              : (_currentStep > 1)
              ? StepState.complete
              : StepState.disabled,
        ),
        Step(
          title:
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Dispatch has accepted order",
                      style: GoogleFonts.raleway(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    // Text((requestDetails.setOffDate.toString() == null ||
                    //     requestDetails.setOffDate
                    //         .toString()
                    //         .contains("null"))
                    //     ? "-"
                    //     : requestDetails.setOffDate.toString()),
                  ],
                )),
            Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_circle_down,
                      size: 26,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      _currentStep < 3
                          ? setState(() => _currentStep += 1)
                          : null;
                    },
                  ),
                )),
          ]),

          // content: Column(
          //   children: <Widget>[
          //     // Container(
          //     //     child: showMap == true
          //     //         ? ElevatedButton(
          //     //         onPressed: () {
          //     //           Navigator.push(
          //     //               context,
          //     //               MaterialPageRoute(
          //     //                   builder: (context) => StatusScreen(
          //     //                     requestModel: requestDetails,
          //     //                   )));
          //     //         },
          //     //         child: Text("View On Map "))
          //     //         : Container()
          //     // )
          //
          //
          //     // initialPosition == null
          //     //     ? const Center(child: Text("Kindly Wait For The Map"))
          //     //     : Container(
          //     //         height: MediaQuery.of(context).size.height /2,
          //     //         child: GoogleMap(
          //     //           initialCameraPosition: CameraPosition(
          //     //               target: initialPosition!, zoom: 14.5),
          //     //           myLocationEnabled: true,
          //     //           polylines: Set<Polyline>.of(polylines.values),
          //     //           markers: _markers,
          //     //           myLocationButtonEnabled: false,
          //     //         )),
          //     // Container(
          //     //     child: ElevatedButton(
          //     //         onPressed: () {
          //     //           Navigator.push(
          //     //               context,
          //     //               MaterialPageRoute(
          //     //                   builder: (context) => StatusScreen(
          //     //                         requestModel: requestDetails,
          //     //                       )));
          //     //         },
          //     //         child: Text("View On Map ")))
          //   ],
          // ),

          isActive: _currentStep >= 2,
          state: _currentStep >= 2 ? StepState.complete : StepState.disabled,
          content: Container(),
        ),
        Step(
          title:
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Dispatch begins delivery",
                      style: GoogleFonts.raleway(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    // Text((requestDetails.siteArrivalDate.toString() == null ||
                    //     requestDetails.siteArrivalDate
                    //         .toString()
                    //         .contains("null"))
                    //     ? "-"
                    //     : requestDetails.siteArrivalDate.toString()),
                  ],
                )),
            Expanded(
                child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_circle_down,
                  size: 26,
                  color: Colors.black,
                ),
                onPressed: () {
                  _currentStep < 4 ? setState(() => _currentStep += 1) : null;
                },
              ),
            )),
          ]),
          content: Column(
            children: <Widget>[
              initialPosition == null
                  ? const Center(child: Text("Please Wait..."))
                  : Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.25,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                        target: initialPosition!, zoom: 14.5),
                    myLocationEnabled: true,
                    polylines: Set<Polyline>.of(polylines.values),
                    markers: _markers,
                    myLocationButtonEnabled: false,
                    onMapCreated: (GoogleMapController controller) {
                      mapController.complete(controller);

                      newGoogleMapController = controller;
                      // newGoogleMapController!
                      //     .showMarkerInfoWindow(MarkerId("source"));
                      // newGoogleMapController!
                      //     .showMarkerInfoWindow(MarkerId("destination"));

                      // //for black theme google map
                      newGoogleMapController!.setMapStyle('''
                    [
    {
        "featureType": "all",
        "elementType": "all",
        "stylers": [
            {
                "saturation": -100
            },
            {
                "gamma": 0.5
            }
        ]
    }
]
                ''');
                    },
                  )),
              SizedBox(height: 10,),
              Container(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width /0.3,
                child: ElevatedButton(
                  style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => StatusScreen(
                    //           requestModel: requestDetails,
                    //         )));
                  },
                  child: Text(
                    "View on map",
                    style: GoogleFonts.raleway(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // content: Column(
          //   children: <Widget>[
          //     Container(
          //         child: showButton!
          //             ? Container()
          //             : ElevatedButton(
          //             onPressed: () async {
          //               // RequestModel requestNewModel = RequestModel(
          //               //     requestId: requestDetails.requestId);
          //               // await confirmArrival(context, requestNewModel);
          //             },
          //             child: Text("Confirm Arrival")))
          //   ],
          // ),
          isActive: _currentStep >= 3,
          state: _currentStep >= 3 ? StepState.complete : StepState.disabled,
        ),
        Step(
          title:
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Dispatch arrives at delivery location",
                      style: GoogleFonts.raleway(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    // Text((requestDetails.requestCompletionDate.toString() ==
                    //     null ||
                    //     requestDetails.requestCompletionDate
                    //         .toString()
                    //         .contains("null"))
                    //     ? "-"
                    //     : requestDetails.requestCompletionDate.toString()),
                  ],
                )),
            Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_circle_down,
                      size: 22,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      _currentStep < 5
                          ? setState(() => _currentStep += 1)
                          : null;
                    },
                  ),
                )),
          ]),
          content: Container(),
          // content: Column(
          //   children: <Widget>[
          //     Container(
          //       child: showButton == true
          //           ? Container()
          //           : ElevatedButton(
          //         style: ElevatedButton.styleFrom(
          //             backgroundColor: kPrimaryTheme),
          //         onPressed: () {
          //           // Navigator.push(
          //           //     context,
          //           //     MaterialPageRoute(
          //           //         builder: (context) =>
          //           //             ProfessionalPaymentScreen(
          //           //               requestId: requestDetails.requestId,
          //           //             )));
          //         },
          //         child: Text(
          //           "Proceed to Professional Fee",
          //           style: GoogleFonts.raleway(
          //             color: Colors.white,
          //             fontWeight: FontWeight.w600,
          //             fontSize: 16,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          isActive: _currentStep >= 4,
          state: _currentStep >= 4 ? StepState.complete : StepState.disabled,
        ),
        Step(
          title:
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Item delivered successfully",
                      style: GoogleFonts.raleway(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    // Text((requestDetails.requestCompletionDate.toString() ==
                    //     null ||
                    //     requestDetails.requestCompletionDate
                    //         .toString()
                    //         .contains("null"))
                    //     ? "-"
                    //     : requestDetails.requestCompletionDate.toString()),
                  ],
                )),
          ]),
          content: Column(
            children: <Widget>[
              Container(
                child: showButton == true
                    ? Container()
                    : Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: MaterialButton(
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => OrderScreen(
                      //           track: "Success Screen",
                      //           showBackButton: true,
                      //         )));
                    },
                    height: MediaQuery.of(context).size.height * 0.06,
                    minWidth: MediaQuery.of(context).size.width /0.3,
                    elevation: 0,
                    splashColor: Colors.yellow[700],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    color: Colors.black,
                    child: Center(
                      child: Text(
                        "Proceed",
                        style: GoogleFonts.raleway(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                )
              ),
            ],
          ),
          isActive: _currentStep >= 6,
          state: _currentStep >= 6 ? StepState.complete : StepState.disabled,
        ),
        //     Step(
        //       title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        //         Expanded(
        //             flex: 3,
        //             child: Column(
        //               crossAxisAlignment: CrossAxisAlignment.stretch,
        //               children: [
        //                 Text(
        //                   "Awaiting Professional fee payment",
        //                   style: GoogleFonts.raleway(
        //                     color: Colors.black,
        //                     fontSize: 16,
        //                     fontWeight: FontWeight.w600,
        //                   ),
        //                 ),
        //                 SizedBox(
        //                   height: 2,
        //                 ),
        //                 Text((requestDetails.requestStartDate.toString() == null ||
        //                     requestDetails.requestStartDate.toString().contains("null"))
        //                     ? "-"
        //                     : requestDetails.requestStartDate.toString()),
        //               ],
        //             )),
        //         // Expanded(
        //         //     child: Align(
        //         //   alignment: Alignment.centerRight,
        //         //   child: IconButton(
        //         //     icon: Icon(
        //         //       Icons.arrow_circle_down,
        //         //       size: 26,
        //         //       color: Colors.black,
        //         //     ),
        //         //     onPressed: () {
        //         //       _currentStep < 5 ? setState(() => _currentStep += 1) : null;
        //         //     },
        //         //   ),
        //         // )),
        //       ]),
        //       content: Column(
        //         children: <Widget>[],
        //       ),
        //       isActive: _currentStep >= 4,
        //       state: _currentStep >= 4 ? StepState.complete : StepState.disabled,
        //     ),
        //     Step(
        //       title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        //         Expanded(
        //             flex: 3,
        //             child: Column(
        //               crossAxisAlignment: CrossAxisAlignment.stretch,
        //               children: [
        //                 Text(
        //                   "Paid",
        //                   style: GoogleFonts.raleway(
        //                     color: Colors.black,
        //                     fontSize: 16,
        //                     fontWeight: FontWeight.w600,
        //                   ),
        //                 ),
        //                 SizedBox(
        //                   height: 2,
        //                 ),
        //                 Text((requestDetails.requestCompletionDate.toString() == null ||
        //                     requestDetails.requestCompletionDate.toString().contains("null"))
        //                     ? "-"
        //                     : requestDetails.requestCompletionDate.toString()),
        //               ],
        //             )),
        //         // Expanded(
        //         //     child: Align(
        //         //   alignment: Alignment.centerRight,
        //         //   child: IconButton(
        //         //     icon: Icon(
        //         //       Icons.arrow_drop_down_circle_sharp,
        //         //       size: 22,
        //         //       color: Colors.black,
        //         //     ),
        //         //     onPressed: () {
        //         //       _currentStep < 6 ? setState(() => _currentStep += 1) : null;
        //         //     },
        //         //   ),
        //         // )),
        //       ]),
        //       content: Column(
        //         children: <Widget>[
        //           Container(
        //             child: showButton == true
        //                 ? Container()
        //                 : ElevatedButton(
        //               style: ElevatedButton.styleFrom(backgroundColor: kPrimaryTheme),
        //               onPressed: () {
        //                 Navigator.push(
        //                     context,
        //                     MaterialPageRoute(
        //                         builder: (context) => ProfessionalPaymentScreen(
        //                           requestId: requestDetails.requestId,
        //                         )));
        //               },
        //               child: Text(
        //                 "Proceed to Professional Fee",
        //                 style: GoogleFonts.raleway(
        //                   color: Colors.white,
        //                   fontWeight: FontWeight.w600,
        //                   fontSize: 16,
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //       isActive: _currentStep >= 5,
        //       state: _currentStep >= 5 ? StepState.complete : StepState.disabled,
        //     ),
        //     Step(
        //   title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        //     Expanded(
        //         flex: 3,
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.stretch,
        //           children: [
        //             Text(
        //               "Rating",
        //               style: GoogleFonts.raleway(
        //                 color: Colors.black,
        //                 fontSize: 16,
        //                 fontWeight: FontWeight.w600,
        //               ),
        //             ),
        //             SizedBox(
        //               height: 2,
        //             ),
        //             Text((requestDetails.requestCompletionDate.toString() == null ||
        //                 requestDetails.requestCompletionDate.toString().contains("null"))
        //                 ? "-"
        //                 : requestDetails.requestCompletionDate.toString()),
        //           ],
        //         )),
        //     // Expanded(
        //     //     child: Align(
        //     //   alignment: Alignment.centerRight,
        //     //   child: IconButton(
        //     //     icon: Icon(
        //     //       Icons.arrow_drop_down_circle_sharp,
        //     //       size: 22,
        //     //       color: Colors.black,
        //     //     ),
        //     //     onPressed: () {
        //     //       _currentStep < 6 ? setState(() => _currentStep += 1) : null;
        //     //     },
        //     //   ),
        //     // )),
        //   ]),
        //   content: Column(
        //     children: <Widget>[
        //       Container(
        //         child: showButton == true
        //             ? Container()
        //             : ElevatedButton(
        //           style: ElevatedButton.styleFrom(backgroundColor: kPrimaryTheme),
        //           onPressed: () {
        //             Navigator.push(
        //                 context,
        //                 MaterialPageRoute(
        //                     builder: (context) => ProfessionalPaymentScreen(
        //                       requestId: requestDetails.requestId,
        //                     )));
        //           },
        //           child: Text(
        //             "Proceed to Professional Fee",
        //             style: GoogleFonts.raleway(
        //               color: Colors.white,
        //               fontWeight: FontWeight.w600,
        //               fontSize: 16,
        //             ),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        //   isActive: _currentStep >= 5,
        //   state: _currentStep >= 5 ? StepState.complete : StepState.disabled,
        // ),
      ];

  Widget controlsBuilder(BuildContext context,
      ControlsDetails controlsDetails) {
    String getText(int stepPosition) {
      switch (stepPosition) {
        case 0:
        // setState(() {
        //   buttonText = "Date Created";
        // });
          return "Date Created";

        case 1:
          return "Matched";
        case 2:
          return "OnRoute";
        case 3:
          return "Job Started";
        case 4:
          return "Job Completed";
        default:
          return "";
      }
    }

    return Align(
      alignment: Alignment.topRight,
      child: SizedBox(
        width: MediaQuery
            .of(context)
            .size
            .width * .30,
        child: Text(""),
        // child: ElevatedButton(
        //   onPressed: controlsDetails.onStepContinue,
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor: kPrimaryTheme,
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(50),
        //     ),
        //   ),
        //   child: Text(
        //     getText(_currentStep),
        //     style: GoogleFonts.lato(
        //       fontSize: 16,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),
      ),
    );
  }

//push um
  void _setMarker() async {
    Set<Marker> newMarker = new Set<Marker>();
    newMarker.add(Marker(
      markerId: MarkerId('source'),
      position: currentLocation!,
      icon: _customSource!,
    ));
    newMarker.add(Marker(
      markerId: MarkerId('destination'),
      position: LatLng(agentLatitude!, agentLongitude!),
      icon: _customDestination!,
    ));
    setState(() {
      _markers = newMarker;
    });
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 3 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}
