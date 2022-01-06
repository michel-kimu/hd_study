package ui.game
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.events.TouchEvent;
	
	public class SoundTrack extends MovieClip
	{
 
		var sndTrackArr: Array = [];
		var tempCircle: Onpu;
	
		public function SoundTrack()
		{
			addEventListener(Event.REMOVED_FROM_STAGE, 			removeStage);	
			btnHit.addEventListener(MouseEvent.MOUSE_DOWN,  	onHit);
			btnHit.addEventListener(TouchEvent.TOUCH_BEGIN , 	onHit);
		}
		
		/********************************************************************************
		 * 
		 * Destructor
		 * 
		 ********************************************************************************/
		public function removeStage(e:Event = null):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, 		removeStage);
			btnHit.removeEventListener(MouseEvent.MOUSE_DOWN,	onHit)
			btnHit.removeEventListener(TouchEvent.TOUCH_BEGIN , onHit);
		}

		//공이 끝까지 진행 했는지 매프레임 체크
		public function Update():void{
			var circleLength: int = sndTrackArr.length - 1;
			for (var counter: int = circleLength; counter >= 0; counter--) {
				tempCircle = sndTrackArr[counter];
				
				if (tempCircle.currentFrame >= 40) {
					removeCircle(counter);
				}
			}
		}
		
		//공 소멸
		private function removeCircle(counter: int): void {
			tempCircle = sndTrackArr[counter];
			tempCircle.fin();
			removeChild(tempCircle);
			sndTrackArr.splice(counter, 1);
		}
		
		//공 만들기
		public function createOnpu(newCircle:Onpu, pos:Point):void{
			newCircle.x = pos.x;
			newCircle.y = pos.y;
			
			addChild(newCircle);
			sndTrackArr.push(newCircle);
		}
		
		//히트 버튼 클릭 처리
		//function taphander(evt:TouchEvent): void { 
		private function onHit(e:Event = null):void{
			MovieClip(parent)[(this.name+'_effect')].mcEffect.gotoAndPlay('st'); //트랙 발광
			if (sndTrackArr.length > 0) {
				tempCircle = sndTrackArr[0];
				tempCircle.playOnpu(); //소리내기
				
				if (tempCircle.currentFrame >= 26 && tempCircle.currentFrame < 40 ) {
					trace('퍼팩트');
					MovieClip(parent)[(this.name+'_effect')].mcColl01.gotoAndPlay('st'); //빤짝
					removeCircle(0);
				}
			}
		}
	}
}