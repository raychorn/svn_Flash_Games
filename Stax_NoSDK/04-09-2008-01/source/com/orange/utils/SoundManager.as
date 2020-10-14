class com.orange.utils.SoundManager extends com.orange.utils.Base_Object
{
	static var _REF:Object;
	var p_sound;
	var p_currMusic_str;
	private function SoundManager ()
	{
		super ();
		setClassName ("SoundManager");
		p_sound = new Sound ();
		p_currMusic_str = "";
		if (_REF != undefined)
		{
			myTrace ("ERROR: do not access the _REF property directly");
		}
	}
	static function get REF ():Object
	{
		if (_REF == undefined)
		{
			_REF = new SoundManager ();
		}
		return (_REF);
	}
	static function playSound (id)
	{
		REF.p_sound.attachSound (id);
		REF.p_sound.start ();
	}
	static function playMusic (id)
	{
		if (REF.p_currMusic_str != id)
		{
			REF.p_sound.stop ();
			REF.p_sound.attachSound (id);
			REF.p_sound.start (0, 1000000);
		}
		REF.p_currMusic_str = id;
	}
	static function stop ()
	{
		REF.p_currMusic_str = "";
		REF.p_sound.stop ();
	}
	static function setVolume (vol)
	{
		REF.p_sound.setVolume (vol);
	}
	static function getVolume ()
	{
		return (REF.p_sound.getVolume ());
	}
}
