## Building Convolve with Dart and Polymer ##

#### Getting MathJax rendering to work   

- MathJax doesn't render inside a polymer-element tag.  But writing to an element in the dom (ie, outside the shadow dom) should work fine for convolve.  Everything else will use polymer.
- JS-interop works great typesetting specific dom elements with dynamic content.  

So updating a div whose id is stored in the variable `eqndiv` in JavaScript:

````javascript
MathJax.Hub.Queue(["Typeset", MathJax.Hub, eqndiv]));
````

Translates to the following using js-interop:

````dart
var context = js.context;
js.scoped(() {
  new js.Proxy(context.MathJax.Hub.Queue(js.array(["Typeset",
                                                    context.MathJax.Hub,
                                                    eqndiv])));
});
````
