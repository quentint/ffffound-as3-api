package net.tw.web.ffffound {
	import com.adobe.xml.syndication.rss.RSS20;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * Dispatched when the feed has been loaded
	 */
	[Event(name="loaderFeed", type="net.tw.web.ffffound.FFFFoundEvent")] 
	/**
	 * FeedLoader extends URLLoader to add it FFFFOUND specific methods
	 * Use it to load a user's feed
	 */
	public class FeedLoader extends URLLoader {
		protected var _feed:Feed;
		protected var _userName:String;
		protected var _type:String;
		protected var _offset:int;
		/**
		 * Use it to target a user's post feed
		 */
		public static const FEED_TYPE_POST:String="post";
		/**
		 * Use it to target a user's found feed
		 */
		public static const FEED_TYPE_FOUND:String="found";
		/**
		 * Current FFFOUND items per page setting
		 */
		public static const ITEMS_PER_PAGE:int=25;
		/**
		 * @param userName The user for which you want the feed's name
		 * @param type Either FEED_TYPE_POST or FEED_TYPE_FOUND
		 * @param offset Use this param to get offseted results
		 */
		public function FeedLoader(userName:String, type:String=null, offset:uint=0) {
			_userName=userName;
			_type=type;
			_offset=offset;
			addEventListener(Event.COMPLETE, onComplete);
			//
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, onE);
			addEventListener(IOErrorEvent.IO_ERROR, onE);
			//addEventListener(HTTPStatusEvent.HTTP_STATUS, onE);
			//addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onE);
		}
		/**
		 * Change the feed's type
		 * Use either FEED_TYPE_POST or FEED_TYPE_FOUND
		 */
		public function set type(s:String):void {
			_type=s;
		}
		/**
		 * This will load the next page based on the current offset and the items per page
		 */
		public function loadNextPage():void {
			//if (_userName==User.EVERYONE) return; 
			_offset+=ITEMS_PER_PAGE;
			loadFeed();
		}
		/**
		 * Set the offset to 0 and reloads the feed
		 */
		public function rewind():void {
			_offset=0;
			loadFeed();
		}
		private function onE(e:Event):void {
			trace(e);
		}
		protected function onComplete(e:Event):void {
			var feedXML:XML = XML(data);
			var rss20:RSS20 = new RSS20();
			rss20.populate(feedXML);
			_feed=new Feed(rss20);
			//
			dispatchEvent(new FFFFoundEvent(FFFFoundEvent.LOADER_FEED));
		}
		/**
		 * Once the FeedLoader created you have to call loadFeed
		 */
		public function loadFeed():void {
			load(new URLRequest(getURL(_userName, _type, _offset)));
		}
		/**
		 * Gets the Feed object
		 */
		public function get feed():Feed {
			return _feed;
		}
		/**
		 * Utility method to get a user feed URL
		 * See constructor for params
		 */
		public static function getURL(userName:String, type:String=null, offset:int=0):String {
			//if (userName==User.EVERYONE) return "http://feeds.feedburner.com/ffffound/everyone";
			if (userName==User.EVERYONE) return "http://ffffound.com/feed?offset="+offset;
			if (type==null) type=FEED_TYPE_FOUND; 
			return "http://ffffound.com/home/"+userName+"/"+type+"/feed?offset="+offset;
		}
	}
}