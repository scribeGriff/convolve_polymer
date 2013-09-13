library application;

import 'dart:html';
import 'package:animation/animation.dart';

main() {
  var el = query('#box');

  var properties = {
    'left': 1000,
    'top': 350
  };

  animate(el, properties: properties, duration: 5000);
}