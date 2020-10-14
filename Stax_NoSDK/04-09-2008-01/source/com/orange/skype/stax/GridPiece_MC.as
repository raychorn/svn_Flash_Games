import com.orange.utils.*;
class com.orange.skype.stax.GridPiece_MC extends Base_MovieClip
{
	var in_mc;
	var out_mc;
	var tubeIn_mc;
	var tubeOut_mc;
	var bubbles_mc;
	var glow_mc;
	var p_currPlayer;
	var p_isFlowing;
	var p_col;
	var p_row;
	var p_isWinner;
	var electricity_mc;
	function GridPiece_MC ()
	{
		setClassName ("GridPiece_MC");
		p_currPlayer = 0;
		var nameSplit = _name.split ("_");
		p_col = Number (nameSplit[1]);
		p_row = Number (nameSplit[2]);
		stop ();
	}
	function flow (inPlayer)
	{
		out_mc.gotoAndStop (p_currPlayer + 1);
		tubeOut_mc.gotoAndStop (p_currPlayer + 1);
		in_mc.gotoAndStop (inPlayer + 1);
		tubeIn_mc.gotoAndStop (inPlayer + 1);
		p_isFlowing = true;
		p_currPlayer = inPlayer;
		if (bubbles_mc._currentframe == 1 && inPlayer)
		{
			bubbles_mc.gotoAndPlay (2);
		}
		gotoAndPlay ("flow");
	}
	function onEnterFrame ()
	{
		var horiz = 0;
		var vert = 0;
		var diag1 = 0;
		var diag2 = 0;
		if (p_currPlayer)
		{
			//check east/west strength
			if (_parent.gridPiece (p_col + 1, p_row).p_currPlayer == p_currPlayer)
			{
				for (var col = p_col + 1; col < 4; col++)
				{
					var piece_mc = _parent.gridPiece (col, p_row);
					if (piece_mc.p_currPlayer == p_currPlayer)
					{
						horiz++;
					}
					else
					{
						break;
					}
				}
				for (var col = p_col - 1; col >= 0; col--)
				{
					var piece_mc = _parent.gridPiece (col, p_row);
					if (piece_mc.p_currPlayer == p_currPlayer)
					{
						horiz++;
					}
					else
					{
						break;
					}
				}
			}
			//check north/south strength              
			if (_parent.gridPiece (p_col, p_row - 1).p_currPlayer == p_currPlayer)
			{
				for (var row = p_row + 1; row < 4; row++)
				{
					var piece_mc = _parent.gridPiece (p_col, row);
					if (piece_mc.p_currPlayer == p_currPlayer)
					{
						vert++;
					}
					else
					{
						break;
					}
				}
				for (var row = p_row - 1; row >= 0; row--)
				{
					var piece_mc = _parent.gridPiece (p_col, row);
					if (piece_mc.p_currPlayer == p_currPlayer)
					{
						vert++;
					}
					else
					{
						break;
					}
				}
			}
			//check northEast strength            
			if (p_row == p_col)
			{
				if (_parent.gridPiece (p_col + 1, p_row + 1).p_currPlayer == p_currPlayer)
				{
					for (var row = p_row + 1; row < 4; row++)
					{
						var col = row;
						var piece_mc = _parent.gridPiece (col, row);
						if (piece_mc.p_currPlayer == p_currPlayer)
						{
							diag1++;
						}
						else
						{
							break;
						}
					}
					for (var row = p_row - 1; row >= 0; row--)
					{
						var col = row;
						var piece_mc = _parent.gridPiece (col, row);
						if (piece_mc.p_currPlayer == p_currPlayer)
						{
							diag1++;
						}
						else
						{
							break;
						}
					}
				}
			}
			//check northWest strength             
			if (p_col == 3 - p_row)
			{
				if (_parent.gridPiece (p_col + 1, p_row - 1).p_currPlayer == p_currPlayer)
				{
					for (var row = p_row + 1; row < 4; row++)
					{
						var col = 3 - row;
						var piece_mc = _parent.gridPiece (col, row);
						if (piece_mc.p_currPlayer == p_currPlayer)
						{
							diag2++;
						}
						else
						{
							break;
						}
					}
					for (var row = p_row - 1; row >= 0; row--)
					{
						var col = 3 - row;
						var piece_mc = _parent.gridPiece (col, row);
						if (piece_mc.p_currPlayer == p_currPlayer)
						{
							diag2++;
						}
						else
						{
							break;
						}
					}
				}
			}
			//check if flipping      
			if (p_isFlowing)
			{
				in_mc.p_bFlip = false;
			}
			else
			{
				in_mc.p_bFlip = true;
				for (var col = p_col - 1; col <= p_col + 1; col++)
				{
					for (var row = p_row - 1; row <= p_row + 1; row++)
					{
						if (row != p_row || col != p_col)
						{
							var bCheck = false;
							bCheck |= (p_row == row || p_col == col);
							bCheck |= (p_row == p_col && row == col);
							bCheck |= (p_col == 3 - p_row && col == 3 - row);
							if (bCheck)
							{
								var piece_mc = _parent.gridPiece (col, row);
								if (piece_mc.p_currPlayer == p_currPlayer)
								{
									in_mc.p_bFlip = false;
									break;
								}
							}
						}
					}
				}
			}
			if (p_isWinner)
			{
				horiz = horiz == 3 ? 3 : 0;
				vert = vert == 3 ? 3 : 0;
				diag1 = diag1 == 3 ? 3 : 0;
				diag2 = diag2 == 3 ? 3 : 0;
			}
		}
		electricity_mc.setLink ("east", horiz);
		electricity_mc.setLink ("south", vert);
		electricity_mc.setLink ("northEast", diag1);
		electricity_mc.setLink ("southEast", diag2);
		//set south      
		//set northEast 
		//set southEast
	}
	function flowDone ()
	{
		p_isFlowing = false;
		if (!p_isWinner)
		{
			stop ();
		}
		_parent.processEvent ("flowDone", this);
	}
}
