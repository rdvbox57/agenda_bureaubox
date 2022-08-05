
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'agenda.dart';
import 'bureauArguments.dart';

class listBureauxScreen extends StatelessWidget {
  const listBureauxScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return _createHomeRoute();
      },
    );
  }

  Route _createHomeRoute() {
    return PageRouteBuilder<void>(
      pageBuilder: (context, animation, secondaryAnimation) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Column(
              children: [
                Text("Bureaux et salle de formation a louer"),
            /*    Text(
                  'à louer',
                  style: Theme
                      .of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(color: Colors.white),
                ),
                */
              ],
            ),
            actions: [
            ],
          ),
          body: const _RecipePage(),
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SharedAxisTransition(
          fillColor: Colors.transparent,
          transitionType: SharedAxisTransitionType.scaled,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
    );
  }
}






class _SettingsInfo {
  const _SettingsInfo(this.settingIcon, this.settingsLabel);

  final IconData settingIcon;
  final String settingsLabel;
}

class _RecipePage extends StatelessWidget {
  const _RecipePage();

  @override
  Widget build(BuildContext context) {

    final savedRecipes = <_RecipeInfo>[
      _RecipeInfo(
        "Bureau Améthyste",
       "Bureau équipé de 13 m²",
        'images/bureaux/Bureau_Amethyste.jpg',
      ),
      _RecipeInfo(
        "Bureau Onyx",
        "Bureau équipé de 13 m²",
        'images/bureaux/Bureau_ONYX.jpg',
      ),
      _RecipeInfo(
        "Bureau Schuman",
        "Bureau équipé de 26 m²",
        'images/bureaux/Bureau_Schuman.jpg',
      ),
      _RecipeInfo(
        "Salle Oslo",
        "Salle de 53 m² pouvant accueillir jusqu'à 12 personnes",
        'images/bureaux/salle_Oslo.jpg',
      ),
      _RecipeInfo(
        "Bureau Direction",
        "Bureau équipé de 26 m²",
        'images/bureaux/bureau_direction.jpg',
      ),
      _RecipeInfo(
        "Bureau Ambre",
        "Bureau équipé de 13 m²",
        'images/bureaux/Bureau_Ambre.jpg',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 8.0),
          child: Text("liste des bureaux"),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: [
              for (var recipe in savedRecipes)
                _RecipeTile(recipe,  savedRecipes.indexOf(recipe))
  ]
          ),
        ),
      ],
    );
  }
}

class _RecipeInfo {
  const _RecipeInfo(this.recipeName, this.recipeDescription, this.recipeImage);

  final String recipeName;
  final String recipeDescription;
  final String recipeImage;
}

class _RecipeTile extends StatelessWidget {
  const _RecipeTile(this._recipe, this._index);
  final _RecipeInfo _recipe;
  final int _index;



  @override
  Widget build(BuildContext context) {
    BureauArguments bureauArg1=new BureauArguments(this._index+1,this._recipe.recipeName);
    return Row(
      children: [
        SizedBox(
          height: 100,
          width: 120,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            child: Image.asset(
              _recipe.recipeImage,
             // package: 'flutter_gallery_assets',
              fit: BoxFit.fitWidth
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            children: [
              ListTile(
                title: Text(_recipe.recipeName),
                subtitle: Text(_recipe.recipeDescription),
               // trailing: Text('0${_index + 1}'),
              ),
              const Divider(thickness: 2),
            ],
          ),
        ),

    SizedBox(

    child: Column(
        children: [
          OutlinedButton.icon(

            onPressed: () {       Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AgendaScreen(bureauArg:bureauArg1)));},
            icon: Icon(Icons.view_agenda,color: Colors.purple)
            ,
            label:Text('Agenda', style: TextStyle(color: Colors.purpleAccent)),
          ),
     /*     OutlinedButton.icon(

        onPressed: () {
      print(this._index);

    Navigator.push(context,
    MaterialPageRoute(builder: (context) =>  ReservationScreen(bureauArg:bureauArg1)));
    },

         icon: Icon(Icons.view_agenda_outlined,color: Colors.blue)

      ,
      label:Text('Réserver', style: TextStyle(color: Colors.blueGrey)),
          )
          */
      ]
    ))
    ],
    );


  }
}

