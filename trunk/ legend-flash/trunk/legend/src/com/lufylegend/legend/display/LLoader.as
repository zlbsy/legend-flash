package zhanglubin.legend.display
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import zhanglubin.legend.base.LBaseLoader;
	import zhanglubin.legend.core.die.IDie;
	import zhanglubin.legend.core.events.IEventListener;
	
	/**
	 * legend的Loader类继承自flash.events.EventDispatcher;
	 * @author lufy(lufy.legend＠gmail.com)
	 */
	public class LLoader extends EventDispatcher implements IDie, IEventListener
	{
		/**
		 * 事件储存器
		 */
		private var _eventList:Array;
		protected var _url:String;
		protected var _loader:LBaseLoader;
		protected var _name:String;
		protected var _type:String;
		public function LLoader()
		{
			this._eventList = new Array();
			super();
		}
		/**
		 *载入文件 
		 */
		public function load(url:String,context:LoaderContext = null):void{
			this._url = url;
			this._loader = new LBaseLoader();
			this._loader.load(new URLRequest(url),context);
			this.addEvent();
		}
		/**
		 *载入ByteArray
		 */
		public function loadBytes(bytes:ByteArray,context:LoaderContext = null):void{
			this._loader = new LBaseLoader();
			this._loader.loadBytes(bytes,context);
			this.addEvent();
		}
		/**
		 *加载事件 
		 */
		protected function addEvent():void{
			this._loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,progress,false,0,true);
			this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,complete,false,0,true);
			this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioError,false,0,true);
		}
		/**
		 *删除事件  
		 */
		protected function reset():void{
			if(this._loader != null){
				this._loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,progress);
				this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,complete);
				this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
				this._loader.unload();
				this._loader.die();
				this._loader = null;
			}
		}
		
		/**
		 * 加载完成
		 */
		protected function complete(event:Event):void{
			this.dispatchEvent(event);
		}
		public function get content():DisplayObject{
			return this._loader.content;
		}
		/**
		 * 加载过程
		 */
		protected function progress(event:ProgressEvent):void{
			this.dispatchEvent(event);
		}
		/**
		 * 加载错误
		 */
		protected function ioError(event:IOErrorEvent):void{
			trace("读取文件出错：" + event.toString());
			this.dispatchEvent(event);
		}
		/**
		 * 清除加载
		 */
		public function die():void{
			if(this._loader != null){
				this._loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,progress);
				this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,complete);
				this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
				this._loader.unload();
				this._loader.die();
				this._loader = null;
			}
			this.removeAllEventListener();
		}
		/**
		 * 从父级移出函数
		 */
		public function removeFromParent():void{}
		/**
		 * 移除所有事件
		 */
		public function removeAllEventListener():void{
			var eventListLength:int = this._eventList.length;
			var eventList:Array;
			for(var i:int = 0;i<eventListLength;i++){
				eventList = this._eventList[0];
				super.removeEventListener(eventList[0],eventList[1],eventList[2]);
				this._eventList.splice(0,1);
			}
		}
		public function get url():String{
			return this._url;
		}
		public function get name():String{
			return this._name;
		}
		public function set name(value:String):void{
			this._name = value;
		}
		public function get loader():LBaseLoader{
			return this._loader;
		}
		public function get type():String{
			return this._type;
		}
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=true):void{
			var eventList:Array = [type,listener,useCapture,priority,useWeakReference];
			this._eventList.push(eventList);
			super.addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void{
			for(var i:int = 0;i<this._eventList.length;i++){
				if(this._eventList[i][0] == type){
					this._eventList.splice(i,1);
					break;
				}
			}
			super.removeEventListener(type,listener,useCapture);
		}
	}
}