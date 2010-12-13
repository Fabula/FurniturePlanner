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

package jiglib.physics
{

	import flash.geom.Vector3D;
	
	import jiglib.math.*;
	import jiglib.physics.constraint.*;

	public class HingeJoint extends PhysicsController
	{

		private const MAX_HINGE_ANGLE_LIMIT:Number = 150;

		private var _hingeAxis:Vector3D;
		private var _hingePosRel0:Vector3D;
		private var _body0:RigidBody;
		private var _body1:RigidBody;
		private var _usingLimit:Boolean;
		private var _hingeEnabled:Boolean;
		private var _broken:Boolean;
		private var _damping:Number;
		private var _extraTorque:Number;

		private var sidePointConstraints:Vector.<JConstraintMaxDistance>;
		private var midPointConstraint:JConstraintPoint;
		private var maxDistanceConstraint:JConstraintMaxDistance;

		public function HingeJoint(body0:RigidBody, body1:RigidBody,
			hingeAxis:Vector3D, hingePosRel0:Vector3D,
			hingeHalfWidth:Number, hingeFwdAngle:Number,
			hingeBckAngle:Number, sidewaysSlack:Number, damping:Number)
		{
			_body0 = body0;
			_body1 = body1;
			_hingeAxis = hingeAxis.clone();
			_hingePosRel0 = hingePosRel0.clone();
			_usingLimit = false;
			_hingeEnabled = false;
			_broken = false;
			_damping = damping;
			_extraTorque = 0;

			_hingeAxis.normalize();
			var _hingePosRel1:Vector3D = _body0.currentState.position.add(_hingePosRel0.subtract(_body1.currentState.position));

			var relPos0a:Vector3D = _hingePosRel0.add(JNumber3D.getScaleVector(_hingeAxis, hingeHalfWidth));
			var relPos0b:Vector3D = _hingePosRel0.subtract(JNumber3D.getScaleVector(_hingeAxis, hingeHalfWidth));

			var relPos1a:Vector3D = _hingePosRel1.add(JNumber3D.getScaleVector(_hingeAxis, hingeHalfWidth));
			var relPos1b:Vector3D = _hingePosRel1.subtract(JNumber3D.getScaleVector(_hingeAxis, hingeHalfWidth));

			var timescale:Number = 1 / 20;
			var allowedDistanceMid:Number = 0.005;
			var allowedDistanceSide:Number = sidewaysSlack * hingeHalfWidth;

			sidePointConstraints = new Vector.<JConstraintMaxDistance>();
			sidePointConstraints[0] = new JConstraintMaxDistance(_body0, relPos0a, _body1, relPos1a, allowedDistanceSide);
			sidePointConstraints[1] = new JConstraintMaxDistance(_body0, relPos0b, _body1, relPos1b, allowedDistanceSide);

			midPointConstraint = new JConstraintPoint(_body0, _hingePosRel0, _body1, _hingePosRel1, allowedDistanceMid, timescale);

			if (hingeFwdAngle <= MAX_HINGE_ANGLE_LIMIT)
			{
				var perpDir:Vector3D = Vector3D.Y_AXIS;
				if (perpDir.dotProduct(_hingeAxis) > 0.1)
				{
					perpDir.x = 1;
					perpDir.y = 0;
					perpDir.z = 0;
				}
				var sideAxis:Vector3D = _hingeAxis.crossProduct(perpDir);
				perpDir = sideAxis.crossProduct(_hingeAxis);
				perpDir.normalize();

				var len:Number = 10 * hingeHalfWidth;
				var hingeRelAnchorPos0:Vector3D = JNumber3D.getScaleVector(perpDir, len);
				var angleToMiddle:Number = 0.5 * (hingeFwdAngle - hingeBckAngle);
				var hingeRelAnchorPos1:Vector3D = JMatrix3D.getRotationMatrix(_hingeAxis.x, _hingeAxis.y, _hingeAxis.z, -angleToMiddle).transformVector(hingeRelAnchorPos0);

				var hingeHalfAngle:Number = 0.5 * (hingeFwdAngle + hingeBckAngle);
				var allowedDistance:Number = len * 2 * Math.sin(0.5 * hingeHalfAngle * Math.PI / 180);

				var hingePos:Vector3D = _body1.currentState.position.add(_hingePosRel0);
				var relPos0c:Vector3D = hingePos.add(hingeRelAnchorPos0.subtract(_body0.currentState.position));
				var relPos1c:Vector3D = hingePos.add(hingeRelAnchorPos1.subtract(_body1.currentState.position));

				maxDistanceConstraint = new JConstraintMaxDistance(_body0, relPos0c, _body1, relPos1c, allowedDistance);
				_usingLimit = true;
			}
			if (_damping <= 0)
			{
				_damping = -1;
			}
			else
			{
				_damping = JNumber3D.getLimiteNumber(_damping, 0, 1);
			}

			enableHinge();
		}

		public function enableHinge():void
		{
			if (_hingeEnabled)
			{
				return;
			}
			midPointConstraint.enableConstraint();
			sidePointConstraints[0].enableConstraint();
			sidePointConstraints[1].enableConstraint();
			if (_usingLimit && !_broken)
			{
				maxDistanceConstraint.enableConstraint();
			}
			enableController();
			_hingeEnabled = true;
		}

		public function disableHinge():void
		{
			if (!_hingeEnabled)
			{
				return;
			}
			midPointConstraint.disableConstraint();
			sidePointConstraints[0].disableConstraint();
			sidePointConstraints[1].disableConstraint();
			if (_usingLimit && !_broken)
			{
				maxDistanceConstraint.disableConstraint();
			}
			disableController();
			_hingeEnabled = false;
		}

		public function breakHinge():void
		{
			if (_broken)
			{
				return;
			}
			if (_usingLimit)
			{
				maxDistanceConstraint.disableConstraint();
			}
			_broken = true;
		}

		public function mendHinge():void
		{
			if (!_broken)
			{
				return;
			}
			if (_usingLimit)
			{
				maxDistanceConstraint.enableConstraint();
			}
			_broken = false;
		}

		public function setExtraTorque(torque:Number):void
		{
			_extraTorque = torque;
		}

		public function getHingeEnabled():Boolean
		{
			return _hingeEnabled;
		}

		public function isBroken():Boolean
		{
			return _broken;
		}

		public function getHingePosRel0():Vector3D
		{
			return _hingePosRel0;
		}

		override public function updateController(dt:Number):void
		{
			if (_damping > 0)
			{
				var hingeAxis:Vector3D = _body1.currentState.rotVelocity.subtract(_body0.currentState.rotVelocity);
				hingeAxis.normalize();

				var angRot1:Number = _body0.currentState.rotVelocity.dotProduct(hingeAxis);
				var angRot2:Number = _body1.currentState.rotVelocity.dotProduct(hingeAxis);

				var avAngRot:Number = 0.5 * (angRot1 + angRot2);
				var frac:Number = 1 - _damping;
				var newAngRot1:Number = avAngRot + (angRot1 - avAngRot) * frac;
				var newAngRot2:Number = avAngRot + (angRot2 - avAngRot) * frac;

				var newAngVel1:Vector3D = _body0.currentState.rotVelocity.add(JNumber3D.getScaleVector(hingeAxis, newAngRot1 - angRot1));
				var newAngVel2:Vector3D = _body1.currentState.rotVelocity.add(JNumber3D.getScaleVector(hingeAxis, newAngRot2 - angRot2));

				_body0.setAngVel(newAngVel1);
				_body1.setAngVel(newAngVel2);
			}

			if (_extraTorque != 0)
			{
				var torque1:Vector3D = _body0.currentState.orientation.transformVector(_hingeAxis);
				torque1 = JNumber3D.getScaleVector(torque1, _extraTorque);

				_body0.addWorldTorque(torque1);
				_body1.addWorldTorque(JNumber3D.getScaleVector(torque1, -1));
			}
		}
	}
}