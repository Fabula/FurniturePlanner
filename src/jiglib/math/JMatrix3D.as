package jiglib.math
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	/**
	 * @author katopz
	 */
	public class JMatrix3D
	{
		public static function getTranslationMatrix(x:Number, y:Number, z:Number):Matrix3D
		{
			var matrix3D:Matrix3D = new Matrix3D();
			matrix3D.appendTranslation(x, y, z);
			return matrix3D;
		}
		
		public static function getScaleMatrix(x:Number, y:Number, z:Number):Matrix3D
		{
			var matrix3D:Matrix3D = new Matrix3D();
			matrix3D.prependScale(x, y, z);
			return matrix3D;
		}
		
		public static function getRotationMatrix(x:Number, y:Number, z:Number, degree:Number, pivotPoint:Vector3D=null):Matrix3D
		{
			var matrix3D:Matrix3D = new Matrix3D();
			matrix3D.appendRotation(degree, new Vector3D(x,y,z),pivotPoint);
			return matrix3D;
		}
		
		public static function getInverseMatrix(m:Matrix3D):Matrix3D
		{
			var matrix3D:Matrix3D = m.clone();
			matrix3D.invert();
			return matrix3D;
		}

		public static function getTransposeMatrix(m:Matrix3D):Matrix3D
		{
			var matrix3D:Matrix3D = m.clone();
			matrix3D.transpose();
			return matrix3D;
		}

		public static function getAppendMatrix3D(a:Matrix3D, b:Matrix3D):Matrix3D
		{
			var matrix3D:Matrix3D = a.clone();
			matrix3D.append(b);
			return matrix3D;
		}

		public static function getPrependMatrix(a:Matrix3D, b:Matrix3D):Matrix3D
		{
			var matrix3D:Matrix3D = a.clone();
			matrix3D.prepend(b);
			return matrix3D;
		}
		
		public static function getSubMatrix(a:Matrix3D, b:Matrix3D):Matrix3D
		{
			var ar:Vector.<Number> = a.rawData;
			var br:Vector.<Number> = b.rawData;
			return new Matrix3D(Vector.<Number>([
				ar[0] - br[0],
				ar[1] - br[1],
				ar[2] - br[2],
				ar[3] - br[3],
				ar[4] - br[4],
				ar[5] - br[5],
				ar[6] - br[6],
				ar[7] - br[7],
				ar[8] - br[8],
				ar[9] - br[9],
				ar[10] - br[10],
				ar[11] - br[11],
				ar[12] - br[12],
				ar[13] - br[13],
				ar[14] - br[14],
				ar[15] - br[15]
			]));
		}
		
		public static function getRotationMatrixAxis(degree:Number, rotateAxis:Vector3D = null):Matrix3D
		{
    		var matrix3D:Matrix3D = new Matrix3D();
    		matrix3D.appendRotation(degree, rotateAxis?rotateAxis:Vector3D.X_AXIS);
    		return matrix3D;
		}
		
		public static function getCols(matrix3D:Matrix3D):Vector.<Vector3D>
		{
			var rawData:Vector.<Number> =  matrix3D.rawData;
			var cols:Vector.<Vector3D> = new Vector.<Vector3D>(3, true);
			
			cols[0] = new Vector3D(rawData[0], rawData[1], rawData[2]);
			cols[1] = new Vector3D(rawData[4], rawData[5], rawData[6]);
			cols[2] = new Vector3D(rawData[8], rawData[9], rawData[10]);
			
			return cols;
		}

		public static function multiplyVector(matrix3D:Matrix3D, v:Vector3D):void
		{
			v = matrix3D.transformVector(v);
			
			/*
			var vx:Number = v.x;
			var vy:Number = v.y;
			var vz:Number = v.z;

			if (vx == 0 && vy == 0 && vz == 0) { return; }
			
			var _rawData:Vector.<Number> =  matrix3D.rawData;
			
			v.x = vx * _rawData[0] + vy * _rawData[4] + vz * _rawData[8]  + _rawData[12];
			v.y = vx * _rawData[1] + vy * _rawData[5] + vz * _rawData[9]  + _rawData[13];
			v.z = vx * _rawData[2] + vy * _rawData[6] + vz * _rawData[10] + _rawData[14];
			*/
		}
	}
}