package ui.selector
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ButtonPrevNextManager 
	{
		private var rotate:Boolean = true; //true:순환모드, false: max 보다 크거나 1 보다 작으면 더이상 진행하지 않음
		private var mcPrev:*;
		private var mcNext:*;
		
		private var Func:Function;
		private var nextCheckFnc:Function; //다음 페이지 버튼을 누르기 전에 미리 체크를 해야 할 내용등을 지정. (ex: 다음 버튼을 누르기 전에 입력한 메일 어드레스 주소가 옳바른지 체크등)
		
		private var position:int  = 1;
		private var max:int
		
		public function ButtonPrevNextManager(rotate:Boolean , max:int, mcPrev:*, mcNext:*, func:Function, nextCheckFnc:Function) {
			position = 1;
			this.rotate = rotate;
			this.max = max;
			this.mcPrev = mcPrev;
			this.mcNext = mcNext;
			this.Func = func; 						//뭔가 실행 시키고 싶은 메서드
			this.nextCheckFnc = nextCheckFnc; 		//Next 를 실행하기 전에 실행하고 싶은 메서드
			
			button_update()
			
			if (mcPrev.hasEventListener(MouseEvent.CLICK))	mcPrev.removeEventListener(MouseEvent.CLICK, onPrev); //이벤트가 등록 되어 있으면 일단 죽이고 보자
			if (mcNext.hasEventListener(MouseEvent.CLICK)) 	mcNext.removeEventListener(MouseEvent.CLICK, onNext);
			
			mcPrev.addEventListener(MouseEvent.CLICK, onPrev);
			mcNext.addEventListener(MouseEvent.CLICK, onNext);

		}
		
		public function update():void {
			Func(position);
		}
		
		//디스트럭터
		public function destructor():void {
			mcPrev.removeEventListener(MouseEvent.CLICK, onPrev);
			mcNext.removeEventListener(MouseEvent.CLICK, onNext);
			this.Func = null;
		}
		
		/********************************************************************************
		 * 
		 * 이전 페이지
		 * 
		 ********************************************************************************/
		public function onNext(e:MouseEvent):void {
			var result:Boolean = false;
			if (nextCheckFnc == null) {
				result = true
			}else {
				result = nextCheckFnc();
			}
			if (result) {
				if (isForwardable()) {
					
					position++;

					if (position > max) position  = 1;
					Func(position);	
					button_update ();
				} 
			}
		}
		
		/********************************************************************************
		 * 
		 * 다음 페이지
		 * 
		 ********************************************************************************/
		public function onPrev(e:MouseEvent):void {
			if (isBackable()) {
				
				position--;
				
				if (position < 1) position  = max;
				Func(position);	
				button_update ();
			}
		}
		/********************************************************************************
		 * 
		 * 다음 버튼
		 * 
		 ********************************************************************************/
		function isForwardable ():Boolean {
			if (rotate) return true; 		//순환모드
			return (position < max)?true:false;
		}
		
		/********************************************************************************
		 * 
		 * 돌아가기 버튼
		 * 
		 ********************************************************************************/
		function isBackable ():Boolean {
			if (rotate) return true;		//순환모드
			return (position > 1)?true:false;
		}
		
		/********************************************************************************
		 * 
		 * 좌우 버튼 상태 갱신
		 * 
		 ********************************************************************************/
		private function button_update ():void {
			mcNext.visible = isForwardable()?true:false;
			mcPrev.visible = isBackable()?true:false;
		}
	}
}