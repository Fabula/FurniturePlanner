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

package jiglib.physics.constraint
{

	import flash.geom.Vector3D;
	
	import jiglib.math.*;
	import jiglib.physics.RigidBody;

	// Constraints a point on one body to be fixed to a point on another body
	public class JConstraintPoint extends JConstraint
	{

		private const _maxVelMag:Number = 20;
		private const _minVelForProcessing:Number = 0.01;


		private var _body0:RigidBody;
		private var _body1:RigidBody;
		private var _body0Pos:Vector3D;
		private var _body1Pos:Vector3D;

		private var _timescale:Number;
		private var _allowedDistance:Number;

		private var r0:Vector3D;
		private var r1:Vector3D;
		private var _worldPos:Vector3D;
		private var _vrExtra:Vector3D;

		/// allowed_distance indicated how much the points are allowed to deviate.
		/// timescale indicates the timescale over which deviation is eliminated
		/// (suggest a few times dt - be careful if there's a variable timestep!)
		/// if timescale < 0 then the value indicates the number of dts
		public function JConstraintPoint(body0:RigidBody, body0Pos:Vector3D, body1:RigidBody, body1Pos:Vector3D, allowedDistance:Number = 1, timescale:Number = 1)
		{
			super();
			_body0 = body0;
			_body0Pos = body0Pos;
			_body1 = body1;
			_body1Pos = body1Pos;
			_allowedDistance = allowedDistance;
			_timescale = timescale;
			if (_timescale < JNumber3D.NUM_TINY)
			{
				_timescale = JNumber3D.NUM_TINY;
			}
			body0.addConstraint(this);
			body1.addConstraint(this);
		}

		override public function preApply(dt:Number):void
		{
			this.satisfied = false;

			r0 = _body0.currentState.orientation.transformVector(_body0Pos);
			r1 = _body1.currentState.orientation.transformVector(_body1Pos);

			var worldPos0:Vector3D = _body0.currentState.position.add(r0);
			var worldPos1:Vector3D = _body1.currentState.position.add(r1);
			_worldPos = JNumber3D.getScaleVector(worldPos0.add(worldPos1), 0.5);

			var deviation:Vector3D = worldPos0.subtract(worldPos1);
			var deviationAmount:Number = deviation.length;
			if (deviationAmount > _allowedDistance)
			{
				_vrExtra = JNumber3D.getScaleVector(deviation, (deviationAmount - _allowedDistance) / (deviationAmount * Math.max(_timescale, dt)));
			}
			else
			{
				_vrExtra = new Vector3D();
			}
		}

		override public function apply(dt:Number):Boolean
		{
			this.satisfied = true;

			if (!_body0.isActive && !_body1.isActive)
			{
				return false;
			}

			var currentVel0:Vector3D = _body0.getVelocity(r0);
			var currentVel1:Vector3D = _body1.getVelocity(r1);
			var Vr:Vector3D = _vrExtra.add(currentVel0.subtract(currentVel1));

			var normalVel:Number = Vr.length;
			if (normalVel < _minVelForProcessing)
			{
				return false;
			}

			if (normalVel > _maxVelMag)
			{
				Vr = JNumber3D.getScaleVector(Vr, _maxVelMag / normalVel);
				normalVel = _maxVelMag;
			}

			var N:Vector3D = JNumber3D.getDivideVector(Vr, normalVel);
			var tempVec1:Vector3D = r0.crossProduct(N);
			tempVec1 = _body0.worldInvInertia.transformVector(tempVec1);
			var tempVec2:Vector3D = r1.crossProduct(N);
			tempVec2 = _body1.worldInvInertia.transformVector(tempVec2);
			var denominator:Number = _body0.invMass + _body1.invMass + N.dotProduct(tempVec1.crossProduct(r0)) + N.dotProduct(tempVec2.crossProduct(r1));
			if (denominator < JNumber3D.NUM_TINY)
			{
				return false;
			}

			var normalImpulse:Vector3D = JNumber3D.getScaleVector(N, -normalVel / denominator);
			_body0.applyWorldImpulse(normalImpulse, _worldPos);
			_body1.applyWorldImpulse(JNumber3D.getScaleVector(normalImpulse, -1), _worldPos);

			_body0.setConstraintsAndCollisionsUnsatisfied();
			_body1.setConstraintsAndCollisionsUnsatisfied();
			this.satisfied = true;
			return true;
		}

	}

}
