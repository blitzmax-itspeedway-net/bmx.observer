SuperStrict

'   OBSERVER FOR BLITZMAX-NG
'   (c) Copyright Si Dunford, Oct 2022, All Rights Reserved
'   V1.1

Rem
bbdoc: bmx.observer
about: 
End Rem
Module bmx.observer

ModuleInfo "Copyright: Si Dunford, Oct 2022, All Rights Reserved"
ModuleInfo "Author:    Si Dunford"
ModuleInfo "Version:   1.1"
ModuleInfo "License:   MIT"

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
	
	' Prevent instance creation by making New() private
	Method New() ; End Method
	
	Function _EventHook:Object( id:Int, data:Object, context:Object )
		Local ev:TEvent = TEvent(data)
		If Not ev; Return data
		post( ev.id, data )
		Return data
	End Function

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
		Local list:TList = TList( _events[ event ] )
		If Not list
			list = New TList()
			_events[event] = list
		End If
		list.addlast( handler )
	End Function
	
	' Remove an event listener: Type must implement IObserver
	Function off( event:Int, handler:IObserver )
		If Not _events.contains( event ); Return
		Local list:TList = TList( _events[ event ] )
		For Local callback:IObserver = EachIn list
			If callback = handler; list.remove( callback )
		Next
		If list.isempty(); _events.remove(event)
	End Function
	
	' Publish an event to all subscribers
	Function post( event:Int, data:Object )
		If Not _events.contains( event ); Return
		Local list:TList = TList( _events[ event ] )
		If Not list; Return	' This should never happen
		For Local callback:IObserver = EachIn list 
			callback.Observe( event, data )
		Next
	End Function

	' Add/Remove system events to the observer system
	Function Events( add:Int = True )
		If add
			AddHook( EmitEventHook, _EventHook )
		Else
			RemoveHook( EmitEventHook, _EventHook )
		EndIf
	End Function

	' Add/Remove flip events to the observer system
	Function Flip( add:Int = True )
		If add
			AddHook( FlipHook, _FlipHook )
		Else
			RemoveHook( FlipHook, _FlipHook )
		EndIf
	End Function	
End Type


