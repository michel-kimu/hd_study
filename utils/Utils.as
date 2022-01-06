package utils{

	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	import flash.display.*;
	import flash.system.*;
	import flash.ui.*;
	
	
	public class Utils{

		public function Utils():void{
		}

		//지정한 프레임 뒤에서 콜벡
		public static function waitFrame(callback:Function,waitFrame:uint = 1):Sprite{
			var sprite:Sprite = new Sprite();
			var count:uint = waitFrame;
			var eventHandler:Function = function(e:Event):void{
				count--;
				if(count > 0)return;
				e.target.removeEventListener(e.type,arguments.callee);
				callback();
				sprite = null;
			}
			sprite.addEventListener(Event.ENTER_FRAME,eventHandler);
			return sprite;
		}

		//배열안에서 지정한 프로퍼티를 가진 최초의 오브젝트의 인덱스를 되돌림
		public static function indexOfByProp(list:Array,prop:String,val:*):int{
			var returnIndex:int = -1;
			var callback:Function = function(item:*,index:int,list:Array):Boolean{
				var bool:Boolean= item[prop] == this.val;
				if(bool){
					returnIndex = index;
				}
				return bool;
			}
			list.some(callback,{ val : val });
			return returnIndex;
		}
		
		//================================
		// 배열 및 오브젝트의 복사
		//사용법:var listsClone = copy(lists);
		//================================
		public static function copy(source:Object):*{
			var bytes:ByteArray = new ByteArray();
			bytes.writeObject(source);
			bytes.position = 0;
			return bytes.readObject();
		}

		//사각형의 중심을 되돌림
		public static function getRectCenterPoint(rect:Rectangle):Point{
			var X:Number = rect.x + rect.width / 2;
			var Y:Number = rect.y + rect.height / 2;
			return new Point(X,Y);
		}

		//================================
		//BitmapData조작
		//================================

		//BitmapData로 만들어서 되돌림
		public static function convertBitmapData(image:*):BitmapData{
			var bitmapData:BitmapData = new BitmapData(image.width,image.height,true,0x00000000);
			bitmapData.draw(image);
			return bitmapData;
		}
		
		
		/********************************************************************************
		* 
		* BitmapData 의 리사이즈
		* 
		* hRatio 수평방향의 비율
		* vRatio 수직방향의 비율
		********************************************************************************/
		public static function resizeBmd(src:BitmapData, hRatio:Number, vRatio:Number):BitmapData
		{
			var res:BitmapData = new BitmapData(
				Math.ceil(src.width * hRatio), Math.ceil(src.height * vRatio)
			  );//
			res.draw(src, new Matrix(hRatio, 0, 0, vRatio), null, null, null, true);
			return res;
		}
		

		//BitmapData을 리사이즈한 후 되돌림
		public static function resizeBitmapData(bitmapData:BitmapData,width:int,height:int):BitmapData{
			if(bitmapData.width == width && bitmapData.height == height){
				return bitmapData;
			}
			var newBitmapData:BitmapData	= new BitmapData(width,height,true,0);
			var bitmap:Bitmap				= new Bitmap(bitmapData,PixelSnapping.NEVER,true);
			var sprite:Sprite				= new Sprite();
			var quality:String				= StageReference.quality;
			bitmap.width = width;
			bitmap.height = height;
			sprite.addChild(bitmap);
			StageReference.quality 			= StageQuality.BEST;
			newBitmapData.draw(sprite);
			StageReference.quality 			= quality;
			return newBitmapData;
		}

		//BitmapData를 사각형의 중심으로 모음
		public static function centeringBitmapData(bitmapData:BitmapData,width:Number,height:Number,color:uint):BitmapData{
			var newBitmapData:BitmapData	= new BitmapData(width,height,true,0);
			var bitmap:Bitmap				= new Bitmap(bitmapData,PixelSnapping.NEVER,false);
			var sprite:Sprite				= new Sprite();
			var quality:String				= StageReference.quality;
			bitmap.x = (width - bitmap.width) / 2;
			bitmap.y = (height - bitmap.height) / 2;
			sprite.graphics.beginFill(color,1);
			sprite.graphics.drawRect(0,0,width,height);
			sprite.addChild(bitmap);
			StageReference.quality = StageQuality.BEST;
			newBitmapData.draw(sprite);
			StageReference.quality = quality;
			return newBitmapData;
		}

		//================================
		//날자관련
		//================================

		//날자의 문자열을 표시
		public static function getDateString(style:String = "",date:Date = null):String{
			if(date == null)date = new Date();
			var dateString:String = "";
			var YYYY:String	= String(date.getFullYear());
			var YY:String		= YYYY.substr(YYYY.length - 2,2);
			var MM:String		= mae0(date.getMonth() + 1,2);
			var DD:String		= mae0(date.getDate(),2);
			var M:String		= String(date.getMonth() + 1);
			var D:String		= String(date.getDate());
			switch(style.toUpperCase()){
				case "YYYY":		dateString = YYYY;									break;
				case "MM":			dateString = MM;									break;
				case "DD":			dateString = DD;									break;
				case "M":			dateString = M;										break;
				case "D":			dateString = D;										break;
				case "YYYYMMDD":	dateString = YYYY	+ MM + DD;						break;
				case "YYYYMM":		dateString = YYYY	+ MM;							break;
				case "YYMMDD":		dateString = YY		+ MM + DD;						break;
				case "YYMM":		dateString = YY		+ MM;							break;
				case "MMDD":		dateString = MM		+ DD;							break;
				case "YYYY/MM/DD":	dateString = YYYY	+ "/" + MM	+ "/" + DD;			break;
				case "YY/MM/DD":	dateString = YY		+ "/" + MM	+ "/" + DD;			break;
				case "YYYY/M/D":	dateString = YYYY	+ "/" + M		+ "/" + D;		break;
				case "YY/M/D":		dateString = YY		+ "/" + M		+ "/" + D;		break;
				case "MM/DD":		dateString = MM		+ "/" + DD;						break;
				case "M/D":			dateString = M		+ "/" + D;						break;
				case "YYYY-MM-DD":	dateString = YYYY	+ "-" + MM	+ "-" + DD;			break;
				case "YY-MM-DD":	dateString = YY		+ "-" + MM	+ "-" + DD;			break;
				case "YYYY-M-D":	dateString = YYYY	+ "-" + M		+ "-" + D;		break;
				case "YY-M-D":		dateString = YY		+ "-" + M		+ "-" + D;		break;
				case "MM-DD":		dateString = MM		+ "-" + DD;						break;
				case "M-D":			dateString = M		+ "-" + D;						break;
				default:			dateString = String(Number(date));					break;
			}
			return dateString;
		}

		//시간을 문자열로 되돌림
		public static function getTimeString(style:String = "",date:Date = null):String{
			if(date == null)date = new Date();
			var timeString:String = "";
			var hh:String	= mae0(date.getHours(),2);
			var mm:String	= mae0(date.getMinutes(),2);
			var ss:String	= mae0(date.getSeconds(),2);
			var h:String	= String(date.getHours());
			var m:String	= String(date.getMinutes());
			var s:String	= String(date.getSeconds());
			switch(style.toLowerCase()){
				case "hh":			timeString = hh;									break;
				case "mm":			timeString = mm;									break;
				case "ss":			timeString = ss;									break;
				case "h":			timeString = h;										break;
				case "m":			timeString = m;										break;
				case "s":			timeString = s;										break;
				case "hhmmss":		timeString = hh	+ mm		+ ss;					break;
				case "hhmm":		timeString = hh	+ mm;								break;
				case "hh:mm:ss":	timeString = hh	+ ":"		+ mm		+ ":" + ss;	break;
				case "hh:mm":		timeString = hh	+ ":"		+ mm;					break;
				case "h:m:s":		timeString = h	+ ":"		+ m		+ ":" + s;		break;
				case "h:m":			timeString = h	+ ":"		+ m;					break;
				default:			timeString = String(Number(date));					break;
			}
			return timeString;
		}

		//문자열이  YYYY-MM-DD hh:mm:ss 로 되어있는가?
		public static function checkDateString(dateString:String):Boolean{
			var flag:Boolean = true;
			if(dateString.length		!= 19
			|| dateString.charAt(4)		!= "-"
			|| dateString.charAt(7)		!= "-"
			|| dateString.charAt(10)	!= " "
			|| dateString.charAt(13)	!= ":"
			|| dateString.charAt(16)	!= ":"
			|| checkStringToUint(dateString.slice(0,4))		== false	//YYYY
			|| checkStringToUint(dateString.slice(5,7))		== false	//MM
			|| checkStringToUint(dateString.slice(8,10))	== false	//DD
			|| checkStringToUint(dateString.slice(11,13))	== false	//hh
			|| checkStringToUint(dateString.slice(14,16))	== false	//mm
			|| checkStringToUint(dateString.slice(17,19))	== false	//ss
			){
				flag = false;
			}
			return flag;
		}

		//YYYY-MM-DD hh:mm:ss를Date오브젝트로 만들어 되돌림
		public static function stringToDate(dateString:String):Date{
			if(checkDateString(dateString) == false)return null;
			var date:Array	= dateString.split(" ")[0].split("-");
			var time:Array	= dateString.split(" ")[1].split(":");
			var i:int;
			for(i = 0 ; i < 3 ; i++){
				date[i]	= int(date[i]);
				time[i]	= int(time[i]);
			}
			return new Date(date[0],date[1] - 1,date[2],time[0],time[1],time[2],0);
		}

		//Date오브젝트를 YYYY-MM-DD hh:mm:ssに로 만들어 되돌림
		public static function dateToString(date:Date = null):String{
			if(date == null)date = new Date();
			return getDateString("YYYY-MM-DD",date) + " " + getTimeString("hh:mm:ss",date);
		}

		
		/********************************************************************************
		* 
		* 년-월-일_시:분:초 의 형식으로 화일명 만들기
		* 
		* 
		********************************************************************************/
		public static function createDateToFileName():String {
			var d:Date = new Date();
			var fileName:String = 	getZeroKetaName(d.getFullYear()) 	+ '-' + 
									getZeroKetaName(d.getMonth()+1)		+ '-' + 
									getZeroKetaName(d.getDate()) 		+ '_' + 
									getZeroKetaName(d.getHours()) 		+ ':' + 
									getZeroKetaName(d.getMinutes()) 	+ ':' + 
									getZeroKetaName(d.getSeconds());
									
			return fileName;
		}
		
		public static function getZeroKetaName(count:int):String
		{
			var ret:String = count.toString();
			while (ret.length < 2)
			{
				ret = "0" + ret;
			}
			return ret;
		}
		
		
		
		//================================
		//문자열 조작
		//================================

		//문자열을 uint형으로 변환이 가능한가?
		public static function checkStringToUint(value:*):Boolean{
			var flag:Boolean = true;
			var numString:String = parseInt(value).toString();
			if(numString == "NaN"					//수치가 아니면 안됨
			|| numString.indexOf(".") != -1			//정수가 아니면 안됨
			|| numString.indexOf("-") != -1			//정의 수가 아니면 안됨
			){
				flag = false;
			}
			return flag;
		}

		//상태를 참조화
		public static function encodeEntityReference(Text:String):String{
			Text = Text.replace(/&/g,"&amp;");
			Text = Text.replace(/</g,"&lt;");
			Text = Text.replace(/>/g,"&gt;");
			Text = Text.replace(/"/g,"&quot;");
			//Text = Text.replace(/'/g,"&apos;");
			Text = Text.replace(/'/g,"&#039;");
			return Text;
		}

		//실체 참조를 문자열로.
		public static function decodeEntityReference(text:String):String{
			text = text.replace(/&amp;/g,"&");
			text = text.replace(/&lt;/g,"<");
			text = text.replace(/&gt;/g,">");
			text = text.replace(/&quot;/g,'"');
			text = text.replace(/&apos;/g,"'");
			text = text.replace(/&#039;/g,"'");
			return text;
		}

		//지정한 행수까지 앞에 0 을 채움
		public static function mae0(num:*,keta:int):String{
			var numString:String = String(num);
			while(numString.length < keta){
				numString = "0" + numString;
			}
			return numString;
		}
		
		//================================
		// sec 초 후 callBack 을 실행
		//================================

		public static function watedCall(sec:Number, callBack:Function, ...args):void
		{
			var timer:Timer = new Timer(1000 * sec,1);

			timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent):void
			{
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, arguments.callee);
				timer = null;
				
				try {
					trace('waitCall::함수 실행');
					if (args.length == 0) 
					{
						callBack();
					}
					else 
					{
						callBack(args);
					}
				}catch (e:Error) {
					trace('waitCall::함수 실행 실패');
				}
			});
			timer.start();
		}
		
		//================================
		// 범위 안에서 랜덤한 수 발생
		//================================
		public static function getRandom(min:int, max:int):Number
		{
			return Math.floor(Math.random() * (max - min + 1)) + min;
		}
		
		//================================
		// 랜덤 정렬
		//================================
		public static  function sortRandom(a, b):int
		{
			var rand = Math.random();
			if (rand > 0.5) {
				return 1;
			} else if (rand < 0.5) {
				return -1;
			} else {
				return 0;
			}
		}
		
		/********************************************************************************
		* 랜덤하게 섞기 (피셔 예이츠 셔플 알고리즘)    2015.05.25 추가 m.kimu  
		* 
		* _arr:[1,2,3,4,5]
		* rtn:[2,4,5,3,1] .... (랜덤하게 섞인 배열)
		********************************************************************************/
		public static function  shuffleArray(_arr: Array):Array {
			var arr:Array = copy(_arr);  //copy 메서드를 사용하고 있음!!
			var swap, tmp: uint;
			for (var i:int = arr.length - 1; i > 0; i--) {
				swap = Math.floor(Math.random() * i);
				tmp = arr[i];
				arr[i] = arr[swap];
				arr[swap] = tmp;
			}
			return (arr)
		}
		
		/********************************************************************************
		 * 모바일 OS 확인
		********************************************************************************/
		//https://github.com/zeh/as3/blob/master/com/zehfernando/utils/AppUtils.as
		
		public static function isAndroid():Boolean{
			//return Capabilities.manufacturer == "Android Linux";
			return (Capabilities.version.substr(0,3) == "AND");
		}
		
		public static function isIOS():Boolean{
			//return Capabilities.manufacturer == "Adobe iOS";  //원하는거 쓰셈
			return (Capabilities.version.substr(0,3) == "IOS");
		}
		
		public static function isMac():Boolean {
			return Capabilities.os == "MacOS" || Capabilities.os.substr(0, 6) == "Mac OS";
		}
		
		public static function isLinux():Boolean {
			// Android: "Linux 3.1.10-g52027f9"
			return Capabilities.os == "Linux";
		}
		
		public static function isWindows():Boolean {
			//return Capabilities.os == "Windows" || Capabilities.os == "Windows 7" || Capabilities.os == "Windows XP" || Capabilities.os == "Windows 2000" || Capabilities.os == "Windows 98/ME" || Capabilities.os == "Windows 95" || Capabilities.os == "Windows CE";
			return Capabilities.manufacturer == "Adobe Windows";
		}
		
		public static function isAirPlayer():Boolean {
			// This returns true even if it's on android!
			return Capabilities.playerType == "Desktop";
		}
		
		public static function isWebPlayer():Boolean {
			return Capabilities.playerType == "ActiveX" || Capabilities.playerType == "PlugIn";
		}

		public static function isStandalone():Boolean {
			// Desktop standalone
			return Capabilities.playerType == "StandAlone";
		}
		
		public static var layoutScale:Number  = 1;
		public static var bgScale:Number = 1;
		public static var bgSize:Object; //화면을 가득 체우는 배경 이미지등을 사용할때 이 값을 참조해서 크기를 정함.
		
		/********************************************************************************
		 * http://www.adobe.com/devnet/air/articles/multiple-screen-sizes.html
		********************************************************************************/
		public static function calcDeviceLayoutScale(w:int, h:int ,stage:Stage):void{
			var deviceSize:Rectangle;
			
			var appScale: Number = 1;
			bgSize = new Object();
			
			if (isAndroid()){
				deviceSize = new Rectangle(0, 0,Math.max(stage.fullScreenWidth, stage.fullScreenHeight),
												Math.min(stage.fullScreenWidth, stage.fullScreenHeight));
			}else{
				Debug.log(stage.stageWidth +' ,' +stage.stageHeight);
				deviceSize = new Rectangle(0, 0, 700, 600); //pc에서는 이 사이즈로 개발하는것으로 함. 
				deviceSize = new Rectangle(0, 0, stage.stageHeight, stage.stageWidth); //Android 플레이어에서는 stage.stageWidth,stage.stageHeight 가 반대로 들어오네.
				//deviceSize = new Rectangle(0, 0, 1024, 600); //pc에서는 이 사이즈로 개발하는것으로 함. 
			}
			 
			
			if ((deviceSize.width / deviceSize.height) > (w / h)) {
				//디바이스가 GUI의 종횡비보다 넓은 경우 높이가 축척을 결정합니다.
				//GUI의 가로보다 세로길이가 길경우, 세로 길이에 피트 
				layoutScale = deviceSize.height / h;
				bgScale = deviceSize.width / w;
				//appSize.width = deviceSize.width / appScale;
				Debug.log('가로 < 세로');
			}else {
				//디바이스가 GUI의 종횡비보다 넓은 경우 넓이가 축척을 결정합니다.
				//GUI의 가로가 세로길이 보다 길경우, 가로의 길이에 피트 
				layoutScale = deviceSize.width / w;
				bgScale =  deviceSize.height / h;
				//appSize.height = deviceSize.height / appScale;
				Debug.log('가로 > 세로');
			}
			
			bgSize.w =  deviceSize.width * bgScale;
			bgSize.h =  deviceSize.height* bgScale;
			
			Debug.log(stage.fullScreenWidth + 'x' + stage.fullScreenHeight + '\n appScale:' + layoutScale + ' bgScale:' + bgScale);
			Debug.log(deviceSize + 'device.width:' + deviceSize.width + ' device.height:' + deviceSize.height + 'bgSize.w:'+bgSize.w + ' ,bgSize.h:' + bgSize.h);
		}
		
		/********************************************************************************
		 * base무비클립 안에 들어 있는 무비클립의 위치를 확대 되고 난 후의 사이즈를 기준으로 원래 위치로 되돌려줌
		 *이렇게 하면 모바일 사이즈에 상관없이 UI의 위치를 통일 할 수 있음
		 *퍼센트로 위치 조정
		 * 
		 * tmpPoint = myLocalPoint(base.menus02,0.9,0.9);
		 * base.menus02.x = tmpPoint.x;
		 * base.menus02.y = tmpPoint.y;
		 * 
		 * 퍼센트 범위 : 0~1
		********************************************************************************/

		public static function myLocalPercentPosition(mc:MovieClip , stage:Stage, pcntX:Number, pcntY:Number):Point{
			var stagePoint: Point 
			if (Utils.isAndroid()){
				stagePoint = new Point(stage.fullScreenWidth * pcntX, stage.fullScreenHeight * pcntY);

			}else{
				stagePoint = new Point(stage.stageWidth * pcntX, stage.stageHeight * pcntY);
			}

			
			var targetPoint: Point = mc.globalToLocal(stagePoint);
			
			return targetPoint
		}
		
		/**********************************************************************************
		 * 
		 * 스테이지의 사이즈 취득
		 * 
		**********************************************************************************/ 
		public static function getStageSize():Point{
			var w:int;
			var h:int;
			if(Utils.isAndroid()){
				w = Math.ceil(StageReference.stage.fullScreenWidth);
				h = Math.ceil(StageReference.stage.fullScreenHeight);
			}else{
				w = Math.ceil(StageReference.stage.stageWidth);
			    h = Math.ceil(StageReference.stage.stageHeight);
			}

			return new Point(w,h);
		}
		/**********************************************************************************
		 *
		 * 부드럽게 움직이기
		 * 
		 * orig: 현재 위치
		 * dest : 이동하고 싶은 위치
		 * coeff:속도
		 *
		 * ex)
		 * this.x += velFriction(this.x , randX, 4);
			this.y += velFriction(this.y, randY, 4);
			
		 **********************************************************************************/
		public static function velFriction(orig:Number, dest:Number, coeff:Number):Number {
			return (dest-orig)/coeff;
		}
		
		
		/**********************************************************************************
		 *
		 * 현재 실행중인 swf 화일명을 취득 
		 * 
		 **********************************************************************************/
		public static function getMyFileName(mc:MovieClip):String{
			var url:String = mc.loaderInfo.url;
　　　　　　var token:Array = url.split("/");
　　　　　　var file:String = token[token.length - 1];
			var temp:String = file.split(".")[0];
			Debug.log( temp);
			
			return temp;
		}
						
		/**********************************************************************************
		 *
		 * 소수점 이하 지정 항수로 버림
		 * 
		 * 2019.11.22 추가
		 * trace(xRoundDown(12.3456, 2));   // 出力: 12.34
		 * 
		 **********************************************************************************/
		function xRoundDown(nValue:Number, nDigits:int):Number {
		  var nMultiplier:Number = Math.pow(10, nDigits);
		  var nResult:Number = Math.floor(nValue * nMultiplier) / nMultiplier;
		  return nResult;
		}
		
		/*while (numChildren > 1) // 자식들 올킬
			{
				removeChildAt(1);
			}*/
	}
}