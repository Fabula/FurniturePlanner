package vo
{	
	[RemoteClass(alias='vo.FurnitureProductVO')]
	[Bindable]
	public class FurnitureProductVO
	{
		public var id:int; 
		public var manufacturer_name:String;
		public var manufacturer_country:String;
		public var style_name:String;
		public var furniture_category_name:String;
		public var price:Number;
		public var model:FurnitureModelVO;
		public var description:String;
	}
}