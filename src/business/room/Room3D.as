package business.room {
	
	import alternativa.engine3d.containers.BSPContainer;
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.MipMapping;
	import alternativa.engine3d.core.MouseEvent3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Object3DContainer;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.primitives.Box;
	
	import by.flastar.alternativa.felink.Alternativa3dPhysics;
	
	import flash.display.BitmapData;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Vector3D;
	
	import jiglib.physics.RigidBody;
	
	import model.BasketItem;
	import model.FurnitureProduct;
	import model.PlannerModelLocator;
	

	public class Room3D extends Sprite {
		
		private var container:Object3DContainer = new Object3DContainer();
		private var bspContainer:BSPContainer;
		
		private var cameraController:SimpleObjectController;
		private var camera:Camera3D;
		private var physics:Alternativa3dPhysics;
		private var room:Box;
		private var basketController:BasketController;
		
		// источник событий для контроллера камеры (в нашем случае это drawAreaSprite)
		private var eventSource:InteractiveObject;
		
		// параметры помещения
		private var roomWidth:Number;
		private var roomHeight:Number;
		private var roomLength:Number;
		
		// размеры родительского окна
		private var parentWidth:Number;
		private var parentHeight:Number;
		
		// импортированная модель
		private var furnitureProductMesh:Mesh;
		private var furnitureProductController:SimpleObjectController;
		
		// твердые тела
		private var rigidProduct:RigidBody;
		private var rgBox:RigidBody;
		private var ground:RigidBody;
		
		private const CAMERA_SPEED:Number = 2;
		private const CAMERA_DISTANCE:Number = 8;
		
		public function Room3D(_roomWidth:Number, _roomHeight:Number, _roomLength:Number,
							   parentWidth:Number,parentHeight:Number, _eventSource:InteractiveObject) 
		{
			
			addEventListener(Event.ADDED_TO_STAGE, MainBuild, false, 0, true);
			
			roomWidth = _roomWidth;
			roomHeight = _roomHeight;
			roomLength = _roomLength;
			
			eventSource = _eventSource;
			this.parentWidth = parentWidth - 2;
			this.parentHeight = parentHeight - 75;
			
			basketController = new BasketController();
		}
		
		private function MainBuild(ev:Event):void{
			// Создание камеры и вьюпорта
			camera = new Camera3D();
			camera.view = new View(parentWidth, parentHeight, true);
			addChild(camera.view);
			
			container.addChild(camera);
						
			physics = new Alternativa3dPhysics(container, 1);
			
			initBox();

			setDefaultCameraSettings();

			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function setDefaultCameraSettings():void{
			cameraController = new SimpleObjectController(eventSource, camera, CAMERA_SPEED);
			cameraController.lookAtXYZ(room.x, room.y, room.z);
		}
		
		private function onEnterFrame(e:Event):void {
			physics.engine.integrate(0.2);
			cameraController.update();
			camera.render();
			
			if (furnitureProductController){
				furnitureProductController.update();	
			}
		}
		
		public function removeListener():void{
			stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onResizeEvent(event:Event):void{
			camera.view.width = stage.width;
			camera.view.height = stage.height;
		}
		
		
		private function initBox():void{
			
			[Embed(source="textures/wood-floorboards-texture.jpg")] 
			const EmbedFloorTexture:Class;
			
			[Embed(source="textures/bricks_zigzag_texture.jpg")]
			const EmbedWallTexture:Class;
			
			[Embed(source="textures/celling.jpg")]
			const EmbedCellingTexture:Class;
			
			// создание материалов
			var floorBitmap:BitmapData = new EmbedFloorTexture().bitmapData;
			var floorTexture:TextureMaterial = new TextureMaterial(floorBitmap, false, true, MipMapping.NONE);
			
			var wallBitmap:BitmapData = new EmbedWallTexture().bitmapData;
			var wallTexture:TextureMaterial = new TextureMaterial(wallBitmap);
			
			var cellingBitmap:BitmapData = new EmbedCellingTexture().bitmapData;
			var cellingTexture:TextureMaterial = new TextureMaterial(cellingBitmap);
						
			// Создание комнаты (прямоугольного параллепипеда)
			room = new Box(roomWidth, roomHeight, roomLength, 1,1,1, true, false, 
				wallTexture, wallTexture, wallTexture, wallTexture, floorTexture, cellingTexture);

			physics.createRigidRoom(room, roomWidth, roomLength, roomHeight);
		}

		public function addFurnitureProductToRoom(product:FurnitureProduct):void{
			furnitureProductMesh = product.modelMesh.clone() as Mesh;
		
			basketController.placeFurnitureProductToBasket(product);
			
			// установка в угол комнаты
			furnitureProductMesh.x = roomWidth;
			furnitureProductMesh.y = 0;
			furnitureProductMesh.z = -roomHeight;
			furnitureProductMesh.scaleX = furnitureProductMesh.scaleY = furnitureProductMesh.scaleZ = 0.03;
			
			furnitureProductMesh.addEventListener(MouseEvent3D.CLICK, selectFurnitureProduct);
			furnitureProductMesh.addEventListener(MouseEvent3D.DOUBLE_CLICK, deselectFurnitureProduct);
			
			furnitureProductController = new SimpleObjectController(eventSource, furnitureProductMesh, CAMERA_SPEED);

			container.addChild(furnitureProductMesh);
			
			// добавляем импортируемый предмет мебели под управление библиотеки jiglib
				
			furnitureProductController.disable();
		}
		
		private function selectFurnitureProduct(event:MouseEvent3D):void{
			furnitureProductMesh.filters = [new GlowFilter(0xFFFFFF, 0.5)];
			translateFurnitureProduct();
		}	
		
		private function deselectFurnitureProduct(event:MouseEvent3D):void{
			furnitureProductMesh.filters = [];
			stopTranslateFurnitureProduct();
		}
		
		private function translateFurnitureProduct():void{
			furnitureProductController.enable();
			cameraController.disable();
		}

		
		private function stopTranslateFurnitureProduct():void{
			furnitureProductController.disable();
			cameraController.enable();
		}
		
		public function changeView(mode:int):void{
			if (mode == 0){
				setCameraTo2D();
			}
			else if (mode == 1){
				setDefaultCameraSettings();
			}
		}
		
		private function setCameraTo2D():void{
			camera.z = 25;
			camera.rotationX = -180 * Math.PI/180;
			camera.rotationY = camera.rotationZ = 0;
			cameraController.disable();
		}
	}
}
