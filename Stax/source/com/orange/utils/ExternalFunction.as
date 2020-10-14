import com.orange.utils.*;
class com.orange.utils.ExternalFunction
{
	static var CALLBACKS_obj:Object = new Object ();
	//------------------------------------------------------------
	//call a javascript function and register for the callback
	static function callJS (jsFunction_str:String, callback_fn:Function)
	{
		var uniqueID = (new Date ()).getTime () + random (10000);
		var callbackID_str = "ExtVar_" + uniqueID;
		registerCallback (callbackID_str, callback_fn);
		//build a string of arguments to pass to the js function
		var args_str = "";
		if (arguments.length > 2)
		{
			for (var i = 2; i < arguments.length; i++)
			{
				var thisArg = arguments[i];
				if (typeof (thisArg) == "number")
				{
					//pass numbers with no surrounding quotes
					args_str += thisArg;
				}
				else
				{
					//pass other data types with surrounding quotes
					thisArg = thisArg.split ("'").join ("\\'").split ('"').join ('\\"');
					args_str += "'" + thisArg + "'";
				}
				//add commas between args
				if (i < arguments.length - 1)
				{
					args_str += ",";
				}
			}
		}
		args_str += ")";
		//flashFunctionCall should be defined in JS to call a function and return a value to the flash movie
		//use flashobj.js to set this up properly
		URLManager.doURL ("javascript:flashFunctionCall('" + _root._JavaScriptFlashID + "','" + jsFunction_str + "','" + callbackID_str + "'," + args_str + ";");
	}
	//------------------------------------------------------------
	//register a callback for a variable change
	static function registerCallback (callbackID_str:String, callback_fn:Function, isPersistent:Boolean)
	{
		CALLBACKS_obj[callbackID_str] = {p_callback_fn:callback_fn, p_isPersistent:isPersistent};
		_root.watch (callbackID_str, ExternalFunction.onVarChange);
	}
	//------------------------------------------------------------
	//callback when a watched variable changes
	static function onVarChange (prop_str, oldVal, newVal)
	{
		//trace change (can be disabled with com.orange.utils.Debug.ignore("ExternalFunction"); )
		Debug.myTrace ("ExternalFunction", "onVarChange", "prop: " + prop_str + ", value: " + newVal);
		CALLBACKS_obj[prop_str].p_callback_fn (newVal);
		//remove variable if not persistent
		if (!CALLBACKS_obj[prop_str].p_isPersistent)
		{
			_root.unwatch (prop_str);
			delete CALLBACKS_obj[prop_str];
		}
	}
}
