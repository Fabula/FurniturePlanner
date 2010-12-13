package messages
{
	import flash.net.FileReference;

	public class FileLoadedMessage
	{
		public var file:FileReference;
		
		public function FileLoadedMessage(file:FileReference)
		{
			this.file = file;
		}
	}
}