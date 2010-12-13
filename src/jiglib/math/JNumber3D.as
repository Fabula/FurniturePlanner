package jiglib.math
{
	import flash.geom.Vector3D;

	/**
	 * @author katopz
	 */
	public class JNumber3D
	{
		public static const NUM_TINY:Number = 0.00001;
		public static const NUM_HUGE:Number = 100000;

		//public static const UP:Vector3D = Vector3D.Y_AXIS;
		//public static const LOOK:Vector3D = Vector3D.Z_AXIS;
		//public static const RIGHT:Vector3D = Vector3D.X_AXIS;

		public static function toArray(v:Vector3D):Array
		{
			return [v.x, v.y, v.z];
		}
		
		public static function getScaleVector(v:Vector3D, s:Number):Vector3D
		{
			return new Vector3D(v.x*s,v.y*s,v.z*s,v.w);
		}

		public static function getDivideVector(v:Vector3D, w:Number):Vector3D
		{
			if (w != 0)
			{
				return new Vector3D(v.x / w, v.y / w, v.z / w);
			}
			else
			{
				return new Vector3D(0, 0, 0);
			}
		}

		public static function getNormal(v0:Vector3D, v1:Vector3D, v2:Vector3D):Vector3D
		{
			var E:Vector3D = v1.clone();
			var F:Vector3D = v2.clone();
			var N:Vector3D = E.subtract(v0).crossProduct(F.subtract(v1));
			N.normalize();

			return N;
		}

		public static function copyFromArray(v:Vector3D, arr:Array):void
		{
			if (arr.length >= 3)
			{
				v.x = arr[0];
				v.y = arr[1];
				v.z = arr[2];
			}
		}

		public static function getLimiteNumber(num:Number, min:Number, max:Number):Number
		{
			var n:Number = num;
			if (n < min)
			{
				n = min;
			}
			else if (n > max)
			{
				n = max;
			}
			return n;
		}
	}
}