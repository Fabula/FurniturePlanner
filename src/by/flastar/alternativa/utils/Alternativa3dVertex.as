package by.flastar.alternativa.utils 
{
	import alternativa.engine3d.core.Vertex;	

	public class Alternativa3dVertex
	{
		private var vx:Vertex;
		
		public function Alternativa3dVertex() 
		{
			
		}
		
		override public function setVertex(vertex:*):void 
		{
			vx = vertex as Vertex;
		}
		
		override public function get x():Number 
		{
			return vx.x;
		}
		
		override public function get y():Number 
		{
			return vx.y;
		}
		
		override public function get z():Number 
		{
			return vx.z;
		}
		
		override public function set x(v:Number):void 
		{
			vx.x = v;
		}
		
		override public function set y(v:Number):void 
		{
			vx.y = v;
		}
		
		override public function set z(v:Number):void 
		{
			vx.z = v;
		}
	}
}