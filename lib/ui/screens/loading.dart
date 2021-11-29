import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BoxDecoration _buildBackground() {
      return BoxDecoration(
        image: DecorationImage(
          image:
              AssetImage("assets/images/brooke-lark-wMzx2nBdeng-unsplash.jpg"),
          fit: BoxFit.cover,
        ),
      );
    }

    Text _buildText() {
      return Text(
        'Recipes',
        style: Theme.of(context).textTheme.headline1,
        textAlign: TextAlign.center,
      );
    }

    return Scaffold(
      // We do not use backgroundColor property anymore.
      // New Container widget wraps our Center widget:
      body: Container(
        decoration: _buildBackground(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildText(),
              SizedBox(height: 50.0),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
