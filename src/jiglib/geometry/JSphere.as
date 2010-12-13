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

package jiglib.geometry
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import jiglib.data.CollOutData;
	import jiglib.math.*;
	import jiglib.physics.PhysicsState;
	import jiglib.physics.RigidBody;
	import jiglib.plugin.ISkin3D;

	public class JSphere extends RigidBody
	{

		public var name:String;
		private var _radius:Number;

		public function JSphere(skin:ISkin3D, r:Number)
		{

			super(skin);
			_type = "SPHERE";
			_radius = r;
			_boundingSphere = _radius;
			mass = 1;
			updateBoundingBox();
		}

		public function set radius(r:Number):void
		{
			_radius = r;
			_boundingSphere = _radius;
			setInertia(getInertiaProperties(mass));
			setActive();
			updateBoundingBox();
		}

		public function get radius():Number
		{
			return _radius;
		}

		override public function segmentIntersect(out:CollOutData, seg:JSegment, state:PhysicsState):Boolean
		{
			out.frac = 0;
			out.position = new Vector3D();
			out.normal = new Vector3D();

			var frac:Number = 0;
			var r:Vector3D = seg.delta;
			var s:Vector3D = seg.origin.subtract(state.position);

			var radiusSq:Number = _radius * _radius;
			var rSq:Number = r.lengthSquared;
			if (rSq < radiusSq)
			{
				out.frac = 0;
				out.position = seg.origin.clone();
				out.normal = out.position.subtract(state.position);
				out.normal.normalize();
				return true;
			}

			var sDotr:Number = s.dotProduct(r);
			var sSq:Number = s.lengthSquared;
			var sigma:Number = sDotr * sDotr - rSq * (sSq - radiusSq);
			if (sigma < 0)
			{
				return false;
			}
			var sigmaSqrt:Number = Math.sqrt(sigma);
			var lambda1:Number = (-sDotr - sigmaSqrt) / rSq;
			var lambda2:Number = (-sDotr + sigmaSqrt) / rSq;
			if (lambda1 > 1 || lambda2 < 0)
			{
				return false;
			}
			frac = Math.max(lambda1, 0);
			out.frac = frac;
			out.position = seg.getPoint(frac);
			out.normal = out.position.subtract(state.position);
			out.normal.normalize();
			return true;
		}

		override public function getInertiaProperties(m:Number):Matrix3D
		{
			var Ixx:Number = 0.4 * m * _radius * _radius;
			return JMatrix3D.getScaleMatrix(Ixx, Ixx, Ixx);
		}
		
		override protected function updateBoundingBox():void {
			_boundingBox.clear();
			_boundingBox.addSphere(this);
		}
	}
}
