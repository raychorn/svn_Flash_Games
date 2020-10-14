//	com.orange.utils.Debug
//		This is a useful class for custom trace functions
//		use myTrace = Debug.getTraceFunction(prefix_1_str:String, prefix_2_str:String) to get a custom trace function
//		use Debug.ignore(prefix_str:String) and Debug.unignore(prefix_str:String) to ignore/unignore given prefixes at runtime
class com.orange.utils.Debug
{
	static var p_ignoreList_obj:Object = new Object ();
	//constructor
	private function Debug ()
	{
	}
	//ignore a prefix
	static function ignore (prefix_str):Void
	{
		trace ("[Debug] ignoring prefix: " + prefix_str);
		Debug.p_ignoreList_obj[prefix_str] = true;
	}
	//uningnore a prefix
	static function unignore (prefix_str):Void
	{
		trace ("[Debug] unignoring prefix: " + prefix_str);
		delete Debug.p_ignoreList_obj[prefix_str];
	}
	//check a prefix
	static function getIgnoreState (prefix_str):Boolean
	{
		if (prefix_str == undefined || prefix_str == "")
		{
			return (false);
		}
		var isIgnored:Boolean;
		isIgnored = (Debug.p_ignoreList_obj[prefix_str] == true);
		return (isIgnored);
	}
	//trace with two optional prefixes
	//output will be "[prefix_1_str] <prefix_2_str> msg"
	//msg is intentionally untyped, as trace can accept anything
	static function myTrace (prefix_1_str, prefix_2_str, msg):Void
	{
		//exit if prefixes are ignored
		if (Debug.getIgnoreState (prefix_1_str) || Debug.getIgnoreState (prefix_2_str))
		{
			return;
		}
		//init output   
		var output_str:String = "";
		//append prefixes
		if (prefix_1_str != undefined && prefix_1_str != "")
		{
			output_str += "[" + prefix_1_str + "] ";
		}
		if (prefix_2_str != undefined && prefix_2_str != "")
		{
			output_str += "<" + prefix_2_str + "> ";
		}
		//append msg   
		output_str += msg;
		//trace to msg window
		trace (output_str);
		//add to root debug_txt
		_root.debug_txt.text += output_str + "\n"
	}
	//get a local trace function
	static function getTraceFunction (prefix_1_str, prefix_2_str)
	{
		var trace_fn = function (msg)
		{
			Debug.myTrace (arguments.callee.prefix_1_str, arguments.callee.prefix_2_str, msg);
		};
		trace_fn.prefix_1_str = prefix_1_str;
		trace_fn.prefix_2_str = prefix_2_str;
		return (trace_fn);
	}
	//initialize an object by adding a myTrace function to it
	static function initialize (target_obj:Object, prefix_1_str, prefix_2_str)
	{
		target_obj["myTrace"] = Debug.getTraceFunction (prefix_1_str, prefix_2_str);
	}
	//trace all properties in an object (not recursive)
	static function traceProps (target_obj)
	{
		Debug.myTrace ("Debug", "traceProps", "begin");
		for (var i in target_obj)
		{
			Debug.myTrace ("Debug", "traceProps", i + ":" + target_obj[i]);
		}
		Debug.myTrace ("Debug", "traceProps", "end");
	}
}
