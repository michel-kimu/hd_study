package event{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import utils.*;
	/**
	 * ...
	 * @author ...
	 */
	public class CustomEventManager   extends EventDispatcher 
	{
		static public const LANGUAGE_CHANGED:String = 'language_changed';
		static public const USER_ATTENDANCED:String = 'user_attendance';
		static public const PAD_ACCESSED:String 	= 'pad_accessed';
		static public const USER_GROUP_INFO:String 	= 'user_group_info'; //강남치매센터 오전반, 오후반...
		static public const TAB_CHANGED:String 		= 'tab_changed'; //텝이 바뀌었음	 	
		
		/***********************************************************************************
		 * 
		 * 이벤트 송출
		 * 
		 **********************************************************************************/
		private function dispatchNow(eventName:String):void
		{
			dispatchEvent(new Event(eventName));
		}
		
		/***********************************************************************************
		 * 언어 설정 변경
		 **********************************************************************************/
		public function updateLanguage():void{
			Debug.log('이벤트:언어 설정 갱신');
			dispatchNow(LANGUAGE_CHANGED);
		}
		
		/***********************************************************************************
		 * 출석 상황 
		 **********************************************************************************/
		public function updateUserAttendance():void{
			Debug.log('이벤트:출석 상황 갱신');
			dispatchNow(USER_ATTENDANCED);
		}
		
		/***********************************************************************************
		 * 패드 접속 상황 
		 **********************************************************************************/
		public function updatePadAccessed():void{
			Debug.log('이벤트:패드 접속 상황 갱신');
			dispatchNow(PAD_ACCESSED);
		}
		
		/***********************************************************************************
		 * 교실 리스트 
		 **********************************************************************************/
		public function updateUserGroupInfo():void{
			Debug.log('이벤트:교실 정보 갱신');
			dispatchNow(USER_GROUP_INFO);
		}
		
		/***********************************************************************************
		 * 텝이 바뀜
		 **********************************************************************************/
		public function updateTabSelected():void{
			//Debug.log('탭 바뀜');
			dispatchNow(TAB_CHANGED);
		}
	}
}