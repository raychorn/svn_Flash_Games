import com.orange.utils.*;
import mx.events.EventDispatcher;
import mx.utils.Delegate;
class com.orange.utils.Base_Object extends Object
{
	// functions added by EventDispatcher
	public var addEventListener:Function;
	public var removeEventListener:Function;
	private var dispatchEvent:Function;
	// added by debug
	var myTrace:Function;
	//name of class (for debug, mostly)
	private var _className_str;
	//constructor
	function Base_Object ()
	{
		EventDispatcher.initialize (this);
		setClassName ("Object");
	}
	//set class name
	private function setClassName (className_str, prefix_2_str)
	{
		_className_str = className_str;
		Debug.initialize (this, className_str, prefix_2_str);
	}
	//get class name
	function get p_className_str ():String
	{
		return (_className_str);
	}
	function subscribeToEvent (event_str)
	{
		TrafficManager.subscribeToEvent (event_str, this);
	}
}
