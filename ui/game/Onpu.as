package ui.game
{
	import flash.display.MovieClip;
	
	public class Onpu extends MovieClip
	{
		private var fncSound:Function;
		
		public function Onpu()
		{
			this.mouseEnabled = false;
			this.mouseChildren = false; //마우스 반응 않하게
		}
		
		public function Init(fnc:Function):void{
			fncSound = fnc;
		}
		
		public function fin():void{
		 	//trace('음표 종료');
		}
		
		public function playOnpu():void{
			if (fncSound!=null) fncSound();
		}
	}
}