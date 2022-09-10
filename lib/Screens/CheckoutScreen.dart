import 'dart:async';
import 'dart:convert';

import 'package:apparel_options/Database/DeliveryCostDB.dart';
import 'package:apparel_options/Model/NewOrderModel.dart';
import 'package:apparel_options/Screens/LandingPage/SuccessScreen.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../Components/ProgressDialog.dart';
import '../Constants/constantColors.dart';
import '../Database/ConfigDB.dart';
import '../Database/UserDB.dart';
import '../Model/AppData.dart';
import '../Model/CheckOutModel.dart';
import '../Model/Config.dart';
import '../Model/DeliveryCost.dart';
import '../Model/FullCartModel.dart';
import '../Model/OrderModel.dart';
import '../Model/ProductModel.dart';
import '../Model/Questions.dart';
import '../Model/UserProfileModel.dart';
import '../Services/NetworkUtility.dart';
import '../Utils/Utility.dart';
import '../Utils/paths.dart';
import '../animation/FadeAnimation.dart';
import 'CartScreen.dart';
import 'LandingPage/MapScreen.dart';
import 'LandingPage/PaymentScreen.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({Key key}) : super(key: key);

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen>
    with TickerProviderStateMixin {

  DeliveryCostDB deliveryCostDB = DeliveryCostDB();
  UserDB userDB = UserDB();
  ConfigDB configDB = ConfigDB();
  UserProfileModel userModel = UserProfileModel();
  UserProfileModel user = UserProfileModel();

  int selectedPayMethod = 0;
  String locationName;
  double itemCost = 0;
  double deliveryCharge = 0;
  double subTotal = 0;
  double serviceCharge = 0;
  double overallTotal = 0;

  var additionalController = TextEditingController();
  var allergyController = TextEditingController();
  TextEditingController _originController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  String additionalNote;
  String allergyNote;
  String _currentAddress = '';
  String _startAddress = '';

  Set<Marker> markersList = Set<Marker>();
  int currentStep = 0;
  String modeOfDelivery;
  String deliveryOptions;
  String modeOfPayment;
  Config configs;
  bool serviceEnabled;
  DeliveryCost deliveryCost;
  Position currentPosition;

  bool servicestatus = false;
  bool haspermission = false;
  LocationPermission permission;
  Position position;
  String long = "", lat = "";
  StreamSubscription<Position> positionStream;

  int id5 = 0;
  int id6 = 0;
  int id7 = 0;

  List<Questions> deliveryMode = [
    Questions(
      index: 1,
      question: "Pick Up",
    ),
    Questions(
      index: 2,
      question: "Delivery",
    ),
  ];



  List<Questions> paymentMethod = [
    Questions(
      index: 1,
      question: "Cash",
    ),
    Questions(
      index: 2,
      question: "Electronic",
    ),
  ];


  List<Step> getSteps() => [
    Step(
      state: currentStep > 0 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 0,
      title: const Text("Order Summary"),
      content: Container(
        width: MediaQuery.of(context).size.width,
        // color: Colors.red,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 14.0, left: 14, right: 14, bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Item",
                        style: GoogleFonts.raleway(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Qty",
                        style: GoogleFonts.raleway(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Price(GHS)",
                        style: GoogleFonts.raleway(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.orangeAccent,
                  thickness: 0.2,
                ),
                SizedBox(
                  height: 6,
                ),
                FutureBuilder(
                    future: Provider.of<AppData>(context, listen: false)
                        .getCartItems(),
                    builder: (context,
                        AsyncSnapshot<List<ProductModel>> snapshot) {
                      if (snapshot.data != null) {
                        return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 13.0, right: 8, bottom: 14),
                                child: GestureDetector(
                                  onTap: () {
                                    // fetchProductDetails(context, pizza.category);
                                    debugPrint(
                                        "pizzaType: ${snapshot.data[index].productCategory}");
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 3.0, right: 3),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            "${snapshot.data[index].productName}",
                                            style: GoogleFonts.raleway(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "${snapshot.data[index].quantity}",
                                            style: GoogleFonts.raleway(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              "${snapshot.data[index].total.toStringAsFixed(2)}",
                                              style: GoogleFonts.lato(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      } else {
                        return Text("List is empty");
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    ),
    Step(
      state: currentStep > 1 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 1,
      title: const Text("Delivery Option"),
      content: Card(
        color: Colors.white,
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                const EdgeInsets.only(left: 10.0, right: 12, top: 6),
                child: Row(
                  children: [
                    Container(
                      child:
                      Icon(Icons.home, size: 27, color: Colors.black),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Address",
                            style: GoogleFonts.raleway(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              letterSpacing: .8,
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            // _startAddress != null ? _startAddress : "-",
                            Provider.of<AppData>(context, listen: false)
                                .locationName !=
                                null
                                ? Provider.of<AppData>(context,
                                listen: false)
                                .locationName
                                : "My Location",
                            style: GoogleFonts.raleway(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, top: 10),
                child: GestureDetector(
                  onTap: () {
                    if (currentPosition == null) {
                      new UtilityService().showMessage(
                        context: context,
                        message:
                        "Please allow location permission on your device",
                        icon: Icon(
                          Icons.error_outline,
                          color: Colors.red,
                        ),
                      );
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchPlacesScreen(
                                positionLocation: currentPosition,
                              )));
                    }
                  },
                  child: Row(
                    children: [
                      Container(
                        child:
                        Icon(Icons.edit, size: 16, color: Colors.teal),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        "Edit Location",
                        style: GoogleFonts.raleway(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.teal,
                          letterSpacing: .75,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: Divider(
                  color: Colors.black54,
                  thickness: 0.2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Container(
                  child: Column(
                    children: deliveryMode
                        .map((data) => Container(
                      height: 35,
                      child: RadioListTile(
                        activeColor: Colors.teal,
                        title: Text(
                          "${data.question}",
                          style: GoogleFonts.raleway(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54),
                        ),
                        groupValue: id6,
                        value: data.index,
                        onChanged: (val) async {
                          setState(() async {
                            modeOfDelivery = data.question;
                            id6 = data.index;
                            print(
                                "Delivery option: $modeOfDelivery");
                            if (modeOfDelivery == "Delivery") {
                              double startLat = configs.latitude;
                              double startLon = configs.longitude;
                              double endLat = Provider.of<AppData>(
                                  context,
                                  listen: false)
                                  .searchPosition
                                  .latitude;
                              double endLon = Provider.of<AppData>(
                                  context,
                                  listen: false)
                                  .searchPosition
                                  .longitude;
                              double distanceInKilometers =
                              await computeDistance(
                                startLat: startLat,
                                startLon: startLon,
                                endLat: endLat,
                                endLon: endLon,
                              );
                              findDeliveryCost("HQ",
                                  distanceInKilometers);

                              print(
                                  'computed distance: $distanceInKilometers');
                              findDeliveryCost("HQ",
                                  distanceInKilometers);
                            } else {
                              setState(() {
                                deliveryCost = null;
                                deliveryCharge = 0;
                                computeCosts();
                              });
                            }
                          });
                        },
                      ),
                    ))
                        .toList(),
                  ),
                ),
              ),
              Container(
                child: modeOfDelivery != null &&
                    modeOfDelivery.contains("Delivery")
                    ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, right: 12, top: 12),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Delivery Time",
                            style: GoogleFonts.raleway(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              letterSpacing: .75,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, right: 12, top: 10),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                "Please note that delivery time could be impacted by external factors",
                                style: GoogleFonts.raleway(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.redAccent.shade100,
                                  letterSpacing: .75,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                )
                    : Container(),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    ),
    Step(
      state: currentStep > 2 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 2,
      title: const Text("Additional Information"),
      content: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 12.0, right: 12, top: 10, bottom: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Additional Note",
                    style: GoogleFonts.raleway(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      letterSpacing: .75,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 100,
              margin: EdgeInsets.all(0),
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 12),
              decoration: const BoxDecoration(
                // color: Colors.teal,
                borderRadius: BorderRadius.all(
                    Radius.circular(7.0)), // set rounded corner radius
              ),
              child: Center(
                child: TextField(
                  keyboardType: TextInputType.text,
                  maxLines: 200,
                  obscureText: false,
                  style: GoogleFonts.raleway(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w300),
                  controller: additionalController,
                  onChanged: (value) {
                    additionalNote = value;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(
                          color: Colors.black54, width: 0.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      borderSide:
                      BorderSide(color: Colors.black54, width: 0.5),
                    ),
                    hintText: "",
                    labelStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    Step(
      state: currentStep > 3 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 3,
      title: const Text("Bill Summary"),
      content: Container(
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 14.0, left: 14, right: 14, bottom: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Summary",
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Colors.black),
                        ),
                        Container(
                          child: Text("GHS",
                              style: GoogleFonts.raleway(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: Colors.black)),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Item Cost:",
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              color: Colors.black),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          Provider.of<AppData>(context, listen: false)
                              .getCartTotal()
                              .toStringAsFixed(2),
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Delivery Charge:",
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              color: Colors.black),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          (deliveryCharge != null)
                              ? deliveryCharge.toStringAsFixed(2)
                              : "0.00",
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Service Charge:",
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              color: Colors.black),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          (serviceCharge != null)
                              ? serviceCharge.toStringAsFixed(2)
                              : "0.00",
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 0.2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Cost(GHS) :",
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Colors.black),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          overallTotal.toStringAsFixed(2),
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    Step(
      state: currentStep > 4 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 4,
      title: const Text("Payment Mode"),
      content: Container(
        child: Column(
          children: [
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Container(
                  child: Column(
                    children: paymentMethod
                        .map((data) => Container(
                      height: 35,
                      child: RadioListTile(
                        activeColor: Colors.teal,
                        title: Text(
                          "${data.question}",
                          style: GoogleFonts.raleway(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54),
                        ),
                        groupValue: id7,
                        value: data.index,
                        onChanged: (val) {
                          setState(() {
                            modeOfPayment = data.question;
                            id7 = data.index;
                            print(
                                "Delivery option: $modeOfPayment");
                            if (modeOfPayment == "Mobile Money") {}
                          });
                        },
                      ),
                    )
                    )
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ];

  Future<double> computeDistance({
    double startLat,
    double startLon,
    double endLat,
    double endLon,
  }) async {
    double distanceInMeters = await Geolocator
        .distanceBetween(startLat, startLon, endLat, endLon);
    double distanceInKilometers = distanceInMeters / 1000;
    return distanceInKilometers;
  }

  void findDeliveryCost(String branch, double distance) async {
    // DeliveryCost del = await deliveryCostDB.getDeliveryCostByBranchAndDistance(
    //     branch, distance);

    List<DeliveryCost> list = await deliveryCostDB.getDeliveryCost();
    bool found = false;
    if (list.isNotEmpty) {
      for (DeliveryCost del in list) {
        if (del.branch == branch &&
            (distance >= del.minDistance && distance <= del.maxDistance)) {
          print('distance found: $del');
          found = true;
          setState(() {
            deliveryCost = del;
            deliveryCharge = deliveryCost.cost;
            debugPrint("The delivery Charge: ${deliveryCharge}");
            computeCosts();
          });
        }
      }
    }
    if (!found) {
      setState(() {
        deliveryCharge = 0;
        computeCosts();
      });
    }

    print('selected delivery cost is: ${deliveryCharge}');
  }

  void computeCosts() {
    setState(() {
      itemCost = Provider.of<AppData>(context, listen: false).getCartTotal();
      subTotal = itemCost + deliveryCharge;
      serviceCharge = configs.serviceCharge * subTotal;
      overallTotal = subTotal + serviceCharge;
    });
    print("item cost: $itemCost");
    print("delivery cost: $deliveryCharge");
    print("sub cost: $subTotal");
    print("service charge: $serviceCharge");
    print("overall cost: $overallTotal");
  }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if(servicestatus){
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        }else if(permission == LocationPermission.deniedForever){
          print("'Location permissions are permanently denied");
        }else{
          haspermission = true;
        }
      }else{
        haspermission = true;
      }

      if(haspermission){
        setState(() {
          //refresh the UI
        });

        getLocation();
      }
    }else{
      print("GPS Service is not enabled, turn on GPS location");
    }

    setState(() {
      //refresh the UI
    });
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print("The Longitude: ${position.longitude}"); //Output: 80.24599079
    print("The Longitude: ${position.latitude}");
    print("Coordinates : $position");//Output: 29.6593457

    long = position.longitude.toString();
    lat = position.latitude.toString();

    setState(() {

      currentPosition = position;
      Provider.of<AppData>(context, listen: false)
          .updateActualCoordinates(currentPosition);
      print('CURRENT POS: $currentPosition');
      //refresh UI
    });
    await _getAddress();

    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    StreamSubscription<Position> positionStream = Geolocator.getPositionStream(
        locationSettings: locationSettings).listen((Position position) {
      print(position.longitude); //Output: 80.24599079
      print(position.latitude); //Output: 29.6593457

      long = position.longitude.toString();
      lat = position.latitude.toString();

      setState(() {
        //refresh UI on update
      });
    });
  }


  _getAddress() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress = "${place.name}, ${place.locality}";
        _originController.text = _currentAddress;
        _startAddress = _currentAddress;
        print("THE ADDRESS: ${_startAddress}");
        Provider.of<AppData>(context, listen: false)
            .updateActualLocation(_startAddress);
      });
    } catch (e) {
      print(e);
    }
  }

  void _setMarker(LatLng point) {
    setState(() {
      markersList.clear();
      markersList.add(Marker(
        markerId: MarkerId('maker'),
        position: LatLng(currentPosition.latitude, currentPosition.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));
    });
  }

  // _getCurrentLocation() async {
  //   await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
  //       .then((Position position) async {
  //     await Geolocator.checkPermission();
  //     await Geolocator.requestPermission();
  //
  //     final GoogleMapController mapController = await _controller.future;
  //     setState(() {
  //       currentPosition = position;
  //       print('CURRENT POS: ${currentPosition}');
  //       _setMarker(
  //           LatLng(currentPosition.latitude, currentPosition.longitude));
  //     });
  //     await _getAddress();
  //   }).catchError((e) {
  //     print(e);
  //   });
  // }



  @override
  void initState() {
    getLocation();
    print("The dragged new location from provider: ${Provider.of<AppData>(context, listen: false).locationName}");
    super.initState();
    // loadUserFromLocalStorage();
    initDB();


  }

  void initDB() async {
    await userDB.initialize();
    await configDB.initialize();
    await deliveryCostDB.initialize();


    List<UserProfileModel> list = await userDB.getAllUsers();
    if (list.isNotEmpty) {
      setState(() {
        user = list.first;
        debugPrint('User Info: $user');
      });
    }

    Config conf = await configDB.getConfigsByBranch("HQ");
    setState(() {
      configs = conf;
    });

    List<DeliveryCost> costList = await deliveryCostDB.getDeliveryCost();
    print('costList: $costList');

    DeliveryCost cost =
    await deliveryCostDB.getDeliveryCostByBranch("HQ");
    setState(() {
      deliveryCost = cost;
    });

    print("delivery cost: $deliveryCost");
    print("service cost: $configs");

    computeCosts();
  }


  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<AppData>(context);
    return Scaffold(
      persistentFooterButtons: [
        Consumer<AppData>(builder: (context, value, child) {
          return Visibility(
            child: Column(
              children: [
                ReusableWidget(
                  title: 'Total',
                  value: r'GHS ' + overallTotal.toStringAsFixed(2),
                ),
                FadeAnimation(
                    0,
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: MaterialButton(
                        onPressed: () async {
                          if (modeOfDelivery == null) {
                            UtilityService().showMessage(
                              message: 'Please specify delivery option',
                              context: context,
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.redAccent,
                              ),
                            );
                            setState(() {
                              currentStep = 1;
                            });
                          } else if (modeOfPayment == null) {
                            UtilityService().showMessage(
                              message: 'Please specify payment mode',
                              context: context,
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.redAccent,
                              ),
                            );
                            setState(() {
                              currentStep = 4;
                            });
                          } else {
                            final provider = Provider.of<AppData>(context, listen: false);

                            NewOrderModel newOrderModel = NewOrderModel(
                              channel: "MobileApp",
                              deliveryOption: modeOfDelivery.toString(),
                              orderAdditionalInfo: additionalController.text.toString(),
                              orderAddress: _startAddress.toString(),
                              orderBranch: "HQ",
                              orderBy: user.name.toString(),
                              orderEmail: user.email.toString(),
                              orderPhone: user.phone.toString(),
                              organizationName: "Apparel",
                              organizationCode: "Apparel",
                              paymentAmount: double.parse(overallTotal.toString()),
                              paymentMode: modeOfPayment,
                              orderTotalAmount: double.parse(overallTotal.toString()),
                              orderLat: double.parse(provider.searchPosition.latitude.toString()),
                              orderLon: double.parse(provider.searchPosition.longitude.toString()),
                              orderQuantity: int.parse(provider.getCartCount().toString()),
                              products: provider.cartItemNew,
                              orderTakenBy: "Admin",
                              orderDetail: "",
                              orderItemCost: double.parse(provider.getCartTotal().toString()),

                            );

                            new UtilityService().confirmationBox(
                                title: 'Confirmation',
                                message: 'Are you sure you want to checkout?',
                                context: context,
                                yesButtonColor: Colors.amber,
                                noButtonColor: Colors.teal,
                                // color: Colors.blueAccent,
                                onYes: () {
                                  debugPrint("PRODUCT FOR POSTING ********: ${newOrderModel.products}");
                                  print("Order Model: $newOrderModel");
                                  Navigator.pop(context);
                                  sendOrder(context: context, dataModel: newOrderModel);
                                },
                                onNo: () {
                                  Navigator.pop(context);
                                });


                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Center(
                                      child: Text(
                                        "Confirmation",
                                        style: GoogleFonts.raleway(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ),
                                    content: Text(
                                      "Are you sure you want to proceed to checkout?",
                                      style: GoogleFonts.raleway(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        child: FlatButton(
                                          height: 34,
                                          color: Colors.teal.shade400,
                                          onPressed: () {
                                            Navigator.pop(context);
                                            debugPrint("PRODUCT FOR POSTING ********: ${newOrderModel.products}");
                                            print("Order Model: $newOrderModel");
                                            Navigator.pop(context);
                                            sendOrder(context: context, dataModel: newOrderModel);
                                          },
                                          child: Text(
                                            "Yes",
                                            style: GoogleFonts.raleway(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                              letterSpacing: 0.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(bottom: 8.0, right: 8),
                                        child: FlatButton(
                                            height: 34,
                                            color: LABEL_COLOR,
                                            onPressed: () {
                                              Navigator.pop(context); //close Dialog
                                            },
                                            child: Text(
                                              "No",
                                              style: GoogleFonts.raleway(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                                letterSpacing: 0.0,
                                              ),
                                            )),
                                      ),
                                      SizedBox(width: 35,),
                                    ],
                                  );
                                });

                          }


                        },
                        height: 40,
                        elevation: 0,
                        splashColor: Colors.teal[700],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Colors.teal,
                        child: Center(
                          child: Text(
                            "Proceed to Checkout",
                            style: GoogleFonts.raleway(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ))
              ],
            ),
          );
        }),
        SizedBox(
          height: 4,
        ),
      ],
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        title: Text(
          "Checkout",
          style: GoogleFonts.raleway(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            letterSpacing: .75,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [
            Theme(
              data: ThemeData(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: Colors.teal,
                      onPrimary: Colors.black, // <-- SEE HERE
                    ),
              ),
              child: SingleChildScrollView(
                child: Stepper(
                  physics: ScrollPhysics(),
                  controlsBuilder: (context, _) {
                    return Container();
                  },
                  type: StepperType.vertical,
                  steps: getSteps(),
                  currentStep: currentStep,
                  onStepContinue: () {
                    final isLastStep = currentStep == getSteps().length - 1;
                    if (isLastStep) {
                      debugPrint("completed");
                      //  Post data to server
                    } else {
                      setState(() {
                        currentStep += 1;
                      });
                    }
                  },
                  onStepTapped: (step) => setState(() {
                    currentStep = step;
                  }),
                  onStepCancel: currentStep == 0
                      ? null
                      : () {
                          setState(() {
                            currentStep -= 1;
                          });
                        },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendOrder({BuildContext context, NewOrderModel dataModel}) async {
    try {
      showDialog(
        context: context,
        builder: (context) {
          return ProgressDialog(displayMessage: 'Please wait...');
        },
      );

      print('order request object: $dataModel');

      var jsonBody = jsonEncode(dataModel);
      print('JSON BODY: $dataModel');
      NetworkUtility networkUtility = NetworkUtility();
      Response response = await networkUtility.postDataWithAuth(
          url: CREATE_ORDER, body: jsonBody, auth: 'Bearer $ACCESS_TOKEN');

      print('order response: ${json.decode(response.body)}');

      if (response == null) {
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
        print('Status: $status');

        if (status == 500 || status == 404 || status == 403) {
          new UtilityService().showMessage(
            message: 'An error has occurred. Please try again',
            icon: Icon(
              Icons.error_outline,
              color: Colors.red,
            ),
            context: context,
          );
        } else if (status == 201) {
          Navigator.of(context, rootNavigator: true).pop();

          //go to payment page, if electronic
          if (dataModel.paymentMode == 'Electronic') {
            CheckoutModel model = CheckoutModel(
              checkoutURL: data['data']['checkoutURL'].toString(),
              checkoutDirectURL: data['data']['checkoutDirectURL'].toString(),
              clientReference: data['data']['clientReference'].toString(),
              checkoutID: data['data']['checkoutID'].toString(),
            );
            print("CHECKOUT MODEL: $model");

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentScreen(
                  clientReference: model.clientReference,
                  checkoutModel: model,
                ),
              ),
            );
          } else {
            new UtilityService().showMessage(
              context: context,
              message: 'Order created successfully',
              icon: Icon(
                Icons.check,
                color: Colors.teal,
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SuccessScreen(),
              ),
            );
          }
          print('successfully sent');
        }
      }
    } catch (e) {
      print('postUserData error: $e');
      new UtilityService().showMessage(
        context: context,
        message: 'An error has occurred. Please try again',
        icon: Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
      );
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
