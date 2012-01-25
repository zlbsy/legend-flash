package zhanglubin.legend.net
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	/**
	 * legendPHP连接类
	 * @author lufy(lufy.legend＠gmail.com)
	 */
	public class PHP
	{
		private var _variables:URLVariables;
		private var _request:URLRequest;
		private var _loader:URLLoader;
		private var _phpURL:String;
		private var _fun:Function;
		private var _errorShow:Function;
		/**
		 * legendPHP连接类
		 */
		public function PHP(){
		}
		/**
		 * 传递参数
		 * 
		 * @param URL
		 * @param 参数
		 * @param error函数
		 * @param 目标函数　
		 */
		public function setVariables(phpURL:String,variables:URLVariables,errorShow:Function,fun:Function):void{
			this._phpURL = phpURL;
			this._variables = variables;
			this._errorShow = errorShow;
			this._fun = fun;
		}
		/**
		 * php运行
		 * 
		 * @param 参数传递方式(默认POST)　
		 */
		public function run(method:String = URLRequestMethod.POST):void{
			// 送信先設定
			_request = new URLRequest();
			_request.url = _phpURL + "?ran=" + Math.random();
			_request.method = method;
			_request.data = _variables;

			//送信
			_loader = new URLLoader();
			_loader.dataFormat = URLLoaderDataFormat.TEXT;
			configureListeners(_loader);
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
		private function configureListeners(dispatcher:URLLoader):void {
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);// 受信完了
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);//error発生
		}
		/**
		 * 错误函数
		 * 
		 * @param IOErrorEvent
		 */
		protected function ioErrorHandler(event:IOErrorEvent):void{
		}
		/**
		 * php调用成功函数
		 * 
		 * @param Event
		 */
		protected function completeHandler(event:Event):void{
			var xml:XML;
			xml = new XML(event.target.data);
			this._fun(xml);
		}
	}
}