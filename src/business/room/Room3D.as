package business.room {
	
	import alternativa.engine3d.containers.BSPContainer;
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.MipMapping;
	import alternativa.engine3d.core.MouseEvent3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Object3DContainer;
	import alternativa.engine3d.core.RayIntersectionData;
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
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import jiglib.physics.RigidBody;
	
	import model.BasketItem;
	import model.FurnitureProduct;
	import model.PlannerModelLocator;
	import model.ProductPosition;
	
	import mx.controls.Alert;
	

	public class Room3D extends Sprite{
		
		private var mainAppModel:PlannerModelLocator = PlannerModelLocator.getInstance();
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
		public var roomWidth:Number;
		public var roomHeight:Number;
		public var roomLength:Number;
		
		// размеры родительского окна
		private var parentWidth:Number;
		private var parentHeight:Number;
		
		// твердые тела
		private var rigidProduct:RigidBody;
		private var rgBox:RigidBody;
		private var ground:RigidBody;
		
		private const CAMERA_SPEED:Number = 2;
		private const CAMERA_DISTANCE:Number = 8;
		
		private var mousePosition:Vector3D;
		private var currentSelectedProduct:Mesh;
		private var moveProduct:Boolean = false;
		
		// сохраняем координаты предметов мебели
		public var productsPositions:Array;
	
		public function Room3D(_roomWidth:Number, _roomLength:Number, _roomHeight:Number,
							   parentWidth:Number,parentHeight:Number, _eventSource:InteractiveObject) 
		{
			
			addEventListener(Event.ADDED_TO_STAGE, MainBuild, false, 0, true);
			
			roomWidth = _roomWidth;
			roomHeight = _roomHeight;
			roomLength = _roomLength;
			
			eventSource = _eventSource;
			this.parentWidth = parentWidth - 2;
			this.parentHeight = parentHeight - 75;
			
			productsPositions = new Array();
			
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
			container.addEventListener(MouseEvent3D.CLICK, onClickEvent);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function setDefaultCameraSettings():void{
			cameraController = new SimpleObjectController(eventSource, camera, CAMERA_SPEED);
			
			// ставим камеру, не точно в угол комнаты, а немного подальше от него.
			var m:Number = 0.01;
			
			cameraController.setObjectPos(new Vector3D(roomWidth/2 - m ,roomLength/2 - m,roomHeight/2 - m));
			cameraController.lookAtXYZ(room.x, room.y, room.z);
		}
		
		private function onEnterFrame(e:Event):void {
			physics.engine.integrate(0.2);
			cameraController.update();
			camera.render();
		}
		
		public function removeListener():void{
			stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
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
			room = new Box(roomWidth, roomLength, roomHeight, 1,1,1, true, false, 
				wallTexture, wallTexture, wallTexture, wallTexture, floorTexture, cellingTexture);

			physics.createRigidRoom(room, roomWidth, roomLength, roomHeight);
		}

		public function addFurnitureProductToRoom(product:FurnitureProduct, matrix:Matrix3D = null):void{
			var furnitureProductMesh:Mesh = product.modelMesh.clone() as Mesh;
			basketController.placeFurnitureProductToBasket(product, furnitureProductMesh);
						
			// если указана матрица трансформации
			if (matrix){
				furnitureProductMesh.matrix = matrix.clone();
			}
			else{
				furnitureProductMesh.x = furnitureProductMesh.y = 0;
				furnitureProductMesh.z = -roomHeight/2;
			}
			
			furnitureProductMesh.scaleX = furnitureProductMesh.scaleY = furnitureProductMesh.scaleZ = 0.0015;
			
			furnitureProductMesh.addEventListener(MouseEvent3D.CLICK, selectFurnitureProduct);
			
			container.addChild(furnitureProductMesh);

			var productPosition:ProductPosition = new ProductPosition(furnitureProductMesh.matrix, product.furnitureProductID);
			productsPositions.push(productPosition);
			
		}
		
		private function quantityOfIdenticProduct(product:FurnitureProduct):int{
			var count:int = 0;
			
			for each (var item:BasketItem in mainAppModel.customerBasket){
				if (item.furnitureProductID == product.furnitureProductID){
					count++;
				}
			}
			
			return count;
			
		}
		
		private function onKeyDown(event:KeyboardEvent):void{
			if (currentSelectedProduct){
				// удаляем из контейнера
				container.removeChild(currentSelectedProduct);
				// удаляем из корзины
				basketController.removeFurnitureProductFromBasket(currentSelectedProduct);
				// удаляем из productsPositions
				
				var index:int = -1;
				for each (var prodPos:ProductPosition in productsPositions){
					// по мешу ищем productID;
					// удаляем
				}
			}
		}
		
		public function importModelToRoom(productID:int, matrix:Matrix3D):void{
			var mainAppModel:PlannerModelLocator = PlannerModelLocator.getInstance();
			var pr:FurnitureProduct;
			
			for each(var product:FurnitureProduct in mainAppModel.furnitureProducts){
				if (productID == product.furnitureProductID){
					pr = product;
				}
			}

			addFurnitureProductToRoom(pr, matrix);
		}
		
		private function selectFurnitureProduct(event:MouseEvent3D):void{
			var furnitureProduct:Mesh = event.target as Mesh;
			moveProduct = !moveProduct;
			
			if (moveProduct){
				furnitureProduct.filters = [new GlowFilter(0xFFFFFF, 0.5)];
				currentSelectedProduct = furnitureProduct;
			}
			else{
				furnitureProduct.filters = [];
				currentSelectedProduct = null;
			}
			
		}	
		
		private function onClickEvent(event:MouseEvent3D):void{
			mousePosition = getMouseVector3d(event, container);
			
			// если предмет выбран
			if (currentSelectedProduct){
				currentSelectedProduct.x = mousePosition.x;
				currentSelectedProduct.y = mousePosition.y;
				
				var productID:int = searchProduct(currentSelectedProduct);
				
				// используя productID
				var matrix:Matrix3D = currentSelectedProduct.matrix.clone();
				updateProductMatrix(productID, matrix);
			}
		}

		public function getMouseVector3d(mouseEvent:MouseEvent3D, container:Object3DContainer,excludeObjecsFromTouch:Dictionary = null):Vector3D
		{
			var data:RayIntersectionData = container.intersectRay(mouseEvent.localOrigin, mouseEvent.localDirection, excludeObjecsFromTouch);
			if (data != null)
			{
				return data.object.matrix.transformVector(data.point);
			}
			return null;
		}

		
		private function updateProductMatrix(productID:int, matrix:Matrix3D):void{
			var prPos:ProductPosition;
			
			for each (var prodPos:ProductPosition in productsPositions){
				if (prodPos.productID == productID){
					prPos = prodPos;
				}
			}
			
			prPos.matrix = matrix.clone();
		}
		
		private function searchProduct(furnitureProductMesh:Mesh):int{
			var productID:int;
			
			for each (var item:BasketItem in mainAppModel.customerBasket){
				if (item.mesh == furnitureProductMesh){
					productID = item.furnitureProductID;
				}
			}
						
			return productID;
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
			cameraController.disable();
			camera.x = camera.y = 0;
			
			//camera.z = 25;
			var cameraHeight:Number = (roomWidth / (2 * Math.tan(camera.fov / 2)));
			
			camera.z = cameraHeight*4;

			camera.rotationX = -180 * Math.PI/180;
			camera.rotationY = camera.rotationZ = 0;
		}
	}
}
