class com.orange.utils.Generic_Button extends com.orange.utils.Base_Button
{
	function Generic_Button ()
	{
		super ();
		setClassName ("Generic_Button");
		addEventListener ("onButtonPress", _parent);
		addEventListener ("onButtonRelease", _parent);
		addEventListener ("onButtonReleaseOutside", _parent);
		addEventListener ("onButtonRollOver", _parent);
		addEventListener ("onButtonRollOut", _parent);
	}
}
