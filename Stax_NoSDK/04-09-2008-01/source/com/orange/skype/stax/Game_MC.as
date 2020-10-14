import com.orange.utils.*;
import com.orange.skype.stax.*;
class com.orange.skype.stax.Game_MC extends StateMachine_MC
{
	//max moves before pieces disappear
	static var MAX_PIECES = 6;
	//2-dimensional array of game grid
	var p_gameGrid_array;
	//moves for player 1
	var p_moves_1_array;
	//moves for player 2
	var p_moves_2_array;
	//column of current move
	var p_currCol;
	//row and column of dropping piece
	var p_dropCol;
	var p_dropRow;
	//names of players
	var player1_str, player2_str;
	//current player number
	var p_currPlayer;
	//player number on this client
	var p_playerNum;
	//player number of winner
	var p_winner;
	//MOVIECLIPS
	//tile that is currently dropping
	var p_dropPiece_mc;
	//move buttons
	var btn_0_mc, btn_1_mc, btn_2_mc, btn_3_mc;
	//turn indicator
	var turn_mc;
	//background button
	var bg_btn;
	//game over button
	var gameOver_mc;
	//instructions clip
	var instructions_mc;
	//start game button
	var btn_startGame_mc;
	var startGameBG_mc;
	//timer clip
	var btn_timer_mc;
	//effects clips
	var greenGlow_mc;
	var redGlow_mc;
	var starField_mc;
	//any time this variable is used, it's for handling local testing in flash authoring
	var p_isLocal;
	//ensures the tiles flip together
	var p_iFlipFrame;
	//constructor
	function Game_MC ()
	{
		setClassName ("Game_MC");
		//true if running locally (not on skype)
		p_isLocal = System.capabilities.playerType == "External";
		//p_isLocal = true;
		//number of currentplayer
		p_playerNum = Number (_root.LocalNumber) + 1;
		//player names
		player1_str = _root.PlayersDspNames[0];
		player1_str = player1_str ? player1_str : "Player 1";
		player2_str = _root.PlayersDspNames[1];
		player2_str = player2_str ? player2_str : "Player 2";
		myTrace ("Player Number is " + p_playerNum);
		//subscribe to skype data event
		TrafficManager.subscribeToEvent ("onSkypeData", this);
		//hacks
		if (p_isLocal)
		{
			p_playerNum = 1;
			if (_parent.p_score1 == "")
			{
				_parent.p_score1 = 1000;
			}
			if (_parent.p_score2 == "")
			{
				_parent.p_score2 = 1000;
			}
		}
		_parent.initScore (p_playerNum);
		gameOver_mc._visible = false;
		instructions_mc._visible = false;
		bg_btn.useHandCursor = false;
		btn_startGame_mc._visible = _parent.p_isFirstGame;
		startGameBG_mc._visible = _parent.p_isFirstGame;
		btn_0_mc.enabled = false;
		btn_0_mc.gotoAndStop (7);
		btn_1_mc.enabled = false;
		btn_1_mc.gotoAndStop (7);
		btn_2_mc.enabled = false;
		btn_2_mc.gotoAndStop (7);
		btn_3_mc.enabled = false;
		btn_3_mc.gotoAndStop (7);
		greenGlow_mc._visible = false;
		p_iFlipFrame = 0;
		setState ("init");
	}
	function onUnload ()
	{
		TrafficManager.unsubscribeToEvent ("onSkypeData", this);
	}
	function state_global (event_str)
	{
		switch (event_str)
		{
		case "onEnterFrame" :
			p_iFlipFrame %= 53;
			p_iFlipFrame++;
			break;
		}
	}
	function state_init (event_str)
	{
		switch (event_str)
		{
		case "onFirstFrame" :
			//disable buttons
			setButtons (0);
			//hide turn indicator
			turn_mc.gotoAndStop ("nothing");
			//init move arrays
			p_moves_1_array = new Array ();
			p_moves_2_array = new Array ();
			//init game array
			p_gameGrid_array = new Array ();
			for (var i = 0; i < 4; i++)
			{
				this["btn_" + i + "_mc"].p_col = i;
				p_gameGrid_array.push ([0, 0, 0, 0]);
			}
			//init buttons
			btn_startGame_mc._visible = true;
			startGameBG_mc._visible = true;
			btn_startGame_mc.p_isEnabled = !_parent.p_isPlayerReady;
			btn_timer_mc.p_isEnabled = true;
			btn_timer_mc.p_isActive = _parent.p_isTimerEnabled;
			myTrace ("game initialized");
			break;
		case "onEnterFrame" :
			if (_parent.p_isAllReady)
			{
				//wait for network to indicate that game is ready, then start
				p_currPlayer = _parent.p_firstPlayer;
				myTrace ("starting game with player " + p_currPlayer);
				setState ("choosePlayer");
			}
			break;
		case "onButtonPress" :
			var btn_mc = arguments[1];
			switch (btn_mc)
			{
			case btn_startGame_mc :
				//start game button
				btn_startGame_mc.p_isEnabled = false;
				_parent.onPlayerReady ();
				_parent.startGame (_parent.p_timerValue);
				if (p_isLocal)
				{
					_parent.p_isGameReady = true;
					_parent.p_isOpponentReady = true;
				}
				break;
			case btn_timer_mc :
				//toggle timer button
				btn_timer_mc.p_isActive = !btn_timer_mc.p_isActive;
				_parent.p_isTimerEnabled = btn_timer_mc.p_isActive;
				_root.sendData ("SetTimerEnabled_" + (_parent.p_isTimerEnabled ? 1 : 0));
				break;
			}
			break;
		case "setTimerEnabled" :
			//toggle timer button based on other user
			btn_timer_mc.p_isActive = arguments[1];
			break;
		case "lockTimerButton" :
			btn_timer_mc.p_isActive = arguments[1];
			btn_timer_mc.enabled = false;
			break;
		case "onLeaveState" :
			btn_startGame_mc._visible = false;
			startGameBG_mc._visible = false;
			btn_timer_mc.enabled = false;
			break;
		}
	}
	function state_choosePlayer (event_str)
	{
		switch (event_str)
		{
		case "onEnterState" :
			turn_mc.gotoAndStop ("flip");
			break;
		case "onEnterFrame" :
			if (p_stateFrame == 20)
			{
				setState (p_currPlayer == p_playerNum ? "wait" : "waitForOpponent");
			}
			break;
		}
	}
	function state_wait (event_str)
	{
		switch (event_str)
		{
		case "onEnterState" :
			myTrace ("my turn");
			SoundManager.playSound ("TurnStart_SND");
			p_currPlayer = p_playerNum;
			turn_mc.gotoAndStop ("yourTurn" + p_currPlayer);
			if (_parent.p_isTimerEnabled)
			{
				turn_mc.timer_mc.gotoAndPlay ("timerOn");
			}
			redGlow_mc.gotoAndStop (1);
			setButtons (0);
			break;
		case "onEnterFrame" :
			if (p_stateFrame <= 2)
			{
				setButtons (0);
			}
			if (p_stateFrame == 10)
			{
				setButtons (p_currPlayer);
			}
			break;
		case "onButtonPress" :
			var btn_mc = arguments[1];
			if (btn_mc.p_col != undefined)
			{
				myTrace ("clicked column " + btn_mc.p_col);
				instructions_mc._visible = false;
				SoundManager.playSound ("Button_SND");
				addPiece (btn_mc.p_col);
				myTrace ("sending move to opponent");
			}
			break;
		case "timerDoneBeep" :
			SoundManager.playSound ("TimerDone_SND");
			setButtons (0);
			break;
		case "timerDone" :
			myTrace ("time up!");
			_root.sendData ("TimeOut_" + p_playerNum);
			setState ("waitForOpponent");
			break;
		case "timerTick" :
			if (redGlow_mc._currentframe == 1)
			{
				redGlow_mc.gotoAndPlay (2);
				starField_mc._visible = false;
			}
			//SoundManager.playSound ("TimerBeep_SND");
			break;
		case "onLeaveState" :
			redGlow_mc.gotoAndStop (1);
			starField_mc._visible = true;
			turn_mc.timer_mc.gotoAndStop (1);
			break;
		}
	}
	function state_waitForOpponent (event_str, col)
	{
		switch (event_str)
		{
		case "onEnterState" :
			myTrace ("waiting for opponent");
			p_currPlayer = (p_playerNum == 1 ? 2 : 1);
			turn_mc.gotoAndStop ("pleaseWait" + p_currPlayer);
			setButtons (0);
			if (p_isLocal)
			{
				setButtons (p_currPlayer);
			}
			break;
		case "opponentMove" :
			myTrace ("opponent moved in column " + col);
			addPiece (col);
			break;
		case "opponentTimeOut" :
			myTrace ("opponent time out");
			SoundManager.playSound ("TimerDone_SND");
			setState ("wait");
			break;
		case "onButtonPress" :
			if (p_isLocal)
			{
				var btn_mc = arguments[1];
				if (btn_mc.p_col != undefined)
				{
					instructions_mc._visible = false;
					addPiece (btn_mc.p_col);
				}
			}
			break;
		}
	}
	function state_dropPiece (event_str, gridPiece_mc)
	{
		switch (event_str)
		{
		case "onEnterState" :
			myTrace ("dropping a piece in " + p_currCol);
			SoundManager.playSound ("Flow_SND");
			setButtons (0);
			break;
		case "flowDone" :
			if (gridPiece_mc.p_currPlayer)
			{
				var flowCol = gridPiece_mc.p_col;
				var flowRow = gridPiece_mc.p_row;
				var isDone = true;
				if (flowRow < 3)
				{
					var nextPiece_mc = gridPiece (flowCol, flowRow + 1);
					if (!nextPiece_mc.p_currPlayer)
					{
						isDone = false;
						nextPiece_mc.flow (gridPiece_mc.p_currPlayer);
						gridPiece_mc.flow (0);
					}
				}
				if (isDone)
				{
					if (p_moves_array.length > MAX_PIECES)
					{
						setState ("dropCol");
					}
					else
					{
						setState ("checkGrid");
					}
				}
				else
				{
					SoundManager.playSound ("Flow_SND");
				}
			}
			break;
		}
	}
	function state_dropCol (event_str)
	{
		switch (event_str)
		{
		case "onEnterState" :
			SoundManager.playSound ("LineOff_SND");
			setButtons (0);
			p_dropCol = p_moves_array[0];
			var firstRow = 3;
			//find move
			for (var i = 0; i < 4; i++)
			{
				if (p_gameGrid_array[p_dropCol][i] == p_currPlayer)
				{
					firstRow = i;
				}
			}
			p_dropRow = firstRow;
			p_dropPiece_mc = gridPiece (p_dropCol, p_dropRow);
			break;
		case "onEnterFrame" :
			if (p_stateFrame < 10)
			{
				p_dropPiece_mc.in_mc._visible = (Math.floor (p_stateFrame / 2) % 2 == 0);
			}
			else if (p_stateFrame == 10)
			{
				p_dropPiece_mc.in_mc._visible = true;
				p_moves_array.shift ();
				myTrace ("dropping column " + p_dropCol);
				var lastPlayer = 0;
				myTrace ("removing " + p_currPlayer + " from " + p_dropRow);
				//flow pieces
				for (var i = 0; i <= p_dropRow; i++)
				{
					var gridPiece_mc = gridPiece (p_dropCol, i);
					var currPlayer = gridPiece_mc.p_currPlayer;
					gridPiece_mc.flow (lastPlayer);
					lastPlayer = currPlayer;
				}
				//remove piece from game grid
				p_gameGrid_array[p_dropCol].splice (p_dropRow, 1);
				//add 0 to top of col
				p_gameGrid_array[p_dropCol].unshift (0);
				myTrace ("game state is now:");
				traceGrid ();
			}
			break;
		case "flowDone" :
			if (p_stateFrame > 2)
			{
				setState ("checkGrid");
			}
			break;
		}
	}
	function state_checkGrid (event_str)
	{
		switch (event_str)
		{
		case "onEnterState" :
			myTrace ("checking for winner");
			var row, col;
			var i;
			//check rows
			for (row = 4; row >= 0; row--)
			{
				var player = p_gameGrid_array[0][row];
				if (player)
				{
					var winner = player;
					for (col = 1; col < 4; col++)
					{
						var gridValue = p_gameGrid_array[col][row];
						if (gridValue != player)
						{
							winner = false;
							break;
						}
					}
					if (winner)
					{
						myTrace ("win in row " + row);
						for (col = 0; col < 4; col++)
						{
							gridPiece (col, row).p_isWinner = true;
						}
						break;
					}
				}
			}
			//check columns
			if (!winner)
			{
				for (col = 0; col < 4; col++)
				{
					var player = p_gameGrid_array[col][0];
					if (player)
					{
						var winner = player;
						for (row = 1; row < 4; row++)
						{
							var gridValue = p_gameGrid_array[col][row];
							if (gridValue != player)
							{
								winner = false;
								break;
							}
						}
						if (winner)
						{
							myTrace ("win in col " + col);
							for (row = 0; row < 4; row++)
							{
								gridPiece (col, row).p_isWinner = true;
							}
							break;
						}
					}
				}
			}
			//check diagonal 1                                                                                                         
			if (!winner)
			{
				var a = p_gameGrid_array;
				var player = a[0][0];
				if (player)
				{
					winner = player;
					for (i = 0; i < 4; i++)
					{
						if (a[i][i] != player)
						{
							winner = false;
						}
					}
				}
				if (winner)
				{
					myTrace ("win in diag1");
					for (i = 0; i < 4; i++)
					{
						gridPiece (i, i).p_isWinner = true;
					}
				}
			}
			//check diagonal 2                                                                                                       
			if (!winner)
			{
				var a = p_gameGrid_array;
				var a = p_gameGrid_array;
				var player = a[0][3];
				if (player)
				{
					winner = player;
					for (i = 0; i < 4; i++)
					{
						if (a[i][4 - 1 - i] != player)
						{
							winner = false;
						}
					}
				}
				if (winner)
				{
					myTrace ("win in diag2");
					for (i = 0; i < 4; i++)
					{
						gridPiece (i, 4 - 1 - i).p_isWinner = true;
					}
				}
			}
			//send last move to opponent                         
			if (p_currPlayer == p_playerNum)
			{
				_root.sendData ("Move_" + p_playerNum + "_" + p_currCol);
			}
			if (!winner)
			{
				setState (p_currPlayer != p_playerNum ? "wait" : "waitForOpponent");
			}
			else
			{
				p_winner = winner;
				setState ("gameOver");
			}
			break;
		}
	}
	function state_gameOver (event_str)
	{
		switch (event_str)
		{
		case "onEnterState" :
			myTrace ("game over, winner is " + p_winner);
			_parent.onGameOver ();
			if (p_winner == p_playerNum)
			{
				SoundManager.playSound ("Win_SND");
				gameOver_mc.winLose_mc.gotoAndStop (1);
				greenGlow_mc._visible = true;
				greenGlow_mc._alpha = 0;
				greenGlow_mc.gotoAndPlay(1)
				starField_mc._visible = false;
			}
			else
			{
				SoundManager.playSound ("Lose_SND");
				gameOver_mc.winLose_mc.gotoAndStop (2);
			}
			//add 1 to winner score
			_parent.setScore (p_winner, 1);
			//subtract 1 from loser scores
			_parent.setScore ((p_winner == 1 ? 2 : 1), -1);
			//tell server what our score is
			_root.EndGame (_parent["p_score" + p_playerNum]);
			gameOver_mc._visible = true;
			gameOver_mc.gotoAndStop (1);
			btn_timer_mc.enabled = true;
			turn_mc.gotoAndStop ("nothing");
			for (var col = 0; col < 4; col++)
			{
				for (var row = 0; row < 4; row++)
				{
					var gridPiece_mc = gridPiece (col, row);
					if (gridPiece_mc.p_isWinner)
					{
						gridPiece_mc.winBubbles_mc.gotoAndPlay (2);
						gridPiece_mc.gotoAndPlay ("win");
					}
					else
					{
						gridPiece_mc.electricity_mc._visible = false;
					}
				}
			}
			break;
		case "onButtonPress" :
			var btn_mc = arguments[1];
			switch (btn_mc)
			{
			case gameOver_mc :
				if (p_isLocal)
				{
					_parent.p_isGameReady = true;
					_parent.p_isPlayerReady = true;
					_parent.p_isOpponentReady = true;
					_parent.setState ("game", true);
				}
				else
				{
					gameOver_mc.gotoAndStop (2);
					_parent.onPlayerReady (_parent.p_isTimerEnabled);
				}
				break;
			case btn_timer_mc :
				btn_timer_mc.p_isActive = !btn_timer_mc.p_isActive;
				_parent.p_isTimerEnabled = btn_timer_mc.p_isActive;
				_root.sendData ("SetTimerEnabled_" + _parent.p_timerValue);
				break;
			}
			break;
		case "onEnterFrame" :
			p_iFlipFrame = 1;
			if (_parent.p_isOpponentReady)
			{
				btn_timer_mc.enabled = true;
				btn_timer_mc.p_isActive = _parent.p_isTimerEnabled;
				btn_timer_mc.enabled = false;
				if (_parent.p_isPlayerReady)
				{
					_parent.processEvent ("newGame");
				}
			}
			if (greenGlow_mc._alpha < 100)
			{
				greenGlow_mc._alpha += 20;
			}
			break;
		case "setTimerEnabled" :
			btn_timer_mc.p_isActive = arguments[1];
			break;
		case "lockTimerButton" :
			btn_timer_mc.p_isActive = arguments[1];
			btn_timer_mc.enabled = false;
			break;
		case "onLeaveState" :
			for (var col = 0; col < 4; col++)
			{
				for (var row = 0; row < 4; row++)
				{
					var gridPiece_mc = gridPiece (col, row);
					gridPiece_mc.electricity_mc._visible = true;
				}
			}
			greenGlow_mc._visible = false;
			starField_mc._visible = true;
			break;
		}
	}
	function traceGrid ()
	{
		for (var i = 0; i < 4; i++)
		{
			myTrace (p_gameGrid_array[i]);
		}
	}
	function addPiece (col)
	{
		if (p_gameGrid_array[col][0] == 0)
		{
			//place a piece in the grid
			var col_array = p_gameGrid_array[col];
			var targetRow = 0;
			for (var i = 0; i < col_array.length; i++)
			{
				if (i == col_array.length - 1 || col_array[i + 1])
				{
					col_array[i] = p_currPlayer;
					targetRow = i;
					break;
				}
			}
			p_currCol = col;
			p_moves_array.push (col);
			gridPiece (col, 0).flow (p_currPlayer);
			myTrace ("adding " + p_currPlayer + " in column " + col);
			traceGrid ();
			setState ("dropPiece");
			return (true);
		}
	}
	function setButtons (player)
	{
		var isActive = player == 2;
		var isEnabled = player > 0;
		for (var i = 0; i < 4; i++)
		{
			var btn_mc = this["btn_" + i + "_mc"];
			btn_mc.p_isEnabled = isEnabled;
			btn_mc.p_isActive = isActive;
			btn_mc._visible = true;
		}
	}
	function gridPiece (col, row)
	{
		return (this["grid_" + col + "_" + row]);
	}
	function onSkypeData (event_obj)
	{
		var skypeData_array = event_obj.skypeData.split ("_");
		if (skypeData_array[0] == "Move")
		{
			if (Number (skypeData_array[1] != p_playerNum))
			{
				processEvent ("opponentMove", skypeData_array[2]);
			}
		}
		else if (skypeData_array[0] == "TimeOut")
		{
			processEvent ("opponentTimeOut");
		}
	}
	function get p_moves_array ()
	{
		return (this["p_moves_" + p_currPlayer + "_array"]);
	}
}
