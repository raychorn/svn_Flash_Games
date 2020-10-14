class com.orange.utils.TrafficManager extends com.orange.utils.Base_Object
{
	static var _REF:Object;
	private function TrafficManager ()
	{
		super ();
		setClassName ("TrafficManager");
		if (_REF != undefined)
		{
			myTrace ("ERROR: do not access the _REF property directly");
		}
	}
	static function get REF ():Object
	{
		if (_REF == undefined)
		{
			_REF = new TrafficManager ();
		}
		return (_REF);
	}
	static function subscribeToEvent (event_str, subscriber)
	{
		REF.addEventListener (event_str, subscriber);
	}
	static function unsubscribeToEvent (event_str, subscriber)
	{
		REF.removeEventListener (event_str, subscriber);
	}
	static function publishEvent (event_obj)
	{
		REF.dispatchEvent (event_obj);
	}
}
