import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../Database/UserDB.dart';
import '../../Index.dart';
import '../../Model/CheckOutModel.dart';
import '../../Model/UserProfileModel.dart';
import '../../Utils/NetworkUtility.dart';
import '../../Utils/Utility.dart';
import '../../Utils/paths.dart';

class PaymentScreen extends StatefulWidget {
  final CheckoutModel? checkoutModel;
  final String? clientReference;

  const PaymentScreen({this.checkoutModel, this.clientReference});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState(
      checkoutModel: checkoutModel!, clientReference: clientReference!);
}

class _PaymentScreenState extends State<PaymentScreen> {
  final CheckoutModel? checkoutModel;
  final String? clientReference;
  UserDB? userDB = UserDB();
  UserProfileModel? user = UserProfileModel();

  _PaymentScreenState({this.checkoutModel, this.clientReference});
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  @override
  void initState() {
    debugPrint("Check out: $checkoutModel");
    super.initState();
    initDB();
  }

  void initDB() async {
    await userDB!.initialize();

    List<UserProfileModel> list = await userDB!.getAllUsers();
    if (list.isNotEmpty) {
      setState(() {
        user = list.first;
        debugPrint('User Info: $user');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                    child: Container(
                      height: 34,
                      color: Colors.transparent,
                      child: Text(
                        "Please wait till payment is done before tapping the button below.",
                        style: GoogleFonts.raleway(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.black),
                        onPressed: () {
                          // Navigator.pop(context);
                          checkPaymentStatus(context, widget.clientReference!);
                        },
                        child: Text(
                          "Tap to Return",
                          style: GoogleFonts.raleway(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Payment",
          style: GoogleFonts.raleway(
              fontSize: 17, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () {
            checkPaymentStatus(context, widget.clientReference!);
          },
          icon: const Icon(Icons.arrow_back_ios_outlined,
              size: 19, color: Colors.black

              // color: Colors.white,
              ),
        ),
        actions: <Widget>[
          NavigationControls(_controller.future),
        ],
      ),
      // body: WebView(
      //   initialUrl: (checkoutModel != null && checkoutModel.checkoutURL != null)
      //       ? checkoutModel.checkoutURL
      //       : 0,
      //   javascriptMode: JavascriptMode.unrestricted,
      //   onWebViewCreated: (WebViewController webViewController) {
      //     _controller.complete(webViewController);
      //   },
      // ),
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(left: 20.0, right: 20),
      //   child: TextButtonComponent(
      //     onTap: (){},
      //     label: "Check Payment Status",
      //     labelColor: kPrimaryTheme,
      //     textColor: Colors.white,
      //     fontSize: 17.3,
      //   ),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void checkPaymentStatus(BuildContext context, String clientReference) async {
    try {
      // showDialog(
      //   context: context,
      //   builder: (context) {
      //     return ProgressDialog(displayMessage: 'Please wait...');
      //   },
      // );
      print("Category category: ${widget.clientReference}");
      NetworkUtility networkUtility = NetworkUtility();
      Response? response = await networkUtility.getDataWithAuth(
          url: '$CHECK_PAYMENT_STATUS/${checkoutModel!.clientReference}',
          auth: ACCESS_TOKEN_FOR_REQUEST);

      print("Client Reference: ${widget.clientReference}");

      debugPrint('Payment Status response: ${response!.body}');

      var data = jsonDecode(response.body);
      print("Data: ${data['data']}");

      if (response.statusCode == 404) {
        new UtilityService().confirmationBox(
            title: 'Payment confirmation not found',
            message: 'Are you sure you want to terminate process?',
            context: context,
            yesButtonColor: Colors.black,
            noButtonColor: Colors.teal,
            // color: Colors.blueAccent,
            onYes: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Index()));
            },
            onNo: () {
              Navigator.pop(context);
            });
      } else if (response.statusCode == 200) {
        if (data['data']['paymentStatus'] == 'Success') {
          successMessage(context);
        } else if (data['data']['paymentStatus'] == 'Fail') {
          new UtilityService().confirmationBox(
              title: 'Payment confirmation not found',
              message: 'Are you sure you want to terminate process?',
              context: context,
              yesButtonColor: Colors.black,
              noButtonColor: Colors.teal,
              // color: Colors.blueAccent,
              onYes: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Index()));
              },
              onNo: () {
                Navigator.pop(context);
              });
        }
      }
    } catch (e) {
      debugPrint('fetch payment status error: $e');
      UtilityService().showMessage(
        message: 'Sorry, an error occurred while checking payment status1111',
        context: context,
        icon: const Icon(
          Icons.cancel,
          color: Colors.redAccent,
        ),
      );
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  Future successMessage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Success!!!",
              style: GoogleFonts.raleway(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            content: Text(
              "Payment successfully made!!!\n Your order is being processed. You would be notified shortly.",
              style: GoogleFonts.raleway(
                color: Colors.teal,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Index()),
                          (route) => false);
                },
                child: Text(
                  "Done",
                  style: GoogleFonts.raleway(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.0,
                  ),
                ),
              ),
            ],
          );
        });
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture)
      : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data!;
        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller.canGoBack()) {
                        await controller.goBack();
                      } else {
                        // ignore: deprecated_member_use
                        // Scaffold.of(context).showSnackBar(
                        //   const SnackBar(content: Text("No back history item")),
                        // );
                        return;
                      }
                    },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller.canGoForward()) {
                        await controller.goForward();
                      } else {
                        // ignore: deprecated_member_use
                        // Scaffold.of(context).showSnackBar(
                        //   const SnackBar(
                        //       content: Text("No forward history item")),
                        // );
                        return;
                      }
                    },
            ),
            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: !webViewReady
                  ? null
                  : () {
                      controller.reload();
                    },
            ),
          ],
        );
      },
    );
  }
}
