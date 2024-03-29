| isFunction classAnalysis instanceMethodsAnalysis classMethodsAnalysis classes SbModel|
SbModel := Sebone at:#Model. "Just to make it possible to treat this object as a model"
SbModel subclass:#JsClass variables:#(#className #superClass #instanceVariables #instanceMethods #classMethods #classVariables #raw #fullpath).
!JsClass init
  instanceVariables := #().
  instanceMethods   := #().
  classVariables    := #().
  classMethods      := #()
!.
SbModel subclass:#JsMethod variables:#(#methodName #raw #fullpath).
classes := #().

isFunction := [:obj|
  (<typeof obj> === 'function') 
  || (<obj instanceof Function>)
].

classAnalysis := [:obj :nameSpace|
  nameSpace := nameSpace || ''.
  [
    (Object getOwnPropertyNames:obj) forEach:[:key| |aClass|
      (key charAt:0) toUpperCase === (key charAt:0) ifTrue:[ "is it a class?"
        | notConstructor |
        [(obj at:key) new] tryCatch:[
          "NameSpace?"
          notConstructor := true.
          classAnalysis value:(obj at:key) value: nameSpace + key + '.'
        ].
  
        notConstructor ifFalse:[
          aClass := JsClass new.
          aClass at:#className put:nameSpace + key.
          aClass at:#raw put:(obj at:key).
          aClass at:#fullpath put:nameSpace + key.
          aClass at:#superClass put:((obj at:key) at:#constructor)||[].
          instanceMethodsAnalysis value:aClass.
          classMethodsAnalysis value:aClass.
          classes push:aClass
        ]
      ]
    ]
  ] tryCatch:[:e|console log:e]
].

instanceMethodsAnalysis := [:aClass| | proto |
  proto := ((aClass at:#raw) at:#prototype) || #{}.
  (Object getOwnPropertyNames:proto) forEach:[:key|
    ([(isFunction value:(proto at:key))] tryCatch:[]) ifTrue:[
      (aClass at:#instanceMethods) push:(
        JsMethod new
        ; at:#methodName put:key
        ; at:#raw put:(proto at:key)
        ; at:#fullpath put:(aClass at:#className)+'.prototype.'+key)
    ] ifFalse:[
      (aClass at:#instanceVariables) push:key
    ]
  ]
].

classMethodsAnalysis := [:aClass| | rawClass |
  rawClass := aClass at:#raw.
  (Object getOwnPropertyNames:rawClass) forEach:[:key|
    ([(isFunction value:(rawClass at:key))] tryCatch:[]) ifTrue:[
      (aClass at:#classMethods) push:(
        JsMethod new
        ; at:#methodName put:key
        ; at:#raw put:(rawClass at:key)
        ; at:#fullpath put:(aClass at:#className)+'.'+key)
    ] ifFalse:[
      (aClass at:#classVariables) push:key
    ]
  ]
].

classAnalysis value:window.

(window hasOwnProperty:#Object) ifFalse:[
  classAnalysis value:#{
    #Array   : Array
    #Boolean : Boolean
    #Date    : Date
    #Function: Function
    #Math    : Math
    #Number  : Number
    #Object  : Object
    #RegExp  : RegExp
    #String : String
  }
].

window at:#classes put:classes.

classes