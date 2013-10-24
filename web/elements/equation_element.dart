import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:convolab/convolab.dart';
import 'package:js/js.dart' as js;
import 'package:ace/ace.dart' as ace;

class MathItem extends Observable {
  @observable String firstValue, secondValue;
  @observable String firstValueIndex, secondValueIndex;
  MathItem([
            this.firstValue = '',
            this.secondValue = '',
            this.firstValueIndex = '',
            this.secondValueIndex = ''
            ]);
}

class EqnElement extends Observable {
  @observable String paragraphOne, paragraphOneIndex, paragraphTwo, paragraphTwoIndex;
  @observable String toolTipOne, toolTipOneIndex, toolTipTwo, toolTipTwoIndex;
  @observable MathItem initial;
  EqnElement(this.initial, this.paragraphOne, this.paragraphOneIndex,
      this.paragraphTwo, this.paragraphTwoIndex, this.toolTipOne,
      this.toolTipOneIndex, this.toolTipTwo, this.toolTipTwoIndex);
}

@CustomTag('equation-element')
class Equations extends PolymerElement {
  String ncoeff, nindex, dcoeff, dindex;
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
                               '1, 2, 3', '2, 4, 3, 5', '1', '2'),
                               'X Sequence Coefficients:',
                               'Zero Index',
                               'H Sequence Coefficients:',
                               'Zero Index',
                               'A comma separated list of the coefficients'
                                   ' for one of the sequences to be convolved',
                               'The zero index is the index that corresponds'
                                   ' to the coefficient for z^0 in the first sequence',
                               'A comma separated list of the coefficients'
                                   ' for the second sequence to be convolved',
                               'The zero index is the index that corresponds'
                                   ' to the coefficient for z^0 in the second sequence'
                               ),
                           "equation-${ids[1]}" : new EqnElement(new MathItem(
                               '4, 9, 2, 1', '3, 4, 7'),
                               'This is a test ${ids[1]}',
                               '',
                               'This is another test ${ids[1]}',
                               '',
                               'Placeholder for toolTip',
                               'Placeholder for toolTip',
                               'Placeholder for toolTip',
                               'Placeholder for toolTip'
                               ),
                           "equation-${ids[2]}" : new EqnElement(new MathItem(
                               '9, 0, 4', '6, 7, 8'),
                               'This is a test ${ids[2]}',
                               '',
                               'This is another test ${ids[2]}',
                               '',
                               'Placeholder for toolTip',
                               'Placeholder for toolTip',
                               'Placeholder for toolTip',
                               'Placeholder for toolTip'
                               ),
                           "equation-${ids[3]}" : new EqnElement(new MathItem(
                               '4, 5, 6, 7', '1, 0, 9'),
                               'This is a test ${ids[3]}',
                               '',
                               'This is another test ${ids[3]}',
                               '',
                               'Placeholder for toolTip',
                               'Placeholder for toolTip',
                               'Placeholder for toolTip',
                               'Placeholder for toolTip'
                               ),
                           "equation-${ids[4]}" : new EqnElement(new MathItem(
                               '6, 7, 7, 6', '3, 3, 3'),
                               'This is a test ${ids[4]}',
                               '',
                               'This is another test ${ids[4]}',
                               '',
                               'Placeholder for toolTip',
                               'Placeholder for toolTip',
                               'Placeholder for toolTip',
                               'Placeholder for toolTip'
                               )
  };

  final Map editors = {
                       "equation-${ids[0]}" : ace.edit(querySelector('#editor-${ids[0]}')),
                       "equation-${ids[1]}" : ace.edit(querySelector('#editor-${ids[1]}')),
                       "equation-${ids[2]}" : ace.edit(querySelector('#editor-${ids[2]}')),
                       "equation-${ids[3]}" : ace.edit(querySelector('#editor-${ids[3]}')),
                       "equation-${ids[4]}" : ace.edit(querySelector('#editor-${ids[4]}'))
  };

  // This is not in the shadow dom since MathJax
  // does not typset inside a polymer-element.
  // This is likely due to js-interop not working
  // with the shadow-dom yet.
  DivElement numeratordiv = querySelector('#numerator-convolution');
  DivElement denominatordiv = querySelector('#denominator-convolution');
  DivElement solutiondiv = querySelector('#solution-convolution');
  DivElement resultsdiv = querySelector('#results-convolution');

  bool get applyAuthorStyles => true;

  Equations.created() : super.created() {
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

  void compute(Event e, var detail, Element target) {
    e.preventDefault();
    if (math.firstValue.isEmpty) {
      ncoeff = eqn_element[this.id].initial.firstValue;
    } else {
      ncoeff = math.firstValue;
    }
    if (math.firstValueIndex.isEmpty) {
      nindex = eqn_element[this.id].initial.firstValueIndex;
    } else {
      nindex = math.firstValueIndex;
    }
    if (math.secondValue.isEmpty) {
      dcoeff = eqn_element[this.id].initial.secondValue;
    } else {
      dcoeff = math.secondValue;
    }
    if (math.secondValueIndex.isEmpty) {
      dindex = eqn_element[this.id].initial.secondValueIndex;
    } else {
      dindex = math.secondValueIndex;
    }

    editors[this.id].session.insert(editors[this.id].cursorPosition, test);

    Sequence numeqn = sequence(ncoeff.split(",")
        .where((element) => element.trim().isNotEmpty)
          .map((element)=> int.parse(element)));
    Sequence deneqn = sequence(dcoeff.split(",")
        .where((element) => element.trim().isNotEmpty)
          .map((element)=> int.parse(element)));
    Sequence numind = numeqn.position(int.parse(nindex));
    Sequence denind = deneqn.position(int.parse(dindex));
    var convolution = conv(numeqn, deneqn, numind, denind);
    numeratordiv.innerHtml = '<p>'+pstring(numeqn, index:int.parse(nindex), variable:'z', name:'x')+'</p>';
    denominatordiv.innerHtml = '<p>'+pstring(deneqn, index:int.parse(dindex), variable:'z', name:'h')+'</p>';
    solutiondiv.innerHtml = '<p>'+convolution.format(null, 'z', 'y')+'</p>';

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