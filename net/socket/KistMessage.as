package net.socket
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author ...
	 */
	public class KistMessage 
	{
		public var session_id:int = 0;
		public var operation_name:String;
		//public var parameters:XMLList = null;
		//public var rows:XMLList = null;
		
		public var objectrows:Array = null;
		public var parameters:Map = null;
		
		public function KistMessage() {
			parameters = new Map();
			objectrows = new Array();
			
		}
		
		public function setParameterNameOnly(paramname:String) {
			parameters.add(paramname, null);
			
		}
		
		public function addParameterValue(paramname:String, value:String) {
			var param_values:Array;
			if (parameters.getValue(paramname) != null ) {
				param_values = parameters.getValue(paramname);
			}
			else {
				param_values = new Array();
				parameters.add(paramname, param_values);
			}
			param_values.push(value);
		}
		
		public function addColumns( columns:Map ) {
			objectrows.push(columns);			
		}
		
		public function getParameterDatas(paramname) {
			return parameters.getValue(paramname);
		}
		
		public function getRows():Array {
			return objectrows;
		}
		
		public function setXMLData(xmldata:XML) 
		{	
			session_id = int(xmldata.session.@id);
			operation_name = String(xmldata.operation.@name);
			
			var parameters_xml:XMLList = xmldata.parameters.parameter;
			
			for ( var i:int = 0; i < parameters_xml.length(); i ++ ) {
				var i_xml:XML = parameters_xml[i];
				var param_name:String = String(i_xml.@name);
				var parametervalues_xml:XMLList = i_xml.value;
				var param_values:Array = new Array();
				var pvxml_length:int = parametervalues_xml.length();
				for ( var pvi:int = 0; pvi < pvxml_length; pvi ++ ) {
					var pvi_xml:XML = parametervalues_xml[pvi];
					param_values.push(String(pvi_xml[0]));
				}				
				parameters.add(param_name, param_values);
			}
			
			if (xmldata.dataset != null) {
				var rows:XMLList = xmldata.dataset.rows.row;
				for ( i = 0; i < rows.length(); i ++ ) {
					var rowxml:XML = rows[i];
					var columnlist:XMLList = rowxml.column;
					var columndata:Map = new Map();
					for ( var j:int = 0; j < columnlist.length(); j ++ ) {
						var columnxml:XML = columnlist[j];
						columndata.add(columnxml.@name, columnxml.@value);
					}
					objectrows.push(columndata);
				}
			}			
		}				
		
		public function toXMLStr() {
			var str:String = "";
			
			str += "<game_message>";
			str += '<session id ="';
			if (session_id == 0)
				str += 'not_bound';
			else	
				str += session_id;
			str += '"/>';
			str += '<operation name="' + operation_name  + '"/>';
			str += '<parameters>';
			var paramnames:Array = this.parameters.getElementNames();
			var i, j:int;
			for ( i = 0; i < paramnames.length; i ++ ) {
			//for ( var paramnamesString:String in this.parameters.getElementNames() ) {
				var param_values:Array = this.parameters.getValue(paramnames[i]);
				
				str += '<parameter name = "' + paramnames[i] + '">';
				for ( j = 0; j < param_values.length; j ++ ) {
					
					if(param_values[j] != null ) {
						str += '<value>' + param_values[j] + '</value>';
					}
				}
				str += '</parameter>';
			}
			str += '</parameters><dataset>';
			str += '<rows>';
			
			for ( i = 0; i < objectrows.length; i ++ ) {
				var row:Map = objectrows[i];
				str += '<row>';
				var columnnames:Array = row.getElementNames();
				for ( j = 0; j < columnnames.length; j ++ ) {
					var columnname:String = columnnames[j];
					str += '<column name="' + columnname + '" value="' + row.getValue(columnname) + '"/>';	
				}
				str += '</row>';
			}
			
			str += '</rows>';
			str += '</dataset>';			
			str += "</game_message>";
			
			///trace("KIST MESSAGE:" + str);
			return str;
		}
	}

}