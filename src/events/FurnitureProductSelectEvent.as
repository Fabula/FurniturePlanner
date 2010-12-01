package events
{
	import flash.events.Event;
	
	import model.FurnitureProduct;

	public class FurnitureProductSelectEvent extends Event
	{
		public static const FURNITURE_PRODUCT_SELECTED:String = "furnitureProductSelected";
		public var furnitureProduct:FurnitureProduct;
		
		public function FurnitureProductSelectEvent(type:String, bubbles:Boolean, furnitureProduct:FurnitureProduct)
		{
			super(type, bubbles);
			this.furnitureProduct = furnitureProduct;
		}
	}
}