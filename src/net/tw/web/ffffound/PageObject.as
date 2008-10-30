package net.tw.web.ffffound {
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.*;
	/**
	 * Abstract class to handle objects for which content has to be loaded from a web page
	 */
	public class PageObject extends EventDispatcher {
		protected var _request:URLRequest;
		protected var _loader:URLLoader;
		//
		public function PageObject(target:IEventDispatcher=null) {
			super(target);
			_request=new URLRequest();
			_loader=new URLLoader();
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
		}
		private function onError(e:Event):void {
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
		}
		protected function tryData(o:*, eventType:String):void {
			if (!o) {
				_loader.addEventListener(Event.COMPLETE, function(e:Event):void {
					dispatchEvent(new FFFFoundEvent(eventType));
				});
				_loader.load(_request);
			}
			else {
				dispatchEvent(new FFFFoundEvent(eventType));
			}
		}
		/**
		 * Utility method to get a section between two strings in a large string
		 */
		public static function getBetween(s:String, begin:String, end:String, lastOccurence:Boolean=false):String {
			var start:int=lastOccurence ? s.lastIndexOf(begin) : s.indexOf(begin);
			if (start==-1) return s;
			return s.substring(start, s.indexOf(end, start)+end.length);
		}
		/**
		 * Utility method to fix unvalid HTML tags
		 */
		public static function fixTags(s:String):String {
			s=s.replace(/(<img(.*?))>/g, "$1/>");
			s=s.replace("<br>", "<br />");
			return s;
		}
		/**
		 * Utility method to extract a directory name from an URL
		 * @param url The URL from which to extract a directory name
		 * @param index The index of the directory name to extract
		 */
		public static function extractDirName(url:String, index:uint):String {
			// http://test.com/abc/def/
			return url.split("/")[index+3];
		}
	}
}