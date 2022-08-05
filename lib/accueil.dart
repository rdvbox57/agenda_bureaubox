import 'package:flutter/material.dart';
import 'inscription.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen();

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
        _buildButtonColumn(color,  Text('Inscription'),()
        {       Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InscriptionScreen()));}
      //  {Navigator.of(context).pushNamed('/inscription');}
        ),
        _buildButtonColumn(color, Text('Connexion'),() {Navigator.of(context).pushNamed('/connexion');}),
      ],
    );
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
              'images/building.jpg',
            width: 480,
             height: 500,
              fit: BoxFit.cover,
          ),


          buttonSection,

    ]
      ),
    )
    ;
  }
}
