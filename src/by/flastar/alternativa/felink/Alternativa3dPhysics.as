package by.flastar.alternativa.felink 
{
	import alternativa.Alternativa3D;
	import alternativa.engine3d.animation.Animation;
	import alternativa.engine3d.core.Object3DContainer;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.primitives.Box;
	import alternativa.engine3d.primitives.Plane;
	import alternativa.engine3d.primitives.Sphere;
	
	import flash.geom.Vector3D;
	
	import jiglib.geometry.JBox;
	import jiglib.geometry.JCapsule;
	import jiglib.geometry.JPlane;
	import jiglib.geometry.JSphere;
	import jiglib.math.JMatrix3D;
	import jiglib.physics.RigidBody;
	import jiglib.plugin.AbstractPhysics;

	/**
	 * ...
	 * @author Sergey [Flastar] Gonchar
	 */
	public class Alternativa3dPhysics extends AbstractPhysics
	{
		public var mainContainer:Object3DContainer;
		public static var instance:Alternativa3dPhysics;
		
		public function Alternativa3dPhysics(mainContainer:Object3DContainer, speed:Number = 1) 
		{
			super(speed);
			this.mainContainer = mainContainer;
			instance = this;
		}
		
		public function getMesh(body:RigidBody):Mesh
		{
			if (body.skin != null)
			{
				return Alternativa3dMesh(body.skin).mesh;
			}
			else
			{
				return null;
			}
		}
		public function createSphere(r:Number, material:Material):RigidBody
		{
			var sphere:Sphere = new Sphere(r);
			sphere.setMaterialToAllFaces(material);
			mainContainer.addChild(sphere);
			
			var jsphere:JSphere = new JSphere(new Alternativa3dMesh(sphere), r);
			addBody(jsphere);
			return jsphere;
		}
		
		public function createCube(w:Number,l:Number,h:Number, material:Material):RigidBody 
		{
			var cube:Box = new Box(w,h,l);
			cube.setMaterialToAllFaces(material);
			mainContainer.addChild(cube);
			//cube.sorting = 2;
			
			var jbox:JBox = new JBox(new Alternativa3dMesh(cube), w, l, h);
			addBody(jbox);
			return jbox;
		}
		
		public function createRigidRoom(room:Box, roomWidth:Number, roomLength:Number, roomHeight:Number):RigidBody{
			// визуальное представление комнаты
			mainContainer.addChild(room);
			
			// создание физ. стен комнаты
			/*var floor:Plane = new Plane(10,10);
			floor.setMaterialToAllFaces(new FillMaterial(0xCCCCCC, 1, 2));
			mainContainer.addChild(floor);*/
			
/*			var rFloor:JPlane = new JPlane(new Alternativa3dMesh(floor));
			//rFloor.setOrientation(JMatrix3D.getRotationMatrixAxis(90));
			rFloor.movable = false;
			rFloor.z = 6;
			addBody(rFloor);
			
			return rFloor;*/
			
			var jbox:JBox = new JBox(new Alternativa3dMesh(room), roomWidth, roomLength, roomHeight);
			jbox.movable = false;
			addBody(jbox);
			return jbox;
		}
		
		public function createGround(material:Material, width:Number, length:Number, level:Number):RigidBody {
			var ground:Plane = new Plane(width, length);
			ground.setMaterialToAllFaces(material);
			ground.z = level;
			
			mainContainer.addChild(ground);
			var jGround:JPlane = new JPlane(new Alternativa3dMesh(ground));
			jGround.movable = false;
			//jGround.setOrientation(JMatrix3D.getRotationMatrixAxis(90));
			jGround.z = level;
			addBody(jGround);
			return jGround;
		}
		
		public function createBoxMesh(mesh:Mesh, w:Number, h:Number,l:Number):RigidBody
		{
			mainContainer.addChild(mesh);
			
			var jbox:JBox = new JBox(new Alternativa3dMesh(mesh), w, h, l);
			addBody(jbox);
			return jbox;
		}
	}
}