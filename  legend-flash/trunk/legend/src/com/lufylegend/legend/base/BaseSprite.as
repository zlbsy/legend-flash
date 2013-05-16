package zhanglubin.legend.base
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import zhanglubin.legend.core.die.IDie;
	import zhanglubin.legend.core.display.ISprite;
	import zhanglubin.legend.core.events.IEventListener;
	import zhanglubin.legend.utils.math.LCoordinate;
	
	/**
	 * legend显示基类
	 * @author lufy(lufy.legend＠gmail.com)
	 */
	public class BaseSprite extends Sprite implements IDie,ISprite,IEventListener
	{
		 
		/**
		 * 事件储存器
		 */
		protected var _eventList:Array;
		/**
		 * legend显示基类
		 */
		public function BaseSprite() {
			this._eventList = new Array();
			super();
		}
		
		/**
		 * 事件储存器
		 */
		public function get eventList():Array
		{
			return _eventList;
		}
		
		/**
		 * 消亡函数
		 * 
		 * 移除所有子对象
		 * 移除所有事件
		 */
		public function die():void{
			this.graphics.clear();
			//移除所有子对象
			this.removeAllChild();
			//移除所有事件
			this.removeAllEventListener();
			this.graphics.clear();
		}
		/**
		 * 从父级将自己移除
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
		override public function removeChild(child:DisplayObject):DisplayObject{
			if(child is IDie){
				(child as IDie).die();
			}else if(child is MovieClip){
				removeMC(child as MovieClip);
			}else if(child is Sprite){
				removeSprite(child as Sprite);
			}
			
			return super.removeChild(child);
		}
		override public function removeChildAt(index:int):DisplayObject{
			var child:DisplayObject = super.removeChildAt(index);
			if(child is IDie){
				(child as IDie).die();
			}else if(child is MovieClip){
				removeMC(child as MovieClip);
			}else if(child is Sprite){
				removeSprite(child as Sprite);
			}
			return child;
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
		/**
		 * 移除所有子对象
		 */
		public function removeAllChild():void{
			var count:int = this.numChildren;
			
			for(var i:int = 0; i < count; i++){
				if(this.getChildAt(0) is IDie){
					(this.getChildAt(0) as IDie).die();
				}else if(this.getChildAt(0) is MovieClip){
					removeMC(this.getChildAt(0) as MovieClip);
				}else if(this.getChildAt(0) is Sprite){
					removeSprite(this.getChildAt(0) as Sprite);
				}
				this.removeChildAt(0);
			}
		}
		/**
		 * 移除子MovieClip上的所有子对象
		 * @param value 对象MC
		 */
		private function removeMC(value:MovieClip):void{
			value.stop();
			var count:int = value.numChildren;
			for(var i:int = 0; i < count; i++){
				if(value.getChildAt(0) is IDie){
					(value.getChildAt(0) as IDie).die();
				}else if(value.getChildAt(0) is MovieClip){
					removeMC(value.getChildAt(0) as MovieClip);
				}else if(value.getChildAt(0) is Sprite){
					removeSprite(value.getChildAt(0) as Sprite);
				}
				value.removeChildAt(0);
			}
		}
		/**
		 * 移除子Sprite上的所有子对象
		 * @param value 对象Sprite
		 */
		private function removeSprite(value:Sprite):void{
			var count:int = value.numChildren;
			for(var i:int = 0; i < count; i++){
				if(value.getChildAt(0) is IDie){
					(value.getChildAt(0) as IDie).die();
				}else if(value.getChildAt(0) is MovieClip){
					removeMC(value.getChildAt(0) as MovieClip);
				}else if(value.getChildAt(0) is Sprite){
					removeSprite(value.getChildAt(0) as Sprite);
				}
				value.removeChildAt(0);
			}
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

		public function set xy(coordinate:LCoordinate):void{
			this.x = coordinate.x;
			this.y = coordinate.y;
		}
		public function get xy():LCoordinate{
			return new LCoordinate(this.x,this.y);
		}
	}
}