import mx.events.EventDispatcher;
import com.orange.utils.Debug;
class com.orange.utils.XMLLoader extends XML
{
	//constants
	static var ELEMENT_NODE:Number = 1;
	static var TEXT_NODE:Number = 3;
	//scope of this object, for callbacks
	var p_scope_obj:Object;
	//url of xml file
	var p_url_str:String;
	//list of nodeNames to watch for
	private var _watchList_obj:Object;
	//added by Debug
	var myTrace:Function;
	// functions added by EventDispatcher
	public var addEventListener:Function;
	public var removeEventListener:Function;
	private var dispatchEvent:Function;
	//constructor
	function XMLLoader (scope_obj:Object)
	{
		EventDispatcher.initialize (this);
		Debug.initialize (this, "XMLLoader");
		this.ignoreWhite = true;
		this.p_scope_obj = scope_obj;
		addEventListener ("onXMLLoad", p_scope_obj);
		addEventListener ("onXMLNodeFound", p_scope_obj);
		addEventListener ("onXMLError", p_scope_obj);
	}
	//load
	function load (url_str:String)
	{
		myTrace ("LOADING XML FILE " + url_str);
		p_url_str = url_str;
		super.load (url_str);
	}
	//called when xml file loads
	function onLoad (isSuccess)
	{
		if (isSuccess && this.status == 0)
		{
			findWatchNodes ();
			myTrace("LOADED " + p_url_str)
			dispatchEvent ({type:"onXMLLoad", target:this});
		}
		else
		{
			if (isSuccess)
			{
				var errorMessage:String;
				switch (this.status)
				{
				case 0 :
					errorMessage = "No error; parse was completed successfully.";
					break;
				case -2 :
					errorMessage = "A CDATA section was not properly terminated.";
					break;
				case -3 :
					errorMessage = "The XML declaration was not properly terminated.";
					break;
				case -4 :
					errorMessage = "The DOCTYPE declaration was not properly terminated.";
					break;
				case -5 :
					errorMessage = "A comment was not properly terminated.";
					break;
				case -6 :
					errorMessage = "An XML element was malformed.";
					break;
				case -7 :
					errorMessage = "Out of memory.";
					break;
				case -8 :
					errorMessage = "An attribute value was not properly terminated.";
					break;
				case -9 :
					errorMessage = "A start-tag was not matched with an end-tag.";
					break;
				case -10 :
					errorMessage = "An end-tag was encountered without a matching start-tag.";
					break;
				default :
					errorMessage = "An unknown error has occurred.";
					break;
				}
				myTrace ("ERROR: " + errorMessage);
			}
			else
			{
				myTrace ("ERROR: Failed to load XML");
			}
			dispatchEvent ({type:"onXMLError", target:this});
		}
	}
	//called when a watchnode is found
	function dispatchNodeEvent (found_xmlnode:XMLNode)
	{
		dispatchEvent ({type:"onXMLNodeFound", target:this, xmlnode:found_xmlnode, nodeName:found_xmlnode.nodeName});
	}
	//add a nodeName to the watchlist
	function addWatchNode (nodeName_str:String)
	{
		if (this._watchList_obj == undefined)
		{
			this._watchList_obj = new Object ();
		}
		_watchList_obj[nodeName_str] = true;
	}
	//remove a nodename from the watchlist
	function removeWatchNode (nodeName_str:String)
	{
		delete _watchList_obj[nodeName_str];
	}
	//parse all data in xml to find watch nodes
	function findWatchNodes ()
	{
		parseNode (this);
	}
	//parse an individual xml node to find watch nodes
	function parseNode (this_xmlnode:XMLNode)
	{
		if (this._watchList_obj == undefined)
		{
			return;
		}
		if (this_xmlnode.nodeType == ELEMENT_NODE)
		{
			//if nodeName is in the watchlist, pass it to the scope
			if (_watchList_obj[this_xmlnode.nodeName])
			{
				dispatchNodeEvent (this_xmlnode);
			}
			//recursively parse child nodes          
			for (var i = 0; i < this_xmlnode.childNodes.length; i++)
			{
				parseNode (this_xmlnode.childNodes[i]);
			}
		}
	}
	//get the first child node with a specified nodename
	static function getNodeData (nodeName_str, which_xmlnode)
	{
		for (var i = 0; i < which_xmlnode.childNodes.length; i++)
		{
			var child_xmlnode = which_xmlnode.childNodes[i];
			if (child_xmlnode.nodeName == nodeName_str)
			{
				return (child_xmlnode.firstChild.nodeValue);
			}
		}
	}
}
