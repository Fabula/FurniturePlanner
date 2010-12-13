package jiglib.geometry
{
	import flash.geom.Vector3D;
	
	import jiglib.data.CollOutData;
	import jiglib.data.PlaneData;
	import jiglib.data.TerrainData;
	import jiglib.math.JNumber3D;
	import jiglib.physics.PhysicsState;
	import jiglib.physics.RigidBody;
	import jiglib.plugin.ITerrain;

	/**
	 * ...
	 * @author Muzer
	 */
	public class JTerrain extends RigidBody
	{
		private var _terrain:ITerrain;
		private var _yUp:Boolean;

		public function JTerrain(tr:ITerrain, yUp:Boolean = true)
		{
			super(null);

			// yUp for lite
			_yUp = yUp;

			_terrain = tr;
			this.movable = false;
			_type = "TERRAIN";
		}

		public function get terrainMesh():ITerrain
		{
			return _terrain;
		}

		public function getHeightByIndex(i:int, j:int):Number
		{
			i = limiteInt(i, 0, _terrain.sw);
			j = limiteInt(j, 0, _terrain.sh);

			return _terrain.heights[i][j];
		}

		/*
		   public function getNormalByIndex(i:int, j:int):Vector3D
		   {
		   var i0:int = i - 1;
		   var i1:int = i + 1;
		   var j0:int = j - 1;
		   var j1:int = j + 1;
		   i0 = limiteInt(i0, 0, _terrain.sw);
		   i1 = limiteInt(i1, 0, _terrain.sw);
		   j0 = limiteInt(j0, 0, _terrain.sh);
		   j1 = limiteInt(j1, 0, _terrain.sh);

		   var dx:Number = (i1 - i0) * _terrain.dw;
		   var dy:Number = (j1 - j0) * _terrain.dh;
		   if (i0 == i1) dx = 1;
		   if (j0 == j1) dy = 1;
		   if (i0 == i1 && j0 == j1) return Vector3D.Y_AXIS;

		   var hFwd:Number = _terrain.heights[i1][j];
		   var hBack:Number = _terrain.heights[i0][j];
		   var hLeft:Number = _terrain.heights[i][j1];
		   var hRight:Number = _terrain.heights[i][j0];

		   var normal:Vector3D = new Vector3D(dx, hFwd - hBack, 0);
		   normal = new Vector3D(0, hLeft - hRight, dy).crossProduct(normal);
		   normal.normalize();
		   return normal;
		   }

		   public function getSurfacePosByIndex(i:int, j:int):Vector3D {
		   return new Vector3D(_terrain.minW + i * _terrain.dw, getHeightByIndex(i, j), _terrain.minH + j * _terrain.dh);
		   }
		 */

		public function getHeightAndNormalByPoint(point:Vector3D):TerrainData
		{
			var w:Number = limiteInt(point.x, _terrain.minW, _terrain.maxW);
			var h:Number = limiteInt(point.z, _terrain.minH, _terrain.maxH);

			var i0:int = int((w - _terrain.minW) / _terrain.dw);
			var j0:int = int((h - _terrain.minH) / _terrain.dh);
			i0 = limiteInt(i0, 0, _terrain.sw);
			j0 = limiteInt(j0, 0, _terrain.sh);

			var i1:int = i0 + 1;
			var j1:int = j0 + 1;
			i1 = limiteInt(i1, 0, _terrain.sw);
			j1 = limiteInt(j1, 0, _terrain.sh);

			var iFrac:Number = 1 - (w - (i0 * _terrain.dw + _terrain.minW)) / _terrain.dw;
			var jFrac:Number = (h - (j0 * _terrain.dh + _terrain.minH)) / _terrain.dh;
			iFrac = JNumber3D.getLimiteNumber(iFrac, 0, 1);
			jFrac = JNumber3D.getLimiteNumber(jFrac, 0, 1);

			// yUp for lite
			var h00:Number = _yUp ? _terrain.heights[i0][j0] : -_terrain.heights[i0][j0];
			var h01:Number = _yUp ? _terrain.heights[i0][j1] : -_terrain.heights[i0][j1];
			var h10:Number = _yUp ? _terrain.heights[i1][j0] : -_terrain.heights[i1][j0];
			var h11:Number = _yUp ? _terrain.heights[i1][j1] : -_terrain.heights[i1][j1];

			var obj:TerrainData = new TerrainData();
			var plane:PlaneData;
			if (iFrac < jFrac || i0 == i1 || j0 == j1)
			{
				obj.normal = new Vector3D(0, h11 - h10, _terrain.dh).crossProduct(new Vector3D(_terrain.dw, h11 - h01, 0));
				// yUp for lite
				if (!_yUp)
					obj.normal.negate();
				obj.normal.normalize();

				plane = new PlaneData(new Vector3D((i1 * _terrain.dw + _terrain.minW), h11, (j1 * _terrain.dh + _terrain.minH)), obj.normal);
				obj.height = plane.pointPlaneDistance(point);
			}
			else
			{
				obj.normal = new Vector3D(0, h01 - h00, _terrain.dh).crossProduct(new Vector3D(_terrain.dw, h10 - h00, 0));
				// yUp for lite
				if (!_yUp)
					obj.normal.negate();
				obj.normal.normalize();

				plane = new PlaneData(new Vector3D((i0 * _terrain.dw + _terrain.minW), h00, (j0 * _terrain.dh + _terrain.minH)), obj.normal);
				obj.height = plane.pointPlaneDistance(point);
			}

			return obj;
		}

		public function getHeightByPoint(point:Vector3D):Number
		{
			return getHeightAndNormalByPoint(point).height;
		}

		public function getNormalByPoint(point:Vector3D):Vector3D
		{
			return getHeightAndNormalByPoint(point).normal;
		}

		public function getSurfacePosByPoint(point:Vector3D):Vector3D
		{
			return new Vector3D(point.x, getHeightAndNormalByPoint(point).height, point.z);
		}

		override public function segmentIntersect(out:CollOutData, seg:JSegment, state:PhysicsState):Boolean
		{
			out.frac = 0;
			out.position = new Vector3D();
			out.normal = new Vector3D();

			// yUp for lite
			var segY:Number = _yUp ? seg.delta.y : -seg.delta.y;

			if (segY > JNumber3D.NUM_TINY)
				return false;

			var obj1:TerrainData = getHeightAndNormalByPoint(seg.origin);
			if (obj1.height < 0)
				return false;

			var obj2:TerrainData = getHeightAndNormalByPoint(seg.getEnd());
			if (obj2.height > 0)
				return false;

			var depthEnd:Number = -obj2.height;
			var weightStart:Number = 1 / (JNumber3D.NUM_TINY + obj1.height);
			var weightEnd:Number = 1 / (JNumber3D.NUM_TINY + obj2.height);

			obj1.normal.scaleBy(weightStart);
			obj2.normal.scaleBy(weightEnd);
			out.normal = obj1.normal.add(obj2.normal);
			out.normal.scaleBy(1 / (weightStart + weightEnd));

			out.frac = obj1.height / (obj1.height + depthEnd + JNumber3D.NUM_TINY);
			out.position = seg.getPoint(out.frac);

			return true;
		}

		private function limiteInt(num:int, min:int, max:int):int
		{
			var n:int = num;
			if (n < min)
				n = min;
			else if (n > max)
				n = max;

			return n;
		}
	}
}