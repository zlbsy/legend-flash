package zhanglubin.legend.display
{
	import flash.display.Shape;
	import zhanglubin.legend.core.die.IDie;
	import zhanglubin.legend.core.events.IEventListener;
	import zhanglubin.legend.utils.math.LCoordinate;

	public class LShape extends Shape implements IDie,IEventListener
	{
		/**
		 * 事件储存器
		 */
		private var _eventList:Array;
		/**
		 * legend Shape显示基类
		 */
		public function LShape()
		{
			this._eventList = new Array();
			super();
		}
		/**
		 * 消亡函数
		 * 
		 * 移除所有事件
		 */
		public function die():void{
			this.graphics.clear();
			//移除所有事件
			this.removeAllEventListener();
			this.graphics.clear();
		}
		/**
		 * 从父级移出函数
		 */
		public function removeFromParent():void{
			if(this.parent)	this.parent.removeChild(this);
		}
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void{
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
		public function set xy(coordinate:LCoordinate):void{
			this.x = coordinate.x;
			this.y = coordinate.y;
		}
		public function get xy():LCoordinate{
			return new LCoordinate(this.x,this.y);
		}
	}
}