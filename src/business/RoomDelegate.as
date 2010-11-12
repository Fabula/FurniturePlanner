package business
{
	import business.Room3D;
	
	[Bindable]
	public class RoomDelegate
	{		
		[MessageDispatcher]
		public var sendRoomToView:Function;
		
		public function createRoom(width:int, height:int, length:int):void{
			sendRoomToView(new Room3D(width, height, length));
		}
	}
}