package net.tw.web.ffffound {
	import com.adobe.serialization.json.JSON;
	import flash.events.Event;
	import flash.net.*;
	/**
	 * Dispatched when the User already marked the Item as found
	 */
	[Event(name="heartExists", type="net.tw.web.ffffound.FFFFoundEvent")]
	/**
	 * Dispatched when sending the Heart has failed
	 */
	[Event(name="heartError", type="net.tw.web.ffffound.FFFFoundEvent")]
	/**
	 * Dispatched when the Heart has sent successfully
	 */
	[Event(name="heartSuccess", type="net.tw.web.ffffound.FFFFoundEvent")]
	/**
	 * This class extends URLLoader to handle "heart sending": I (heart) THIS!
	 */
	public class Heart extends URLLoader {
		protected var _id:String;
		protected var _request:URLRequest;
		/**
		 * Mark an image as "found"
		 * @param id The id of the Item to mark as found
		 */
		public function Heart(id:String) {
			_id=id;
			addEventListener(Event.COMPLETE, onComplete);
			_request=new URLRequest("http://ffffound.com/gateway/in/api/add_asset");
			_request.method=URLRequestMethod.POST;
			var vars:URLVariables=new URLVariables();
			vars.collection_id='i'+id;
			vars.inappropriate=false;
			_request.data=vars;
			load(_request);
		}
		private function onComplete(e:Event):void {
			data=JSON.decode(data);
			if (error=="EXISTS") dispatchEvent(new FFFFoundEvent(FFFFoundEvent.HEART_EXISTS));
			else if (!success) dispatchEvent(new FFFFoundEvent(FFFFoundEvent.HEART_ERROR));
			else dispatchEvent(new FFFFoundEvent(FFFFoundEvent.HEART_SUCCESS));
		}
		/**
		 * Get details about the last error
		 */
		public function get error():String {
			return data.error;
		}
		/**
		 * Know if the Heart has been added, or if it already existed
		 */
		public function get added():Boolean {
			return data.added;
		}
		/**
		 * Know if the Heart has been posted successfully
		 */
		public function get success():Boolean {
			return data.success;
		}
	}
}