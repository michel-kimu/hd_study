package ui.game
{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.utils.ByteArray;
	import flash.geom.Matrix;
	import flash.display.BitmapData;
	import flash.display.StageQuality;
	
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	
	import caurina.transitions.Tweener;
	import utils.*;
	import globals.Global;
	
	/**
	 * ...
	 * @author ...신경쇄약 게임
	 * 
	 * 주의 : 스테이지에 올라가 있는 무비 클립의 구성과 스크립트의 구성이 같아야 함
	 */
	public class DrawPencil extends MovieClip 
	{
		
		// 描画領域（幅）
		private static const CANVAS_WIDTH:Number = 300;
		// 描画領域（高さ）
		private static const CANVAS_HEIGHT:Number = 330;

		// 마스크용 스프라이트
		private var drawArea:Sprite;
		private var inArea:Boolean = false;
		
		public var col:uint = 0x000000;
		public var brushSize:int = 15;
		public var alph:Number = 0.95;
		
		public function DrawPencil(){
			addEventListener(Event.REMOVED_FROM_STAGE, ehRemoved);
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			trace('canvas:' + canvas);
		
			drawArea = new Sprite();
			canvas.addChild(drawArea);
			
			canvas.addEventListener(MouseEvent.MOUSE_DOWN, 	startDrawHandler, false, 0, false);
			stage.addEventListener(MouseEvent.MOUSE_UP, 	endDrawHandler, false, 0, false);
			//canvas.addEventListener(MouseEvent.MOUSE_OUT,		onMouseOutHandler);
			mcEraser.addEventListener(MouseEvent.CLICK, onEraserCick);
			
		}
		/**********************************************************************************
		 * 
		 * 떠날때
		 * 
		 **********************************************************************************/
		private function ehRemoved(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, ehRemoved);
			canvas.removeEventListener(MouseEvent.MOUSE_DOWN, 	startDrawHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, 		endDrawHandler); 
 
			mcEraser.removeEventListener(MouseEvent.CLICK, onEraserCick);
			
			canvas.removeChild(drawArea);
			drawArea = null;
			trace('canvas kill');
		}
		
		function onMouseOutHandler(e:MouseEvent):void {
			inArea = false; //커서가 버튼 밖으로 나갔음
			 
		}
		function startDrawHandler(event:MouseEvent):void{
			inArea = true;
			startDraw(event)
		}

		function startDraw(event:MouseEvent):void{
			// 선의 굵기, 색, 불투명도를 설정
			drawArea.graphics.lineStyle( brushSize, col, alph);
			// 그리기 시작 위치를 마우스의 위치로 이동함
			drawArea.graphics.moveTo(event.localX, event.localY);
			// 그리기 시작
			canvas.addEventListener(MouseEvent.MOUSE_MOVE, moveDrawHandler, false, 0, false);
		}
		
		function endDrawHandler(event:Event):void{
			endDraw();
		}
		
		function endDraw():void{
			//trace('end');
			canvas.removeEventListener(MouseEvent.MOUSE_MOVE, moveDrawHandler, false);
			drawArea.graphics.endFill();
		}
		
		function moveDrawHandler(event:MouseEvent):void{
			
			if (event.localX < brushSize/2) {
				event.localX = brushSize / 2;
				inArea = false;
			}
			
			if (event.localX >= (CANVAS_WIDTH - brushSize/2)) {
				event.localX = (CANVAS_WIDTH - brushSize / 2);
				inArea = false;
			}
			
			if (event.localY < brushSize/2){
				event.localY = brushSize / 2;
				inArea = false;
			}
			
			if (event.localY >= (CANVAS_HEIGHT-brushSize/2)) {
				event.localY = (CANVAS_HEIGHT - brushSize / 2);
				inArea = false;
			}
			
			if (event.localX < (CANVAS_WIDTH - brushSize/2) && event.localX > brushSize / 2) {
				if ((event.localY > brushSize / 2) && (event.localY < (CANVAS_HEIGHT - brushSize / 2))){
					if (!inArea){
						drawArea.graphics.endFill();
						startDraw(event)
						trace('ok');
					}
					
					inArea = true;
				}
			}
			//trace('inArea:' + inArea);

		 	if(inArea)drawArea.graphics.lineTo(event.localX, event.localY);
		}
		
		// 지우개 버튼 클릭
		public function onEraserCick(event:Event = null):void{
			Global.soundManager.playSE('ch2', 'SE_Huki', null,false, 1, 60);  //창문닫는 소리
			onEraseDrawArea()
		}
		
		public function onEraseDrawArea():void{
			drawArea.graphics.clear();
		}
		
		public function setColor(id:int):void{
			alph = 0.95;
			switch(id){
				case 1:
					col = 0x000000; //검정
				break;
				case 2:
					col = 0xF6A135; //주황
				break;
				case 3:
					col = 0x85bf49; //녹색
				break;
				case 4:
					col = 0xFf0000; //빨강
				break;
				case 5:
					col = 0x8c519d; //보라
				break;
				case 6:
					col = 0x34b4e8; //하늘
				break;
				case 7:
					col = 0xffffff; //흰색(지우개)
					alph = 1.0;
				break;
			}
		}
		
		//브러시의 사이즈
		public function setBrushSize(id:int):void{
			switch(id){
				case 1:
					brushSize = 10;
				break;
				case 2:
					brushSize = 16;
				break;
				case 3:
					brushSize = 24;
				break;
				case 4:
					brushSize = 30;
				break;
			}
		}
	}
}