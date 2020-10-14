import com.orange.utils.*;
import caurina.transitions.*;
import mx.events.EventDispatcher;
import mx.utils.Delegate;
class com.orange.utils.Base_MovieClip extends MovieClip
{
	// functions added by EventDispatcher
	public var addEventListener:Function;
	public var removeEventListener:Function;
	private var dispatchEvent:Function;
	// added by debug
	var myTrace:Function;
	//added by FrameManager
	var addFrameAction:Function;
	var removeFrameAction:Function;
	//name of class (for debug, mostly)
	private var _className_str;
	//constructor
	function Base_MovieClip ()
	{
		EventDispatcher.initialize (this);
		FrameManager.initialize (this);
		setClassName ("MovieClip");
	}
	//set class name
	private function setClassName (className_str, prefix_2_str)
	{
		_className_str = className_str;
		if (prefix_2_str == undefined)
		{
			prefix_2_str = _name;
		}
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
