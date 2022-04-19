import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:day_night_time_picker/lib/constants.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:dog/dog.dart';
import 'package:flutter/material.dart';
import 'package:hydrate/screens/mainScreen.dart';
import 'package:hydrate/utils/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class Timecard extends StatefulWidget {
  int index;

  Timecard({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<Timecard> createState() => _TimecardState();
}

class _TimecardState extends State<Timecard> {
  @override
  void initState() {
    super.initState();
    getTime();
    int vid = createUniqueId();

    AndroidAlarmManager.periodic(
      const Duration(minutes: 10),
      vid,
      createRemainderNotification,
    );
  }

  List<String> timeList = List.filled(4, '9:00 AM', growable: false);

  TimeOfDay _time = TimeOfDay.now();
  bool checkBox = false;
  void onCheckBoxChanged(bool newValue) {
    setState(() {
      checkBox = newValue;
    });
  }

  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
      dog.i(" onTimeChanged ${_time.format(context).toString()}");
      timeList[widget.index] = _time.format(context).toString();
      // timeList.insert(widget.index, _time.format(context).toString());
      setTime(timeList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.lightBlue.shade50,
      child: SizedBox(
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              child: Text(
                // storedTime.isEmpty
                //     ? _time.format(context).toString()
                //     :
                timeList[widget.index],
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () async {
                setState(() {});
                Navigator.of(context).push(showPicker(
                  context: context,
                  value: _time,
                  onChange: onTimeChanged,
                  minuteInterval: MinuteInterval.TEN,
                  // Optional onChange to receive value as DateTime
                ));
              },
            ),
            Checkbox(
                activeColor: Colors.green,
                value: checkBox,
                onChanged: (bool? value) {
                  setState(() {
                    checkBox = value!;
                  });
                  if (checkBox) {
                    if (widget.index == 0) {
                      waterValue.value += 0.25;
                    } else if (widget.index == 1) {
                      waterValue.value += 0.25;
                    } else if (widget.index == 2) {
                      waterValue.value += 0.25;
                    } else {
                      waterValue.value += 0.25;
                    }
                  }
                  if (!checkBox) {
                    if (widget.index == 0) {
                      waterValue.value -= 0.25;
                    } else if (widget.index == 1) {
                      waterValue.value -= 0.25;
                    } else if (widget.index == 2) {
                      waterValue.value -= 0.25;
                    } else {
                      waterValue.value -= 0.25;
                    }
                  }
                }
                // RemainderScreenState().callBack();

                )
          ],
        ),
      ),
    );
  }

  Future<void> setTime(List<String> timeList) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setStringList('Time', timeList);
    dog.i("Time list in set time $timeList");
  }

  void getTime() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    timeList = pref.getStringList('Time')!;
    dog.i("Time list in get time $timeList");
    setState(() {});
  }
}

void alarmCheck() {
  createRemainderNotification();

  final DateTime now = DateTime.now();
  dog.i("Alarm Alarmed $now");
}
