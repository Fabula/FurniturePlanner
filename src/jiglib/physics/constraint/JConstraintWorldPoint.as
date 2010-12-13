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


package jiglib.physics.constraint {

	import flash.geom.Vector3D;
	
	import jiglib.math.*;
	import jiglib.physics.RigidBody;
	
	// Constrains a point within a rigid body to remain at a fixed world point
	public class JConstraintWorldPoint extends JConstraint {
		
		private const minVelForProcessing:Number = 0.001;
		private const allowedDeviation:Number = 0.01;
		private const timescale:Number = 4;
		
		private var _body:RigidBody;
		private var _pointOnBody:Vector3D;
		private var _worldPosition:Vector3D;
		
		// pointOnBody is in body coords
		public function JConstraintWorldPoint(body:RigidBody, pointOnBody:Vector3D, worldPosition:Vector3D) {
			super();
			_body = body;
			_pointOnBody = pointOnBody;
			_worldPosition = worldPosition;
			body.addConstraint(this);
		}
		
		public function set worldPosition(pos:Vector3D):void {
			_worldPosition = pos;
		}
		
		public function get worldPosition():Vector3D {
			return _worldPosition;
		}
		
		override public function apply(dt:Number):Boolean {
			this.satisfied = true;

			var worldPos:Vector3D = _body.currentState.orientation.transformVector(_pointOnBody);
			worldPos = worldPos.add( _body.currentState.position);
			var R:Vector3D = worldPos.subtract(_body.currentState.position);
			var currentVel:Vector3D = _body.currentState.linVelocity.add(_body.currentState.rotVelocity.crossProduct(R));
			
			var desiredVel:Vector3D;
			var deviationDir:Vector3D;
			var deviation:Vector3D = worldPos.subtract(_worldPosition);
			var deviationDistance:Number = deviation.length;
			if (deviationDistance > allowedDeviation) {
				deviationDir = JNumber3D.getDivideVector(deviation, deviationDistance);
				desiredVel = JNumber3D.getScaleVector(deviationDir, (allowedDeviation - deviationDistance) / (timescale * dt));
			} else {
				desiredVel = new Vector3D();
			}
			
			var N:Vector3D = currentVel.subtract(desiredVel);
			var normalVel:Number = N.length;
			if (normalVel < minVelForProcessing) {
				return false;
			}
			N = JNumber3D.getDivideVector(N, normalVel);
			
			var tempV:Vector3D = R.crossProduct(N);
			tempV = _body.worldInvInertia.transformVector(tempV);
			var denominator:Number = _body.invMass + N.dotProduct(tempV.crossProduct(R));
			 
			if (denominator < JNumber3D.NUM_TINY) {
				return false;
			}
			 
			var normalImpulse:Number = -normalVel / denominator;
			
			_body.applyWorldImpulse(JNumber3D.getScaleVector(N, normalImpulse), worldPos);
			
			_body.setConstraintsAndCollisionsUnsatisfied();
			this.satisfied = true;
			
			return true;
		}
	}
}
