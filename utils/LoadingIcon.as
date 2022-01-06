package utils{
	import flash.display.MovieClip;
	import flash.events.VideoEvent;
	import flash.geom.Point;
	
	public class LoadingIcon extends MovieClip{
		private var guardCover:GuardCover;
		private var loadingIcon:MovieClip;
		
		public function LoadingIcon():void{
			loadingIcon = new swcLoadingIcon();
			loadingIcon.scaleX = loadingIcon.scaleY =  Utils.layoutScale;			//해상도가 다른 안드로이드 기종 사이즈 대응
		}
		
		public function show():void {
			
			guardCover = new GuardCover(0x000000);
			var stageSize:Point = Utils.getStageSize();
			loadingIcon.x = stageSize.x / 2;
			loadingIcon.y = stageSize.y / 2;
			
			guardCover.addChild(loadingIcon);
		}
		
		public function hide():void{
			if(guardCover.contains(loadingIcon))			guardCover.removeChild(loadingIcon);
			guardCover.hide();
		}
	}
}