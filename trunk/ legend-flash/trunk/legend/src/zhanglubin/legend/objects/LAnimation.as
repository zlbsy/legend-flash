package zhanglubin.legend.objects
{
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	
	import zhanglubin.legend.events.LEvent;
	import zhanglubin.legend.core.die.IDie;
	import zhanglubin.legend.core.events.IEventListener;
	
	public class LAnimation extends EventDispatcher implements IDie,IEventListener
	{
		/**
		 *正序播放
		 */ 
		public static const POSITIVE:int = 1; 
		/**
		 *倒序播放
		 */ 
		public static const ANTITONE:int = 2;
		/**
		 *循环 
		 */ 
		public static const CIRCULATION:int = 3;
		protected var _dataArray:Array;
		protected var _dataBMP:BitmapData;
		protected var _rowIndex:int;
		protected var _rowCount:int;
		protected var _currentframe:int;
		protected var _currentframeCount:int;
		/**
		 * 事件储存器
		 */
		protected var _eventList:Array;
		/**
		 * legend的BitmapData播放类
		 * @author lufy(lufy.legend＠gmail.com)
		 */
		public function LAnimation(dataArray:Array)
		{
			this._eventList = new Array();
			this._dataArray = dataArray;
			this._rowCount = dataArray.length;
			this.rowIndex = 0;
		}
		/**
		 * 消亡函数
		 * 
		 * 移除所有子对象
		 * 移除所有事件
		 */
		public function die():void{
			//移除所有事件
			this.removeAllEventListener();
		}
		/**
		 * 从父级将自己移除
		 */
		public function removeFromParent():void{
			this.die();
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
		
		/**
		 * 当前图片的行号
		 */
		public function get rowIndex():uint
		{
			return _rowIndex;
		}
		/**
		 * 当前图片的行号
		 */
		public function set rowIndex(value:uint):void
		{
			var ischange:Boolean = false;
			if(_rowIndex != value)ischange = true;
			_rowIndex = value;
			if(_rowIndex >= this._rowCount){
				_rowIndex = 0;
				return;
			}
			_currentframeCount = this._dataArray[_rowIndex].length;
			if(ischange)_currentframe = - 1;
		}
		
		public function get currentframeCount():uint
		{
			return _currentframeCount;
		}
		
		public function set currentframeCount(value:uint):void
		{
			_currentframeCount = value;
		}
		
		/**
		 * 当前BitmapData
		 */
		public function get dataBMP():BitmapData
		{
			return _dataBMP;
		}
		
		/**
		 * 当前BitmapData
		 */
		public function set dataBMP(value:BitmapData):void
		{
			_dataBMP = value;
		}
		
		/**
		 * 当前图片的列号
		 */
		public function get currentframe():int
		{
			return _currentframe;
		}
		
		/**
		 * 当前图片的列号
		 */
		public function set currentframe(value:int):void
		{
			_currentframe = value;
		}
		
		public function get rowCount():uint
		{
			return _rowCount;
		}
		
		public function set rowCount(value:uint):void
		{
			_rowCount = value;
		}
		
		/**
		 * BitmapData播放
		 * 
		 * @param playMode 播放类型
		 */
		public function run(playMode:uint):void{
			if(playMode == LAnimation.CIRCULATION){
				return;
			}
			checkEvent(playMode);
			if(playMode == LAnimation.POSITIVE){
				_currentframe++;
				if(_currentframe == _currentframeCount){
					_currentframe = 0;
				}
			}else if(playMode == LAnimation.ANTITONE){
				if(_currentframe == 0){
					_currentframe = _currentframeCount - 1;
				}else{
					_currentframe--;
				}
			}
			trace(_currentframe);
			_dataBMP = _dataArray[_rowIndex][_currentframe];
		}
		private function checkEvent(playMode:uint):void{
			if(playMode == LAnimation.POSITIVE && _currentframe == _currentframeCount - 1){
				dispatchEvent(new LEvent(LEvent.ANIMATION_COMPLETE));
			}else if(playMode == LAnimation.ANTITONE && _currentframe == 0){
				dispatchEvent(new LEvent(LEvent.ANIMATION_COMPLETE));
			}
		}
	}
}