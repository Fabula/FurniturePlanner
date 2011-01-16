package business.room
{
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.primitives.Box;
	
	import flash.display.InteractiveObject;
	import flash.geom.Vector3D;
		
	public class ExCamera extends Camera3D
	{
		public var cameraController:SimpleObjectController;
		private var eventSource:InteractiveObject;
		
		private var room:Room;

		private const CAMERA_SPEED:Number = 2;
		
		public function ExCamera(parentWidth:Number, parentHeight:Number, room:Room, eventSource:InteractiveObject)
		{
			this.view = new View(parentWidth, parentHeight);
			this.room = room;
			this.eventSource = eventSource;
			
			setCameraTo3D();
			
		}
		
		public function setCameraTo3D():void{
			cameraController = new SimpleObjectController(eventSource, this, CAMERA_SPEED);
			
			// ставим камеру, не точно в угол комнаты, а немного подальше от него.
			var m:Number = 0.01;
			
			cameraController.setObjectPos(new Vector3D(room.width/2 - m ,room.length/2 - m, room.height/2 - m));
			cameraController.lookAtXYZ(room.x, room.y, room.z);
		}
		
		public function setCameraTo2D():void{
			cameraController.disable();
			x = y = 0;

			z = Math.max(room.width, room.height) / (2 * Math.tan(fov/2)) * 4;
			
			rotationX = -180 * Math.PI/180;
			rotationY = rotationZ = 0;
		}
	}
}