package ui.dialog {
	import flash.events.Event;
	
	//다이어로그용 커스텀 이벤트
	public class DialogEvent extends Event {
		
		static public const SHOW_START:String		= "showStart";
		static public const SHOW_FINISH:String		= "showFinish";
		static public const HIDE_START:String		= "hideStart";
		static public const HIDE_FINISH:String		= "hideFinish";
		
		public var wait:Boolean;
		public var response:Boolean;
		public var data:Object;
		
		public function DialogEvent(type:String,  wait:Boolean = false, response:Boolean = false, data:Object = null):void {
			super(type);
			this.wait = wait;
			this.response = response;
			this.data = data;
		}
		
		public override function clone():Event {
			return new DialogEvent(type, wait, response, data);
		}
		
		public override function toString():String {
			return formatToString("DialogEvent","type","bubbles","cancelable","eventPhase","wait","response","data");
		}
	}
}