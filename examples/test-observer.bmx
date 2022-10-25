SuperStrict

Import bmx.observer

AppTitle="Observer Test"
Graphics 300,200

Type TWatcher Implements IObserver

	Method New()
		Observer.on( EVENT_FLIP, Self )
		Observer.on( EVENT_MOUSEMOVE, Self )
	End Method
	
	Method Observe( event:Int, data:Object )
		Print( "-> "+Observer.name( event ) )
	End Method
	
End Type

Global TF:String[] = ["disabled","ENABLED"]

Local watcher:TWatcher = New TWatcher()

Local events:Int = False
Local flips:Int = False

Repeat
	Cls
	
	DrawText( "E) - Toggle System Events - "+TF[events], 0, 10 )
	DrawText( "F) - Toggle Flip Events   - "+TF[flips], 0, 25 )
	
	If KeyHit( KEY_F )
		flips = Not flips
		Observer.Flip( flips )
		Print( "# FLIP EVENTS: "+Upper( TF[flips] ) )
	End If

	If KeyHit( KEY_E )
		events = Not events
		Observer.Events( events )
		Print( "# SYSTEM EVENTS: "+Upper( TF[events] ) )
	End If
	
	Flip
	Delay(1)
Until KeyHit( KEY_ESCAPE ) Or AppTerminate()
