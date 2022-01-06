package utils{

import flash.errors.IOError;
import flash.events.StatusEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.LocalConnection;

import mx.core.mx_internal;
import mx.formatters.DateFormatter;
import mx.logging.ILogger;
import mx.logging.Log;
import mx.logging.LogEvent;
import mx.logging.targets.LineFormattedTarget;

	/**
	 * ...AIR로 퍼블리슈 했을때 로그 출력
	 * 
	 * C:\Users\<사용자명>\AppData\Roaming\main\Local Store\log\<년-월-일>.txt 로 저장됨
	 * 
	 * @author ...
	 */
use namespace mx_internal;

	public class Logger extends LineFormattedTarget {

	  /** DateFormatter */
	  private var formatter:DateFormatter;

	  /**
	   * コンストラクタ
	   */
	  public function Logger() {
		super();
		Log.addTarget(this);

		formatter = new DateFormatter();
		formatter.formatString = "YYYY-MM-DD";
	  }

	  /**
	   * ログ書き込み処理
	   */
	  override mx_internal function internalLog(message:String):void {

		try {
		  var fileName:String = formatter.format(new Date()) + ".txt";
		  var file:File = File.applicationStorageDirectory.resolvePath("app-storage:/log/" + fileName);
		  var stream:FileStream = new FileStream();
		  stream.open(file, FileMode.APPEND);
		  message += "\n";
		  message = message.replace(/\n/g, File.lineEnding);
		  stream.writeMultiByte(message, File.systemCharset);

		} catch(error:IOError) {
		} finally {
		  stream.close();
		}
	  }
	}
}
