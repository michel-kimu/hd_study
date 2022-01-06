package ui.button
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import utils.*;
	//import globals.*;	
	
	/**
	 * 
	 *  btnControl.addEventListener(MouseEvent.CLICK, func); 식으로 지정
	 * ...
	 * @author 
	 */
	public class CheckBoxProc extends MovieClip
	{
		
		private var mDown:Boolean
		private var mOut:Boolean;
		private var _state:Boolean;
		
		private var Func:Function;
				
		public function CheckBoxProc() {

			this._state = false;
			
			this.mDown = false;		//마우스가 눌렸나?
			this.mOut = false;		//커서가 밖으로 나갔나?
			
			addEventListener(Event.REMOVED_FROM_STAGE, 	removeStage);	
			addEventListener(MouseEvent.MOUSE_DOWN, 	onMouseDownHandler)
			addEventListener(MouseEvent.MOUSE_OVER,		onMouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT,		onMouseOutHandler);
		}
		
		public function init():void{
			this._state = false;
			MovieClip(parent).gotoAndPlay('up2');
		}
		
		/********************************************************************************
		 * 
		 * Destructor
		 * 
		 ********************************************************************************/
		public function removeStage(e:Event = null):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, 	removeStage);
			removeEventListener(MouseEvent.MOUSE_DOWN,		onMouseDownHandler)
			removeEventListener(MouseEvent.MOUSE_OVER, 		onMouseOverHandler);
			removeEventListener(MouseEvent.MOUSE_OUT,		onMouseOutHandler);
			
			trace('ButtonAnimationType Removed!')
		}
		
		public function setFunction(func:Function = null):void
		{
			Func = func;
		}
		
		//커서가 밖으로 나간 상태에서 MouseUp 했을때 반응하지 않도록.
		private function onMouseOutHandler(e:MouseEvent):void {
			mOut = true; //커서가 버튼 밖으로 나갔음
			 
			if (_state){
				MovieClip(parent).gotoAndPlay('up1');
			}else{
				MovieClip(parent).gotoAndPlay('up2');
			}
		}
		
		private function onMouseDownHandler(e:MouseEvent):void {
			mDown = true; //버튼이 눌렸음
			
			if (_state){
				MovieClip(parent).gotoAndPlay('down2');
			}else{
				MovieClip(parent).gotoAndPlay('down1');
			}
			
			//AppState.modelCenter._soundManager.playSE('ch3', 'SE_Click');
			StageReference.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			//stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
		}

		private function onMouseOverHandler(e:MouseEvent):void {
			mOut = false; //커서가 버튼안으로 들어왔음.
			
			//패드에서는 이 처리가 사실은 필요 없지 않나 싶다...
			if (_state){
				//MovieClip(parent).gotoAndPlay('down2');
			}else{
				//MovieClip(parent).gotoAndPlay('down1');
			}
		}
		
		 /********************************************************************************
		 * 
		 * as3의 onReleaseOutside과 같은 처리
		 * 
		 * MouseDown일때만 반응합니다
		 * 
		 ********************************************************************************/
		public function onMouseUpHandler(e:MouseEvent):void {
			
			StageReference.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			//stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);

			mDown = false;
				
			if (!mOut) {
				if (_state){
					MovieClip(parent).gotoAndPlay('up2');
					_state = false;
				}else{
					MovieClip(parent).gotoAndPlay('up1');
					_state = true;
				}
					
				if (Func != null) {
					Func(_state);//선택 상태
				}
			}

			e.updateAfterEvent(); //화면 갱신
		}
	}
	
}