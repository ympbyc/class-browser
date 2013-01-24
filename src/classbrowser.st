| SbModel SbCollection SbView whichMethods |

SbModel := Sebone at:#Model.
SbCollection := Sebone at:#Collection.
SbView := Sebone at:#View.

whichMethods := #instanceMethods. "toggle between #instanceMethods and #classMethods"

SbCollection subclass:#ClassCollection variables:#().
"Collection of classes displayed in the class pane"
!ClassCollection fetch
  "classAnalyser puts them in window"
  (window at:#classes) forEach:[:cl|
    self add:cl
  ]
!.

SbView subclass:#ClassPaneView variables:#(#selectedRow).
!ClassPaneView init
  self setUIConstructor:[$ value:'#class-pane'].
!.
!ClassPaneView render
  self el html:''.
  self model each:[:cl| |row|
    row := $ value:'<li>'.
    row text:(cl at:#className).
    self bindClick:row model:cl.
    row appendTo: self el
  ]
!.
!ClassPaneView onAdd: cl |row|
  row := $ value:'<li>'.
  row text:(cl at:#className).
  self bindClick:row model:cl.
  row appendTo: self el
!.
!ClassPaneView bindClick:row model:m
  row o:#click n:[|mpv edv|
    selectedRow ifTrue:[selectedRow css:#{#backgroundColor:'#fff' #color:'#000'}].
    row css:#{#backgroundColor:'#3261AB' #color:'#fff'}.
    selectedRow := row.

    mpv := MethodPaneView new.
    mpv setModel:m.
    mpv render.

    edv := EditorView new.
    edv setModel:m.
    edv render
  ].
  ($ value:'#classMethod') o:#click n:[whichMethods := #classMethods. selectedRow click].
  ($ value:'#instanceMethod') o:#click n:[whichMethods := #instanceMethods. selectedRow click].
!.

SbView subclass:#MethodPaneView variables:#(#selectedRow).
!MethodPaneView init
  self setUIConstructor:[$ value:'#method-pane'].
!.
!MethodPaneView render
  self el html:''.
  (self model at:whichMethods) forEach:[:im| |row|
    row := $ value:'<li>'.
    row text:(im at:#methodName).
    self bindClick:row model:im.
    row appendTo: self el
  ]
!.
!MethodPaneView bindClick:row model:m
  row o:#click n:[|edv|
    selectedRow ifTrue:[selectedRow css:#{#backgroundColor:'#fff' #color:'#000'}].
    row css:#{#backgroundColor:'#3261AB' #color:'#fff'}.
    selectedRow := row.

    edv := EditorView new.
    edv setModel:m.
    edv render
  ]
!.

SbView subclass:#EditorView variables:#().
!EditorView init
  self setUIConstructor:[$ value:'#editor-content']
!.
!EditorView render
  self el text: (self model at:#raw) toString.
  window sh_highlightDocument
!.
!EditorView update:prop to:val
  self render
!.


SbView subclass:#AppView variables:#().
!AppView init | clColl clPane |
  clColl := ClassCollection new.
  clPane := ClassPaneView new.
  clPane setModel:clColl.
  clColl fetch.

  self listenEvents
!.
!AppView listenEvents | changeSchemeBtn |
  changeSchemeBtn := ($ value:'#color-scheme').
  changeSchemeBtn o:#click n:[ :e |
    changeSchemeBtn text === 'light' ifTrue:[
      changeSchemeBtn text: 'dark'.
      ($ value:'pre.sh_sourceCode') css: #{#backgroundColor:'#fff' #color:'#000'}
    ] ifFalse: [
       changeSchemeBtn text: 'light'.
      ($ value:'pre.sh_sourceCode') css: #{#backgroundColor:'#342826' #color:'#fff'}
    ]
  ]
!.

$ value:[
  AppView new
]