class com.orange.utils.AnimClip_MC extends com.orange.utils.StateMachine_MC
{
	var p_isChanged;
	var p_isStopOnChange;
	function AnimClip_MC ()
	{
		setClassName ("AnimClip_MC");
		stop ();
	}
	function setState (state_str)
	{
		if (state_str != p_state_str)
		{
			p_isChanged = true;
			p_isStopOnChange ? gotoAndStop (state_str) : gotoAndPlay(state_str);
		}
		super.setState (state_str);
	}
	function onEnterFrame ()
	{
		if (p_isChanged)
		{
			processEvent ("onFirstFrame");
			p_isChanged = false;
		}
		super.onEnterFrame ();
	}
}