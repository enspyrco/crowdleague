import 'package:crowdleague/utils/locator.dart';
import 'package:crowdleague/you/check-in/check_in_service.dart';
import 'package:flutter/material.dart';

import '../../utils/widgets/divider_with_subheading.dart';
import 'widgets/venues_search.dart';

const double kUpperRangeValue = 1440; // mins in day = 24 * 60
const int kNumDivisions = 288; // num divisions containing 5 mins = 24 * 60 / 5
const int kMinsInHalfDay = 720;
const int kMinsInHour = 60;
const double kInitialDuration = 180;

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  String? _selectedVenueId;

  // Slider state variables
  double _startValue = 0;
  RangeValues _currentRangeValues = RangeValues(0, kUpperRangeValue);
  RangeLabels _rangeLabels = RangeLabels('', '');
  String _roughStart = 'Now';
  String _roughDuration = 'for about 3 hours';

  @override
  void initState() {
    super.initState();

    // Calculate the initial start value of the slider, ie. the minutes passed today
    _startValue =
        (DateTime.now().hour * kMinsInHour + DateTime.now().minute).toDouble();
    // Start at the nearest 5 min increment so the "In x minutes" text is a multiple of 5
    _startValue = (_startValue / 5).round() * 5;

    // Calculate the initial end value of the slider as a pre-set duration from the start
    double endValue = (DateTime.now().hour * kMinsInHour +
        DateTime.now().minute +
        kInitialDuration);
    // Check if the duration has gone over the end of the day
    if (endValue > kUpperRangeValue) endValue = kUpperRangeValue;

    // Set the start and end values of the slider
    _currentRangeValues =
        RangeValues(_startValue.floorToDouble(), endValue.floorToDouble());
  }

  // A callback passed in to the VenuesSearch widget
  void _updateSelectedVenueId(String id) {
    setState(() {
      _selectedVenueId = id;
    });
  }

  // Convert each range value into a corresponding time string for range labels
  void _updateRangeLabels(RangeValues values) {
    // A nested function that converts the number of minutes into a string of
    // the form "1:25 pm".
    String convertToTimeString(double minutes) {
      String startMinutes =
          (minutes % kMinsInHour).round().toString().padLeft(2, '0');
      String startHours;
      String timeOfDay;
      if (minutes < kMinsInHalfDay) {
        startHours = (minutes / kMinsInHour).floor().toString();
        if (startHours == '0') startHours = '12';
        timeOfDay = 'am';
      } else {
        startHours =
            ((minutes - kMinsInHalfDay) / kMinsInHour).floor().toString();
        timeOfDay = 'pm';
      }

      return '$startHours:$startMinutes $timeOfDay';
    }

    String startTime = convertToTimeString(values.start);
    String endTime = convertToTimeString(values.end);

    _rangeLabels = RangeLabels(startTime, endTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check In'),
      ),
      body: Column(
        children: [
          const DividerWithSubheading('Location'),
          VenuesSearch(setVenueIdCallback: _updateSelectedVenueId),
          const DividerWithSubheading('Time'),
          RangeSlider(
            values: _currentRangeValues,
            max: kUpperRangeValue,
            divisions: kNumDivisions,
            labels: _rangeLabels,
            onChangeEnd: (values) {
              // if the slider slides backward past current time, reset to now
              setState(() {
                if (values.start <= _startValue) {
                  _currentRangeValues =
                      RangeValues(_startValue.toDouble(), values.end);

                  // Calculate the rough duration string
                  _roughStart = 'Now';
                  double durationMins = values.end - _startValue.toDouble();
                  int durationHours = (durationMins / kMinsInHour).floor();
                  _roughDuration = 'for about $durationHours hours';
                }
              });
            },
            onChanged: (RangeValues values) {
              setState(() {
                _currentRangeValues = values;

                // Calculate the rough duration string
                double durationMins = values.end - values.start;
                _roughStart = 'In ${(values.start - _startValue).round()} mins';
                int durationHours = (durationMins / kMinsInHour).floor();
                _roughDuration = 'for about $durationHours hours';

                _updateRangeLabels(_currentRangeValues);
              });
            },
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Text(_roughStart),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: Text(_roughDuration),
              ),
            ],
          ),
          SizedBox(height: 35),
          OutlinedButton(
            onPressed: _selectedVenueId == null
                ? null
                : () {
                    // Get a DateTime for the start of today
                    DateTime today = DateTime.now();
                    today = today.subtract(Duration(
                        minutes: today.hour * kMinsInHour + today.minute));

                    // Add the sliders start value to get to the start time
                    DateTime startTime = today.add(
                        Duration(minutes: _currentRangeValues.start.round()));

                    final checkInDuration = Duration(
                        minutes: (_currentRangeValues.end -
                                _currentRangeValues.start)
                            .round());

                    locate<CheckInService>().createCheckIn(
                      _selectedVenueId!,
                      startTime,
                      checkInDuration,
                    );
                  },
            style: ButtonStyle(
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            child: Text('Check In'),
          ),
        ],
      ),
    );
  }
}
