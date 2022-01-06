package utils{
	import flash.utils.getTimer;
	public class ScoreCulc {
		private var _cTime:int;
		private var _score:int;
		private var _status:int;
		public function ScoreCulc(){
		}
		public function start():void {
			this._cTime = getTimer();
			trace('start!');
		}
		public function stop():void {
			var time:int = getTimer() - this._cTime;
			if (time < 2000) {
				//this._status = CheckLabelMC.EXCELLENT;
				this._score = 500;
			}else if (time < 3000) {
				//this._status = CheckLabelMC.GREAT;
				this._score = 200;
			}else if (time < 4000) {
				//this._status = CheckLabelMC.GOOD;
				this._score = 50;
			}else {
				//this._status = CheckLabelMC.HIT;
				this._score = 10;
			}
			trace(time+'stop:' + _score);
		}
		public function get score():int { 
			trace('_score:'+_score);
			return _score;
		}
		public function get status():int { 
			return _status;
		}
	}
}