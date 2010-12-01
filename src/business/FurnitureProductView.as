package business
{
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3DContainer;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.objects.Mesh;
	
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	import model.FurnitureProduct;
	
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.LinkButton;
	
	public class FurnitureProductView extends Sprite
	{
		private var container:Object3DContainer;
		private var camera:Camera3D;
		private var eventSource:InteractiveObject;
		private var product:FurnitureProduct;
		private var furnitureProductMeshCopy:Mesh;
		
		public function FurnitureProductView(product:FurnitureProduct, eventSource:InteractiveObject)
		{
			addEventListener(Event.ADDED_TO_STAGE, MainBuild, false, 0, true);
			this.eventSource = eventSource;
			this.product = product;
		}
		
		private function MainBuild(event:Event):void{
			initScene();
			setCameraPosition();
			furnitureProductMeshCopy = product.modelMesh.clone() as Mesh;
			furnitureProductMeshCopy.x = furnitureProductMeshCopy.y = furnitureProductMeshCopy.z = 0;
			container.addChild(furnitureProductMeshCopy);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function initScene():void{
			camera = new Camera3D();
			camera.view = new View(eventSource.width, eventSource.height, true);
			camera.view.hideLogo();
			addChild(camera.view);
			container = new Object3DContainer();
			container.addChild(camera);
		}
		
		private function setCameraPosition():void{
			camera.rotationX = -90 * Math.PI/180; // значение поворота измеряется в радианах
			camera.y = -170;
			camera.x = 0;
			camera.z = 80;
		}
		
		private function onEnterFrame(event:Event):void{
			camera.render();
			furnitureProductMeshCopy.rotationZ += 0.01;
		}
		
	}
}