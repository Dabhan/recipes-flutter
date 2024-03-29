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
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('recipes');
    Stream<QuerySnapshot> stream;
    // The argument recipeType is set
    if (recipeType != null) {
      stream = collectionReference.where("types", arrayContains: recipeType.typeName).snapshots();
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
      child: StreamBuilder(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return _buildLoadingIndicator();
          final documents = snapshot.data.docs.where((document) => ids == null || ids.contains(document.id)).toList();

          final children = documents
              .map<Widget>((document) => StaggeredGridTile.fit(
                  crossAxisCellCount: 1,
                  child: RecipeCard(
                    recipe: Recipe.fromMap(document.data(), document.id),
                    inFavorites: appState.favourites.contains(document.id),
                    onFavoriteButtonPressed: _handleFavoritesListChanged,
                  )))
              .toList();

          return SingleChildScrollView(
            child: StaggeredGrid.count(
              axisDirection: AxisDirection.down,
              crossAxisCount: useMobileLayout
                  ? 1
                  : useLargeLayout
                      ? 3
                      : 2,
              children: children,
            ),
          );
        },
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
