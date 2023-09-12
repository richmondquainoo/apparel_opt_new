import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:apparel_options/Model/DeliveryAddressModel.dart';
import 'package:apparel_options/Screens/LandingPage/explore.dart';
import 'package:apparel_options/Utils/paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

import 'package:provider/provider.dart';

import '../../../Constants/myColors.dart';
import '../../Components/ProgressDialog.dart';
import '../../Model/AppData.dart';
import '../../Model/predicted_places.dart';
import '../../Services/NetworkUtility.dart';
import '../../Services/services/api/PlacePredictionTile.dart';
import '../../Services/services/api/PredictedPlaces.dart';
import '../../Services/services/api/api_service.dart';
import '../../Services/services/api/direction.dart';
import '../../Services/services/api/request_assistant.dart';
import '../../Services/services/location_service.dart';
import '../../Utils/Utility.dart';
import '../../config/ApiConfig.dart';


class SearchPlacesScreen extends StatefulWidget {
  const SearchPlacesScreen({Key? key}) : super(key: key);

  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}

class _SearchPlacesScreenState extends State<SearchPlacesScreen>
    with TickerProviderStateMixin {
  _SearchPlacesScreenState();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final StreamController<bool> streamController =
      StreamController<bool>.broadcast();

  customizeStatusAndNavigationBar() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light));
  }

  var descriptionController = TextEditingController();
  var additionalController = TextEditingController();
  TextEditingController timeinput = TextEditingController();
  TextEditingController _originController = TextEditingController();
  String? description;
  String? additionalNote;
  String? modeOfDelivery;
  String? showDateTime;
  String? showLocation;
  String? deliveryTime;
  bool? editDescription = true;
  bool? editAdditionalNote = true;
  bool? showAddingPhoto = true;
  bool? showAddVoiceNote = true;
  bool? showVehicles = true;
  bool? showServices = true;
  bool? showDelivery = true;
  bool? showSearch = true;
  String? showDescription;
  String? serviceLocation;
  String? confirmedLocation;
  String address = "";
  String? selectedDate;
  String? newSelectedValue;
  String? loc;
  String? locationName;
  double? currentLongitude;
  double? currentLatitude;
  String? myAddress;
  String? _currentAddress = '';
  String? _startAddress = '';
  String? requestIdFromResponse;
  List? newAgents = [];
  var accuracy = '';
  LocationService? locationService;
  geo.Position? position;
  String? long = "", lat = "";
  StreamSubscription<geo.Position>? positionStream;
  geo.Position? currentPosition;
  String? selectedCategory;
  String? path;
  int id5 = 0;
  int id6 = 0;
  int _toggleValue = 0;
  final List<Marker> _marker = <Marker>[];
  String header = "";
  bool search = false;
  var coordinates;
  bool isAutoCompleteLoading = false;
  final Completer<GoogleMapController> mapController = Completer();
  TextEditingController locationController = TextEditingController();
  List<PredictedPlaces?> placesPredictedList = [];
  var textController = TextEditingController();


  void onCameraMove(CameraPosition position) async {
    setState(() {
      search = false;
    });
    initialPosition = position.target;
  }

  LatLng? initialPosition;
  late String? imageFile;
  String? carNumberToSend;
  int? kilometres = 100;

  @override
  void initState() {
     initLocation();
    _toggleValue = 0;
    showDateTime = "As soon as possible";
    _controller = AnimationController(vsync: this, duration: _duration);
    customizeStatusAndNavigationBar();
    locationService=LocationService();
    locationService!
        .getCurrentLocation()
        .then((position) => _updatePosition(position, context));
    super.initState();
  }

  AnimationController? _controller;
  GoogleMapController? newGoogleMapController;
  Duration? _duration = Duration(milliseconds: 500);
  Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));

  void initLocation() async {
    await getUserLocation();
    await getLocation();
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    long = position!.longitude.toString();
    lat = position!.latitude.toString();

    setState(() async {
      currentPosition = position;
      Provider.of<AppData>(context, listen: false)
          .updateActualCoordinates(currentPosition!);
      print('CURRENT POS: $currentPosition');
      //refresh UI

      await _getAddress();
    });
  }

  _getAddress() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          currentPosition!.latitude, currentPosition!.longitude);
      Placemark place = p[0];
      setState(() {
        _currentAddress =
            "${place.name},${place.street},${place.subLocality}, ${place.locality},${place.subAdministrativeArea}";
        _originController.text = _currentAddress!;
        _startAddress = _currentAddress;
        print("THE ADDRESS: ${_startAddress}");
        Provider.of<AppData>(context, listen: false)
            .updateActualLocation(_startAddress!);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> getUserLocation() async {
    var position = await geo.GeolocatorPlatform.instance.getCurrentPosition(
        locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.bestForNavigation));

    setState(() {
      initialPosition = LatLng(position.latitude, position.longitude);
    });
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(
      CameraUpdate.newLatLng(initialPosition!),
    );
    print("This initialPosition: $initialPosition");
  }

  // void getUserLocation() async {
  //   var position = await GeolocatorPlatform.instance.getCurrentPosition(
  //       locationSettings: const LocationSettings(
  //           accuracy: LocationAccuracy.bestForNavigation));
  //
  //   setState(() {
  //     initialPosition = LatLng(position.latitude, position.longitude);
  //   });
  //
  //   final GoogleMapController controller = await mapController.future;
  //   controller.animateCamera(
  //     CameraUpdate.newLatLng(initialPosition!),
  //   );
  //
  //   print("This is the location $initialPosition");
  // }

  void onCreated(GoogleMapController controller) {
    setState(() {
      mapController.complete(controller);
    });
  }

  void getMoveCamera() async {
    List<Placemark> placemark = await placemarkFromCoordinates(
        initialPosition!.latitude, initialPosition!.longitude);
    locationController.text =
        "${placemark[0].street},${placemark[0].subAdministrativeArea}";
    placemark[0].street!;
    var latitude = Provider.of<AppData>(context, listen: false)
        .updateLatitude(initialPosition!.latitude);
    var longitude = Provider.of<AppData>(context, listen: false)
        .updateLongitude(initialPosition!.longitude);
    coordinates = LatLng(initialPosition!.latitude, initialPosition!.longitude);

    setState(() {
      header = locationController.text;
      var actualLocation = Provider.of<AppData>(context, listen: false)
          .updateActualLocationName(header);
      print(
          "THE ACTUAL LOCATION:${Provider.of<AppData>(context, listen: false).locationName}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      persistentFooterButtons: [
        Column(
          children: [
            Container(
              // height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Select delivery location',
                          style: GoogleFonts.raleway(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Expanded(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Align(
                                            alignment: Alignment.topLeft,
                                            child: Icon(
                                              Icons.location_pin,
                                              size: 35,
                                              color: Colors.black,
                                            )),
                                        SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            Provider.of<AppData>(context,
                                                            listen: false)
                                                        .locationName ==
                                                    null
                                                ? "loading..."
                                                : Provider.of<AppData>(context,
                                                        listen: false)
                                                    .locationName!,
                                            maxLines: 10,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.raleway(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "Location for package delivery",
                                              style: GoogleFonts.raleway(
                                                  fontSize: 12,
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black54),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            showSearch = !showSearch!;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.black,
                                            size: 25,
                                          ),
                                        )),
                                  ],
                                ),
                                Divider(
                                  color: Colors.black87,
                                  thickness: 0.1,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
              child: MaterialButton(
                onPressed: () {
                  confirmedLocation = Provider.of<AppData>(context, listen: false)
                          .locationName
                          .toString();
                  print("THE TAPPED LOCATION: ${confirmedLocation}");

                  Provider.of<AppData>(context, listen: false)
                      .updateConfirmedLocationName(
                          confirmedLocation.toString());

                  // var draggedPosition =
                  // geo.Position(
                  //     latitude: cameraPosition.target.latitude,
                  //     longitude: cameraPosition.target.longitude);
                  //
                  // print(
                  //     "The dragged Position: ${draggedPosition}");
                  // Provider.of<AppData>(context,
                  //     listen: false)
                  //     .updateActualCoordinates(
                  //     draggedPosition);

                  Provider.of<AppData>(context, listen: false)
                      .updateConfirmedLocation(
                          Provider.of<AppData>(context, listen: false)
                              .confirmedLocation
                              .toString());
                  print("The dragged new location from provider: ${Provider.of<AppData>(context, listen: false).locationName}");
                  DeliveryAddressModel deliveryModel = new DeliveryAddressModel(
                      email: "richie@gmail.com",
                      address: "accra- newtown",
                      latitude: 4.564,
                      longitude: -0.4564,
                      country: "Ghana",
                      region: "Accra",
                      postCode: "0233",
                      dateCreated: '',
                      lastEdited: ""
                  );
                  setDeliveryAddress(deliveryModel);
                },
                height: 50,
                elevation: 0,
                splashColor: Colors.amber[700],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.black,
                child: Center(
                  child: Text(
                    "DONE",
                    style: GoogleFonts.raleway(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 8.0, right: 8),
        //   child: GestureDetector(
        //     onTap: () async {
        //
        //     },
        //     child: Container(
        //       height: 56,
        //       decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(10),
        //           color: kPrimaryTheme,
        //           boxShadow: const [
        //             BoxShadow(
        //               color: Colors.black12,
        //               blurRadius: 1,
        //               spreadRadius: 2,
        //               offset: Offset(1, 1.3),
        //             ),
        //           ]),
        //       child: Padding(
        //         padding: const EdgeInsets.only(left: 0.0),
        //       ),
        //     ),
        //   ),
        // ),
      ],
      body: SizedBox.expand(
        child: Stack(
          children: <Widget>[
            initialPosition == null
                ? const Center(child: Text("Please check your network"))
            :GoogleMap(
              mapType: MapType.normal,
              zoomControlsEnabled: false,
              initialCameraPosition:
                  CameraPosition(target: initialPosition!, zoom: 18),
              myLocationButtonEnabled: false,
              markers: Set<Marker>.of(_marker),
              myLocationEnabled: true,
              onCameraMove: onCameraMove,
              onMapCreated: (GoogleMapController controller) {
                mapController.complete(controller);

                newGoogleMapController = controller;

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
              onCameraIdle: () async {
                search = true;
                setState(() {
                  getMoveCamera();
                });
              },
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                  height: 43,
                  child: Image.asset("assets/images/placeholder.png")),
            ),


            search == true
                ? Positioned(
                    top: MediaQuery.of(context).size.height / 2.90,
                    left: MediaQuery.of(context).size.width / 3.62,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        // color: Colors.black.withOpacity(0.75),
                      ),
                      width: 195,
                      height: 40,
                      child: const Center(child: Text("")),
                    ),
                  )
                : Positioned(
                    top: MediaQuery.of(context).size.height / 3.00,
                    left: MediaQuery.of(context).size.width / 2.3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 17, vertical: 12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.black.withOpacity(0.75)),
                      width: 50,
                      height: 40,
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                          strokeWidth: 2.5,
                        ),
                      ),
                    ),
                  ),
            Positioned(
              top: 29,
              left: 0,
              right: 16,
              child: Container(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 3.0, right: 6),
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 25,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ),
              ),
            ),
            Container(
                child: showSearch! == false
                    ? Positioned(
                        top: 35,
                        left: 54,
                        right: 16,
                        child: Container(
                          height: 600,
                          width: double.maxFinite,
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Column(
                            children: [
                              Flexible(
                                  child: TextFormField(
                                showCursor: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                      color: kPrimaryTheme,
                                      width: 1.0,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(70),
                                    borderSide: BorderSide(
                                      color: kPrimaryTheme,
                                      width: 1.5,
                                    ),
                                  ),
                                  hintText: 'Enter location...',
                                  hintStyle: GoogleFonts.raleway(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54),
                                  suffixIcon: locationController.text.length > 3
                                      ? IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () {
                                            locationController.clear();
                                            setState(() {});
                                          },
                                        )
                                      : const Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Icon(Icons.search)),
                                ),
                                controller: locationController,
                                style: GoogleFonts.raleway(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                onChanged: ((valueTyped) {
                                  if (valueTyped.length > 2) {
                                    findPlaceAutoCompleteSearch(valueTyped);
                                    var actualLocation = Provider.of<AppData>(
                                            context,
                                            listen: false)
                                        .updateActualLocationName(
                                            locationController.text);
                                    print(
                                        "THE ACTUAL LOCATION:${Provider.of<AppData>(context, listen: false).locationName}");
                                  }
                                }),
                              )),
                              SizedBox(height: 4),
                              Expanded(
                                child: isAutoCompleteLoading == false &&
                                        placesPredictedList.isNotEmpty &&
                                        locationController.text.isNotEmpty
                                    ? Container(
                                        width: double.maxFinite,
                                        color: Colors.black,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: ListView.separated(
                                          itemCount: placesPredictedList.length,
                                          physics: ClampingScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return PlacePredictionTileDesign(
                                              onPressed: () {
                                                getPlaceDirectionDetails(
                                                        placesPredictedList[
                                                                index]
                                                            !.place_id,
                                                        context)
                                                    .then((_) {
                                                  placesPredictedList.clear();
                                                  setState(() {});
                                                  var result =
                                                      Provider.of<AppData>(
                                                              context,
                                                              listen: false)
                                                          .updatedLocation;
                                                  print(result);
                                                  if (result != null) {
                                                    print('im here');
                                                    goToPlace(
                                                        result
                                                            .locationLatitude!,
                                                        result
                                                            .locationLongitude!);
                                                  }
                                                });
                                              },
                                              predictedPlaces: placesPredictedList[index]
                                            );
                                          },
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return const Divider(
                                              height: 1,
                                              color: Colors.white,
                                              thickness: 1,
                                            );
                                          },
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              )
                            ],
                          ),
                        ),
                      )
                    : Container()),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(bottom: 18, right: 8),
                child: GestureDetector(
                  onTap: () {
                    getUserLocation();
                  },
                  child: const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.my_location,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            // DraggableScrollableSheet(
            //     maxChildSize: 0.36,
            //     initialChildSize: 0.20,
            //     minChildSize: 0.05,
            //     builder: (context, scrollController) =>
            //         StatefulBuilder(builder: (context, setState) {
            //           return SingleChildScrollView(
            //             child:
            //           );
            //         })),

            // DraggableScrollableSheet(
            //   initialChildSize: 0.1,
            //   minChildSize: 0.0,
            //   maxChildSize: 0.6,
            //   builder:
            //       (BuildContext context, ScrollController scrollController) {
            //     return Container(
            //       decoration: BoxDecoration(
            //           color: Colors.white,
            //           borderRadius: BorderRadius.only(
            //               topLeft: Radius.circular(50),
            //               topRight: Radius.circular(50))),
            //       child: ListView.builder(
            //         controller: scrollController,
            //         itemCount: 1,
            //         itemBuilder: (BuildContext context, int index) {
            //           return Column(
            //             mainAxisAlignment: MainAxisAlignment.start,
            //             children: [
            //               Align(
            //                 alignment: Alignment.topCenter,
            //                 child: Container(
            //                   height: 5.0,
            //                   width: 44.0,
            //                   decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10.0)),
            //                 ),
            //               ),
            //               Padding(
            //                 padding: const EdgeInsets.all(10.0),
            //                 child: Column(
            //                   children: [
            //                     SizedBox(
            //                       height: 10,
            //                     ),
            //                     Row(
            //                       mainAxisAlignment:
            //                       MainAxisAlignment.spaceBetween,
            //                       children: [
            //                         Row(
            //                           children: [
            //                             Align(
            //                                 alignment: Alignment.topLeft,
            //                                 child: Icon(
            //                                   Icons.location_pin,
            //                                   size: 35,
            //                                   color: Colors.black,
            //                                 )),
            //                             SizedBox(
            //                               width: 15,
            //                             ),
            //                             Column(
            //                               crossAxisAlignment:
            //                               CrossAxisAlignment.start,
            //                               children: [
            //                                 Text(
            //                                   Provider.of<AppData>(context,
            //                                       listen: false)
            //                                       .locationName ==
            //                                       null
            //                                       ? "loading..."
            //                                       : Provider.of<AppData>(
            //                                       context,
            //                                       listen: false)
            //                                       .locationName!,
            //                                   maxLines: 7,
            //                                   overflow: TextOverflow.ellipsis,
            //                                   style: GoogleFonts.raleway(
            //                                     fontSize: 14,
            //                                     fontWeight: FontWeight.w600,
            //                                     color: Colors.black,
            //                                   ),
            //                                 ),
            //                                 SizedBox(
            //                                   height: 6,
            //                                 ),
            //                                 Align(
            //                                   alignment: Alignment.topLeft,
            //                                   child: Text(
            //                                     "Location for service delivery",
            //                                     style: GoogleFonts.raleway(
            //                                         fontSize: 12,
            //                                         letterSpacing: 0,
            //                                         fontWeight: FontWeight.w600,
            //                                         color: Colors.black54),
            //                                   ),
            //                                 ),
            //                               ],
            //                             ),
            //                           ],
            //                         ),
            //                         GestureDetector(
            //                             onTap: () {
            //                               setState(() {
            //                                 showSearch = !showSearch!;
            //                               });
            //                             },
            //                             child: Icon(
            //                               Icons.edit,
            //                               color: Colors.blueAccent,
            //                               size: 20,
            //                             )),
            //                       ],
            //                     ),
            //                     Divider(
            //                       color: Colors.black87,
            //                       thickness: 0.1,
            //                     ),
            //                   ],
            //                 ),
            //               )
            //             ],
            //           );
            //         },
            //       ),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Future<void> _updatePosition(geo.Position position, BuildContext context) async {
    List pm = await locationService!.getPlacemarkFromCoord(
      currentLatitude = position.latitude,
      currentLongitude = position.longitude,
    );

    setState(() {
      print("currentLatitude: $currentLatitude");

      address = '${pm[0]}';
      print(address);
      initialPosition = LatLng(position.latitude, position.longitude);
    });
    context
        .read<ApiService>()
        .convertCoordToPlace(
      lat: position.latitude,
      long: position.longitude,
    )
        .then((value) {
      print('long name: ${value['address_components'][1]['long_name']}');

      setState(() {
        loc = '${value['address_components'][1]['long_name']}';
        myAddress = loc;
      });
    }).catchError((err) {
      print("error occurred $err");
    });
  }

  void setDeliveryAddress(DeliveryAddressModel deliveryAddressModel) async {
    try {
      showDialog(
        context: context,
        builder: (context) {
          return ProgressDialog(displayMessage: 'Updating location...');
        },
      );

      var jsonBody = jsonEncode(deliveryAddressModel);
      NetworkUtility networkUtility = NetworkUtility();
      Response? response = await networkUtility.postDataWithAuth(
          url: SET_DELIVERY_ADDRESS, body: jsonBody, auth: 'Bearer $ACCESS_TOKEN');
      print("THE URL : $SET_DELIVERY_ADDRESS");
      print("THE request body : $jsonBody");

      print('update response: ${response!.body}');

      Navigator.of(context, rootNavigator: true).pop();
      if (response == null) {
        Navigator.pop(context);
        //error handling
        new UtilityService().showMessage(
          context: context,
          message: 'An error has occurred. Please try again',
          icon: Icon(
            Icons.error_outline,
            color: Colors.red,
          ),
        );
      } else {
        var data = jsonDecode(response.body);

        int status = data['status'];
        debugPrint("The statusCode: ${status}");
        debugPrint("=============================");
        String message = data['message'];

        if (status == 201) {
          new UtilityService().showMessage(
            context: context,
            message: 'Delivery location updated successfully',
            icon: Icon(
              Icons.check_circle,
              color: Colors.lightGreenAccent,
            ),
          );
          setState(() {
            confirmedLocation = Provider.of<AppData>(context, listen: false)
                .locationName
                .toString();
            print("THE TAPPED LOCATION: ${confirmedLocation}");

            Provider.of<AppData>(context, listen: false)
                .updateConfirmedLocationName(
                confirmedLocation.toString());
          });
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ExplorePage()));
        } else {
          Navigator.pop(context);
          new UtilityService().showMessage(
            context: context,
            message: data['message'],
            icon: Icon(
              Icons.error_outline,
              color: Colors.red,
            ),
          );
        }
      }
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      new UtilityService().showMessage(
        context: context,
        message: "An error occurred while updating location",
        icon: Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
      );
      print('server location update error: $e');
    }
  }

  void findPlaceAutoCompleteSearch(String inputText) async {
    setState(() {
      isAutoCompleteLoading = true;
    });
    if (inputText.length > 1) //2 or more than 2 input characters
    {
      String urlAutoCompleteSearch =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=${ApiConfig.googleApiKey}&components=country:gh";

      var responseAutoCompleteSearch =
          await RequestAssistant.receiveRequest(urlAutoCompleteSearch);
      print(responseAutoCompleteSearch);
      if (responseAutoCompleteSearch ==
          "Error Occurred, Failed. No Response.") {
        return;
      }

      if (responseAutoCompleteSearch["status"] == "OK") {
        var placePredictions = responseAutoCompleteSearch["predictions"];

        var placePredictionsList = (placePredictions as List)
            .map((jsonData) => PredictedPlaces.fromJson(jsonData))
            .toList();

        setState(() {
          isAutoCompleteLoading = false;
          placesPredictedList = placePredictionsList;
          print(placesPredictedList);
        });
      }
    }
  }

  Future<void> getPlaceDirectionDetails(String? placeId, context) async {
    String placeDirectionDetailsUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${ApiConfig.googleApiKey}";

    var responseApi =
        await RequestAssistant.receiveRequest(placeDirectionDetailsUrl);

    print("this $responseApi");

    if (responseApi == "Error Occurred, Failed. No Response.") {
      return;
    }

    if (responseApi["status"] == "OK") {
      Directions directions = Directions();
      directions.locationName = responseApi["result"]["name"];
      directions.locationId = placeId;
      directions.locationLatitude =
          responseApi["result"]["geometry"]["location"]["lat"];
      directions.locationLongitude =
          responseApi["result"]["geometry"]["location"]["lng"];

      print(directions.locationLatitude);

      Provider.of<AppData>(context, listen: false)
          .updatedLocationAddress(directions);
    }
  }

  Future<Uint8List?> loadNetworkImage(String path) async {
    final completer = Completer<ImageInfo>();
    var image = NetworkImage(path);
    image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener((info, _) => completer.complete(info)));
    final imageInfo = await completer.future;
    final byteData = await imageInfo.image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return byteData?.buffer.asUint8List();
  }

  Future<void> goToPlace(double lat, double lng) async {
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
          lat,
          lng,
        ),
        zoom: 18)));
  }
}
