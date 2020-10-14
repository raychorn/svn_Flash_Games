class com.orange.utils.Phone
{
	static var KEY_1 = 49;
	static var KEY_2 = 50;
	static var KEY_3 = 51;
	static var KEY_4 = 52;
	static var KEY_5 = 53;
	static var KEY_6 = 54;
	static var KEY_7 = 55;
	static var KEY_8 = 56;
	static var KEY_9 = 57;
	static var KEY_UP = KEY_2
	static var KEY_DOWN = KEY_8
	static var KEY_RIGHT = KEY_6
	static var KEY_LEFT = KEY_4
	static var KEY_ENTER = KEY_5
	
	static function getKey(keyCode)
	{
		var phoneKey = keyCode
		switch(keyCode)
		{
			case Key.RIGHT:
				phoneKey = KEY_RIGHT;
				break;
			case Key.LEFT:
				phoneKey = KEY_LEFT;
				break;
			case Key.UP:
				phoneKey = KEY_UP;
				break;
			case Key.DOWN:
				phoneKey = KEY_DOWN;
				break;
			case KEY_5:
			case Key.ENTER:
			case Key.SPACE:
				phoneKey = KEY_ENTER;
				break;
		}
		return(phoneKey)
	}
	static function isKeyDown(keyCode)
	{
		var keyIsDown = Key.isDown(keyCode)
		switch(keyCode)
		{
			case Key.RIGHT:
				keyIsDown = Key.isDown(Key.RIGHT) || Key.isDown(KEY_RIGHT)
				break;
			case Key.LEFT:
				keyIsDown = Key.isDown(Key.LEFT) || Key.isDown(KEY_LEFT)
				break;
			case Key.UP:
				keyIsDown = Key.isDown(Key.UP) || Key.isDown(KEY_UP)
				break;
			case Key.DOWN:
				keyIsDown = Key.isDown(Key.DOWN) || Key.isDown(KEY_DOWN)
				break;
			case KEY_5:
			case Key.ENTER:
			case Key.SPACE:
				keyIsDown = Key.isDown(KEY_5) || Key.isDown(Key.ENTER) || Key.isDown(Key.SPACE);
				break;
		}
		return(keyIsDown)
	}
}