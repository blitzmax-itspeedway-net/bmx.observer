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

| | | | |
|---|---|---|---|---|
| EVENT_APPMASK | EVENT_APPSUSPEND | EVENT_APPRESUME | EVENT_APPTERMINATE |
| EVENT_APPOPENFILE | EVENT_APPIDLE | EVENT_KEYMASK | EVENT_KEYDOWN |
| EVENT_KEYUP | EVENT_KEYCHAR | EVENT_KEYREPEAT | EVENT_MOUSEMASK |
| EVENT_MOUSEDOWN | EVENT_MOUSEUP | EVENT_MOUSEMOVE | EVENT_MOUSEWHEEL |
| EVENT_MOUSEENTER | EVENT_MOUSELEAVE | EVENT_TIMERMASK | EVENT_TIMERTICK |
| EVENT_HOTKEYMASK | EVENT_HOTKEYHIT | EVENT_GADGETMASK | EVENT_GADGETACTION |
| EVENT_GADGETPAINT | EVENT_GADGETSELECT | EVENT_GADGETMENU | EVENT_GADGETOPEN |
| EVENT_GADGETCLOSE | EVENT_GADGETDONE | EVENT_GADGETLOSTFOCUS | EVENT_GADGETSHAPE |
| EVENT_WINDOWMASK | EVENT_WINDOWMOVE | EVENT_WINDOWSIZE | EVENT_WINDOWCLOSE |
| EVENT_WINDOWACTIVATE | EVENT_WINDOWACCEPT | EVENT_WINDOWMINIMIZE | EVENT_WINDOWMAXIMIZE |
| EVENT_WINDOWRESTORE | EVENT_MENUMASK | EVENT_MENUACTION | EVENT_STREAMMASK |
| EVENT_STREAMEOF | EVENT_STREAMAVAIL | EVENT_PROCESSMASK | EVENT_PROCESSEXIT |
| EVENT_TOUCHMASK | EVENT_TOUCHDOWN | EVENT_TOUCHUP | EVENT_TOUCHMOVE |
| EVENT_MULTIGESTURE | EVENT_USEREVENTMASK | | |

## Flip Event Support
```
Observer.Flip( True|False )
```
Adding support for flip events will allow you to subscribe to the `EVENT_FLIP` event.
