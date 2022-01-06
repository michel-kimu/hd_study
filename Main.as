package{
	import flash.geom.*;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import users.User;

	import event.CustomEventManager;
	import ui.dialog.*;
	import globals.*;
	import utils.*;
	import net.socket.*;
	
	public class Main extends GameModule{
		var em:CustomEventManager;
		
		public function Main() {
			Global.id = Utils.getMyFileName(this).toUpperCase(); //소스하나로 여러개의 앱을 생성..
	 
			//trace('Global.id:' + Global.id);
			Global.ver = 'ver.0.0.2a';
			super();
		}
		
		/**********************************************************************************
		 *
		 * 안드로이드 기기의 스테이지 사이즈에 맞게 메인 무비클립을 리사이즈
		 *
		 **********************************************************************************/
		protected override function calcAndroidMobileDeviceLayoutScale()
		{
			Utils.calcDeviceLayoutScale(666,400, StageReference.stage); //
		}
		
		protected override function Start():void{
			gotoAndPlay('start');

			Global.soundManager.setInit_AllChannelVolume( 1.0, 1.0, 1.0, 1.0);//사운드는 모바일에서 괭장히 느려짐

			Global.id = 'PAD_'+padNum +'_GAME21';

			//Global.socketManager.regist(Global.id);// 'PAD_' + SOManager.getShared('PAD_NUM')); //regist 를 해 줘야 서버에 새로운 방이 생김
			//Global.socketManager.onSendKistMessage('req_select_padinfo_by_id');
			 
			//em = Global.eventManager;
			//em.addEventListener(CustomEventManager.TAB_CHANGED, funcTabChanged);
 
			//해상도에 상관없이 BG 사이즈를 변경/설정
			mcBG.scaleX = mcBG.scaleY = Utils.bgScale;
			mcBG.x = stage.fullScreenWidth / 2
			mcBG.y = stage.fullScreenHeight / 2
		
			//메인mc 사이즈 설정
			//trace('Utils.layoutScale:' + Utils.layoutScale);
			
			mcMain.scaleX = mcMain.scaleY = Utils.layoutScale;

			mcVRBase.scaleX = mcVRBase.scaleY = Utils.layoutScale; //가상의 프론트 베이스를 하나 만들고 이 베이스의 위치에 mcMain을 배치하면 mcMain의 스테이지밖으로 이미지가 조금만 나가도 전체 중심이 틀어지는 문제를 방지할 수 있음
			
			if (Utils.isAndroid()){
				mcVRBase.x = stage.fullScreenWidth / 2 - mcVRBase.width / 2;
				mcVRBase.y = stage.fullScreenHeight / 2 - mcVRBase.height / 2;
			}else{
				mcVRBase.x = stage.stageWidth / 2 - mcVRBase.width / 2;
				mcVRBase.y = stage.stageHeight / 2 - mcVRBase.height / 2;
			}
			
			//세로방향에서 가로로 패드를 돌리는 타이밍에 이 처리를 하면 베이스가 0,0 위치가 아닌 -399,400 (겔럭시 A7 2000x1200 의경우) 위치에서 시작이 되므로 무조건 0,0 으로 맞춤
			
			mcVRBase.x = 0;// stage.fullScreenWidth / 2 - mcVRBase.width / 2;
			mcVRBase.y = 0;// stage.fullScreenHeight / 2 - mcVRBase.height / 2;
				
			mcMain.x = mcVRBase.x;
			mcMain.y = mcVRBase.y;
			//
			//mcVersion.y = 10;
			//mcVersion.setVersion(Global.ver);
		}
		
		protected override function goPage(namae:String):void{
			//trace('namae' + namae);
			switch(namae){
				case 'title':
				 	mcMain.gotoAndPlay('title');
					break;

				case 'control':	
				case 'prev':
				case 'win':
				case 'lose':
				 
					mcMain.gotoAndPlay(namae);
					break;
			}
		}
		
		//사용자 점수 저장(강사패드로 전송한 후, 강사패드에서 DB로 저장)
		protected override function sendUserSaveScores():void{
			if (mcMain) mcMain.sendUserSaveScores(); 
		}
	}
}