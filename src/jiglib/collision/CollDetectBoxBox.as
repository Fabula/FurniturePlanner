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
	import jiglib.data.EdgeData;
	import jiglib.data.SpanData;
	import jiglib.geometry.*;
	import jiglib.math.*;
	import jiglib.physics.MaterialProperties;
	import jiglib.physics.PhysicsState;

	public class CollDetectBoxBox extends CollDetectFunctor
	{
		private const MAX_SUPPORT_VERTS:Number = 10;
		private var combinationDist:Number;

		public function CollDetectBoxBox()
		{
			name = "BoxBox";
			type0 = "BOX";
			type1 = "BOX";
		}

		//Returns true if disjoint.  Returns false if intersecting
		private function disjoint(out:SpanData, axis:Vector3D, box0:JBox, box1:JBox):Boolean
		{
			var obj0:SpanData = box0.getSpan(axis);
			var obj1:SpanData = box1.getSpan(axis);
			var obj0Min:Number = obj0.min;
			var obj0Max:Number = obj0.max;
			var obj1Min:Number = obj1.min;
			var obj1Max:Number = obj1.max;

			if (obj0Min > (obj1Max + JConfig.collToll + JNumber3D.NUM_TINY) || obj1Min > (obj0Max + JConfig.collToll + JNumber3D.NUM_TINY))
			{
				out.flag = true;
				return true;
			}
			if ((obj0Max > obj1Max) && (obj1Min > obj0Min))
			{
				out.depth = Math.min(obj0Max - obj1Min, obj1Max - obj0Min);
			}
			else if ((obj1Max > obj0Max) && (obj0Min > obj1Min))
			{
				out.depth = Math.min(obj1Max - obj0Min, obj0Max - obj1Min);
			}
			else
			{
				out.depth = Math.min(obj0Max, obj1Max);
				out.depth -= Math.max(obj0Min, obj1Min);
			}
			out.flag = false;
			return false;
		}

		private function addPoint(contactPoints:Vector.<Vector3D>, pt:Vector3D, combinationDistanceSq:Number):Boolean
		{
			for each (var contactPoint:Vector3D in contactPoints)
			{
				if (contactPoint.subtract(pt).lengthSquared < combinationDistanceSq)
				{
					contactPoint = JNumber3D.getDivideVector(contactPoint.add(pt), 2);
					return false;
				}
			}
			contactPoints.push(pt);
			return true;
		}
		
		private function getSupportPoint(box:JBox, axis:Vector3D):Vector3D {
			var orientationCol:Vector.<Vector3D> = box.currentState.getOrientationCols();
			var _as:Number = axis.dotProduct(orientationCol[0]);
			var _au:Number = axis.dotProduct(orientationCol[1]);
			var _ad:Number = axis.dotProduct(orientationCol[2]);
			
			var p:Vector3D = box.currentState.position.clone();
  
			if (_as < -JNumber3D.NUM_TINY) {
				p = p.add(JNumber3D.getScaleVector(orientationCol[0], 0.5 * box.sideLengths.x));
			}else if (_as >= JNumber3D.NUM_TINY) {
				p = p.subtract(JNumber3D.getScaleVector(orientationCol[0], 0.5 * box.sideLengths.x));
			}
  
			if (_au < -JNumber3D.NUM_TINY) {
				p = p.add(JNumber3D.getScaleVector(orientationCol[1], 0.5 * box.sideLengths.y));
			}else if (_au > JNumber3D.NUM_TINY) {
				p = p.subtract(JNumber3D.getScaleVector(orientationCol[1], 0.5 * box.sideLengths.y));
			}
  
			if (_ad < -JNumber3D.NUM_TINY) {
				p = p.add(JNumber3D.getScaleVector(orientationCol[2], 0.5 * box.sideLengths.z));
			}else if (_ad > JNumber3D.NUM_TINY) {
				p = p.subtract(JNumber3D.getScaleVector(orientationCol[2], 0.5 * box.sideLengths.z));
			}
			return p;
		}

		private function getAABox2EdgeIntersectionPoints(contactPoint:Vector.<Vector3D>, origBoxSides:Vector3D, origBoxState:PhysicsState, edgePt0:Vector3D, edgePt1:Vector3D):int {
			var jDir:int;
			var kDir:int;
			var dist0:Number;
			var dist1:Number;
			var frac:Number;
			var num:int = 0;
			var pt:Vector3D;
			var edgeDir:Vector3D = edgePt1.subtract(edgePt0);
			edgeDir.normalize();
			var ptArr:Array;
			var faceOffsets:Array;
			var edgePt0Arr:Array = JNumber3D.toArray(edgePt0);
			var edgePt1Arr:Array = JNumber3D.toArray(edgePt1);
			var edgeDirArr:Array = JNumber3D.toArray(edgeDir);
			var sidesArr:Array = JNumber3D.toArray(JNumber3D.getScaleVector(origBoxSides, 0.5));
			for (var iDir:int = 2; iDir >= 0; iDir--) {
				if (Math.abs(edgeDirArr[iDir]) < 0.1) {
					continue;
				}
				jDir = (iDir + 1) % 3;
				kDir = (iDir + 2) % 3;
				faceOffsets = [ -sidesArr[iDir], sidesArr[iDir]];
				for (var iFace:int = 1; iFace >= 0; iFace-- ) {
					dist0 = edgePt0Arr[iDir] - faceOffsets[iFace];
					dist1 = edgePt1Arr[iDir] - faceOffsets[iFace];
					frac = -1;
					if (dist0 * dist1 < -JNumber3D.NUM_TINY) {
						frac = -dist0 / (dist1 - dist0);
					}else if (Math.abs(dist0) < JNumber3D.NUM_TINY) {
						frac = 0;
					}else if (Math.abs(dist1) < JNumber3D.NUM_TINY) {
						frac = 1;
					}
					if (frac >= 0) {
						pt = JNumber3D.getScaleVector(edgePt0, 1 - frac).add(JNumber3D.getScaleVector(edgePt1, frac));
						ptArr = JNumber3D.toArray(pt);
						if ((ptArr[jDir] > -sidesArr[jDir] - JNumber3D.NUM_TINY) && (ptArr[jDir] < sidesArr[jDir] + JNumber3D.NUM_TINY) && (ptArr[kDir] > -sidesArr[kDir] - JNumber3D.NUM_TINY) && (ptArr[kDir] < sidesArr[kDir] + JNumber3D.NUM_TINY) ) {
							pt = origBoxState.orientation.transformVector(pt);
							pt = pt.add(origBoxState.position);
							addPoint(contactPoint, pt, combinationDist);
							if (++num == 2) {
								return num;
							}
						}
					}
				}
			}
			return num;
		}
		
		private function getBox2BoxEdgesIntersectionPoints(contactPoint:Vector.<Vector3D>, box0:JBox, box1:JBox, newState:Boolean):Number
		{
			var num:Number = 0;
			var seg:JSegment;
			var box0State:PhysicsState = (newState) ? box0.currentState : box0.oldState;
			var box1State:PhysicsState = (newState) ? box1.currentState : box1.oldState;
			var boxPts:Vector.<Vector3D> = box1.getCornerPointsInBoxSpace(box1State, box0State);
			
			var boxEdges:Vector.<EdgeData> = box1.edges;
			var edgePt0:Vector3D;
			var edgePt1:Vector3D;
			for each (var boxEdge:EdgeData in boxEdges)
			{
				edgePt0 = boxPts[boxEdge.ind0];
				edgePt1 = boxPts[boxEdge.ind1];
				num += getAABox2EdgeIntersectionPoints(contactPoint, box0.sideLengths, box0State, edgePt0, edgePt1);
				if (num >= 8) {
					return num;
				}
			}
			return num;
		}

		private function getBoxBoxIntersectionPoints(contactPoint:Vector.<Vector3D>, box0:JBox, box1:JBox, newState:Boolean):uint
		{
			getBox2BoxEdgesIntersectionPoints(contactPoint, box0, box1, newState);
			getBox2BoxEdgesIntersectionPoints(contactPoint, box1, box0, newState);
			return contactPoint.length;
		}
		
		override public function collDetect(info:CollDetectInfo, collArr:Vector.<CollisionInfo>):void
		{
			var box0:JBox = info.body0 as JBox;
			var box1:JBox = info.body1 as JBox;

			if (!box0.hitTestObject3D(box1))
				return;

			if (JConfig.aabbDetection && !box0.boundingBox.overlapTest(box1.boundingBox))
				return;

			var numTiny:Number = JNumber3D.NUM_TINY;
			var numHuge:Number = JNumber3D.NUM_HUGE;

			var dirs0Arr:Vector.<Vector3D> = box0.currentState.getOrientationCols();
			var dirs1Arr:Vector.<Vector3D> = box1.currentState.getOrientationCols();

			// the 15 potential separating axes
			var axes:Vector.<Vector3D> = Vector.<Vector3D>([dirs0Arr[0], dirs0Arr[1], dirs0Arr[2],
				dirs1Arr[0], dirs1Arr[1], dirs1Arr[2],
				dirs0Arr[0].crossProduct(dirs1Arr[0]),
				dirs0Arr[1].crossProduct(dirs1Arr[0]),
				dirs0Arr[2].crossProduct(dirs1Arr[0]),
				dirs0Arr[0].crossProduct(dirs1Arr[1]),
				dirs0Arr[1].crossProduct(dirs1Arr[1]),
				dirs0Arr[2].crossProduct(dirs1Arr[1]),
				dirs0Arr[0].crossProduct(dirs1Arr[2]),
				dirs0Arr[1].crossProduct(dirs1Arr[2]),
				dirs0Arr[2].crossProduct(dirs1Arr[2])]);

			var l2:Number;
			// the overlap depths along each axis
			var overlapDepths:Vector.<SpanData> = new Vector.<SpanData>();
			var i:int = 0;
			var axesLength:int = axes.length;

			// see if the boxes are separate along any axis, and if not keep a 
			// record of the depths along each axis
			for (i = 0; i < axesLength; i++)
			{
				var _overlapDepth:SpanData = overlapDepths[i] = new SpanData();
				_overlapDepth.depth = numHuge;

				l2 = axes[i].lengthSquared;
				if (l2 < numTiny)
					continue;
				
				var ax:Vector3D = axes[i].clone();
				ax.normalize();
				if (disjoint(overlapDepths[i], ax, box0, box1))
					return;
			}

			// The box overlap, find the separation depth closest to 0.
			var minDepth:Number = numHuge;
			var minAxis:int = -1;
			axesLength = axes.length;
			for (i = 0; i < axesLength; i++)
			{
				l2 = axes[i].lengthSquared;
				if (l2 < numTiny)
					continue;

				// If this axis is the minimum, select it
				if (overlapDepths[i].depth < minDepth)
				{
					minDepth = overlapDepths[i].depth;
					minAxis = int(i);
				}
			}
			
			if (minAxis == -1)
				return;
			
			// Make sure the axis is facing towards the box0. if not, invert it
			var N:Vector3D = axes[minAxis].clone();
			if (box1.currentState.position.subtract(box0.currentState.position).dotProduct(N) > 0)
				N = JNumber3D.getScaleVector(N, -1);
			
			var contactPointsFromOld:Boolean = true;
			var contactPoints:Vector.<Vector3D> = new Vector.<Vector3D>();
			combinationDist = 0.05 * Math.min(Math.min(box0.sideLengths.x, box0.sideLengths.y, box0.sideLengths.z), Math.min(box1.sideLengths.x, box1.sideLengths.y, box1.sideLengths.z));
			combinationDist += (JConfig.collToll * 3.464);
			combinationDist *= combinationDist;

			if (minDepth > -JNumber3D.NUM_TINY)
				getBoxBoxIntersectionPoints(contactPoints, box0, box1, false);
			
			if (contactPoints.length == 0)
			{
				contactPointsFromOld = false;
				getBoxBoxIntersectionPoints(contactPoints, box0, box1, true);
			}
			
			var bodyDelta:Vector3D = box0.currentState.position.subtract(box0.oldState.position).subtract(box1.currentState.position.subtract(box1.oldState.position));
			var bodyDeltaLen:Number = bodyDelta.dotProduct(N);
			var oldDepth:Number = minDepth + bodyDeltaLen;
			
			var SATPoint:Vector3D = new Vector3D();
			switch(minAxis){
				//-----------------------------------------------------------------
				// Box0 face, Box1 Corner collision
				//-----------------------------------------------------------------
			case 0:
			case 1:
			case 2:
			{
				//-----------------------------------------------------------------
				// Get the lowest point on the box1 along box1 normal
				//-----------------------------------------------------------------
				SATPoint = getSupportPoint(box1, JNumber3D.getScaleVector(N, -1));
				break;
			}
			//-----------------------------------------------------------------
			// We have a Box2 corner/Box1 face collision
			//-----------------------------------------------------------------
			case 3:
			case 4:
			case 5:
			{
				//-----------------------------------------------------------------
				// Find with vertex on the triangle collided
				//-----------------------------------------------------------------
				SATPoint = getSupportPoint(box0, N);
				break;
			}
			//-----------------------------------------------------------------
			// We have an edge/edge colliiosn
			//-----------------------------------------------------------------
			case 6:
			case 7:
			case 8:
			case 9:
			case 10:
			case 11:
			case 12:
			case 13:
			case 14:
			{ 
				//-----------------------------------------------------------------
				// Retrieve which edges collided.
				//-----------------------------------------------------------------
				i = minAxis - 6;
				var ia:int = i / 3;
				var ib:int = i - ia * 3;
				//-----------------------------------------------------------------
				// find two P0, P1 point on both edges. 
				//-----------------------------------------------------------------
				var P0:Vector3D = getSupportPoint(box0, N);
				var P1:Vector3D = getSupportPoint(box1, JNumber3D.getScaleVector(N, -1));
      
				//-----------------------------------------------------------------
				// Find the edge intersection. 
				//-----------------------------------------------------------------
     
				//-----------------------------------------------------------------
				// plane along N and F, and passing through PB
				//-----------------------------------------------------------------
				var planeNormal:Vector3D = N.crossProduct(dirs1Arr[ib]);
				var planeD:Number = planeNormal.dotProduct(P1);
      
				//-----------------------------------------------------------------
				// find the intersection t, where Pintersection = P0 + t*box edge dir
				//-----------------------------------------------------------------
				var div:Number = dirs0Arr[ia].dotProduct(planeNormal);
      
				//-----------------------------------------------------------------
				// plane and ray colinear, skip the intersection.
				//-----------------------------------------------------------------
				if (Math.abs(div) < JNumber3D.NUM_TINY)
					return;
      
				var t:Number = (planeD - P0.dotProduct(planeNormal)) / div;
      
				//-----------------------------------------------------------------
				// point on edge of box0
				//-----------------------------------------------------------------
				P0 = P0.add(JNumber3D.getScaleVector(dirs0Arr[ia], t));
				SATPoint = P0.add(JNumber3D.getScaleVector(N, 0.5 * minDepth));
				break;
			}
			}

			var collPts:Vector.<CollPointInfo>;
			if (contactPoints.length > 0)
			{
				collPts = new Vector.<CollPointInfo>(contactPoints.length, true);

				var minDist:Number = JNumber3D.NUM_HUGE;
				var maxDist:Number = -JNumber3D.NUM_HUGE;
				var dist:Number;
				var depth:Number;
				var depthScale:Number;
				var cpInfo:CollPointInfo;
				var contactPoint:Vector3D;

				for each (contactPoint in contactPoints)
				{
					dist = contactPoint.subtract(SATPoint).length;
					
					if (dist < minDist)
						minDist = dist;

					if (dist > maxDist)
						maxDist = dist;
				}

				if (maxDist < minDist + JNumber3D.NUM_TINY)
					maxDist = minDist + JNumber3D.NUM_TINY;

				i = 0;
				for each (contactPoint in contactPoints)
				{
					dist = contactPoint.subtract(SATPoint).length;
					depthScale = (dist - minDist) / (maxDist - minDist);
					depth = (1 - depthScale) * oldDepth;
					cpInfo = new CollPointInfo();
					
					if (contactPointsFromOld)
					{
						cpInfo.r0 = contactPoint.subtract(box0.oldState.position);
						cpInfo.r1 = contactPoint.subtract(box1.oldState.position);
					}
					else
					{
						cpInfo.r0 = contactPoint.subtract(box0.currentState.position);
						cpInfo.r1 = contactPoint.subtract(box1.currentState.position);
					}
					
					cpInfo.initialPenetration = depth;
					collPts[int(i++)] = cpInfo;
				}
			}
			else
			{
				cpInfo = new CollPointInfo();
				cpInfo.r0 = SATPoint.subtract(box0.currentState.position);
				cpInfo.r1 = SATPoint.subtract(box1.currentState.position);
				cpInfo.initialPenetration = oldDepth;
				
				collPts = new Vector.<CollPointInfo>(1, true);
				collPts[0] = cpInfo;
			}

			var collInfo:CollisionInfo = new CollisionInfo();
			collInfo.objInfo = info;
			collInfo.dirToBody = N;
			collInfo.pointInfo = collPts;

			var mat:MaterialProperties = new MaterialProperties();
			mat.restitution = Math.sqrt(box0.material.restitution * box1.material.restitution);
			mat.friction = Math.sqrt(box0.material.friction * box1.material.friction);
			collInfo.mat = mat;
			collArr.push(collInfo);

			info.body0.collisions.push(collInfo);
			info.body1.collisions.push(collInfo);
		}
	}
}