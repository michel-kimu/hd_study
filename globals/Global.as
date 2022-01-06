package globals{
	import net.*;
	import flash.text.Font;
	import media.sound.SoundManager;
	import users.User;
	import utils.LoadingIcon;
	import ui.language.*;
	import event.*;
	
	public class Global {
		
		public static var id:String = '';
		public static var ver:String = '';
		public static var language:String = '0'; 	//0:한국어, 1:영어
		
		public static var socketManager:SocketManager;
		public static var loadingIcon:LoadingIcon = new LoadingIcon();
		public static var sentenceManager:SentenceManager;
		public static var soundManager:SoundManager = new SoundManager();
		public static var eventManager:CustomEventManager = new CustomEventManager();
	
		public static var inrfnt:Font = new fntNotoSans();
		
		//콘테츠별 변수
		//
		public function Global() {
		}
		
		//소켓 인스턴스를 생성
		public static function initSocketManager(ip:String, port:String, funcSvrTry:Function = null, funcSvrConnect:Function = null, funcSvrDisConnect:Function = null, funcSvrConnectFail:Function = null , funcSvrReceiveData:Function = null){
			socketManager = new SocketManager(	ip, 
												port, 
												funcSvrTry, 
												funcSvrConnect, 
												funcSvrDisConnect, 
												funcSvrConnectFail,
												funcSvrReceiveData
												);
		}
		//

		public static var sentakusi:String = '';
		public static var seikai:String = '';
		
		public static function isLauncher():Boolean{
			trace(id);
			if (CONFIG::DEBUG){
				return true; //debug use
			}
			var rslt:int = id.indexOf('LAUNCHER')
			
			return (rslt !=-1)?true:false;
		}
		
		//콘테츠별 변수
		//public static var usersName:Array; 		 	//출석한 유저명
		//public static var padAccessed:Array; 	 		//패드 접속 상황
		//public static var userGroupInfo:Array;		//교실 정보
		//public static var tabNum:int;					//탭 순서(1~)
		//public static var users:Array = new Array();	//MMS Test 사용자 (이름+주민번호) 검색 결과, 
		//public static var currentUser:User;
		
		//public static var arrMMSEScore:Array = new Array(30);			//라디오 버튼 상태 (O:1점, X:0점)
		//public static var arrSGDSScore:Array = new Array(15);			//상동
		//public static var currentDir:String;			//테스트 페이지는 신규등록과 검색 페이지에서 접근이 가능한데 '돌아가기' 버튼은 어느 페이지에서 왔는지를 구분하기 위해 이 변수가 필요
		//
	}
}