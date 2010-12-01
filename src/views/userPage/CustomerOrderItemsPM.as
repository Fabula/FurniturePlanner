package views.userPage
{
	import model.BasketItem;
	import model.PlannerModelLocator;

	[Bindable]
	public class CustomerOrderItemsPM
	{
		
		public var totalPrice:int = 0;
		
		public function handleCheckBoxSelect():void{
			calculateTotalPrice();
		}
		
		private function calculateTotalPrice():void{
			var mainAppModel:PlannerModelLocator = PlannerModelLocator.getInstance();
			totalPrice = 0;
			for each (var item:BasketItem in mainAppModel.customerBasket){
				if (item.buy){
					totalPrice += item.price;
				}
			}			
		}
	}
}