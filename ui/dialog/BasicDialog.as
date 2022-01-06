package ui.dialog {
	
	import flash.text.*;
	import flash.display.MovieClip;

	
	public class BasicDialog extends Dialog{
		private var _message:String = "";
		private var mc:MovieClip;
		
		public function BasicDialog(msg:String = "" , wait:Boolean = true):void {
			super(wait);	
			//--------------------------------------------------------------------------------
			mc = new swcBasicDialog();  //common.swc 용
			addChild(mc);
			//--------------------------------------------------------------------------------
			this._message =  msg;
			refresh()
			
		}
		
		private function refresh():void {
			var paddingTop:int		= 40;
			var paddingBottom:int	= 40;
			mc.textField.autoSize	= TextFieldAutoSize.CENTER;
			mc.textField.multiline	= true;
			mc.textField.wordWrap	= false;
			mc.textField.text		=  _message;
			
			mc.base.width		= Math.round(Math.max(400,mc.textField.width + 60));
			mc.base.height		= Math.round(Math.max(250,mc.textField.height + paddingTop + paddingBottom));
			mc.icon.y			= Math.round(mc.base.height / -2 + 10);
			mc.textField.y		= Math.round(mc.base.height / -2 + paddingTop + (mc.base.height - paddingTop - mc.textField.height - paddingBottom) / 2);
			
		}
	}
}