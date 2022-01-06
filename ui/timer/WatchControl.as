package ui.timer
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * m.kim   2012.06.14
	 */
	public class WatchControl extends MovieClip
	{
		private var is_pause:Boolean; 					//일시정지
		private var game_timer:TimerWatchClass; 		//게임 타이머
		private var game_time :uint;					//게임 총시간
		
		
		public function WatchControl()
		{
			addEventListener(Event.REMOVED_FROM_STAGE, destruct);
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
		
			is_pause = false;
			game_timer = new TimerWatchClass(this);
		}
		
		public function Start(sec:Number):void {
			game_time = sec * 1000;
			game_timer.Start(game_time, OnGameProgress);
		}
		
		public function Pause():void {
			game_timer.Pause();
		}
		
		public function Resume():void {
			game_timer.Resume()
		}
		
		public function Kill():void {
			game_timer.kill();
		}
 
		function OnGameProgress(status:String, passed:uint):void
		{
			switch (status)
			{
				case "progress": 
					//경과 시간의 표시
					
					UpdateTimer(passed / game_time);
					
					if (!isNaN(game_timer.MinKeta)){
						var min:String = (int(game_timer.MinKeta)+1) + "";
						//var sec:String = (game_timer.SecKeta).toFixed( 0 ) + "";
						var tmp:String = game_timer.SecKeta.toString();
						var sec:String = tmp.substring(0,2);
						
						
						DisplayTimerInfo(min, sec);
						
						/*if (passed >= 30 * 1000)
						{
							trace("30초");
							return;
						}*/
					}

					break;
				case "complete": 
					trace("타임 오버");
					
					UpdateTimer(1.0);

					DisplayTimerInfo("0", "00");
					
					if (game_timer != null)
					{
						//game_timer.kill();
						//game_timer = null;
					}
					
					dispatchEvent(new Event(Event.COMPLETE));
					
					break;
				case "completed": 
					// 타임오버 완료
					break;
			}
		}
		private function destruct(e:Event):void
		{
			trace('timer removed!!!');
			removeEventListener(Event.REMOVED_FROM_STAGE, destruct);
			if(game_timer){
				game_timer.kill()
				game_timer = null;
			}
		}

		public function UpdateTimer(ratio :Number):void {
		}
		public function DisplayTimerInfo(min:String, sec:String):void {
		}
	}
}