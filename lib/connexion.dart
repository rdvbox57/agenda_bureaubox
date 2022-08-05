import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'listeBureaux.dart';

class ConnexionScreen extends StatelessWidget {
  const ConnexionScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: const Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: connexionForm(),


          ),
        ),
      ),
    );
  }
}

class connexionForm extends StatefulWidget {
  const connexionForm();

  @override
  _ConnexionFormState createState() => _ConnexionFormState();
}
class _ConnexionFormState extends State<connexionForm> {
  final _mailController = TextEditingController();
  final _pwdController  = TextEditingController();

  bool _visible = false;
  bool passwordHidden = true;
  bool _savePassword = true;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    Future userLogin() async {
      //Login API URL
      print("userLogin");

      Uri url = Uri.parse("http://127.0.0.1:9001/user/login");
      print (url.port.toString());
      print(url.authority);

      // Showing LinearProgressIndicator.
      setState(() {
        _visible = true;
      });
      // Getting username and password from Controller
      Map data = {
        'username': _mailController.text,
        'password': _pwdController.text,
      };
      //Starting Web API Call.
      print(data);
      print(json.encode(data));

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
        print(msg['loginStatus'].toString());
        //Check Login Status
       if (msg['loginStatus'] == true) {
                   setState(() {
            //hide progress indicator
            _visible = false;
          });
          // Navigate to Welcome Screen
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => listBureauxScreen()));
        }
      else {
          setState(() {
            //hide progress indicator
            _visible = false;
            Fluttertoast.showToast(msg: 'Mail ou mot de passe  invalide',
                toastLength: Toast.LENGTH_LONG,
                timeInSecForIosWeb: 5,
                fontSize: 20,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.black54,
              textColor: Colors.red,
              webShowClose: true
            );
          });
        }
      } else {
        setState(() {
          //hide progress indicator
          _visible = false;

          //Show Error Message Dialog
          //showMessage("Error during connecting to Server.");
        });
      }

    }
    return Form(
      onChanged: _updateFormProgress,
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
       //  LinearProgressIndicator(value: _visible),
          Text('Connexion', style: Theme
              .of(context)
              .textTheme
              .headline4),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _mailController,
              decoration: const InputDecoration(labelText: 'Mail'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'SVP Entrez le mail';
                  }
                  return null;
                }
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              obscureText: true,
              controller: _pwdController,
              decoration: const InputDecoration(labelText: 'Mot de passe'
            ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'SVP Entrez le mot de passe';
                }
                return null;
              }
            ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {

                  userLogin()}
              },
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Connexion',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).primaryColor),
              ),
            ),
          ),
        ],
      ),
    )
    ;
  }
  void _showAgendaScreen() {

    Navigator.of(context).pushNamed('/');
  }


  void _updateFormProgress() {
    var progress = 0.0;
    final controllers = [
      _pwdController ,
      _mailController
    ];

    for (final controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length;
      }
    }

  }

}

