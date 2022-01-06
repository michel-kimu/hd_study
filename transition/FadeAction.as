package transition{

	import fl.transitions.*;
	import fl.transitions.easing.*;
	import flash.display.*;
	import flash.events.*;

	public class FadeAction extends EventDispatcher{

		private static var tweenKeeper:Array = [];

		private var target:DisplayObject;
		private var tweenA:Tween;

		public function FadeAction(target:DisplayObject):void{
			this.target = target;
		}

		public function show(_alpha:Number = 1,delay:Number = 0.1):void{
			tweenA = new Tween(target,"alpha",None.easeInOut,target.alpha,_alpha,delay,true);
			addKeeper(tweenA);
			addShowEventListener(tweenA);
		}

		public function hide(_alpha:Number = 0,delay:Number = 0.1):void{
			tweenA = new Tween(target,"alpha",None.easeInOut,target.alpha,_alpha,delay,true);
			addKeeper(tweenA);
			addHideEventListener(tweenA);
		}

		public function stop():void{
			if(isPlaying){
				tweenA.stop();
			}
			if(tweenA is Tween){
				removeShowEventListener(tweenA);
				removeHideEventListener(tweenA);
			}
			removeKeeper(tweenA);
		}

		public function get isPlaying():Boolean{
			return tweenA && tweenA.isPlaying;
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
			target.addEventListener(TweenEvent.MOTION_FINISH,showFinishHandler);
		}

		private function removeShowEventListener(target:Tween):void{
			target.removeEventListener(TweenEvent.MOTION_START,showStartHandler);
			target.removeEventListener(TweenEvent.MOTION_FINISH,showFinishHandler);
		}

		private function addHideEventListener(target:Tween):void{
			target.addEventListener(TweenEvent.MOTION_START,hideStartHandler);
			target.addEventListener(TweenEvent.MOTION_FINISH,hideFinishHandler);
		}

		private function removeHideEventListener(target:Tween):void{
			target.removeEventListener(TweenEvent.MOTION_START,hideStartHandler);
			target.removeEventListener(TweenEvent.MOTION_FINISH,hideFinishHandler);
		}

		private function showStartHandler(e:TweenEvent):void{
			dispatchEvent(new Event("showStart"));
		}

		private function showFinishHandler(e:TweenEvent):void{
			removeKeeper(tweenA);
			removeShowEventListener(e.target as Tween);
			dispatchEvent(new Event("showFinish"));
		}

		private function hideStartHandler(e:TweenEvent):void{
			dispatchEvent(new Event("hideStart"));
		}

		private function hideFinishHandler(e:TweenEvent):void{
			removeKeeper(tweenA);
			removeHideEventListener(e.target as Tween);
			dispatchEvent(new Event("hideFinish"));
		}
	}
}