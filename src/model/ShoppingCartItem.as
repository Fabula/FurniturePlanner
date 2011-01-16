package model
{
	import alternativa.engine3d.objects.Mesh;

	public class ShoppingCartItem extends FurnitureProduct
	{
		[Bindable]
		public var buy:Boolean = false;
		
		[Bindable]
		public var quantity:int = 1;
		
		public var mesh:Mesh;
		public var isSelect:Boolean;
		
		public function ShoppingCartItem(manufacturerName:String, manufacturerCountry:String, furnitureStyle:String, furnitureCategory:String, price:Number, model:FurnitureModel, description:String, id:int, buy:Boolean = false, quantity:int = 1)
		{
			super(manufacturerName, manufacturerCountry, furnitureStyle, furnitureCategory, price, model, description, id);
			this.buy = buy;
			this.quantity = quantity;
		}
		
		public static function toShoppingCartItem(pr:FurnitureProduct):ShoppingCartItem{
			var shoppingCartItem:ShoppingCartItem = new ShoppingCartItem(pr.manufacturerName, pr.manufacturerCountry,
													   pr.furnitureStyle, pr.furnitureCategory, pr.price, pr.furnitureModel, pr.description, pr.furnitureProductID);
			return shoppingCartItem;
		}
	}
}