package jiglib.data
{
	import flash.geom.Vector3D;
	
	import jiglib.physics.RigidBody;

	/**
	 * @author katopz
	 */
	public class CollOutBodyData extends CollOutData
	{
		public var rigidBody:RigidBody;

		public function CollOutBodyData(frac:Number = 0, position:Vector3D = null, normal:Vector3D = null, rigidBody:RigidBody = null)
		{
			super(frac, position, normal);
			this.rigidBody = rigidBody;
		}
	}
}