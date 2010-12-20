package business
{
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.MouseEvent3D;
	import alternativa.engine3d.core.Object3D;
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
	
	import model.FurnitureProduct;
	
	import mx.controls.Alert;
	
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
		private var cameraController:SimpleObjectController;
		
		public function Preview(parentHeight:Number, product:FurnitureProduct){
			
			addEventListener(Event.ADDED_TO_STAGE, MainBuild, false, 0, true);
			// высота родительского окна
			this.parentHeight = parentHeight - 5;
			// продукт, который мы загружаем из каталога, содержит трехмерную модель и описание
			this.product = product;
		}
		
		protected function MainBuild(ev:Event):void{
			initScene();
			importModel(product);
			setCameraPosition();
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
			camera.x = camera.y = 0;
			camera.rotationX = - Math.PI;
			camera.z = ((modelMesh.boundMaxX - modelMesh.boundMinX) / (2 * Math.tan(camera.fov / 2))) * 4;
		}

		private function importModel(product:FurnitureProduct):void{
			var parser:Parser3DS = new Parser3DS();
			parser.parse(product.furnitureModel.furnitureModel);
			
			for each (var obj:Object3D in parser.objects){
				if (obj is Mesh){
					modelMesh = obj as Mesh;
					modelMesh.x = modelMesh.y = modelMesh.z =0;
				}
			}
			
			modelMesh.weldVerticesAndFaces(0.01, 0.001);
			
			trace (modelMesh.boundMaxX - modelMesh.boundMinX);
			trace (modelMesh.boundMaxX - modelMesh.boundMinX);
			trace (modelMesh.boundMaxX - modelMesh.boundMinX);
			// загрузка текстур
			var textureLoader:MaterialLoader = new MaterialLoader();
			textureLoader.load(parser.textureMaterials);		

			// добавляем в сцену
			container.addChild(modelMesh);
			product.modelMesh = modelMesh;
			modelMesh.addEventListener(MouseEvent3D.CLICK, showFurnitureProductDescription);
		}
		
		private function showFurnitureProductDescription(ev:MouseEvent3D):void{
			dispatchEvent(new FurnitureProductSelectEvent(FurnitureProductSelectEvent.FURNITURE_PRODUCT_SELECTED, true, product));
		}
	}
}