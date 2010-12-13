/*
Copyright (c) 2007 Danny Chapman 
http://www.rowlhouse.co.uk

This software is provided 'as-is', without any express or implied
warranty. In no event will the authors be held liable for any damages
arising from the use of this software.
Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:
1. The origin of this software must not be misrepresented; you must not
claim that you wrote the original software. If you use this software
in a product, an acknowledgment in the product documentation would be
appreciated but is not required.
2. Altered source versions must be plainly marked as such, and must not be
misrepresented as being the original software.
3. This notice may not be removed or altered from any source
distribution.
 */

/**
 * @author Muzer(muzerly@gmail.com)
 * @link http://code.google.com/p/jiglibflash
 */

package jiglib.geometry{

	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import jiglib.data.CollOutData;
	import jiglib.math.*;
	import jiglib.physics.PhysicsState;
	import jiglib.physics.RigidBody;
	import jiglib.plugin.ISkin3D;
	
	public class JCapsule extends RigidBody {
		
		private var _length:Number;//cylinder height
		private var _radius:Number;//radius of sphere
		
		public function JCapsule(skin:ISkin3D, r:Number, l:Number) {
			super(skin);
			_type = "CAPSULE";
			_radius = r;
			_length = l;
			_boundingSphere = getBoundingSphere(r, l);
			mass = 1;
			updateBoundingBox();
		}
		 
		public function set radius(r:Number):void {
			_radius = r;
			_boundingSphere = getBoundingSphere(_radius, _length);
			setInertia(getInertiaProperties(mass));
			updateBoundingBox();
			setActive();
		}
		public function get radius():Number {
			return _radius;
		}
		 
		public function set length(l:Number):void {
			_length = l;
			_boundingSphere = getBoundingSphere(_radius, _length);
			setInertia(getInertiaProperties(mass));
			updateBoundingBox();
			setActive();
		}
		public function get length():Number {
			return _length;
		}
		 
		public function getBottomPos(state:PhysicsState):Vector3D {
			return state.position.add(JNumber3D.getScaleVector(state.getOrientationCols()[1], -_length / 2));
		}
		 
		public function getEndPos(state:PhysicsState):Vector3D {
			return state.position.add(JNumber3D.getScaleVector(state.getOrientationCols()[1], _length / 2));
		}

		override public function segmentIntersect(out:CollOutData, seg:JSegment, state:PhysicsState):Boolean
		{
			out.frac = 0;
			out.position = new Vector3D();
			out.normal = new Vector3D();

			var Ks:Vector3D = seg.delta;
			var kss:Number = Ks.dotProduct(Ks);
			var radiusSq:Number = _radius * _radius;

			var cols:Vector.<Vector3D> = state.getOrientationCols();
			var cylinderAxis:JSegment = new JSegment(getBottomPos(state), cols[1]);
			var Ke:Vector3D = cylinderAxis.delta;
			var Kg:Vector3D = cylinderAxis.origin.subtract(seg.origin);
			var kee:Number = Ke.dotProduct(Ke);
			if (Math.abs(kee) < JNumber3D.NUM_TINY)
			{
				return false;
			}

			var kes:Number = Ke.dotProduct(Ks);
			var kgs:Number = Kg.dotProduct(Ks);
			var keg:Number = Ke.dotProduct(Kg);
			var kgg:Number = Kg.dotProduct(Kg);

			var distSq:Number = Kg.subtract(JNumber3D.getDivideVector(JNumber3D.getScaleVector(Ke, keg), kee)).lengthSquared;
			if (distSq < radiusSq)
			{
				out.frac = 0;
				out.position = seg.origin.clone();
				out.normal = out.position.subtract(getBottomPos(state));
				out.normal = out.normal.subtract(JNumber3D.getScaleVector(cols[1], out.normal.dotProduct(cols[1])));
				out.normal.normalize();
				return true;
			}

			var a:Number = kee * kss - (kes * kes);
			if (Math.abs(a) < JNumber3D.NUM_TINY)
			{
				return false;
			}
			var b:Number = 2 * (keg * kes - kee * kgs);
			var c:Number = kee * (kgg - radiusSq) - (keg * keg);
			var blah:Number = (b * b) - 4 * a * c;
			if (blah < 0)
			{
				return false;
			}
			var t:Number = (-b - Math.sqrt(blah)) / (2 * a);
			if (t < 0 || t > 1)
			{
				return false;
			}
			out.frac = t;
			out.position = seg.getPoint(t);
			out.normal = out.position.subtract(getBottomPos(state));
			out.normal = out.normal.subtract(JNumber3D.getScaleVector(cols[1], out.normal.dotProduct(cols[1])));
			out.normal.normalize();
			return true;
		}
		
		override public function getInertiaProperties(m:Number):Matrix3D {
			var cylinderMass:Number = m * Math.PI * _radius * _radius * _length / getVolume();
			var Ixx:Number = 0.25 * cylinderMass * _radius * _radius + (1 / 12) * cylinderMass * _length * _length;
			var Iyy:Number = 0.5 * cylinderMass * _radius * _radius;
			var Izz:Number = Ixx;
			 
			var endMass:Number = m - cylinderMass;
			Ixx += (0.4 * endMass * _radius * _radius + endMass * Math.pow(0.5 * _length, 2));
			Iyy += (0.2 * endMass * _radius * _radius);
			Izz += (0.4 * endMass * _radius * _radius + endMass * Math.pow(0.5 * _length, 2));
			 
			return JMatrix3D.getScaleMatrix(Ixx, Iyy, Izz);
		}
		
		override protected function updateBoundingBox():void {
			_boundingBox.clear();
			_boundingBox.addCapsule(this);
		}
		
		private function getBoundingSphere(r:Number, l:Number):Number {
			return Math.sqrt(Math.pow(l / 2, 2) + r * r) + r;
		}
		
		private function getVolume():Number {
			return (4 / 3) * Math.PI * _radius * _radius * _radius + _length * Math.PI * _radius * _radius;
		}
	}
	
}
