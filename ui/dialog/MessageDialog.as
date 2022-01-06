package ui.dialog {

	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.ui.Keyboard;
	import ui.*;

	public class MessageDialog extends Dialog{
		private var mc:MovieClip;
		private var _message:String = "";
		private var _func:Function;
		
		public function MessageDialog(message:String = "", func:Function = null, wait:Boolean = true):void{
			super(wait);
			//--------------------------------------------------------------------------------
			mc = new swcMessageDialog();  //common.swc 용
			addChild(mc);
			//--------------------------------------------------------------------------------
			
			this.message = message;
			_func = func;
			
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
			
			mc.buttonOK.y		= Math.round(mc.base.height / 2 - 30);
		}

		//UI ON/OFF
		private function setUI(option:Boolean):void {
			if(option){
				mc.buttonOK.addEventListener(MouseEvent.CLICK, mouseDownHandler);
				_stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			}else{
				mc.buttonOK.removeEventListener(MouseEvent.CLICK, mouseDownHandler);
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
			
			if (_func != null) _func();
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
			switch (e.target)
			{
				case mc.buttonOK: 
					response = true;
					hide();
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