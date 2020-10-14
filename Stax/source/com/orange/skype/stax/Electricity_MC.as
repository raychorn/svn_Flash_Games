import com.orange.skype.stax.*;
import com.orange.utils.*;
class com.orange.skype.stax.Electricity_MC extends Base_MovieClip
{
	var p_links_obj;
	var p_links_array;
	var p_numLinks;
	var p_bSkip;
	static var RADIUS_SHORT = 35;
	static var RADIUS_LONG_STRAIGHT = 65;
	static var RADIUS_LONG_DIAG = 107;
	function Electricity_MC ()
	{
		setClassName ("Electricity_MC");
		p_links_obj = new Object ();
		p_links_obj.east = 0;
		p_links_obj.southEast = 1;
		p_links_obj.south = 2;
		p_links_obj.southWest = 3;
		p_links_obj.west = 4;
		p_links_obj.northWest = 5;
		p_links_obj.north = 6;
		p_links_obj.northEast = 7;
		p_links_array = [false, false, false, false, false, false, false, false];
		p_numLinks = 0;
		p_bSkip = false;
	}
	function setLink (dir, strength)
	{
		p_links_array[p_links_obj[dir]] = strength;
	}
	function onEnterFrame ()
	{
		p_bSkip = !p_bSkip;
		if (p_bSkip)
		{
			//return;
		}
		var color = _parent.p_currPlayer == 1 ? 0xFF2222 : 0xFFFF00
		this.clear ();
		for (var i = 0; i < 8; i++)
		{
			var strength = p_links_array[i];
			if (strength)
			{
				this.lineStyle (strength, color);
				var angle = Math.PI * i / 4;
				var startRadius = RADIUS_SHORT;
				var endRadius = (i % 2 == 0 ? RADIUS_LONG_STRAIGHT : RADIUS_LONG_DIAG);
				var startX = startRadius * Math.cos (angle);
				var startY = startRadius * Math.sin (angle);
				this.moveTo (startX, startY);
				for (var radius = startRadius; radius < endRadius - 3; radius += 25 * Math.random ())
				{
					var newAngle = angle + strength/10 - (strength/5 * Math.random ());
					var newX = radius * Math.cos (newAngle);
					var newY = radius * Math.sin (newAngle);
					this.lineTo (newX, newY);
				}
				var endX = endRadius * Math.cos (angle);
				var endY = endRadius * Math.sin (angle);
				this.lineTo (endX, endY);
			}
		}
	}
	function getRandomRadius ()
	{
		return (35 + 10 * Math.random ());
	}
}
