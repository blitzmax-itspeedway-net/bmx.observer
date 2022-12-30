SuperStrict

'	OBSERVER EXAMPLES
'	(c) Copyright Si Dunford, December 2022

Import bmx.observer

Global EVENT_EXAMPLE:Int = Observer.Allocate( "Example event" )

Type TExample Implements IObserver

	Method Observe( event:Int, data:Object )
		Print( "-> "+Observer.name( event ) )+ " - "+String(data)
	End Method

	Method Enable()
		Observer.on( EVENT_EXAMPLE, Self )
	End Method

	Method Disable()
		Observer.off( EVENT_EXAMPLE, Self )
	End Method
			
End Type

Local example:TExample = New TExample()
Observer.post( EVENT_EXAMPLE, "Message sent before" )

Print "HANDLERS BEFORE: "+Observer.count( EVENT_EXAMPLE )

example.enable()
Observer.post( EVENT_EXAMPLE, "Message sent between" )

Print "HANDLERS BETWEEN: "+Observer.count( EVENT_EXAMPLE )

example.disable()
Observer.post( EVENT_EXAMPLE, "Message sent after" )

Print "HANDLERS AFTER: "+Observer.count( EVENT_EXAMPLE )


