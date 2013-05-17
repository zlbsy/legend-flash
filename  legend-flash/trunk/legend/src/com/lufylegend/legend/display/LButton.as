package com.lufylegend.legend.display
{
	import flash.display.BitmapData;
	import flash.display.SimpleButton;
	import flash.geom.Point;
	
	import mx.controls.Label;
	
	import com.lufylegend.legend.components.LLabel;
	import com.lufylegend.legend.core.die.IDie;
	import com.lufylegend.legend.core.display.ISprite;
	import com.lufylegend.legend.core.events.IEventListener;
	import com.lufylegend.legend.text.LTextField;
	import com.lufylegend.legend.utils.LFilter;
	import com.lufylegend.legend.utils.math.LCoordinate;
	
	/**
	 * legend按钮类
	 * @author lufy(lufy.legend＠gmail.com)
	 */
	public class LButton extends SimpleButton implements IDie,ISprite,IEventListener
	{
		/**
		 * 事件储存器
		 */
		private var _eventList:Array;
		private var _upState:LSprite;
		private var _overState:LSprite;
		private var _downState:LSprite;
		private var _upLabel:LLabel;
		private var _overLabel:LLabel;
		private var _downLabel:LLabel;
		
		private var _bitmap:LBitmap
		private var _labelOver:LLabel
		private var _labelDown:LLabel
		private var _labelUp:LLabel
		private var _value:Object;
		private var _labelColor:String = "#000000";
		private var _labelSize:int = 15;
		private var _disposeList:Array;
		/**
		 * legend按钮类
		 * 
		 * @param 按钮up bitmapdata
		 * @param 按钮over bitmapdata
		 * @param 按钮down bitmapdata
		 */
		public function LButton(up:BitmapData,over:BitmapData=null,down:BitmapData=null)
		{
			super();
			_eventList = new Array();
			this._disposeList = new Array();
			this.createUpState(up);
			this.createOverState(over,up);
			this.createDownState(down,up);
			
			this.hitTestState = this._upState;
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

		public function get value():Object
		{
			return _value;
		}

		public function set value(value:Object):void
		{
			_value = value;
		}

		public function createUpState(value:BitmapData):void{
			this._upState = new LSprite();
			this._bitmap = new LBitmap(value);
			this._upState.addChild(this._bitmap);
			this.upState = this._upState;
		}
		public function createOverState(value:BitmapData,up:BitmapData):void{
			this._overState = new LSprite();
			if(value != null){
				this._bitmap = new LBitmap(value);
			}else{
				this._bitmap = new LBitmap(up);
				this._bitmap.x = 1;
				this._bitmap.y = 1;
				LFilter.setBrightness(this._bitmap,1.5);
			}
			this._overState.addChild(this._bitmap);
			this.overState = this._overState;
		}
		public function createDownState(value:BitmapData,up:BitmapData):void{
			this._downState = new LSprite();
			if(value != null){
				this._bitmap = new LBitmap(value);
			}else{
				this._bitmap = new LBitmap(up);
				this._bitmap.x = 1;
				this._bitmap.y = 1;
				LFilter.setBrightness(this._bitmap,0.5);
			}
			this._downState.addChild(this._bitmap);
			this.downState = this._downState;
		}
		public function set labelColor(value:String):void{
			_labelColor = value;
		}
		public function set labelSize(value:int):void{
			_labelSize = value;
		}
		public function set label(value:String):void{
			if(this._labelUp == null){
				this._labelUp = this.creatLabel(value);
				this._labelOver = this.creatLabel(value);
				this._labelDown = this.creatLabel(value);
				this._upState.addChild(this._labelUp);
				this._overState.addChild(this._labelOver);
				this._downState.addChild(this._labelDown);
				this._labelUp.x = (this._upState.width - this._labelUp.width)/2;
				this._labelUp.y = (this._upState.height - this._labelUp.height)/2;
				this._labelOver.x = (this._overState.width - this._labelOver.width)/2;
				this._labelOver.y = (this._overState.height - this._labelOver.height)/2;
				this._labelDown.x = (this._downState.width - this._labelDown.width)/2;
				this._labelDown.y = (this._downState.height - this._labelDown.height)/2;
			}else{
				this._labelUp.htmlText = "<font color='" + this._labelColor + "'><b>" + value + "</b></font>";
				this._labelOver.htmlText = "<font color='" + this._labelColor + "'><b>" + value + "</b></font>";
				this._labelDown.htmlText = "<font color='" + this._labelColor + "'><b>" + value + "</b></font>";
			}
		}
		private function creatLabel(value:String):LLabel{
			var label:LLabel = new LLabel();
			label.htmlText = "<font color='" + this._labelColor + "' size = '" + _labelSize + "'><b>" + value + "</b></font>";
			return label;
		}
		private function addLabel():void{
		}
		public function setLabel(valueUp:LLabel,valueOver:LLabel,valueDown:LLabel):void{
			this._labelUp = valueUp;
			this._labelOver = valueOver;
			this._labelDown = valueDown;
			this._upState.addChild(this._labelUp);
			this._overState.addChild(this._labelOver);
			this._downState.addChild(this._labelDown);
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
		/**
		 * 从父级移出函数
		 */
		public function removeFromParent():void{
			if(this.parent)	this.parent.removeChild(this);
		}
		/**
		 * 移除所有子类
		 */
		public function removeAllChild():void{
			if(this._upState != null)this._upState.die();
			if(this._overState != null)this._overState.die();
			if(this._downState != null)this._downState.die();
			this._upState = null;
			this._overState = null;
			this._downState = null;
			this.upState = null;
			this.overState = null;
			this.downState = null;
			this._bitmap = null;
		}
		/**
		 * 消亡函数
		 * 
		 * 移除所有事件
		 */
		public function die():void{
			//移除所有子类
			this.removeAllChild();
			//移除所有事件
			this.removeAllEventListener();
			while(this._disposeList.length > 0){
				(this._disposeList[0] as BitmapData).dispose();
				this._disposeList.shift();
			}
		}
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void{
			if(this._eventList == null)return;
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
		
	}
}