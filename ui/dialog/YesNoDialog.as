package ui.dialog {

	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.ui.Keyboard;
	import ui.*;

	public class YesNoDialog extends Dialog{
		private var mc:MovieClip;
		private var _message:String = "";
		private var _funcYes:Function;
		private var _funcNo:Function;
		private var _selectBtnType:Boolean = false;
		
		public function YesNoDialog(message:String = "", funcYes:Function = null, funcNo:Function = null, wait:Boolean = true):void{
			super(wait);
			//--------------------------------------------------------------------------------
			mc = new swcYesNoDialog();  //common.swc 용
			addChild(mc);
			//--------------------------------------------------------------------------------
			
			this.message = message;
			_funcYes = funcYes;
			_funcNo = funcNo;
			
			addEventListener(DialogEvent.SHOW_FINISH, showFinishHandler);
			addEventListener(DialogEvent.HIDE_START, hideStartHandler);
			addEventListener(DialogEvent.HIDE_FINISH, hideFinished);
		}

		public function get message():String{
			return _message;
		}
		public function set message(__message:String):void{
			_message = __message;
			refresh();
		}

		//텍스트 관련 설정
		private function refresh():void{
			var paddingTop:int		= 40;
			var paddingBottom:int	= 40;

			mc.textField.autoSize		= TextFieldAutoSize.CENTER;
			mc.textField.multiline		= true;
			mc.textField.wordWrap		= false;
			mc.textField.text			= _message;
			//textField.filters = [new GlowFilter(0x000000, 1, 6, 6, 10, 1)];
			
			mc.base.width		= Math.round(Math.max(400,mc.textField.width + 60));
			mc.base.height		= Math.round(Math.max(250,mc.textField.height + paddingTop + paddingBottom));
			mc.icon.y				= Math.round(mc.base.height / -2 + 10);
			mc.textField.y		= Math.round(mc.base.height / -2 + paddingTop + (mc.base.height - paddingTop - mc.textField.height - paddingBottom) / 2);
			trace("mc.buttonOK:" + mc.buttonYes);
			mc.buttonYes.y  = mc.buttonNo.y	= Math.round(mc.base.height / 2 - 30);
		}

		//UI ON/OFF
		private function setUI(option:Boolean):void {
			if(option){
				mc.buttonYes.addEventListener(MouseEvent.CLICK, mouseDownHandler);
				mc.buttonNo.addEventListener(MouseEvent.CLICK, mouseDownHandler);
				_stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			}else{
				mc.buttonYes.removeEventListener(MouseEvent.CLICK, mouseDownHandler);
				mc.buttonNo.removeEventListener(MouseEvent.CLICK, mouseDownHandler);
				_stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
				removeChild(mc);
			}
		}
		
		/****************************************************************************
		 * Event Handler
		 ****************************************************************************/
		private function hideFinished(e:DialogEvent):void
		{
			removeEventListener(DialogEvent.SHOW_FINISH, showFinishHandler);
			removeEventListener(DialogEvent.HIDE_START, hideStartHandler);
			removeEventListener(DialogEvent.HIDE_FINISH, hideFinished);
			
			if (_funcYes != null && _funcNo != null){
				if (_selectBtnType){
					_funcYes();
				}else{
					_funcNo();
				}
			}
		}
		
		private function showFinishHandler(e:DialogEvent):void
		{
			setUI(true);
		}
		
		private function hideStartHandler(e:DialogEvent):void
		{
			setUI(false);
		}
		
		//클릭
		private function mouseDownHandler(e:Event):void{
			hide();
			switch (e.target)
			{
				case mc.buttonYes: 
					_selectBtnType = true;
					break;
					
				case mc.buttonNo:
					_selectBtnType = false;
					break;
			}
		}
		//Enter->OK,ESC->OK
		private function keyDownHandler(e:KeyboardEvent):void{
			//FullScreen모드일때 ESC가 눌리면 풀스크린도 해제가 되버리므로 일단 보류.
			/*
			 * switch(e.keyCode){
				case Keyboard.ENTER://Enter
					response = true;
					hide();
				break;
				case Keyboard.ESCAPE://ESC
					response = false;
					hide();
				break;
				
			}*/
		}
		
	}
}