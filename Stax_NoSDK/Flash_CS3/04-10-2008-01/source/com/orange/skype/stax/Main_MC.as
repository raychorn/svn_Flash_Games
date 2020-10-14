import com.orange.utils.*;
class com.orange.skype.stax.Main_MC extends StateMachine_MC
{
	var content_mc;
	var game_mc;
	var p_nextState_str;
	var p_firstPlayer;
	var p_playerNum;
	var p_isOpponentReady;
	var p_isPlayerReady;
	var p_isGameReady;
	var p_isFirstGame;
	var p_isTimerEnabled;
	var p_isHost;
	var p_score1, p_score2;
	var p_sound;
	function Main_MC ()
	{
		setClassName ("Main_MC");
		p_firstPlayer = random (2) + 1;
		p_score1 = "";
		p_score2 = "";
		p_isTimerEnabled = true;
		p_isFirstGame = true;
		setState ("title", true);
		playMusic ();
		_root._quality = "HIGH";
		TrafficManager.subscribeToEvent ("onSkypeData", this);
	}
	function state_title (event_str)
	{
		switch (event_str)
		{
		case "onButtonRelease" :
			if (p_stateFrame > 1)
			{
				setState ("game", true);
			}
			break;
		}
	}
	function state_game (event_str)
	{
		switch (event_str)
		{
		case "newGame" :
			startGame (p_isTimerEnabled);
			break;
		}
	}
	function startGame (isTimerEnabled)
	{
		p_isHost = Number (_root.LocalNumber) == 0;
		myTrace ("start game! host:" + p_isHost);
		if (p_isHost)
		{
			//we are the host, so choose the first player and start a new game)
			p_firstPlayer = random (2) + 1;
			//(p_firstPlayer == 1 ? 2 : 1);
			p_isGameReady = false;
			_root.sendData ("GameStart_" + p_firstPlayer + "_" + (isTimerEnabled ? 1 : 0));
		}
		else
		{
			//we are the guest, so send a game start request
			_root.sendData ("GameStartRequest_" + (isTimerEnabled ? 1 : 0));
		}
	}
	function onSkypeData (event_obj)
	{
		var splitData = event_obj.skypeData.split ("_");
		switch (splitData[0])
		{
		case "GameStart" :
			setState ("game", true);
			p_isGameReady = true;
			p_firstPlayer = Number (splitData[1]);
			p_isTimerEnabled = Number (splitData[2]);
			_root.sendData ("GameStartConfirm_" + p_firstPlayer);
			break;
		case "GameStartRequest" :
			if (!p_isGameReady)
			{
				startGame (Number (splitData[1]));
				if (p_state_str != "game")
				{
					setState ("game", true);
				}
			}
			break;
		case "GameStartConfirm" :
			p_isGameReady = true;
			setState ("game", true);
			break;
		case "PlayerReady" :
			p_isOpponentReady = true;
			if (!p_isPlayerReady)
			{
				game_mc.processEvent ("lockTimerButton", Number (splitData[1]));
			}
			break;
		case "SetTimerEnabled" :
			p_isTimerEnabled = Number (splitData[1]);
			if (p_state_str == "game")
			{
				game_mc.processEvent ("setTimerEnabled", p_isTimerEnabled);
			}
			break;
		case "SetOpponentScore" :
			myTrace ("player " + splitData[1] + " score is now " + splitData[2]);
			this["p_score" + splitData[1]] = Number (splitData[2]);
			break;
		}
	}
	function onGameOver ()
	{
		p_isFirstGame = false;
		p_isGameReady = false;
		p_isOpponentReady = false;
		p_isPlayerReady = false;
	}
	function onPlayerReady (timerValue)
	{
		p_isPlayerReady = true;
		_root.sendData ("PlayerReady_" + timerValue);
	}
	function get p_isAllReady ()
	{
		return (p_isGameReady && p_isOpponentReady && p_isPlayerReady);
	}
	function get p_timerValue ()
	{
		return (p_isTimerEnabled ? 1 : 0);
	}
	function initScore (playerNum)
	{
		p_playerNum = playerNum;
		if (this["p_score" + p_playerNum] == "")
		{
			if ((!_root.Score || !(Number (_root.Score))) && _root.Score != 0)
			{
				_root.Score = 1000;
			}
			myTrace ("starting score is " + _root.Score);
			this["p_score" + p_playerNum] = Number (_root.Score);
			_root.sendData ("SetOpponentScore_" + p_playerNum + "_" + _root.Score);
		}
	}
	function setScore (playerNum, increment)
	{
		if (playerNum == p_playerNum || game_mc.p_isLocal)
		{
			var newScore = Number (this["p_score" + playerNum]) + increment;
			this["p_score" + playerNum] = Math.max (newScore, 0);
			_root.sendData ("SetOpponentScore_" + p_playerNum + "_" + this["p_score" + p_playerNum]);
		}
	}
	function playMusic ()
	{
		p_sound = new Sound (this);
		p_sound.setVolume (20);
		p_sound.onSoundComplete = function ()
		{
			this["start"] ();
		};
		p_sound.attachSound ("Music_SND");
		p_sound.start (0, 999999);
	}
}
