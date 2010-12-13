package model
{
	import flash.utils.ByteArray;

	[Bindable]
	public class FurnitureModel
	{
		public var furnitureModelID:Number;
		public var furnitureModel:ByteArray;
		public var texture:ByteArray;
		public var height:Number;
		public var width:Number;
		public var length:Number;
		
		public function FurnitureModel(furnitureModel:ByteArray, height:Number = 0, width:Number = 0, length:Number = 0)
		{
			this.furnitureModel = furnitureModel;
			this.height = height;
			this.width = width;
			this.length = length;
		}
	}
}