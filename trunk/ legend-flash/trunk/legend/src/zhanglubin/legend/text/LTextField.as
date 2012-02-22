package zhanglubin.legend.text
{
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	
	import zhanglubin.legend.core.die.IDie;
	import zhanglubin.legend.core.events.IEventListener;
	import zhanglubin.legend.events.LEvent;
	import zhanglubin.legend.utils.math.LCoordinate;

	public class LTextField extends TextField implements IEventListener,IDie
	{
		public static const CENTER:String = TextFieldAutoSize.CENTER;
		public static const LEFT:String = TextFieldAutoSize.LEFT;
		public static const RIGHT:String = TextFieldAutoSize.RIGHT;
		public static const NONE:String = TextFieldAutoSize.NONE;
		/**
		 * 事件储存器
		 */
		private var _eventList:Array;
		private var _textWind:Array;
		private var _ltext:String;
		private var _windIndex:int;
		private var _timer:Timer;
		private var _tEvent:Boolean = false;
		private var _css:StyleSheet;
		/**
		 * legend的TextField类
		 */
		public function LTextField()
		{
			this._eventList = new Array();
			super();
		}

		public function get css():StyleSheet
		{
			return _css;
		}

		public function set css(value:StyleSheet):void
		{
			_css = value;
		}

		/**
		 * 添加逐字显示文本
		 * 
		 * @param value 文本
		 * @param css css
		 * @param delay 计时器事件间的延迟
		 * @param repeatCount 设置的计时器运行总次数
		 */
		public function setWindText(value:String,__css:StyleSheet = null,delay:Number = 50.0, repeatCount:int = 0):void{
			if(this._textWind == null){
				this._textWind = new Array();
			}else{
				this._textWind.splice(0,this._textWind.length);
			}
			_windIndex = 0;
			_ltext = "";
			var i:int = 0;
			this.text = "";
			while(i<value.length){
				if(value.charAt(i) == "<"){
					var e1:int = value.indexOf(">",i);
					var e2:int = value.indexOf("</span>",e1);
					var cls:String = value.substring(i,e1 + 1);
					for(var j:int = e1 + 1;j<e2;j++){
						this._textWind.push(cls + value.charAt(j) + "</span>");
					}
					i = e2 + 6;
				}else{
					this._textWind.push(value.charAt(i));
				}
				i++;
			}
			if(__css == null){
				__css = this.getCss();
			}
			this._css = __css;
			if(this._timer == null){
				this._timer = new Timer(delay,repeatCount);
				this._timer.addEventListener(TimerEvent.TIMER,windText,false,0,true);
				this._tEvent = true;
			}
			if(this._timer.running){
				this._timer.reset();
				this._timer.start();
			}else{
				this._timer.start();
			}
			this.styleSheet = this._css;
		}
		/**
		 * 从父级移出函数
		 */
		public function removeFromParent():void{
			this.parent.removeChild(this);
		}
		/**
		 * 逐字显示
		 * 
		 * @param 事件
		 */
		private function windText(event:TimerEvent):void{
			if(_windIndex < this._textWind.length){
				_ltext += this._textWind[_windIndex++];
				this.htmlText = "<p>" + _ltext + "</p>";
				this.scrollV = this.maxScrollV;
			}else{
				this._timer.stop();
				dispatchEvent(new LEvent(LEvent.LTEXT_MAX));
			}
		}
		public function windOver():void{
			if(this._textWind != null){
				this.htmlText = "<p>" + this._textWind.join("") + "</p>";
				this.scrollV = this.maxScrollV;
			}
			this.removeAllEventListener();
		}
		/**
		 * 返回一个StyleSheet的Css
		 * 
		 */
		private function getCss():StyleSheet{
			var css:StyleSheet = new StyleSheet( );
			css.setStyle("p", {fontFamily: "_sans",fontSize:"18",color:"#FFFFFF",fontWeight:"bold"});
			css.setStyle(".red", {color:"#FF0000"});
			css.setStyle(".yellow", {color:"#FFFF00"});
			css.setStyle(".green", {color:"#00FF00"});
			css.setStyle(".blue", {color:"#0000FF"});
			css.setStyle(".pink", {color:"#FF00FF"});
			css.setStyle(".black", {color:"#000000"});
			return css;
		}
		/**
		 * 清除Timer
		 * 
		 */
		private function deleteTimer():void{
			if(this._timer != null){
				if(this._timer.running){
					this._timer.stop();
				}
				if(this._tEvent){
					this._timer.removeEventListener(TimerEvent.TIMER,windText);
				}
				this._timer = null;
			}
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
		 * 移除所有事件
		 */
		public function removeAllEventListener():void{
			this.deleteTimer();
			if(this._textWind != null)this._textWind = null;
			
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