import 'dart:convert';
import 'dart:developer';

import 'package:activities/activity_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CriteriaWidget extends StatefulWidget {
  const CriteriaWidget({Key? key}) : super(key: key);

  @override
  State<CriteriaWidget> createState() => _CriteriaWidgetState();
}

class _CriteriaWidgetState extends State<CriteriaWidget> {
  var accessibility = [0.0, 0.3];
  var price = [0.0, 0.5];
  var participants = 1;

  var accessibilityStr = 'Easy';
  var priceStr = 'Free';

  Future<ActivityModel> findActivity() async {
    final query = 'http://www.boredapi.com/api/activity?'
        'minaccessibility=${accessibility[0]}'
        '&maxaccessibility=${accessibility[1]}'
        '&minprice=${price[0]}'
        '&maxprice=${price[1]}'
        '&participants=$participants';
    log(query);
    final response = await http.get(Uri.parse(query));
    if (response.statusCode == 200) {
      final thisJson = jsonDecode(response.body);
      if (thisJson['error'] != null) {
        return ActivityModel(activity: 'No matching activities', type: 'error');
      }
      final activity = ActivityModel.fromJson(thisJson);
      log(activity.activity);
      log(activity.type);
      return activity;
    } else {
      return ActivityModel(activity: 'Unable to reach server', type: 'error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Max Accessibility'),
          DropdownButton(
            value: accessibilityStr,
            items: ['Easy', 'Medium', 'Hard'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (value) {
              switch (value) {
                case 'Easy':
                  accessibility = [0.0, 0.3];
                  break;
                case 'Medium':
                  accessibility = [0.0, 0.7];
                  break;
                case 'Hard':
                  accessibility = [0.0, 1.0];
                  break;
              }
              setState(() => accessibilityStr = (value as String));
            },
          ),
          const Text('Max Price'),
          DropdownButton(
            value: priceStr,
            items: ['Free', 'Low', 'Medium', 'High'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (value) {
              switch (value) {
                case 'Free':
                  price = [0.0, 0.0];
                  break;
                case 'Low':
                  price = [0.0, 0.3];
                  break;
                case 'Medium':
                  price = [0.0, 0.7];
                  break;
                case 'High':
                  price = [0.0, 1.0];
                  break;
              }
              setState(() => priceStr = (value as String));
            },
          ),
          const Text('Participants'),
          Slider(
            label: 'Participants',
            value: participants.toDouble(),
            divisions: 4,
            min: 1,
            max: 5,
            onChanged: (value) => setState(() { participants = value.toInt(); }),
          ),
          OutlinedButton(
            onPressed: () {
              findActivity().then((value) {
                ScaffoldMessenger
                    .of(context)
                    .showSnackBar(
                      SnackBar(
                        content: Text(value.activity),
                        duration: const Duration(seconds: 2)
                      )
                    );
              });
            },
            child: const Text('Find activity'),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 64),
            child: Text('Data provided by boredapi.com'),
          ),
        ],
      ),
    );
  }
}
