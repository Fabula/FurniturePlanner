package business
{
	import business.room.Room3D;
	
	import messages.CreateRoomMessage;
	
	[Bindable]
	public class RoomDelegate
	{		
		[MessageDispatcher]
		public var sendRoomToView:Function;
		
		public function createRoom(width:int, height:int, length:int):void{
			sendRoomToView(new CreateRoomMessage(width, height, length));
		}
	}
}