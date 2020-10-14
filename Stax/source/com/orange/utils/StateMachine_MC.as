import com.orange.utils.*;
class com.orange.utils.StateMachine_MC extends Base_MovieClip
{
	//current state (private, use p_state_str)
	private var _state_str;
	//current state function
	var p_currState_fn:Function;
	//number of frames in current state
	var p_stateFrame;
	var state_global:Function;
	//constructor
	function StateMachine_MC ()
	{
		setClassName ("StateMachine_MC");
		Key.addListener (this);
	}
	function processEvent (event_str)
	{
		if (!state_global.apply (this, arguments))
		{
			p_currState_fn.apply (this, arguments);
		}
	}
	function onKeyDown ()
	{
		processEvent ("onKeyDown", Key.getCode (), Key.getAscii ());
	}
	function onKeyUp ()
	{
		processEvent ("onKeyUp", Key.getCode (), Key.getAscii ());
	}
	function onMouseDown ()
	{
		processEvent ("onMouseDown");
	}
	function onMouseUp ()
	{
		processEvent ("onMouseUp");
	}
	function onButtonPress (event_obj)
	{
		processEvent ("onButtonPress", event_obj.target);
	}
	function onButtonRelease (event_obj)
	{
		processEvent ("onButtonRelease", event_obj.target);
	}
	function onButtonReleaseOutside (event_obj)
	{
		processEvent ("onButtonReleaseOutside", event_obj.target);
	}
	function onButtonRollOver (event_obj)
	{
		processEvent ("onButtonRollOver", event_obj.target);
	}
	function onButtonRollOut (event_obj)
	{
		processEvent ("onButtonRollOut", event_obj.target);
	}
	function onEnterFrame ()
	{
		p_stateFrame++;
		if (p_stateFrame == 1)
		{
			processEvent ("onFirstFrame");
		}
		processEvent ("onEnterFrame");
	}
	function setState (newState_str, isNewFrame)
	{
		myTrace ("setting state " + newState_str);
		processEvent ("onLeaveState");
		p_currState_fn = this["state_" + newState_str];
		p_stateFrame = 0;
		if (isNewFrame)
		{
			gotoAndStop (newState_str);
		}
		processEvent ("onEnterState");
		_state_str = newState_str;
	}
	//setter
	function set p_state_str (newState_str)
	{
		setState (newState_str);
	}
	//getter
	function get p_state_str ()
	{
		return (_state_str);
	}
}
