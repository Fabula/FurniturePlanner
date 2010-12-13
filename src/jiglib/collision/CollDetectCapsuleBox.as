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

	public class CollDetectCapsuleBox extends CollDetectFunctor
	{

		public function CollDetectCapsuleBox()
		{
			name = "CapsuleBox";
			type0 = "CAPSULE";
			type1 = "BOX";
		}

		override public function collDetect(info:CollDetectInfo, collArr:Vector.<CollisionInfo>):void
		{
			var tempBody:RigidBody;
			if (info.body0.type == "BOX")
			{
				tempBody = info.body0;
				info.body0 = info.body1;
				info.body1 = tempBody;
			}

			var capsule:JCapsule = info.body0 as JCapsule;
			var box:JBox = info.body1 as JBox;

			if (!capsule.hitTestObject3D(box))
			{
				return;
			}
			if (JConfig.aabbDetection && !capsule.boundingBox.overlapTest(box.boundingBox)) {
				return;
			}

			var collPts:Vector.<CollPointInfo> = new Vector.<CollPointInfo>();
			var cpInfo:CollPointInfo;

			var averageNormal:Vector3D = new Vector3D();
			var oldSeg:JSegment = new JSegment(capsule.getBottomPos(capsule.oldState), JNumber3D.getScaleVector(capsule.oldState.getOrientationCols()[1], capsule.length));
			var newSeg:JSegment = new JSegment(capsule.getBottomPos(capsule.currentState), JNumber3D.getScaleVector(capsule.currentState.getOrientationCols()[1], capsule.length));
			var radius:Number = capsule.radius;

			var oldObj:Vector.<Number> = new Vector.<Number>(4, true);
			var oldDistSq:Number = oldSeg.segmentBoxDistanceSq(oldObj, box, box.oldState);
			var newObj:Vector.<Number> = new Vector.<Number>(4, true);
			var newDistSq:Number = newSeg.segmentBoxDistanceSq(newObj, box, box.currentState);
			var arr:Vector.<Vector3D> = box.oldState.getOrientationCols();

			if (Math.min(oldDistSq, newDistSq) < Math.pow(radius + JConfig.collToll, 2))
			{
				var segPos:Vector3D = oldSeg.getPoint(Number(oldObj[3]));
				var boxPos:Vector3D = box.oldState.position.clone();
				boxPos = boxPos.add(JNumber3D.getScaleVector(arr[0], oldObj[0]));
				boxPos = boxPos.add(JNumber3D.getScaleVector(arr[1], oldObj[1]));
				boxPos = boxPos.add(JNumber3D.getScaleVector(arr[2], oldObj[2]));

				var dist:Number = Math.sqrt(oldDistSq);
				var depth:Number = radius - dist;

				var dir:Vector3D;
				if (dist > JNumber3D.NUM_TINY)
				{
					dir = segPos.subtract(boxPos);
					dir.normalize();
				}
				else if (segPos.subtract(box.oldState.position).length > JNumber3D.NUM_TINY)
				{
					dir = segPos.subtract(box.oldState.position);
					dir.normalize();
				}
				else
				{
					dir = JMatrix3D.getRotationMatrix(0, 0, 1, 360 * Math.random()).transformVector(Vector3D.Y_AXIS);
				}
				averageNormal = averageNormal.add(dir);

				cpInfo = new CollPointInfo();
				cpInfo.r0 = boxPos.subtract(capsule.oldState.position);
				cpInfo.r1 = boxPos.subtract(box.oldState.position);
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
				mat.restitution = Math.sqrt(capsule.material.restitution * box.material.restitution);
				mat.friction = Math.sqrt(capsule.material.friction * box.material.friction);
				collInfo.mat = mat;
				collArr.push(collInfo);

				info.body0.collisions.push(collInfo);
				info.body1.collisions.push(collInfo);
			}
		}
	}

}
