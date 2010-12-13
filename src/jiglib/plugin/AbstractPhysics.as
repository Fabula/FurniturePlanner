package jiglib.plugin {
	import flash.utils.getTimer;
	
	import jiglib.physics.PhysicsSystem;
	import jiglib.physics.RigidBody;

	/**
	 * @author bartekd and Ringo
	 */
	public class AbstractPhysics {
		
		private var initTime:int;
		private var stepTime:int;
		private var speed:Number;
		private var deltaTime:Number = 0;
		private var physicsSystem:PhysicsSystem;
		
		public function AbstractPhysics(speed:Number = 5) {
			this.speed = speed;
			initTime = getTimer();
			physicsSystem = PhysicsSystem.getInstance();
		}
		
		public function addBody(body:RigidBody):void {
			physicsSystem.addBody(body as RigidBody);
		}
		
		public function removeBody(body:RigidBody):void {
			physicsSystem.removeBody(body as RigidBody);
		}
		
		public function get engine():PhysicsSystem {
			return physicsSystem ;
		}

		public function afterPause():void {
			initTime = getTimer();
		}

		public function step():void {
			stepTime = getTimer();
	        deltaTime = ((stepTime - initTime) / 1000) * speed;
	        initTime = stepTime;
	        physicsSystem.integrate(deltaTime);
		}
	}
}
