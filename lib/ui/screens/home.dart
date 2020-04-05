import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipes/model/recipe.dart';
import 'package:recipes/ui/widgets/recipe_card.dart';
import 'package:recipes/utils/store.dart';
import 'package:recipes/model/state.dart';
import 'package:recipes/state_widget.dart';
import 'package:recipes/ui/screens/login.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  // New member of the class:
  StateModel appState;

  DefaultTabController _buildTabView({Widget body}) {
    const double _iconSize = 20.0;

    return DefaultTabController(
      length: RecipeType.values.length + 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Recipes"),
            elevation: 2.0,
            bottom: TabBar(
              isScrollable: true,
              labelColor: Theme.of(context).indicatorColor,
              tabs: [
                ..._recipeTabs(_iconSize),
                Tab(icon: Icon(Icons.favorite, size: _iconSize)),
                Tab(icon: Icon(Icons.settings, size: _iconSize)),
              ],
            ),
        ),
        body: Padding(
          padding: EdgeInsets.all(5.0),
          child: body,
        ),
      ),
    );
  }

List<Widget> _recipeTabs(double _iconSize) {
  return RecipeType.values.map((type){
    return Tab(text: type.name,);
  }).toList();
}


  Widget _buildContent() {
    if (appState.isLoading) {
      return _buildTabView(
        body: _buildLoadingIndicator(),
      );
    } else if (!appState.isLoading && appState.user == null) {
      return new LoginScreen();
    } else {
      return _buildTabView(
        body: _buildTabsContent(),
      );
    }
  }

  Center _buildLoadingIndicator() {
    return Center(
      child: new CircularProgressIndicator(),
    );
  }

  Padding _buildRecipes({RecipeType recipeType, List<String> ids}) {
    CollectionReference collectionReference =
        Firestore.instance.collection('recipes');
    Stream<QuerySnapshot> stream;
    // The argument recipeType is set
    if (recipeType != null) {
      stream = collectionReference
          .where("type", isEqualTo: recipeType.index)
          .snapshots();
    } else {
      // Use snapshots of all recipes if recipeType has not been passed
      stream = collectionReference.snapshots();
    }
    return Padding(
      // Padding before and after the list view:
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: new StreamBuilder(
              stream: stream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return _buildLoadingIndicator();
                return new ListView(
                  children: snapshot.data.documents
                      // Check if the argument ids contains document ID if ids has been passed:
                      .where((d) => ids == null || ids.contains(d.documentID))
                      .map((document) {
                    return new RecipeCard(
                      recipe:
                          Recipe.fromMap(document.data, document.documentID),
                      inFavorites:
                          appState.favourites.contains(document.documentID),
                      onFavoriteButtonPressed: _handleFavoritesListChanged,
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  TabBarView _buildTabsContent() {
    return TabBarView(
      children: [
       ..._buildRecipePages(),
        _buildRecipes(ids: appState.favourites),
        Center(child: Icon(Icons.settings)),
      ],
    );
  }

  List<Widget> _buildRecipePages() {
    return RecipeType.values.map((type){
      return _buildRecipes(recipeType: type);
    }).toList();
  }

  // Inactive widgets are going to call this method to
  // signalize the parent widget HomeScreen to refresh the list view:
  void _handleFavoritesListChanged(String recipeID) {
    updateFavorites(appState.user.uid, recipeID).then((result) {
      if (result == true) {
        setState(() {
          if (!appState.favourites.contains(recipeID))
            appState.favourites.add(recipeID);
          else
            appState.favourites.remove(recipeID);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build the content depending on the state:
    appState = StateWidget.of(context).state;
    return _buildContent();
  }

}
