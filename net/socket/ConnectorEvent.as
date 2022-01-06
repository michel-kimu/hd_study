package net.socket
{
	import flash.events.Event;
	
	public class ConnectorEvent extends Event
	{
		
		public static const RCV:String = "RECEIVE";
		public static const SND:String = "SEND";
		
		public var msg:KistMessage;
		
		public function ConnectorEvent(type:String, msg:KistMessage)
		{
			super(type);
			this.msg = msg;
		}
		
		public override function clone():Event
		{
			return new ConnectorEvent(this.type, msg);
		}
	}
}