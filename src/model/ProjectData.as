package model
{
	public class ProjectData
	{
		public var roomWidth:Number;
		public var roomLength:Number;
		public var roomHeight:Number;
		public var productsPositions:Array;
		
		public function ProjectData(width:Number, length:Number, height:Number, productsPositions:Array)
		{
			roomWidth = width;
			roomLength = length;
			roomHeight = height;
			productsPositions = productsPositions;
		}
	}
}