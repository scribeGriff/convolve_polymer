import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:convolab/convolab.dart';
import 'package:js/js.dart' as js;

class Math extends Object with ObservableMixin {
  @observable String expression;
  Math([this.expression = '']);
}

@CustomTag('equation-element')
class Equations extends PolymerElement with ObservableMixin {
  String equation;
  @observable Math math = new Math();

  // This is not in the shadow dom since MathJax
  // does not typset inside a polymer-element.
  DivElement eqndiv = query('#equation');

  bool get applyAuthorStyles => true;

  void render(Event e, var detail, Node target) {
    equation = math.expression;
    Sequence coeff = sequence(equation.split(",")
        .where((element) => element.trim().isNotEmpty)
          .map((element)=> int.parse(element)));
    eqndiv.innerHtml = pstring(coeff);
    var context = js.context;
    js.scoped(() {
      // This repesents the following:
      // MathJax.Hub.Queue(["Typeset", MathJax.Hub, eqndiv]));
      new js.Proxy(context.MathJax.Hub.Queue(js.array(["Typeset",
                                                       context.MathJax.Hub,
                                                       eqndiv])));
    });
  }
}