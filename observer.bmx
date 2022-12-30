SuperStrict

'   OBSERVER FOR BLITZMAX-NG
'   (c) Copyright Si Dunford, Oct 2022, All Rights Reserved
'   V1.5

Rem
bbdoc: bmx.observer
about: 
End Rem
Module bmx.observer

ModuleInfo "Copyright: Si Dunford, Oct 2022, All Rights Reserved"
ModuleInfo "Author:    Si Dunford"
ModuleInfo "Version:   1.5"
ModuleInfo "License:   MIT"

ModuleInfo "History: V1.5, 30 DEC 2022"
ModuleInfo "History: Added .count()"

ModuleInfo "History: V1.4, 21 DEC 2022"
ModuleInfo "History: Single threaded by default, added threaded() method"

ModuleInfo "History: V1.3, 08 DEC 2022"
ModuleInfo "History: Threadsafe"

ModuleInfo "History: V1.2, 08 DEC 2022"
ModuleInfo "History: Added support for events debugging"

ModuleInfo "History: V1.1, 23 OCT 2022"
ModuleInfo "History: Updated event type to INT from STRING"
ModuleInfo "History: Added support for EmitEventHook and FlipHook"
ModuleInfo "History: Added test-observer.bmx"
ModuleInfo "History: First Public version available on Github"

ModuleInfo "History: V1.0, 15 OCT 2022"
ModuleInfo "History: First Release"

Import BRL.Event		' TEvent, AllocUserEventId
Import BRL.Map			' TIntMap
Import BRL.LinkedList	' TList
Import BRL.Graphics		' FlipHook
Import BRL.Threads		' Mutex/Threading

' Create event ID for FLIP Event
Global EVENT_FLIP:Int = Observer.Allocate( "flip" )

' Create Interface for the Observer
Interface IObserver
	Method Observe( event:Int, data:Object )
End Interface

' Observer Namespace
Type Observer
	Private
	Global _events:TIntMap = New TIntMap()
	
	Global DEBUGGER:Int = Allocate( "Event Debugger" )			'[1.2]
	Global _mutex:TMutex = CreateMutex()						'[1.3]
	Global _threadsafe:Int = False								'[1.4]
	
	' Prevent instance creation by making New() private
	Method New() ; End Method

	'[1.1] Private eventhook handler
	Function _EventHook:Object( id:Int, data:Object, context:Object )
		Local ev:TEvent = TEvent(data)
		'If ev; DebugLog( "POSTING EVENT "+ev.id )
		If ev; post( ev.id, data )
		Return data
	End Function

	'[1.1] Private fliphook handler
	Function _FlipHook:Object( id:Int, data:Object, context:Object )
		post( EVENT_FLIP, Null )
		Return data
	End Function
	
	Public
	
	' Allocate a new event ID
	Function Allocate:Int( descr:String )
		Return AllocUserEventId( descr )
	End Function
	
	' Obtain an event name for a given event ID
	Function Name:String( event:Int )
		Return TEvent.DescriptionForId( event )
	End Function
		
	' Add an event listener: Type must implement IObserver
	Function on( event:Int, handler:IObserver )
		If _threadsafe; LockMutex( Observer._mutex )			'[1.3, 1.4]
		Local list:TList = TList( _events[ event ] )
		If Not list
			list = New TList()
			_events[event] = list
		End If
		list.addlast( handler )
		If _threadsafe; UnlockMutex( Observer._mutex )			'[1.3, 1.4]
	End Function
	
	' Remove an event listener: Type must implement IObserver
	Function off( event:Int, handler:IObserver )
		If Not _events.contains( event ); Return
		If _threadsafe; LockMutex( Observer._mutex )			'[1.3, 1.4]
		Local list:TList = TList( _events[ event ] )
		For Local callback:IObserver = EachIn list
			If callback = handler; list.remove( callback )
		Next
		If list.isempty(); _events.remove(event)
		If _threadsafe; UnlockMutex( Observer._mutex )			'[1.3, 1.4]
	End Function
	
	' Publish an event to all subscribers
	Function post( event:Int, data:Object )
		' [1.2] added support for event debugging
		If _events.contains( DEBUGGER ); _post( event, DEBUGGER, data )
		If _events.contains( event ); _post( event, event, data )
		
		'[1.2] post moved to inner function so it can be used twice
		Function _post( event:Int, handler:Int, data:Object )
			Local list:TList = TList( _events[ handler ] )
			If Not list; Return	' This should never happen
			' NOTE, Making this threadsafe causes deadlocks if observer used inside handler!
			For Local callback:IObserver = EachIn list 
				' Prevent list changes from returning null
				If callback
					callback.Observe( event, data )
				Else
					Exit
				End If
			Next
		End Function
		
	End Function

	'[1.1] Add/Remove system events to the observer system
	Function Events( add:Int = True )
		If add
			AddHook( EmitEventHook, _EventHook )
		Else
			RemoveHook( EmitEventHook, _EventHook )
		EndIf
	End Function

	'[1.1] Add/Remove flip events to the observer system
	Function Flip( add:Int = True )
		If add
			AddHook( FlipHook, _FlipHook )
		Else
			RemoveHook( FlipHook, _FlipHook )
		EndIf
	End Function

	'[1.2] provide interface for debugging
	Function debug( handler:IObserver, enable:Int = True)
		If enable
			on( DEBUGGER, handler )
		Else
			off( DEBUGGER, handler )
		End If
	End Function
	
	' [1.4] Optional threaded support
	Function threaded( state:Int = True )
		_threadsafe = state
	End Function

	' [1.5] Count number of handlers for given event
	Function count:Int( event:Int )
		If Not _events.contains( event ); Return 0
		Local list:TList = TList( _events[ event ] )
		Return list.count()
	End Function
	
End Type


