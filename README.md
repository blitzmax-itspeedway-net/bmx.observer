# Module bmx.observer

An event observer system easily added to any existing type.

**VERSION:** 1.0

# DEPENDENCIES
* [BlitzMax-NG](https://blitzmax.org/downloads/)

# MANUAL INSTALL USING GIT
**LINUX:**
```
    # mkdir -p ~/BlitzMax/mod/bmx.mod
    # cd ~/BlitzMax/mod/bmx.mod
    # git clone https://github.com/blitzmax-itspeedway-net/observer.mod.git
    # cd observer.mod
    # chmod +x compile.sh
    # ./compile.sh
```
**WINDOWS:**
```
    C:\> mkdir C:\BlitzMax\mod\bmx.mod
    C:\> cd /d C:\BlitzMax\mod\bmx.mod
    C:\> git clone https://github.com/blitzmax-itspeedway-net/observer.mod.git
    C:\> cd observer.mod
    C:\> compile.bat
```

# MANUAL INSTALL USING ZIP
* Create a folder in your BlitzMax/mod folder called "bmx.mod"
* Download ZIP file from GitHub and unzip it: You will have a folder called observer.mod.
* Copy folder observer.mod-main/observer.mod to BlitzMax/mod/bmx.mod/
* Run the compile.sh or compile.bat file located in the lexer.mod folder to compile

# UPDATE USING GIT
**LINUX:**
```
    # cd ~/BlitzMax/mod/bmx.mod/observer.mod
    # git pull
    # chmod +x compile.sh
    # ./compile.sh
```
**WINDOWS:**
```
    C:\> cd /d C:\BlitzMax\mod\bmx.mod\observer.mod
    C:\> git pull
    C:\> compile.bat
```

# Importing the module
```
import bmx.observer
```

# Using the Module

## Adding a custom event
```
Global EVENT_EXPLOSION:int = Observer.Allocate( "Explosion" )
```

## Getting an event name
```
Local eventName:String = Observer.name( EVENT_EXPLOSION )
```

## Posting an event
```
Observer.post( EVENT_EXPLOSION, data )
```

## Adding an event listener
An event listener can be added to any existing type, simply by adding an `Implements IObserver` to the definition:
```
Type MyType Implements IObserver

    Method New()
        Observer.on( EVENT_EXPLOSION, self )
    End Method

    Method Observe( event:Int, data:Object )
        Debuglog( "MyType:Observe(): "+Observer.name( event ) )
    End Method

End Type
```
## System Event Support
```
Observer.Events( True|False )
```
Adding support for system events will allow you to subscribe to all the standard Blitzmax events which include the following:
(Some of these are MaxGUI Specific).

| EVENT_APPMASK | EVENT_APPSUSPEND | EVENT_APPRESUME | EVENT_APPTERMINATE |
| :- | :- | :- | :- |
| __EVENT_APPOPENFILE__ | __EVENT_APPIDLE__ | __EVENT_KEYMASK__ | __EVENT_KEYDOWN__ |
| __EVENT_KEYUP__ | __EVENT_KEYCHAR__ | __EVENT_KEYREPEAT__ | __EVENT_MOUSEMASK__ |
| __EVENT_MOUSEDOWN__ | __EVENT_MOUSEUP__ | __EVENT_MOUSEMOVE__ | __EVENT_MOUSEWHEEL__ |
| __EVENT_MOUSEENTER__ | __EVENT_MOUSELEAVE__ | __EVENT_TIMERMASK__ | __EVENT_TIMERTICK__ |
| __EVENT_HOTKEYMASK__ | __EVENT_HOTKEYHIT__ | __EVENT_GADGETMASK__ | __EVENT_GADGETACTION__ |
| __EVENT_GADGETPAINT__ | __EVENT_GADGETSELECT__ | __EVENT_GADGETMENU__ | __EVENT_GADGETOPEN__ |
| __EVENT_GADGETCLOSE__ | __EVENT_GADGETDONE__ | __EVENT_GADGETLOSTFOCUS__ | __EVENT_GADGETSHAPE__ |
| __EVENT_WINDOWMASK__ | __EVENT_WINDOWMOVE__ | __EVENT_WINDOWSIZE__ | __EVENT_WINDOWCLOSE__ |
| __EVENT_WINDOWACTIVATE__ | __EVENT_WINDOWACCEPT__ | __EVENT_WINDOWMINIMIZE__ | __EVENT_WINDOWMAXIMIZE__ |
| __EVENT_WINDOWRESTORE__ | __EVENT_MENUMASK__ | __EVENT_MENUACTION__ | __EVENT_STREAMMASK__ |
| __EVENT_STREAMEOF__ | __EVENT_STREAMAVAIL__ | __EVENT_PROCESSMASK__ | __EVENT_PROCESSEXIT__ |
| __EVENT_TOUCHMASK__ | __EVENT_TOUCHDOWN__ | __EVENT_TOUCHUP__ | __EVENT_TOUCHMOVE__ |
| __EVENT_MULTIGESTURE__ | __EVENT_USEREVENTMASK__ | | |

## Flip Event Support
```
Observer.Flip( True|False )
```
Adding support for flip events will allow you to subscribe to the `EVENT_FLIP` event.
