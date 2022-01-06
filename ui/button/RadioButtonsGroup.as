package ui.button
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author 
	 */
	public class RadioButtonsGroup extends MovieClip 
	{
		private var btnPressStates:Array = new Array(); 
		private var btnMcs:Array = new Array();  // ['mcRadioBtn01', 'mcRadioBtn02']; //미리 스테이지에 올려주셈
		
		private var rdoTargetMc:MovieClip;
		private var selectedId:int;

		private var Func:Function;
		
		public function RadioButtonsGroup():void {
			addEventListener(Event.REMOVED_FROM_STAGE, removeStage);
		}
		
		public function Init(num:int = -1, func:Function = null):void {
			selectedId = -1;
			Func = func;
			
			for (var i = 0 ; i < this.numChildren ; i++) {
				var mc:MovieClip = MovieClip(this.getChildAt(i))
			
				btnPressStates.push(false);  	//false 으로 초기화
				mc.addEventListener(MouseEvent.MOUSE_DOWN, onRadioButtonClicked);
				mc.setId(i);
				btnMcs.push(mc);
			}
			if (num > 0) {
				btnPressStates[num - 1] = true;
				btnMcs[num - 1].onMouse_Down();
				selectedId = num-1;
				
				if (Func != null) {
					Func(selectedId);//선택한 버튼
				}
			}
		}
		/********************************************************************************
		 * 
		 * Destructor
		 * 
		 ********************************************************************************/
		public function removeStage(e:Event = null):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removeStage);
			
			for (var i:int = 0 ; i < btnMcs.length; i++) {
				btnMcs[i].removeEventListener(MouseEvent.MOUSE_DOWN, onRadioButtonClicked);
			}
		}
		/********************************************************************************
		 * 
		 * 라디오 버튼 처리 
		 * 
		 ********************************************************************************/
		public function onRadioButtonClicked(e:MouseEvent = null):void {
			selectedId = -1;
			
			var tgt:MovieClip =  MovieClip(e.currentTarget);
			if(rdoTargetMc != tgt){ //클릭에 한번만 대응
				rdoTargetMc = tgt;
			}else {
				return;
			}
			
			//모든 버튼을 안눌린 상태로 전환
			//for (var i:int = 0 ; i < btnMcs.length; i++) {
			//	btnPressStates[i] = false;
			//	btnMcs[i].onMouse_Up();
			//}
			onRadioButtonStateInit();
			
			
			//이번에 눌린 버튼의 처리
			rdoTargetMc.onMouse_Down();
			
			for (var j:int = 0 ; j < btnMcs.length; j++) {
				if (rdoTargetMc == btnMcs[j]) {
					selectedId = j
					btnPressStates[j] = true;	
					break;
				}
			}
			
			//
			if (Func != null) {
				Func(selectedId);//선택한 버튼
			}
			//
		}
		
		public function onRadioButtonStateInit():void{
			selectedId = -1;
			//모든 버튼을 안눌린 상태로 전환
			for (var i:int = 0 ; i < btnMcs.length; i++) {
				btnPressStates[i] = false;
				btnMcs[i].onMouse_Up();
			}
		}
		
		/********************************************************************************
		 * 
		 * 라디오 버튼 리셋
		 * 
		 ********************************************************************************/
		public function resetRadioButton():void{
			onRadioButtonStateInit()
			rdoTargetMc = null;
		}
		/********************************************************************************
		 * 
		 * 버튼 선택시 외부에서 실행 시킬 메서드 등록
		 * 
		 ********************************************************************************/
		public function setFunction(func:Function):void {
			Func = func
		}
	}
}