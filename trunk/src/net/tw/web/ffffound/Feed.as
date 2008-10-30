package net.tw.web.ffffound {
	import com.adobe.xml.syndication.generic.RSS20Feed;
	import com.adobe.xml.syndication.rss.Item20;
	import com.adobe.xml.syndication.rss.RSS20;
	//
	/**
	 * This class extends RSS20Feed to make its items FFFFOUND ones.
	 */
	public class Feed extends RSS20Feed {
		private var _items:Array;
		private var _rss20:RSS20;
		public function Feed(rss20:RSS20) {
			super(rss20);
			_rss20=rss20;
			_items=[];
			for each (var item:Item20 in _rss20.items) {
				_items.push(Item.getFromFeedItem(item));
			}
		}
		override public function get items():Array {
			return _items;
		}
	}
}