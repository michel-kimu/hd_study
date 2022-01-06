package transition {

	import fl.transitions.*;
	import fl.transitions.easing.*;
	import flash.display.*;
	import flash.events.*;

	public class PopupAction extends EventDispatcher{

		static public const SHOW_START:String		= "showStart";
		static public const SHOW_FINISH:String		= "showFinish";
		static public const HIDE_START:String		= "hideStart";
		static public const HIDE_FINISH:String		= "hideFinish";
		
		private static var tweenKeeper:Array = [];

		private var _stage:Stage = null;
		private var target:DisplayObject;
		private var tweenY:Tween;
		private var tweenA:Tween;

		public function PopupAction(_target:DisplayObject):void{
			target = _target;
			target.alpha = 0;
			if(target.stage != null){
				_stage = target.stage;
				setCenter();
				_stage.addEventListener(Event.RESIZE,resizeHandler);
				target.addEventListener(Event.REMOVED_FROM_STAGE,removedHandler);
			}else{
				target.addEventListener(Event.ADDED_TO_STAGE,addedHandler);
			}
		}

		private function addedHandler(e:Event):void{
			if(e.currentTarget == e.target){
				e.target.removeEventListener(e.type,arguments.callee);
				_stage = target.stage;
				setCenter();
				_stage.addEventListener(Event.RESIZE,resizeHandler);
				target.addEventListener(Event.REMOVED_FROM_STAGE,removedHandler);
			}
		}

		private function removedHandler(e:Event):void{
			if(e.currentTarget == e.target){
				e.target.removeEventListener(e.type,arguments.callee);
				target.addEventListener(Event.ADDED_TO_STAGE,addedHandler);
				_stage.removeEventListener(Event.RESIZE,resizeHandler);
			}
		}

		private function resizeHandler(e:Event):void{
			stop();
			target.alpha = 1;
			setCenter();
		}

		public function setCenter():void{
			if(_stage != null){
				target.x = Math.round(_stage.stageWidth / 2);
				target.y = Math.round(_stage.stageHeight / 2);
			}
		}

		public function show():void{
			setCenter();
			target.alpha = 0;
			tweenY = new Tween(target,"y",Regular.easeOut,target.y + 80,target.y,0.2,true); //10
			tweenA = new Tween(target,"alpha",Regular.easeOut,target.alpha,1.0,0.2,true);
			addKeeper(tweenY);
			addKeeper(tweenA);
			addShowEventListener(tweenY);
		}

		public function hide():void{
			setCenter();
			target.alpha = 1;
			tweenY = new Tween(target,"y",Regular.easeIn,target.y,target.y - 80,0.1,true);
			tweenA = new Tween(target,"alpha",Regular.easeIn,target.alpha,0,0.1,true);
			addKeeper(tweenY);
			addKeeper(tweenA);
			addHideEventListener(tweenY);
		}

		public function stop():void{
			if(isPlaying){
				tweenY.stop();
				tweenA.stop();
			}
			if(tweenY is Tween){
				removeShowEventListener(tweenY);
				removeHideEventListener(tweenY);
			}
			removeKeeper(tweenY);
			removeKeeper(tweenA);
		}

		public function get isPlaying():Boolean{
			return tweenY && tweenY.isPlaying;
		}

		private function addKeeper(target:Tween):void{
			tweenKeeper.push(target);
		}

		private function removeKeeper(target:Tween):void{
			var index:int = tweenKeeper.indexOf(target);
			if(index != -1)tweenKeeper.splice(index,1);
		}

		private function addShowEventListener(target:Tween):void{
			target.addEventListener(TweenEvent.MOTION_START,showStartHandler);
			target.addEventListener(TweenEvent.MOTION_STOP,showStopHandler);
			target.addEventListener(TweenEvent.MOTION_FINISH,showFinishHandler);
		}

		private function removeShowEventListener(target:Tween):void{
			target.removeEventListener(TweenEvent.MOTION_START,showStartHandler);
			target.removeEventListener(TweenEvent.MOTION_STOP,showStopHandler);
			target.removeEventListener(TweenEvent.MOTION_FINISH,showFinishHandler);
		}

		private function addHideEventListener(target:Tween):void{
			target.addEventListener(TweenEvent.MOTION_START,hideStartHandler);
			target.addEventListener(TweenEvent.MOTION_STOP,hideStopHandler);
			target.addEventListener(TweenEvent.MOTION_FINISH,hideFinishHandler);
		}

		private function removeHideEventListener(target:Tween):void{
			target.removeEventListener(TweenEvent.MOTION_START,hideStartHandler);
			target.removeEventListener(TweenEvent.MOTION_STOP,hideStopHandler);
			target.removeEventListener(TweenEvent.MOTION_FINISH,hideFinishHandler);
		}
		
		private function showStartHandler(e:TweenEvent):void{
			dispatchEvent(new Event(SHOW_START));
		}

		private function showStopHandler(e:TweenEvent):void{
			removeKeeper(tweenY);
			removeKeeper(tweenA);
			removeShowEventListener(e.target as Tween);
			
			dispatchEvent(new Event(SHOW_FINISH));
		}

		private function showFinishHandler(e:TweenEvent):void{
			removeKeeper(tweenY);
			removeKeeper(tweenA);
			removeShowEventListener(e.target as Tween);

			dispatchEvent(new Event(SHOW_FINISH));
		}

		private function hideStartHandler(e:TweenEvent):void{
			dispatchEvent(new Event(HIDE_START));
		}

		private function hideStopHandler(e:TweenEvent):void{
			removeKeeper(tweenY);
			removeKeeper(tweenA);
			removeHideEventListener(e.target as Tween);
			
			dispatchEvent(new Event(HIDE_FINISH));
		}

		private function hideFinishHandler(e:TweenEvent):void{
			removeKeeper(tweenY);
			removeKeeper(tweenA);
			removeHideEventListener(e.target as Tween);
			
			dispatchEvent(new Event(HIDE_FINISH));
		}
	}
}