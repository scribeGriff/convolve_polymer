import 'dart:html';
import 'package:polymer/polymer.dart';

@CustomTag('navbar-element')
class NavbarElement extends PolymerElement {

  bool get applyAuthorStyles => true;

  // Do I really want to do it like this?
  void doConvolution(Event e, var detail, Node target) {
    e.preventDefault();
    print('selected convolution');
  }

  void doDeconvolution(Event e, var detail, Node target) {
    e.preventDefault();
    print('selected deconvolution');
  }

  void doSequences(Event e, var detail, Node target) {
    e.preventDefault();
    print('selected sequences');
  }

  void doFilters(Event e, var detail, Node target) {
    e.preventDefault();
    print('selected filters');
  }

  void doFourier(Event e, var detail, Node target) {
    e.preventDefault();
    print('selected fourier');
  }
}