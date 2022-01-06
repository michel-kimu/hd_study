package utils
{
	import flash.display.*;
	import flash.system.*;
	import utils.Utils;
	/**
	 * ...
	 * @author ...m.kimu 2015.05.25
	 * 
	 * 마우스 가드 
	 * 
	 * 버튼등이 반응하지 못하도록 커버.
	 */
	public class GuardCover extends Sprite 
	{
		private var col:uint;
		private var w:uint;
		private var h:uint;
		private var _stage:Stage = null;
		
		public function GuardCover( _col:int = 0x000000, _alpha = 0.7){
			col = _col;
			_stage = StageReference.stage;
			_stage.addChild (this);

			if(Utils.isAndroid()){
				w = Math.ceil(stage.fullScreenWidth);
				h = Math.ceil(stage.fullScreenHeight);
			}else{
				w = Math.ceil(stage.stageWidth);
			    h = Math.ceil(stage.stageHeight);
			}

			graphics.clear();
			var _alpha:Number = _alpha;
			graphics.beginFill(col, _alpha);
			graphics.drawRect(0,0,w,h);
		}
		
		public function hide():void{
			if (_stage.contains(this)){
				_stage.removeChild(this);
				graphics.clear();
			}
		}
	}
}