package business.room {
	
	import alternativa.engine3d.containers.BSPContainer;
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Debug;
	import alternativa.engine3d.core.MouseEvent3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Object3DContainer;
	import alternativa.engine3d.core.RayIntersectionData;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.objects.Mesh;
	
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import model.FurnitureProduct;
	import model.PlannerModelLocator;
	import model.ProductPosition;
	import model.ShoppingCartItem;
	
	import mx.controls.Alert;
	

	public class RoomController extends Sprite{
		
		private var mainAppModel:PlannerModelLocator = PlannerModelLocator.getInstance();
		private var container:Object3DContainer = new Object3DContainer();

		private var cameraController:SimpleObjectController;
		private var camera:ExCamera;
		private var room:Room;
		private var shoppingCartController:ShoppingCartController;
		
		// источник событий для контроллера камеры (в нашем случае это drawAreaSprite)
		private var eventSource:InteractiveObject;
		
		// параметры помещения
		public var roomWidth:Number;
		public var roomHeight:Number;
		public var roomLength:Number;
		
		// размеры родительского окна
		private var parentWidth:Number;
		private var parentHeight:Number;
		
		private const CAMERA_DISTANCE:Number = 8;
		
		private var mousePosition:Vector3D;
		private var currentSelectedProduct:Mesh;
		private var moveProduct:Boolean = false;
		
		// сохраняем координаты предметов мебели
		public var productsPositions:Vector.<ProductPosition>;
	
		public function RoomController(_roomWidth:Number, _roomLength:Number, _roomHeight:Number,
							   parentWidth:Number,parentHeight:Number, _eventSource:InteractiveObject) 
		{
			
			addEventListener(Event.ADDED_TO_STAGE, mainBuild, false, 0, true);
			
			roomWidth = _roomWidth;
			roomHeight = _roomHeight;
			roomLength = _roomLength;
			
			eventSource = _eventSource;
			this.parentWidth = parentWidth - 2;
			this.parentHeight = parentHeight - 75;
			
			productsPositions = new Vector.<ProductPosition>();
			
			shoppingCartController = new ShoppingCartController();
		}
		
		private function mainBuild(ev:Event):void{
			// Создание камеры и вьюпорта
			room = new Room(roomWidth, roomLength, roomHeight);
			container.addChild(room);
			
			camera = new ExCamera(parentWidth, parentHeight, room, eventSource);
			addChild(camera.view);
			addChild(camera.diagram);
			
			container.addChild(camera);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			//container.addEventListener(MouseEvent3D.CLICK, onClickEvent);
			//stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function onEnterFrame(e:Event):void {
			camera.cameraController.update();
			camera.render();
		}
		
		public function removeListener():void{
			stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function addFurnitureProductToRoom(product:FurnitureProduct, matrix:Matrix3D = null):void{
			var furnitureProductMesh:Mesh = product.modelMesh.clone() as Mesh;
			shoppingCartController.placeFurnitureProductToShoppingCart(product, furnitureProductMesh);
						
			// если указана матрица трансформации
			if (matrix){
				furnitureProductMesh.matrix = matrix.clone();
			}
			else{
				furnitureProductMesh.x = furnitureProductMesh.y = 0;
				furnitureProductMesh.z = -roomHeight/2;
			}
			
			furnitureProductMesh.scaleX = furnitureProductMesh.scaleY = furnitureProductMesh.scaleZ = 0.0015;
			
			furnitureProductMesh.addEventListener(MouseEvent3D.MOUSE_DOWN, onMouseDown);
			
			container.addChild(furnitureProductMesh);

			var productPosition:ProductPosition = new ProductPosition(furnitureProductMesh.matrix, product.furnitureProductID);
			productsPositions.push(productPosition);
			
		}
		
		
/*		private function onKeyDown(event:KeyboardEvent):void{
			if (currentSelectedProduct && (event.keyCode == 127)){

				// удаляем из контейнера
				container.removeChild(currentSelectedProduct);
				// удаляем из корзины
				shoppingCartController.removeFurnitureProductFromShoppingCart(currentSelectedProduct);
				// удаляем из productsPositions
				
				var index:int = -1;
				for each (var prodPos:ProductPosition in productsPositions){
					// по мешу ищем productID;
					// удаляем
				}
			}
		}*/
		
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
		
		private function onMouseDown(e:MouseEvent3D):void{
			container.addEventListener(MouseEvent3D.MOUSE_MOVE, onMouseMove);
			container.addEventListener(MouseEvent3D.MOUSE_UP, onMouseUp);
			
			currentSelectedProduct = e.target as Mesh;
		}
		
		private function onMouseUp(e:MouseEvent3D):void
		{
			container.removeEventListener(MouseEvent3D.MOUSE_MOVE, onMouseMove);
			container.removeEventListener(MouseEvent3D.MOUSE_UP, onMouseUp);
			currentSelectedProduct.filters = [];
		}
		
		private function onMouseMove(event:MouseEvent3D):void
		{
			mousePosition = getMouseVector3d(event, container);
			
			if (currentSelectedProduct && mousePosition){
				currentSelectedProduct.x = mousePosition.x;
				currentSelectedProduct.y = mousePosition.y;
				currentSelectedProduct.z = mousePosition.z;
			}

		}

		private function getMouseVector3d(mouseEvent:MouseEvent3D, container:Object3DContainer,excludeObjecsFromTouch:Dictionary = null):Vector3D
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
		
		
		public function changeView(mode:int):void{
			if (mode == 0){
				camera.setCameraTo2D();
			}
			else if (mode == 1){
				camera.setCameraTo3D();
			}
		}
		
	}
}
