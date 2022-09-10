import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationScreen extends StatefulWidget {
  final bool showBackButton;
  const NotificationScreen({
    Key key,
    this.showBackButton,
  }) : super(key: key);

  @override
  State<NotificationScreen> createState() =>
      _NotificationScreenState(showBackButton: showBackButton);
}

class _NotificationScreenState extends State<NotificationScreen> {
  final bool showBackButton;
  _NotificationScreenState({this.showBackButton});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: (showBackButton != null && showBackButton)
            ? IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  size: 19,
                  color: Colors.black54,
                ),
              )
            : Container(),
        backgroundColor: Colors.grey.shade50,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Notifications",
          style: GoogleFonts.raleway(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            color: Colors.black,
            letterSpacing: .75,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 2, top: 2, right: 5, left: 5),
                child: Center(
                  child: Text(
                    "There are no notifications",
                    style: GoogleFonts.raleway(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      letterSpacing: 0.3,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
