package messages
{
	import model.FurnitureProduct;

	public class AddFurnitureProductToRoom
	{
		public var product:FurnitureProduct;
		
		public function AddFurnitureProductToRoom(pr:FurnitureProduct)
		{
			product = pr;
		}
	}
}