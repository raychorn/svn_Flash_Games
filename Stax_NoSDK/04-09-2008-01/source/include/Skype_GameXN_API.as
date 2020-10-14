//this operates the Skype GameXN API 
//It is used to communicate between 2 Skpye Clients.
//Public calls
//called by the game server. does the opponent handshake and provided names and addresses.
this.initGame = function ()
{
	PlayersNames = PlayersIdentifiersList.split (';');
	PlayersDspNames = PlayersDisplayNamesList.split (';');
	MyName = PlayersNames[LocalNumber];
	//myTrace ("LocalNumber is " + LocalNumber);
	//myTrace ("MyName is " + MyName);
	//
	ServerName = PlayersNames[ServerIdentifier];
	//myTrace ("ServerIdentifier is " + ServerIdentifier);
	//myTrace ("ServerName is " + ServerName);
	//Set up the local player's name
	MyDspName = PlayersDspNames[LocalNumber];
	//myTrace ("LocalNumber is " + LocalNumber);
	//myTrace ("MyDspName is " + MyDspName);
	//myNameField.text = MyDspName;
	//Set up the opponent's name
	if (LocalNumber == 0)
	{
		OpponentDspName = PlayersDspNames[1];
	}
	else
	{
		OpponentDspName = PlayersDspNames[0];
	}
	//OpponentNameField.text = OpponentDspName;
};
this.sendData = function (datatoSend)
{
	myTrace ("sending skype data " + datatoSend);
	//format requires the * & @. Anything after that is fine. 
	fscommand (sSendDataInt, "*@" + datatoSend);
	turnIndicatorField.text = "Wait";
	BtnSendData._visible = false;
	//receiveData (datatoSend);
};
//called automatically when the game receives data from the other player. Normally for recieving the player's last move.
this.receiveData = function (dataToReceive)
{
	myTrace ("received skype data " + dataToReceive);
	com.orange.utils.TrafficManager.publishEvent ({type:"onSkypeData", skypeData:dataToReceive});
};
//////////////////////////////////////////////////////////////
//Extra Events (not needed for the simple version of stax);
///////////////////////////////////////////////////////////////
//event called by the server.
this.EndGame = function (localScore)
{
	fscommand(sEndGameInt, localScore);
	//myTrace ("Endgame has been called");
};
this.FinishedLoading = function(){
	myTrace ("FinishedLoading has been called");
	fscommand(sGameLoaded);
}
//event called by the server. 
this.LoadGame = function ()
{
	//myTrace ("LoadGame has been called");
};
this.OpponentReady = function ()
{
	//myTrace ("OpponentReady has been called");
};
this.NewGame = function ()
{
	//myTrace ("NewGame has been called");
};
this.RequestRemovePlayer = function (val1, val2)
{
	//myTrace ("RequestRemovePlayer has been called with " + val + " " + val2);
};
this.RemovePlayer = function (val1)
{
	//myTrace ("RemovePlayer has been called with " + val);
};
this.RequestAddPlayer = function (val1, val2)
{
	//myTrace ("RequestAddPlayer has been called with " + val + " " + val2);
};
//vars populated by the game server.
Command = '';
Data = '';
sYourTurn = '';
sPleaseWait = '';
sMoveInfo = '';
sYouLose = '';
sYouWin = '';
IsServer = '';
ServerIdentifier = '';
PlayersIdentifiersList = '';
LocalNumber = '';
PlayersDisplayNamesList = '';
Score = '';
//------  Command constants:
//---->  Flash
sInitExt = 'cmdinit';
sReceiveDataExt = 'cmdreceivedata';
sNewGameExt = 'cmdnewgame';
sLoadGameExt = 'cmdloadgame';
sSaveGameExt = 'cmdgetsavedata';
sPartnerReadyExt = 'cmdplayerready';
sSetScoreExt = 'cmdsetscore';
sClearScoreExt = 'cmdclearscore';
sAddPlayerExt = 'cmdaddplayer';
sAddObserver = 'cmdaddobserver';
sHostRemovePlayerExt = 'cmdhostremoveplayer';
sGetPlayStateExt = 'cmdgetgamereplica';
sSetPlayStateExt = 'cmdapplygamereplica';
sAbortRequestAddExt = 'cmdcanceladdplayerquery';
//<----  Flash
sSendDataInt = 'cmdSendData';
sEndGameInt = 'cmdEndGame';
sSaveGameInt = 'cmdSetGameData';
sSavePreference = 'cmdSavePreference';
sGameRemovePlayerInt = 'cmdGameRemovePlayer';
sReturnGameStateInt = 'cmdSendGameReplica';
sCloseGameInt = 'cmdCloseGame';
sRequestAddPlayerInt = 'cmdQueryAddPlayer';
sStartSessionInt = 'cmdStartSession';
sStopSessionInt = 'cmdStopSession';
sGameLoaded = 'cmdGameLoaded';
//	Flash  ----> Flash
sLoadGameInt = 'cmdloadgame';
sSetScoreInt = 'cmdsetscore';
sReadyInt = 'ready';
sRequestRemovePlayerInt = 'cmdReqRemovePlayer';
sAllowAddPlayerInt = 'cmdAllowAddPlayer';
sAllowRemovePlayerInt = 'cmdAllowRemovePlayer';
sToServer = 'toServer';

this.WatchCommand = function (_prop, _old, Command)
{
	if (Command != undefined)
	{
		fscommand ('cmdDebug', 'Command: ' + Command + ';   data: ' + Data);
		Command = Command.toLowerCase ();
		if (Command == sReceiveDataExt)
		{
			//myTrace ("sReceiveDataExt has been called");
			DataValue = Data.split ('&');
			//myTrace ("data is " + DataValue[0]);
			if (DataValue[0] == sEndGameInt)
			{
				//end game code
				EndGame ();
			}
			else if (DataValue[0] == sLoadGameInt)
			{
				//load game code
				LoadGame ();
			}
			else if (DataValue[0] == sSetScoreInt)
			{
				//myTrace ("sSetScoreInt has been passed");
				//setScore event called
			}
			else if (DataValue[0] == sReadyInt)
			{
				//call opponentReady
				OpponentReady ();
			}
			else if (DataValue[0] == sNewGameExt)
			{
				if (ServerName == MyName)
				{
					fscommand (sSendDataInt, '*' + '@' + sNewGameExt);
				}
				NewGame ();
			}
			else if (DataValue[0] == sRequestRemovePlayerInt)
			{
				RequestRemovePlayer (DataValue[1], DataValue[2]);
			}
			else if (DataValue[0] == sAllowRemovePlayerInt)
			{
				fscommand (sGameRemovePlayerInt, DataValue[1]);
				fscommand (sSendDataInt, '*' + '@' + sGameRemovePlayerInt + '&' + DataValue[1]);
				//call removePlayer command
				RemovePlayer (DataValue[1]);
			}
			else if (DataValue[0] == sGameRemovePlayerInt)
			{
				RemovePlayer (DataValue[1]);
			}
			else if (DataValue[0] == sRequestAddPlayerInt)
			{
				RequestAddPlayer (DataValue[1], DataValue[2]);
				/*if (MultiPlayer.getPlayersCnt()<MultiPlayer.MaxPlayers) {
				fscommand(sSendDataInt, DataValue[1]+'@'+sAllowAddPlayerInt);
				//need to put a call in here.
				}
				*/
			}
			else if (DataValue[0] == sAbortRequestAddExt)
			{
				MultiPlayer.UnReservePlayer ();
				//need to put a call in here.
			}
			else if (DataValue[0] == sAllowAddPlayerInt)
			{
				fscommand (sRequestAddPlayerInt, '');
			}
			else
			{
				Check = GameController.CheckField (Data);
				if (DataValue[3] == sToServer)
				{
					(Check) ? fscommand (sSendDataInt, '*' + '@' + DataValue[0] + '&' + DataValue[1] + '&' + DataValue[2]) : '';
					if (ServerName == MyName && Check)
					{
						//GameController.AlienMove(Data);
					}
				}
				else
				{
					//GameController.AlienMove(Data);
					receiveData (Data);
				}
			}
		}
		if (Command == sInitExt)
		{
			//put calls in to start game.
			initGame ();
		}
		if (Command == sPartnerReadyExt)
		{
			turnIndicatorField.text = "Wait";
			if (Data == '0')
			{
				//MultiPlayer.IamObserver = false;
				//MultiPlayer.removePlayer(MultiPlayer.MyName);
				//mc_youAreObserver._visible = false;
				//MultiPlayer.addPlayer(MultiPlayer, MultiPlayer.MyName, MultiPlayer.MyDspName);
			}
			else
			{
				//BtnAddPlayer._visible = false;
			}
			//PartnerReady = true;
			//PartnerIsReadyExterior();
			if (ServerName != MyName)
			{
				fscommand (sSendDataInt, ServerName + '@' + sReadyInt + '&' + MyName);
			}
		}
		if (Command == sClearScoreExt)
		{
		}
		if (Command == sNewGameExt)
		{
			fscommand (sSendDataInt, ServerName + '@' + sNewGameExt);
		}
		if (Command == sSaveGameExt)
		{
			fscommand (sSaveGameInt, ReturnGameState ());
		}
		if (Command == sLoadGameExt)
		{
			if ((Data != undefined) and (Data != ''))
			{
				LoadGame (Data, true);
				fscommand (sSendDataInt, '*' + '@' + sLoadGameInt + '&' + Data);
			}
		}
		if (Command == sGetPlayStateExt)
		{
			fscommand (sReturnGameStateInt, ReturnGameState () + '&' + getPlayersNo ());
		}
		if (Command == sSetPlayStateExt)
		{
			StateSplit = Data.split ('&');
			GameController.LoadGame (StateSplit[0]);
			MultiPlayer.setPlayersNo (StateSplit[1]);
		}
		if (Command == sAddPlayerExt)
		{
			addParams = Data.split (':');
			if (MultiPlayer.ServerName != MultiPlayer.MyName)
			{
				MultiPlayer.UnReservePlayer ();
			}
			MultiPlayer.addPlayer (MultiPlayer, addParams[0], addParams[1]);
		}
		if (Command == sAddObserver)
		{
			addParams = Data.split (':');
			MultiPlayer.addObserver (MultiPlayer, addParams[0], addParams[1]);
		}
		if (Command == sHostRemovePlayerExt)
		{
			RemovePlayer (Data);
		}
		if (Command == sAbortRequestAddExt)
		{
			fscommand (sSendDataInt, MultiPlayer.ServerName + '@' + sAbortRequestAddExt);
		}
	}
};
function myTrace (msg)
{
	com.orange.utils.Debug.myTrace ("Skype", "_root", msg);
}
this.watch ('Command', this.WatchCommand);
myTrace ("Skype API initialized");
