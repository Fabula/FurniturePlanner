package jiglib.data
{
	import flash.geom.Vector3D;

	/**
	 * ...
	 * @author Muzer
	 */
	public class PlaneData
	{

		private var _position:Vector3D;
		private var _normal:Vector3D;
		private var _distance:Number;

		public function PlaneData(position:Vector3D, normal:Vector3D)
		{
			_position = position.clone();
			_normal = normal.clone();
			_distance = _position.dotProduct(_normal);
		}

		public function get position():Vector3D
		{
			return _position;
		}

		public function get normal():Vector3D
		{
			return _normal;
		}

		public function get distance():Number
		{
			return _distance;
		}

		public function pointPlaneDistance(pt:Vector3D):Number
		{
			return _normal.dotProduct(pt) - _distance;
		}
	}
}