SuperStrict

'	OBSERVER EXAMPLES
'	(c) Copyright Si Dunford, December 2022

Import maxgui.drivers
Import bmx.observer

AppTitle="MAXGUI Observer"

Global app:Application = New Application()
app.run()

Type Application Implements IObserver

	Field window:TGadget
	Field quit:Int = False

	Method New()

		' Enable system events
		Observer.Events( True )

		' Listen for MAXGUI events
		Observer.on( EVENT_APPTERMINATE, Self )
		Observer.on( EVENT_WINDOWCLOSE, Self )
		Observer.on( EVENT_WINDOWSIZE, Self )
		Observer.on( EVENT_WINDOWMOVE, Self )

	End Method

	Method Observe( id:Int, data:Object )
		DebugLog( "OBSERVER: " + Observer.name(id) )

		Select id
		Case EVENT_APPTERMINATE
			End
		Case EVENT_WINDOWCLOSE
			End
		Case EVENT_WINDOWSIZE
			Local event:TEvent = TEvent(data)
			If event; DebugLog( event.tostring() )
		Case EVENT_WINDOWMOVE
			Local event:TEvent = TEvent(data)
			If event; DebugLog( event.tostring() )
		EndSelect
		
	End Method
		
	Method run()
		
		Const FLAGS:Int = WINDOW_TOOL | WINDOW_RESIZABLE | WINDOW_TITLEBAR
		window = CreateWindow( AppTitle, 0, 0, 600, 400,, FLAGS )
		
		Repeat
			WaitEvent()		' Process MaxGUI events
			Delay(5)
		Forever
		
	End Method
		
End Type

	