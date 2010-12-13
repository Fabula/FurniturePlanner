package model
{
	public class BasketItem extends FurnitureProduct
	{
		[Bindable]
		public var buy:Boolean = false;
		
		[Bindable]
		public var quantity:int = 1;
		
		public function BasketItem(manufacturerName:String, manufacturerCountry:String, furnitureStyle:String, furnitureCategory:String, price:Number, model:FurnitureModel, description:String, id:int, buy:Boolean = false, quantity:int = 1)
		{
			super(manufacturerName, manufacturerCountry, furnitureStyle, furnitureCategory, price, model, description, id);
			this.buy = buy;
			this.quantity = quantity;
		}
		
		public static function toBasketItem(pr:FurnitureProduct):BasketItem{
			var basketItem:BasketItem = new BasketItem(pr.manufacturerName, pr.manufacturerCountry,
													   pr.furnitureStyle, pr.furnitureCategory, pr.price, pr.furnitureModel, pr.description, pr.furnitureProductID);
			return basketItem;
		}
	}
}