import 'dart:html';
import 'package:polymer/polymer.dart';
//import 'package:animation/animation.dart';

/// The Item class represents an item in the navigation bar.
class Item extends Object with ObservableMixin {
  @observable String text;
  @observable String id;
  @observable bool selected;

  Item(this.text, this.id, this.selected) {
    bindProperty(this, const Symbol('selected'),
        () => notifyProperty(this, const Symbol('arrowClass')));
  }

// Apply a selected class for completed items.
  String get arrowClass {
    if (selected) return 'active';
    else return 'cl-effect';
  }
}

/// The navigation bar.
@CustomTag('navbar-element')
class NavbarElement extends PolymerElement with ObservableMixin {
  final ObservableList<Item> menu =
      toObservable([
                    new Item('Fourier', 'fourier', false),
                    new Item('Sequences', 'sequence', false),
                    new Item('Convolution', 'convolution', true),
                    new Item('Deconvolution', 'deconvolution', false),
                    new Item('Filters', 'filter', false)
                    ]);

  bool get applyAuthorStyles => true;

  void menuHandler(Event e, var detail, Element target) {
    e.preventDefault();
    print(target.attributes["id"]);
    menu.forEach((element) {
      if (element.id == target.attributes["id"]) {
        element.selected = true;
      } else {
        element.selected = false;
      }
    });

    /*var el = query('#box');

    var properties = {
                      'left': 1000,
                      'top': 350
    };

    animate(el, properties: properties, duration: 5000);*/
  }
}