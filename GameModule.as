package
{
	import flash.display.*;
	import flash.system.*;
	import flash.events.*;
	import flash.ui.*;
	import flash.desktop.*;
	import flash.net.*;
	
	import utils.*;
	import globals.Global;
	import ui.language.*;
	import event.CustomEventManager;
 
	
	public class GameModule extends MovieClip
	{
		public function GameModule()
		{
			try{Security.allowDomain("*");}catch (e){};
			(stage)?init():addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			initStageReference();

			debugSetting();
			
			calcAndroidMobileDeviceLayoutScale();
			
			SOManager.init(); 
			
			//socketConnect();
			Start();
		}
		
		/**********************************************************************************
		 *
		 * 언어별 문장 화일 관련
		 * 
		 *
		 **********************************************************************************/
		//public function initSentenceManager():void{
		//	Global.sentenceManager = new SentenceManager(sentenceFileLoadingComplete);
		//}
		
		public function sentenceFileLoadingComplete():void{
			Debug.log("언어 화일 로딩 완료");
			Global.loadingIcon.hide(); //로딩 아이콘 감추기
	
			Start();
		}
		
		/**********************************************************************************
		 *
		 * 디버그 세팅
		 * 
		 *
		 **********************************************************************************/
		public function debugSetting():void{
			if (CONFIG::DEBUG){
				Debug.enabled = true;
				Debug.log('Debug start'); //디버그 선언후 반드시 로그를 찍어 줄것
				//SWFProfiler.init(stage, this);
			}
		}
		
		/**********************************************************************************
		 *
		 * 소켓 접속 시도
		 * 
		 * 런처일때와 아닐때 각각 접속 방식이 다름.
		 * 
		 * 런처일때는 Shared Object로 부터IP,Port 등의 정보를 취득, 런처가 아닐때는 런처에서 부터 전달 받은 정보로 
		 * 소켓에 접속을 시도함.
		 *
		 **********************************************************************************/
		public function socketConnect():void{
			if (Global.isLauncher()){
				
				SOManager.init();  //SharedObject Manager 초기화 (ip,port,pad타입등을 저장함)
				trace('디버그용. 1이라고합세');
				//padNum = "2"; //디버그용. 1이라고합세
				//Global.padNum = padNum;
				
				//Ip,Port,PadNum정보를 Shared Object 로 부터 취득
				var so:Object = SOManager.loadSOInfo();
				//Global.initSocketManager(so.ip, so.port, svrConnectTry, svrConnectedOk, svrDisconnect, svrConnectFail, svrReceiveData);
				Global.initSocketManager('192.168.112.121', '5050', svrConnectTry, svrConnectedOk, svrDisconnect, svrConnectFail, svrReceiveData);
				Global.socketManager.connectServer(); //서버 접속 시도
			
			}else{
				var na:NativeApplication = NativeApplication.nativeApplication;
				na.addEventListener(InvokeEvent.INVOKE, invokeProc);
				Debug.log("Target App");
			}
		}
		
		/**********************************************************************************
		 *
		 * 런처로 부터 기동된 앱이 IP,Port등의 정보를 취득
		 *
		 **********************************************************************************/
		
		public var padNum:String;
		
		public function invokeProc(e:InvokeEvent):void{
			Debug.log('Invoke!!');
			if (e.arguments[0] == undefined) return;
			
			var str:String = e.arguments[0].toString();
			var answerArr:Array = str.split("//");
			for(var i:int = 0 ; i < answerArr.length; i++){
				Debug.log(answerArr[i]);
			}

			if (e.arguments.length > 0) {
				Debug.log("ip:" + answerArr[1] + ', port:' +answerArr[2]  + ', padNum:' +answerArr[3] );
				
				var ip:String = answerArr[1];
				var port:String = answerArr[2];
				padNum = answerArr[3];
				
				//Global.padNum = padNum;
				
				Global.initSocketManager(ip, port, svrConnectTry, svrConnectedOk, svrDisconnect, svrConnectFail, svrReceiveData);
				Global.socketManager.connectServer(); //서버 접속 시도
			} else {
				Debug.log("그냥 기동");
			}
		}
		
		/**********************************************************************************
		 *
		 * 서버 재 접속 시도
		 *
		 **********************************************************************************/
		public function retryServerAcc(e:Event = null):void{
			Global.socketManager.retryServerAccess();
		}
		
		/**********************************************************************************
		 *
		 * 스테이지 설정
		 *
		 **********************************************************************************/
		private function initStageReference():void
		{
			StageReference.stage = stage
			StageReference.quality = StageQuality.BEST;
			
			if (Utils.isAndroid())
			{
				StageReference.scaleMode = StageScaleMode.NO_SCALE;
				StageReference.align = StageAlign.TOP_LEFT;
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT; //한손가락으로만 조작
				 
				NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE; //시스템이 유휴 모드로 전환되지 않도록
			}
			else
			{
				StageReference.scaleMode = StageScaleMode.SHOW_ALL;
				//	StageReference.displayState = StageDisplayState.FULL_SCREEN;
				StageReference.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE; //AIR모드에서 키보드 입력이 가능하도록 (보통 FullScreen 에서 키보드 입력이 안되므로)
			}
		}
		
		/**********************************************************************************
		 * 
		 * 서버 접속 시도
		 * 
		 **********************************************************************************/	
		function svrConnectTry(e:Event = null):void{
			Global.loadingIcon.show();
			Debug.log('서버 접속 시도');
		}
		
		/**********************************************************************************
		 * 
		 * 서버 접속 성공
		 * 
		 **********************************************************************************/
		function svrConnectedOk(e:Event = null):void{
			Debug.log('서버 접속 성공 , 언어 화일 로딩');
			
			sentenceFileLoadingComplete();
		}
		
		/**********************************************************************************
		 * 
		 * 서버 접속 실패
		 * 
		 **********************************************************************************/
		function svrConnectFail(e:Event = null):void{
			Debug.log('서버 접속 실패! ');
			Global.loadingIcon.hide(); //로딩 아이콘 감추기
			
			//Start(); //서버에 억세스가 되건 안되건 일단 톱페이지는 보여 주세요
		}
		
		/**********************************************************************************
		 * 
		 * 서버 접속 끊어짐
		 * 
		 **********************************************************************************/
		function svrDisconnect(e:Event = null):void{
			Debug.log('서버 접속 끊어짐 : TOP으로 보내거나...하셈');
		}
		
		/**********************************************************************************
		 * 
		 * 서버로 부터 데이터 수
		 * 
		 **********************************************************************************/
		function svrReceiveData(msg:String, xmlTmp:XML):void{
			
			//Debug.log('msg:' + msg);
			//trace('param:' + xmlTmp);
		/*	
			var tmp:String = '';
			var arr:Array;
			
			switch(msg) {
				case 'noti_game_close': //게임 종료
					sendUserSaveScores();
					systemQuit()
				break;
				
				case 'noti_pad_title_page': 
					Global.winner = '-1'; 
					Global.selectUserPadNum = 	'-1';
					Global.selectUserLeft = 	'-1';
					Global.selectUserRight = 	'-1';

				case 'noti_select_human_vs_human': 
					Global.level = 'human';  //사람과 싸워요
					goPage('title');		//무조건 앞으로
					break;
					
				case 'noti_select_robot_vs_human':
					Global.level = 'robot';  //로봇과 싸워요
					goPage('title');		//무조건 앞으로
					break;
					
				case 'noti_select_robot_level_menu'://레벨선택 페이지
				case 'noti_goto_select_game_type':	
					goPage('title');		//무조건 앞으로
					break;
					
				case 'noti_selected_user': //선생 패드에서 선택한 사용자의 패드 번호를 취득. 여기서 취득한 번호와 각 패드의 번호가 같은 패드에서만 콘트롤러를 표시함
					tmp = xmlTmp.parameters.parameter.(@name == 'padNum')[0].value;
					Global.selectUserPadNum = (int(tmp) + 1).toString();
					if(Global.padNum == Global.selectUserPadNum)Global.direction = 'RIGHT';  //Cpu vs Human 은 Right 로 함
					trace('선택한 사용자의 패드 번호:' + Global.selectUserPadNum + ' , 방향:' + Global.direction);
					
					break;
						
				case 'noti_selected_left_users':
					tmp = xmlTmp.parameters.parameter.(@name == 'padNum')[0].value;
					Global.selectUserLeft = (int(tmp) + 1).toString();
					if(Global.padNum == Global.selectUserLeft)Global.direction = 'LEFT';  //좌측 사람
					Debug.log('선택한 사용자의 패드 번호:' + Global.selectUserLeft + ' , 방향:' + Global.direction + ',Global.padNum:' + Global.padNum + 'tmp:' + Global.selectUserLeft);
					break;
					
				case 'noti_selected_right_users':
					tmp = xmlTmp.parameters.parameter.(@name == 'padNum')[0].value;
					Global.selectUserRight = (int(tmp) + 1).toString();
					if(Global.padNum == Global.selectUserRight)Global.direction = 'RIGHT';  //좌측 사람
					Debug.log('선택한 사용자의 패드 번호:' + Global.selectUserRight + ' , 방향:' + Global.direction + ',Global.padNum:' + Global.padNum + 'tmp:' + Global.selectUserRight);
					break;
					 
				case 'noti_user_pad_rensyu': //패드 연습패이지
					//trace('Global.padNum:' + Global.padNum);
					//trace('Global.selectUserPadNum:' + Global.selectUserPadNum);
					//trace('Global.selectUserLeft:'+Global.selectUserLeft);
					//trace('Global.selectUserRight:' + Global.selectUserRight);;
					if (Global.padNum == Global.selectUserPadNum || Global.padNum == Global.selectUserLeft || Global.padNum == Global.selectUserRight) goPage('prev');
					break;
					
				case 'noti_standby_game':  //선생패드에서 '게임 시작' 버튼이 있는 페이지, 
					if (Global.padNum == Global.selectUserPadNum || Global.padNum == Global.selectUserLeft || Global.padNum == Global.selectUserRight) goPage('control');
					break;	

				case 'noti_pong_game_winner': //누가 이겼나?
					tmp = xmlTmp.parameters.parameter.(@name == 'winner')[0].value; //'LEFT'/'RIGHT' 중 하나
					if (Global.direction == tmp){
						if (Global.padNum == Global.selectUserPadNum || Global.padNum == Global.selectUserLeft || Global.padNum == Global.selectUserRight) {
							Global.winner = "WIN";
							goPage('win'); //승자
						}
					}else{
						if (Global.padNum == Global.selectUserPadNum || Global.padNum == Global.selectUserLeft || Global.padNum == Global.selectUserRight){
							Global.winner = "LOSE";
							goPage('lose'); //패자
						}
					}
					break;

			}*/
		}
		
		
		/**********************************************************************************
		 * 
		 * 어플리케이션 종료
		 * 
		 **********************************************************************************/
		public function systemQuit(e:Event = null):void{
			
			try{
				Global.socketManager.disconnect();
				Debug.log('소켓 절단, 앱 종료');
				if (Utils.isAndroid()){
					NativeApplication.nativeApplication.exit();
				}else{
 					System.exit(0); //IDE에서 확인 안됨. 퍼블리시 끝난 swf 에서 실행할것
				}
			}
			catch (err:Error)
			{
				Debug.log('Quit Error');
				 
			}
		}

		/**********************************************************************************
		 *
		 * 안드로이드 기기의 스테이지 사이즈에 맞게 메인 무비클립을 리사이즈
		 *
		 **********************************************************************************/
		protected function calcAndroidMobileDeviceLayoutScale() { }
		
		/**********************************************************************************
		 *
		 * 기본 준비 완료
		 *
		 **********************************************************************************/
		protected function Start():void { }
		protected function goPage(namae:String):void{}
		protected function sendUserSaveScores():void{} 
	}
}