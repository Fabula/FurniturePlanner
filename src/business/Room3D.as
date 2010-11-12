package business {
	
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3DContainer;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.primitives.Box;
	import alternativa.engine3d.primitives.Plane;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import model.PlannerModelLocator;
	
	/**
	 * Создание простейшего трёхмерного приложения на Alternativa3D.
	 */
	public class Room3D extends Sprite {
		
		private var container:Object3DContainer = new Object3DContainer();
		private var controller:SimpleObjectController;
		private var camera:Camera3D;
		private var box:Box;
		private var plane:Plane;
		
		private var roomWidth:Number;
		private var roomHeight:Number;
		private var roomLength:Number;
		
		private var mainAppModel:PlannerModelLocator = PlannerModelLocator.getInstance();
		
		
		public function Room3D(width:Number, height:Number, length:Number) {
			addEventListener(Event.ADDED_TO_STAGE, MainBuild, false, 0, true);
			roomWidth = width;
			roomHeight = height;
			roomLength = length;
		}
		
		private function MainBuild(ev:Event):void{
			// Создание камеры и вьюпорта
			camera = new Camera3D();
			camera.view = new View(mainAppModel.toolAreaWidth, mainAppModel.toolAreaHeight,true);
			addChild(camera.view);
			container.addChild(camera);
			
			// Создание примитива
			box = new Box(roomWidth, roomHeight, roomLength, 1,1,1, true);
			var material:FillMaterial = new FillMaterial(0x000000, 1, 1);
			box.setMaterialToAllFaces(material);
			container.addChild(box);
			
			
			// Подписка на события
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void {
			box.x = box.x + 1;
			controller.update();
			camera.render();
		}
		
	}
}
