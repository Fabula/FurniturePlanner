package business.room
{
	import flash.display.InteractiveObject;
	import flash.events.KeyboardEvent;

	public class KeyManager
	{
		
		public static const W:uint = 0x57;
		public static const RIGHT:uint = 37;
		public static const UP:uint = 38;
		public static const DOWN:uint = 40;
		
		private var eventSource:InteractiveObject;
		private var pressed:Object = {W: false, right: false, up: false, down: false};
		
		public function KeyManager(eventSource:InteractiveObject)
		{
			this.eventSource = eventSource;
			eventSource.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			eventSource.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		public function getKeys():Object{
			var keys:Object = {x: 0, y:0};
			if (pressed.W) keys.x -= 1;
			if (pressed.rigth) keys.x += 1;
			if (pressed.up) keys.y -= 1;
			if (pressed.down) keys.y += 1;
			
			return keys;
		}
		
		private function onKeyDown(event:KeyboardEvent):void{
			switch(event.keyCode){
				case W:
					pressed.W = true;
					break;
				case RIGHT:
					pressed.right = true;
					break;
				case UP:
					pressed.up = true;
					break;
				case DOWN:
					pressed.down = true;
					break;
			}
		}
		
		private function onKeyUp(event:KeyboardEvent):void{
			switch(event.keyCode){
				case W:
					pressed.W = false;
					break;
				case RIGHT:
					pressed.right = false;
					break;
				case UP:
					pressed.up = false;
					break;
				case DOWN:
					pressed.down = false;
					break;
			}
		}
	}
}