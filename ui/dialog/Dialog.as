package ui.dialog{
	import flash.display.*;
	import flash.events.Event;
	import transition.PopupAction;
	import utils.*;
	
	public class Dialog extends Sprite {
	
		protected var _stage:Stage = null;
		 
		private static var isVisible:Boolean = false;				//화면에 등장했나?
		public static var waitList:Array = [];						//다이어로그가 발생한 순서대로 추가
		
		protected var wait:Boolean;									//차례를 기다림
		protected var response:Boolean = true;
		protected var data:Object = { };
		protected var popupAction:PopupAction; 						//어떻게 보여 줄까?
		private var guardCover:GuardCover;
		
		public function Dialog(wait:Boolean = true):void {
			this.scaleX = this.scaleY =  Utils.layoutScale;			//해상도가 다른 안드로이드 기종 사이즈 대응
			Debug.log("Utils.layoutScale;" + Utils.layoutScale);
			_stage = StageReference.stage; 							//스테이지 참조
			
			cacheAsBitmap = true; 									//일단 퍼포먼스의 향상을 기대하면서..
			this.wait = wait;   									//기다릴래?
		}
		
		public static function get isNowView():Boolean {
			return isVisible;
		}

		private static function nextDialog():void{
			var dialog:Dialog = waitList.shift();
			if(dialog as Dialog)dialog.show();
		}
		
		//다이어로그 보여주기
		public function show():void {
			if (isVisible) {
					waitList.push(this);
					trace("다이어로그를 추가합니다");
				}else{
					isVisible = true; //出番이요.
					
					guardCover = new GuardCover(0x000000);
					_stage.addChild(this);
					
					popupAction = new PopupAction(this);
					popupAction.addEventListener(DialogEvent.SHOW_FINISH, ehShowFinish);

					popupAction.show();
					dispatchEvent(new DialogEvent(DialogEvent.SHOW_START, wait, response, data));
				}
		}
		
		//다이어로그 감추기
		public function hide():void {
			popupAction.addEventListener(DialogEvent.HIDE_FINISH, ehHideFinish);
			popupAction.hide();
			
			dispatchEvent(new DialogEvent(DialogEvent.HIDE_START, wait, response, data)); 
		}
		
		private function ehShowFinish(e:Event):void {
			e.target.removeEventListener(e.type, arguments.callee);
			dispatchEvent(new DialogEvent(DialogEvent.SHOW_FINISH, wait, response, data));
		}
		
		private function ehHideFinish(e:Event):void {
			e.target.removeEventListener(e.type, arguments.callee);
			isVisible = false;
			
			if (parent != null) parent.removeChild(this); //다이어로그 종료
		 
			guardCover.hide();//Mouse Guard 종료
			dispatchEvent(new DialogEvent(DialogEvent.HIDE_FINISH, wait, response, data));
			
			if(waitList.length > 0)nextDialog(); //스텍된 다이어로그가 있으면 다음 다이어로그를 표시
		}
		
	}
}