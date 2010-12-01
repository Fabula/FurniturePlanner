package business
{	
	import command.BrowseFileCommand;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	
	import mx.rpc.IResponder;
	import mx.utils.Base64Encoder;

	public class FileModelDelegate
	{
		private var localStore:FileReference;
		private var _furnitureModel:FileReference;
		private var _command:BrowseFileCommand;
		
		public function FileModelDelegate(command:BrowseFileCommand){
			_command = command;
		}
		
		public function getFileOfModel():void{
			localStore = new FileReference();
			localStore.browse(getTypes());
			configureListeners(localStore);
		}
		
		private function getTypes():Array {
			var modelsTypes:Array = new Array(get3DModelsTypeFilter());
			return modelsTypes;
		}
		
		private function get3DModelsTypeFilter():FileFilter {
			return new FileFilter("3DS models (*.3ds)", "*.3ds");
		}
		
		private function configureListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.SELECT, selectHandler);
		}
		
		private function selectHandler(event:Event):void{
			_furnitureModel = FileReference(event.target);
			_furnitureModel.load();
			_furnitureModel.addEventListener(Event.COMPLETE, _command.onCompleteLoadModelFile);
		}
	}
}