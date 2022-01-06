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
	public class ButtonUpProc extends MovieClip
	{
		
		private var mDown:Boolean
		private var mOut:Boolean;
		private var Func:Function;
		
		public function ButtonUpProc() {

			this.mDown = false;		//마우스가 눌렸나?
			this.mOut = false;		//커서가 밖으로 나갔나?
			
			addEventListener(Event.REMOVED_FROM_STAGE, 	removeStage);	
			addEventListener(MouseEvent.MOUSE_DOWN, 	onMouseDownHandler)
			addEventListener(MouseEvent.MOUSE_OVER,		onMouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT,		onMouseOutHandler);
			
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
		
		private function onMouseOutHandler(e:MouseEvent):void {
			mOut = true; //커서가 버튼 밖으로 나갔음
			MovieClip(parent).gotoAndPlay('normal')
		}
		
		private function onMouseDownHandler(e:MouseEvent):void {
			mDown = true; //버튼이 눌렸음
			MovieClip(parent).gotoAndPlay('down');
			//AppState.modelCenter._soundManager.playSE('ch3', 'SE_Click');
			StageReference.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
		}

		private function onMouseOverHandler(e:MouseEvent):void {
			mOut = false; //커서가 버튼안으로 들어왔음.
			
			if (mDown){
				MovieClip(parent).gotoAndPlay('down');
				//AppState.modelCenter._soundManager.playSE('ch3', 'SE_Click');
			}else{
				//trace('커서가 버튼안으로 들어왔음.');
				MovieClip(parent).gotoAndPlay('up');
			}
		}	
		 /********************************************************************************
		 * 
		 * as3의 onReleaseOutside과 같은 처리
		 * 
		 ********************************************************************************/
		public function onMouseUpHandler(e:MouseEvent):void {
			
			StageReference.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			if (mDown) {
				mDown = false;
				
				if (!mOut) {
					MovieClip(parent).gotoAndPlay('up')
					if (Func != null) {
						Func();//선택 상태
					}
				}
			}
			e.updateAfterEvent(); //화면 갱신
		}
	}
	
}