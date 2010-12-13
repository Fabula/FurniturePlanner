package command
{
	import business.FileModelDelegate;
	
	import flash.events.Event;
	import flash.net.FileReference;
	
	import messages.FileLoadedMessage;
	import messages.GetFileMessage;
	
	import model.PlannerModelLocator;
	
	import mx.controls.Alert;
	import mx.utils.Base64Encoder;

	public class BrowseFileCommand
	{
		
		[MessageDispatcher]
		public var dispatcher:Function;
		
		public function execute(message:GetFileMessage):void{
			var delegate:FileModelDelegate = new FileModelDelegate(this);
			delegate.getFileOfModel();
		}
		
		public function onCompleteLoadModelFile(event:Event):void{
			/*_model.currentProductFile = event.target as FileReference;*/
			dispatcher(new FileLoadedMessage(event.target as FileReference));
			// отправить событие - файл загружен с ссылкой на файл, которое получит popUp окно
			
			/*var encoder:Base64Encoder = new Base64Encoder();
			encoder.encodeBytes(event.target.data);
			_model.base64ProductFileString = encoder.toString();*/
			Alert.show("Файл успешно загружен!");
		}
	}
}