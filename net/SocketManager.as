package net
{
	import flash.events.*;
	import flash.utils.Timer;
	import flash.net.*;
	import globals.Global;
	
	import net.socket.*;
	import utils.*;
	import ui.dialog.*;

	/**
	 * ...
	 * @author ...
	 */
	public class SocketManager extends ConnectObj
	{

		private var pingSender:Timer;

		private var dialog:Dialog;
		
		private var funcSvrTry:Function;
		private var funcSvrConnect:Function;
		private var funcSvrDisConnect:Function;
		private var funcSvrConnectFail:Function;
		private var funcSvrDataReceive:Function;
		 
		private var ip:String;
		private var port:int;
		
		private var svrState:String; //서버 접속에 실패할 경우, 2번 연속으로 실패 메시지가 날아 오는걸 방지하기 위한 목적
		
		public function SocketManager(ip:String, port:String, funcSvrTry:Function = null, funcSvrConnect:Function = null, funcSvrDisConnect:Function = null,funcSvrConnectFail:Function=null, funcSvrDataReceive:Function = null)
		{
			this.ip = ip;
			this.port = int(port);
			
			this.funcSvrTry = funcSvrTry;					//서버 접속 시도
			this.funcSvrConnect = funcSvrConnect; 			//서버 접속 성공
			this.funcSvrDisConnect = funcSvrDisConnect;		//서버 접속 끊어짐
			this.funcSvrConnectFail = funcSvrConnectFail;	//서버 접속 실패
			this.funcSvrDataReceive = funcSvrDataReceive;	//서버로 부터 받은 데이터 파싱
			 
			svrState = 'STAY';
		}
		
		/**********************************************************************************
		 *
		 * 서버 접속
		 *
		 **********************************************************************************/
		public function connectServer():void
		{
			if (!_connected){
				funcSvrTry(); //서버 접속 시도

				addEventListener(ConnectorEvent.RCV, onDataReceived)
				connect(ip, port, accessOK, accessFail);
				svrState = 'TRY';
			}else{
				Debug.log('이미 서버에 접속 중입니다');
			}
		}
		
		/**********************************************************************************
		 *
		 * 정기적으로 ping 송신
		 *
		 **********************************************************************************/
		private function pingSend():void{
			pingSender = new Timer(5000);
			pingSender.addEventListener(TimerEvent.TIMER, sendPing);
			pingSender.start();
		}
		
		public function sendPing(e:TimerEvent):void
		{
			var msg:KistMessage = new KistMessage();
			msg.operation_name = "req_ping";
			sendMessage(msg);
		}
		
		
		/**********************************************************************************
		 *
		 * 서버 접속 성공
		 *
		 **********************************************************************************/
		private function accessOK():void
		{	
			svrState = 'CONNECTED';
			//removeEventListener(ConnectorEvent.RCV, onDataReceived);
			Debug.log("서버 접속 성공, ip:" + ip + ' , port:' + port);
			pingSend();
			funcSvrConnect();
		}
		

		/**********************************************************************************
		 *
		 * 서버 접속 중 연결이 끊어짐
		 *
		 **********************************************************************************/
		override protected function onDisconnectSvr():void{
			svrState = 'DISCONNECT';
			if(pingSender) pingSender.stop();  //ping 날리기 중지
			//dialog = new MessageDialog('네트워크 연결이 끊겼습니다\n다시 연결을 시도합니다\n(ip:' + ip + ', port:' + port + ')', connectServer);  
			dialog = new MessageDialog('네트워크 연결이 끊어졌습니다\n다시 연결을 시도합니다', connectServer); 
			dialog.show();
		}
		
		private function closeDisconnect():void{
			Debug.log("서버 중간에 끊어짐")
			funcSvrDisConnect();
		}
		
		/**********************************************************************************
		 *
		 * 서버 접속 실패
		 *
		 **********************************************************************************/
		private function accessFail(errMsg:String):void
		{
			if (svrState == 'ACCESS_FAIL'){ //2번 연속으로 들어올 때가 있구료
				trace('같은 메시지가 복수회 전달됨')
				return;
			}
			svrState = 'ACCESS_FAIL';
			
			removeEventListener(ConnectorEvent.RCV, onDataReceived);
			
			Debug.log("서버 접속 실패:(" + errMsg + '), ip:' + ip + ' , port:' + port);
			dialog = new MessageDialog('네트워크에 연결할 수 없습니다\n다시 연결을 시도합니다\n(ip:' + ip + ', port:' + port + ')', connectServer); //Error #2010:Local-with-filesystem SWF 화일은 소켓을 사용할수 없습니다. (세큐리티 설정하세요)
			dialog.show();
			funcSvrConnectFail();
		}
		
		/**********************************************************************************
		 * 
		 * 컨트롤 패널 표시
		 * 
		 * 서버 접속 실패를 알리는 다이얼로그의 OK버튼이 눌린후 다이얼로그가 완전히 사라진 다음 호출됨 
		 * 
		 **********************************************************************************/
		public function retryServerAccess():void
		{
			if (Dialog.waitList.length == 0) {
				dialog = new ControlDialog(UpdateIpPortInfo);
				dialog.show();
			}
		}
		
		
		/**********************************************************************************
		 *
		 * 컨트롤 패널 > 업데이트 버튼 클릭 
		 * 
		 * 컨트롤 패널에서 입력한 정보들
		 *
		 **********************************************************************************/
		function UpdateIpPortInfo(ip:String, port:String):void{
			this.ip = ip;
			this.port = int(port);
						
			Debug.log('ip:' + ip + ' port:' + port);
			connectServer();
		}

		/**********************************************************************************
		 * 서버로 부터 이벤트를 수신
		 *
		 * TM으로 부터 수신하는 메시지는 다음과 같은 포멧으로 구성이 되어있다
		 *
		 * <game-message>
		 * <session id="not_bound"/>		<- 이부분은 무시해도 됨 (TM에서 사용함)
		 * <operation name=“noti_set_image_countdown "/> <- name 에 지정된 문자열이 TM으로 부터 전달되어 오는 메시지
		 * </game-message>
		 **********************************************************************************/
		
		private function onDataReceived(e:ConnectorEvent):void
		{
			var msg:String = e.msg.operation_name.toLowerCase();
			 
			if (msg.indexOf('res_ping') < 0)
			{ 
				Debug.log("서버에서 수신:?", msg);//이걸 전부 로그에 찍는건 로그 화일 사이즈만 커지므로 res_ping 은 일단 Debug.log 표시를 건너뜀
			}
			//param 취득용
			var xmlTmp:XML = XML(e.msg.toXMLStr()); ;
			funcSvrDataReceive(msg, xmlTmp); //여기서 파싱해서 각자 알아서 쓰세요
		}

		/**********************************************************************************
		 *
		 * 서버 송신 메시지
		 *
		 **********************************************************************************/
		public function onSendKistMessage(operation:String):void{
			
			var msg:KistMessage = new KistMessage();
			msg.operation_name = operation;
			
			switch(operation){
				case 'req_select_padinfo_by_id':
					var padNum:String 	= SOManager.getShared('PAD_NUM');
					msg.addParameterValue('macaddr', padNum)
				case 'regist':
					//msg.addParameterValue('uri', getMacAddress());
					break;
				case 'req_select_padinfo_by_macaddr':
					//msg.addParameterValue('macaddr', getMacAddress());
					break;
				case 'req_select_lastattendaceuser_by_macaddr':
					//msg.addParameterValue("macaddr", seatNo);
					break;
				case 'req_join_game':
					//msg.addParameterValue("userid", userID);
					//msg.addParameterValue("gameid", ConfigManager.GAME_ID);
					break;
			}
			sendMessage(msg);
		}
	}
}