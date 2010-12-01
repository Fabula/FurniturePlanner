package messages
{
	public class CreateRoomMessage
	{
		public var roomWidth:Number;
		public var roomLength:Number;
		public var roomHeight:Number;
		
		public function CreateRoomMessage(roomWidth:Number, roomLength:Number, roomHeight:Number)
		{
			this.roomWidth = roomWidth;
			this.roomLength = roomLength;
			this.roomHeight = roomHeight;
		}
	}
}