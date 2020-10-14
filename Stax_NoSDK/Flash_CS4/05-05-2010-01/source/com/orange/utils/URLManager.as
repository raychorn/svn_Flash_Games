//	a wrapper for getURL
//
//	will trace urls to output window in authoring, but actually launch them in a browser
//	also, will put a slight delay between simultaneous getURL calls as a workaround for some browsers
//
//	usage: replace getURL(...) with com.orange.utils.URLManager.doURL(...)
//
//	note: uses com.orange.utils.Debug for trace output
//
import com.orange.utils.Debug;
class com.orange.utils.URLManager
{
	//=========================================
	//doURL: a wrapper for getURL
	//=========================================
	//true if urls are ignored and just traced, this var can be set manually or left alone
	static var IGNORE_URL;
	//array of urls to get, best left alone
	static var _URLS_array:Array = new Array ();
	//interval id for timer, best left alone
	static var _URL_INTERVAL:Number;
	//milliseconds between getURL calls
	static var _URL_DELAY:Number = 10;
	//when running as a local file, don't actually get the url, just trace it
	//also, put in a short delay between URLs to avoid bugs in some browsers
	static function doURL ()
	{
		URLManager._URLS_array.push (arguments);
		if (URLManager._URL_INTERVAL == undefined)
		{
			URLManager._URL_INTERVAL = setInterval (URLManager._checkURLArray, _URL_DELAY);
		}
	}
	static function _checkURLArray ()
	{
		if (URLManager._URLS_array.length > 0)
		{
			var args_array = _URLS_array.shift ();
			URLManager._reallyDoURL.apply (null, args_array);
		}
		if (URLManager._URLS_array.length == 0)
		{
			clearInterval (URLManager._URL_INTERVAL);
			delete (URLManager._URL_INTERVAL);
		}
	}
	static function _reallyDoURL (url_str:String)
	{
		//trace url
		Debug.myTrace ("URLManager", "doURL", url_str);
		//check to see if urls are ignored
		if (URLManager.IGNORE_URL == undefined)
		{
			//ignore urls if this is a local file
			URLManager.IGNORE_URL = System.capabilities.playerType == "External" || System.capabilities.playerType == "StandAlone";
		}
		//get the url if we are not running as a local file     
		if (!URLManager.IGNORE_URL)
		{
			getURL.apply (null, arguments);
		}
	}
}
