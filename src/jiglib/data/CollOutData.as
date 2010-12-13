package jiglib.data
{
	import flash.geom.Vector3D;

	import jiglib.physics.RigidBody;

	/**
	 * @author katopz
	 */
	public class CollOutData
	{
		public var frac:Number;
		public var position:Vector3D;
		public var normal:Vector3D;

		public function CollOutData(frac:Number = 0, position:Vector3D = null, normal:Vector3D = null)
		{
			this.frac = isNaN(frac) ? 0 : frac;
			this.position = position ? position : new Vector3D;
			this.normal = normal ? normal : new Vector3D;
		}
	}
}