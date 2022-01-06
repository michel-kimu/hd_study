package utils
{
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	//import globals.AppState;
	//import model.*;
	
	public class StageReference
	{
		
		private static var _isMouseDown:Boolean = false;
		private static var _stage:Object = {};
		//public static var _modelcenterEventDispatcher:ModelCenterEventDispatcher;
		
		public function StageReference():void
		{
			throw new ArgumentError("StageUtils Class 는 인스턴스로 만들수 없음");
		}
		
		//================================
		//Stage의 참조
		//================================
		
		//stage
		public static function get stage():Stage
		{
			return _stage as Stage;
		}
		
		public static function set stage(__stage:Stage):void
		{
			if (_stage is Stage == false)
			{
				
				if (_stage.align is String) __stage.align = _stage.align;					//Flash Player 또는 브라우저의 스테이지의 배치를 지정(TOP,BOTTOM..)
				if (_stage.displayState is String) __stage.displayState = _stage.displayState;			//표준 스테이지 모드(NORMAL), 전화면 모드(FULL_SCREEN)
				if (_stage.focus is InteractiveObject) __stage.focus = _stage.focus;					//키보드 포커스
				if (_stage.frameRate is Number) __stage.frameRate = _stage.frameRate;
				if (_stage.fullScreenSourceRect is Rectangle) __stage.fullScreenSourceRect = _stage.fullScreenSourceRect;	//스테니지의 특정 영역을 Flash Player로 확대/축소하기위해 설정
				if (_stage.height is Number) __stage.height = _stage.height;
				if (_stage.mouseChildren is Boolean) __stage.mouseChildren = _stage.mouseChildren;			//이 오브젝트의 자식의 개수를 되돌림
				if (_stage.quality is String) __stage.quality = _stage.quality;				//Flash Player가 사용하는 렌더링 품질
				if (_stage.scaleMode is String) __stage.scaleMode = _stage.scaleMode;				//사용하는 확대/축소 모드를 지정
				if (_stage.showDefaultContextMenu is Boolean) __stage.showDefaultContextMenu = _stage.showDefaultContextMenu;//콘텍스트 메뉴에 디폴트의 항목을 표시할것인가
				if (_stage.stageFocusRect is Boolean) __stage.stageFocusRect = _stage.stageFocusRect;		//오브젝트가 포커스를 가지는 경우에 강조표시된 경계선을 표시할것인가
				if (_stage.stageHeight is Number) __stage.stageHeight = _stage.stageHeight;			//Flash Player 윈도우의 높이
				if (_stage.stageWidth is Number) __stage.stageWidth = _stage.stageWidth;			//Flash Player 윈도우의 폭
				if (_stage.tabChildren is Boolean) __stage.tabChildren = _stage.tabChildren;			//오브젝트의 자식에게 TAB 이 유효한지 조사함
				if (_stage.width is Number) __stage.width = _stage.width;
				_stage = __stage as Stage;
				
				//_stage.addEventListener(MouseEvent.MOUSE_DOWN,mouseEventHandler);
				//_stage.addEventListener(MouseEvent.MOUSE_UP, mouseEventHandler);
				
				//	dispatchEvent(new StageEvent(StageEvent.ARRIVED_STAGE,null,_stage));
				
				_stage.addEventListener(KeyboardEvent.KEY_DOWN, onkeydown);
				
			}
		}
		
		public static function onkeydown(e:KeyboardEvent)
		{
			if (e.ctrlKey)
			{
				_stage.addEventListener(KeyboardEvent.KEY_UP, onkeyup)
			}
		}
		
		public static function onkeyup(e:KeyboardEvent)
		{
			_stage.removeEventListener(KeyboardEvent.KEY_UP, onkeyup);
			trace(e.keyCode);
			
/*			
			_modelcenterEventDispatcher = AppState.modelCenter._modelCenterEventDispatcher;
			if (e.keyCode == 88)
			{
				trace("You pressed Ctrl+X");
			}
			else if (e.keyCode == 67)
			{
				if (_modelcenterEventDispatcher){
					_modelcenterEventDispatcher.controlPanelView(); //컨트롤패널 보이기
				}
				trace("You pressed Ctrl+c" + _modelcenterEventDispatcher);
			}
			else if (e.keyCode == 86)
			{
				trace("You pressed Ctrl+v");
			}
			e.ctrlKey = false;
*/
		}
		
		//================================
		//Stage프로퍼티
		//================================
		
		//align
		public static function get align():String
		{
			return _stage.align;
		}
		
		public static function set align(value:String):void
		{
			var before:* = _stage.align;
			var after:* = value;
			_stage.align = value;
			//dispatchEvent(new StageEvent(StageEvent.CHANGE_ALIGN,before,after));
		}
		
		//displayState
		public static function get displayState():String
		{
			return _stage.displayState;
		}
		
		public static function set displayState(value:String):void
		{
			var before:* = _stage.displayState;
			var after:* = value;
			_stage.displayState = value;
			//dispatchEvent(new StageEvent(StageEvent.CHANGE_DISPLAY_STATE,before,after));
		}
		
		//focus
		public static function get focus():InteractiveObject
		{
			return _stage.focus;
		}
		
		public static function set focus(value:InteractiveObject):void
		{
			var before:* = _stage.focus;
			var after:* = value;
			_stage.focus = value;
			//	dispatchEvent(new StageEvent(StageEvent.CHANGE_FOCUS,before,after));
		}
		
		//frameRate
		public static function get frameRate():Number
		{
			return _stage.frameRate;
		}
		
		public static function set frameRate(value:Number):void
		{
			var before:* = _stage.frameRate;
			var after:* = value;
			_stage.frameRate = value;
			//	dispatchEvent(new StageEvent(StageEvent.CHANGE_FRAME_RATE,before,after));
		}
		
		//fullScreenSourceRect
		public static function get fullScreenSourceRect():Rectangle
		{
			return _stage.fullScreenSourceRect;
		}
		
		public static function set fullScreenSourceRect(value:Rectangle):void
		{
			var before:* = _stage.fullScreenSourceRect;
			var after:* = value;
			_stage.fullScreenSourceRect = value;
			//	dispatchEvent(new StageEvent(StageEvent.CHANGE_FULL_SCREEN_SOURCE_RECT,before,after));
		}
		
		//height
		public static function get height():Number
		{
			return _stage.height;
		}
		
		public static function set height(value:Number):void
		{
			var before:* = _stage.height;
			var after:* = value;
			_stage.height = value;
			//	dispatchEvent(new StageEvent(StageEvent.CHANGE_HEIGHT,before,after));
		}
		
		//mouseChildren
		public static function get mouseChildren():Boolean
		{
			return _stage.mouseChildren;
		}
		
		public static function set mouseChildren(value:Boolean):void
		{
			var before:* = _stage.mouseChildren;
			var after:* = value;
			_stage.mouseChildren = value;
			//	dispatchEvent(new StageEvent(StageEvent.CHANGE_MOUSE_CHILDREN,before,after));
		}
		
		//quality
		public static function get quality():String
		{
			return _stage.quality;
		}
		
		public static function set quality(value:String):void
		{
			var before:* = _stage.quality;
			var after:* = value;
			_stage.quality = value;
			//	dispatchEvent(new StageEvent(StageEvent.CHANGE_QUALITY,before,after));
		}
		
		//scaleMode
		public static function get scaleMode():String
		{
			return _stage.scaleMode;
		}
		
		public static function set scaleMode(value:String):void
		{
			var before:* = _stage.scaleMode;
			var after:* = value;
			_stage.scaleMode = value;
			//	dispatchEvent(new StageEvent(StageEvent.CHANGE_SCALE_MODE,before,after));
		}
		
		//showDefaultContextMenu
		public static function get showDefaultContextMenu():Boolean
		{
			return _stage.showDefaultContextMenu;
		}
		
		public static function set showDefaultContextMenu(value:Boolean):void
		{
			var before:* = _stage.showDefaultContextMenu;
			var after:* = value;
			_stage.showDefaultContextMenu = value;
			//	dispatchEvent(new StageEvent(StageEvent.CHANGE_SHOW_DEFAULT_CONTEXT_MENU,before,after));
		}
		
		//stageFocusRect
		public static function get stageFocusRect():Boolean
		{
			return _stage.stageFocusRect;
		}
		
		public static function set stageFocusRect(value:Boolean):void
		{
			var before:* = _stage.stageFocusRect;
			var after:* = value;
			_stage.stageFocusRect = value;
			//	dispatchEvent(new StageEvent(StageEvent.CHANGE_STAGE_FOCUS_RECT,before,after));
		}
		
		//stageHeight
		public static function get stageHeight():Number
		{
			return _stage.stageHeight;
		}
		
		public static function set stageHeight(value:Number):void
		{
			var before:* = _stage.stageHeight;
			var after:* = value;
			_stage.stageHeight = value;
			//	dispatchEvent(new StageEvent(StageEvent.CHANGE_STAGE_HEIGHT,before,after));
		}
		
		//stageWidth
		public static function get stageWidth():Number
		{
			return _stage.stageWidth;
		}
		
		public static function set stageWidth(value:Number):void
		{
			var before:* = _stage.stageWidth;
			var after:* = value;
			_stage.stageWidth = value;
		
			//	dispatchEvent(new StageEvent(StageEvent.CHANGE_STAGE_WIDTH,before,after));
		}
		
		//tabChildren
		public static function get tabChildren():Boolean
		{
			return _stage.tabChildren;
		}
		
		public static function set tabChildren(value:Boolean):void
		{
			var before:* = _stage.tabChildren;
			var after:* = value;
			_stage.tabChildren = value;
			//	dispatchEvent(new StageEvent(StageEvent.CHANGE_TAB_CHILDREN,before,after));
		}
		
		//width
		public static function get width():Number
		{
			return _stage.width;
		}
		
		public static function set width(value:Number):void
		{
			var before:* = _stage.width;
			var after:* = value;
			_stage.width = value;
		
			//	dispatchEvent(new StageEvent(StageEvent.CHANGE_WIDTH,before,after));
		}
		
		//================================
		//편리한 기능
		//================================
		
		//마우스 버튼의 상태
		public static function get isMouseDown():Boolean
		{
			return _isMouseDown;
		}
		
		private static function mouseEventHandler(e:MouseEvent):void
		{
			_isMouseDown = e.buttonDown;
		}
	
		//================================
		//static용EventDispatcher
		//================================
	/*
	   //addEventListener
	   public static function addEventListener(type:String,listener:Function,useCapture:Boolean = false,priority:int = 0,useWeakReference:Boolean = false):void{
	   dispatcher.addEventListener(type,listener,useCapture,priority);
	   }
	
	   //removeEventListener
	   public static function removeEventListener(type:String,listener:Function,useCapture:Boolean = false):void{
	   dispatcher.removeEventListener(type,listener,useCapture);
	   }
	
	   //dispatchEvent
	   public static function dispatchEvent(event:Event):Boolean{
	   return dispatcher.dispatchEvent(event);
	   }
	
	   //hasEventListener
	   public static function hasEventListener(type:String):Boolean{
	   return dispatcher.hasEventListener(type);
	   }
	
	   //willTrigger
	   public static function willTrigger(type:String):Boolean{
	   return dispatcher.willTrigger(type);
	   }*/
	}
}