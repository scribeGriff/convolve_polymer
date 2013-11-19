## Building Convolve with Dart and Polymer ##

#### Getting MathJax rendering to work   

- MathJax doesn't render inside a polymer-element tag (or possibly it is a problem using js-interop with Polymer.dart according to [this](http://stackoverflow.com/questions/19156471/using-google-maps-lib-with-polymer "using js-interop with polymer.dart")).  But writing to an element in the dom (ie, outside the shadow dom) should work fine for convolve.  Everything else will use polymer.
- JS-interop works great typesetting specific dom elements with dynamic content.  

So updating a div whose id is stored in the variable `eqndiv` in JavaScript:

````javascript
MathJax.Hub.Queue(["Typeset", MathJax.Hub, resultsdiv]));
````

Translates to the following using js-interop:

````dart
import 'package:js/js.dart' as js;

js.Proxy context = js.context;
context.MathJax.Hub.Queue(js.array(["Typeset", context.MathJax.Hub, resultsdiv]));
````

#### Screenshot ####

![Font Awesome - ness](http://www.scribegriff.com/dartlang/github/convolve/convolve_polymer_fa.jpg)
