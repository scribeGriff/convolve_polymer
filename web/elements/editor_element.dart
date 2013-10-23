import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:ace/ace.dart' as ace;

// This will not work until js-interop works with polymer.

@CustomTag('editor-element')
class Editor extends PolymerElement {
  String test = """
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

  var editor;

  Editor.created() : super.created() {
    Element aceElement = $['editor'];
    editor = ace.edit($['editor'])
        ..theme = new ace.Theme("ace/theme/clouds_midnight")
    ..session.mode = new ace.Mode("ace/mode/dart");
    editor.session.tabSize = 2;
    editor.session.useSoftTabs = true;
    editor.session.insert(editor.cursorPosition, "$test");
  }
}