import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

import '../../Constants/constantColors.dart';
import '../../Constants/myColors.dart';
import '../../Database/RatingDB.dart';

import '../../Database/UserDB.dart';
import '../../Index.dart';
import '../../Model/RatingModel.dart';

import '../../Model/UserModel.dart';
import '../../Utils/NetworkUtility.dart';
import '../../Utils/paths.dart';
import '../../config/Config.env.dart';
import '../../main.dart';
import 'explore.dart';


class RatingScreen extends StatefulWidget {
  // final RequestModel? requestModel;
  const RatingScreen({Key? key}) : super(key: key);

  @override
  State<RatingScreen> createState() =>
      _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  // final RequestModel? requestModel;
  var additionalCommentController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _RatingScreenState();

  String? additionalComment;
  RatingDB ratingDB = RatingDB();
  double? actualRating;

  UserModel userModel = UserModel();
  UserDB userDB = UserDB();
  UserModel newUserModel = UserModel();

  int pending = 0;
  int completed = 0;
  int progress = 0;
  int cancelled = 0;
  int total = 0;
  String? ratingMessage;
  bool? noRating;

  @override
  void initState() {
    actualRating = 0;
    noRating == false;
    initDB();
    super.initState();
  }

  void initDB() async {
    await ratingDB.initialize();
    await userDB.initialize();
    // await requestListDB.initialize();
    await loadUserFromLocalStorage();
  }

  Future<void> loadUserFromLocalStorage() async {
    // List<UserModel>? users = await userDB.getAllUsers();
    // if (users!.isNotEmpty) {
    //   setState(() {
    //     userModel = users.last;
    //     newUserModel = userModel;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    if(noRating == false){
      actualRating = 0;
    }
    return Scaffold(
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: GestureDetector(
            onTap: () async {
              // RatingModel ratingModel = RatingModel(
              //   agentName: requestModel!.agentName,
              //   companyName: requestModel!.companyName,
              //   rating: actualRating.toString(),
              //   comment: additionalComment,
              //   reviewer: userModel.phone,
              //   agentId: requestModel!.agentId,
              //   companyId: requestModel!.companyId,
              //   agentImage: requestModel!.agentPhoto,
              //   dateCreated: requestModel!.dateCreated,
              // );
              //
              // await sendRating(context, ratingModel);
              Navigator.pushReplacement(this.context,
                  MaterialPageRoute(builder: (context) => Index()));
              // await fetchAllRequest(context);
            },
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.amber,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 1,
                      spreadRadius: 2,
                      offset: Offset(1, 1.3),
                    ),
                  ]),
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Submit",
                      style: GoogleFonts.raleway(
                          fontSize: 18,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Rating",
          style: GoogleFonts.raleway(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: kPrimaryTextColor,
          ),
        ),
        leading: BackButton(
          onPressed: () {
            // Navigator.pushReplacement(this.context,
            //     MaterialPageRoute(builder: (context) => HomeScreen()));
          },
          color: kPrimaryTextColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            const SizedBox(
              height: 20,
            ),
            Card(
              child: Container(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 28.0, bottom: 20),
                          child: Text(
                            "Your feedback will help improve your customer experience?",
                            style: GoogleFonts.raleway(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            // overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    RatingBar.builder(
                      updateOnDrag: true,
                      itemSize: 50,
                      glow: true,
                      glowRadius: 20,
                      initialRating: 0,
                      minRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 5,
                      ),
                      onRatingUpdate: (rating) {
                        print("The rating sent:${actualRating}");
                        setState(() {
                          actualRating = rating;
                          if(rating == 0){
                            ratingMessage == "Kindly tap to rate agent";
                          } else if (rating == 0.5 || rating == 1) {
                            ratingMessage = "Very Bad";
                          } else if (rating == 1.5 || rating == 2) {
                            ratingMessage = "Bad";
                          } else if (rating == 2.5 || rating == 3) {
                            ratingMessage = "Good";
                          } else if (rating == 3.5 || rating == 4) {
                            ratingMessage = "Very Good";
                          } else if (rating == 4.5 || rating == 5) {
                            ratingMessage = "Excellent";
                          }
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: actualRating == 0
                          ? Container()
                          : Text(
                        "${ratingMessage!.toUpperCase()}",
                        style: GoogleFonts.raleway(
                          fontSize: 22,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        // overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 140,
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
                                fontWeight: FontWeight.w600),
                            controller: additionalCommentController,
                            onChanged: (value) {
                              additionalComment = value;
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide:
                                const BorderSide(color: Colors.black54, width: 0.0),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(6)),
                                borderSide:
                                BorderSide(color: Colors.black54, width: 1.5),
                              ),
                              hintText: "Comment...",
                              labelStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

  // Future<void> sendRating(BuildContext context, RatingModel dataModel) async {
  //   final config = await AppConfig.forEnvironment(envVar);
  //   try {
  //     EasyLoading.show(status: '');
  //     var jsonBody = jsonEncode(dataModel);
  //     NetworkUtility networkUtility = NetworkUtility();
  //     Response? response = await networkUtility.postDataWithAuth(
  //       url: '$ADD_RATING', auth: 'Bearer ${config.token}', body: jsonBody,);
  //     print("RESPONSE: ${response!.body}");
  //
  //     if (response == null) {
  //       EasyLoading.dismiss();
  //       //error handling
  //       ScaffoldMessenger.of(_scaffoldKey.currentContext!)
  //           .showSnackBar(SnackBar(
  //         content: Row(
  //           children: [
  //             const Icon(
  //               Icons.error,
  //               color: Colors.orange,
  //             ),
  //             SizedBox(
  //               width: 5,
  //             ),
  //             Text(
  //               "An error occurred while fetching car data",
  //               style: GoogleFonts.raleway(
  //                   fontSize: 14,
  //                   color: Colors.orangeAccent,
  //                   fontWeight: FontWeight.w600),
  //             ),
  //           ],
  //         ),
  //       ));
  //     } else {
  //       var data = jsonDecode(response.body);
  //       int status = data['status'];
  //       var ratingData = data['data'];
  //       print('Status: $status');
  //       print('Ratings : $ratingData');
  //       await ratingDB.deleteAll();
  //
  //       if (status == 500 || status == 404 || status == 403 || status == 400) {
  //         EasyLoading.dismiss();
  //         ScaffoldMessenger.of(_scaffoldKey.currentContext!)
  //             .showSnackBar(SnackBar(
  //           content: Row(
  //             children: [
  //               const Icon(
  //                 Icons.error,
  //                 color: Colors.orange,
  //               ),
  //               SizedBox(
  //                 width: 5,
  //               ),
  //               Text(
  //                 "An error occurred",
  //                 style: GoogleFonts.raleway(
  //                     fontSize: 14,
  //                     color: Colors.orangeAccent,
  //                     fontWeight: FontWeight.w600),
  //               ),
  //             ],
  //           ),
  //         ));
  //       } else if (status == 200) {
  //         EasyLoading.showSuccess('Done!');
  //         if (data['data'] != null) {
  //           // RatingModel ratingModel = RatingModel(
  //           //   agentId: data['data']['agentId'],
  //           //   agentName: data['data']['agentName'],
  //           //   agentImage: data['data']['agentImage'],
  //           //   companyName: data['data']['companyName'],
  //           //   companyId: data['data']['companyId'],
  //           //   rating: data['data']['rating'],
  //           //   comment: data['data']['comment'],
  //           //   reviewer: data['data']['reviewer'],
  //           //   dateCreated: data['data']['dateCreated'],
  //           // );
  //           // print("RATING MODEL:${ratingModel}");
  //           //
  //           // // await addCarDB.deleteAll();
  //           // await ratingDB.insertObject(ratingModel);
  //           print("Insertion in Rating Database");
  //         }
  //         ;
  //
  //         // Navigator.pushReplacement(this.context,
  //         //     MaterialPageRoute(builder: (context) => HomeScreen()));
  //
  //         ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
  //           backgroundColor: Colors.white,
  //           content: Row(
  //             children: [
  //               const Icon(
  //                 Icons.check_circle,
  //                 color: Colors.lightGreenAccent,
  //               ),
  //               SizedBox(
  //                 width: 5,
  //               ),
  //               Text(
  //                 "Success",
  //                 style: GoogleFonts.raleway(
  //                     fontSize: 14,
  //                     color: Colors.black54,
  //                     fontWeight: FontWeight.w600),
  //               ),
  //             ],
  //           ),
  //         ));
  //       }
  //       // Navigator.of(context, rootNavigator: true).pop();
  //       EasyLoading.dismiss();
  //     }
  //
  //     // Navigator.of(context, rootNavigator: true).pop();
  //   } catch (e) {
  //     EasyLoading.dismiss();
  //     // debugPrint('fetch car data error: $e');
  //     // ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(SnackBar(
  //     //   content: Row(
  //     //     children: [
  //     //       const Icon(Icons.error,color: Colors.orange,),
  //     //       SizedBox(width: 5,),
  //     //       Text("An error occurred",style: GoogleFonts.raleway(fontSize: 14,color: Colors.orangeAccent,fontWeight: FontWeight.w600),),
  //     //     ],
  //     //   ),
  //     // ));
  //     // Navigator.of(context, rootNavigator: true).pop();
  //   }
  // }

  // Future<void> fetchAllRequest(BuildContext context) async {
  //   final config = await AppConfig.forEnvironment(envVar);
  //   try {
  //     EasyLoading.show(status: '');
  //     NetworkUtility networkUtility = NetworkUtility();
  //     Response? response = await networkUtility.getDataWithAuth(
  //       url: '$config.fetchAllRequestUrl/${userModel.phone}',
  //       auth: 'Bearer ${config.token}',
  //     );
  //     print("RESPONSE: ${response!.body}");
  //
  //     if (response.statusCode == 500 ||
  //         response.statusCode == 404 ||
  //         response.statusCode == 403) {
  //       EasyLoading.dismiss();
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Row(
  //           children: [
  //             const Icon(
  //               Icons.error,
  //               color: Colors.orange,
  //             ),
  //             SizedBox(
  //               width: 5,
  //             ),
  //             Text(
  //               "An error occurred while fetching services",
  //               style: GoogleFonts.raleway(
  //                   fontSize: 14,
  //                   color: Colors.orangeAccent,
  //                   fontWeight: FontWeight.w600),
  //             ),
  //           ],
  //         ),
  //       ));
  //       EasyLoading.dismiss();
  //     } else if (response.statusCode == 200) {
  //       //clear db
  //       await requestListDB.deleteAll();
  //
  //       var data = jsonDecode(response.body);
  //       var requests = data['data'] as List;
  //       setState(() {
  //         progress = 0;
  //         pending = 0;
  //         completed = 0;
  //         cancelled = 0;
  //       });
  //
  //       if (requests.isNotEmpty) {
  //         for (int i = 0; i < requests.length; i++) {
  //           // parse and save  menu items to menu db
  //
  //           // RequestModel requestModel = RequestModel(
  //           //   serviceId: requests[i]['serviceId'],
  //           //   service: requests[i]['service'],
  //           //   description: requests[i]['description'],
  //           //   deliveryType: requests[i]['deliveryType'],
  //           //   deliveryAddress: requests[i]['deliveryAddress'],
  //           //   requestImage: requests[i]['requestImage'],
  //           //   customerName: requests[i]['customerName'],
  //           //   customerEmail: requests[i]['customerEmail'],
  //           //   customerPhone: requests[i]['customerPhone'],
  //           //   agentName: requests[i]['agentName'],
  //           //   agentPhoto: requests[i]['agentPhoto'],
  //           //   agentPhone: requests[i]['agentPhone'],
  //           //   companyName: requests[i]['companyName'],
  //           //   calloutFee: requests[i]['calloutFee'].toString(),
  //           //   professionalFee: requests[i]['professionalFee'].toString(),
  //           //   requestStatus: requests[i]['requestStatus'],
  //           //   dateCreated: requests[i]['dateCreated'],
  //           //   additionalInfo: requests[i]['additionalInfo'],
  //           //   deliveryLatitude: requests[i]['deliveryLatitude'],
  //           //   deliveryLongitude: requests[i]['deliveryLongitude'],
  //           //   requestId: requests[i]['requestId'].toString(),
  //           //   vehicleNumber: requests[i]['vehicleNumber'].toString(),
  //           //   cancellationDate: requests[i]['cancellationDate'].toString(),
  //           //   cancelledBy: requests[i]['cancelledBy'].toString(),
  //           //   cancellationReason: requests[i]['cancellationReason'].toString(),
  //           // );
  //           if (requestModel.requestStatus == 'completed') {
  //             setState(() {
  //               completed += 1;
  //             });
  //           }
  //           if (requestModel.requestStatus == 'cancelled') {
  //             setState(() {
  //               cancelled += 1;
  //             });
  //           }
  //           if (requestModel.requestStatus == 'on_site' ||
  //               requestModel.requestStatus == 'matched' ||
  //               requestModel.requestStatus == 'on_route' ||
  //               requestModel.requestStatus == 'awaiting_payment') {
  //             setState(() {
  //               progress += 1;
  //             });
  //           }
  //           requestModelList!.clear();
  //
  //           setState(() {
  //             total = completed + cancelled + progress;
  //           });
  //
  //           // save to local db
  //           if (requestModel.requestStatus == 'on_site' ||
  //               requestModel.requestStatus == 'matched' ||
  //               requestModel.requestStatus == 'on_route' ||
  //               requestModel.requestStatus == 'awaiting_payment' ||
  //               requestModel.requestStatus == 'cancelled' ||
  //               requestModel.requestStatus == 'completed') {
  //             setState(() {
  //               allRequestModel = requestModel;
  //             });
  //             await requestListDB.insertObject(allRequestModel);
  //           }
  //           setState(() {
  //             if (requestModelList != null)
  //               requestModelList!.add(allRequestModel);
  //           });
  //           EasyLoading.showSuccess('Done!');
  //           // Navigator.pushReplacement(this.context,
  //           //     MaterialPageRoute(builder: (context) => HomeScreen()));
  //           EasyLoading.dismiss();
  //           // }
  //         }
  //
  //         if (true) {
  //           // loadRequestFromDB();
  //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
  //                   "Request downloaded successfully",
  //                   style: GoogleFonts.raleway(
  //                       fontSize: 14,
  //                       color: Colors.black54,
  //                       fontWeight: FontWeight.w500),
  //                 ),
  //               ],
  //             ),
  //           ));
  //         }
  //       }
  //     }
  //     EasyLoading.dismiss();
  //   } catch (e) {
  //     debugPrint('fetch services data error: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Row(
  //         children: [
  //           const Icon(
  //             Icons.error,
  //             color: Colors.orange,
  //           ),
  //           SizedBox(
  //             width: 5,
  //           ),
  //           Text(
  //             "An error occurred while fetching requests",
  //             style: GoogleFonts.raleway(
  //                 fontSize: 14,
  //                 color: Colors.orangeAccent,
  //                 fontWeight: FontWeight.w600),
  //           ),
  //         ],
  //       ),
  //     ));
  //     Navigator.of(context, rootNavigator: true).pop();
  //   }
  // }
}
