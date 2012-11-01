| isFunction classAnalysis instanceMethodsAnalysis classMethodsAnalysis classes SbModel|
SbModel := Sebone at:#Model. "Just to make it possible to treat this object as a model"
SbModel subclass:#JsClass variables:#(#className #superClass #instanceVariables #instanceMethods #classMethods #classVariables #raw).
!JsClass init
  instanceVariables := #().
  instanceMethods   := #().
  classVariables    := #().
  classMethods      := #()
!.
SbModel subclass:#JsMethod variables:#(#methodName #raw).
classes := #().

isFunction := [:obj|
  (<typeof obj> === 'function') 
  || (<obj instanceof Function>)
].

classAnalysis := [:obj|
  (Object keys:obj) forEach:[:key| |aClass|
    (key charAt:0) toUpperCase === (key charAt:0) ifTrue:[ "is it a class?"
      aClass := JsClass new.
      aClass at:#className put:key.
      aClass at:#raw put:(obj at:key).
      aClass at:#superClass put:((obj at:key) at:#constructor)||[].
      instanceMethodsAnalysis value:aClass.
      classMethodsAnalysis value:aClass.
      classes push:aClass
    ]
  ]
].

instanceMethodsAnalysis := [:aClass| | proto |
  proto := ((aClass at:#raw) at:#prototype) || #{}.
  (Object keys:proto) forEach:[:key|
    (isFunction value:(proto at:key)) ifTrue:[
      (aClass at:#instanceMethods) push:(JsMethod new; at:#methodName put:key; at:#raw put:(proto at:key))
    ] ifFalse:[
      (aClass at:#instanceVariables) push:key
    ]
  ]
].

classMethodsAnalysis := [:aClass| | rawClass |
  rawClass := aClass at:#raw.
  (Object keys:rawClass) forEach:[:key|
    (isFunction value:(rawClass at:key)) ifTrue:[
      (aClass at:#classMethods) push:(JsMethod new; at:#methodName put:key; at:#raw put:(rawClass at:key))
    ] ifFalse:[
      (aClass at:#classVariables) push:key
    ]
  ]
].

classAnalysis value:window.

window at:#classes put:classes.

classes