package ui.language
{
	
	/**
	 * ...
	 * @author ...
	 */
	
	import flash.events.*;
	import utils.*;
	import globals.Global;
	import ui.dialog.*;
	
	public class SentenceManager 
	{
		private var iniFileName:String = './xml/Sentence.xml';
		
		private var xmlLoader:XmlLoader;
		private var xmlInfo:XML;
		
		private var funcProcFin:Function;
		
		public function SentenceManager(func:Function = null){
			funcProcFin = func;
			
			xmlLoader = new XmlLoader(iniFileName, "SENTENCE");
			setEventHandler(xmlLoader, true);
		}
		
		private function setEventHandler(target:*,option:Boolean = true):void{
			if(option){
				target.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
				target.addEventListener(ErrorEvent.ERROR,errorHandler);
				target.addEventListener(Event.COMPLETE,eventHandler);
			}else{
				target.removeEventListener(IOErrorEvent.IO_ERROR,errorHandler);
				target.removeEventListener(ErrorEvent.ERROR,errorHandler);
				target.removeEventListener(Event.COMPLETE,eventHandler);
			}
		}
		
		private function errorHandler(e:*, target:* = null):void { 
			if(e is ErrorEvent){
				target = e.target;
			}
			switch(target) {
				case xmlLoader:
					setEventHandler(xmlLoader, false) 	//이벤트 헨들러 취소
					
					var dialog:Dialog = new MessageDialog(iniFileName +' 화일 로딩 실패'); //Error #2010:Local-with-filesystem SWF 화일은 소켓을 사용할수 없습니다. (세큐리티 설정하세요)
					dialog.show();
		
				break;				 
			}
		}
		
		private function eventHandler(e:Event):void {
			setEventHandler(xmlLoader, false) 	//이벤트 헨들러 취소
			
			switch(e.target) {
				case xmlLoader: //초기화 화일(config.xml)
					var xmlGenre:String = e.target.data.type
					var xml:XML = new XML(e.target.data.xml);
					 
					//------------------------------------------------------------
					if (xmlGenre == "SENTENCE") {
						 xmlInfo = xml;
						//trace(xmlInfo);
						funcProcFin(); //로딩 완료
					}
					break;
			}
		}
		
		 /**********************************************************************************
		 * 
		 * 문구 취득
		 * 
		 * id :  문구를 표시할 id
		 **********************************************************************************/
		public function getSentenceFromID(_id:String):XMLList{
			return xmlInfo.txt.(@id == _id)
		}
		
		 /**********************************************************************************
		 * 
		 * 언어별 문구 취득
		 * 
		 * id :  문구를 표시할 영역의 id
		 **********************************************************************************/
		public function getSentence(id:String):Object{
			var tmp:XMLList = getSentenceFromID(id);
			var str:Object = {txt:'', fontSize:12, bold:false};
			
			switch(Global.language){
				case '0':
						str.txt = tmp.sentence_kr;
						str.fontSize = tmp.sentence_kr.@font_size
						str.bold = tmp.sentence_kr.@bold;
					break;
					
				case '1':
						str.txt = tmp.sentence_en;
						str.fontSize = tmp.sentence_en.@font_size
						str.bold = tmp.sentence_en.@bold;
					break;
					
				case '2':
						str.txt = tmp.sentence_dk;
						str.fontSize = tmp.sentence_dk.@font_size
						str.bold = tmp.sentence_dk.@bold;
					break;
			}  
			return str;
		}
	}
	
}