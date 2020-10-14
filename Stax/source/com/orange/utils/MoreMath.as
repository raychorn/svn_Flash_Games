class com.orange.utils.MoreMath
{
	static var DEGREES = 180/Math.PI;
	static var RADIANS = Math.PI/180
	static function getAngleDiff (angle1:Number, angle2:Number):Number
	{
		var diff1:Number = angle1 - angle2;
		diff1 = (diff1 + 360 * 10) % 360;
		var diff2:Number = -diff1;
		diff2 = (diff2 + 360 * 10) % 360;
		var diff:Number = (diff1 < diff2) ? -diff1 : diff2;
		return (diff);
	}
}
