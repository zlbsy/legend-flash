package com.lufylegend.legend.display
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import com.lufylegend.legend.base.BaseSprite;
	import com.lufylegend.legend.core.die.IDie;
	import com.lufylegend.legend.core.display.ISprite;
	
	/**
	 * legend显示类
	 * 使用legend flash 所有显示对象必须继承此类或者其父类
	 * @author lufy(lufy.legend＠gmail.com)
	 */
	public class LSprite extends BaseSprite
	{
		private var _disposeList:Array = new Array();
		/**
		 * legend显示类
		 */
		public function LSprite() {
			super();
		}
		/**
		 * 待销毁bitmapdata储存器
		 */
		public function get disposeList():Array
		{
			return _disposeList;
		}
		
		/**
		 * @private
		 */
		public function set disposeList(value:Array):void
		{
			_disposeList = value;
		} 
		override public function die():void{
			super.die();
			while(this.disposeList != null && this._disposeList.length > 0){
				if(this._disposeList[0] is BitmapData)(this._disposeList[0] as BitmapData).dispose();
				this._disposeList.shift();
			}
		}
	}
}