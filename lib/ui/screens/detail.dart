import 'package:flutter/material.dart';

import 'package:recipes/model/recipe.dart';
import 'package:recipes/ui/widgets/recipe_title.dart';
import 'package:recipes/model/state.dart';
import 'package:recipes/state_widget.dart';
import 'package:recipes/utils/store.dart';
import 'package:recipes/ui/widgets/recipe_image.dart';

class DetailScreen extends StatefulWidget {
  final Recipe recipe;
  final bool inFavorites;

  DetailScreen(this.recipe, this.inFavorites);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ScrollController _scrollController;
  bool _inFavorites;
  StateModel appState;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _scrollController = ScrollController();
    _inFavorites = widget.inFavorites;
  }

  @override
  void dispose() {
    // "Unmount" the controllers:
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleInFavorites() {
    setState(() {
      _inFavorites = !_inFavorites;
      if (_inFavorites) {
        appState.favourites.add(widget.recipe.id);
      } else {
        appState.favourites.remove(widget.recipe.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;

    var shortestSide = MediaQuery.of(context).size.width;
    var safePadding = MediaQuery.of(context).padding.top;

    final imageHeight =
        shortestSide * (1 / RecipeImage.aspectRatio(context, true));
    final textHeight = 150.0;

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerViewIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RecipeImage(widget.recipe.imageURL, detail: true),
                    RecipeTitle(widget.recipe, 25.0),
                  ],
                ),
              ),
              expandedHeight: imageHeight + textHeight - safePadding,
              pinned: true,
              floating: true,
              elevation: 2.0,
              forceElevated: innerViewIsScrolled,
              bottom: TabBar(
                tabs: <Widget>[
                  Tab(text: "Ingredients"),
                  Tab(text: "Method"),
                ],
                controller: _tabController,
              ),
            )
          ];
        },
        body: TabBarView(
          children: <Widget>[
            IngredientsView(widget.recipe.ingredients),
            PreparationView(widget.recipe.preparation),
          ],
          controller: _tabController,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          updateFavorites(appState.user.uid, widget.recipe.id).then((result) {
            // Toggle "in favorites" if the result was successful.
            if (result) _toggleInFavorites();
          });
        },
        child: Icon(
          _inFavorites ? Icons.favorite : Icons.favorite_border,
          color: Theme.of(context).iconTheme.color,
        ),
        elevation: 2.0,
        backgroundColor: Theme.of(context).backgroundColor,
      ),
    );
  }
}

class IngredientsView extends StatelessWidget {
  final List<String> ingredients;

  IngredientsView(this.ingredients);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = <Widget>[];
    ingredients.forEach((item) {
      children.add(
        new Row(
          children: <Widget>[
            new SizedBox(width: 5.0),
            Flexible(
                child: new Text(item,
                    style: Theme.of(context).textTheme.subtitle1)),
          ],
        ),
      );
      // Add spacing between the lines:
      children.add(
        new SizedBox(
          height: 5.0,
        ),
      );
    });
    return ListView(
      padding: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 75.0),
      children: children,
    );
  }
}

class PreparationView extends StatelessWidget {
  final List<String> preparationSteps;

  PreparationView(this.preparationSteps);

  @override
  Widget build(BuildContext context) {
    List<Widget> textElements = <Widget>[];
    preparationSteps.asMap().forEach((index, item) {
      textElements
          .add(Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("${index + 1}."),
        SizedBox(
          width: 10.0,
        ),
        Flexible(
            child: Text(item, style: Theme.of(context).textTheme.subtitle1)),
      ]));
      // Add spacing between the lines:
      textElements.add(
        SizedBox(
          height: 10.0,
        ),
      );
    });
    return ListView(
      padding: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 75.0),
      children: textElements,
    );
  }
}
