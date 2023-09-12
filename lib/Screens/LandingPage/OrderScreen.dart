import 'dart:convert';

import 'package:apparel_options/Constants/constantColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

import 'package:provider/provider.dart';

import '../../Components/GenericCardComponent.dart';
import '../../Database/OrderDB.dart';
import '../../Database/UserDB.dart';
import '../../Model/AppData.dart';
import '../../Model/NewOrderModel.dart';
import '../../Model/UserProfileModel.dart';
import '../../Services/NetworkUtility.dart';
import '../../Utils/Utility.dart';
import '../../Utils/paths.dart';
import '../../index.dart';

class OrderScreen extends StatefulWidget {
  final bool? showBackButton;
  final bool? goToHome;
  const OrderScreen({Key? key, this.showBackButton, this.goToHome})
      : super(key: key);

  @override
  State<OrderScreen> createState() =>
      _OrderScreenState(showBackButton: showBackButton!, goToHome: goToHome);
}

class _OrderScreenState extends State<OrderScreen> {
  final bool? showBackButton;
  final bool? goToHome;
  List<NewOrderModel> orderList = [];
  int pending = 0;
  int progress = 0;
  int delivered = 0;
  int cancelled = 0;
  int total = 0;

  int step1 = 1;
  int step2 = 2;
  int step3 = 3;
  int step4 = 4;
  int step5 = 5;
  int step6 = 6;
  int step7 = 7;

  int upperBound = 7;
  int currentStep = 0;
  List<NewOrderModel> listOfOrders = [];
  List<NewOrderModel> foundItem = [];
  bool showSpinner = true;

  UserDB userDB = UserDB();
  OrderDB orderDB = OrderDB();
  UserProfileModel userProfileModel = UserProfileModel();

  @override
  void initState() {
    initDB();
    // TODO: implement initState
    super.initState();

  }

  void initDB() async {
    try {
      await userDB.initialize();
      await orderDB.initialize();

      await loadUserFromLocalStorage();
      await loadOrdersFromLocalStorage();

    } catch (e) {
      print("Error on init DB");
    }
  }


  Future<void> loadUserFromLocalStorage() async {
    List<UserProfileModel> users = await userDB.getAllUsers();
    if (users.isNotEmpty) {
      setState(() {
        userProfileModel = users.first;
      });
    }
    print(
        'userProfileModel after load up: ${userProfileModel.phone.toString()}');
  }

  Future<void> loadOrdersFromLocalStorage() async {
    List<NewOrderModel> orders = await orderDB
        .getOrdersByPhone(int.parse(userProfileModel.phone!).toString());
    setState(() {
      orderList = orders;
    });
    print('initial order list after load up: $orderList');

    if (orderList.isEmpty) {
      fetchOrderListWithLoader();
    } else {
      setState(() {
        showSpinner = false;
        listOfOrders = orderList;
      });
    }
  }

  void _runFilter(String enteredKeyword) {
    List<NewOrderModel> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = orderList;
    } else {
      results = orderList
          .where((item) =>
          item.orderNo!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      setState(() {
        orderList = results;
      });
    }

    // Refresh the UI

    print('listOfOrders after: $orderList');
  }

  _OrderScreenState({this.showBackButton, this.goToHome});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: (showBackButton!)
            ? IconButton(
                onPressed: () {
                  (goToHome != null && goToHome == true)
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Index(),
                          ),
                        )
                      : Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 19,
                  color: Colors.black,
                ),
              )
            : Container(),
        centerTitle: true,
        backgroundColor: Colors.grey.shade50,
        elevation: 0.2,
        automaticallyImplyLeading: false,
        title: Text(
          "MY ORDERS",
          style: GoogleFonts.raleway(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            letterSpacing: .75,
          ),
        ),
      ),
      body: RefreshIndicator(
        displacement: 100,
        color: Colors.teal,
        strokeWidth: 1,
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        onRefresh: () async {
          fetchOrderListWithLoader();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 12, left: 8, right: 8, bottom: 2),
                child: Container(
                  height: 40,
                  child: TextField(
                    keyboardType: TextInputType.numberWithOptions(),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        _runFilter(value);
                      } else {
                        setState(() {
                          // fetchOrderListWithLoader();
                          orderList = listOfOrders;
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
                      focusedBorder:  OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(19)),
                        borderSide: BorderSide(color: Colors.black, width: 0.3),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: GenericCardComponent(
                    borderRadius: 10,
                    // backgroundColor: kPrimaryTextColor,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Track My Order(s)',
                            style: GoogleFonts.lato(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              // decoration: TextDecoration.underline,
                            ),
                          ),
                          SizedBox(
                            child: Divider(
                              thickness: 1.0,
                            ),
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Container(
                              child: Image.asset(
                                'assets/images/orderImage.png',
                                height: 100,
                              ),
                            ),
                          ),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      "$pending",
                                      style: GoogleFonts.lato(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      'PENDING',
                                      style: GoogleFonts.lato(
                                        color: Colors.orangeAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      '$progress',
                                      style: GoogleFonts.lato(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      'IN-PROGRESS',
                                      style: GoogleFonts.lato(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      '$delivered',
                                      style: GoogleFonts.lato(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      'DELIVERED',
                                      style: GoogleFonts.lato(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      '$cancelled',
                                      style: GoogleFonts.lato(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      'CANCELLED',
                                      style: GoogleFonts.lato(
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 7, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => OrderTrackingPage()));
                        // await fetchRiderLocationData(context, );
                      },
                      child: Container(
                        child: Text(
                          "My Orders - $total",
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 14),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          orderList.clear();
                        });
                        print("Cleared");
                      },
                      child: Container(
                        child: Text(
                          "Clear all",
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                              fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: Divider(
                  thickness: 0.2,
                  color: Colors.black54,
                ),
              ),
              Column(
                children: (showSpinner)
                    ? [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: CircularProgressIndicator(
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                ]
                    : loadOrderList(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void fetchOrderListWithLoader() async {
    try {
      setState(() {
        showSpinner = true;
      });

      NetworkUtility networkUtility = NetworkUtility();
      Response? response = await networkUtility.getDataWithAuth(
          url: '${FETCH_LIST_OF_ORDERS_BY_EMAIL}/${userProfileModel.email}',
          auth: 'Bearer $ACCESS_TOKEN');
      print(
          "The url: ${FETCH_LIST_OF_ORDERS_BY_EMAIL}/${userProfileModel.email}");

      debugPrint('order response: ${response!.body}');

      print("UserModel email: ${userProfileModel.email}");
      if (response!.statusCode == 200 && response != null) {
        //parse data received
        var data = jsonDecode(response.body);

        //order data
        var orderData = data['data'] as List;
        print("The order data: ${orderData}");
        if (orderData.isNotEmpty) {
          //clear db
          await orderDB.deleteAll();
          setState(() {
            progress = 0;
            pending = 0;
            delivered = 0;
            cancelled = 0;
            total = 0;

          });
          if (orderList != null) orderList.clear();
          for (int i = 0; i < orderData.length; i++) {
            NewOrderModel orderModel = new NewOrderModel(
              orderBy: orderData[i]['orderBy'],
              orderEmail: orderData[i]['orderEmail'].toString(),
              orderNo: orderData[i]['orderNo'].toString(),
              orderPhone: orderData[i]['orderPhone'].toString(),
              orderBranch: orderData[i]['orderBranch'].toString(),
              channel: orderData[i]['channel'].toString(),
              orderLon: orderData[i]['orderLon'],
              orderLat: orderData[i]['orderLat'],
              orderTotalAmount: orderData[i]['orderTotalAmount'],
              orderAddress: orderData[i]['orderAddress'],
              orderQuantity: orderData[i]['orderQuantity'],
              paymentStatus: orderData[i]['paymentStatus'].toString(),
              deliveryOption: orderData[i]['deliveryOption'].toString(),
              orderStatus: orderData[i]['orderStatus'].toString(),
              eta: orderData[i]['eta'].toString(),
              distance: orderData[i]['distance'].toString(),
              dispatcher: orderData[i]['dispatcher'].toString(),
              dispatcherPhone: orderData[i]['dispatcherPhone'].toString(),
            );

            if (orderModel.orderStatus == 'Pending') {
              setState(() {
                pending += 1;
              });
            }
            if (orderModel.orderStatus == 'Delivered') {
              setState(() {
                delivered += 1;
              });
            }
            if (orderModel.orderStatus == 'Cancelled') {
              setState(() {
                cancelled += 1;
              });
            }
            if (!(orderModel.orderStatus == 'Pending' ||
                orderModel.orderStatus == 'Delivered' ||
                orderModel.orderStatus == 'Cancelled')) {
              setState(() {
                progress += 1;
              });
            }

            setState(() {
              total = pending + progress + delivered + cancelled;
            });

            if (orderModel.orderStatus == 'Pending') {
              setState(() {
                currentStep = step1;
              });
            }
            if (orderModel.orderStatus == 'Progress') {
              setState(() {
                currentStep = step6;
              });
            }
            if (orderModel.orderStatus == 'Delivered') {
              setState(() {
                print(
                    "Dispatcher phone at delivered: ${orderModel.dispatcherPhone}");
                currentStep = step7;
              });
            }

            //save to local db
            await orderDB.insertObject(orderModel);
            setState(() {
              if (orderList != null) orderList.add(orderModel);
            });

            print("OrderList: ${orderList.length}");
            print(
                "Dispatcher phone number : ${orderModel.dispatcherPhone!.length}");
          }
          if (orderList != null) {
            setState(() {
              listOfOrders = orderList;
            });
          }
        }
      } else {
        UtilityService().showMessage(
          message: 'Sorry, an error occurred while fetching data',
          context: context,
          icon: const Icon(
            Icons.cancel,
            color: Colors.redAccent,
          ),
        );
      }
      setState(() {
        showSpinner = false;
      });
    } catch (e) {
      debugPrint('fetch order list data error: $e');
      setState(() {
        showSpinner = false;
      });
      UtilityService().showMessage(
        message: 'Sorry, an error occurred while order list',
        context: context,
        icon: const Icon(
          Icons.cancel,
          color: Colors.redAccent,
        ),
      );
    }
  }

  List<Column> loadOrderList(BuildContext context) {
    final cart = Provider.of<AppData>(context);
    List<Column> list = [];
    try {
      print("Order List in loadOrder: ${orderList}");

      if (orderList != null) {
        for (NewOrderModel order in orderList) {
          int curStep = 0;
          list.add(
            Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(
                        left: 4.0, right: 4, top: 0, bottom: 4),
                    child: GestureDetector(
                      onTap: () async {
                        if (order.orderStatus == 'Pending') {
                          curStep = 0;
                        }
                        if (order.orderStatus == 'Processing') {
                          curStep = 1;
                        }
                        if (order.orderStatus == 'Processed') {
                          curStep = 2;
                        }
                        if (order.orderStatus == 'Dispatched') {
                          curStep = 3;
                        }
                        if (order.orderStatus == 'PickedUp') {
                          curStep = 4;
                        }
                        if (order.orderStatus == 'Delivering') {
                          curStep = 5;
                        }
                        if (order.orderStatus == 'Delivered') {
                          curStep = 6;
                        }

                        // showMaterialModalBottomSheet(
                        //     context: context,
                        //     builder: (context) =>
                        //         StatefulBuilder(builder: (context, setState) {
                        //           return SingleChildScrollView(
                        //             physics: ClampingScrollPhysics(),
                        //             child: Column(
                        //               children: [
                        //                 Padding(
                        //                   padding: const EdgeInsets.only(
                        //                       top: 18.0, left: 10),
                        //                   child: Row(
                        //                     children: [
                        //                       Container(
                        //                         child: Text("Order No: ",
                        //                             style: GoogleFonts.raleway(
                        //                                 fontSize: 13,
                        //                                 color: Colors.black,
                        //                                 fontWeight:
                        //                                 FontWeight.w500)),
                        //                       ),
                        //                       Container(
                        //                         child: Text(
                        //                             order.orderNo.toString() ??
                        //                                 "",
                        //                             style: GoogleFonts.raleway(
                        //                                 fontSize: 15,
                        //                                 color: Colors.teal,
                        //                                 fontWeight:
                        //                                 FontWeight.w400)),
                        //                       ),
                        //                     ],
                        //                   ),
                        //                 ),
                        //                 Theme(
                        //                   data: ThemeData(
                        //                     colorScheme: Theme.of(context)
                        //                         .colorScheme
                        //                         .copyWith(
                        //                       primary: Colors.black,
                        //                       onPrimary: Colors
                        //                           .black, // <-- SEE HERE
                        //                     ),
                        //                   ),
                        //                   child: Stepper(
                        //                     controlsBuilder: (context, _) {
                        //                       return Container();
                        //                     },
                        //                     type: StepperType.vertical,
                        //                     steps: getSteps(curStep, order),
                        //                     currentStep: currentStep,
                        //                     onStepContinue: () {
                        //                       final isLastStep = currentStep ==
                        //                           getSteps(curStep, order)
                        //                               .length -
                        //                               1;
                        //                       if (isLastStep) {
                        //                         debugPrint("completed");
                        //                         //  Post data to server
                        //                       } else {
                        //                         setState(() {
                        //                           currentStep += 1;
                        //                         });
                        //                       }
                        //                     },
                        //                     onStepTapped: (step) =>
                        //                         setState(() {
                        //                           currentStep = step;
                        //                         }),
                        //                     onStepCancel: currentStep == 0
                        //                         ? null
                        //                         : () {
                        //                       setState(() {
                        //                         currentStep -= 1;
                        //                       });
                        //                     },
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //           );
                        //         }));
                      },
                      child: Card(
                        child: Container(
                          // height: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 5.0, right: 5, top: 15, bottom: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Text("Order No: ",
                                                      style:
                                                      GoogleFonts.raleway(
                                                          fontSize: 13,
                                                          color: Colors
                                                              .black54,
                                                          fontWeight:
                                                          FontWeight
                                                              .w500)),
                                                ),
                                                Container(
                                                  child: Text(
                                                      order.orderNo
                                                          .toString() ??
                                                          "",
                                                      style:
                                                      GoogleFonts.raleway(
                                                          fontSize: 13,
                                                          color: Colors
                                                              .black54,
                                                          fontWeight:
                                                          FontWeight
                                                              .w400)),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Text("Ordered Qty: ",
                                                      style:
                                                      GoogleFonts.raleway(
                                                          fontSize: 13,
                                                          color: Colors
                                                              .black54,
                                                          fontWeight:
                                                          FontWeight
                                                              .w500)),
                                                ),
                                                Container(
                                                  child: Text(
                                                      order.orderQuantity
                                                          .toString() ??
                                                          "-",
                                                      style:
                                                      GoogleFonts.raleway(
                                                          fontSize: 13,
                                                          color:
                                                          Colors.black,
                                                          fontWeight:
                                                          FontWeight
                                                              .w400)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          thickness: 0.18,
                                          color: Colors.black,
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Text(
                                                      "Delivery Option:",
                                                      style:
                                                      GoogleFonts.raleway(
                                                          fontSize: 13,
                                                          color:
                                                          Colors.black,
                                                          fontWeight:
                                                          FontWeight
                                                              .w500)),
                                                ),
                                                Container(
                                                  child: Text(
                                                      order.deliveryOption!,
                                                      style:
                                                      GoogleFonts.raleway(
                                                          fontSize: 13,
                                                          color:
                                                          Colors.teal,
                                                          fontWeight:
                                                          FontWeight
                                                              .w400)),
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    child: Text(
                                                        "Delivery Location",
                                                        style:
                                                        GoogleFonts.raleway(
                                                            fontSize: 13,
                                                            color: Colors
                                                                .black,
                                                            fontWeight:
                                                            FontWeight
                                                                .w500)),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                        order.orderAddress!,
                                                        style:
                                                        GoogleFonts.raleway(
                                                            fontSize: 13,
                                                            color: Colors
                                                                .black54,
                                                            fontWeight:
                                                            FontWeight
                                                                .w300)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 13,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Text("Order Status: ",
                                                      style:
                                                      GoogleFonts.raleway(
                                                          fontSize: 13,
                                                          color:
                                                          Colors.black,
                                                          fontWeight:
                                                          FontWeight
                                                              .w500)),
                                                ),
                                                Container(
                                                  child: Text(
                                                      "${order.orderStatus}" ??
                                                          "-",
                                                      style:
                                                      GoogleFonts.raleway(
                                                          fontSize: 13,
                                                          color: (order.orderStatus !=
                                                              null &&
                                                              order.orderStatus ==
                                                                  'Pending')
                                                              ? Colors.black
                                                              : (order.orderStatus !=
                                                              null &&
                                                              order.orderStatus ==
                                                                  'Delivered')
                                                              ? Colors
                                                              .teal
                                                              : (order.orderStatus != null &&
                                                              order.orderStatus ==
                                                                  'Cancelled')
                                                              ? Colors
                                                              .deepOrangeAccent
                                                              : Colors
                                                              .blue,
                                                          fontWeight:
                                                          FontWeight
                                                              .w400)),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                              children: [
                                                Container(
                                                  child: Text("ETA :",
                                                      style:
                                                      GoogleFonts.raleway(
                                                          fontSize: 13,
                                                          color:
                                                          Colors.black,
                                                          fontWeight:
                                                          FontWeight
                                                              .w500)),
                                                ),
                                                Container(
                                                  child: Text(
                                                      "${order.eta} min" ?? "-",
                                                      style:
                                                      GoogleFonts.raleway(
                                                          fontSize: 13,
                                                          color: Colors
                                                              .black54,
                                                          fontWeight:
                                                          FontWeight
                                                              .w300)),
                                                ),
                                              ],
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
                      ),
                    ))
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

  List<Step> getSteps(int currentStep, NewOrderModel orderModel) => [
    Step(
      state: currentStep == 0
          ? StepState.indexed
          : (currentStep > 0)
          ? StepState.complete
          : StepState.disabled,
      isActive: currentStep >= 0,
      title: const Text("Pending"),
      content: Container(
        width: MediaQuery.of(context).size.width,
        // color: Colors.red,
        child: Padding(
            padding: const EdgeInsets.only(
                top: 0, left: 14, right: 14, bottom: 14),
            child: Text(
              "Your order is pending",
              style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontSize: 13),
            )),
      ),
    ),
    Step(
      state: currentStep == 1
          ? StepState.indexed
          : (currentStep > 1)
          ? StepState.complete
          : StepState.disabled,
      isActive: currentStep >= 1,
      title: const Text("Processing"),
      content: Container(
        width: MediaQuery.of(context).size.width,
        // color: Colors.red,
        child: Padding(
            padding: const EdgeInsets.only(
                top: 0, left: 14, right: 14, bottom: 14),
            child: Text(
              "Your order is being processed",
              style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontSize: 13),
            )),
      ),
    ),
    Step(
      state: currentStep == 2
          ? StepState.indexed
          : (currentStep > 2)
          ? StepState.complete
          : StepState.disabled,
      isActive: currentStep >= 2,
      title: const Text("Processed"),
      content: Container(
        width: MediaQuery.of(context).size.width,
        // color: Colors.red,
        child: Padding(
            padding: const EdgeInsets.only(
                top: 0, left: 14, right: 14, bottom: 14),
            child: Text(
              "Your order has been processed successfully",
              style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontSize: 13),
            )),
      ),
    ),
    Step(
      state: currentStep == 3
          ? StepState.indexed
          : (currentStep > 3)
          ? StepState.complete
          : StepState.disabled,
      isActive: currentStep >= 3,
      title: const Text("Assigned to rider"),
      content: Container(
        width: MediaQuery.of(context).size.width,
        // color: Colors.red,
        child: Padding(
            padding: const EdgeInsets.only(
                top: 0, left: 14, right: 14, bottom: 14),
            child: Text(
              "Your order has been assigned to a rider",
              style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontSize: 13),
            )),
      ),
    ),
    // Step(
    //   state: currentStep == 4
    //       ? StepState.indexed
    //       : (currentStep > 4)
    //       ? StepState.complete
    //       : StepState.disabled,
    //   isActive: currentStep >= 4,
    //   title: const Text("Picked up by rider"),
    //   content: Container(
    //     width: MediaQuery.of(context).size.width,
    //     // color: Colors.red,
    //     child: Padding(
    //         padding: const EdgeInsets.only(
    //             top: 0, left: 14, right: 14, bottom: 14),
    //         child: Column(
    //           children: [
    //             Text(
    //               "Your order has been picked up by ${orderModel.dispatcher}",
    //               style: GoogleFonts.raleway(
    //                   fontWeight: FontWeight.w400,
    //                   color: Colors.black,
    //                   fontSize: 13),
    //             ),
    //             SizedBox(
    //               height: 7,
    //             ),
    //             GestureDetector(
    //               onTap: () {
    //                 _makePhoneCall(orderModel.dispatcherPhone.toString());
    //               },
    //               child: Container(
    //                 height: 37,
    //                 width: 120,
    //                 child: Center(
    //                   child: Text(
    //                     "Call Rider",
    //                     style: GoogleFonts.raleway(
    //                         fontWeight: FontWeight.w400,
    //                         fontSize: 16,
    //                         color: Colors.white),
    //                   ),
    //                 ),
    //                 decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(5),
    //                     color: Colors.teal),
    //               ),
    //             )
    //           ],
    //         )),
    //   ),
    // ),
    // Step(
    //   state: currentStep == 5
    //       ? StepState.indexed
    //       : (currentStep > 5)
    //       ? StepState.complete
    //       : StepState.disabled,
    //   isActive: currentStep >= 5,
    //   title: const Text("Delivering"),
    //   content: Container(
    //     width: MediaQuery.of(context).size.width,
    //     // color: Colors.red,
    //     child: Column(
    //       children: [
    //         Padding(
    //             padding: const EdgeInsets.only(
    //                 top: 4.0, left: 4, right: 4, bottom: 14),
    //             child: Text(
    //               "Your order is being delivered",
    //               style: GoogleFonts.raleway(
    //                   fontWeight: FontWeight.w400,
    //                   color: Colors.black,
    //                   fontSize: 13),
    //             )),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             GestureDetector(
    //               onTap: () async {
    //                 await fetchRiderLocationData(
    //                     context, orderModel.dispatcherPhone);
    //                 // Navigator.push(context,
    //                 //     MaterialPageRoute(builder: (context) => TrackMap()));
    //               },
    //               child: Container(
    //                 height: 35,
    //                 width: 100,
    //                 decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(5),
    //                     color: Colors.teal),
    //                 child: Center(
    //                     child: Text(
    //                       "View on Map",
    //                       style: GoogleFonts.raleway(
    //                           fontSize: 14,
    //                           color: Colors.white,
    //                           fontWeight: FontWeight.w500),
    //                     )),
    //               ),
    //             ),
    //             GestureDetector(
    //               onTap: () {
    //                 _makePhoneCall(orderModel.dispatcherPhone.toString());
    //               },
    //               child: Container(
    //                 height: 37,
    //                 width: 120,
    //                 child: Center(
    //                   child: Text(
    //                     "Call Rider",
    //                     style: GoogleFonts.raleway(
    //                         fontWeight: FontWeight.w400,
    //                         fontSize: 16,
    //                         color: Colors.white),
    //                   ),
    //                 ),
    //                 decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(5),
    //                     color: Colors.teal),
    //               ),
    //             )
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // ),
    Step(
      state: currentStep == 6
          ? StepState.indexed
          : (currentStep > 6)
          ? StepState.complete
          : StepState.disabled,
      isActive: currentStep >= 6,
      title: const Text("Delivered"),
      content: Container(
        width: MediaQuery.of(context).size.width,
        // color: Colors.red,
        child: Padding(
            padding: const EdgeInsets.only(
                top: 0, left: 14, right: 14, bottom: 14),
            child: Text(
              "Your order has been delivered successfully",
              style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w500,
                  color: Colors.teal,
                  fontSize: 14),
            )),
      ),
    ),
  ];
}
