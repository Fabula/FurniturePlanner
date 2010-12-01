package business
{
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.MouseEvent3D;
	import alternativa.engine3d.core.Object3DContainer;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.loaders.MaterialLoader;
	import alternativa.engine3d.loaders.Parser3DS;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.primitives.Box;
	
	import events.FurnitureProductSelectEvent;
	
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.media.Camera;
	import flash.utils.ByteArray;
	
	import model.FurnitureProduct;
	
	import mx.controls.Alert;
	import mx.utils.Base64Decoder;
	
	public class Preview extends Sprite
	{
		// создаем статичное изображение загружаемой модели
		
		// размеры родительского окна строго фиксированы
		protected var parentWidth:Number = 150;
		private var parentHeight:Number;

		protected var container:Object3DContainer;
		protected var camera:Camera3D;
		private var product:FurnitureProduct;
		public var modelMesh:Mesh;
		private var box:Box;
		private var controller:SimpleObjectController;
		
		public function Preview(parentHeight:Number, product:FurnitureProduct){
			
			addEventListener(Event.ADDED_TO_STAGE, MainBuild, false, 0, true);
			// высота родительского окна
			this.parentHeight = parentHeight - 5;
			// продукт, который мы загружаем из каталога, содержит трехмерную модель и описание
			this.product = product;
		}
		
		protected function MainBuild(ev:Event):void{
			initScene();
			setCameraPosition();
			importModel(product);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(e:Event):void {
			camera.render();
		}
		
		protected function initScene():void{
			camera = new Camera3D();
			camera.view = new View(parentWidth, parentHeight, true);
			camera.view.hideLogo();
			addChild(camera.view);
			container = new Object3DContainer();
			container.addChild(camera);
		}
		
		protected function setCameraPosition():void{
			camera.rotationX = -1.5;
			camera.y = -200;
			camera.x = -140;
			camera.z = 80;
		}

		private function importModel(product:FurnitureProduct):void{
			
			// декодируем base64 строку обратно в ByteArray
			var decoder:Base64Decoder = new Base64Decoder();
			var productModel:ByteArray;
				
			decoder.decode(product.model_data);
			productModel= decoder.toByteArray();
			var parser:Parser3DS = new Parser3DS();
			parser.parse(productModel);
			modelMesh = parser.objects[0] as Mesh;
			modelMesh.x -= 100;
				
			// загрузка текстур
			var textureLoader:MaterialLoader = new MaterialLoader();
			textureLoader.load(parser.textureMaterials);	
				
			// добавляем в сцену
			container.addChild(modelMesh);
			product.modelMesh = modelMesh;
			modelMesh.addEventListener(MouseEvent3D.CLICK, showFurnitureProductDescription);
			modelMesh.addEventListener(MouseEvent3D.MOUSE_OUT, deselectFurnitureProduct);
		}
		
		private function showFurnitureProductDescription(ev:MouseEvent3D):void{
			dispatchEvent(new FurnitureProductSelectEvent(FurnitureProductSelectEvent.FURNITURE_PRODUCT_SELECTED, true, product));
		}
		
		private function deselectFurnitureProduct(event:MouseEvent3D):void{
			// убрать эффект свечения
		}
		
	}
}