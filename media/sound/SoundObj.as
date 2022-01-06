package media.sound
{
	import flash.display.*;
	import flash.utils.*;
	import flash.events.*;
	import flash.media.*;

	public class SoundObj extends MovieClip {
		//-----------------------------------------
		var sChannel:SoundChannel;
		var mySound:Sound;
		var callBack:Function;//사운드 재생후 실행
		var currentVE:String;

		var libMc:MovieClip;
		var trans:SoundTransform = null;
		public var vol:Number = 0.0;
		
		//--------------------------------------------------------
		public function SoundObj (mc:MovieClip=null, volume:Number=1.0) {
			libMc = mc;
			vol = volume;
			//trace('libMc:' + libMc + " ,vol:" + vol);
		}
		
		public function setVolume(newVol:Number):void {
			vol = newVol;
		}
		public function getVolume():Number {
			return vol;
		}
		
		//LOAD SWF의cast_lib전용
		public function playSound (ve:String, flg:Boolean, func:Function=null,retry:int = 0):void {

			try {

				//trace("재생：");
				if (sChannel is Object && flg == true) {
					stopSound ();//ＶＥ 멈춤(복수의 소리는 재생하지 않음)
				}

				currentVE = ve;
				callBack = func;
				
				if (ve != "") {
					var ClassReference:Class;
					if (libMc) {
						ClassReference = libMc.get_Item_Class(ve);
					}else {
						ClassReference=getDefinitionByName(ve) as Class;
					}
					
					
					//var ClassReference:Class=getDefinitionByName(ve) as Class;
					//var ClassReference:Class = libMc.get_Item_Class(ve);
					
					mySound = new ClassReference() as Sound;

					sChannel = mySound.play(0, retry);
					sChannel.addEventListener (Event.SOUND_COMPLETE, sound_complete_event);
					
					trans = sChannel.soundTransform;
					trans.volume =  vol;
					sChannel.soundTransform = trans;
					//trace("vol:" + vol);
					
				}
			} catch (err:Error) {
				trace ("Play(" + ve + ") Error : " + err.message);
			}
		}
		
		public function changeVolume(vol:Number):void {
			if (sChannel) {
				trans = sChannel.soundTransform;
				trans.volume =  vol;
				sChannel.soundTransform = trans;	
			}
		}
		
		public function stopSound ():void {
			if (sChannel is Object) {
				//trace("--------------------------------------->stop");
				sChannel.stop ();
				Clear ();
			}
		}

		//사운드 재생후, 지정한 함수를 실행
		function sound_complete_event (e:Event):void {
			if (callBack != null) {
				callBack.call (null);
			}
			Clear ();
		}

		/* 사운드 크리어 */
		function Clear ():void {
			if (sChannel != null) {
				sChannel.removeEventListener (Event.SOUND_COMPLETE, sound_complete_event);
				sChannel = null;
			}
			mySound = null;
			callBack = null;
			currentVE = null;
		}
	}
}