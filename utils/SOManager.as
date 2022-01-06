package utils
{
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.net.*;
 	import utils.*;
	import globals.Global;
	/**
	 * ...
	 * @author ...m.kmu 2015.05.25
	 * 
	 * 사용법
	 * 1) 초기화
	 * 		SOManager.init();  
	 * 	
	 * 2) 키와 값 저장
	 * 		var so:Object = {}
	 *		so['LANGUAGE'] = 'KOR';
	 *		SOManager.setShared(so, temp);
	 * 
	 * 3) 키 값을 로드
	 *		SOManager.getShared('LANGUAGE')
	 * 
	 * 4) 키값을 삭제
	 * 		SOManager.deleteShared('LANGUAGE');
	 * 
	 * 5) SharedObject기록 자체를 완전 삭제
     *		SOManager.clearShared();
	 */
	public class SOManager 
	{
		private static const SO_NAME:String = 'SCC_HOMESTUDY_2107_09';
		private static const SO_BYTES:int = 20000;  //필요한 용량 (Bytes)
		
		private static var so:SharedObject;
		private static var callback:Function;
		
		public function SOManager(){		
		}
		
		public static function init():void{
			if(so)so.removeEventListener(NetStatusEvent.NET_STATUS,netStatusEventHandler);
			so = SharedObject.getLocal(SO_NAME);
			Debug.log('SharedObject Manager : OK');
			so.addEventListener(NetStatusEvent.NET_STATUS,netStatusEventHandler);
		}
		/********************************************************************************
		* 저장하기
		* 
		■사용법
		 var so:Object = {}
		 so[SOKey] = true;
		SOManager.setShared(so) 
		********************************************************************************/
		public static function setShared(data:Object, _callback:Function = null):String{
			callback = _callback;
			
			//복제를 SharedObject 에 대입
			var name:String;
			for (name in data){
				so.data[name] = Utils.copy(data[name]);
			}
			
			//저장
			var status:String = '';
			try{
				status = so.flush(SO_BYTES);
				switch(status){
					case SharedObjectFlushStatus.FLUSHED:
						if (callback is Function) callback(true);
						callback = null;
						break;
						
					case SharedObjectFlushStatus.PENDING: 
						//플래시 플래이어의 다이어로그가 표시됨 (저장 허가, 저장용량 확인 요구)
						//그밖의 netStatus 이벤트가 나오므로 netStatusEventHandler 로 콜백
						break;
				}
			}catch (e:*){
				if (callback is Function) callback(false); 
				callback = null;
			}
			return status;
		}

		/********************************************************************************
		* 지정한 데이터를 꺼내옴(복제해서 되돌림)
		* 
		■사용법
		 setShared()에서 사용한 SOKey 를 파라매터로 넘기면 해당 데이터를 취득함
		********************************************************************************/
		public static function getShared(name:String):*{
			return Utils.copy(so.data[name]);
		}
		
		/********************************************************************************
		 * 지정한 키의 데이터를 삭제함
		 * 
		********************************************************************************/
		public static function deleteShared(name:String):void{
			delete so.data[name];
			trace(name + '데이터를 삭제함');
		}
		
		/********************************************************************************
		 * 모두 삭제！
		 * SharedObject 의 화일 자체를 삭제함
		********************************************************************************/
		public static function clearShared():void{
			so.clear();
		}
		
		//감시
		private static function netStatusEventHandler(e:NetStatusEvent):void{		 
			switch(e.info.level){
				case "status":
				//성공
				if(callback is Function)callback(true);
				callback = null;
				break;

				case "error":
				//실패
				if(callback is Function)callback(false);
				callback = null;
				break;
			}
		}
		
		
		/********************************************************************************
		 * SO LOAD
		********************************************************************************/
		public static function loadSOInfo():Object{
			
			//Ip,Port,PadNum정보를 Shared Object 로 부터 취득
			var so:Object = new Object();
			
			var ver:String 		= getShared('VER');
			var ip:String 		= getShared('IP');  
			var port:String		= getShared('PORT');
			var padNum:String 	= getShared('PAD_NUM');
			var langNum:String  = getShared('LANGUAGE');
			
			//SO에 데이터가 저장되어 있지 않으면 되돌리는 Null을 그대로 대입하지 않게함
			so.ver = (ver == null)?'':ver;
			so.ip = (ip == null)?'':ip;
			so.port = (port == null)?'':port;
			so.padNum = (padNum == null)?'0':padNum;
			so.langNum = (langNum == null)?'0':langNum;
				
			Debug.log('SOManager :  ip:' + ip + ', port:' + port + ', padNum:' + padNum + ',langNum:'+langNum);
			return so;
		}
		
		/********************************************************************************
		 * SO SAVE
		********************************************************************************/
		public static function saveSOInfo(ver:String, ip:String, port:String, padNum:String, langNum:String):void{
			var so:Object = {}
			
			so['VER'] = ver;
			so['IP'] = ip;
			so['PORT'] = port;
			so['PAD_NUM'] = padNum;
			so['LANGUAGE'] = langNum;
			
	  		var rslt:String = setShared(so);
			Debug.log('SO 저장 완료:' + rslt);
		}
		
		/********************************************************************************
		 * 언어 설정 로딩
		********************************************************************************/
		public static function getLanguage():String{
			var lang:String = SOManager.getShared('LANGUAGE');
			lang = (lang == null)?'0':lang;
			return lang;
		}
		
		/********************************************************************************
		 * 언어 설정 저장
		********************************************************************************/
		public static function setLanguage(id:int):void{
			var so:Object = {}
			so['LANGUAGE'] = id.toString();
			SOManager.setShared(so);
			Debug.log('언어 변경:' + SOManager.getShared('LANGUAGE'))
		}
	}
}