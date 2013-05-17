package com.lufylegend.legend.net{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import com.lufylegend.legend.core.net.INet;
	import com.lufylegend.legend.display.LURLLoader;
	import com.lufylegend.legend.json.JSON;
	
	/**
	 * legendPHP连接类
	 * @author lufy(lufy.legend＠gmail.com)
	 */
	public class LNet implements INet
	{
		public static const TYPE_JSON:String = "json";
		public static const TYPE_XML:String = "xml";
		public static const TYPE_STRING:String = "string";
		private var _variables:URLVariables;
		private var _request:URLRequest;
		private var _loader:LURLLoader;
		private var _phpURL:String;
		private var _fun:Function;
		private var _errorShow:Function;
		private var _resultType:String;
		/**
		 * legendPHP连接类
		 */
		public function LNet(){}
		/**
		 * 传递参数
		 * 
		 * @param URL
		 * @param 参数
		 * @param error函数
		 * @param 目标函数　
		 */
		public function setVariables(phpURL:String,variables:URLVariables,errorFun:Function,completeFun:Function):void{
			this._phpURL = phpURL;
			this._variables = variables;
			this._errorShow = errorFun;
			this._fun = completeFun;
			
		}
		/**
		 * php运行
		 * 
		 * @param 参数传递方式(默认POST)　
		 */
		public function run(method:String = URLRequestMethod.POST,resultType:String = LNet.TYPE_XML):void{
			_resultType = resultType;
			// 送信先設定
			_request = new URLRequest();
			_request.url = _phpURL + "?legendrand=" + Math.random() + "&";
			_request.method = method;
			_request.data = _variables;

			//送信
			_loader = new LURLLoader();
			_loader.dataFormat = URLLoaderDataFormat.TEXT;
			configureListeners();
			try {
				_loader.load(_request);// 送信開始
			} catch (error:Error) {
				ioErrorHandler(null);
				return;
			}
			
		}
		/**
		 * 添加事件
		 * 
		 * @param URLLoader
		 */
		public function configureListeners():void {
			_loader.addEventListener(Event.COMPLETE, completeHandler);// 受信完了
			_loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);//error発生
			//_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler); 
		}
		/**
		 * 错误函数
		 * 
		 * @param securityErrorHandler
		 */
		public function securityErrorHandler(event:SecurityErrorEvent):void{
			this._errorShow();
		}
		/**
		 * 错误函数
		 * 
		 * @param IOErrorEvent
		 */
		public function ioErrorHandler(event:IOErrorEvent):void{
			this._errorShow();
		}
		/**
		 * php调用成功函数
		 * 
		 * @param Event
		 */
		protected function completeHandler(event:Event):void{
			event.target.die();
			if(_resultType == LNet.TYPE_JSON){
				this._fun(com.lufylegend.legend.json.JSON.decode(event.target.data.toString()));
			}else if(_resultType == LNet.TYPE_JSON){
				this._fun(new XML(event.target.data.toString()));
			}else{
				this._fun(event.target.data.toString());
			}
		}
	}
}