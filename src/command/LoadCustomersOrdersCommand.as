package command
{
	import business.OrderDelegate;
	
	import errorMessages.ErrorMessageCenter;
	
	import messages.GetAllOrdersMessage;
	
	import model.Order;
	import model.PlannerModelLocator;
	import model.User;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;
	
	import vo.UserVO;

	public class LoadCustomersOrdersCommand implements IResponder
	{
		private var mainAppModel:PlannerModelLocator = PlannerModelLocator.getInstance();
		
		public function execute(message:GetAllOrdersMessage):void{
			var delegate:OrderDelegate = new OrderDelegate(this);
			delegate.loadCustomersOrders();
		}
		
		public function result(event:Object):void{
			var resultEvent:ResultEvent = ResultEvent(event);
			var customers:Array = resultEvent.result as Array;

			mainAppModel.customersWithOrders= new Array();
			
			for each(var userVO:UserVO in customers){
				mainAppModel.customersWithOrders.push(User.fromVO(userVO));
			}
			
			// извлекли информацию о покупателях
			mainAppModel.customers = new Array();
			mainAppModel.customersOrders = new Array();
			
			for each (var customer:User in mainAppModel.customersWithOrders){
				var customerDetails:User = new User(customer.name, customer.lastName, customer.telephoneNumber, customer.telephoneNumber);
				customerDetails.id = customer.id;
				mainAppModel.customers.push(customerDetails);
				for each (var order:Order in customer.orders){
					mainAppModel.customersOrders.push(order);
				}
			}
		}
		
		public function fault(event:Object):void{
			Alert.show(ErrorMessageCenter.networkError, ErrorMessageCenter.errorMessageTitle);
		}
	}
}