package ui.dialog {

	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.ui.Keyboard;
	import fl.controls.*
 	
	import ui.*;
	import globals.*;
	import utils.*;
	 
	 public class ControlDialog extends Dialog{
		private var mc:MovieClip;

		private var ip:String;
		private var port:String;
		private var padNum:String;
		private var langNum:String; //언어
		private var _func:Function;
		
		private var padType:RadioButtonGroup;
		private var langType:RadioButtonGroup; //언어타입
		
		private var container:Sprite
	
		public function ControlDialog(updateFunc:Function = null, wait:Boolean = true):void{
			//soIP,soPort,grpNum:패드에 저장되어 있는 정보
			
			super(wait);
			
			//--------------------------------------------------------------------------------
			mc = new swcControlDialog();  //common.swc 용
			addChild(mc);
			//--------------------------------------------------------------------------------
 
			_func = updateFunc;
			
			var soInfo:Object = SOManager.loadSOInfo();		//Ip,Port,PadNum정보를 Shared Object 로 부터 취득

			mc.mcGuard.alpha = 0;  
			mc.txtVer.text = Global.ver;
			
			//언어선택용 라디오 버튼
			//스테이지에 라디오 버튼을 배치하면 체크상태가 재대로 유지 못하는 결과 스크립트로 만들기로함
			this.padNum = soInfo.padNum;
			this.langNum = soInfo.langNum;
			
			container = new Sprite();
 			padType = createRadioButtonGroup("padType", ["Teacher", "RC001", "RC002", "RC003", "RC004", "RC005", "RC006", "RC007", "RC008"],25);
			langType = createRadioButtonGroup("langType", ["한국어", "English"], 143);
			
			padType.getRadioButtonAt(parseInt(padNum)).selected  = true
			langType.getRadioButtonAt(parseInt(langNum)).selected  = true
			
			container.x = -130;
			container.y = -105;
		 	mc.addChild(container);
			
			//Ip,Port 용 텍스트 입력 필드
			mc.txtIpNum.restrict = '0-9.';
			mc.txtPortNum.restrict = '0-9';
			mc.txtIpNum.text = mc.txtPortNum.text = '';
			
			mc.txtIpNum.text = soInfo.ip;
			mc.txtPortNum.text = soInfo.port;
			
			addEventListener(DialogEvent.SHOW_FINISH, showFinishHandler);
			addEventListener(DialogEvent.HIDE_START, hideStartHandler);
			addEventListener(DialogEvent.HIDE_FINISH, hideFinished);
		}

		//UI ON/OFF
		private function setUI(option:Boolean):void {
			if (option){
				mc.mcGuard.visible = false; 
				mc.btnUpdate.addEventListener(MouseEvent.CLICK, btnFuncUpdate);		//업데이트 버튼
				mc.btnClose.addEventListener(MouseEvent.CLICK, btnFuncHideMe);		//닫기 버튼
				padType.addEventListener(Event.CHANGE, rbg_eventHandler);			//체크박스
				langType.addEventListener(Event.CHANGE, rbg_lang_eventHandler);			//언어 체크박스
				_stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			}else{
				mc.mcGuard.visible = true; 
				mc.btnUpdate.removeEventListener(MouseEvent.CLICK, btnFuncUpdate);	//업데이트 버튼
				mc.btnClose.removeEventListener(MouseEvent.CLICK, btnFuncHideMe);	//닫기 버튼
				padType.removeEventListener(Event.CHANGE, rbg_eventHandler);		//체크박스
				langType.removeEventListener(Event.CHANGE, rbg_lang_eventHandler);			//언어 체크박스
				_stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
				
				mc.removeChild(container);
				removeChild(mc);
			}
		}
		
		/****************************************************************************
		 * Event Handler
		 ****************************************************************************/
		private function hideFinished(e:DialogEvent):void
		{
			removeEventListener(DialogEvent.SHOW_FINISH, showFinishHandler);
			removeEventListener(DialogEvent.HIDE_START, hideStartHandler);
			removeEventListener(DialogEvent.HIDE_FINISH, hideFinished);
		}
		
		private function showFinishHandler(e:DialogEvent):void
		{
			setUI(true);
		}
		
		private function hideStartHandler(e:DialogEvent):void
		{
			setUI(false);
		}
		
		//Enter->OK,ESC->OK
		private function keyDownHandler(e:KeyboardEvent):void{
			//FullScreen모드일때 ESC가 눌리면 풀스크린도 해제가 되버리므로 일단 보류.
			/*
			 * switch(e.keyCode){
				case Keyboard.ENTER://Enter
					response = true;
					hide();
				break;
				case Keyboard.ESCAPE://ESC
					response = false;
					hide();
				break;
				
			}*/
		}
		
		/**********************************************************************************
		 *
		 * 업데이트 버튼 클릭용
		 *
		 * ip,port, 패드 번호 정보를 SO에 저장하게함
		 **********************************************************************************/
		private function btnFuncUpdate(e:MouseEvent = null):void
		{
			ip = mc.txtIpNum.text;
			port = mc.txtPortNum.text;
			
			if (_func != null){
				
					SOManager.saveSOInfo(Global.ver, ip, port, padNum, langNum); //페널에서 입력한 유저 정보를 SO 에 저장
					_func(ip, port); //소켓 접속에 필요한 정보만 넘기자.
			}
			hide();
		}
		/**********************************************************************************
		 *
		 * 닫기 버튼 클릭용
		 *
		 **********************************************************************************/
		public function btnFuncHideMe(e:Event = null):void
		{
			hide();
		}
		
	 
		/**********************************************************************************
		 *
		 * 패드 타입용 라디오 버튼 선택용
		 *
		 **********************************************************************************/
		private function rbg_eventHandler(e:Event = null):void
		{
			var rbg:RadioButtonGroup = e.target as RadioButtonGroup;

			if (rbg.selectedData != null)
			{
				padNum = String(rbg.selectedData);
				trace('선택된 라디오 버튼 번호(패드):' + padNum);
				
				if(padNum != '0'){ //학생용 패드일때는 언어 설정 못함
					langType.getRadioButtonAt(0).enabled = false;
					langType.getRadioButtonAt(1).enabled = false;
				}else{//선생님 페드일때만 언어설정이 유요함
					langType.getRadioButtonAt(0).enabled = true;
					langType.getRadioButtonAt(1).enabled = true;
				}
			}
			else
			{
				trace("no value specified.");
			}
		}
		
		/**********************************************************************************
		 *
		 * 언어 타입용 라디오 버튼 선택용
		 *
		 **********************************************************************************/
		private function rbg_lang_eventHandler(e:Event = null):void
		{
			var rbg:RadioButtonGroup = e.target as RadioButtonGroup;

			if (rbg.selectedData != null)
			{
				langNum = String(rbg.selectedData);
				trace('선택된 라디오 버튼 번호(언어):' + langNum);
				Global.language = langNum;
				Global.eventManager.updateLanguage();
				
				SOManager.setLanguage(int(langNum)); //다른 체크 박스는 업데이트 버튼을 누르면 저장이 되지만 다국어의 경우는 체크박스를 클릭하는 순간에 바로 적용이 되므로 바로바로 저장하는게 정답임
				//AppState.modelCenter.setLanguage(id);
			}
			else
			{
				trace("no value specified.");
			}
		}
		
		
		
		/**********************************************************************************
		 *
		 * 라디오 버튼 생성
		 *
		 * 스테이지에 배치하는것 보다 스크립트로 작성하는게 훨씬 경쾌하게 동작함
		 **********************************************************************************/
		private function createRadioButtonGroup(groupName:String,labelList:Array, posY:Number):RadioButtonGroup{
			var group:RadioButtonGroup = new RadioButtonGroup(groupName);
			//var container:Sprite = new Sprite();
			var textFormat:TextFormat = new TextFormat("Arial",12,0x666666);
			var disabledTextFormat:TextFormat = new TextFormat("Arial",12,0x999999);
			var positionX:Number = 0;
			var positionY:Number = posY;
			var i:uint;
	 
			for(i = 0 ; i < labelList.length ; i++){
				var radio:RadioButton = new RadioButton();
				radio.value = i;
				radio.focusEnabled = false;
				radio.tabEnabled = false;
				radio.textField.autoSize =  TextFieldAutoSize.LEFT;
				radio.setStyle("textFormat",textFormat);
				radio.setStyle("disabledTextFormat",disabledTextFormat);
				radio.label = labelList[i];
			
				//trace('padNum:' + padNum);
				if (groupName == 'langType' && padNum != '0'){
					radio.enabled = false;
				}
				
				//콘테이너에 배치
				if (i % 3 == 0){
					positionY += 30;
					positionX = 0;
				}
				radio.y = positionY;
				radio.x = positionX;
				positionX += 100;
				
				//if(labelList.length >= 4){
				//	positionX += 60;
				//}else{
				//	positionX += 100;
				//}
				container.addChild(radio);
				group.addRadioButton(radio);	//RadioButtonGroup에 추가
			}
			return group;
		}
		
		 
	}
}