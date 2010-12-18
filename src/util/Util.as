package util
{
	import mx.controls.dataGridClasses.DataGridColumn;
	
	public class Util
	{
		public static function convertDate(item:Object, column:DataGridColumn):String{
			return item.created_at.date + "/" + item.created_at.month + "/" + item.created_at.fullYear + " " + item.created_at.hours + ":" + item.created_at.minutes;
		}
	}
}