import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:fancy_syntax/syntax.dart';
import 'package:js/js.dart' as js;

class Math extends Object with ObservableMixin {
  @observable
  String message;
}

String render(String v) {
  js.context.MathJax.Hub.Typeset();
  return v;
}

main() {
  var globals = {
                 'render': (String v) => render(v)
  };
  var equation = query('#tmpl');
  equation.bindingDelegate = new FancySyntax(globals: globals);
  equation.model = new Math();
}
