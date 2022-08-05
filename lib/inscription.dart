import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter_mapbox_autocomplete/flutter_mapbox_autocomplete.dart';
import 'package:http/http.dart' as http;
import 'mailExistant.dart';
import 'listeBureaux.dart';


class InscriptionScreen extends StatelessWidget {
  const InscriptionScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: const Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: InscriptionForm(),
          ),
        ),
      ),
    );
  }
}
class InscriptionForm extends StatefulWidget {
  const InscriptionForm();

  @override
  _SignUpFormState createState() => _SignUpFormState();
}
class _SignUpFormState extends State<InscriptionForm> {
  final _firstNameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _passwordControlTextController = TextEditingController();
  final _professionTextController = TextEditingController();
  final _addressTextController = TextEditingController();
  final _addressCPTextController = TextEditingController();
  final _addressVilleTextController = TextEditingController();
  final _phoneTextController = TextEditingController();
  final _mailTextController = TextEditingController();
  final _startPointController=TextEditingController();

  Future userRegister() async {
    //Login API URL
    print("user Register");
    Uri url = Uri.parse("http://127.0.0.1:9001/user/register");

    Map data = {
      'prenom': _firstNameTextController.text,
      'nom': _lastNameTextController.text,
      'profession': _professionTextController.text,
      'adresse': _addressTextController.text,
      'CodePostal': _addressCPTextController.text,
      'ville': _addressVilleTextController.text,
      'telephone': _phoneTextController.text,
      'mail': _mailTextController.text,
      'password': _passwordTextController.text,
    };
    print(json.encode(data));
    Object myBody() {
      var theBody = jsonEncode(data);
      return theBody;
    }
    //   Future<http.Response> postRequest () async {
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: myBody());
    print(response.statusCode.toString());
    if (response.statusCode == 200) {
      print(response.body);
      var msg = jsonDecode(response.body);
      if (msg['loginStatus'] == true) {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MailScreen()));
      }
      if (msg['registerStatus'] == true) {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => listBureauxScreen()));
      }
      else {

      }
    }
  }
  double _formProgress = 0;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    const sizedBoxSpace = SizedBox(height: 22);
    final RestorableBool _obscureText = RestorableBool(true);
    return Form(
      key: _formKey,
    //  onChanged: _updateFormProgress,

      child: ListView(
       // mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(value: _formProgress),
          Text('Inscription', style: Theme
              .of(context)
              .textTheme
              .headline4),
              sizedBoxSpace,
             TextFormField(
                 maxLength: 50,
              controller: _lastNameTextController,
              decoration: const InputDecoration(
                  filled: true,
                  icon: const Icon(Icons.person),
                  hintText: 'Quel est votre nom?',
                  labelText: 'nom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom';
                  }
                  return null;
                }
            ),
            sizedBoxSpace,
             TextFormField(
                 maxLength: 50,
              controller: _firstNameTextController,
              decoration: const InputDecoration(
                  filled: true,
                  icon: const Icon(Icons.person),
                  labelText: 'Prénom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le prénom';
                  }
                  return null;
                }
            ),
      sizedBoxSpace,
             TextFormField(
              controller: _professionTextController,
              decoration: const InputDecoration(
                  filled: true,
                  icon: const Icon(Icons.business_sharp),
                  labelText: 'Profession'),
                 validator: (value) {
                   if (value == null || value.isEmpty) {
                     return 'Veuillez indiquer votre  profession';
                   }
                   return null;
                 }
            ),
          sizedBoxSpace,
          TextFormField(
            decoration: const InputDecoration(
                filled: true,
                icon: const Icon(Icons.home),
                labelText: 'Sélectionnez votre adresse'),
            controller: _startPointController,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                  MapBoxAutoCompleteWidget(
                  //  apiKey: 'pk.eyJ1IjoidG9uaW81NyIsImEiOiJjbDV1czlpbmcwMndjM2JucW9nY3k1amt5In0.MSebALmBiwLVdrUrovHHUQ',
                    apiKey:'pk.eyJ1IjoidG9uaW81NyIsImEiOiJjbDZlc250b20wYXcyM2NvM3kyZWVnaTByIn0.kiSm9CzSrhEZ7QbEq3NE-Q',
                    hint: "Selectionnez votre ville",
                    onSelect: (place) {
                      // TODO : Process the result gotten
                      _startPointController.text = place.placeName.toString();
                    },
                    limit: 10,
                    language: 'fr',
                    country: 'FR,BE',

                  ),
                /*      MapboxAutocompleteSearchWidget(
                    onPlaceSelected: selectedPlace,
                    mapboxApiKey: 'pk.eyJ1IjoidG9uaW81NyIsImEiOiJjbDV1czlpbmcwMndjM2JucW9nY3k1amt5In0.MSebALmBiwLVdrUrovHHUQ',
                  ),
                  */

                //  fullscreenDialog: true,

                  ),
                );
            },
            enabled: true,
          ),
      sizedBoxSpace,
      TextFormField(
              controller: _addressTextController,
              decoration: const InputDecoration(
                  icon: const Icon(Icons.home),
                  labelText: 'Adresse'),
            ),
      sizedBoxSpace,
      TextFormField(
              controller: _addressCPTextController,
              decoration: const InputDecoration(
                  icon: const Icon(Icons.home),
                  labelText: 'CP'),
            ),
      sizedBoxSpace,
             TextFormField(
              controller: _addressVilleTextController,
              decoration: const InputDecoration(
                  icon: const Icon(Icons.home),
                  labelText: 'Ville'),
                 validator: (value) {
                   if (value == null || value.isEmpty) {
                     return 'Veuillez indiquer votre  ville';
                   }
                   return null;
                 }

            ),
      sizedBoxSpace,
             TextFormField(
              keyboardType:TextInputType.phone,
              inputFormatters:[
                FilteringTextInputFormatter.digitsOnly
              ],
              controller: _phoneTextController,
              decoration: const InputDecoration(
                  icon: const Icon(Icons.phone),
                  labelText: 'Téléphone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un numéro de téléphone';
                  }
                  return null;
                }
            ),
      sizedBoxSpace,
             TextFormField(
              keyboardType:TextInputType.emailAddress,
              controller: _mailTextController,
              decoration: const InputDecoration(
                  filled: true,
                  icon: const Icon(Icons.email),
                  labelText: 'Mail'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une adresse mail valide';
                  }
                  return null;
                }
            ),
      sizedBoxSpace,
          TextFormField(
              obscureText: true,
              controller: _passwordTextController,
              decoration: InputDecoration(
                labelText: " Mot de passe",
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureText.value = !_obscureText.value;
                    });
                  },
                  hoverColor: Colors.transparent,
                  icon: Icon(
                   // _obscureText.value ? Icons.visibility : Icons.visibility_off,
                      Icons.visibility_off
                  ),
                ),
              ),

              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un mot de passe';
                }
                  if (value.length<8)
                    {
                      return 'Le mot de passe doit avoir au moins 8 caractères';
                }
                return null;
              }


            ),
      sizedBoxSpace,
             TextFormField(
                 obscureText: true,
              controller: _passwordControlTextController,
              decoration: InputDecoration(
                  labelText: "Confirmer le mot de passe",
                  suffixIcon: IconButton(
                  onPressed: () {
             setState(() {
            // _obscureText.value = !_obscureText.value;
             });
             },
               hoverColor: Colors.transparent,
               icon: Icon(
               //  _obscureText.value ? Icons.visibility : Icons.visibility_off,
                   Icons.visibility_off
               ),
             ),
            ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez confirmer le mot de passe';
                  }
                  else
                    if (_passwordTextController.text!= _passwordControlTextController.text) {
                      return ' les mots de passe ne sont pas identiques'+_passwordTextController.text+' '+  _passwordControlTextController.text;
                    }
                  return null;
                }
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.resolveWith((
                  Set<MaterialState> states) {
                return states.contains(MaterialState.disabled) ? null : Colors
                    .white;
              }),
              backgroundColor: MaterialStateProperty.resolveWith((
                  Set<MaterialState> states) {
                return states.contains(MaterialState.disabled) ? null : Colors
                    .blue;
              }),
            ),
            onPressed: () =>{
              if (_formKey.currentState!.validate()) {
                userRegister()}
            },

            child: const Text('S''inscrire'),
          ),
        ],
      ),
    )
    ;
  }
/*
  void selectedPlace(BuildContext context, Place place) {
    print('Place Name : ${place.placeName}');
    setState(() {
      _startPointController.text = place.placeName;
    });
  }

 */

  void _updateFormProgress() {
    var progress = 0.0;
    final controllers = [
      _firstNameTextController,
      _lastNameTextController,
      _passwordTextController,
      _professionTextController,
     _addressTextController,
     _phoneTextController,
     _mailTextController

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
