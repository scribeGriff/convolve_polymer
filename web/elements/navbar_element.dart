import 'dart:html';
import 'package:polymer/polymer.dart';

/// The Item class represents an item in the navigation bar.
class Item extends Observable {
  @observable String text;
  @observable String id;
  @observable String icon;
  @observable bool selected;

  Item(this.text, this.id, this.icon, this.selected) {
    onPropertyChange(this, #selected, () =>
        notifyPropertyChange(#arrowClass, null, selected));
  }

  // Apply a selected class for the selected items.
  // There is a suggestion that much of the above could just be
  // replaced with @dependsOn.
  // @dependsOn([#selected])
  @reflectable String get arrowClass {
    if (selected) return 'active';
    else return 'cl-effect';
  }
}

/// The navigation bar.
@CustomTag('navbar-element')
class NavbarElement extends PolymerElement {
  // TODO: Does this list need to be observable?
  final ObservableList<Item> menu =
      toObservable([
                    new Item('Fourier', 'fourier', 'fa fa fa-sort-amount-desc fa-rotate-270', false),
                    new Item('Sequences', 'sequence', 'fa fa-tasks', false),
                    new Item('Convolution', 'convolution', 'fa fa-asterisk', true),
                    new Item('Deconvolution', 'deconvolution', 'fa fa-headphones fa-rotate-90', false),
                    new Item('Filters', 'filter', 'fa fa-filter', false)
                    ]);

  final List classList = [
                          "next-l",
                          "next-next-l",
                          "previous-previous",
                          "previous",
                          "active",
                          "next",
                          "next-next",
                          "previous-previous-r",
                          "previous-r"
                          ];

  // The left most class for the default state is previous-previous.
  final int defaultSelection = 2;
  int
    currentSelection = 2,  // Initialized to menu[2] = convolution.
    newSelection,
    offsetClass;

  // Monitor if animation is currently in progress.
  bool inProgress = false;

  bool get applyAuthorStyles => true;

  NavbarElement.created() : super.created();

// This doesn't work and not sure why.
//  NavBarElement() {
//    // The default selection is convolution which is the 2nd entry in menu.
//    //currentSelection = menu.indexOf(menu.firstWhere((i) => i.selected == true));
//  }

  void menuHandler(Event e, var detail, Element target) {
    e.preventDefault();
    // Check if this is not the current element.
    if (target.attributes["id"] != menu[currentSelection].id && !inProgress) {
      inProgress = true;
      menu.forEach((element) {
        if (element.id == target.attributes["id"]) {
          newSelection = menu.indexOf(element);
          offsetClass = defaultSelection - newSelection;
          element.selected = true;
          currentSelection = newSelection;
        } else {
          element.selected = false;
        }
      });
      // Now add the animation class to each element referenced in the menu.
      for (var i = 0; i < menu.length; i++) {
        querySelector("#${menu[i].id}").classes
          .add("to-${classList.elementAt(defaultSelection + i + offsetClass)}");
      }
      // Wait for the animation to finish updating the current element, then
      // remove the animation class and add the classes for the final position.
      window.onAnimationEnd.first.then((_) {
        for (var i = 0; i < menu.length; i++) {
          querySelector("#${menu[i].id}")
            ..classes.removeAll(classList)
            ..classes.remove("to-${classList.elementAt(defaultSelection + i + offsetClass)}")
            ..classes.add(classList.elementAt(defaultSelection + i + offsetClass));
          inProgress = false;
        }
      });
    }
  }
}