class com.orange.utils.FrameManager extends com.orange.utils.Base_Object
{
	//static reference to the hearbeat clip
	static var HEARTBEAT_mc:MovieClip;
	//container for frame actions
	var p_frameActions_array:Array;
	//target for frame actions, all actions will be called on this object
	var p_target_obj:Object;
	//constructor	
	function FrameManager (target_obj)
	{
		setClassName ("FrameManager");
		p_frameActions_array = new Array ();
		p_target_obj = target_obj;
		//myTrace("init")
	}
	//add an action
	function addFrameAction (action_str:String)
	{
		//myTrace("adding " + arguments)
		var action_obj = new Object ();
		action_obj.p_name_str = action_str;
		//add optional arguments to the object
		action_obj.p_arguments_array = new Array ();
		if (arguments.length > 1)
		{
			for (var i = 1; i < arguments.length; i++)
			{
				action_obj.p_arguments_array.push (arguments[i]);
			}
		}
		p_frameActions_array.push (action_obj);
		if (p_frameActions_array.length == 1)
		{
			//myTrace("adding heartbeat listener")
			p_heartbeat_mc.addEventListener ("onHeartBeat", this);
		}
	}
	function onHeartBeat ()
	{
		//send out all registered actions
		for (var i = 0; i < p_frameActions_array.length; i++)
		{
			var action_obj = p_frameActions_array[i];
			//myTrace("calling " + action_obj.p_name_str)
			var isRemoved = p_target_obj[action_obj.p_name_str].apply (p_target_obj, action_obj.p_arguments_array);
			if (isRemoved)
			{
				removeFrameAction (i);
			}
		}
	}
	//remove an action
	function removeFrameAction (removeIndex, isRemoveAllInstances:Boolean)
	{
		//myTrace("removing " + arguments)
		//if argument is a string, remove last instance of that action
		if (typeof (removeIndex) == "string")
		{
			for (var i in p_frameActions_array)
			{
				if (p_frameActions_array[i].p_name_str == removeIndex)
				{
					p_frameActions_array.splice (i, 1);
					//exit if we're not removing all actions with this name
					if (!isRemoveAllInstances)
					{
						break;
					}
				}
			}
		}
		else
		{
			//numbered index, just remove that element
			p_frameActions_array.splice (removeIndex, 1);
		}
		//remove event listener
		if (p_frameActions_array.length == 0)
		{
			//myTrace("unlistening for heartbeat")
			p_heartbeat_mc.removeEventListener ("onHeartBeat", this);
		}
	}
	//remove all actions
	function removeAllActions ()
	{
		//myTrace("removing all actions")
		p_frameActions_array.length = 0;
		//myTrace("unlistening for heartbeat")
		p_heartbeat_mc.removeEventListener ("onHeartBeat", this);
	}
	//get a reference to the static heartbeat clip
	function get p_heartbeat_mc ():MovieClip
	{
		if (HEARTBEAT_mc == undefined)
		{
			//myTrace("initializing static heartbeat")
			HEARTBEAT_mc = _root.createEmptyMovieClip ("HEARTBEAT_mc", _root.getNextHighestDepth ());
			mx.events.EventDispatcher.initialize (HEARTBEAT_mc);
			HEARTBEAT_mc.onEnterFrame = function ()
			{
				this.dispatchEvent ({type:"onHeartBeat"});
			};
			HEARTBEAT_mc.onMouseDown = function ()
			{
				this.dispatchEvent ({type:"onMouseDown"});
			};
			HEARTBEAT_mc.onMouseUp = function ()
			{
				this.dispatchEvent ({type:"onMouseUp"});
			};
		}
		return (HEARTBEAT_mc);
	}
	static function initialize (target_obj)
	{
		target_obj.p_frameManager = new FrameManager (target_obj);
		target_obj.addFrameAction = function (action_str)
		{
			this["p_frameManager"].addFrameAction.apply(this["p_frameManager"], arguments);
		};
		target_obj.removeFrameAction = function (removeIndex, isRemoveAllInstances:Boolean)
		{
			this["p_frameManager"].removeFrameAction (removeIndex, isRemoveAllInstances);
		};
	}
}
