SuperStrict

'	OBSERVER EXAMPLES
'	(c) Copyright Si Dunford, October 2022

Import bmx.observer

AppTitle="Observer Test 2"
Graphics 800,600

' Allocate custom Event ID
Global EVENT_HITBOTTOM:Int = Observer.Allocate( "Blob has hit the ground" )

Type TGame Implements IObserver
	Global list:TList = CreateList()
	
	Method New()
		' Listen for the EVENT_HITBOTTOM event
		Observer.on( EVENT_HITBOTTOM, Self )
	End Method

	Method Observe( id:Int, data:Object )
		Select id
		Case EVENT_HITBOTTOM
			' Create a message when something hits the ground
			Local entity:TEntity = TEntity(data)
			If entity; New TMSG( entity.x )	
		End Select
	End Method

	Method loop()
		Repeat
			Cls

			For Local entity:TEntity = EachIn list
				entity.update()
			Next
				
			For Local entity:TEntity = EachIn list
				entity.render()
			Next
			
			Flip
		Until KeyHit( KEY_ESCAPE )
	End Method

End Type

Type TEntity
	Field link:TLink
	Field x:Float
	Field y:Float

	Method New()
		link = ListAddLast( TGame.list, Self )
	End Method
	
	Method die()
		link.remove()
	End Method
	
	Method update() Abstract	
	Method render() Abstract
	
End Type

Type TBlob Extends TEntity
	
	Field speed:Float
	
	Method New()
		x = RndFloat() * GraphicsWidth()
		y = RndFloat() * GraphicsHeight()
		speed = RndFloat() * 5 + 1
	End Method
	
	Method update()
		y :+ speed
		If y> GraphicsHeight() 
			' We have hit bottom of screen
			observer.post( EVENT_HITBOTTOM, Self )
			' Re-use object and assign to top of screen
			x = RndFloat() * GraphicsWidth()
			y = 0
		End If
	End Method
	
	Method render()
		SetColor( $00, $FF, $00 )
		DrawOval( x-5,y-5,10,10 )
	End Method
	
End Type

Type TMSG Extends TEntity
	Field message:String
	Field timer:Int

	Method New( pos:Float )
		message = ["Splash","Bang","Sploosh","Splat","Plop"][Rand(0,4)]
		timer = MilliSecs() + 500
		x = pos - TextWidth(message)/2
		y = GraphicsHeight() - TextHeight(message) -2 
	End Method

	Method update()
		If MilliSecs() > timer; die()
	End Method
	
	Method render()
		SetColor( $FF,0,0 )
		DrawText( message, x, y )
	End Method
	
End Type

' Add some blobs
For Local n:Int = 1 Until 10
	New TBlob()
Next

Global game:TGame = New TGame()

game.loop()
