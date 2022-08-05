import 'package:flutter/material.dart';
class MailScreen extends StatelessWidget {
  const MailScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: const Center(
        child: SizedBox(

          child: Card(
            child: WelcomeForm(),
          ),
        ),
      ),
    );
  }
}

class WelcomeForm extends StatefulWidget {
  const WelcomeForm();

  @override
  _WelcomeFormState createState() => _WelcomeFormState();
}
class _WelcomeFormState extends State<WelcomeForm> {

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    TextButton _buildButtonColumn(Color color, Text label, final VoidCallback navig ) {
      return
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
          onPressed: navig,

          child:  label,
        );
    }



    Widget buttonSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButtonColumn(color,  Text('HOME'),(){Navigator.of(context).pushNamed('/');}),
        _buildButtonColumn(color,  Text('Inscription'),() {Navigator.of(context).pushNamed('/inscription');}),
        _buildButtonColumn(color, Text('Connexion'),() {Navigator.of(context).pushNamed('/connexion');}),
      ],
    );
    return Form(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'images/logo_9.png',
              width: 272,
              height: 70,
              fit: BoxFit.cover,
            ),
            Text('Il existe déjà un client avec ce mail. Voulez-vous vous connecter?', style: Theme
                .of(context)
                .textTheme
                .headline4),



            buttonSection,

          ]
      ),
    )
    ;
  }
}