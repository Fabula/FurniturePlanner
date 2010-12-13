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

package jiglib.collision
{

	import flash.geom.Vector3D;

	import jiglib.cof.JConfig;
	import jiglib.geometry.*;
	import jiglib.math.*;
	import jiglib.physics.MaterialProperties;
	import jiglib.physics.RigidBody;

	public class CollDetectSphereCapsule extends CollDetectFunctor
	{

		public function CollDetectSphereCapsule()
		{
			name = "SphereCapsule";
			type0 = "SPHERE";
			type1 = "CAPSULE";
		}

		override public function collDetect(info:CollDetectInfo, collArr:Vector.<CollisionInfo>):void
		{
			var tempBody:RigidBody;
			if (info.body0.type == "CAPSULE")
			{
				tempBody = info.body0;
				info.body0 = info.body1;
				info.body1 = tempBody;
			}

			var sphere:JSphere = info.body0 as JSphere;
			var capsule:JCapsule = info.body1 as JCapsule;

			if (!sphere.hitTestObject3D(capsule))
			{
				return;
			}
			
			if (JConfig.aabbDetection && !sphere.boundingBox.overlapTest(capsule.boundingBox)) {
				return;
			}

			var oldSeg:JSegment = new JSegment(capsule.getBottomPos(capsule.oldState), JNumber3D.getScaleVector(capsule.oldState.getOrientationCols()[1], capsule.length));
			var newSeg:JSegment = new JSegment(capsule.getBottomPos(capsule.currentState), JNumber3D.getScaleVector(capsule.currentState.getOrientationCols()[1], capsule.length));
			var radSum:Number = sphere.radius + capsule.radius;

			var oldObj:Vector.<Number> = new Vector.<Number>(1, true);
			var oldDistSq:Number = oldSeg.pointSegmentDistanceSq(oldObj, sphere.oldState.position);
			var newObj:Vector.<Number> = new Vector.<Number>(1, true);
			var newDistSq:Number = newSeg.pointSegmentDistanceSq(newObj, sphere.currentState.position);

			if (Math.min(oldDistSq, newDistSq) < Math.pow(radSum + JConfig.collToll, 2))
			{
				var segPos:Vector3D = oldSeg.getPoint(oldObj[0]);
				var delta:Vector3D = sphere.oldState.position.subtract(segPos);

				var dist:Number = Math.sqrt(oldDistSq);
				var depth:Number = radSum - dist;

				if (dist > JNumber3D.NUM_TINY)
				{
					delta = JNumber3D.getDivideVector(delta, dist);
				}
				else
				{
					delta = JMatrix3D.getRotationMatrix(0, 0, 1, 360 * Math.random()).transformVector(Vector3D.Y_AXIS);
				}

				var worldPos:Vector3D = segPos.add(JNumber3D.getScaleVector(delta, capsule.radius - 0.5 * depth));

				var collPts:Vector.<CollPointInfo> = new Vector.<CollPointInfo>();
				var cpInfo:CollPointInfo = new CollPointInfo();
				cpInfo.r0 = worldPos.subtract(sphere.oldState.position);
				cpInfo.r1 = worldPos.subtract(capsule.oldState.position);
				cpInfo.initialPenetration = depth;
				collPts.push(cpInfo);

				var collInfo:CollisionInfo = new CollisionInfo();
				collInfo.objInfo = info;
				collInfo.dirToBody = delta;
				collInfo.pointInfo = collPts;

				var mat:MaterialProperties = new MaterialProperties();
				mat.restitution = Math.sqrt(sphere.material.restitution * capsule.material.restitution);
				mat.friction = Math.sqrt(sphere.material.friction * capsule.material.friction);
				collInfo.mat = mat;
				collArr.push(collInfo);

				info.body0.collisions.push(collInfo);
				info.body1.collisions.push(collInfo);
			}
		}
	}

}
