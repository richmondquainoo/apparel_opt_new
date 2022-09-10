import 'dart:async';
import 'dart:convert';

import 'package:apparel_options/Database/ProductDetailsDB.dart';
import 'package:apparel_options/Database/ProductSpecificationDB.dart';
import 'package:apparel_options/Database/ProductVariantDB.dart';
import 'package:apparel_options/Model/ProductSpecificationModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

import '../../Constants/Colors.dart';
import '../../Constants/constantColors.dart';
import '../../Database/BranchDB.dart';
import '../../Database/CategoryDB.dart';
import '../../Database/ConfigDB.dart';
import '../../Database/DeliveryCostDB.dart';
import '../../Database/LikesDB.dart';
import '../../Database/MenuDB.dart';
import '../../Database/PromoDB.dart';
import '../../Database/UserDB.dart';
import '../../Index.dart';
import '../../Model/BranchModel.dart';
import '../../Model/CategoryModel.dart';
import '../../Model/Config.dart';
import '../../Model/DeliveryCost.dart';
import '../../Model/LikeModel.dart';
import '../../Model/MenuModel.dart';
import '../../Model/NewMenuModel.dart';
import '../../Model/ProductDetailsModel.dart';
import '../../Model/ProductVariantModel.dart';
import '../../Model/PromoModel.dart';
import '../../Model/Questions.dart';
import '../../Model/UserProfileModel.dart';
import '../../Utils/NetworkUtility.dart';
import '../../Utils/Utility.dart';
import '../../Utils/paths.dart';

class PreLoadScreen extends StatefulWidget {
  // final UserProfileModel userProfileModel;
  const PreLoadScreen({
    Key key,
  }) : super(key: key);

  @override
  State<PreLoadScreen> createState() => _PreLoadScreenState();
}

class _PreLoadScreenState extends State<PreLoadScreen> {
  Timer _timer;
  double _progress;

  // final UserProfileModel userProfileModel;
  UserProfileModel userModel = UserProfileModel();
  CategoryDB categoryDB = CategoryDB();
  PromoDB promoDB = PromoDB();
  CategoryModel category = CategoryModel();
  PromoModel promo = PromoModel();
  UserDB userDB = UserDB();
  MenuDB menuDB = MenuDB();
  BranchDB branchDB = BranchDB();
  LikesDB likesDB = LikesDB();
  ConfigDB configDB = ConfigDB();
  DeliveryCostDB deliveryCostDB = DeliveryCostDB();
  ProductVariantDB productVariantDB = ProductVariantDB();
  ProductSpecificationDB productSpecificationDB = ProductSpecificationDB();
  ProductDetailsDB productDetailsDB = ProductDetailsDB();

  List<CategoryModel> categoryList = [];
  List<PromoModel> promoList = [];
  List<MenuModel> popularList = [];
  List<BranchModel> branchList = [];
  List<ProductVariantModel> productVariantsList = [];


  int id5 = 0;
  String branch;

  @override
  void initState() {
    initDB();
    super.initState();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    // EasyLoading.showProgress(0.25, status: 'downloading...');
    // EasyLoading.removeCallbacks();
  }

  void initDB() async {
    //Step 0: Initialize db objects
    await branchDB.initialize();
    await userDB.initialize();
    await menuDB.initialize();
    await likesDB.initialize();
    await configDB.initialize();
    await deliveryCostDB.initialize();
    await productVariantDB.initialize();
    await productSpecificationDB.initialize();
    await productDetailsDB.initialize();

    //Step 1: Fetch user from local db
    await loadUserFromLocalStorage();
    await fetchAllMethods();

    //Step 2: Make all fetches
    // await fetchMenuData(context);
    // await fetchLikesData(context);
    // await fetchConfigData(context);
    // await fetchDeliveryCharges(context);
  }

  Future<void> fetchAllMethods() async {
    try {
      // _progress = 0;
      // _timer?.cancel();
      // _timer = Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
      //   EasyLoading.showProgress(_progress,
      //       status: '${(_progress * 100).toStringAsFixed(0)}%');
      //   _progress += 0.03;
      //
      //   if (_progress >= 1) {
      //     _timer?.cancel();
      //     EasyLoading.dismiss();
      //   }
      // });

      await fetchMenuData(context);
      // await fetchLikesData(context);
      // await fetchConfigData(context);
      // await fetchDeliveryCharges(context);
    } catch (e) {
      print("Sorry an error occurred when fetching all methods");
    }
  }

  Future<void> loadUserFromLocalStorage() async {
    List<UserProfileModel> users = await userDB.getAllUsers();
    if (users.isNotEmpty) {
      setState(() {
        userModel = users.first;
      });
    }
    print('user obj on branch page: $userModel');
  }



  _PreLoadScreenState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/preloadPic.jpg",
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.5),
            colorBlendMode: BlendMode.darken,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
                vertical: 220,
              ),
              decoration: BoxDecoration(
                color: BLACK_COLOR.withOpacity(0.35),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 120,
                  width: 120,
                  child: Image.asset(
                    "assets/images/appLogo.png",
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Center(
                        child: Text(
                          "Apparel",
                          style: GoogleFonts.aBeeZee(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: PRIMARY_YELLOW,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Center(
                        child: Text(
                          "Options",
                          style: GoogleFonts.raleway(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          // TextButton(
          //   child: Text('showProgress'),
          //   onPressed: () {
          //     _progress = 0;
          //     _timer?.cancel();
          //     _timer = Timer.periodic(const Duration(milliseconds: 100),
          //         (Timer timer) {
          //       EasyLoading.showProgress(_progress,
          //           status: '${(_progress * 100).toStringAsFixed(0)}%');
          //       _progress += 0.03;
          //
          //       if (_progress >= 1) {
          //         _timer?.cancel();
          //         EasyLoading.dismiss();
          //       }
          //     });
          //   },
          // ),
        ],
      ),
    );
  }

  Future<void> saveBranch() async {
    BranchModel model = BranchModel(branch: branch);
    await branchDB.deleteAll();
    await branchDB.insertObject(model);
  }

  void fetchMenuData(BuildContext context) async {
    try {
      EasyLoading.show(status: 'loading...');
      NetworkUtility networkUtility = NetworkUtility();
      Response response = await networkUtility.getDataWithAuth(
          url: '${FETCH_LIST_OF_POPULAR_MENUS_BY_BRANCH}',
          auth: ACCESS_TOKEN_FOR_REQUEST);

      // debugPrint('Menu request url: ${FETCH_LIST_OF_POPULAR_MENUS_BY_BRANCH}/${branch}');

      if (response.statusCode == 200 && response != null) {
        //clear db
        await menuDB.deleteAll();
        await productVariantDB.deleteAll();
        var data = jsonDecode(response.body);
        var menuData = data['data'] as List;
        // var productVariantsData = data['data']['productVariants'].toString();

        // List<NewMenuModel> productList = newMenuModelListFromJson(jsonEncode(data['data']));
        //
        // List<ProductVariantModel> newProductList = productVariantModelFromJson(jsonEncode(data['data']));

        print("Actual product Variant: ${menuData}");


        // NewMenuModel newMenuModel = NewMenuModel.fromJson(json.decode(data['data']));
        // save to local db
        // await productVariantDB.insertObject(productList);

        // print("The new menu model: $productList");
        if (menuData.isNotEmpty) {
          for (int i = 0; i < menuData.length; i++) {
            // parse and save  menu items to menu db
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
              brand: menuData[i]['brand'].toString(),
              quantity: menuData[i]['quantity'].toString(),
            );

            // save to local db
            await menuDB.insertObject(menuModel);
            print("Item insertion into MenuDB");

            var productVariantList = menuData[i]['productVariants'] as List;
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
              await productVariantDB.insertObject(productVariantModel);
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
              await productSpecificationDB.insertObject(productSpecificationModel);
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
                  details: productDetailsList[m]['details']
              );
              print("ProductDetailsModel: ${productDetailsModel}");
              // save to local db
              await productDetailsDB.insertObject(productDetailsModel);
              print("Item insertion into productDetailsDB");

            }

          }
        }

        // EasyLoading.dismiss();
        EasyLoading.show(status: 'Processing...');

        List<MenuModel> list = await menuDB.getAllMenu();
        // Navigator.of(context).pop();

        if (list.isNotEmpty) {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => Index(),
          //   ),
          // );

          // fetchLikesData(context);
          fetchConfigData(context);
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

  void fetchLikesData(BuildContext context) async {
    try {
      // EasyLoading.showProgress(0.25, status: 'loading...');
      NetworkUtility networkUtility = NetworkUtility();
      Response response = await networkUtility.getDataWithAuth(
          url: '${FETCH_LIKES_DATA}/HQ/email/${userModel.email}',
          auth: ACCESS_TOKEN_FOR_REQUEST);

      if (response.statusCode == 200 && response != null) {
        var data = jsonDecode(response.body);
        var list = data['data'] as List;
        if (list.isNotEmpty) {
          //clear db
          await likesDB.deleteAll();
          for (int i = 0; i < list.length; i++) {
            LikeModel likeData = LikeModel(
              menuId: list[i]['menuId'],
              likes: list[i]['likes'],
              branch: list[i]['branch'],
              organization: list[i]['organization'],
              email: list[i]['email'],
            );
            await likesDB.insertObject(likeData);
          }
        }
      }
      Navigator.of(context, rootNavigator: true).pop();

      EasyLoading.dismiss();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Index(),
        ),
      );
    } catch (e) {
      debugPrint('fetch likes data error: $e');
      Navigator.of(context, rootNavigator: true).pop();
      EasyLoading.dismiss();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Index(),
        ),
      );
    }
  }

  void fetchConfigData(BuildContext context) async {
    try {
      EasyLoading.showProgress(0.50, status: 'Setting Up...');
      NetworkUtility networkUtility = NetworkUtility();
      Response response = await networkUtility.getDataWithAuth(
          url: '${FETCH_CONFIGURATIONS_BY_BRANCH}/HQ',
          auth: ACCESS_TOKEN_FOR_REQUEST);

      print('config data: ${response.body}');

      if (response.statusCode == 200 && response != null) {
        var data = jsonDecode(response.body);
        var list = data as List;
        if (list.isNotEmpty) {
          //clear db
          await configDB.deleteAll();
          for (int i = 0; i < list.length; i++) {
            Config config = Config(
              // id: list[i]['id'],
              branch: list[i]['branch'],
              assignmentMode: list[i]['assignmentMode'],
              organization: list[i]['organization'],
              serviceCharge: list[i]['serviceCharge'],
              latitude: list[i]['latitude'],
              longitude: list[i]['longitude'],
            );
            await configDB.insertObject(config);
          }
        }
      }
      // Navigator.of(context, rootNavigator: true).pop();
      fetchDeliveryCharges(context);
    } catch (e) {
      debugPrint('fetch config data error: $e');
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  void fetchDeliveryCharges(BuildContext context) async {
    try {
      EasyLoading.showProgress(0.50, status: 'Almost Done...');
      NetworkUtility networkUtility = NetworkUtility();
      Response response = await networkUtility.getDataWithAuth(
          url: '${FETCH_DELIVERY_COST_BY_BRANCH}/HQ',
          auth: ACCESS_TOKEN_FOR_REQUEST);

      print('delivery charge data: ${response.body}');

      if (response.statusCode == 200 && response != null) {
        EasyLoading.showSuccess('Success!');
        var data = jsonDecode(response.body);
        var list = data as List;
        if (list.isNotEmpty) {
          //clear db
          await deliveryCostDB.deleteAll();
          for (int i = 0; i < list.length; i++) {
            DeliveryCost deliveryCost = DeliveryCost(
              id: list[i]['id'],
              branch: list[i]['branch'],
              minDistance: list[i]['minDistance'],
              organization: list[i]['organization'],
              maxDistance: list[i]['maxDistance'],
              cost: list[i]['cost'],
            );
            await deliveryCostDB.insertObject(deliveryCost);
          }
        }
      }
      fetchLikesData(context);
    } catch (e) {
      debugPrint('fetch likes data error: $e');
      Navigator.of(context, rootNavigator: true).pop();
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => Index(),
      //   ),
      // );
    }
  }

}
