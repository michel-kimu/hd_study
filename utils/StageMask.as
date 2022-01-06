package utils{

	import flash.display.*;
	import flash.events.*;

	public class StageMask extends Shape{

		private var _color:uint;
		private var _stage:Stage;

		public function StageMask(color:uint = 0):void{

			_color = color;
			refresh();

			if(stage == null){
				addEventListener(Event.ADDED_TO_STAGE,eventHandler);
			}else{
				_stage = stage;
				_stage.addEventListener(Event.RESIZE,eventHandler);
				addEventListener(Event.REMOVED_FROM_STAGE,eventHandler);
			}
		}

		//색
		public function get color():uint{
			return _color;
		}
		public function set color(__color:uint):void{
			_color = __color;
			refresh();
		}

		//자멸
		public function clear():void{
			if(parent)parent.removeChild(this);
			graphics.clear();
			_stage.addEventListener(Event.RESIZE,eventHandler);
			removeEventListener(Event.ADDED_TO_STAGE,eventHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE,eventHandler);
			_stage = null;
		}

		/*
		 * Event Handler
		 */
		private function eventHandler(e:Event):void{
			if(e.currentTarget != e.target)return;
			switch(e.type){

				case Event.RESIZE:							
					if(_stage == null)return;
					width = Math.ceil(_stage.stageWidth);
					height = Math.ceil(_stage.stageHeight);
				break;

				case Event.ADDED_TO_STAGE:	//배치되면 리사이즈를 개시
					_stage = stage;
					refresh();
					eventHandler(new Event(Event.RESIZE));
					_stage.addEventListener(Event.RESIZE,eventHandler);
					removeEventListener(Event.ADDED_TO_STAGE,eventHandler);
					addEventListener(Event.REMOVED_FROM_STAGE,eventHandler);
				break;

				case Event.REMOVED_FROM_STAGE:	//리사이즈 종료
					_stage.removeEventListener(Event.RESIZE,eventHandler);
					removeEventListener(Event.REMOVED_FROM_STAGE,eventHandler);
					addEventListener(Event.ADDED_TO_STAGE,eventHandler);
				break;
			}
		}

		//
		private function refresh():void{
			if (_stage == null) return;
			
			graphics.clear();
			graphics.beginFill(_color,0.5);
			graphics.drawRect(0, 0, 1, 1);
		}
	}
}
