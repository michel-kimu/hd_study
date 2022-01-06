package utils{

	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.events.*;
	
	import utils.*;
	
	/**
	 * ...
	 * @author m.kim
	 */
	public class XmlLoader  extends EventDispatcher{

		private var xmlLoader:URLLoader;
		private var xml:XML;
		private var type:String;
		
		public function XmlLoader(url:String, type:String) {
			this.type = type;
			trace(url);
			xmlLoader = new URLLoader()
			xmlLoader.dataFormat = URLLoaderDataFormat.TEXT
			xmlLoader.addEventListener(Event.COMPLETE, load_comp_func)
			
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
			xmlLoader.addEventListener(ErrorEvent.ERROR,errorHandler);

			xmlLoader.load(new URLRequest(url));
		}
		private function errorHandler(e:*):void {
			Debug.log("ERR: ",type + " 로딩 실패")
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR)); 
		}
		
		private function load_comp_func(e:Event):void {
			try {
				xml = new XML(xmlLoader.data)
				dispatchEvent(new Event(Event.COMPLETE))
			}catch (err:TypeError) {
				Debug.log("ERR:",err.message)
			}
		}
		
		public function get data():Object {
			return {xml:this.xml, type:this.type}			
		}
	}
}