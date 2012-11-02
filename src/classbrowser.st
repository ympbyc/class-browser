| SbModel SbCollection SbView whichMethods |

SbModel := Sebone at:#Model.
SbCollection := Sebone at:#Collection.
SbView := Sebone at:#View.

whichMethods := #instanceMethods.

SbCollection subclass:#ClassCollection variables:#().
!ClassCollection fetch
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
  ]
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
  self setUIConstructor:[$ value:'#editor']
!.
!EditorView render
  self el text: (self model at:#raw) toString
!.
!EditorView update:prop to:val
  self render
!.

SbView subclass:#AppView variables:#().
!AppView init | clColl clPane |
  clColl := ClassCollection new.
  clPane := ClassPaneView new.
  clPane setModel:clColl.
  clColl fetch
!.

$ value:[
  ($ value:'#classMethod') o:#click n:[whichMethods := #classMethods].
  ($ value:'#instanceMethod') o:#click n:[whichMethods := #instanceMethods].
  AppView new
]