package parsersexample {
	
	import alternativa.engine3d.containers.DistanceSortContainer;
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Debug;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Object3DContainer;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.loaders.MaterialLoader;
	import alternativa.engine3d.loaders.Parser3DS;
	import alternativa.engine3d.loaders.ParserCollada;
	import alternativa.engine3d.objects.Mesh;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	
	/**
	 * Пример работы с парсерами в Alternativa3D.
	 */
	public class ParsersExample extends Sprite {
		
		private var rootContainer:Object3DContainer = new DistanceSortContainer();
		
		private var camera:Camera3D;
		private var controller:SimpleObjectController;
		private var mesh:Mesh;
		
		public function ParsersExample() {
			addEventListener(Event.ADDED_TO_STAGE, MainBuild, false, 0, true);
		}
		
		private function MainBuild(ev:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, MainBuild);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			// Создание камеры и вьюпорта
			camera = new Camera3D();
			camera.view = new View(stage.width, stage.height);
			addChild(camera.view);
			addChild(camera.diagram);
			
			// Установка начального положения камеры
			camera.rotationX = -130*Math.PI/180;
			camera.y = -300;
			camera.z = 300;
			controller = new SimpleObjectController(stage, camera, 200);
			rootContainer.addChild(camera);
			
			// Загрузка моделей
			
			var loader3ds:URLLoader = new URLLoader();
			loader3ds.dataFormat = URLLoaderDataFormat.BINARY;
			loader3ds.load(new URLRequest("parsersexample/model.3DS"));
			loader3ds.addEventListener(Event.COMPLETE, on3dsLoad);
			
			// Режим отладки
			camera.addToDebug(Debug.EDGES, Object3D);
			camera.addToDebug(Debug.BOUNDS, Object3D);
			
			// Подписка на события
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(Event.RESIZE, onResize);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function on3dsLoad(e:Event):void {
			// Парсинг модели
			var parser:Parser3DS = new Parser3DS();
			parser.parse((e.target as URLLoader).data, "parsersexample/");
			mesh = parser.objects[0] as Mesh;
			mesh.x -= 100;
			rootContainer.addChild(mesh);
			// Загрузка текстур
			var materialLoader:MaterialLoader = new MaterialLoader();
			materialLoader.load(parser.textureMaterials);
		}
				
		private function onEnterFrame(e:Event):void {
			controller.update();
			mesh.rotationZ -= 0.01;
			camera.render();
		}
		
		private function onResize(e:Event = null):void {
			camera.view.width = stage.stageWidth;
			camera.view.height = stage.stageHeight;
		}
		
		private function onKeyDown(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.TAB) {
				camera.debug = !camera.debug;
			}
			if (e.keyCode == 81) { // Q
				if (stage.quality == "HIGH") {
					stage.quality = "LOW";
				} else {
					stage.quality = "HIGH";
				}
			}
		}
		
	}
}
