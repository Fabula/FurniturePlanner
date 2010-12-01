package command
{
	import business.FileModelDelegate;
	import messages.GetFileMessage;
	import model.PlannerModelLocator;
	import flash.events.Event;
	import flash.net.FileReference;

	import mx.controls.Alert;
	import mx.utils.Base64Encoder;

	public class BrowseFileCommand
	{
		private var _model:PlannerModelLocator = PlannerModelLocator.getInstance();
		
		public function execute(message:GetFileMessage):void{
			var delegate:FileModelDelegate = new FileModelDelegate(this);
			delegate.getFileOfModel();
		}
		
		public function onCompleteLoadModelFile(event:Event):void{
			_model.currentProductFile = event.target as FileReference;
			var encoder:Base64Encoder = new Base64Encoder();
			encoder.encodeBytes(event.target.data);
			_model.base64ProductFileString = encoder.toString();
			Alert.show("Файл успешно загружен!");
		}
	}
}