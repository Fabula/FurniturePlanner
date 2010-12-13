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
	import flash.utils.Dictionary;

	import jiglib.data.CollOutBodyData;
	import jiglib.geometry.JSegment;
	import jiglib.math.*;
	import jiglib.physics.RigidBody;

	public class CollisionSystem
	{
		private var detectionFunctors:Dictionary;
		public var collBody:Vector.<RigidBody>;

		public function CollisionSystem()
		{
			collBody = new Vector.<RigidBody>();
			detectionFunctors = new Dictionary(true);
			detectionFunctors["BOX_BOX"] = new CollDetectBoxBox();
			detectionFunctors["BOX_SPHERE"] = new CollDetectSphereBox();
			detectionFunctors["BOX_CAPSULE"] = new CollDetectCapsuleBox();
			detectionFunctors["BOX_PLANE"] = new CollDetectBoxPlane();
			detectionFunctors["BOX_TERRAIN"] = new CollDetectBoxTerrain();
			detectionFunctors["SPHERE_BOX"] = new CollDetectSphereBox();
			detectionFunctors["SPHERE_SPHERE"] = new CollDetectSphereSphere();
			detectionFunctors["SPHERE_CAPSULE"] = new CollDetectSphereCapsule();
			detectionFunctors["SPHERE_PLANE"] = new CollDetectSpherePlane();
			detectionFunctors["SPHERE_TERRAIN"] = new CollDetectSphereTerrain();
			detectionFunctors["CAPSULE_CAPSULE"] = new CollDetectCapsuleCapsule();
			detectionFunctors["CAPSULE_BOX"] = new CollDetectCapsuleBox();
			detectionFunctors["CAPSULE_SPHERE"] = new CollDetectSphereCapsule();
			detectionFunctors["CAPSULE_PLANE"] = new CollDetectCapsulePlane();
			detectionFunctors["CAPSULE_TERRAIN"] = new CollDetectCapsuleTerrain();
			detectionFunctors["PLANE_BOX"] = new CollDetectBoxPlane();
			detectionFunctors["PLANE_SPHERE"] = new CollDetectSpherePlane();
			detectionFunctors["PLANE_CAPSULE"] = new CollDetectCapsulePlane();
			detectionFunctors["TERRAIN_SPHERE"] = new CollDetectSphereTerrain();
			detectionFunctors["TERRAIN_BOX"] = new CollDetectBoxTerrain();
			detectionFunctors["TERRAIN_CAPSULE"] = new CollDetectCapsuleTerrain();
		}

		public function addCollisionBody(body:RigidBody):void
		{
			if (!findBody(body))
				collBody.push(body);
		}

		public function removeCollisionBody(body:RigidBody):void
		{
			if (findBody(body))
				collBody.splice(collBody.indexOf(body), 1);
		}

		public function removeAllCollisionBodies():void
		{
			collBody.splice(0, collBody.length);
		}

		// Detects collisions between the body and all the registered collision bodies
		public function detectCollisions(body:RigidBody, collArr:Vector.<CollisionInfo>):void
		{
			if (!body.isActive)
				return;

			var info:CollDetectInfo;
			var fu:CollDetectFunctor;

			for each (var _collBody:RigidBody in collBody)
			{
				if (body != _collBody && checkCollidables(body, _collBody) && detectionFunctors[body.type + "_" + _collBody.type] != undefined)
				{
					info = new CollDetectInfo();
					info.body0 = body;
					info.body1 = _collBody;
					fu = detectionFunctors[info.body0.type + "_" + info.body1.type];
					fu.collDetect(info, collArr);
				}
			}
		}

		// Detects collisions between the all bodies
		public function detectAllCollisions(bodies:Vector.<RigidBody>, collArr:Vector.<CollisionInfo>):void
		{
			var info:CollDetectInfo;
			var fu:CollDetectFunctor;
			var bodyID:int;
			var bodyType:String;

			for each (var _body:RigidBody in bodies)
			{
				bodyID = _body.id;
				bodyType = _body.type;
				for each (var _collBody:RigidBody in collBody)
				{
					if (_body == _collBody)
					{
						continue;
					}

					if (_collBody.isActive && bodyID > _collBody.id)
					{
						continue;
					}

					if (checkCollidables(_body, _collBody) && detectionFunctors[bodyType + "_" + _collBody.type] != undefined)
					{
						info = new CollDetectInfo();
						info.body0 = _body;
						info.body1 = _collBody;
						fu = detectionFunctors[info.body0.type + "_" + info.body1.type];
						fu.collDetect(info, collArr);
					}
				}
			}
		}

		public function segmentIntersect(out:CollOutBodyData, seg:JSegment, ownerBody:RigidBody):Boolean
		{
			out.frac = JNumber3D.NUM_HUGE;
			out.position = new Vector3D();
			out.normal = new Vector3D();

			var obj:CollOutBodyData = new CollOutBodyData();
			for each (var _collBody:RigidBody in collBody)
			{
				if (_collBody != ownerBody && segmentBounding(seg, _collBody))
				{
					if (_collBody.segmentIntersect(obj, seg, _collBody.currentState))
					{
						if (obj.frac < out.frac)
						{
							out.position = obj.position;
							out.normal = obj.normal;
							out.frac = obj.frac;
							out.rigidBody = _collBody;
						}
					}
				}
			}

			if (out.frac > 1)
				return false;

			if (out.frac < 0)
			{
				out.frac = 0;
			}
			else if (out.frac > 1)
			{
				out.frac = 1;
			}

			return true;
		}

		public function segmentBounding(seg:JSegment, obj:RigidBody):Boolean
		{
			var pos:Vector3D = seg.getPoint(0.5);
			var r:Number = seg.delta.length / 2;

			if (obj.type != "PLANE" && obj.type != "TERRAIN")
			{
				var num1:Number = pos.subtract(obj.currentState.position).length;
				var num2:Number = r + obj.boundingSphere;

				if (num1 <= num2)
					return true;
				else
					return false;
			}
			else
			{
				return true;
			}
		}

		private function findBody(body:RigidBody):Boolean
		{
			return collBody.indexOf(body) > -1;
		}

		private function checkCollidables(body0:RigidBody, body1:RigidBody):Boolean
		{
			if (body0.nonCollidables.length == 0 && body1.nonCollidables.length == 0)
				return true;

			if(body0.nonCollidables.indexOf(body1) > -1)
				return false;
			
			if(body1.nonCollidables.indexOf(body0) > -1)
				return false;
				
			return true;
		}
	}
}