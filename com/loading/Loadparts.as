package com.loading{
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	
	/* @author zawa aka dubfrog */ 
	
	public class Loadparts extends Sprite{
		private var color:Number;
		private var size:Number;
		private var bool:Boolean;
		private var parts:Array;
		private var timer:Timer;
		private var cnt:Number;
		
		public function Loadparts(_color:Number = 0x000000, _size:Number = 5):void{
			color = _color;
			size = _size;
			createLoader();
		}
		private function createLoader():void
		{
			var radian:Number = Math.PI / 180;
			var cutmax:Number = 12;
			var radius:Number = size;
			parts = [];
			for (var i = 0; i <= cutmax-1; i++)
			{
				var angle:Number = (360 / cutmax) * i;
				var mc:Sprite = partsRect();
				mc.x = Math.sin(radian * angle) * radius;
				mc.y = Math.cos(radian * angle) * radius;
				mc.rotation = -angle;
				mc.alpha = .3;
				addChild(mc);
				parts[i] = mc;
			}
		}
		private function partsRect():Sprite 
		{
			var mc:Sprite = new Sprite();
			mc.graphics.beginFill(color);
			mc.graphics.drawRoundRect(-(size / 4)/2, -(size / 1.5)/2, size / 4, size, size / 3);
			mc.graphics.endFill();
			return mc;
		}
		public function start():void
		{
			cnt = 0;
			bool = true;
			timer = new Timer(40, 0);
			timer.addEventListener(TimerEvent.TIMER, loading);
			timer.start();
		}
		private function reset():void
		{
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, loading);
			timer = null;
			
			for (var i = 0; i <= parts.length - 1; i++) {
				parts[i].removeEventListener(Event.ENTER_FRAME, alphaup);
			}
		}
		private function loading(e:TimerEvent):void
		{
			if (bool)
			{
				parts[cnt].alpha = 1;
				parts[cnt].removeEventListener(Event.ENTER_FRAME, alphaup);
				parts[cnt].addEventListener(Event.ENTER_FRAME, alphaup);
				cnt--;
				if (cnt < 0) cnt = parts.length - 1;
			}
		}
		private function alphaup(e:Event):void
		{
			var target = e.target;
			target.alpha += (.3 - target.alpha) * .1;
		}
		public function stop():void
		{
			reset();
		}
		

	}
}