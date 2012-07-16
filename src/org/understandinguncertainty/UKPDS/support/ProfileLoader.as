package org.understandinguncertainty.UKPDS.support
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class ProfileLoader
	{
		public var path:String = "";
		public var loader:URLLoader;
		public var completeHandler:Function;
		public var ioErrorHandler:Function;
				
		public function ProfileLoader()
		{
		}
		
		public function load(path:String,
							 completeHandler:Function = null):void {
		
			if(this.path != path || this.completeHandler != completeHandler || loader == null) {
				loader = new URLLoader();
				this.path = path;
				removeAllListeners();
				addAllListeners(completeHandler);
				loader.load(new URLRequest(path));
			}
		}
		
		public function xmlData(event:Event):XML {
			var loader:URLLoader = event.target as URLLoader;
			var filedata:XML = new XML(loader.data);
			return filedata;
		}
		
		private function addAllListeners(completeHandler:Function):void
		{
			
			this.completeHandler = completeHandler;
			if(completeHandler != null)
			{
				loader.addEventListener(Event.COMPLETE, completeHandler);
				loader.addEventListener(IOErrorEvent.IO_ERROR, completeHandler);
			}
			
		}		

		private function removeAllListeners():void
		{
			
			if(completeHandler != null)
			{
				loader.removeEventListener(Event.COMPLETE, completeHandler);
				loader.removeEventListener(IOErrorEvent.IO_ERROR, completeHandler);
				completeHandler = null;
			}
		}			
	}
}