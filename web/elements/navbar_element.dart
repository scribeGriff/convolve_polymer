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

  int currentSelection = 2;
  int newSelection;
  int offsetClass;
  List classList = [
                    "previous-previous",
                    "previous",
                    "active",
                    "next",
                    "next-next"
                    ];

  bool get applyAuthorStyles => true;
// This doesn't work and not sure why.
//  NavBarElement() {
//    // The default selection is convolution which is the 2nd entry in menu.
//    //currentSelection = menu.indexOf(menu.firstWhere((i) => i.selected == true));
//  }

  void menuHandler(Event e, var detail, Element target) {
    e.preventDefault();
    // Check if this is not the current element.
    if (target.attributes["id"] != menu[currentSelection].id) {
      menu.forEach((element) {
        if (element.id == target.attributes["id"]) {
          newSelection = menu.indexOf(element);
          offsetClass = newSelection - currentSelection;
          element.selected = true;
          currentSelection = newSelection;
        } else {
          element.selected = false;
        }
      });
      // Update the classList to the new selection.
      offsetClass = offsetClass > 0 ? offsetClass : offsetClass + menu.length;
      classList.insertAll(0, classList.sublist(classList.length - offsetClass,
                                               classList.length));
      classList.removeRange(classList.length - offsetClass, classList.length);
      // Once you have that, loop through the menu item list and
      // attach the correct class.
      for (var i = 0; i < menu.length; i++) {
        query("#${menu[i].id}").classes.removeAll(classList);
        query("#${menu[i].id}").classes.add(classList.elementAt(i));
      }
    }

    /*var el = query('#box');

    var properties = {
                      'left': 1000,
                      'top': 350
    };

    animate(el, properties: properties, duration: 5000);*/
  }
}