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
	import jiglib.geometry.JSphere;
	import jiglib.geometry.JTerrain;
	import jiglib.math.JNumber3D;
	import jiglib.physics.MaterialProperties;
	import jiglib.physics.RigidBody;
	
	public class CollDetectSphereTerrain extends CollDetectFunctor
	{
		
		public function CollDetectSphereTerrain() 
		{
			name = "SphereTerrain";
			type0 = "SPHERE";
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

			var sphere:JSphere = info.body0 as JSphere;
			var terrain:JTerrain = info.body1 as JTerrain;
			
			var obj:TerrainData = terrain.getHeightAndNormalByPoint(sphere.currentState.position);
			if (obj.height < JConfig.collToll + sphere.radius) {
				var dist:Number = terrain.getHeightByPoint(sphere.oldState.position);
				var depth:Number = sphere.radius - dist;
				
				var Pt:Vector3D = sphere.oldState.position.subtract(JNumber3D.getScaleVector(obj.normal, sphere.radius));
				
				var collPts:Vector.<CollPointInfo> = new Vector.<CollPointInfo>();
				var cpInfo:CollPointInfo = new CollPointInfo();
				cpInfo.r0 = Pt.subtract(sphere.oldState.position);
				cpInfo.r1 = Pt.subtract(terrain.oldState.position);
				cpInfo.initialPenetration = depth;
				collPts.push(cpInfo);
				
				var collInfo:CollisionInfo = new CollisionInfo();
				collInfo.objInfo = info;
				collInfo.dirToBody = obj.normal;
				collInfo.pointInfo = collPts;
				var mat:MaterialProperties = new MaterialProperties();
				mat.restitution = Math.sqrt(sphere.material.restitution * terrain.material.restitution);
				mat.friction = Math.sqrt(sphere.material.friction * terrain.material.friction);
				collInfo.mat = mat;
				collArr.push(collInfo);
				info.body0.collisions.push(collInfo);
				info.body1.collisions.push(collInfo);
			}
		}
	}

}