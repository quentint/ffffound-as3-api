package net.tw.web.ffffound {
	import com.adobe.xml.syndication.generic.RSS20Item;
	import com.adobe.xml.syndication.rss.Item20;
	
	import flash.events.Event;
	import flash.net.*;
	/**
	 * Dispatched when the Item's suggestions have been loaded
	 */
	[Event(name="itemSuggestions", type="net.tw.web.ffffound.FFFFoundEvent")]
	/**
	 * Dispatched when the Item's Users have been loaded
	 */
	[Event(name="itemUsers", type="net.tw.web.ffffound.FFFFoundEvent")]
	/**
	 * Dispatched when the Item's source URL has been loaded
	 */
	[Event(name="itemSourceURL", type="net.tw.web.ffffound.FFFFoundEvent")]
	/**
	 * Dispatched when the Item's source referer has been loaded
	 */
	[Event(name="itemSourceReferer", type="net.tw.web.ffffound.FFFFoundEvent")]
	/**
	 * Dispatched when the Item's media content URL has been loaded
	 */
	[Event(name="itemMediaContentURL", type="net.tw.web.ffffound.FFFFoundEvent")]
	/**
	 * Dispatched when the Item's media thumbnail URL has been loaded
	 */
	[Event(name="itemMediaThumbnailURL", type="net.tw.web.ffffound.FFFFoundEvent")]
	/**
	 * Dispatched when the Item's title has been loaded
	 */
	[Event(name="itemTitle", type="net.tw.web.ffffound.FFFFoundEvent")]
	/**
	 * Class used to manage FFFFOUND image Items
	 */
	public class Item extends PageObject {
		protected var _id:String;
		protected var _mediaContentURL:String;
		protected var _mediaThumbnailURL:String;
		protected var _sourceURL:String;
		protected var _sourceReferer:String;
		protected var _title:String;
		//
		protected var _suggestions:Array;
		protected var _users:Array;
		protected var _userNames:Array;
		//
		private static var _items:Array;
		//
		public static const MAX_THUMBNAIL_DIMENSION:uint=160;
		public static const MAX_MEDIA_DIMENSION:uint=480;
		//
		private static const mediaNS:Namespace=new Namespace("http://search.yahoo.com/mrss/");
		private static const atomNS:Namespace=new Namespace("http://www.w3.org/2005/Atom");
		private static const ffffoundNS:Namespace=new Namespace("http://ffffound.com/scheme/feed");
		/**
		 * Creates an Item object from an image id, retrieved via a Feed for example
		 * @param id The (Item) image id
		 */
		public function Item(id:String) {
			_id=id;
			_request.url=link;
			_loader.addEventListener(Event.COMPLETE, onLoad);
		}
		override public function toString():String {
			return "[Item id='"+id+"']";
		}
		/**
		 * Utility method to get an Item from an Item20
		 */
		public static function getFromFeedItem(pItem:Item20):Item {
			var rssItem:RSS20Item=new RSS20Item(pItem);
			var xml:XMLList=pItem.xml;
			var item:Item=Item.getFromId(getIdFromURL(rssItem.link));
			item._mediaContentURL=xml.mediaNS::content.@url.toString();
			item._mediaThumbnailURL=xml.mediaNS::thumbnail.@url.toString();
			item._sourceURL=xml.ffffoundNS::source.@url.toString();
			item._sourceReferer=xml.ffffoundNS::source.@referer.toString();
			item._title=rssItem.title;
			return item;
		}
		/**
		 * Utility method to get an Item from an id
		 */
		public static function getFromId(id:String):Item {
			if (!_items) _items=[];
			if (_items[id]) return _items[id];
			_items[id]=new Item(id);
			return _items[id];
		}
		/**
		 * Utility method to get an Item from an URL
		 */
		public static function getFromURL(url:String):Item {
			return getFromId(getIdFromURL(url));
		}
		/**
		 * Utility method to get an Item's id from its URL
		 */
		public static function getIdFromURL(url:String):String {
			return (url.split("/").pop() as String).split("?")[0];
		}
		/**
		 * Returns the link (URL) to the Item
		 */
		public function get link():String {
			return "http://ffffound.com/image/"+_id;
		}
		/**
		 * The Item's id
		 */
		public function get id():String  {
			return _id;
		}
		protected function onLoad(e:Event):void {
			var s:String=_loader.data as String;
			s=fixTags(s);
			var start:Number=s.indexOf('<div class="related_to">');
			var xmlStr:String=s.substring(start, s.indexOf('<br clear="all">', start)+25);
			xmlStr=xmlStr.replace('<br clear="all">', '');
			try {
				var xml:XML=new XML(xmlStr);
			} catch (er:Error) {
				trace(er);
				return;
			}
			var suggs:XMLList=xml..a.@href;
			_suggestions=[];
			for (var i:Number=0; i<suggs.length(); i++) {
				_suggestions.push(Item.getFromId(suggs[i].toString().split("/")[2]));
			}
			//
			xmlStr=getBetween(s, '<div class="saved_by">', '</div>');
			xml=new XML(xmlStr);
			var users:XMLList=xml..a.text();
			_users=[];
			_userNames=[];
			for (i=0; i<users.length(); i++) {
				_users.push(User.getFromName(users[i].toString()));
				_userNames.push(users[i].toString());
			}
			//
			xmlStr=getBetween(s, '<a id="asseti'+_id+'-link-img', '</a>');
			xml=new XML(xmlStr);
			_sourceURL=xml.@href.toString();
			//
			_mediaContentURL=xml.img.@src.toString();
			_mediaThumbnailURL=_mediaContentURL.replace("img.", "img-thumb.").replace("_m.", "_s.");
			//
			xmlStr=getBetween(s, '<a id="asseti'+_id+'-link', '</a>');
			xml=new XML(xmlStr);
			_sourceReferer=xml.@href.toString();
			//
			_title=xml.text().toString();
		}
		/**
		 * Load the Item's suggestions (Items)
		 */
		public function loadSuggestions():void {
			tryData(_suggestions, FFFFoundEvent.ITEM_SUGGESTIONS);
		}
		/**
		 * Get the Item's loaded suggestions (Items)
		 */
		public function get suggestions():Array {
			return _suggestions;
		}
		/**
		 * Load the Item's Users (those who found this Item)
		 */
		public function loadUsers():void {
			tryData(_users, FFFFoundEvent.ITEM_USERS);
		}
		/**
		 * Get the loaded Users
		 */
		public function get users():Array {
			return _users;
		}
		/**
		 * Get the loaded Users names (strings)
		 */
		public function get userNames():Array {
			return _userNames;
		}
		/**
		 * Load the Item's source URL
		 */
		public function loadSourceURL():void {
			tryData(_sourceURL, FFFFoundEvent.ITEM_SOURCE_URL);
		}
		/**
		 * Get the loaded Item's source URL
		 */
		public function get sourceURL():String {
			return _sourceURL;
		}
		/**
		 * Load the Item's source referer
		 */
		public function loadSourceReferer():void {
			tryData(_sourceReferer, FFFFoundEvent.ITEM_SOURCE_REFERER);
		}
		/**
		 * Get the loaded Item's source referer
		 */
		public function get sourceReferer():String {
			return _sourceReferer;
		}
		/**
		 * Load the Item's media content URL
		 */
		public function loadMediaContentURL():void {
			tryData(_mediaContentURL, FFFFoundEvent.ITEM_MEDIA_CONTENT_URL);
		}
		/**
		 * Get the loaded Item's media content URL
		 */
		public function get mediaContentURL():String {
			return _mediaContentURL;
		}
		/**
		 * Load the Item's media thumbnail URL
		 */
		public function loadMediaThumbnailURL():void {
			tryData(_mediaThumbnailURL, FFFFoundEvent.ITEM_MEDIA_THUMBNAIL_URL);
		}
		/**
		 * Get the loaded Item's media thumbnail URL
		 */
		public function get mediaThumbnailURL():String {
			return _mediaThumbnailURL;
		}
		/**
		 * Load the Item's title
		 */
		public function loadTitle():void {
			tryData(_title, FFFFoundEvent.ITEM_TITLE);
		}
		/**
		 * Get the loaded Item's title
		 */
		public function get title():String {
			return _title;
		}
	}
}