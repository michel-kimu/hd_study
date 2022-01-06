package ui.timer
{
	import flash.events.Event;
 
	/**
	 * ...
	 * @author 
	 */
	public class TimerClock extends WatchControl 
	{
		public var min:String;
		public var sec:String;

		public function TimeBar() {
			Init();
		}
		public function Init():void {
			MIN_VIEW.text = "";
			SEC_VIEW.text = "";
			MC_GAUGE.Update(0);
		}
		
		public function setTimer(min:String="00", sec:String="00"):void {
			this.min = min;
			this.sec = sec;
			run();
			//DisplayTimerInfo(min, sec);
		}

		override public function UpdateTimer(ratio :Number) :void
		{
			var percent :Number = ratio * 100;
	
			var outPutNum:Number = ratio;
			if (percent > 100) percent %= 100;
			
			//MC_ARROW.rotation = 360 * percent / 100;  //초침
			MC_GAUGE.Update(ratio);
			 
		}

		private var oldMin:String = "0"; //시작 직후 "REMAIN_FIVE_SECONDS" 이벤트 발생을 억제하기 위해
		
		override public function DisplayTimerInfo(min:String, sec:String):void {
			MIN_VIEW.setText(min);
		//	MIN_VIEW.text = min;
			SEC_VIEW.text = String(parseInt(sec) + 0);;
		}
		
		public function run():void {
			super.Start(Number(min));
		}
	}
	
}