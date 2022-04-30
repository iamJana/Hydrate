import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:day_night_time_picker/lib/constants.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:dog/dog.dart';
import 'package:flutter/material.dart';
import 'package:hydrate/main.dart';
import 'package:hydrate/screens/mainScreen.dart';
import 'package:hydrate/utils/notification.dart';
import 'package:hydrate/utils/sharedpref.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String> timeList = List.filled(4, '9:00 AM', growable: false);
List<String> checkBoxListString = List.filled(4, 'false', growable: false);
List<bool> checkBoxListBool = List.filled(4, false, growable: false);
List<bool> convertedBool = List.filled(4, false, growable: false);
List<String> convertedString = List.filled(4, 'false', growable: false);

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

int vid = 0;

class _TimecardState extends State<Timecard> {
  @override
  void initState() {
    super.initState();
    if (pref.containsKey('Time')) {
      getTime();
      dog.i("SharedPreference of time list $getTime");
    } else {
      dog.v("No time sharedpreference stored ");
    }
    if (pref.containsKey('checkbox')) {
      getCheckBox();
      dog.i("SharedPreference of check list $getCheckBox");
    } else {
      dog.v("No time sharedpreference stored ");
    }
    if (pref.containsKey('watervalue')) {
      getWaterLevel();
      dog.i(" WaterValue contains in sharedPreferences");
    }
  }

  TimeOfDay _time = TimeOfDay.now();
  bool checkBox = false;

  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
      dog.i(" onTimeChanged ${_time.format(context).toString()}");
      timeList[widget.index] = _time.format(context).toString();
      // timeList[widget.index]= _time.format(context).toString());
      dog.i("Time List length ${timeList.length}");
      dog.i("Time Hour ${_time.hour}");
      dog.i("Time Minute ${_time.minute}");

      final now = DateTime.now();
      DateTime todaysTime =
          DateTime(now.year, now.month, now.day, _time.hour, _time.minute);
      notification(todaysTime, widget.index);

      setTime(timeList);
    });
  }

  void onCheckBoxChanged(bool? newValue) {
    setState(() {
      checkBoxListBool[widget.index] = newValue!;
      parseString(checkBoxListBool);
      dog.i("bool list $checkBoxListBool");
      setCheckBox(convertedString);
      dog.i("setcheck box $convertedString");
      if (checkBoxListBool[widget.index]) {
        if (widget.index == 0) {
          waterValue.value += 0.25;
        } else if (widget.index == 1) {
          waterValue.value += 0.25;
        } else if (widget.index == 2) {
          waterValue.value += 0.25;
        } else {
          waterValue.value += 0.25;
        }
      } else {
        if (waterValue.value > 0) {
          waterValue.value -= 0.25;
        }
      }
      setWaterLevel(waterValue.value);
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
                  minuteInterval: MinuteInterval.ONE,
                  // Optional onChange to receive value as DateTime
                ));
              },
            ),
            Checkbox(
              activeColor: Colors.green,
              value: checkBoxListBool[widget.index],
              onChanged: onCheckBoxChanged,
            )
          ],
        ),
      ),
    );
  }

  Future<void> setTime(List<String> timeList) async {
    Prefs.setStringList('Time', timeList);
    dog.i("Time list in set time $timeList");
  }

  void getTime() async {
    timeList = Prefs.getStringList('Time')!;
    dog.i("Time list in get time $timeList");
    setState(() {});
  }

  void setCheckBox(List<String> checkBoxList) async {
    Prefs.setStringList('checkbox', convertedString);
  }

  void getCheckBox() async {
    convertedString = Prefs.getStringList('checkbox')!;
    parseBool(convertedString);
    setState(() {});
  }

  void setWaterLevel(double value) async {
    Prefs.setDouble('watervalue', value);
  }

  void getWaterLevel() async {
    waterValue.value = Prefs.getDouble('watervalue')!;
    setState(() {});
  }
}

void alarmCheck() {
  createRemainderNotification();

  final DateTime now = DateTime.now();
  dog.i("Alarm Alarmed $now");
}

parseBool(List<String> list) {
  for (int i = 0; i < list.length; i++) {
    if (list[i] == 'true') {
      convertedBool[i] = true;
    } else {
      convertedBool[i] = false;
    }
  }
  checkBoxListBool = convertedBool;
}

parseString(List<bool> list) {
  for (int i = 0; i < list.length; i++) {
    if (list[i] == true) {
      convertedString[i] = 'true';
    } else {
      convertedString[i] = 'false';
    }
  }
}

notification(DateTime time, int id) {
  AndroidAlarmManager.oneShotAt(time, id, createRemainderNotification);
}
