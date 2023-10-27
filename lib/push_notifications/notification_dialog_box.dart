import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../../Components/ProgressDialog.dart';
import '../../Constants/myColors.dart';
import '../../Database/UserDB.dart';
import '../../Model/AgentModel.dart';
import '../../Model/AppData.dart';
import '../../Model/ChargesModel.dart';
import '../../Model/CheckModel.dart';
import '../../Model/PaymentModel.dart';
import '../../Model/UserModel.dart';
import '../../Utils/NetworkUtility.dart';
import '../../Utils/Utility.dart';
// import '../../Utils/paths.dart';
import '../../config/Config.env.dart';
import '../../main.dart';

class NotificationDialogBox extends StatefulWidget {
  final String? subject;
  final String? content;
  final String? address;
  final String? requestId;
  final String? service;
  final String? agentId;
  final String? agentName;
  final String? companyName;

  NotificationDialogBox(
      {this.subject,
      this.content,
      this.address,
      this.requestId,
      this.service,
      this.agentId,
      this.agentName,
      this.companyName});

  @override
  State<NotificationDialogBox> createState() => _NotificationDialogBoxState();
}

class _NotificationDialogBoxState extends State<NotificationDialogBox> {
  ChargesModel chargesModel2 = ChargesModel();
  AgentModel newAgentModel = AgentModel();
  UserDB userDB = UserDB();
  UserModel userModel = UserModel();
  CheckoutModel checkoutModel = CheckoutModel();
  CheckoutModel? newCheckOutModel;

  @override
  void initState() {
    init();
    super.initState();
    // print(
        // "The request ID: ${Provider.of<AppData>(context, listen: false).requestNotification!.requestId.toString()}");
  }

  void init() async {
    // await fetchCallOutCharge(context);
    await userDB.initialize();
    // await fetchAgentByID(context);
    await loadUserFromLocalStorage();
  }

  // Future<void> fetchAgentByID(BuildContext context) async {
  //   final config = await AppConfig.forEnvironment(envVar);
  //   try {
  //     EasyLoading.show(status: 'Matching to agent...');
  //     NetworkUtility networkUtility = NetworkUtility();
  //     Response? response = await networkUtility.getDataWithAuth(
  //       url:
  //           '${config.fetchAgentByIdUrl}/${Provider.of<AppData>(context, listen: false).newAgentID}',
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
  //               "An error occurred while fetching charges",
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
  //       print("THE STATUS CODE IS 200");
  //       var data = jsonDecode(response.body);
  //       var agents = data['data'];
  //
  //       AgentModel agentModel = AgentModel(
  //         otherName: agents['otherName'],
  //         surname: agents['surname'],
  //         photo: agents['photo'],
  //         companyName: agents['companyName'],
  //         companyId: agents['companyId'].toString(),
  //         address: agents['address'],
  //       );
  //       print("Agent Model: $agentModel");
  //
  //       setState(() {
  //         newAgentModel = agentModel;
  //       });
  //
  //       print("NEW AGENT MODEL: $newAgentModel");
  //
  //       await fetchCallOutCharge(context);
  //
  //       EasyLoading.showSuccess('Done!');
  //
  //       EasyLoading.dismiss();
  //       //clear db
  //
  //       EasyLoading.dismiss();
  //       // }
  //     }
  //     EasyLoading.dismiss();
  //   } catch (e) {
  //     EasyLoading.dismiss();
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
  //             "An error occurred while fetching data",
  //             style: GoogleFonts.raleway(
  //                 fontSize: 14,
  //                 color: Colors.orangeAccent,
  //                 fontWeight: FontWeight.w600),
  //           ),
  //         ],
  //       ),
  //     ));
  //     // Navigator.of(context, rootNavigator: true).pop();
  //   }
  // }
  //
  // Future<void> fetchCallOutCharge(BuildContext context) async {
  //   final config = await AppConfig.forEnvironment(envVar);
  //   try {
  //     EasyLoading.show(status: 'Fetching charges...');
  //     NetworkUtility networkUtility = NetworkUtility();
  //     Response? response = await networkUtility.getDataWithAuth(
  //       url: config.fetchCallOutChargeUrl!,
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
  //               "An error occurred while fetching charges",
  //               style: GoogleFonts.raleway(
  //                   fontSize: 14,
  //                   color: Colors.orangeAccent,
  //                   fontWeight: FontWeight.w600),
  //             ),
  //           ],
  //         ),
  //       ));
  //       EasyLoading.dismiss();
  //     } else {
  //       var data = jsonDecode(response.body);
  //       var charges = data['data'] as List;
  //       print("charges***: $charges");
  //       if (charges.isNotEmpty) {
  //         for (int i = 0; i < charges.length; i++) {
  //           // parse and save  menu items to menu db
  //
  //           ChargesModel chargesModel = ChargesModel(
  //               id: charges[i]['id'],
  //               fee: charges[i]['fee'],
  //               type: charges[i]['type'],
  //               amount: charges[i]['amount'],
  //               createdBy: charges[i]['createdBy'],
  //               dateCreated: charges[i]['dateCreated']);
  //           print("Charges Model: $chargesModel");
  //
  //           setState(() {
  //             chargesModel2 = chargesModel;
  //           });
  //
  //           print("@@@@@@@@@@@@@@@@@@: $chargesModel2");
  //
  //           EasyLoading.showSuccess('Done!');
  //         }
  //       }
  //
  //       EasyLoading.dismiss();
  //       //clear db
  //
  //       EasyLoading.dismiss();
  //       // }
  //     }
  //     EasyLoading.dismiss();
  //   } catch (e) {
  //     EasyLoading.dismiss();
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
  //             "An error occurred while fetching data",
  //             style: GoogleFonts.raleway(
  //                 fontSize: 14,
  //                 color: Colors.orangeAccent,
  //                 fontWeight: FontWeight.w600),
  //           ),
  //         ],
  //       ),
  //     ));
  //     // Navigator.of(context, rootNavigator: true).pop();
  //   }
  // }

  Future<void> loadUserFromLocalStorage() async {
    List<UserModel>? users = (await userDB.getAllUsers()).cast<UserModel>();
    if (users!.isNotEmpty) {
      setState(() {
        userModel = users.first;
      });
    }
    print('userModel after load up: $userModel');
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.transparent,
      elevation: 1,
      child: Container(
        margin: const EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 14,
            ),
            //title
            Text(
              "Agent Details",
              style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.black54),
            ),
            const SizedBox(height: 14.0),
            const Divider(
              height: 3,
              endIndent: 13,
              indent: 13,
              thickness: 1.3,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  //origin location with icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Agent Name:",
                        style: GoogleFonts.raleway(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        widget.agentName != null
                            ? widget.agentName.toString()
                            : '-',
                        style: GoogleFonts.raleway(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 11,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Company:",
                        style: GoogleFonts.raleway(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        widget.companyName != null && widget.companyName != null
                            ? widget.companyName.toString()
                            : '-',
                        style: GoogleFonts.raleway(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 11,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Callout Charge: ",
                        style: GoogleFonts.raleway(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        chargesModel2 != null && chargesModel2.amount != null
                            ? chargesModel2.amount.toString()
                            : '-',
                        // ( "GHS ${chargesModel2.amount}") == null ? "loading..." :( "GHS ${chargesModel2.amount}"),
                        style: GoogleFonts.raleway(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryTheme),
                    onPressed: () async {
                      PaymentModel paymentModel = PaymentModel(
                          organizationCode: "MyFita",
                          organizationName: "MyFita",
                          branchCode: "MyFita",
                          branchName: "MyFita",
                          // name: userModel.firstName,
                          email: userModel.email!.trim(),
                          phone: userModel.phone,
                          // billNo: Provider.of<AppData>(context, listen: false)
                          //     .requestNotification!
                          //     .requestId
                          //     .toString(),
                          billAmount: chargesModel2.amount,
                          debitAmount: chargesModel2.amount,
                          billType: "Callout",
                          description: "Callout");

                      print("the payment Model:$paymentModel");

                      // await payCallOut(
                      //     context: context, dataModel: paymentModel);
                      print("CHECK OUT MoDEL: $newCheckOutModel");
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => PaymentScreen(
                      //               clientReference:
                      //                   newCheckOutModel!.clientReference,
                      //               checkoutModel: newCheckOutModel,
                      //             )));
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>CallOutChargeScreen(
                      // )));
                    },
                    child: Text(
                      "Pay Call out charge".toUpperCase(),
                      style: GoogleFonts.raleway(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future<void> payCallOut({
  //   BuildContext? context,
  //   PaymentModel? dataModel,
  // }) async {
  //   // final config = await AppConfig.forEnvironment(envVar);
  //   try {
  //     showDialog(
  //       context: context!,
  //       builder: (context) {
  //         return ProgressDialog(displayMessage: 'Please wait...');
  //       },
  //     );
  //
  //     print('payment request object: $dataModel');
  //
  //     var jsonBody = jsonEncode(dataModel);
  //     NetworkUtility networkUtility = NetworkUtility();
  //     Response? response = await networkUtility.postDataWithAuth(
  //         url: config.initiatePaymentUrl!,
  //         body: jsonBody,
  //         auth: 'Bearer ${config.token}');
  //
  //     print('payCallout response: ${response?.body}');
  //
  //     if (response == null) {
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
  //               "An error occurred",
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
  //       print('Status: $status');
  //
  //       if (status == 500 || status == 404 || status == 403) {
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
  //                 "Sorry, an error occurred",
  //                 style: GoogleFonts.raleway(
  //                     fontSize: 14,
  //                     color: Colors.orangeAccent,
  //                     fontWeight: FontWeight.w600),
  //               ),
  //             ],
  //           ),
  //         ));
  //       } else if (status == 200) {
  //         CheckoutModel? checkoutModel = CheckoutModel(
  //           checkoutURL: data['data']['checkoutURL'].toString(),
  //           checkoutDirectURL: data['data']['checkoutDirectURL'].toString(),
  //           clientReference: data['data']['clientReference'].toString(),
  //           checkoutID: data['data']['checkoutID'].toString(),
  //         );
  //         print("CHECKOUT MODEL in method: $checkoutModel");
  //
  //         setState(() {
  //           newCheckOutModel = checkoutModel;
  //         });
  //
  //         // if(mounted){
  //         //   showDialog(
  //         //       barrierDismissible: false,
  //         //       useSafeArea: true,
  //         //       context: _scaffoldKey.currentContext!,
  //         //       builder: (context) {
  //         //         return Container(
  //         //           child: WebView(
  //         //             initialUrl: (checkoutModel.checkoutURL),
  //         //             javascriptMode: JavascriptMode.unrestricted,
  //         //           ),
  //         //         );
  //         //       });
  //         // }
  //         Navigator.pop(context);
  //       }
  //     }
  //     Navigator.of(context, rootNavigator: true).pop();
  //   } catch (e) {
  //     print('postUserData error: $e');
  //     ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
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
  //             "Sorry, an error occurred",
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
  //
  // void checkPaymentStatus(BuildContext context, String clientReference) async {
  //   final config = await AppConfig.forEnvironment(envVar);
  //   try {
  //     // showDialog(
  //     //   context: context,
  //     //   builder: (context) {
  //     //     return ProgressDialog(displayMessage: 'Please wait...');
  //     //   },
  //     // );
  //     print("Category category: ${checkoutModel.clientReference}");
  //     NetworkUtility networkUtility = NetworkUtility();
  //     Response? response = await networkUtility.getDataWithAuth(
  //       url: '${config.checkPaymentStatusUrl}/${checkoutModel.clientReference}',
  //       auth: config.accessTokenForRequest!,
  //     );
  //
  //     print("Client Reference: ${checkoutModel.clientReference}");
  //
  //     debugPrint('Payment Status response: ${response?.body}');
  //
  //     var data = jsonDecode(response!.body);
  //     print("Data: ${data['data']}");
  //
  //     if (response.statusCode == 404) {
  //       showDialog(
  //           context: _scaffoldKey.currentContext!,
  //           builder: (context) {
  //             return AlertDialog(
  //               title: Center(
  //                 child: Text(
  //                   "Payment Confirmation not found",
  //                   style: GoogleFonts.raleway(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w600,
  //                     color: Colors.black,
  //                     letterSpacing: 0.3,
  //                   ),
  //                 ),
  //               ),
  //               content: Text(
  //                 "Are you sure you want to terminate process?",
  //                 style: GoogleFonts.raleway(
  //                   fontSize: 13,
  //                   fontWeight: FontWeight.w400,
  //                   color: Colors.black,
  //                   letterSpacing: 0.3,
  //                 ),
  //               ),
  //               actions: <Widget>[
  //                 Padding(
  //                   padding: const EdgeInsets.only(bottom: 8.0),
  //                   child: SizedBox(
  //                     height: 34,
  //                     child: ElevatedButton(
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: Colors.teal,
  //                       ),
  //                       onPressed: () async {
  //                         Navigator.pop(context);
  //                       },
  //                       child: Text(
  //                         "Yes",
  //                         style: GoogleFonts.raleway(
  //                           fontSize: 14,
  //                           fontWeight: FontWeight.w700,
  //                           color: Colors.white,
  //                           letterSpacing: 0.0,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.only(bottom: 8.0, right: 8),
  //                   child: SizedBox(
  //                     height: 34,
  //                     child: ElevatedButton(
  //                         style: ElevatedButton.styleFrom(
  //                           backgroundColor: kPrimaryTheme,
  //                         ),
  //                         onPressed: () {
  //                           Navigator.pop(context); //close Dialog
  //                         },
  //                         child: Text(
  //                           "No",
  //                           style: GoogleFonts.raleway(
  //                             fontSize: 14,
  //                             fontWeight: FontWeight.w700,
  //                             color: Colors.white,
  //                             letterSpacing: 0.0,
  //                           ),
  //                         )),
  //                   ),
  //                 )
  //               ],
  //             );
  //           });
  //     } else if (response.statusCode == 200) {
  //       if (data['data']['paymentStatus'] == 'Success') {
  //         successMessage(context);
  //       } else if (data['data']['paymentStatus'] == 'Fail') {
  //         showDialog(
  //             context: _scaffoldKey.currentContext!,
  //             builder: (context) {
  //               return AlertDialog(
  //                 title: Center(
  //                   child: Text(
  //                     "Payment Confirmation not found",
  //                     style: GoogleFonts.raleway(
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.w600,
  //                       color: Colors.black,
  //                       letterSpacing: 0.3,
  //                     ),
  //                   ),
  //                 ),
  //                 content: Text(
  //                   "Are you sure you want to terminate process?",
  //                   style: GoogleFonts.raleway(
  //                     fontSize: 13,
  //                     fontWeight: FontWeight.w400,
  //                     color: Colors.black,
  //                     letterSpacing: 0.3,
  //                   ),
  //                 ),
  //                 actions: <Widget>[
  //                   Padding(
  //                     padding: const EdgeInsets.only(bottom: 8.0),
  //                     child: SizedBox(
  //                       height: 34,
  //                       child: ElevatedButton(
  //                         style: ElevatedButton.styleFrom(
  //                           backgroundColor: Colors.teal,
  //                         ),
  //                         onPressed: () async {
  //                           Navigator.pop(context);
  //                         },
  //                         child: Text(
  //                           "Yes",
  //                           style: GoogleFonts.raleway(
  //                             fontSize: 14,
  //                             fontWeight: FontWeight.w700,
  //                             color: Colors.white,
  //                             letterSpacing: 0.0,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.only(bottom: 8.0, right: 8),
  //                     child: SizedBox(
  //                       height: 34,
  //                       child: ElevatedButton(
  //                           style: ElevatedButton.styleFrom(
  //                             backgroundColor: kPrimaryTheme,
  //                           ),
  //                           onPressed: () {
  //                             Navigator.pop(context); //close Dialog
  //                           },
  //                           child: Text(
  //                             "No",
  //                             style: GoogleFonts.raleway(
  //                               fontSize: 14,
  //                               fontWeight: FontWeight.w700,
  //                               color: Colors.white,
  //                               letterSpacing: 0.0,
  //                             ),
  //                           )),
  //                     ),
  //                   )
  //                 ],
  //               );
  //             });
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint('fetch payment status error: $e');
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
  //             "Sorry, an error occurred",
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
