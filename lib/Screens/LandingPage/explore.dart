import 'dart:async';
import 'dart:convert';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:badges/badges.dart' as badges;
import 'package:apparel_options/Database/ProductDetailsDB.dart';
import 'package:apparel_options/Database/ProductSpecificationDB.dart';
import 'package:apparel_options/Database/ProductVariantDB.dart';
import 'package:apparel_options/Model/ProductVariantModel.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:we_slide/we_slide.dart';
import 'dart:ui' as ui;
import '../../Components/BulletList.dart';
import '../../Components/ListTileMenuComponent.dart';
import '../../Components/ProgressDialog.dart';
import '../../Constants/Colors.dart';
import '../../Constants/constantColors.dart';
import '../../Constants/myColors.dart';
import '../../Database/MenuDB.dart';
import '../../Database/UserDB.dart';
import '../../Model/AppData.dart';
import '../../Model/DeliveryAddressModel.dart';
import '../../Model/MenuModel.dart';
import '../../Model/NewMenuModel.dart';
import '../../Model/ProductDetailsModel.dart';
import '../../Model/ProductNew.dart';
import '../../Model/ProductSpecificationModel.dart';
import '../../Model/UserModel.dart';
import '../../Model/UserProfileModel.dart';
import '../../Model/predicted_places.dart';
import '../../Services/NetworkUtility.dart';
import '../../Services/services/api/PlacePredictionTile.dart';
import '../../Services/services/api/api_service.dart';
import '../../Services/services/api/direction.dart';
import '../../Services/services/api/request_assistant.dart';
import '../../Services/services/location_service.dart';
import '../../Utils/Utility.dart';
import '../../Utils/paths.dart';
import '../../animation/FadeAnimation.dart';
import '../../config/ApiConfig.dart';
import '../AccountScreen.dart';
import '../CartScreen.dart';
import '../CategoryScreen.dart';
import '../ProductDetails.dart';
import 'FavoritesScreen.dart';
import 'MapScreen.dart';
import 'MenuInfoScreen.dart';
import 'OrderScreen.dart';
import 'ProductDetailsScreen.dart';
import 'SearchPlacesScreen.dart';
import 'SearchScreen.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key, this.otpModel}) : super(key: key);
  final UserModel? otpModel;

  @override
  _ExplorePageState createState() => _ExplorePageState(otpModel: otpModel);
}

class _ExplorePageState extends State<ExplorePage>
    with TickerProviderStateMixin {
  final UserModel? otpModel;
  UserDB? userDB = UserDB();
  MenuDB? menuDB = MenuDB();
  UserProfileModel? userProfileModel = UserProfileModel();
  ProductVariantModel? productVariantModel = ProductVariantModel();
  ProductVariantDB? productVariantDB = ProductVariantDB();
  ProductSpecificationDB? productSpecificationDB = ProductSpecificationDB();
  ProductDetailsDB? productDetailsDB = ProductDetailsDB();

  List<MenuModel?> categoryList = [];
  List<MenuModel?> newArrivalList = [];
  List<MenuModel?> newArrivalMenu = [];
  List<MenuModel?> promoList = [];
  List<MenuModel?> popularItems = [];
  List<MenuModel?> popularMenu = [];
  List<ProductVariantModel?> productVariantsList = [];
  List<ProductVariantModel?> productVariantsListByID = [];

  // late final LocationService locationService;
  LatLng? initialPosition;

  bool? hasPromo;
  bool? isLoading;

  double? currentLongitude;
  double? currentLatitude;
  String? myAddress;
  String address = "";
  // String? _currentAddress = '';
  String? _startAddress = '';
  String? loc;
  final Completer<GoogleMapController> mapController = Completer();
  String? _currentAddress= '';
  Position? _currentPosition;

  bool? servicestatus = false;
  bool? haspermission = false;
  LocationPermission? permission;
  Position? position;
  String? long = "", lat = "";
  late StreamSubscription<Position?> positionStream;
  String? deliveryLocation;

  AnimationController? _controller;
  GoogleMapController? newGoogleMapController;
  Duration? _duration = Duration(milliseconds: 500);

  customizeStatusAndNavigationBar() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light));
  }

  Future<bool> showExitPopUp() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
              child: Text(
                "Leaving Application",
                style: GoogleFonts.raleway(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            content: Text(
              "Are you sure you want to logout?",
              style: GoogleFonts.raleway(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                letterSpacing: 0.3,
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: SizedBox(
                  height: 34,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.teal,
                    ),
                    onPressed: () async {
                      Navigator.pop(context);

                      cleanUp();
                      SystemNavigator.pop();
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
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, right: 8),
                child: SizedBox(
                  height: 34,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: kPrimaryTheme,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
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
              )
            ],
          );
        });
    return false;
  }

  void cleanUp() async {
    try {
      await userDB!.deleteAll();
      await menuDB!.deleteAll();
      await productVariantDB!.deleteAll();
      await productSpecificationDB!.deleteAll();
      await productDetailsDB!.deleteAll();
    } catch (e) {
      print("Error on clean up logout");
    }
  }

  @override
  void initState() {
    initLocation();
    _getCurrentPosition();
    checkGps();
    isLoading = true;
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });

    _controller = AnimationController(vsync: this, duration: _duration);
    customizeStatusAndNavigationBar();
    locationService=LocationService();
    locationService!
        .getCurrentLocation()
        .then((position) => _updatePosition(position, context));
    super.initState();
    getUserLocation();

    initDB();
    _scrollController = ScrollController();
    _scrollController!.addListener(_listenToScrollChange);
    products();
  }

  void initLocation() async {
    await getUserLocation();
    await getLocation();
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
  String? selectedDate;
  String? newSelectedValue;
  String? locationName;
  String? requestIdFromResponse;
  List? newAgents = [];
  var accuracy = '';
  LocationService? locationService;
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
  TextEditingController locationController = TextEditingController();
  List<PredictedPlaces?> placesPredictedList = [];
  var textController = TextEditingController();


  void onCameraMove(CameraPosition position) async {
    setState(() {
      search = false;
    });
    initialPosition = position.target;
  }

  late String? imageFile;
  String? carNumberToSend;
  int? kilometres = 100;


  void initDB() async {
    try {
      await userDB!.initialize();
      await menuDB!.initialize();
      await productVariantDB!.initialize();
      await productSpecificationDB!.initialize();
      await productDetailsDB!.initialize();

      await loadUserFromLocalStorage();
      await getInitialCategoriesData();
      await getPopularItemList();
      await loadProductVariantsFromDB();
      await loadProductVariantsByProductID();
      await getNewArrivalData();
    } catch (e) {
      print("Error on init DB");
    }
  }

  Future<void> getUserLocation() async {
    print("USER LOCATION METHOD");
    var position = await geo.GeolocatorPlatform.instance.getCurrentPosition();
    print("USER METHOD ${position}");
    setState(() {
      initialPosition = LatLng(position.latitude, position.longitude);
    });
    print("This initialPosition: $initialPosition");
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(
      CameraUpdate.newLatLng(initialPosition!),
    );

  }


  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);

    }).catchError((e) {
      // debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        print("THE LOCATION: ${_currentAddress}");
        initialPosition = LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
        print("THE INITIAL POSITION: $initialPosition");
        _currentAddress = '${place.street}, ${place.subLocality}';
        if(Provider.of<AppData>(context, listen: false).locationName.toString().contains("null")) {
          deliveryLocation = _currentAddress;
        }else{
          deliveryLocation = Provider.of<AppData>(context, listen: false).locationName;
        }
        print("THE LOCA: ${Provider.of<AppData>(context, listen: false).locationName}");
      });
      print("LOC: ${_currentAddress}");
    }).catchError((e) {
      // debugPrint(e);
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    print("THE LOCATION: ${Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)}");


    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<void> loadUserFromLocalStorage() async {
    List<UserProfileModel> users = await userDB!.getAllUsers();
    if (users.isNotEmpty) {
      setState(() {
        userProfileModel = users.first;
      });
    }
    print('userProfileModel after load up: $userProfileModel');
  }

  Future<void> loadProductVariantsFromDB() async {
    List<ProductVariantModel> productVariants = await productVariantDB!.getAllVariants();
    if (productVariants.isNotEmpty) {
      setState(() {
        productVariantsList = productVariants;
      });
    }
    else{
      print("Error occurred on the database");
    }
    print("Product Variants from the DB: ${productVariantsList.length}");
  }

  Future<void> loadProductVariantsByProductID() async {
    List<ProductVariantModel> productVariantsByID = await productVariantDB!.getProductVariantById(productVariantModel!.productId.toString());
    if(productVariantsByID.isNotEmpty){
      setState(() {
        productVariantsListByID = productVariantsByID;
      });
    }
    print("productVariants model id:  ${productVariantModel!.productId}");
    print("productVariantsByID:  ${productVariantsByID.length}");
  }

  Future<void> getNewArrivalData() async {
    //fetch Category data from local storage
    List<MenuModel> list = await menuDB!.getByNewArrival();
    setState(() {
      newArrivalList = list;
    });
    print("Get New Arrival List: ${newArrivalList.length} | $newArrivalList");
  }

  Future<void> getProductByID() async {
    //fetch Category data from local storage
    List<MenuModel> list = await menuDB!.getByNewArrival();
    setState(() {
      newArrivalList = list;
    });
    print("Get New Arrival List: ${newArrivalList.length} | $newArrivalList");
  }

  Future<void> getInitialCategoriesData() async {
    //fetch Category data from local storage
    List<MenuModel> list = await menuDB!.getAllCategories();
    setState(() {
      categoryList = list;
    });
    print("Get initial Categories: ${categoryList.length} | $categoryList");
  }

  Future<void> getPopularItemList() async {
    //fetch Category data from local storage
    print("********BENEATH THE POP DB1");
    List<MenuModel>? list = await menuDB!.getAllMenu();
    print("********BENEATH THE POP DB: ${list}");
    setState(() {
      popularMenu = list!;
    });
    print("Popular Items List: ${popularMenu.length}|| $popularMenu");
  }

  ScrollController? _scrollController;
  bool _isScrolled = false;

  List<dynamic> productList = [];
  List<String> size = [
    "S",
    "M",
    "L",
    "XL",
  ];

  List<Color> colors = [
    Colors.black,
    Colors.purple,
    Colors.orange.shade200,
    Colors.blueGrey,
    Color(0xFFFFC1D9),
  ];

  int _selectedColor = 0;
  int _selectedSize = 1;

  var selectedRange = RangeValues(150.00, 1500.00);

  _ExplorePageState({this.otpModel});

  int newIndex = 2;

  void _listenToScrollChange() {
    if (_scrollController!.offset >= 100.0) {
      setState(() {
        _isScrolled = true;
      });
    } else {
      setState(() {
        _isScrolled = false;
      });
    }
  }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if(servicestatus!){
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

      if(haspermission!){
        setState(() {
          //refresh the UI
        });

        // getLocation();
      }
    }else{
      print("GPS Service is not enabled, turn on GPS location");
    }

    setState(() {
      //refresh the UI
    });
  }

  final double _panelMinSize = 70.0;
  final double _panelMaxSize = 40;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: showExitPopUp,
      child: Scaffold(
        backgroundColor: kBackgroundTheme,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.grey.shade200,
          elevation: 0.2,
          title: Text(
            "Home",
            style: GoogleFonts.raleway(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              letterSpacing: .75,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          actions: [
            Center(
              child: badges.Badge(
                badgeContent: Consumer<AppData>(builder: (context, value, child) {
                  return Text(
                      value.getCartCount().toString() != null ? value.getCartCount().toString() : "0",
                    style: TextStyle(color: Colors.white),
                  );
                }),
                badgeAnimation: badges.BadgeAnimation.slide(
                  toAnimate: true,
                  animationDuration: Duration(milliseconds: 300),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartScreen(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        drawer: Drawer(
          child: Material(
            color: Colors.black87,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    children: <Widget>[
                      DrawerHeader(
                        child: Container(
                          height: 70,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AvatarGlow(
                                endRadius: 35,
                                glowColor: Colors.amber,
                                child: Container(
                                  child: const CircleAvatar(
                                    backgroundImage: AssetImage(
                                        'assets/images/personIcon.png'),
                                    radius: 25,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (userProfileModel! != null &&
                                            userProfileModel!.name != null)
                                        ? userProfileModel!.name!
                                        : 'Welcome',
                                    style: GoogleFonts.lato(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    (userProfileModel != null &&
                                            userProfileModel!.email != null)
                                        ? userProfileModel!.email!
                                        : '-',
                                    style: GoogleFonts.lato(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.white,
                        thickness: 0.12,
                      ),
                      ListTileMenuComponent(
                        icon: Icons.menu,
                        label: 'Menu',
                        labelColor: Colors.white,
                        iconColor: Colors.amber,
                        onTap: () {
                          // Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryScreen(
                                showBackButton: true,
                              ),
                            ),
                          );
                        },
                      ),
                      ListTileMenuComponent(
                        icon: Icons.favorite,
                        iconColor: Colors.amber,
                        label: 'My Favorites',
                        labelColor: Colors.white,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FavoritesScreen(),
                            ),
                          );
                        },
                      ),
                      ListTileMenuComponent(
                        icon: Icons.card_giftcard_outlined,
                        label: 'Orders',
                        iconColor: Colors.amber,
                        labelColor: Colors.white,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderScreen(
                                showBackButton: true,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Container(
                        child: Column(
                          children: [
                            const Divider(
                              thickness: 0.12,
                              color: Colors.white,
                            ),
                            ListTileMenuComponent(
                              icon: Icons.settings,
                              label: 'Setting',
                              iconColor: Colors.amber,
                              labelColor: Colors.white,
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AccountScreen(),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 10,),
                            Text(
                              "Version 1.0.1",
                              style: GoogleFonts.raleway(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            fetchMenuData(context);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 6,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          isLoading != false
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8, bottom: 0, top: 6),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(top: 8.0, left: 8),
                                      child: ShimmerCard(
                                        height: 14,
                                        width: 85,
                                      ),
                                    ),
                                  ),
                                )
                              : Align(
                                  alignment: Alignment.topLeft,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          child: Image.asset(
                                            "assets/images/appLogo.png",
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 1.0),
                                        child: Text(
                                          (userProfileModel! != null &&
                                              userProfileModel!.name != null)
                                              ? "Welcome, ${userProfileModel!.name!}"
                                              : 'Welcome',
                                          style: GoogleFonts.raleway(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,

                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                        ],
                      ),
                      Divider(
                        color: Colors.black38,
                        thickness: 0.1,
                        endIndent: 12.5,
                        indent: 12.5,
                      ),
                      Container(
                        height: 50,
                        color: Colors.amber.shade100,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                           children: [
                             Icon(
                               Icons.location_on_sharp,
                               color: Colors.black,
                               size: 27,
                             ),
                             SizedBox(width: 10,),
                             Container(
                               child: isLoading != false
                                   ? Padding(
                                 padding: const EdgeInsets.only(
                                     left: 8.0,
                                     right: 8,
                                     bottom: 4,
                                     top: 6),
                                 child: Align(
                                   alignment: Alignment.topLeft,
                                   child: Padding(
                                     padding: const EdgeInsets.only(
                                         top: 8.0, left: 8),
                                     child: ShimmerCard(
                                       height: 14,
                                       width: 95,
                                     ),
                                   ),
                                 ),
                               )
                                   :Expanded(
                                 child: Row(
                                   children: [
                                     Expanded(
                                       child: Consumer<AppData>(builder: (context, value, child) {
                                         return Text(
                                           (Provider.of<AppData>(context, listen: false).confirmationLocation!.isNotEmpty)
                                               ? "Deliver to ${userProfileModel!.name} -  ${Provider.of<AppData>(context, listen: false).confirmationLocation}"
                                               : 'Loading...',
                                           style: GoogleFonts.raleway(
                                               fontSize: 14.8,
                                               fontWeight: FontWeight.w600,
                                               color: Colors.black),
                                         );
                                       }),
                                     ),
                                     Padding(
                                       padding: const EdgeInsets.all(8.0),
                                       child: InkWell(
                                         onTap: (){
                                           print("++++++++");
                                           // const BottomSheetExample();
                                           Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPlacesScreen()));

//                                        showModalBottomSheet(
//                                            isScrollControlled: true,
//                                            context: context,
//                                            backgroundColor: Colors.white,
//                                            shape: RoundedRectangleBorder(
//                                            borderRadius: BorderRadiusDirectional.only(
//                                            topEnd: Radius.circular(25),
//                                             topStart: Radius.circular(25),
//                                        ),
//                                        ),
//                                          builder: (context) => SingleChildScrollView(
//                                          padding: EdgeInsetsDirectional.only(
//                                          start: 20,
//                                          end: 20,
//                                          bottom: 30,
//                                          top: 8,
//                                        ),
//                                        child:SingleChildScrollView(
//                                          child: Container(
//                                            height: MediaQuery.sizeOf(context).height * 0.89,
//                                            child: SizedBox.expand(
//                                              child: Stack(
//                                                children: <Widget>[
//                                                  initialPosition == null
//                                                      ? const Center(child: Text("Please check your network"))
//                                                      :GoogleMap(
//                                                    mapType: MapType.normal,
//                                                    zoomControlsEnabled: false,
//                                                    initialCameraPosition:
//                                                    CameraPosition(target: initialPosition!, zoom: 18),
//                                                    myLocationButtonEnabled: false,
//                                                    markers: Set<Marker>.of(_marker),
//                                                    myLocationEnabled: true,
//                                                    onCameraMove: onCameraMove,
//                                                    onMapCreated: (GoogleMapController controller) {
//                                                      mapController.complete(controller);
//                                                      newGoogleMapController = controller;
//
//                                                      // //for black theme google map
//                                                      newGoogleMapController!.setMapStyle('''
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
//                                                    },
//                                                    onCameraIdle: () async {
//                                                      search = true;
//                                                      setState(() {
//                                                        getMoveCamera();
//                                                      });
//                                                    },
//                                                  ),
//                                                  Align(
//                                                    alignment: Alignment.center,
//                                                    child: Container(
//                                                        height: 43,
//                                                        child: Image.asset("assets/images/placeholder.png")),
//                                                  ),
//                                                  search == true
//                                                      ? Positioned(
//                                                    top: MediaQuery.of(context).size.height / 2.90,
//                                                    left: MediaQuery.of(context).size.width / 3.62,
//                                                    child: Container(
//                                                      decoration: BoxDecoration(
//                                                        borderRadius: BorderRadius.circular(12.0),
//                                                        // color: Colors.black.withOpacity(0.75),
//                                                      ),
//                                                      width: 195,
//                                                      height: 40,
//                                                      child: const Center(child: Text("")),
//                                                    ),
//                                                  )
//                                                      : Positioned(
//                                                    top: MediaQuery.of(context).size.height / 3.00,
//                                                    left: MediaQuery.of(context).size.width / 2.3,
//                                                    child: Container(
//                                                      padding: const EdgeInsets.symmetric(
//                                                          horizontal: 17, vertical: 12),
//                                                      decoration: BoxDecoration(
//                                                          borderRadius: BorderRadius.circular(12.0),
//                                                          color: Colors.black.withOpacity(0.75)),
//                                                      width: 50,
//                                                      height: 40,
//                                                      child: const Center(
//                                                        child: CircularProgressIndicator(
//                                                          valueColor: AlwaysStoppedAnimation(Colors.white),
//                                                          strokeWidth: 2.5,
//                                                        ),
//                                                      ),
//                                                    ),
//                                                  ),
//                                                  Positioned(
//                                                    top: 29,
//                                                    left: 0,
//                                                    right: 16,
//                                                    child: Container(
//                                                      alignment: Alignment.topLeft,
//                                                      child: Padding(
//                                                        padding: const EdgeInsets.all(15),
//                                                        child: CircleAvatar(
//                                                          radius: 20,
//                                                          backgroundColor: Colors.black,
//                                                          child: Padding(
//                                                            padding: const EdgeInsets.only(bottom: 3.0, right: 6),
//                                                            child: IconButton(
//                                                                onPressed: () {
//                                                                  Navigator.pop(context);
//                                                                },
//                                                                icon: const Icon(
//                                                                  Icons.arrow_back,
//                                                                  size: 25,
//                                                                  color: Colors.white,
//                                                                )),
//                                                          ),
//                                                        ),
//                                                      ),
//                                                    ),
//                                                  ),
//                                                  Container(
//                                                      child: showSearch! == false
//                                                          ? Positioned(
//                                                        top: 35,
//                                                        left: 54,
//                                                        right: 16,
//                                                        child: Container(
//                                                          height: 600,
//                                                          width: double.maxFinite,
//                                                          padding: const EdgeInsets.symmetric(horizontal: 6),
//                                                          child: Column(
//                                                            children: [
//                                                              Flexible(
//                                                                  child: TextFormField(
//                                                                    showCursor: true,
//                                                                    decoration: InputDecoration(
//                                                                      filled: true,
//                                                                      fillColor: Colors.white,
//                                                                      enabledBorder: OutlineInputBorder(
//                                                                        borderRadius: BorderRadius.circular(25.0),
//                                                                        borderSide: BorderSide(
//                                                                          color: kPrimaryTheme,
//                                                                          width: 1.0,
//                                                                        ),
//                                                                      ),
//                                                                      border: OutlineInputBorder(
//                                                                        borderRadius: BorderRadius.circular(70),
//                                                                        borderSide: BorderSide(
//                                                                          color: kPrimaryTheme,
//                                                                          width: 1.5,
//                                                                        ),
//                                                                      ),
//                                                                      hintText: 'Enter location...',
//                                                                      hintStyle: GoogleFonts.raleway(
//                                                                          fontSize: 13,
//                                                                          fontWeight: FontWeight.w400,
//                                                                          color: Colors.black54),
//                                                                      suffixIcon: locationController.text.length > 3
//                                                                          ? IconButton(
//                                                                        icon: const Icon(Icons.close),
//                                                                        onPressed: () {
//                                                                          locationController.clear();
//                                                                          setState(() {});
//                                                                        },
//                                                                      )
//                                                                          : const Padding(
//                                                                          padding: EdgeInsets.only(left: 10),
//                                                                          child: Icon(Icons.search)),
//                                                                    ),
//                                                                    controller: locationController,
//                                                                    style: GoogleFonts.raleway(
//                                                                      fontSize: 14,
//                                                                      fontWeight: FontWeight.w600,
//                                                                      color: Colors.black,
//                                                                    ),
//                                                                    onChanged: ((valueTyped) {
//                                                                      if (valueTyped.length > 2) {
//                                                                        findPlaceAutoCompleteSearch(valueTyped);
//                                                                        var actualLocation = Provider.of<AppData>(
//                                                                            context,
//                                                                            listen: false)
//                                                                            .updateActualLocationName(
//                                                                            locationController.text);
//                                                                        print(
//                                                                            "THE ACTUAL LOCATION:${Provider.of<AppData>(context, listen: false).locationName}");
//                                                                      }
//                                                                    }),
//                                                                  )),
//                                                              SizedBox(height: 4),
//                                                              Expanded(
//                                                                child: isAutoCompleteLoading == false &&
//                                                                    placesPredictedList.isNotEmpty &&
//                                                                    locationController.text.isNotEmpty
//                                                                    ? Container(
//                                                                  width: double.maxFinite,
//                                                                  color: Colors.black,
//                                                                  padding: EdgeInsets.symmetric(
//                                                                      horizontal: 16),
//                                                                  child: ListView.separated(
//                                                                    itemCount: placesPredictedList.length,
//                                                                    physics: ClampingScrollPhysics(),
//                                                                    itemBuilder: (context, index) {
//                                                                      return PlacePredictionTileDesign(
//                                                                          onPressed: () {
//                                                                            getPlaceDirectionDetails(
//                                                                                placesPredictedList[
//                                                                                index]
//                                                                                !.place_id,
//                                                                                context)
//                                                                                .then((_) {
//                                                                              placesPredictedList.clear();
//                                                                              setState(() {});
//                                                                              var result =
//                                                                                  Provider.of<AppData>(
//                                                                                      context,
//                                                                                      listen: false)
//                                                                                      .updatedLocation;
//                                                                              print(result);
//                                                                              if (result != null) {
//                                                                                print('im here');
//                                                                                goToPlace(
//                                                                                    result
//                                                                                        .locationLatitude!,
//                                                                                    result
//                                                                                        .locationLongitude!);
//                                                                              }
//                                                                            });
//                                                                          },
//                                                                          predictedPlaces: placesPredictedList[index]
//                                                                      );
//                                                                    },
//                                                                    separatorBuilder:
//                                                                        (BuildContext context,
//                                                                        int index) {
//                                                                      return const Divider(
//                                                                        height: 1,
//                                                                        color: Colors.white,
//                                                                        thickness: 1,
//                                                                      );
//                                                                    },
//                                                                  ),
//                                                                )
//                                                                    : const SizedBox.shrink(),
//                                                              )
//                                                            ],
//                                                          ),
//                                                        ),
//                                                      )
//                                                          : Container()),
//                                                  Align(
//                                                    alignment: Alignment.bottomRight,
//                                                    child: Padding(
//                                                      padding: EdgeInsets.only(bottom: 18, right: 8),
//                                                      child: GestureDetector(
//                                                        onTap: () {
//                                                          getUserLocation();
//                                                        },
//                                                        child: const CircleAvatar(
//                                                          radius: 25,
//                                                          backgroundColor: Colors.grey,
//                                                          child: Icon(
//                                                            Icons.my_location,
//                                                            color: Colors.white,
//                                                          ),
//                                                        ),
//                                                      ),
//                                                    ),
//                                                  ),
//                                                  // DraggableScrollableSheet(
//                                                  //     maxChildSize: 0.36,
//                                                  //     initialChildSize: 0.20,
//                                                  //     minChildSize: 0.05,
//                                                  //     builder: (context, scrollController) =>
//                                                  //         StatefulBuilder(builder: (context, setState) {
//                                                  //           return SingleChildScrollView(
//                                                  //             child:
//                                                  //           );
//                                                  //         })),
//
//                                                  // DraggableScrollableSheet(
//                                                  //   initialChildSize: 0.1,
//                                                  //   minChildSize: 0.0,
//                                                  //   maxChildSize: 0.6,
//                                                  //   builder:
//                                                  //       (BuildContext context, ScrollController scrollController) {
//                                                  //     return Container(
//                                                  //       decoration: BoxDecoration(
//                                                  //           color: Colors.white,
//                                                  //           borderRadius: BorderRadius.only(
//                                                  //               topLeft: Radius.circular(50),
//                                                  //               topRight: Radius.circular(50))),
//                                                  //       child: ListView.builder(
//                                                  //         controller: scrollController,
//                                                  //         itemCount: 1,
//                                                  //         itemBuilder: (BuildContext context, int index) {
//                                                  //           return Column(
//                                                  //             mainAxisAlignment: MainAxisAlignment.start,
//                                                  //             children: [
//                                                  //               Align(
//                                                  //                 alignment: Alignment.topCenter,
//                                                  //                 child: Container(
//                                                  //                   height: 5.0,
//                                                  //                   width: 44.0,
//                                                  //                   decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10.0)),
//                                                  //                 ),
//                                                  //               ),
//                                                  //               Padding(
//                                                  //                 padding: const EdgeInsets.all(10.0),
//                                                  //                 child: Column(
//                                                  //                   children: [
//                                                  //                     SizedBox(
//                                                  //                       height: 10,
//                                                  //                     ),
//                                                  //                     Row(
//                                                  //                       mainAxisAlignment:
//                                                  //                       MainAxisAlignment.spaceBetween,
//                                                  //                       children: [
//                                                  //                         Row(
//                                                  //                           children: [
//                                                  //                             Align(
//                                                  //                                 alignment: Alignment.topLeft,
//                                                  //                                 child: Icon(
//                                                  //                                   Icons.location_pin,
//                                                  //                                   size: 35,
//                                                  //                                   color: Colors.black,
//                                                  //                                 )),
//                                                  //                             SizedBox(
//                                                  //                               width: 15,
//                                                  //                             ),
//                                                  //                             Column(
//                                                  //                               crossAxisAlignment:
//                                                  //                               CrossAxisAlignment.start,
//                                                  //                               children: [
//                                                  //                                 Text(
//                                                  //                                   Provider.of<AppData>(context,
//                                                  //                                       listen: false)
//                                                  //                                       .locationName ==
//                                                  //                                       null
//                                                  //                                       ? "loading..."
//                                                  //                                       : Provider.of<AppData>(
//                                                  //                                       context,
//                                                  //                                       listen: false)
//                                                  //                                       .locationName!,
//                                                  //                                   maxLines: 7,
//                                                  //                                   overflow: TextOverflow.ellipsis,
//                                                  //                                   style: GoogleFonts.raleway(
//                                                  //                                     fontSize: 14,
//                                                  //                                     fontWeight: FontWeight.w600,
//                                                  //                                     color: Colors.black,
//                                                  //                                   ),
//                                                  //                                 ),
//                                                  //                                 SizedBox(
//                                                  //                                   height: 6,
//                                                  //                                 ),
//                                                  //                                 Align(
//                                                  //                                   alignment: Alignment.topLeft,
//                                                  //                                   child: Text(
//                                                  //                                     "Location for service delivery",
//                                                  //                                     style: GoogleFonts.raleway(
//                                                  //                                         fontSize: 12,
//                                                  //                                         letterSpacing: 0,
//                                                  //                                         fontWeight: FontWeight.w600,
//                                                  //                                         color: Colors.black54),
//                                                  //                                   ),
//                                                  //                                 ),
//                                                  //                               ],
//                                                  //                             ),
//                                                  //                           ],
//                                                  //                         ),
//                                                  //                         GestureDetector(
//                                                  //                             onTap: () {
//                                                  //                               setState(() {
//                                                  //                                 showSearch = !showSearch!;
//                                                  //                               });
//                                                  //                             },
//                                                  //                             child: Icon(
//                                                  //                               Icons.edit,
//                                                  //                               color: Colors.blueAccent,
//                                                  //                               size: 20,
//                                                  //                             )),
//                                                  //                       ],
//                                                  //                     ),
//                                                  //                     Divider(
//                                                  //                       color: Colors.black87,
//                                                  //                       thickness: 0.1,
//                                                  //                     ),
//                                                  //                   ],
//                                                  //                 ),
//                                                  //               )
//                                                  //             ],
//                                                  //           );
//                                                  //         },
//                                                  //       ),
//                                                  //     );
//                                                  //   },
//                                                  // ),
//                                                ],
//                                              ),
//                                            ),
//
//                                          ),
//                                        )))

                                         },
                                         child: Icon(
                                           Icons.keyboard_arrow_down_outlined,
                                           color: Colors.black,
                                           size: 24,
                                         ),
                                       ),
                                     ),
                                   ],
                                 ),
                               ),
                             ),


                           ],
                          ),
                        ),
                        ),
                      SizedBox(height: 6,),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Container(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  isLoading != false
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0,
                                              right: 8,
                                              bottom: 4,
                                              top: 6),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0, left: 8),
                                              child: ShimmerCard(
                                                height: 14,
                                                width: 95,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15.0, top: 0),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Container(
                                              child: Text(
                                                "Categories",
                                                style: GoogleFonts.raleway(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                  letterSpacing: 0.3,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                ],
                              ),
                              isLoading != false
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8, bottom: 4),
                                      child: Container(
                                        height: 60,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: 7,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 7, top: 7, right: 3),
                                              child: ShimmerCard(
                                                height: 30,
                                                width: 55,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                  : Container(
                                height: 100,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 1,
                                    itemBuilder: (context, index) {
                                      return Row(
                                        children: loadCategoryList(context),
                                      );
                                    }),
                              ),
                              Row(
                                children: [
                                  isLoading != false
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0,
                                              right: 8,
                                              bottom: 4,
                                              top: 6),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0, left: 8),
                                              child: ShimmerCard(
                                                height: 14,
                                                width: 95,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, top: 5, bottom: 10),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Container(
                                              child: Text(
                                                "Recommended",
                                                style: GoogleFonts.raleway(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                  letterSpacing: 0.3,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                ],
                              ),
                              isLoading != false
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8, bottom: 4),
                                      child: Container(
                                        height: 210,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: 5,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ShimmerCard(
                                                  height: 160,
                                                  width: 190,
                                                ),
                                              );
                                            }),
                                      ),
                                    )
                                  : Container(
                                      height: 250,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: 1,
                                          itemBuilder: (context, index) {
                                            return Row(
                                              children:
                                                  loadPopularList(context),
                                            );
                                          }),
                                    ),
                              Row(
                                children: [
                                  isLoading != false
                                      ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0,
                                        right: 8,
                                        bottom: 4,
                                        top: 6),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, left: 8),
                                        child: ShimmerCard(
                                          height: 14,
                                          width: 95,
                                        ),
                                      ),
                                    ),
                                  )
                                      : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, top: 15, bottom: 1),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                        child: Text(
                                          "New Arrivals",
                                          style: GoogleFonts.raleway(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              isLoading != false
                                  ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8, bottom: 4),
                                child: Container(
                                  height: 210,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: 5,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding:
                                          const EdgeInsets.all(8.0),
                                          child: ShimmerCard(
                                            height: 160,
                                            width: 190,
                                          ),
                                        );
                                      }),
                                ),
                              )
                                  : Container(
                                height: 250,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 1,
                                    itemBuilder: (context, index) {
                                      return Row(
                                        children:
                                        loadNewArrivalList(context),
                                      );
                                    }),
                              ),
                              isLoading != false
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 14.0, right: 6, bottom: 4),
                                      child: Container(
                                        height: 210,
                                        child: ShimmerCard(
                                          height: 160,
                                          // width: 190,
                                        ),
                                      ),
                                    )
                                  : Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, top: 15, bottom: 0),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            child: Text(
                                              "Promotions",
                                              style: GoogleFonts.raleway(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                          height: 200,
                                          child: hasPromo == false
                                              ? ListView.builder(
                                                  scrollDirection: Axis.horizontal,
                                                  itemCount: 1,
                                                  itemBuilder: (context, index) {
                                                    return Row(
                                                      children:
                                                          loadPromotions(context),
                                                    );
                                                  },
                                                )
                                              : Card(
                                                  color: Colors.white,
                                                  child: Container(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      children: [
                                                        Container(
                                                          height: 70,
                                                          child: Image.asset(
                                                              "assets/images/tshirt.png"),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Center(
                                                          child: Container(
                                                            child: Text(
                                                              "No promos available",
                                                              style: GoogleFonts
                                                                  .raleway(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight.w300,
                                                                color:
                                                                    Colors.black54,
                                                                letterSpacing: 0.3,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                    ],
                                  ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            _getCurrentPosition;
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => SearchScreen()));
          },
          child: Icon(
            Icons.search,
            size: 24,
          ),
        ),
      ),
    );
  }

  Future<void> products() async {
    final String response = await rootBundle.loadString('assets/products.json');
    final data = await json.decode(response);

    setState(() {
      productList = demoProducts;
    });
  }

  productCart(ProductNew product) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child:GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductDetails(product: product)));
        },
        child: Container(
          margin: const EdgeInsets.only(right: 10, bottom: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(5, 10),
                blurRadius: 15,
                color: Colors.grey.shade200,
              )
            ],
          ),
          padding: EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 150,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(product.images![0],
                              color: Colors.black12,
                              colorBlendMode: BlendMode.darken,
                              fit: BoxFit.cover)),
                    ),
                    // Add to cart button
                    Positioned(
                      right: 5,
                      bottom: 5,
                      child: MaterialButton(
                        color: Colors.teal,
                        minWidth: 40,
                        height: 40,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        onPressed: () {

                        },
                        padding: EdgeInsets.all(5),
                        child: const Center(
                            child: Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                              size: 20,
                            )),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 13.0),
                child: Text(
                  product.title!,
                  style: GoogleFonts.lato(
                      color: LABEL_COLOR,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      letterSpacing: 0.3),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 13.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "GHc " + product.price.toString(),
                      style: GoogleFonts.lato(
                        color: LABEL_COLOR,
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      product.description!,
                      style: GoogleFonts.ibmPlexSans(
                          color: LABEL_COLOR,
                          fontSize: 14,
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  Future<dynamic> ViewAppointment(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              child: Container(
                padding: const EdgeInsets.only(
                    top: 20, left: 20, right: 20, bottom: 20),
                height: MediaQuery.of(context).size.height * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filter',
                          style: GoogleFonts.raleway(
                              color: Colors.black,
                              fontSize: 1,
                              fontWeight: FontWeight.w700),
                        ),
                        MaterialButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: const Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 30,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Color",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: colors.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedColor = index;
                              });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  color: _selectedColor == index
                                      ? colors[index]
                                      : colors[index].withOpacity(0.5),
                                  shape: BoxShape.circle),
                              width: 40,
                              height: 40,
                              child: Center(
                                child: _selectedColor == index
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      )
                                    : Container(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Size',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: size.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedSize = index;
                              });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  color: _selectedSize == index
                                      ? Colors.yellow[800]
                                      : Colors.grey.shade200,
                                  shape: BoxShape.circle),
                              width: 40,
                              height: 40,
                              child: Center(
                                child: Text(
                                  size[index],
                                  style: TextStyle(
                                      color: _selectedSize == index
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 15),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Slider Price Renge filter
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Price Range',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '\$ ${selectedRange.start.toStringAsFixed(2)}',
                              style: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 12),
                            ),
                            Text(" - ",
                                style: TextStyle(color: Colors.grey.shade500)),
                            Text(
                              '\$ ${selectedRange.end.toStringAsFixed(2)}',
                              style: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RangeSlider(
                        values: selectedRange,
                        min: 0.00,
                        max: 2000.00,
                        divisions: 100,
                        inactiveColor: Colors.grey.shade300,
                        activeColor: Colors.yellow[800],
                        labels: RangeLabels(
                          '\$ ${selectedRange.start.toStringAsFixed(2)}',
                          '\$ ${selectedRange.end.toStringAsFixed(2)}',
                        ),
                        onChanged: (RangeValues values) {
                          setState(() => selectedRange = values);
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    button('Filter', () {})
                  ],
                ),
              ),
            );
          });
        });
  }

  forYou(ProductNew product) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: Container(
        margin: const EdgeInsets.only(right: 10, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(5, 10),
              blurRadius: 15,
              color: Colors.grey.shade200,
            )
          ],
        ),
        padding: EdgeInsets.all(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(product.images![0],
                            color: Colors.black12,
                            colorBlendMode: BlendMode.darken,
                            fit: BoxFit.cover)),
                  ),
                  // Add to cart button
                  Positioned(
                    right: 5,
                    bottom: 5,
                    child: MaterialButton(
                      color: Colors.teal,
                      minWidth: 40,
                      height: 40,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      onPressed: () {
                        addToCartModal();
                      },
                      padding: EdgeInsets.all(5),
                      child: const Center(
                          child: Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                            size: 20,
                          )),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13.0),
              child: Text(
                product.title!,
                style: GoogleFonts.lato(
                    color: LABEL_COLOR,
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                    letterSpacing: 0.3),
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.price.toString(),
                    style: GoogleFonts.lato(
                      color: LABEL_COLOR,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    product.description!,
                    style: GoogleFonts.ibmPlexSans(
                        color: LABEL_COLOR,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  showFilterModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            padding:
                const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filter',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      minWidth: 40,
                      height: 40,
                      color: Colors.grey.shade300,
                      elevation: 0,
                      padding: EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: const Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Color",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: colors.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColor = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                              color: _selectedColor == index
                                  ? colors[index]
                                  : colors[index].withOpacity(0.5),
                              shape: BoxShape.circle),
                          width: 40,
                          height: 40,
                          child: Center(
                            child: _selectedColor == index
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  )
                                : Container(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Size',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: size.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedSize = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                              color: _selectedSize == index
                                  ? Colors.yellow[800]
                                  : Colors.grey.shade200,
                              shape: BoxShape.circle),
                          width: 40,
                          height: 40,
                          child: Center(
                            child: Text(
                              size[index],
                              style: TextStyle(
                                  color: _selectedSize == index
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 15),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Slider Price Range filter
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Price Range',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '\$ ${selectedRange.start.toStringAsFixed(2)}',
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 12),
                        ),
                        Text(" - ",
                            style: TextStyle(color: Colors.grey.shade500)),
                        Text(
                          '\$ ${selectedRange.end.toStringAsFixed(2)}',
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                RangeSlider(
                    values: selectedRange,
                    min: 0.00,
                    max: 2000.00,
                    divisions: 100,
                    inactiveColor: Colors.grey.shade300,
                    activeColor: Colors.yellow[800],
                    labels: RangeLabels(
                      '\$ ${selectedRange.start.toStringAsFixed(2)}',
                      '\$ ${selectedRange.end.toStringAsFixed(2)}',
                    ),
                    onChanged: (RangeValues values) {
                      setState(() => selectedRange = values);
                    }),
                const SizedBox(
                  height: 20,
                ),
                button('Filter', () {})
              ],
            ),
          );
        });
      },
    );
  }

  addToCartModal() {
    return showModalBottomSheet(
        context: context,
        transitionAnimationController: AnimationController(
            duration: const Duration(milliseconds: 400), vsync: this),
        builder: (context) => StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  height: 380,
                  padding: EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Fabric",
                              style: GoogleFonts.raleway(
                                height: 1.5,
                                color: LABEL_COLOR,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            BulletList(const [
                              "5.3 oz., 100% preshrunk cotton",
                              "Made with sustainably and fairly grown USA cotton",
                            ]),
                            Text(
                              "Feature",
                              style: GoogleFonts.raleway(
                                height: 1.5,
                                color: LABEL_COLOR,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            BulletList(const [
                              "Seamless rib at neck",
                              "Taped shoulder-to-shoulder",
                              "Double-needle stitching throughout",
                              '"7/8" collar',
                            ]),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Available Colors",
                          style: GoogleFonts.raleway(
                              color: LABEL_COLOR,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 0,
                        ),
                        Container(
                          height: 60,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: colors.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedColor = index;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                      color: _selectedColor == index
                                          ? colors[index]
                                          : colors[index].withOpacity(0.5),
                                      shape: BoxShape.circle),
                                  width: 30,
                                  height: 30,
                                  child: Center(
                                    child: _selectedColor == index
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 18,
                                          )
                                        : Container(),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Available Sizes",
                          style: GoogleFonts.raleway(
                              color: LABEL_COLOR,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                        Container(
                          height: 60,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: size.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedSize = index;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                      color: _selectedSize == index
                                          ? Colors.yellow[800]
                                          : Colors.grey.shade200,
                                      shape: BoxShape.circle),
                                  width: 30,
                                  height: 30,
                                  child: Center(
                                    child: Text(
                                      size[index],
                                      style: GoogleFonts.raleway(
                                          color: _selectedSize == index
                                              ? Colors.white
                                              : LABEL_COLOR,
                                          fontSize: 13),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MaterialButton(
                          onPressed: () {
                            Navigator.pop(context);

                            // Let's show a snackbar when an item is added to the cart
                            final snackbar = SnackBar(
                              content: const Text("Item added to cart"),
                              duration: Duration(seconds: 5),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () {},
                              ),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackbar);
                          },
                          height: 50,
                          elevation: 0,
                          splashColor: Colors.yellow[700],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Colors.black,
                          child: const Center(
                            child: Text(
                              "Add to Cart",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ));
  }

  button(String text, Function onPressed) {
    return MaterialButton(
      onPressed: () => onPressed(),
      height: 50,
      elevation: 0,
      splashColor: Colors.yellow[700],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.yellow[800],
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  List<Row> loadCategoryList(BuildContext context) {
    List<Row> list = [];
    try {
      if (categoryList.isNotEmpty) {
        for (MenuModel? category in categoryList) {
          list.add(
            Row(
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 4, top: 5),
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MenuInfoScreen(
                              category: category!.category,
                            ),
                          ),
                        );
                        // menuDB.getAllMenu();
                        // fetchMenuData(context, category.category);
                      },
                      child: Container(
                          child: Column(
                        children: [
                          CachedNetworkImage(
                            imageUrl: category!.imageUrl.toString(),
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(38),
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
                            height: 60,
                            width: 60,
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
                          // Container(
                          //   height: 70,
                          //   width: 70,
                          //   decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(18),
                          //       border: Border.all(
                          //         color: Colors
                          //             .black12, //                   <--- border color
                          //         width: 1.0,
                          //       ),
                          //       color: NAVBAR_BACKGROUND_COLOR),
                          //   child: Padding(
                          //       padding: EdgeInsets.all(8.0),
                          //       child: hasBackgroundImage == false
                          //           ? CircleAvatar(
                          //               backgroundImage: AssetImage(
                          //                   "assets/images/fork.png"),
                          //               radius: 60,
                          //               foregroundImage: NetworkImage(
                          //                   category.imageUrl.toString()),
                          //             )
                          //           : Container(
                          //               child: Column(
                          //                 mainAxisAlignment:
                          //                     MainAxisAlignment.center,
                          //                 crossAxisAlignment:
                          //                     CrossAxisAlignment.stretch,
                          //                 children: [
                          //                   Container(
                          //                     height: 30,
                          //                     child: Image.asset(
                          //                         "assets/images/fork.png"),
                          //                   ),
                          //                 ],
                          //               ),
                          //             )),
                          // ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            category.category!,
                            style: GoogleFonts.raleway(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      )),
                    ))
              ],
            ),
          );
        }
      }

      return list;
    } catch (e) {
      debugPrint('Error Category List: $e');
      return null!;
    }
  }

  List<Card> loadPromotions(BuildContext context) {
    List<Card> list = [];
    final cart = Provider.of<AppData>(context);
    try {
      // print("Branch Promo List: ${promoList.length}");
      if (promoList.isNotEmpty) {
        for (MenuModel? promo in promoList) {
          list.add(
            Card(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 4.0, right: 4, top: 5, bottom: 5),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        height: 180,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.50),
                                BlendMode.darken),
                            image: NetworkImage(
                              promo!.imageUrl.toString(),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 14.0, right: 14, top: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              Center(
                                child: Container(
                                  child: Text(
                                    "Today\'s Promos",
                                    style: GoogleFonts.raleway(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        letterSpacing: 0.6),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MenuInfoScreen(
                                            // menuModel: menuModel,
                                            ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 66,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.black),
                                    child: Center(
                                      child: Text(
                                        "View",
                                        style: GoogleFonts.raleway(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            letterSpacing: 0.6),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      } else {
        Text(
          "No Promos available",
          style: GoogleFonts.raleway(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            letterSpacing: 0.3,
          ),
        );
      }

      return list;
    } catch (e) {
      debugPrint('Error promo list: $e');
      return null!;
    }
  }

  List<Row> loadPopularList(BuildContext context) {
    final cart = Provider.of<AppData>(context);
    final locationProvider = Provider.of<AppData>(context);
    // final _items = AddOns.getAddOns();
    List<Row> list = [];
    try {
      if (popularMenu.isNotEmpty ) {
        for (MenuModel? popularMenu in popularMenu) {
          print("THE PO BEANTH");
          print("DATA FOR NEXT SCREEN: ${popularMenu}");
          list.add(
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    await goToProductDetails(popularMenu!, context);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10, bottom: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(5, 10),
                          blurRadius: 15,
                          color: Colors.grey.shade200,
                        )
                      ],
                    ),
                    padding: EdgeInsets.all(6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 150,

                          child: Stack(
                            children: [
                              Container(
                                width: 220,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl: popularMenu!.imageUrl.toString(),
                                    height: 200,
                                    width: 220,
                                    fit: BoxFit.cover,
                                    color: Colors.black12,
                                    colorBlendMode: BlendMode.darken,
                                    placeholder: (context, url) => Container(
                                      height: 100,
                                      width: 100,
                                      child: Image.asset(
                                        "assets/images/tshirt.png",
                                        cacheHeight: 85,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      "assets/images/tshirt.png",
                                      cacheHeight: 85,
                                    ),
                                  ),
                                ),
                              ),

                              // Add to cart button
                              Positioned(
                                right: 5,
                                bottom: 5,
                                child: MaterialButton(
                                  color: Colors.amber,
                                  minWidth: 40,
                                  height: 40,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  onPressed: () {
                                    // cartModal(menuModel);
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             ProductDetailsScreen(
                                    //               pizzaMenuModel: menuModel,
                                    //               categoryBranch:
                                    //                   categoryBranch,
                                    //             )));
                                  },
                                  padding: EdgeInsets.all(5),
                                  child: const Center(
                                      child: Icon(
                                    Icons.shopping_cart,
                                    color: Colors.black,
                                    size: 20,
                                  )),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 220,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 13.0),
                                  child: Text(

                                    popularMenu != null ? popularMenu.product! : "-",
                                    style: GoogleFonts.raleway(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 13.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                popularMenu.category!,
                                style: GoogleFonts.raleway(
                                    color: LABEL_COLOR,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text(
                                  "GHS " + popularMenu.price.toString(),
                                  style: GoogleFonts.lato(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      } else {
        Row(
          children: [
            Container(
              child: Text("Hello"),
            ),
          ],
        );
      }

      return list;
    } catch (e) {
      debugPrint('Error pizza list: $e');
      return null!;
    }
  }

  List<Row> loadNewArrivalList(BuildContext context) {
    final cart = Provider.of<AppData>(context);
    final locationProvider = Provider.of<AppData>(context);
    // final _items = AddOns.getAddOns();
    List<Row> list = [];
    try {
      if (newArrivalList.isNotEmpty ) {
        for (MenuModel? newArrivalList in newArrivalList) {
          list.add(
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    await goToProductDetails(newArrivalList!, context);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10, bottom: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(5, 10),
                          blurRadius: 15,
                          color: Colors.grey.shade200,
                        )
                      ],
                    ),
                    padding: EdgeInsets.all(6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 150,

                          child: Stack(
                            children: [
                              Container(
                                width: 220,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl: newArrivalList!.imageUrl.toString(),
                                    height: 200,
                                    width: 220,
                                    fit: BoxFit.cover,
                                    color: Colors.black12,
                                    colorBlendMode: BlendMode.darken,
                                    placeholder: (context, url) => Container(
                                      height: 100,
                                      width: 100,
                                      child: Image.asset(
                                        "assets/images/tshirt.png",
                                        cacheHeight: 85,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                          "assets/images/tshirt.png",
                                          cacheHeight: 85,
                                        ),
                                  ),
                                ),
                              ),

                              // Add to cart button
                              Positioned(
                                right: 5,
                                bottom: 5,
                                child: MaterialButton(
                                  color: Colors.amber,
                                  minWidth: 40,
                                  height: 40,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  onPressed: () {
                                    // cartModal(menuModel);
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             ProductDetailsScreen(
                                    //               pizzaMenuModel: menuModel,
                                    //               categoryBranch:
                                    //                   categoryBranch,
                                    //             )));
                                  },
                                  padding: EdgeInsets.all(5),
                                  child: const Center(
                                      child: Icon(
                                        Icons.shopping_cart,
                                        color: Colors.black,
                                        size: 20,
                                      )),
                                ),
                              ),
                              Positioned(
                                right: 5,
                                top: 5,
                                child: Center(
                                    child: Container(
                                      height: 40,
                                      child: Image.asset("assets/images/newArrival.png"),
                                    )
                                )
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 220,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 13.0),
                                  child: Text(

                                    newArrivalList != null ? newArrivalList.product! : "-",
                                    style: GoogleFonts.raleway(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 13.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                newArrivalList.category!,
                                style: GoogleFonts.raleway(
                                    color: LABEL_COLOR,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text(
                                  "GHS " + newArrivalList.price.toString(),
                                  style: GoogleFonts.lato(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      } else {
        Row(
          children: [
            Container(
              child: Text("Hello"),
            ),
          ],
        );
      }

      return list;
    } catch (e) {
      debugPrint('Error pizza list: $e');
      return null!;
    }
  }

  void fetchMenuData(BuildContext context) async {
    try {
      EasyLoading.show(status: 'loading...');
      NetworkUtility networkUtility = NetworkUtility();
      Response? response = await networkUtility.getDataWithAuth(
          url: '${FETCH_LIST_OF_POPULAR_MENUS_BY_BRANCH}',
          auth: ACCESS_TOKEN_FOR_REQUEST);

      // debugPrint('Menu request url: ${FETCH_LIST_OF_POPULAR_MENUS_BY_BRANCH}/${branch}');

      if (response!.statusCode == 200 && response != null) {
        EasyLoading.showSuccess('Success!');
        //clear db
        await menuDB!.deleteAll();
        await productVariantDB!.deleteAll();
        var data = jsonDecode(response.body);
        var menuData = data['data'] as List;

        if (menuData.isNotEmpty) {
          for (int i = 0; i < menuData.length; i++) {
            // parse and save  menu items to menu db

            var productVariantList = menuData[i]['productVariants'] as List;
            print("productVariantList: $productVariantList");
            for (int j = 0; j < productVariantList.length; j++) {
              ProductVariantModel productVariantModel = ProductVariantModel(
                id: productVariantList[j]['id'],
                productId: productVariantList[j]['productId'],
                color: productVariantList[j]['color'] as String,
                colorCode: productVariantList[j]['colorCode'] as String,
                imageUrl: productVariantList[j]['imageUrl'] as String,
                quantity: productVariantList[j]['quantity'],
                sizes: productVariantList[j]['sizes'] as String,
              );
              print("productVariantModel: ${productVariantModel}");
              // save to local db
              await productVariantDB!.insertObject(productVariantModel);
              print("Item insertion into productVariantDB");
            }

            var productSpecificationsList = menuData[i]['productSpecifications'] as List;
            for (int k = 0; k < productSpecificationsList.length; k++) {
              ProductSpecificationModel productSpecificationModel = ProductSpecificationModel(
                id: productSpecificationsList[k]['id'],
                specification: productSpecificationsList[k]['specification'] as String,
                value: productSpecificationsList[k]['value'] as String,
                organization: productSpecificationsList[k]['organization'] as String ,
                createdBy: productSpecificationsList[k]['createdBy'] as String ,
                productId: productSpecificationsList[k]['productId'],

              );
              print("productSpecificationModel: ${productSpecificationModel}");
              // save to local db
              await productSpecificationDB!.insertObject(productSpecificationModel);
              print("Item insertion into productSpecificationDB");
            }

            var productDetailsList = menuData[i]['productDetails'] as List;
            for (int m = 0; m < productDetailsList.length; m++) {
              ProductDetailsModel productDetailsModel = ProductDetailsModel(
                id: productDetailsList[m]['id'],
                header: productDetailsList[m]['header'] as String,
                organization: productDetailsList[m]['organization'] as String ,
                createdBy: productDetailsList[m]['createdBy'] as String ,
                productId: productDetailsList[m]['productId'],
                details: productDetailsList[m]['details']  as String,
              );
              print("ProductDetailsModel: ${productDetailsModel}");
              // save to local db
              await productDetailsDB!.insertObject(productDetailsModel);
              print("Item insertion into productDetailsDB");
            }

            MenuModel menuModel = MenuModel(
              id: menuData[i]['id'],
              type: menuData[i]['type'].toString(),
              imageUrl: menuData[i]['imageUrl'].toString(),
              size: menuData[i]['size'].toString(),
              price: menuData[i]['price'].toString(),
              tagName: menuData[i]['tagName'].toString(),
              description: menuData[i]['description'].toString(),
              branch: menuData[i]['branch'].toString(),
              cumulativeRating: menuData[i]['cumulativeRating'].toString(),
              ratingFrequency: menuData[i]['ratingFrequency'].toString(),
              category: menuData[i]['category'].toString(),
              menuItem: menuData[i]['menuItem'].toString(),
              likes: menuData[i]['likes'].toString(),
              organization: menuData[i]['organization'].toString(),
              publish: menuData[i]['publish'].toString(),
              product: menuData[i]['product'].toString(),
              newArrival: menuData[i]['newArrival'].toString(),
              manufacturer: menuData[i]['manufacturer'].toString(),
              quantity: menuData[i]['quantity'].toString(),
              brand: menuData[i]['brand'].toString(), productVariants: [],
            );

            // save to local db
            await menuDB!.insertObject(menuModel);
            print("The Main Model: $menuModel");
            print("Item insertion into MenuDB");

          }
        }
        EasyLoading.dismiss();

        List<MenuModel>? list = await menuDB!.getAllMenu();
        getInitialCategoriesData();
        getPopularItemList();
        // Navigator.of(context).pop();

        if (list!.isNotEmpty) {
          UtilityService().showMessage(
            message: 'Products downloaded successfully',
            context: context,
            icon: const Icon(
              Icons.check,
              color: Colors.teal,
            ),
          );

          // fetchLikesData(context);
          // fetchConfigData(context);
        } else {
          UtilityService().showMessage(
            message: 'Sorry, no menu info found for the selected branch',
            context: context,
            icon: const Icon(
              Icons.info,
              color: Colors.blue,
            ),
          );
        }
      } else {
        UtilityService().showMessage(
          message: 'Sorry, an error occurred while fetching app data',
          context: context,
          icon: const Icon(
            Icons.cancel,
            color: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      debugPrint('fetch bill data error: $e');
      UtilityService().showMessage(
        message: 'Sorry, an error occurred while fetching app data',
        context: context,
        icon: const Icon(
          Icons.cancel,
          color: Colors.redAccent,
        ),
      );
      Navigator.of(context, rootNavigator: true).pop();
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

class BottomSheetExample extends StatelessWidget {
  const BottomSheetExample({key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text('showModalBottomSheet'),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 200,
                color: Colors.amber,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text('Modal BottomSheet'),
                      ElevatedButton(
                        child: const Text('Close BottomSheet'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({
    Key? key,
    this.height,
    this.width,
  }) : super(key: key);
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.050),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}


