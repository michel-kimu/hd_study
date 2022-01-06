package ui.timer
{
	
	/**
	 * ...
	 * @author 
	 */
	public class TimerBar extends WatchControl 
	{
		public var min:String;
		public var sec:String;
		
		public var currentMin:String;
		public var currentSec:String;
		
		public var fncTimeOver:Function;
		
		public function TimeBar() {
			Init();
		}
		
		public function Init():void {
			MIN_VIEW.text = "--";
			SEC_VIEW.text = "--";
			MC_LINER.Init();
		}
		
		public function setTimer(func:Function = null, min:String="00", sec:String="00" ):void {
			this.min = min;
			this.sec = sec;
		
			Init();
			
			fncTimeOver = func;
			
			//trace('>fncTimeOver' + fncTimeOver);
			
			//DisplayTimerInfo(min, sec);
		}
		
		override public function UpdateTimer(ratio :Number) :void
		{
			var percent :Number = ratio * 100;
			//var outPutNum:Number = ratio;
			if (percent > 100) percent %= 100;
			
			MC_LINER.Update(ratio);
		}
		
		override public function DisplayTimerInfo(min:String, sec:String):void {
			
			currentMin = min;
			currentSec = sec;
			
			MIN_VIEW.text = currentMin;
			SEC_VIEW.text = currentSec;
		}
		
		public function run():void {
			trace("바 타이머 시작");
			super.Start(Number(min));
		}
		
		public function getMin():String {
			return currentMin;
		}
		
		public function getSec():String {
			return currentSec;
		}
		
		override protected  function time_is_over():void{
			//trace('fncTimeOver' + fncTimeOver);
			if (fncTimeOver != null){
				fncTimeOver();
			}
		}
	}
	
}