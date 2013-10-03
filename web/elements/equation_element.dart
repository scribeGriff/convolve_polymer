import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:convolab/convolab.dart';
import 'package:js/js.dart' as js;

class Math extends Object with ObservableMixin {
  @observable String numerator, denominator;
  Math([this.numerator = '', this.denominator]);
}

@CustomTag('equation-element')
class Equations extends PolymerElement with ObservableMixin {
  String ncoeff, dcoeff;
  @observable Math math = new Math();

  // This is not in the shadow dom since MathJax
  // does not typset inside a polymer-element.
  DivElement numeratordiv = query('#numerator');
  DivElement denominatordiv = query('#denominator');
  DivElement solutiondiv = query('#solution');
  DivElement resultsdiv = query('#results');

  bool get applyAuthorStyles => true;

  void render(Event e, var detail, Node target) {
    ncoeff = math.numerator;
    dcoeff = math.denominator;
    Sequence numeqn = sequence(ncoeff.split(",")
        .where((element) => element.trim().isNotEmpty)
          .map((element)=> int.parse(element)));
    Sequence deneqn = sequence(dcoeff.split(",")
        .where((element) => element.trim().isNotEmpty)
          .map((element)=> int.parse(element)));
    var convolution = conv(numeqn, deneqn);
    numeratordiv.innerHtml = pstring(numeqn);
    denominatordiv.innerHtml = pstring(deneqn);
    solutiondiv.innerHtml = convolution.format();
    js.Proxy context = js.context;
    js.scoped(() {
      // This repesents the following:
      // MathJax.Hub.Queue(["Typeset", MathJax.Hub, numeratordiv]));
      new js.Proxy(context.MathJax.Hub.Queue(js.array(["Typeset",
                                                       context.MathJax.Hub,
                                                       resultsdiv])));
    });
  }
}