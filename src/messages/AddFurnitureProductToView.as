package messages
{
	import model.FurnitureProduct;

	public class AddFurnitureProductToView
	{
		public var product:FurnitureProduct;
		
		public function AddFurnitureProductToView(pr:FurnitureProduct)
		{
			product = pr;
		}
	}
}