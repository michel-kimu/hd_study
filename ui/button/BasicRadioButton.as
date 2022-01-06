package ui.button
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author 
	 */
	public class BasicRadioButton extends MovieClip
	{
		private var id:int;
		
		public function BasicRadioButton():void {
			
		}
		
		public function setId(num:int):void {
				id = num;
		}
		
		public function getId():int {
				return id;	
		}
		
		public function onMouse_Down() { 
			gotoAndPlay('down');
		}
		public  function onMouse_Up() { 
			gotoAndStop('up');
		}
	}
	
}