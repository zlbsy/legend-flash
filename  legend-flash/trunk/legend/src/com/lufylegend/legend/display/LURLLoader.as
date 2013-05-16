package zhanglubin.legend.display
{
	import flash.net.URLLoader;
	
	import zhanglubin.legend.core.die.IDie;
	import zhanglubin.legend.core.events.IEventListener;

	public class LURLLoader extends URLLoader implements IDie,IEventListener
	{
		/**
		 * 事件储存器
		 */
		private var _eventList:Array;
		/**
		 * legend的URLLoader类继承自flash.net.URLLoader
		 * @author lufy(lufy.legend＠gmail.com)
		 */
		public function LURLLoader() 
		{
			this._eventList = new Array();
			super();
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
		/**
		 * 消亡函数
		 * 
		 * 移除所有事件
		 */
		public function die():void{
			//移除所有事件
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
	}
}