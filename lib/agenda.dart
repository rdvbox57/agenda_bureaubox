import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/scheduler.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'accueil.dart';
import 'reservation.dart';
import 'bureauArguments.dart';

BureauArguments selectBureau=BureauArguments(0, "");
List<Meeting> listRDV= <Meeting>[];

DateTime? _datePicked = DateTime.now();
class AgendaScreen extends StatelessWidget {
  final BureauArguments bureauArg;
  const AgendaScreen({required this.bureauArg});

  void _addRdv(BuildContext context) {
    print("Ajout RDV");
    Navigator.push(context,
        MaterialPageRoute(builder: (context) =>  ReservationScreen(bureauArg:bureauArg)));

  }
  @override
  Widget build(BuildContext context) {
    selectBureau=bureauArg;
    _loadAgenda(selectBureau);
    print("listRDV "+listRDV.toString());
    return Scaffold(
      appBar: AppBar(title: Text( "Agenda de " +selectBureau.description)),
        body: ListView(
       //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
        Localizations.override(
        context: context,
        locale: Locale('fr'),

         //   SizedBox(height: 20),
        //   child: Expanded (
             child:  SizedBox(
               width: double.infinity,
               height: 640,

               child:  SfCalendar(

          view: CalendarView.week,
          onViewChanged: _viewChanged,
          allowedViews: [
            CalendarView.day,
            CalendarView.week,
            CalendarView.month,
          ],
          headerStyle: CalendarHeaderStyle(
              textAlign: TextAlign.center,
              backgroundColor: Colors.purple,
              textStyle: TextStyle(
                  fontSize: 25,
                  fontStyle: FontStyle.normal,
                  letterSpacing: 5,
                  color: Colors.black,
                  fontWeight: FontWeight.w500)),
          todayHighlightColor: Colors.red,
          cellBorderColor: Colors.purple,
          backgroundColor: Colors.black12,
          showNavigationArrow: true,
          weekNumberStyle: const WeekNumberStyle(
            backgroundColor: Colors.greenAccent,
            textStyle: TextStyle(color: Colors.black, fontSize: 20),
          ),

         // dataSource:  _loadAgenda(selectBureau),
                // dataSource: MeetingDataSource(_getDataSource()),
                 dataSource: MeetingDataSource(listRDV),
      //    monthViewSettings: MonthViewSettings(
        //      appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
        ),

            // )
           )),
        ]
             ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addRdv(context),
          child: const Icon(Icons.add),
        tooltip: 'Ajouter un RDV'
      ),


        bottomNavigationBar: BottomAppBar(
            color: Colors.black38,
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextButton.icon(icon: Icon(Icons.home), label: Text("Retour Accueil"), onPressed: ()
                {       Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen()));},

              //  { Navigator.of(context).pushNamed('/'); },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(16.0),
                    primary: Colors.blue,
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  onPressed: () { Navigator.of(context).pushNamed('/bureau'); },
                  child: const Text('Retour Location'),
                )
              ],
            ),
          ),
        );
  }
}
void _viewChanged(ViewChangedDetails viewChangedDetails) {
  SchedulerBinding.instance.addPostFrameCallback((duration) {
    _datePicked = viewChangedDetails
        .visibleDates[viewChangedDetails.visibleDates.length ~/ 2];
  });
}
List<Meeting> _getDataSource()  {
  final List<Meeting> meetings = <Meeting>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
  DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));
  meetings.add(Meeting(
      'Conference', startTime, endTime, const Color(0xFF0F8644), false));

  return meetings;
  }


Future<void>_loadAgenda(BureauArguments selectBureau) async {

  print("load agenda()");
  Uri url = Uri.parse("http://127.0.0.1:9001/reservation/list");
  var response = await http.get(url);
  print(response.statusCode.toString());
  final List<Meeting> meetings = <Meeting>[];
  if (response.statusCode == 200) {
    //Server response into variable
    print(response.body);
    var msg = jsonDecode(response.body);
    print(msg);
    print('before decode');
    var tagObjsJson = jsonDecode(msg) as List<dynamic>;

  print( tagObjsJson.length);

    for (var i = 0; i < tagObjsJson.length; i = i + 1) {
      print(tagObjsJson[i]);

      DateTime heureDebut = DateTime.parse(tagObjsJson[i]['heureDebut']) ;
      DateTime heureFin = DateTime.parse(tagObjsJson[i]['heureFin']) ;
      int numBureau=tagObjsJson[i]['numBureau'];
      if (numBureau==selectBureau.numBureau) {
        print("ok numBureau");
        Meeting meet = new Meeting(
            tagObjsJson[i]['nomReservation'], heureDebut, heureFin,
            const Color(0xFF0F8644), false);
        meetings.add(Meeting(
            tagObjsJson[i]['nomReservation'], heureDebut, heureFin,
            const Color(0xFF0F8644), false));
      }
    }
    listRDV=meetings;

    print(listRDV);
  }
  else {
    print("retour <>200 " + response.statusCode.toString());
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}
class Reservation {
  Reservation(this.id_reservation,this.numBureau,this.nomReservation, this.dateReservation,this.heureDebut, this.heureFin);

  int id_reservation;
  int numBureau;
  String nomReservation;
  DateTime dateReservation;
  DateTime heureDebut;
  DateTime heureFin;

  factory Reservation.fromJson(dynamic json) {
    return Reservation(json['id_reservation'] as int,json['numBureau'] as int,json['nomReservation'] as String, json['dateReservation'] as DateTime,json['heureDebut'] as DateTime,json['heureFin'] as DateTime);
  }
  @override
  String toString() {
    return '{ ${this.id_reservation}, ${this.nomReservation} ${this.dateReservation}, ${this.heureDebut}${this.heureFin} }';
  }

}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}


class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source, List<CalendarResource> resourceColl) {
    appointments = source;
    resources = resourceColl;
  }
}