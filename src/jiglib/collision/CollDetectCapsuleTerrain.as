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
	import jiglib.data.TerrainData;
	import jiglib.geometry.JCapsule;
	import jiglib.geometry.JTerrain;
	import jiglib.math.JNumber3D;
	import jiglib.physics.MaterialProperties;
	import jiglib.physics.RigidBody;
	
	public class CollDetectCapsuleTerrain extends CollDetectFunctor
	{
		
		public function CollDetectCapsuleTerrain() 
		{
			name = "BoxTerrain";
			type0 = "CAPSULE";
			type1 = "TERRAIN";
		}
		
		override public function collDetect(info:CollDetectInfo, collArr:Vector.<CollisionInfo>):void
		{
			var tempBody:RigidBody;
			if (info.body0.type == "TERRAIN")
			{
				tempBody = info.body0;
				info.body0 = info.body1;
				info.body1 = tempBody;
			}
			
			var capsule:JCapsule = info.body0 as JCapsule;
			var terrain:JTerrain = info.body1 as JTerrain;
			
			var collPts:Vector.<CollPointInfo> = new Vector.<CollPointInfo>();
			var cpInfo:CollPointInfo;
			
			var averageNormal:Vector3D = new Vector3D();
			var pos1:Vector3D = capsule.getBottomPos(capsule.oldState);
			var pos2:Vector3D = capsule.getBottomPos(capsule.currentState);
			var obj1:TerrainData = terrain.getHeightAndNormalByPoint(pos1);
			var obj2:TerrainData = terrain.getHeightAndNormalByPoint(pos2);
			if (Math.min(obj1.height, obj2.height) < JConfig.collToll + capsule.radius) {
				var oldDepth:Number = capsule.radius - obj1.height;
				var worldPos:Vector3D = pos1.subtract(JNumber3D.getScaleVector(obj2.normal, capsule.radius));
				cpInfo = new CollPointInfo();
				cpInfo.r0 = worldPos.subtract(capsule.oldState.position);
				cpInfo.r1 = worldPos.subtract(terrain.oldState.position);
				cpInfo.initialPenetration = oldDepth;
				collPts.push(cpInfo);
				averageNormal = averageNormal.add(obj2.normal);
			}
			
			pos1 = capsule.getEndPos(capsule.oldState);
			pos2 = capsule.getEndPos(capsule.currentState);
			obj1 = terrain.getHeightAndNormalByPoint(pos1);
			obj2 = terrain.getHeightAndNormalByPoint(pos2);
			if (Math.min(obj1.height, obj2.height) < JConfig.collToll + capsule.radius) {
				oldDepth = capsule.radius - obj1.height;
				worldPos = pos1.subtract(JNumber3D.getScaleVector(obj2.normal, capsule.radius));
				cpInfo = new CollPointInfo();
				cpInfo.r0 = worldPos.subtract(capsule.oldState.position);
				cpInfo.r1 = worldPos.subtract(terrain.oldState.position);
				cpInfo.initialPenetration = oldDepth;
				collPts.push(cpInfo);
				averageNormal = averageNormal.add(obj2.normal);
			}
			
			if (collPts.length > 0)
			{
				averageNormal.normalize();
				var collInfo:CollisionInfo = new CollisionInfo();
				collInfo.objInfo = info;
				collInfo.dirToBody = averageNormal;
				collInfo.pointInfo = collPts;

				var mat:MaterialProperties = new MaterialProperties();
				mat.restitution = Math.sqrt(capsule.material.restitution * terrain.material.restitution);
				mat.friction = Math.sqrt(capsule.material.friction * terrain.material.friction);
				collInfo.mat = mat;
				collArr.push(collInfo);

				info.body0.collisions.push(collInfo);
				info.body1.collisions.push(collInfo);
			}
		}
	}

}