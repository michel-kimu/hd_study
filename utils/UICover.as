package utils{

	import flash.display.*;
	import flash.events.*;

	public class UICover extends Sprite{

		public var stageMask:StageMask = new StageMask();

		public function UICover():void{

			mouseEnabled = true;
			mouseChildren = false;

			stageMask.alpha = 0;
			addChild(stageMask);
			
			addEventListener(MouseEvent.MOUSE_DOWN, function(e:Event):void {
				//마우스 입력 거부
			});
			
			addEventListener(MouseEvent.MOUSE_UP,function(e:Event):void {
				//마우스 입력 거부
			});
		}
		
		
	}
}