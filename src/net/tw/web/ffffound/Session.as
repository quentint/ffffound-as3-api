package net.tw.web.ffffound {
	import com.adobe.serialization.json.*;
	import flash.events.*;
	import flash.net.*;
	/**
	 * Dispatched when the Session has been opened
	 */
	[Event(name="sessionSignIn", type="net.tw.web.ffffound.FFFFoundEvent")]
	/**
	 * Dispatched when the Session has been closed
	 */
	[Event(name="sessionSignOut", type="net.tw.web.ffffound.FFFFoundEvent")]
	/**
	 * This class extends URLLoader to add it specific methods
	 * Use it to log a user in and out, to send hearts and to post images.
	 */
	public class Session extends URLLoader {
		protected var _userName:String;
		protected var _pass:String;
		protected var _lastRequest:URLRequest;
		//
		public static const LOGIN_URL:String="http://ffffound.com/gateway/in/api/login";
		public static const LOGOUT_URL:String="http://ffffound.com/gateway/in/api/logout";
		/**
		 * Parameters should be self-explanatory
		 */
		public function Session(userName:String, pass:String) {
			_userName=userName;
			_pass=pass;
			addEventListener(Event.COMPLETE, onLog);
		}
		/**
		 * Attemps to sign the user in
		 */
		public function signIn():void {
			var logRequest:URLRequest=new URLRequest(LOGIN_URL);
			_lastRequest=logRequest;
			logRequest.method=URLRequestMethod.POST;
			var vars:URLVariables=new URLVariables();
			vars.hostname=_userName;
			vars.password=_pass;
			logRequest.data=vars;
			load(logRequest);
		}
		/**
		 * Attemps to sign the user out
		 */
		public function signOut():void {
			var logRequest:URLRequest=new URLRequest(LOGOUT_URL);
			_lastRequest=logRequest;
			logRequest.method=URLRequestMethod.POST;
			load(logRequest);
		}
		protected function onLog(e:Event):void {
			// UGLY!
			if (_lastRequest.url==LOGIN_URL) {
				data=JSON.decode(data);
				dispatchEvent(new FFFFoundEvent(FFFFoundEvent.SESSION_SIGN_IN));
			} else {
				dispatchEvent(new FFFFoundEvent(FFFFoundEvent.SESSION_SIGN_OUT));
			}
		}
		public function get displayName():String {
			return data.display_name;
		}
		public function get email():String {
			return data.email;
		}
		public function get error():String {
			return data.error;
		}
		public function get hostname():String {
			return data.hostname;
		}
		public function get success():Boolean {
			return data.success;
		}
		public function get token():String {
			return data.token;
		}
		public function get url():String {
			return data.url;
		}
		public function get user_id():String {
			return data.user_id;
		}
		/**
		 * Use it as a shortcut to post images
		 */
		public function findImage(url:String):Find {
			return new Find(url);
		}
		/**
		 * Use it as a shortcut to heart images
		 */
		public function heartImage(id:String):Heart {
			return new Heart(id);
		}
		public function get userName():String {
			return _userName;
		}
		public function get password():String {
			return _pass;
		}
		public function get user():User {
			return new User(userName);
		}
	}
}