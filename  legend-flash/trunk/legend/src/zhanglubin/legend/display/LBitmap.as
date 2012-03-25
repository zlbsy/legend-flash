package zhanglubin.legend.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import zhanglubin.legend.core.die.IDie;
	import zhanglubin.legend.core.events.IEventListener;
	import zhanglubin.legend.utils.LGlobal;
	import zhanglubin.legend.utils.math.LCoordinate;
	
	/**
	 * legend的Bitmap类继承自flash.display.Bitmap
	 * @author lufy(lufy.legend＠gmail.com)
	 */
	public class LBitmap extends Bitmap implements IDie,IEventListener
	{
		/**
		 * 事件储存器
		 */
		private var _eventList:Array;
		private var _save:Boolean = true;
		/**
		 * legend的Bitmap类继承自flash.display.Bitmap
		 * @author lufy(lufy.legend＠gmail.com)
		 */
		public function LBitmap(bitmapData:BitmapData = null,pixelSnapping:String = "auto",smoothing:Boolean = false)
		{
			this._eventList = new Array();
			super(bitmapData,pixelSnapping,smoothing);
		}
		
		public function get save():Boolean
		{
			return _save;
		}

		public function set save(value:Boolean):void
		{
			_save = value;
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
			if(!_save){
				this.bitmapData.dispose();
			}
		}
		/**
		 * 从父级移出函数
		 */
		public function removeFromParent():void{
			if(this.parent)	this.parent.removeChild(this);
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
		public function inHitPoint(mouseX:Number, mouseY:Number):Boolean
		{
			return this.bitmapData == null ? false : this.bitmapData.getPixel32(mouseX, mouseY) >>> 24 != 0x00;
		}
		public function set xy(coordinate:LCoordinate):void{
			this.x = coordinate.x;
			this.y = coordinate.y;
		}
		public function get xy():LCoordinate{
			return new LCoordinate(this.x,this.y);
		}
		public function get coordinate():Point
		{
			return new Point(this.x,this.y);
		}
		
		public function set coordinate(value:Point):void
		{
			this.x = value.x;
			this.y = value.y;
		}
	}
}