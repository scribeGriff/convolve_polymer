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

  // The default selection is convolution which is the 2nd entry in menu.
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

  void menuHandler(Event e, var detail, Element target) {
    e.preventDefault();
    // Check if this is not the current element.
    if (target.attributes["id"] != menu[currentSelection].id) {
      menu.forEach((element) {
        if (element.id == target.attributes["id"]) {
          if (menu.indexOf(element) == currentSelection) return;
          newSelection = menu.indexOf(element);
          offsetClass = newSelection - currentSelection;
          element.selected = true;
          currentSelection = newSelection;
        } else {
          element.selected = false;
        }
      });
      // Now need to offset classList queue by the offsetClass amount.
      // Do that here using pop/push where sign determines direction.
      // Or just do this with a simple list and sublist??
      // The following is still not working.
      offsetClass = offsetClass > 0 ? offsetClass : offsetClass + menu.length;
      classList.insert(0, classList.sublist(classList.length - offsetClass, classList.length).join(", "));
      classList.removeRange(classList.length - offsetClass, classList.length);
      // Once you have that, loop through menu item list and attach the correct class.
      // Something like this?
      for (var i = 0; i < menu.length; i++) {
        query("#${menu[i].id}").classes.removeAll(classList);
        query("#${menu[i].id}").classes.add(classList.elementAt(i));
      }
    }
//        query("#$selected").classes.removeAll(classList);
//        query("#$selected").classes.add("active");
//      } else {
//        element.selected = false;
//        query("#convolution").classes.remove("active");
//        query("#convolution").classes.add("previous");
//      }


    /*var el = query('#box');

    var properties = {
                      'left': 1000,
                      'top': 350
    };

    animate(el, properties: properties, duration: 5000);*/
  }
}