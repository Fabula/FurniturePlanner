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

package jiglib.geometry {
	import flash.geom.Vector3D;
	
	import jiglib.math.JNumber3D;
	
	// An axis-aligned box
	public class JAABox {
		
		private var _minPos:Vector3D;
		private var _maxPos:Vector3D;
		
		public function JAABox(minPos:Vector3D, maxPos:Vector3D) {
			_minPos = minPos.clone();
			_maxPos = maxPos.clone();
		}
		
		public function get minPos():Vector3D {
			return _minPos;
		}
		public function set minPos(pos:Vector3D):void {
			_minPos = pos.clone();
		}
		
		public function get maxPos():Vector3D {
			return _maxPos;
		}
		public function set maxPos(pos:Vector3D):void {
			_maxPos = pos.clone();
		}
		
		public function get sideLengths():Vector3D {
			var pos:Vector3D = _maxPos.clone();
			pos.subtract(_minPos);
			return pos;
		}
		
		public function get centrePos():Vector3D {
			var pos:Vector3D = _minPos.clone();
			return JNumber3D.getScaleVector(pos.add(_maxPos), 0.5);
		}
		
		public function move(delta:Vector3D):void {
			_minPos.add(delta);
			_maxPos.add(delta);
		}
		
		public function clear():void {
			_minPos = new Vector3D(JNumber3D.NUM_HUGE, JNumber3D.NUM_HUGE, JNumber3D.NUM_HUGE);
			_maxPos = new Vector3D( -JNumber3D.NUM_HUGE, -JNumber3D.NUM_HUGE, -JNumber3D.NUM_HUGE);
		}
		
		public function clone():JAABox {
			return new JAABox(_minPos, _maxPos);
		}
		
		
		
		public function addPoint(pos:Vector3D):void {
			if (pos.x < _minPos.x) _minPos.x = pos.x - JNumber3D.NUM_TINY;
			if (pos.x > _maxPos.x) _maxPos.x = pos.x + JNumber3D.NUM_TINY;
			if (pos.y < _minPos.y) _minPos.y = pos.y - JNumber3D.NUM_TINY;
			if (pos.y > _maxPos.y) _maxPos.y = pos.y + JNumber3D.NUM_TINY;
			if (pos.z < _minPos.z) _minPos.z = pos.z - JNumber3D.NUM_TINY;
			if (pos.z > _maxPos.z) _maxPos.z = pos.z + JNumber3D.NUM_TINY;
		}
		
		public function addBox(box:JBox):void {
			var pts:Vector.<Vector3D> = box.getCornerPoints(box.currentState);
			addPoint(pts[0]);
			addPoint(pts[1]);
			addPoint(pts[2]);
			addPoint(pts[3]);
			addPoint(pts[4]);
			addPoint(pts[5]);
			addPoint(pts[6]);
			addPoint(pts[7]);
		}
		
		public function addSphere(sphere:JSphere):void {
			if (sphere.currentState.position.x - sphere.radius < _minPos.x) {
				_minPos.x = (sphere.currentState.position.x - sphere.radius) - 1;
			}
			if (sphere.currentState.position.x + sphere.radius > _maxPos.x) {
				_maxPos.x = (sphere.currentState.position.x + sphere.radius) + 1;
			}
			
			if (sphere.currentState.position.y - sphere.radius < _minPos.y) {
				_minPos.y = (sphere.currentState.position.y - sphere.radius) - 1;
			}
			if (sphere.currentState.position.y + sphere.radius > _maxPos.y) {
				_maxPos.y = (sphere.currentState.position.y + sphere.radius) + 1;
			}
			
			if (sphere.currentState.position.z - sphere.radius < _minPos.z) {
				_minPos.z = (sphere.currentState.position.z - sphere.radius) - 1;
			}
			if (sphere.currentState.position.z + sphere.radius > _maxPos.z) {
				_maxPos.z = (sphere.currentState.position.z + sphere.radius) + 1;
			}
		}
		
		public function addCapsule(capsule:JCapsule):void {
			var pos:Vector3D = capsule.getBottomPos(capsule.currentState);
			if (pos.x - capsule.radius < _minPos.x) {
				_minPos.x = (pos.x - capsule.radius) - 1;
			}
			if (pos.x + capsule.radius > _maxPos.x) {
				_maxPos.x = (pos.x + capsule.radius) + 1;
			}
			
			if (pos.y - capsule.radius < _minPos.y) {
				_minPos.y = (pos.y - capsule.radius) - 1;
			}
			if (pos.y + capsule.radius > _maxPos.y) {
				_maxPos.y = (pos.y + capsule.radius) + 1;
			}
			
			if (pos.z - capsule.radius < _minPos.z) {
				_minPos.z = (pos.z - capsule.radius) - 1;
			}
			if (pos.z + capsule.radius > _maxPos.z) {
				_maxPos.z = (pos.z + capsule.radius) + 1;
			}
			
			pos = capsule.getEndPos(capsule.currentState);
			if (pos.x - capsule.radius < _minPos.x) {
				_minPos.x = (pos.x - capsule.radius) - 1;
			}
			if (pos.x + capsule.radius > _maxPos.x) {
				_maxPos.x = (pos.x + capsule.radius) + 1;
			}
			
			if (pos.y - capsule.radius < _minPos.y) {
				_minPos.y = (pos.y - capsule.radius) - 1;
			}
			if (pos.y + capsule.radius > _maxPos.y) {
				_maxPos.y = (pos.y + capsule.radius) + 1;
			}
			
			if (pos.z - capsule.radius < _minPos.z) {
				_minPos.z = (pos.z - capsule.radius) - 1;
			}
			if (pos.z + capsule.radius > _maxPos.z) {
				_maxPos.z = (pos.z + capsule.radius) + 1;
			}
		}
		
		public function addSegment(seg:JSegment):void {
			addPoint(seg.origin);
			addPoint(seg.getEnd());
		}
		
		public function overlapTest(box:JAABox):Boolean {
			return (
				(_minPos.z >= box.maxPos.z) ||
				(_maxPos.z <= box.minPos.z) ||
				(_minPos.y >= box.maxPos.y) ||
				(_maxPos.y <= box.minPos.y) ||
				(_minPos.x >= box.maxPos.x) ||
				(_maxPos.x <= box.minPos.x) ) ? false : true;
		}
		
		public function isPointInside(pos:Vector3D):Boolean {
			return ((pos.x >= _minPos.x) && 
				    (pos.x <= _maxPos.x) && 
				    (pos.y >= _minPos.y) && 
				    (pos.y <= _maxPos.y) && 
				    (pos.z >= _minPos.z) && 
				    (pos.z <= _maxPos.z));
		}
	}
}