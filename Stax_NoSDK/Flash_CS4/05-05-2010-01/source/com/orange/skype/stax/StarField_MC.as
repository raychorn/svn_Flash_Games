class com.orange.skype.stax.StarField_MC extends com.orange.utils.Base_MovieClip {
	var p_intervalID;
	var p_frame;
	function StarField_MC() {
		setClassName("StarField_MC");
		p_frame = 0;
	}
	function onEnterFrame() {
		p_frame++;
		if (p_frame == 5) {
			makeStar();
			p_frame = 0;
		}
	}
	function makeStar() {
		for (var i = 0; i<3; i++) {
			var init_obj = new Object();
			init_obj._rotation = random(360);
			init_obj.p_speed = 3+4*Math.random();
			var angle = init_obj._rotation*Math.PI/180;
			init_obj.p_cos = Math.cos(angle);
			init_obj.p_sin = Math.sin(angle);
			var startOffset = random(60);
			init_obj._x = startOffset*init_obj.p_cos;
			init_obj._y = startOffset*init_obj.p_sin;
			init_obj._xscale = 60+random(40);
			init_obj._yscale = init_obj._xscale;
			init_obj.onEnterFrame = function() {
				this["p_speed"] += 1.4;
				this._x += this["p_speed"]*this["p_cos"];
				this._y += this["p_speed"]*this["p_sin"];
				if (Math.abs(this._x)>400 || Math.abs(this._y)>400) {
					this.removeMovieClip();
				}
			};
			var depth = this.getNextHighestDepth();
			var star_mc = attachMovie("Star_MC", "star_"+depth, depth, init_obj);
		}
	}
	function onUnload() {
		myTrace("cleaning up");
	}
}
