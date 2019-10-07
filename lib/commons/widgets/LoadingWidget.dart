import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildLoading();
  }

  Widget _buildLoading() {
    return new Center(
      child: new CircularProgressIndicator(),
    );
  }
}