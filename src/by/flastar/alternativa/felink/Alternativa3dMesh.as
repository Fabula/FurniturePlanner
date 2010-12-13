package by.flastar.alternativa.felink
{
	import alternativa.engine3d.objects.Mesh;
	import flash.geom.Vector3D;
	import jiglib.plugin.ISkin3D;
	
	import flash.geom.Matrix3D;
	/**
	 * @author Sergey [Flastar] Gonchar
	 */
	public class Alternativa3dMesh implements ISkin3D
	{
		private var _mesh:Mesh;
		
		public function Alternativa3dMesh(inputMesh:Mesh) 
		{
			this._mesh = inputMesh;
			
		}
		public function get transform():Matrix3D
		{
			return _mesh.matrix;
		}
		
		public function set transform(m:Matrix3D):void
		{			
			_mesh.matrix = m.clone();
		}
		
		public function get mesh():Mesh
		{
			return _mesh;
		}
	}
}