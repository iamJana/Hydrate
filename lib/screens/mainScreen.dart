import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

import 'package:hydrate/widgets/timecard.dart';

class RemainderScreen extends StatefulWidget {
  const RemainderScreen({Key? key}) : super(key: key);

  @override
  RemainderScreenState createState() => RemainderScreenState();
}



var waterValue = ValueNotifier(0.00);

class RemainderScreenState extends State<RemainderScreen> {
  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications()
            .requestPermissionToSendNotifications(channelKey: 'basic_channel')
            .then((_) => (Navigator.pop(context)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String time = DateFormat('hh:mm a').format(DateTime.now());

    return Scaffold(
      // backgroundColor: Colors.deepPurpleAccent.shade700,
      appBar: AppBar(
          backgroundColor: Colors.lightBlue.shade200,
          centerTitle: true,
          title: const Text(
            "Stay Hydrate",
            style: TextStyle(color: Colors.black),
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Center(
              child: SizedBox(
                  height: 180,
                  width: 180,
                  child: ValueListenableBuilder(
                    valueListenable: waterValue,
                    builder: (BuildContext context, value, Widget? child) {
                      return LiquidCircularProgressIndicator(
                        value: waterValue.value, // Defaults to 0.5.
                        valueColor: const AlwaysStoppedAnimation(Color(
                            0xffD4F1F9)), // Defaults to the current Theme's accentColor.
                        backgroundColor: Colors.white,
                        // Defaults to the current Theme's backgroundColor.
                        borderColor: Colors.blue,
                        borderWidth: 3.0,

                        direction: Axis
                            .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                        center: const Text("Loading..."),
                      );
                    },
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            Timecard(
              index: 0,
            ),
            const SizedBox(
              height: 10,
            ),
            Timecard(
              index: 1,
            ),
            const SizedBox(
              height: 10,
            ),
            Timecard(
              index: 2,
            ),
            const SizedBox(
              height: 10,
            ),
            Timecard(
              index: 3,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Done"),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Reset"),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
