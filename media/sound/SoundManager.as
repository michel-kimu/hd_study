package media.sound
{
	//음원을 내부 라이브러리에 가지고 있을때 사용
	import flash.display.MovieClip;
	import caurina.transitions.Tweener;
	
	import utils.*;
	import media.*;
	
	import flash.events.*;
	
	public class SoundManager extends MovieClip{
	//	private static var instance:SoundManager = new SoundManager();
		
		public var vol1:Number;
		public var vol2:Number;
		public var vol3:Number;
		public var vol4:Number;
		var snd:Object;
		
		public function SoundManager() {
			//if (instance) throw new Error("Snd::getInstance로 접근하시요");
			//instance = this;
			
		}
		//public static function getInstance():SoundManager {
		//	return instance;
		//	}
		
		public function init():void {
			trace('soundManager...... ok');
			snd = {ch1:new SoundObj(null, vol1),ch2:new SoundObj(null, vol2),ch3:new SoundObj(null, vol3),ch4:new SoundObj(null, vol4)};
		}
		
		//전체널 볼륨 설정 + 초기화
		public function setInit_AllChannelVolume(v1:Number, v2:Number, v3:Number, v4:Number):void {
			setAllChannelVolume(v1, v2, v3, v4);
			init();
		}	
		
		//전체널 볼륨 설정
		private function setAllChannelVolume(v1:Number, v2:Number, v3:Number, v4:Number):void {
			vol1 = v1;
			vol2 = v2;
			vol3 = v3;
			vol4 = v4;
		}
		public function stopAllSound():void {
			trace('Sound All Stop!');
			snd["ch1"].stopSound ();
			snd["ch2"].stopSound ();
			snd["ch3"].stopSound ();
			snd["ch4"].stopSound ();
		}

		public function stopChanelSound(ch:String):void {
			snd[ch].stopSound ();
		}
		/***********************************************************************************
		인수1:음원 이름
		인수2:true: 기좀 음원 정지
		인수3:음원 플래이 종료후 실행할 함수명
		인수4:반복 재생 횟수
		***********************************************************************************/
		//--------------------------------------------------------------------------------
		//BGM
		//ex) playBGM('bgmGame1');
		//--------------------------------------------------------------------------------
		public function playBGM(ve:String, volPerc:Number = 100.0):void {
			//BGM은 ch1 고정
			//라이브러리의 음원 볼륨이 서로 달라 외부 config에서 설정한 볼륨과 비례하게 조절되도록 함
			var nowVol:Number = vol1;
			var newVol:Number = nowVol * volPerc / 100;
			 
			 
			snd["ch1"].setVolume(newVol);
			snd["ch1"].playSound ( ve, true, null, 99999);
			 
		}
		
		//BGM 중지
		public function stopBGM(vol:Number = 1.0):void {
			stopChanelSound('ch1');
			setChannelVolume('ch1', vol);// 볼륨을 원상 복귀 시킴
			//trace('볼륨을 원상 복귀 시킴' + getChannelVolume('ch1'));
		}
		
		//해당 체널의 볼륨 취득
		public function getChannelVolume(chname:String):Number{
			return snd[chname].getVolume();
		}
		
		//해당 체널의 볼륨 설정
		public function setChannelVolume(chname:String, vol:Number):void{
			snd[chname].setVolume(vol);
		}
		
		//해당 체널의 볼륨 설정
		public function setChangeFadeVolume(chname:String, obj:Object):void{
			snd[chname].changeVolume(obj.vol);
		}
		
		public function setFadeOut(chname:String, delayTime:Number, limitVol:Number, func:Function):void{
			var tmpObj:Object = {vol:0.0 };
			tmpObj.vol = snd[chname].getVolume();

			Tweener.addTween(tmpObj, {vol:limitVol, time:delayTime, onUpdate:setChangeFadeVolume, onUpdateParams:[chname,tmpObj], onComplete:func});
		}
		//--------------------------------------------------------------------------------
		//SE
		//ex) playSE('ch1','bgmGame1',null,true,1,100);
		//또는 playSE('ch1','bgmGame2');
		// ch : 체널
		// ve : 이름
		// cbk: 소리 재생 후 실행할 함수명
		// flg: true: 앞서 나는 소리를 중지후 재생, false: 앞서 나는 소리와 함께 재생
		// repeat : 반복회수
		// volPerc: 볼륨 퍼센트
		//--------------------------------------------------------------------------------
		public function playSE(ch:String, ve:String, cbk:Function = null , flg:Boolean = true, repeat:int = 1 , volPerc:Number = 100.0):void {
			var nowVol:Number = 1.0;
			switch(ch) {
				case 'ch1':
					ch = 'ch2'; //실수로 BGM체널이 지정되었을 경우 ch2로 강제 전환
				case 'ch2':
					nowVol = vol2;
					break;
				case 'ch3':
					nowVol = vol3;
					break;	
				case 'ch4':
					nowVol = vol4;
					break;	
			}
			
			var newVol:Number = nowVol * volPerc / 100;
			snd[ch].setVolume(newVol);
			
			snd[ch].playSound ( ve, flg , cbk ,repeat );
		}
		

		// ch : 체널
		// fade : in, out
		// speed : 속도
		// fnc: 페이드 처리후 실행할 함수
		
		var amount:int;
		var fadeType:String
		var fadeAmount:Number;
		var fadeChannel:String;
		var fadeSpeed:Number;
		var fadeCount:Number = 0.0;
		var fadeFunc:Function ;
		
		public function sndFade(ch:String, fade:String, speed:Number = 0.025, fnc:Function = null) {
			var vol:Number = snd[ch].getVolume();
			fadeType = fade.toUpperCase();
			fadeChannel = ch;
			fadeSpeed = speed;
			fadeFunc = fnc;
			
			switch(fadeType) {
				case 'IN':
					amount  = vol;
					fadeCount = 0.0
					break;
				case 'OUT':
					amount = 0.0;
					fadeCount = vol;
					break;
			}
			
			addEventListener(Event.ENTER_FRAME, loop);
		}
		
		function loop(e:Event):void
		{
			switch(fadeType) {
				case 'IN':
					fadeCount += fadeSpeed;
					if(fadeCount >= amount){
						removeEventListener(Event.ENTER_FRAME, loop);
						if(fadeFunc != null)fadeFunc();
					} 
					break;
				case 'OUT':
					fadeCount -= fadeSpeed;
					if (fadeCount < 0.0) {
						removeEventListener(Event.ENTER_FRAME, loop);
						if(fadeFunc != null)fadeFunc();
					}
					break;
			}
			//trace('fadeCount:' + fadeCount);
			snd[fadeChannel].changeVolume(fadeCount);
		}
	}
}