import com.orange.utils.*;
class com.orange.utils.Resizer
{
	static var p_fn_str;
	static function initFunction ()
	{
		p_fn_str = "javascript:";
		p_fn_str += "var setSWFDimensions = function (objID,width,height) {";
		p_fn_str += "	if(document.all && !document.getElementById) {"
		p_fn_str += " 		document.all[objID].style.pixelWidth = datoX;"
		p_fn_str += " 		 		document.all[objID].style.pixelHeight = datoY;"
		p_fn_str += "	}else{"
		p_fn_str += "		document.getElementById(objID).style.width = datoX;"
		p_fn_str += "		document.getElementById(objID).style.height = datoY;"
		p_fn_str += "	}"
		p_fn_str += "}"
		/*
		p_fn_str += "if (objID && width && height) {";
		p_fn_str += "var fObj = document.getElementById(objID);";
		p_fn_str += "var fEmb = document.getElementById(objID+'-embed');";
		p_fn_str += "if (fObj && fObj.style) {";
		p_fn_str += "fObj.style.width = width+'px';";
		p_fn_str += "fObj.style.height = height+'px';";
		p_fn_str += "alert('Setting object dimensions ' + fObj.style.width);"
		p_fn_str += "}";
		p_fn_str += "if (fEmb != null) {";
		p_fn_str += "fEmb.width = width;";
		p_fn_str += "fEmb.height = height;";
		p_fn_str += "if (fEmb.style) {";
		p_fn_str += "fEmb.style.width = width+'px';";
		p_fn_str += "fEmb.style.height = height+'px';";
		p_fn_str += "}";
		p_fn_str += "}";
		p_fn_str += "}";
		p_fn_str += "}";
		*/
		URLManager.doURL (p_fn_str);
	}
	static function setElementSize (id_str, newWidth, newHeight)
	{
		if (!p_fn_str)
		{
			initFunction ();
		}
		var url_str = ("javascript:setSWFDimensions('" + id_str + "', " + newWidth + ", " + newHeight + ");");
		URLManager.doURL (url_str);
	}
}
