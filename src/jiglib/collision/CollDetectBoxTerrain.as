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
	import jiglib.geometry.JBox;
	import jiglib.geometry.JTerrain;
	import jiglib.math.JNumber3D;
	import jiglib.physics.MaterialProperties;
	import jiglib.physics.RigidBody;
	
	public class CollDetectBoxTerrain extends CollDetectFunctor
	{
		
		public function CollDetectBoxTerrain() 
		{
			name = "BoxTerrain";
			type0 = "BOX";
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
			
			var box:JBox = info.body0 as JBox;
			var terrain:JTerrain = info.body1 as JTerrain;
			
			var oldPts:Vector.<Vector3D> = box.getCornerPoints(box.oldState);
			var newPts:Vector.<Vector3D> = box.getCornerPoints(box.currentState);
			var collNormal:Vector3D = new Vector3D();
			
			var obj:TerrainData;
			var dist:Number;
			var newPt:Vector3D;
			var oldPt:Vector3D;
			
			var collPts:Vector.<CollPointInfo> = new Vector.<CollPointInfo>();
			var cpInfo:CollPointInfo;
			
			for (var i:int = 0; i < 8; i++ ) {
				newPt = newPts[i];
				obj = terrain.getHeightAndNormalByPoint(newPt);
				
				if (obj.height < JConfig.collToll) {
					oldPt = oldPts[i];
					dist = terrain.getHeightByPoint(oldPt);
					collNormal = collNormal.add(obj.normal);
					cpInfo = new CollPointInfo();
					cpInfo.r0 = oldPt.subtract(box.oldState.position);
					cpInfo.r1 = oldPt.subtract(terrain.oldState.position);
					cpInfo.initialPenetration = -dist;
					collPts.push(cpInfo);
				}
			}
			
			if (collPts.length > 0) {
				collNormal.normalize();
				var collInfo:CollisionInfo = new CollisionInfo();
				collInfo.objInfo = info;
				collInfo.dirToBody = collNormal;
				collInfo.pointInfo = collPts;
				var mat:MaterialProperties = new MaterialProperties();
				mat.restitution = Math.sqrt(box.material.restitution * terrain.material.restitution);
				mat.friction = Math.sqrt(box.material.friction * terrain.material.friction);
				collInfo.mat = mat;
				collArr.push(collInfo);
				info.body0.collisions.push(collInfo);
				info.body1.collisions.push(collInfo);
			}
		}
	}

}