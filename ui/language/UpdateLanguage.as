package ui.language
{
	import flash.events.Event;
	import flash.text.*;
	import flash.display.MovieClip;
	import globals.*;
	import event.*;
	/**
	 * ...
	 * @author ...
	 * ID:  무비클립의 이름
	 */
	public class UpdateLanguage extends MovieClip 
	{
		
		var em:CustomEventManager;
		
		public function UpdateLanguage(){
			addEventListener(Event.REMOVED_FROM_STAGE,removeStage);	
			em = Global.eventManager;
			em.addEventListener(CustomEventManager.LANGUAGE_CHANGED, update);
			update();
		}
		
		private function update(e:Event = null):void{
			if(Global.sentenceManager == null) return;

			var obj:Object = Global.sentenceManager.getSentence(this.name); //무비클립의 이름이 ID 임.
			var tf:TextFormat = new TextFormat();
			tf.size = obj.fontSize;  //폰트 사이즈 재정의
			if (obj.bold == '1'){			
				tf.bold = true;
			}
			this.txt.defaultTextFormat = tf;
			this.txt.text = obj.txt; //문구 표시
			
		}
		
		/********************************************************************************
		 * 
		 * Destructor
		 * 
		 ********************************************************************************/
		public function removeStage(e:Event = null):void {
			removeEventListener(Event.REMOVED_FROM_STAGE,removeStage);
			em.removeEventListener(CustomEventManager.LANGUAGE_CHANGED, update);
		}
	}
	
}