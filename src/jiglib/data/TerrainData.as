package jiglib.data
{
	import flash.geom.Vector3D;

	/**
	 * @author katopz
	 */
	public class TerrainData
	{
		public var height:Number;
		public var normal:Vector3D;

		public function TerrainData(height:Number = 0, normal:Vector3D = null)
		{
			this.height = isNaN(height) ? 0 : height;
			this.normal = normal ? normal : new Vector3D();
		}
	}
}