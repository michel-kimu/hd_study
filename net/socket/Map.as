package net.socket
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Krucef
	 */
	public class Map extends Object 
	{
		private var array_names:Array = null;
		private var array_datas:Array = null;
		
		public function Map() 
		{
			array_names = new Array();
			array_datas = new Array(); 
		}
		
		public function add( ename:String, evalue ) {
			var ani:int = array_names.indexOf(ename);
			if( ani == -1 )	{
				array_names.push(ename);
				array_datas.push(evalue);
			} else {
				array_datas[ani] = evalue;
			}			
		}
		
		public function remove( ename:String ) {
			if ( this[ename] != null) {
				this[ename] = null;
			}
		}
		
		public function findStr( ename:String ) {
			if (array_names.indexOf(ename) != -1) {
				return ename;
			}
			return null;
		}
		
		public function getValue(ename:String) {
			var ani:int = array_names.indexOf(ename);
			if( ani != -1 )	{			
				return array_datas[ani];				
			}
			return null;
		}
		
		public function getElementNames():Array {
			return array_names;
		}
		
		public function length():int {
			return array_names.length;
		}				
	}

}