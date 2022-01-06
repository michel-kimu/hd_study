package utils{

	import flash.events.*;

	public class StageEvent extends Event{

		public static const ARRIVED_STAGE:String					= "arrivedStage";
		public static const CHANGE_ALIGN:String						= "changeAlign";
		public static const CHANGE_DISPLAY_STATE:String				= "changeDisplayState";
		public static const CHANGE_FOCUS:String						= "changeFocus";
		public static const CHANGE_FRAME_RATE:String				= "changeFrameRate";
		public static const CHANGE_FULL_SCREEN_SOURCE_RECT:String	= "changeFullScreenSourceRect";
		public static const CHANGE_HEIGHT:String					= "changeHeight";
		public static const CHANGE_MOUSE_CHILDREN:String			= "changeMouseChildren";
		public static const CHANGE_QUALITY:String					= "changeQuality";
		public static const CHANGE_SCALE_MODE:String				= "changeScaleMode";
		public static const CHANGE_SHOW_DEFAULT_CONTEXT_MENU:String	= "changeShowDefaultContextMenu";
		public static const CHANGE_STAGE_FOCUS_RECT:String			= "changeStageFocusRect";
		public static const CHANGE_STAGE_HEIGHT:String				= "changeStageHeight";
		public static const CHANGE_STAGE_WIDTH:String				= "changeStageWidth";
		public static const CHANGE_TAB_CHILDREN:String				= "changeTabChildren";
		public static const CHANGE_WIDTH:String						= "changeWidth";

		private var _before:*;
		private var _after:*;

		public function StageEvent(type:String,__before:* = undefined,__after:* = undefined):void{
			super(type);
			_before	= __before;
			_after		= __after;
		}

		public function get before():*	{return _before;	}
		public function get after():*		{return _after;		}

		public override function clone():Event{   
			return new StageEvent(type,before,after);
		}

		public override function toString():String{   
			return formatToString("StageEvent","type","bubbles","cancelable","eventPhase","before","after");
		}
	}
}