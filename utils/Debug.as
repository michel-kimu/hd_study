package utils{

	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.system.*;
	import flash.text.*;
	import flash.ui.*;
	import flash.utils.*;


	public class Debug{

		public static var mangaBook:*;
		public static var showKomaRectFlag:Boolean = false;

		public static var enabled:Boolean = false;
		private static var initialized:Boolean = false;
		private static var _stage:Stage;
		private static var traceField:TextField = new TextField();

		public function Debug():void{
		}

		//디버그 초기화
		private static function init():void{
			if(initialized)return;
			initialized = true;
			_stage = StageReference.stage;
			//traceField
			traceField.type = TextFieldType.DYNAMIC;
			traceField.mouseEnabled = false;
			traceField.multiline = true;
			traceField.wordWrap = false;
			traceField.visible = false;
			traceField.blendMode = BlendMode.NORMAL;
			traceField.selectable = true;
			traceField.y = 40;
			traceField.width = _stage.stageWidth;
			traceField.height = _stage.stageHeight - 10;
			//Visible
			var button1:Sprite = new Sprite();
			button1.graphics.beginFill(0xff0000,1);
			button1.graphics.drawRect(0,0,80,40);
			button1.alpha = 0.2;
			button1.buttonMode = true;
			button1.tabEnabled = false;
			button1.addEventListener(MouseEvent.MOUSE_DOWN,function(e:MouseEvent):void{
				traceField.visible = !traceField.visible;
				if(traceField.visible){
					e.target.alpha = 1;
				}else{
					e.target.alpha = 0.2;
				}
			});
			//Selectable
			var button2:Sprite = new Sprite();
			button2.graphics.beginFill(0x00ff00,1);
			button2.graphics.drawRect(80,0,160,40);
			button2.alpha = 0.2;
			button2.buttonMode = true;
			button2.tabEnabled = false;
			button2.addEventListener(MouseEvent.MOUSE_DOWN,function(e:MouseEvent):void{
				traceField.mouseEnabled = !traceField.mouseEnabled;
				if(traceField.mouseEnabled){
					e.target.alpha = 1;
				}else{
					e.target.alpha = 0.2;
				}
			});
			//BlendMode
			var button3:Sprite = new Sprite();
			button3.graphics.beginFill(0x0000ff,1);
			button3.graphics.drawRect(160,0,80,40);
			button3.alpha = 0.2;
			button3.buttonMode = true;
			button3.tabEnabled = false;
			button3.addEventListener(MouseEvent.MOUSE_DOWN,function(e:MouseEvent):void{
				if(traceField.blendMode == BlendMode.NORMAL){
					traceField.blendMode = BlendMode.INVERT;
					e.target.alpha = 1;
				}else{
					traceField.blendMode = BlendMode.NORMAL;
					e.target.alpha = 0.2;
				}
			});
			
			//addChild
			_stage.addChild(traceField);
			_stage.addChild(button1);
			_stage.addChild(button2);
			_stage.addChild(button3);
			
			//setChildIndex
			var addedHandler:Function = function(e:Event = null):void{
				_stage.setChildIndex(traceField,_stage.numChildren - 1);
				_stage.setChildIndex(button1,_stage.numChildren - 1);
				_stage.setChildIndex(button2,_stage.numChildren - 1);
				_stage.setChildIndex(button3,_stage.numChildren - 1);
			}
			//RESIZE
			var resizeHandler:Function = function(e:Event = null):void{
				traceField.width = _stage.stageWidth;
				traceField.height = _stage.stageHeight - 10;
				traceField.scrollV = traceField.maxScrollV;
			}
			addedHandler();
			resizeHandler();
			_stage.addEventListener(Event.ADDED,addedHandler);
			_stage.addEventListener(Event.RESIZE,resizeHandler);
//			button1.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
		}

		//디버그용 트레이스
		public static function log(...args:Array):void {
			//CONFIG::DEBUG{
				if(initialized == false && enabled)init();
				args.unshift("[ " + Utils.getTimeString("hh:mm:ss") + " ]");
				var i:int,mes:String = "";
				for(i = 0 ; i < args.length ; i++){
					if(mes != "")mes += "  ";
					mes += args[i];
				}
				
				if (enabled == false) { //디버그 모드가 아닐때에는 trace만 처리
					trace(mes);
					return;
				}
				traceField.appendText(mes + "\n");
				traceField.scrollV = traceField.maxScrollV;
				
				trace(mes);
			//}
		}

		//콘텍스트 메뉴의 추가
		public static function addMenu(target:InteractiveObject,caption:String,func:Function = null):void{
			/*
			if(target.contextMenu == null)target.contextMenu = new ContextMenu();
			target.contextMenu.hideBuiltInItems();
			var item:ContextMenuItem = new ContextMenuItem(caption);
			if(func != null)item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,func);
			target.contextMenu.customItems.push(item);
			*/
		}

		//콘텍스트 메뉴의 삭제
		public static function removeMenu(target):void {
			/*
			if(target.contextMenu == null)return;
			var item:ContextMenuItem;
			while(target.contextMenu.customItems.length){
				item = target.contextMenu.customItems.shift();
				item = null;
			}
			*/
		}

		//범용 에러 트레이스
		public static function errorHandler(e:*):void{
			log(e.message);
		}

		//범용 이벤트 트레이스
		public static function eventHandler(e:*):void{
			var message:String = "";
			var addMessage:Function = function(mes:String):void{
				if(message != "")message += " ";
				message += mes;
			}
			addMessage(e.type);
			switch(e.type){

				case IOErrorEvent.IO_ERROR:
				case SecurityErrorEvent.SECURITY_ERROR:
				addMessage(e.text);
				break;

				case ProgressEvent.PROGRESS:
				addMessage(Math.round(e.bytesLoaded / e.bytesTotal * 100) + "%");
				break;

				case HTTPStatusEvent.HTTP_STATUS:
				addMessage(e.status);
				break;

				case Event.COMPLETE:
				switch(e.target.constructor){
					case URLLoader:		addMessage(e.target.data);break;
					case Loader:		addMessage(e.data);break;
				}
			}
			log(message);
		}

		//ByteArray를 문자열 표현으로
		public static function bytesToString(bytes:ByteArray):String{
			var i:int,byteString:String = "";
			for(i = 0 ; i < bytes.length ; i++){
				if(byteString != "")byteString += ",";
				byteString += Utils.mae0(bytes[i].toString(16),2);
			}
			return byteString;
		}

		//지정의 포인트에 배치
		public static function markPoint(point:*):Shape{
			var shape:Shape = new Shape();
			shape.graphics.lineStyle(3,0xFF0000,1,false,LineScaleMode.NONE);
			shape.graphics.moveTo	(point.x - 10,point.y - 10);
			shape.graphics.lineTo	(point.x + 10,point.y + 10);
			shape.graphics.moveTo	(point.x + 10,point.y - 10);
			shape.graphics.lineTo	(point.x - 10,point.y + 10);
			return shape;
		}

		//지정한 사각형태를 배치
		public static function markRect(rect:Rectangle,text:String = ""):Sprite{
			var sprite:Sprite = new Sprite();
			var R:uint	= Math.floor(Math.random() * 256) << 16;
			var G:uint	= Math.floor(Math.random() * 256) << 8;
			var B:uint	= Math.floor(Math.random() * 256) << 0;
			sprite.graphics.beginFill(R+G+B,0.2);
			sprite.graphics.lineStyle(2,R+G+B,1,true,LineScaleMode.NONE);
			sprite.graphics.drawRect(rect.x,rect.y,rect.width,rect.height);
			sprite.mouseChildren = false;
			if(text != ""){
				var textField:TextField = new TextField();
				textField.defaultTextFormat = new TextFormat(null,Math.max(rect.width,rect.height),R+G+B);
				textField.autoSize = TextFieldAutoSize.CENTER;
				textField.text = text;
				textField.x = rect.x + rect.width / 2 - textField.width / 2
				textField.y = rect.y + rect.height / 2 - textField.height / 2
				sprite.addChild(textField);
			}
			return sprite;
		}
	}
}