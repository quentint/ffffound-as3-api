package net.tw.web.ffffound {
	import flash.events.Event;
	/**
	 * Class for handling FFFFOUND specific Events
	 */
	public class FFFFoundEvent extends Event {
		/**
		 * Dispatched when a User's favorites have been loaded
		 */
		public static const USER_FAVORITES:String="userFavorites";
		/**
		 * Dispatched when a User's followers have been loaded
		 */
		public static const USER_FOLLOWERS:String="userFollowers";
		/**
		 * Dispatched when a FeedLoader's feed has been loaded
		 */
		public static const LOADER_FEED:String="loaderFeed";
		/**
		 * Dispatched when an Item's suggestions have been loaded
		 */
		public static const ITEM_SUGGESTIONS:String="itemSuggestions";
		/**
		 * Dispatched when an Item's Users have been loaded
		 */
		public static const ITEM_USERS:String="itemUsers";
		/**
		 * Dispatched when an Item's source URL has been loaded
		 */
		public static const ITEM_SOURCE_URL:String="itemSourceURL";
		/**
		 * Dispatched when an Item's source referer has been loaded
		 */
		public static const ITEM_SOURCE_REFERER:String="itemSourceReferer";
		/**
		 * Dispatched when an Item's media content URL has been loaded
		 */
		public static const ITEM_MEDIA_CONTENT_URL:String="itemMediaContentURL";
		/**
		 * Dispatched when an Item's media thumbnail URL has been loaded
		 */
		public static const ITEM_MEDIA_THUMBNAIL_URL:String="itemMediaThumbnailURL";
		/**
		 * Dispatched when an Item's title has been loaded
		 */
		public static const ITEM_TITLE:String="itemTitle";
		/**
		 * Dispatched when a Session has been signed in
		 */
		public static const SESSION_SIGN_IN:String="sessionSignIn";
		/**
		 * Dispatched when a Session has been signed out
		 */
		public static const SESSION_SIGN_OUT:String="sessionSignOut";
		/**
		 * Dispatched when a Heart has been successfully sent
		 */
		public static const HEART_SUCCESS:String="heartSuccess";
		/**
		 * Dispatched when a Heart already exists
		 */
		public static const HEART_EXISTS:String="heartExists";
		/**
		 * Dispatched when a Heart has failed
		 */
		public static const HEART_ERROR:String="heartError";
		/**
		 * Used to store various things
		 */
		public var data:Object;
		public function FFFFoundEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}