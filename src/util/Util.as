package util
{
	import mx.controls.dataGridClasses.DataGridColumn;
	
	public class Util
	{
		public static function convertDate(item:Object, column:DataGridColumn):String{
			return item.orderCreatedDate.date + "/" + (item.orderCreatedDate.month + 1) + "/" + item.orderCreatedDate.fullYear + " " + item.orderCreatedDate.hours + ":" + item.orderCreatedDate.minutes;
		}
	}
}