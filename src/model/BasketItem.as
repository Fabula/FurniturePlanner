package model
{
	public class BasketItem extends FurnitureProduct
	{
		[Bindable]
		public var buy:Boolean = false;
		
		public function BasketItem(manufacturerName:String, manufacturerCountry:String, furnitureStyle:String, furnitureCategory:String, price:Number, model_data:String, buy:Boolean = false)
		{
			super(manufacturerName, manufacturerCountry, furnitureStyle, furnitureCategory, price, model_data);
			this.buy = buy;
		}
		
		public static function toBasketItem(pr:FurnitureProduct):BasketItem{
			var basketItem:BasketItem = new BasketItem(pr.manufacturerName, pr.manufacturerCountry,
													   pr.furnitureStyle, pr.furnitureCategory, pr.price, pr.model_data);
			return basketItem;
		}
	}
}