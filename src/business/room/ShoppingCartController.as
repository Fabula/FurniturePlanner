package business.room
{
	import alternativa.engine3d.objects.Mesh;
	
	import model.FurnitureProduct;
	import model.PlannerModelLocator;
	import model.ShoppingCartItem;

	public class ShoppingCartController
	{
		private var shoppingCartItem:ShoppingCartItem;
		private var mainAppModel:PlannerModelLocator = PlannerModelLocator.getInstance();
		
		public function ShoppingCartController(){
			mainAppModel.customerShoppingCart = new Array();
		}
		
		public function placeFurnitureProductToShoppingCart(product:FurnitureProduct, modelMesh:Mesh):void{
			shoppingCartItem = ShoppingCartItem.toShoppingCartItem(product);
			shoppingCartItem.mesh = modelMesh;
			
			var matched:Boolean = false;
			
			for each (var item:ShoppingCartItem in mainAppModel.customerShoppingCart){
				if (item.furnitureProductID == shoppingCartItem.furnitureProductID){
					item.quantity++;
					matched = true;
				}
			}
			
			if (!matched){
				mainAppModel.customerShoppingCart.push(shoppingCartItem);	
				
			}
			
		}
		
		public function removeFurnitureProductFromShoppingCart(modelMesh:Mesh):void{
			
			var index:int = -1;
			
			for each (var item:ShoppingCartItem in mainAppModel.customerShoppingCart ){
				index++;
				
				// ищем объекты, содержащие ссылку на данную полигон. модель
				if (item.modelMesh == modelMesh){
					mainAppModel.customerShoppingCart.slice(index, 1);
				}
			}
			
		}
		
		public function searchProduct(furnitureProductMesh:Mesh):int{
			var productID:int;
			
			for each (var item:ShoppingCartItem in mainAppModel.customerShoppingCart){
				if (item.mesh == furnitureProductMesh){
					productID = item.furnitureProductID;
				}
			}
			
			return productID;
		}
	}
}