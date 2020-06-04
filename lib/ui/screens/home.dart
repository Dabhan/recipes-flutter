import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:recipes/model/recipe.dart';
import 'package:recipes/ui/widgets/recipe_card.dart';
import 'package:recipes/ui/widgets/settings_button.dart';
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
          centerTitle: true,
          title: Text("Recipes"),
          elevation: 2.0,
          bottom: TabBar(
            isScrollable: true,
            labelColor: Theme.of(context).indicatorColor,
            tabs: [
              Tab(icon: Icon(Icons.favorite, size: _iconSize)),
              ..._recipeTabs(_iconSize),
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
    return RecipeType.values.map((type) {
      return Tab(
        text: type.name,
      );
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
          .where("type", isEqualTo: recipeType.typeName)
          .snapshots();
    } else {
      // Use snapshots of all recipes if recipeType has not been passed
      stream = collectionReference.snapshots();
    }
    var shortestSide = MediaQuery.of(context).size.width;
    final bool useMobileLayout = shortestSide < 600;
    final bool useLargeLayout = shortestSide >= 1200;
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
                var documents = snapshot.data.documents.where((document) => ids == null || ids.contains(document.documentID)).toList();
                return new StaggeredGridView.countBuilder(
                  crossAxisCount: useMobileLayout ? 1 : useLargeLayout ? 3 : 2,
                  itemBuilder: (context, index) {
                    var document = documents[index];
                    return new RecipeCard(
                      recipe:
                          Recipe.fromMap(document.data, document.documentID),
                      inFavorites:
                          appState.favourites.contains(document.documentID),
                      onFavoriteButtonPressed: _handleFavoritesListChanged,
                    );
                  },
                  itemCount: documents.length,
                  staggeredTileBuilder: (int index) =>
                      new StaggeredTile.fit(1),
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
        _buildRecipes(ids: appState.favourites),
        ..._buildRecipePages(),
        _buildSettings(),
      ],
    );
  }

  Column _buildSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SettingsButton(
          Icons.exit_to_app,
          "Log out",
          appState.user.displayName,
          () async {
            await StateWidget.of(context).signOut();
          },
        ),
      ],
    );
  }

  List<Widget> _buildRecipePages() {
    return RecipeType.values.map((type) {
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
