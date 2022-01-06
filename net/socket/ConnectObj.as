package net.socket{
	
	import flash.events.EventDispatcher;
	import utils.*;
	
	public class ConnectObj extends EventDispatcher {
		private var socket:SocketControl;
		
		private var reqQueue:Array = new Array();
		private var msgMap:Map = new Map();
		
		private var onConnectFunc:Function = null;
		private var onFailFunc:Function = null;
		
		public var _connected:Boolean = false;
		
		public function ConnectObj() {
			socket = SocketControl.getSocketControl();
			socket.setReceiveFunc(onMsgReceive)	//SocketControll에서 수신한 xml 데이터를 kistmessage 로 가공한뒤, 
		}
		
		private function onMsgReceive():void {
			var msg:KistMessage;
			//trace('callBackL:' + callBack);
			while (msg = socket.getFirstMessage()) {
				dispatchEvent(new ConnectorEvent(ConnectorEvent.RCV, msg));
				var callBack:Function = reqQueue[msg.session_id] as Function;
				if (callBack != null) {
					callBack(msg);
				}else {
					callBack = msgMap.getValue(msg.session_id.toString()) as Function;
					if (callBack != null) {
						callBack()
					}
				}
			}
		}
		
		public function connect(ip:String , port:int, onConnectFunc:Function = null, onFailFunc:Function = null):void {
			this.onConnectFunc = onConnectFunc;
			this.onFailFunc = onFailFunc;
			
			socket.connect(ip, port, onConnect, onConnectFail);
			socket.setDisconnectFunc(onDisconnect);
		}
		
		public function disconnect():void{
			socket.disconnect();
		}
		
		public function onDisconnect():void {
			//Debug.log("disconnected");			
			onDisconnectSvr();
			_connected = false;
		}
		
		private function onConnect():void {
			_connected = true;
			
			if ( null != onConnectFunc )
				onConnectFunc();
		}
		
		private function onConnectFail(msg:String):void {
			_connected = false;
		
			if ( null != onFailFunc ){
				onFailFunc(msg);
			}
		}
 
		public function get connected():Boolean { return _connected; }
		
		/*********************************************************************************/
		
		public function sendMessage(msg:KistMessage, callback:Function = null):void 
		{
			dispatchEvent(new ConnectorEvent(ConnectorEvent.SND, msg));
			
			reqQueue[SocketControl.getMsgID().toString()] = callback; //getMsgID()로 콜벡함수가 들어갈 배열의 인덱스를 지정한다.getMsgID()는 send()가 불릴때 마다 카운트업된다. 초기치는 0.
			socket.send(msg);		
		}
		
		public function regist(uri:String = "KIST"):void { //'KIST' 는 디폴트로 한 서버에는 같은 KIST를 쓰는 어프리가 2개이상 붙을수 없으므로 이 이름은 겹치지 않는 유니크한 이름으로 바꿀것.
			var msg:KistMessage = new KistMessage();
			msg.operation_name = "regist";
			msg.addParameterValue("uri", uri);
			
			sendMessage(msg);
		}
		
		public function reqGame(gameID:String, callback:Function):void {
			var msg:KistMessage = new KistMessage();
			msg.operation_name = "req_game";
			msg.addParameterValue("gameid", gameID);
			
			sendMessage(msg, callback);
		}
		//
		protected function onDisconnectSvr():void{}
	}
}