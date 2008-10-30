package net.tw.web.ffffound {
	import flash.events.*;
	import flash.net.*;
	/**
	 * Dispatched when the User's favorites have been loaded
	 */
	[Event(name="userFavorites", type="net.tw.web.ffffound.FFFFoundEvent")]
	/**
	 * Dispatched when the User's followers have been loaded
	 */
	[Event(name="userFollowers", type="net.tw.web.ffffound.FFFFoundEvent")]
	/**
	 * Class to manage FFFFOUND User items
	 */
	public class User extends PageObject {
		private static var _users:Array;
		//
		private var _name:String;
		private var _xml:XML;
		//
		private var _favorites:Array;
		private var _favoriteNames:Array;
		private var _followers:Array;
		private var _followerNames:Array;
		//
		public static const EVERYONE:String="everyone";
		/**
		 * Creates a User object from a user name
		 */
		public function User(n:String) {
			_name=n;
			_request.url=url;
			_loader.addEventListener(Event.COMPLETE, onLoad);
		}
		override public function toString():String {
			return "[User name='"+name+"']";
		}
		/**
		 * Allows you to know if the current User is the abstract "everyone" User
		 */
		public function isEveryone():Boolean {
			return name==EVERYONE;
		}
		/**
		 * Utility method to get a User from his name
		 */
		public static function getFromName(s:String):User {
			if (!_users) _users=[];
			// Fix, because user "shift" broke the logic!
			var arrayKey:String="user-"+s;
			if (_users[arrayKey]) return _users[arrayKey];
			_users[arrayKey]=new User(s);
			return _users[arrayKey];
		}
		/**
		 * Utility method to get a User from his public page URL
		 */
		public static function getFromURL(url:String):User {
			return getFromName(extractDirName(url, 2));
		}
		/**
		 * Utility method to get a User's public page URL from his name
		 */
		public static function getURL(name:String):String {
			if (name==EVERYONE) return "http://ffffound.com/";
			return "http://ffffound.com/home/"+name+"/";
		}
		private function onLoad(e:Event):void {
			_favorites=[];
			_favoriteNames=[];
			_followers=[];
			_followerNames=[];
			//
			if (isEveryone()) return;
			//
			var s:String=_loader.data as String;
			var xmlStr:String=getBetween(s, '<ul class="user_activity">', '</ul>');
			var xml:XML=new XML(xmlStr);
			var favs:XMLList=xml..li.a.text();
			for (var i:Number=0; i<favs.length(); i++) {
				_favoriteNames.push(favs[i].toString());
				_favorites.push(User.getFromName(favs[i].toString()));
			}
			//
			xmlStr=getBetween(s, '<ul class="user_activity">', '</ul>', true);
			xml=new XML(xmlStr);
			var fols:XMLList=xml..li.a.text();
			for (i=0; i<fols.length(); i++) {
				_followerNames.push(fols[i].toString());
				_followers.push(User.getFromName(fols[i].toString()));
			}
		}
		/**
		 * Load the User's favorites (Users)
		 */
		public function loadFavorites():void {
			tryData(_favorites, FFFFoundEvent.USER_FAVORITES);
		}
		/**
		 * Get the User's loaded favorites (Users)
		 */
		public function get favorites():Array {
			return _favorites;
		}
		/**
		 * Get the User's loaded favorites' names (strings)
		 */
		public function get favoriteNames():Array {
			return _favoriteNames;
		}
		/**
		 * Load the User's followers (Users)
		 */
		public function loadFollowers():void {
			tryData(_followers, FFFFoundEvent.USER_FOLLOWERS);
		}
		/**
		 * Get the User's loaded followers (Users)
		 */
		public function get followers():Array {
			return _followers;
		}
		/**
		 * Get the User's loaded followers' names (strings)
		 */
		public function followerNames():Array {
			return _followerNames;
		}
		/**
		 * Get the User's name
		 */
		public function get name():String {
			return _name;
		}
		/**
		 * Get the User's public page URL
		 */
		public function get url():String {
			return getURL(name);
		}
		/**
		 * Get the FeedLoader for this User
		 * See FeedLoader for the parameters
		 */
		public function getFeedLoader(type:String=null, offset:uint=0):FeedLoader {
			return new FeedLoader(name, type, offset);
		}
	}
}