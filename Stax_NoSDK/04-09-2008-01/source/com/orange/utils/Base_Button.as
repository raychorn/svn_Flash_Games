class com.orange.utils.Base_Button extends com.orange.utils.Base_MovieClip
{
	//var
	//frames - untyped because they can be numbers or strings
	var p_pressFrame;
	var p_activeOffFrame;
	var p_inactiveOffFrame;
	var p_activeOverFrame;
	var p_inactiveOverFrame;
	var p_activeDownFrame;
	var p_inactiveDownFrame;
	var p_disabledFrame;
	var p_currFrame;
	private var _isActive:Boolean;
	private var _isRolledOver:Boolean;
	private var _isPressed:Boolean;
	//constructor
	function Base_Button ()
	{
		super();
		setClassName ("Base_Button");
		defaultProp ("p_inactiveOffFrame", 1);
		defaultProp ("p_inactiveOverFrame", 2);
		defaultProp ("p_inactiveDownFrame", 3);
		defaultProp ("p_activeOffFrame", 4);
		defaultProp ("p_activeOverFrame", 5);
		defaultProp ("p_activeDownFrame", 6);
		defaultProp ("p_disabledFrame", 7);
		defaultProp ("p_isActive", false);
		setFrame ();
	}
	//set a property to its default if it is undefined
	function defaultProp (propName_str:String, propValue)
	{
		if (this[propName_str] == undefined)
		{
			this[propName_str] = propValue;
		}
	}
	//get and set active state
	function set p_isActive (isActive:Boolean)
	{
		if (isActive != undefined)
		{
			_isActive = isActive;
		}
		else
		{
			_isActive = !_isActive;
		}
		setFrame ();
	}
	function get p_isActive ():Boolean
	{
		return (_isActive);
	}
	//getters for states
	function get p_isRolledOver ():Boolean
	{
		return (_isRolledOver);
	}
	function get p_isPressed ():Boolean
	{
		return (_isPressed);
	}
	function set p_isEnabled (isEnabled:Boolean)
	{
		if (!isEnabled)
		{
			_isRolledOver = false;
			_isPressed = false;
		}
		this.enabled = isEnabled;
		setFrame ();
	}
	function get p_isEnabled ():Boolean
	{
		return (this.enabled);
	}
	//getters for frames
	function get p_offFrame ()
	{
		return (_isActive ? p_activeOffFrame : p_inactiveOffFrame);
	}
	function get p_overFrame ()
	{
		return (_isActive ? p_activeOverFrame : p_inactiveOverFrame);
	}
	function get p_downFrame ()
	{
		return (_isActive ? p_activeDownFrame : p_inactiveDownFrame);
	}
	//set current frame
	function setFrame ()
	{
		var targetFrame = p_disabledFrame;
		if (this.enabled)
		{
			if (_isRolledOver)
			{
				targetFrame = _isPressed ? p_downFrame : p_overFrame;
			}
			else
			{
				targetFrame = p_offFrame;
			}
		}
		var temp = _currentframe;
		gotoAndStop (targetFrame);
		p_currFrame = targetFrame;
		if (_currentframe != temp)
		{
			sendEvent ("onButtonFrameChange");
		}
	}
	//get event object
	function getEventObj ():Object
	{
		var event_obj = new Object ();
		event_obj.target = this;
		return (event_obj);
	}
	//send the event
	function sendEvent (eventType_str:String)
	{
		var event_obj = getEventObj ();
		event_obj.type = eventType_str;
		event_obj.target = this;
		dispatchEvent (event_obj);
	}
	//mouse events
	function onRollOver ()
	{
		_isRolledOver = true;
		setFrame ();
		sendEvent ("onButtonRollOver");
	}
	function onDragOver ()
	{
		_isRolledOver = true;
		setFrame ();
		sendEvent ("onButtonRollOver");
	}
	function onDragOut ()
	{
		//_isRolledOver = false;
		setFrame ();
		sendEvent ("onButtonRollOut");
	}
	function onRollOut ()
	{
		_isRolledOver = false;
		setFrame ();
		sendEvent ("onButtonRollOut");
	}
	function onPress ()
	{
		_isPressed = true;
		setFrame ();
		sendEvent ("onButtonPress");
	}
	function onRelease ()
	{
		_isPressed = false;
		setFrame ();
		sendEvent ("onButtonRelease");
	}
	function onReleaseOutside ()
	{
		_isRolledOver = false;
		_isPressed = false;
		setFrame ();
	}
}
