package vo
{	
	[RemoteClass(alias='vo.FurnitureModelVO')]
	[Bindable]
	public class FurnitureModelVO
	{
		[Transient]
		public var furniture_product_id:int;
		
		[Transient]
		public var id:int;
		
		public var model:String;
		//public var texture:ByteArray;
		public var height:Number;
		public var width:Number;
		public var length:Number;
	}
}