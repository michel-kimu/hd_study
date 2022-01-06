package ui.timer
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getTimer;
	/**
	 * ...
	 * m.kim 2012.06.14
	 */
	public class TimerWatchClass 
	{
		private var tgt_clip:MovieClip;
		private var callback:Function;
		private var at_start:uint;
		private var now_time:uint;
		private var max_time:uint;
		private var complete:Boolean;
		private var is_pause:Boolean;
		
		public var lastTime:Number;
		public var MinKeta:Number;
		public var SecKeta:Number;
		
		public function TimerWatchClass(tgt:MovieClip)
		{
			tgt_clip = tgt;
		}
		
		/* 수동 디스트럭터(타이머 종료) */
		public function kill():void
		{
			trace('timer kill()!!!!!!!!!!!!');
			tgt_clip.removeEventListener(Event.ENTER_FRAME, OnProgress);
			
			tgt_clip = null;
			callback = null;
		}
		
		/* 타이머 시작*/
		public function Start(max:uint, cbk:Function):void
		{
			is_pause = false;
			
			callback = cbk;
			now_time = 0;
			max_time = max;
			complete = false;


			if (! tgt_clip.hasEventListener(Event.ENTER_FRAME)) {
				tgt_clip.addEventListener(Event.ENTER_FRAME, OnProgress);
			}
			at_start = getTimer();
		}
		
		/* 타이머 정지 */
		public function Pause():void
		{
			is_pause = true;
		}
		
		/* 타이머 개시 */
		public function Resume():void
		{
			is_pause = false;
			at_start = getTimer() - now_time;
		}
		
		/* 타이머 이벤트 */
		private function OnProgress(event:Event):void
		{
			if (is_pause)return;
			
			now_time = getTimer() - at_start;
			if (now_time >= max_time)
			{
				//now_time = max_time;
				if (callback == null)
				{
					trace("null");
				}
				else
				{
					callback.call(null, (!complete ? "complete" : "completed"), now_time);
				}
				complete = true;
				return;
			}
			callback.call(null, "progress", now_time);
			
			lastTime = (max_time - now_time)
			MinKeta = int(lastTime / 1000)
			SecKeta = lastTime % 1000
		}
	}
}