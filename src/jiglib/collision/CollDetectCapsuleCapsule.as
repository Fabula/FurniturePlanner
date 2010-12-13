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

	public class CollDetectCapsuleCapsule extends CollDetectFunctor
	{

		public function CollDetectCapsuleCapsule()
		{
			name = "CapsuleCapsule";
			type0 = "CAPSULE";
			type1 = "CAPSULE";
		}

		override public function collDetect(info:CollDetectInfo, collArr:Vector.<CollisionInfo>):void
		{
			var capsule0:JCapsule = info.body0 as JCapsule;
			var capsule1:JCapsule = info.body1 as JCapsule;

			if (!capsule0.hitTestObject3D(capsule1))
			{
				return;
			}
			
			if (JConfig.aabbDetection && !capsule0.boundingBox.overlapTest(capsule1.boundingBox)) {
				return;
			}

			var collPts:Vector.<CollPointInfo> = new Vector.<CollPointInfo>();
			var cpInfo:CollPointInfo;

			var averageNormal:Vector3D = new Vector3D();
			var oldSeg0:JSegment = new JSegment(capsule0.getEndPos(capsule0.oldState), JNumber3D.getScaleVector(capsule0.oldState.getOrientationCols()[1], -capsule0.length));
			var newSeg0:JSegment = new JSegment(capsule0.getEndPos(capsule0.currentState), JNumber3D.getScaleVector(capsule0.currentState.getOrientationCols()[1], -capsule0.length));
			var oldSeg1:JSegment = new JSegment(capsule1.getEndPos(capsule1.oldState), JNumber3D.getScaleVector(capsule1.oldState.getOrientationCols()[1], -capsule1.length));
			var newSeg1:JSegment = new JSegment(capsule1.getEndPos(capsule1.currentState), JNumber3D.getScaleVector(capsule1.currentState.getOrientationCols()[1], -capsule1.length));

			var radSum:Number = capsule0.radius + capsule1.radius;

			var oldObj:Vector.<Number> = new Vector.<Number>(2, true);
			var oldDistSq:Number = oldSeg0.segmentSegmentDistanceSq(oldObj, oldSeg1);
			var newObj:Vector.<Number> = new Vector.<Number>(2, true);
			var newDistSq:Number = newSeg0.segmentSegmentDistanceSq(oldObj, newSeg1);

			if (Math.min(oldDistSq, newDistSq) < Math.pow(radSum + JConfig.collToll, 2))
			{
				var pos0:Vector3D = oldSeg0.getPoint(oldObj[0]);
				var pos1:Vector3D = oldSeg1.getPoint(oldObj[1]);

				var delta:Vector3D = pos0.subtract(pos1);
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

				var worldPos:Vector3D = pos1.add(JNumber3D.getScaleVector(delta, capsule1.radius - 0.5 * depth));
				averageNormal = averageNormal.add(delta);

				cpInfo = new CollPointInfo();
				cpInfo.r0 = worldPos.subtract(capsule0.oldState.position);
				cpInfo.r1 = worldPos.subtract(capsule1.oldState.position);
				cpInfo.initialPenetration = depth;
				collPts.push(cpInfo);
			}

			if (collPts.length > 0)
			{
				var collInfo:CollisionInfo = new CollisionInfo();
				collInfo.objInfo = info;
				collInfo.dirToBody = averageNormal;
				collInfo.pointInfo = collPts;

				var mat:MaterialProperties = new MaterialProperties();
				mat.restitution = Math.sqrt(capsule0.material.restitution * capsule1.material.restitution);
				mat.friction = Math.sqrt(capsule0.material.friction * capsule1.material.friction);
				collInfo.mat = mat;
				collArr.push(collInfo);

				info.body0.collisions.push(collInfo);
				info.body1.collisions.push(collInfo);
			}
		}
	}

}
