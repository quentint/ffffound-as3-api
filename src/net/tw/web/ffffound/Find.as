package net.tw.web.ffffound {
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * Dispatched when the image has been posted
	 */
	[Event(name="added", type="flash.events.Event")]
	/**
	 * Dispatched when the image posting has failed
	 */
	[Event(name="cancel", type="flash.events.Event")] 
	/**
	 * Find extends URLLoader to add it specific methods
	 * Use it to post an image to a User account
	 */
	public class Find extends URLLoader {
		private var _url:String;
		private var _referer:String;
		private var _title:String;
		private var _alt:String;
		//
		private var _tokenLoader:URLLoader;
		private var _token:String;
		//
		private var _request:URLRequest;
		/**
		 * @param url The URL of the image to post.
		 * @param referer The URL of the refering page for the image. If not specified, the URL of the image will be used.
		 * @param title The title for the image. If not specified, the filename of the image will be used.
		 * @param alt The image's alternate text. If not specified, the filename of the image will be used.
		 */
		public function Find(url:String, referer:String=null, title:String=null, alt:String=null) {
			_url=url;
			_referer=referer;
			_title=title;
			_alt=alt;
			//
			addEventListener(Event.COMPLETE, onComplete);
			//
			_tokenLoader=new URLLoader();
			_tokenLoader.addEventListener(Event.COMPLETE, onToken);
			_tokenLoader.load(new URLRequest("http://ffffound.com/bookmarklet.js"));
		}
		private function onToken(e:Event):void {
			var tokenLoaderData:String=_tokenLoader.data as String;
			_token=tokenLoaderData.substr(tokenLoaderData.indexOf("token=")+7, 108);
			dispatchEvent(new Event('token'));
			//
			if (_referer==null) _referer=_url;
			if (_title==null) _title=_url.substr(_url.lastIndexOf('/')+1);
			if (_alt==null) _alt=_title; 
			var params:Object={
				'token':_token,
				'url':_url,
				'referer':_referer,
				'title':_title,
				'alt':_alt
			};
			var urlb:Array=[];
			urlb.push("http://ffffound.com/add_asset");
			urlb.push('?');
			for(var n:String in params){
				urlb.push(encodeURIComponent(n));
				urlb.push('=');
				urlb.push(encodeURIComponent(params[n]));
				urlb.push('&')
			}
			_request=new URLRequest(urlb.join(""));
			load(_request);
		}
		protected function onComplete(e:Event):void {
			if ((data as String).toLowerCase().indexOf('added!')!=-1) {
				dispatchEvent(new Event(Event.ADDED));
			} else {
				dispatchEvent(new Event(Event.CANCEL));
			}
		}
	}
}