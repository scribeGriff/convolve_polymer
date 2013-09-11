import 'dart:html';
import 'package:polymer/polymer.dart';

/// The Item class represents an item in the navigation bar.
class Item extends Object with ObservableMixin {
  @observable String text;
  @observable String id;

  Item([this.text = '', this.id = '']);
}

/// The navigation bar.
@CustomTag('navbar-element')
class NavbarElement extends PolymerElement with ObservableMixin {
  final ObservableList<Item> menu =
      toObservable([
                    new Item('Convolution', 'convolution'),
                    new Item('Deconvolution', 'deconvolution'),
                    new Item('Sequences', 'sequence'),
                    new Item('Filters', 'filter'),
                    new Item('Fourier', 'fourier')
                    ]);

  bool get applyAuthorStyles => true;

  void menuHandler(Event e, var detail, Element target) {
    e.preventDefault();
    print(target.attributes["id"]);
  }
}