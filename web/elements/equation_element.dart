import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:convolab/convolab.dart';
import 'package:js/js.dart' as js;
import 'package:ace/ace.dart' as ace;

class MathItem extends Object with ObservableMixin {
  @observable String firstValue, secondValue;
  MathItem([this.firstValue = '', this.secondValue = '']);
}

class EqnElement extends Object with ObservableMixin {
  @observable String paragraphOne, paragraphTwo;
  @observable MathItem initial;
  EqnElement(this.initial, this.paragraphOne, this.paragraphTwo);
}

@CustomTag('equation-element')
class Equations extends PolymerElement with ObservableMixin {
  String ncoeff, dcoeff;
  @observable MathItem math = new MathItem();

  // The id of each equation element.
  static final List ids = [
                           'convolution',
                           'deconvolution',
                           'sequence',
                           'fourier',
                           'filter'
                           ];

  // Initializing each equation element.
  // TODO - strings for each input field (including optional fields).
  final Map eqn_element = {
                           "equation-${ids[0]}" : new EqnElement(new MathItem(
                               '1, 2, 0, 3', '4, 0, 6'),
                               'This is a test ${ids[0]}',
                               'This is another test ${ids[0]}'
                               ),
                           "equation-${ids[1]}" : new EqnElement(new MathItem(
                               '4, 9, 2, 1', '3, 4, 7'),
                               'This is a test ${ids[1]}',
                               'This is another test ${ids[1]}'
                               ),
                           "equation-${ids[2]}" : new EqnElement(new MathItem(
                               '9, 0, 4', '6, 7, 8'),
                               'This is a test ${ids[2]}',
                               'This is another test ${ids[2]}'
                               ),
                           "equation-${ids[3]}" : new EqnElement(new MathItem(
                               '4, 5, 6, 7', '1, 0, 9'),
                               'This is a test ${ids[3]}',
                               'This is another test ${ids[3]}'
                               ),
                           "equation-${ids[4]}" : new EqnElement(new MathItem(
                               '6, 7, 7, 6', '3, 3, 3'),
                               'This is a test ${ids[4]}',
                               'This is another test ${ids[4]}'
                               )
  };

  final Map editors = {
                       "equation-${ids[0]}" : ace.edit(query('#editor-${ids[0]}')),
                       "equation-${ids[1]}" : ace.edit(query('#editor-${ids[1]}')),
                       "equation-${ids[2]}" : ace.edit(query('#editor-${ids[2]}')),
                       "equation-${ids[3]}" : ace.edit(query('#editor-${ids[3]}')),
                       "equation-${ids[4]}" : ace.edit(query('#editor-${ids[4]}'))
  };

  // This is not in the shadow dom since MathJax
  // does not typset inside a polymer-element.
  // This is likely due to js-interop not working
  // with the shadow-dom yet.
  DivElement numeratordiv = query('#numerator-convolution');
  DivElement denominatordiv = query('#denominator-convolution');
  DivElement solutiondiv = query('#solution-convolution');
  DivElement resultsdiv = query('#results-convolution');

  bool get applyAuthorStyles => true;

  created() {
    super.created();
    //print(this.id);
    //print(this.id.split("-")[1]);
    editors[this.id]
      ..theme = new ace.Theme("ace/theme/textmate")
      ..session.mode = new ace.Mode("ace/mode/dart")
      ..session.tabSize = 2
      ..session.useSoftTabs = true;
  }

  String test = """
  final List<String> test = ["string1", "string2"];
  static final Map<String> test2 = new Map(); 
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
  """;

  void render(Event e, var detail, Element target) {
    if (math.firstValue.isEmpty) {
      ncoeff = eqn_element[this.id].initial.firstValue;
    } else {
      ncoeff = math.firstValue;
    }
    if (math.secondValue.isEmpty) {
      dcoeff = eqn_element[this.id].initial.secondValue;
    } else {
      dcoeff = math.secondValue;
    }

    editors[this.id].session.insert(editors[this.id].cursorPosition, test);

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