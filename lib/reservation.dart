import 'package:flutter/material.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'bureauArguments.dart';


String _date='';
 BureauArguments bureau=BureauArguments(0, "");
DateTime selectedDate = DateTime.now();
TimeRange _time = new TimeRange(startTime:TimeOfDay(hour: 0, minute: 0),endTime:TimeOfDay(hour: 8, minute: 0));
class ReservationScreen extends StatelessWidget {
  final BureauArguments bureauArg;

  const ReservationScreen({required this.bureauArg});

  //static const routeName = '/extractArguments';
 // @override
//  _ReservationState createState() => _ReservationState();
//  const ReservationScreen({super.key});
//  static const routeName = '/extractArguments';

  @override
  Widget build(BuildContext context) {
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate
    ];
    supportedLocales: [
    const Locale('en'),
    const Locale('fr')
    ];
print('réservation');
    bureau=bureauArg;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: const Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: ReservationForm(),


          ),
        ),
      ),
    );
  }
}

class ReservationForm extends StatefulWidget {
 // final BureauArguments bureauArg1;
  const ReservationForm();

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<ReservationForm> {
  final _firstNameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();
  final _dateTextController = TextEditingController();
  final _creneauStartTextController = TextEditingController();
  final _creneauEndTextController = TextEditingController();

  double _formProgress = 0;
  @override
  void initState() {
    _dateTextController.text = ""; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Form(
      onChanged: _updateFormProgress,

    //  onChanged: _updateFormProgress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(value: _formProgress),
          Text('Réservation '+bureau.description, style: Theme
              .of(context)
              .textTheme
              .headline4),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _firstNameTextController,
              decoration: const InputDecoration(labelText: 'Prénom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez Entre le prénom';
                  }
                  return null;
                }
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _lastNameTextController,
              decoration: const InputDecoration(labelText: 'Nom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez Entre le nom';
                  }
                  return null;
                }
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child:TextField(
                controller: _dateTextController, //editing controller of this TextField
                decoration: InputDecoration(
                    icon: Icon(Icons.calendar_today), //icon of text field
                    labelText: "Sélectionnez la Date" //label text of field
                ),
              onTap: () async {
                 final pickedDate = await showDatePicker(
              context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030)
    );

    if(pickedDate != null ){
    print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
    String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

    _dateTextController.text = formattedDate;
    setState(() {
      _date=DateFormat('yyyy-MM-dd').format(pickedDate);
      selectedDate=pickedDate;
      _dateTextController.text = formattedDate; //set output date to TextField value.
    });
    }else{
    print("Date is not selected");
    }
  },
          ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _creneauStartTextController,
              decoration: const InputDecoration(labelText: 'Créneau début'),
    onTap:  () async{await _showCreneauSelection();},
    ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _creneauEndTextController,
              decoration: const InputDecoration(labelText: 'Créneau fin'),
              onTap: () async{await _showCreneauSelection();},
            ),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor:  MaterialStateProperty.all(Colors.white),
            backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
            onPressed:  () {  Navigator.pop(context);},

            child: const Text('Annuler'),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
                return states.contains(MaterialState.disabled) ? null : Colors.white;
              }),
              backgroundColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
                return states.contains(MaterialState.disabled) ? null : Colors.blue;
              }),
            ),
            onPressed:  _formProgress == 1 ? _reservation : null,

            child: const Text('Réserver'),
          ),
        ],
      ),
    )
    ;
  }
  Future _reservation() async {

    final localizations = MaterialLocalizations.of(context);
    final now = new DateTime.now();
    final dtStart = DateTime(now.year, now.month, now.day, _time.startTime.hour, _time.startTime.minute);
    final dtEnd = DateTime(now.year, now.month, now.day, _time.endTime.hour, _time.endTime.minute);
    Map data = {
      'firstName': _firstNameTextController.text,
      'lastName': _lastNameTextController.text,
      'numBureau':bureau.numBureau,
      'date': _date,
      'heureDebut': DateTime(selectedDate.year, selectedDate.month, selectedDate.day, _time.startTime.hour, _time.startTime.minute).toString(),
      'heureFin':DateTime(selectedDate.year, selectedDate.month, selectedDate.day, _time.endTime.hour, _time.endTime.minute).toString(),

    };
    //Starting Web API Call.
    print(data);
    print(json.encode(data));
    Uri url = Uri.parse("http://127.0.0.1:9001/reservation");
    Object myBody(){
      var theBody = jsonEncode(data);
      return theBody;
    }

    var response = await http.post(url,
        headers:{"Content-Type":"application/json"},
        body: myBody());
    print(response.statusCode.toString());
    if (response.statusCode == 200) {

        //Server response into variable
        print(response.body);

        var msg = jsonDecode(response.body);
    }
  }
//fonction qui permet de sélectionner un créneau horaire de réservation pour un bureau
  Future<TimeRange>   _showCreneauSelection() async {
     TimeRange result =   await showTimeRangePicker(
      context: context,
      
      rotateLabels: false,
      ticks: 15,
      interval:Duration(minutes: 30),
      ticksColor: Colors.grey,
      ticksOffset: -15,
      fromText:"de",
      toText: "à",
      labels: [
        "24 h",
        "3 h",
        "6 h",
        "9 h",
        "12 h",
        "15 h",
        "18 h",
        "21 h"
      ].asMap().entries.map((e) {
        return ClockLabel.fromIndex(
            idx: e.key, length: 8, text: e.value);
      }).toList(),
      labelOffset: -30,
      padding: 55,
      start: TimeOfDay(hour: 8, minute: 0),
      end: TimeOfDay(hour: 12, minute: 0),
      maxDuration: Duration(hours: 20),

    );
     final localizations = MaterialLocalizations.of(context);
     final formattedTimeOfDay = localizations.formatTimeOfDay(result.startTime);
    print("result StartTime" + formattedTimeOfDay);
    if (result!=null) {
      print("result " + result.toString());
      _creneauStartTextController.text = (result.startTime.hour).toString()+" h: "+((result.startTime.minute).toString()=="0"?"00":(result.startTime.minute).toString());
      _creneauEndTextController.text = (result.endTime.hour).toString()+" h: "+((result.endTime.minute).toString()=="0"?"00":(result.endTime.minute).toString());
      setState(() {
        _time = result;
      });
    }
    return result;
  }

  void _updateFormProgress() {
    var progress = 0.0;
    final controllers = [
      _firstNameTextController,
      _lastNameTextController,
      _dateTextController,
      _creneauStartTextController,
      _creneauEndTextController
    ];

    for (final controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length;
      }
    }

    setState(() {
      _formProgress = progress;
    });
  }

}