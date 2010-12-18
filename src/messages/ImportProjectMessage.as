package messages
{
	public class ImportProjectMessage
	{
		public var roomSize:Object;
		public var productsPositions:Array;
		
		public function ImportProjectMessage(roomSize:Object, productsPositions:Array)
		{
			this.roomSize = roomSize;
			this.productsPositions = productsPositions;
		}
	}
}