package net.socket
{
	/**
	 * ...
	 * @author Krucef
	 */
	
	import flash.net.Socket;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.system.Security;
	import flash.system.Capabilities;
	
	import utils.*;
	import ui.dialog.*;
　
	public class SocketControl
	{
		public static var socketcontrol:SocketControl = null;
		private static var msg_id:int = 0;
		private var soc:Socket;
		
		private var receiveFunc:Function = null;
		private var socketCloseFunc:Function = null;
		private var socketOpenFunc:Function = null;
		private var socketOpenFailFunc:Function = null;
		private var socketDisconnectFunc:Function = null; //m.kimu  소켓이 끊어졌을 경우 실행될 메서드
		
		public var messageQueue:Array;
		
		public var funcStack:Array;
		
		public var bufferstr:String;
		
		private var splitstr:String;
		
		private var ip:String; //2016.01.06 mkim
		private var port:int;
		
		public var nowOS:String;
		
		public static function getSocketControl():SocketControl {
			if (socketcontrol == null )
				socketcontrol = new SocketControl();
			return socketcontrol;
		}		
		
		public static function getMsgID():int {
			return msg_id;
		}
		
		public function SocketControl() 
		{
			createSocket();
			//
			messageQueue = new Array();
			funcStack = new Array();
			
			bufferstr = "";
			
			splitstr = '@\r\n';  //안드로이드도 이걸쎄?
			
			//AIR로 만든 서버는 상관이 없는데 TM 은 아바타가 Window이건 아니건 상관없이 Linux 의 기호로 보내온다.
			//개발할때 스위칭 할것.
		 	if((Capabilities.os.indexOf("Windows") >= 0))
			{
				nowOS = 'Os:Win';
				splitstr = '@\r\n';
			//	splitstr = '@\n'; //<- 요부분!!    윈도우라도 서버가 리눅스라 이게 들어오네 그려,
			}
			else if((Capabilities.os.indexOf("Mac") >= 0))
			{
				nowOS = 'Os:Mac';
				splitstr = '@\n';
			 } 
			else if((Capabilities.os.indexOf("Linux") >= 0)) 
			{
				nowOS = 'Os:Linux';
				splitstr = '@\n';
				
				if (Capabilities.manufacturer == "Android Linux"){
					nowOS = 'Os:Android';
					splitstr = '@\r\n';  //안드로이드도 이걸쎄?
				}
			}
		}
		
		
		private function createSocket():void {
						
			if (soc != null){
				soc.close(); //이거 생략하면 에러뜸(Error #2044: Unhandled securityError:. text=Error #2048: Security sandbox violation: file:/~)
				if (soc.hasEventListener(ProgressEvent.SOCKET_DATA)) soc.removeEventListener(ProgressEvent.SOCKET_DATA, onReceive);
				if (soc.hasEventListener(Event.CONNECT)) soc.removeEventListener(Event.CONNECT, onConnect);
				if (soc.hasEventListener(Event.CLOSE)) soc.removeEventListener(Event.CLOSE, onDisconnect);
				if (soc.hasEventListener(SecurityErrorEvent.SECURITY_ERROR)) soc.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
				if (soc.hasEventListener(IOErrorEvent.IO_ERROR)) soc.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);		
			}
			
			soc = new Socket();
			soc.timeout = 10 * 1000;
			
			soc.addEventListener(ProgressEvent.SOCKET_DATA, onReceive);
			soc.addEventListener(Event.CONNECT, onConnect);
			soc.addEventListener(Event.CLOSE, onDisconnect);
			soc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			soc.addEventListener(IOErrorEvent.IO_ERROR , onIoError);			
		}
		
		
		public function isConnected():Boolean {
			return soc.connected;
		}
		
		public function setReceiveFunc(receiveFunc:Function) {
			this.receiveFunc = receiveFunc;
		}
		
		public function connect(ip:String, port:int, onConnectFunc:Function = null, onFailFunc:Function = null) {
			this.ip = ip;
			this.port = port;
			
			socketOpenFunc = onConnectFunc;
			socketOpenFailFunc = onFailFunc;
			
			try {
				soc.connect(ip, port);
			}catch (e:Error) {
				var dialog:Dialog;
				dialog = new BasicDialog(e.message); //Error #2010:Local-with-filesystem SWF 화일은 소켓을 사용할수 없습니다. (세큐리티 설정하세요)
				dialog.show();
			}
		}
		
		public function setDisconnectFunc(func:Function = null):void{
			socketDisconnectFunc = func;
		}
		public function disconnect(func:Function = null) {
			socketCloseFunc = func;
			soc.close();
		}
		
		public function getFirstMessage():KistMessage {
			if(messageQueue.length > 0)
				return messageQueue.shift();
			return null;
		}
		
		public function onSecurityError(event:SecurityErrorEvent):void {
			Debug.log("SocketControl::SecurityError"+socketOpenFailFunc)
			if( socketOpenFailFunc != null )
				socketOpenFailFunc("security error");
		}
		
		public function onIoError(event:IOErrorEvent):void {			
			if ( socketOpenFailFunc != null ){
				trace('서버 연결 실패');
				soc.close(); //서버 접속 시도 하지 않도록.
				socketOpenFailFunc(event.toString());
			}
		}		
		
		public function onConnect(event:Event):void {
			Debug.log(">SocketControl::connect success");
			if (socketOpenFunc != null)
				socketOpenFunc();
		}
		
		public function onDisconnect(event:Event):void {
			Debug.log("SocketControl::disconnect success");
			
			if (socketDisconnectFunc != null) 
			{
				soc.close();
				socketDisconnectFunc();
			}
		}
		
		//접속이 끊어졌을 경우, retry 함  2016.01.06 mkim
		private function retryConnect():void {
			Debug.log('socket server retry connect: ip:'+ip + ' port:'+port);
			
			createSocket();
			
			try {
				soc.connect(ip, port);
			}catch (e:Error) {
				Debug.log('SOCKET SERVER ERROR:' + e.message);
			}
		}
		
		public function onReceive(event:ProgressEvent):void {
			//Debug.log("receive_message - msg length:" + soc.bytesAvailable + "byte : " + event.bytesLoaded);
			try
			{
				while ( soc.bytesAvailable > 0 ) {
					var msg:String = soc.readUTFBytes(soc.bytesAvailable);
					
					
					msg = bufferstr + msg;
					bufferstr = "";
					
			
					if(msg.indexOf(splitstr) == -1 ) {
						bufferstr = msg;
						
						return;
					}
					
					var strmsgs:Array = msg.split(splitstr);
					
					//Debug.log("******************************** recv ********************************");
					for (var i:int = 0; i < strmsgs.length - 1; i ++ ) {
						if (strmsgs[i] != "" ) {
							//Debug.log("↓----------------------------------↓");
							//Debug.log(strmsgs[i]);
							//Debug.log("↑----------------------------------↑");
							var kistmessage:KistMessage = new KistMessage();
							var xmlstr:String = strmsgs[i];
							var xml:XML = new XML(xmlstr);
							kistmessage.setXMLData(xml);					
							messageQueue.push( kistmessage );
						}
					}
						
					if (strmsgs[strmsgs.length -1] != "")
						bufferstr += strmsgs[strmsgs.length -1];
					
					if (receiveFunc != null ) {
						receiveFunc();
					}
				}
			} catch ( e:Error )	{
				Debug.log('onReceive : ' + e.toString() );
			}
		}
		
		public function getReceiveMsgLength():int {
			return messageQueue.length;
		}
		
		public function procMessages( msg_no:int = 0 ) {
			var count:int = 0;
			while ( messageQueue.length != 0 ) {
				var xmldata:XML = messageQueue.shift();
				if (xmldata.header.msg_id.length() > 0 ){
					var msg_id:int = int(xmldata.header.msg_id[0]);
					if (funcStack[msg_id] != null) {
						((funcStack[msg_id]) as Function )( xmldata );
					} else {
						receiveFunc(xmldata);
					}
				}
				
				count ++;
				
				if(msg_no != 0) {
					if(count >= msg_no)
						break;
				}
			}
		}
		
		public function send(kistmessage:KistMessage , proc:Function = null):void {
			kistmessage.session_id = msg_id;
			var str:String = kistmessage.toXMLStr();
			if(proc != null)
				funcStack[msg_id] = proc;
				
			SocketControl.msg_id  = SocketControl.msg_id + 1;
			
			if ( isConnected()) {
				 
				if (str.indexOf('req_ping')<0) { //이걸 전부 로그에 찍는건 로그 화일 사이즈만 커지므로 req_ping 은 일단 Debug.log 표시를 건너뜀
					Debug.log(nowOS  +"******************************** send ********************************", msg_id);
					Debug.log(str);
				}
				soc.writeUTFBytes(str + '\n@\n');
				//soc.writeUTFBytes(str + splitstr);
				soc.flush();	
			}else {
				Debug.log('불명한 소켓입니다. 접속을 확인 하세요');
			}
			
		}		
	}

}