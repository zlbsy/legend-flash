package com.lufylegend.legend.utils.transitions
{
	import flash.display.DisplayObject;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class LManager
	{
		private static var _timer:Timer;
		private static var _transitionList:Array;
		public function LManager()
		{
		}

		public static function get transitionList():Array
		{
			return _transitionList;
		}

		public static function set transitionList(value:Array):void
		{
			_transitionList = value;
		}

		public static function clear():void{
			var i:uint,j:uint;
			for(i=0;i<_transitionList.length;i++){
				var tran:Array = _transitionList[i];
				for(j=0;j<tran.length;j++){
					tran[j] = null;
				}
			}
			_transitionList.splice(0,_transitionList.length);
		}
		public static function wait(time:int,fun:Function):void{
			tranInit();
			var tran:Array = ["wait",0,time,fun];
			_transitionList.push(tran);
			timerInit();
		}
		public static function fadeIn(container:DisplayObject,speed:Number,fun:Function):void{
			container.alpha = 0;
			fadeTo(container,1,speed,fun);
		}
		public static function fadeOut(container:DisplayObject,speed:Number,fun:Function):void{
			container.alpha = 1;
			fadeTo(container,0,speed,fun);
		}
		public static function fadeTo(container:DisplayObject,alphaTo:Number,speed:Number,fun:Function):void{
			fadeFromTo(container,container.alpha,alphaTo,speed,fun);
		}
		public static function fadeFromTo(container:DisplayObject,alphaFrom:Number,alphaTo:Number,speed:Number,fun:Function):void{
			tranInit();
			container.alpha = alphaFrom;
			var tran:Array = ["fadeTo",container,alphaTo,speed,fun];
			_transitionList.push(tran);
			timerInit();
		}
		public static function moveTo(container:DisplayObject,toX:int,toY:int,speed:Number,fun:Function):void{
			tranInit();
			var a:Number = Math.atan(Math.abs(container.y - toY)/Math.abs(container.x - toX));
			var speedX:Number;
			var speedY:Number;
			speedX = speed*Math.cos(a);
			speedY = speed*Math.sin(a);
			var tran:Array = ["moveTo",container,toX,toY,speedX,speedY,fun];
			_transitionList.push(tran);
			timerInit();
		}
		private static function tranInit():void{
			if(_transitionList == null){
				_transitionList = new Array();
			}
		}
		private static function timerInit():void{
			if(_timer == null){
				_timer = new Timer(10);
				_timer.addEventListener(TimerEvent.TIMER,onTimer,false,0,true);
				_timer.start();
			}
		}
		private static function onTimer(event:TimerEvent):void{
			if(_transitionList.length == 0){
				_transitionList = null;
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER,onTimer);
				_timer = null;
				return;
			}
			var i:uint;
			for(i=0;i<_transitionList.length;i++){
				var tran:Array = _transitionList[i];
				var tranOver:Boolean = false;
				switch(tran[0]){
					case "fadeTo":
						tranOver = runFadeTo(tran);
						break;
					case "moveTo":
						tranOver = runMoveTo(tran);
						break;
					case "wait":
						tranOver = runWait(tran);
						break;
				}
				if(tranOver){
					_transitionList.splice(i,1);
					i--;
				}
			}
		}
		private static function runWait(tran:Array):Boolean{
			if(tran[1] >= tran[2]){
				var fun:Function = tran[3];
				tran[3] = null;
				if(fun != null)fun();
				return true;
			}
			tran[1] += 1;
			return false;
		}
		private static function runFadeTo(tran:Array):Boolean{
			if(Math.abs((tran[1] as DisplayObject).alpha-tran[2]) < tran[3]){
				(tran[1] as DisplayObject).alpha = tran[2];
				var fun:Function = tran[4];
				tran[1] = null;
				tran[4] = null;
				if(fun != null)fun();
				return true;
			}
			if((tran[1] as DisplayObject).alpha > tran[2]){
				(tran[1] as DisplayObject).alpha -= tran[3];
			}else{
				(tran[1] as DisplayObject).alpha += tran[3];
			}
			return false;
		}
		private static function runMoveTo(tran:Array):Boolean{
			if((tran[4] == 0 || (tran[1] as DisplayObject).x-tran[2]) == 0 && 
				(tran[5] == 0 || (tran[1] as DisplayObject).y-tran[3] == 0)){
				var fun:Function = tran[6];
				tran[1] = null;
				tran[6] = null;
				if(fun != null)fun();
				return true;
			}
			if((tran[1] as DisplayObject).x > tran[2]){
				(tran[1] as DisplayObject).x -= tran[4];
				if((tran[1] as DisplayObject).x < tran[2])(tran[1] as DisplayObject).x = tran[2];
			}else if((tran[1] as DisplayObject).x < tran[2]){
				(tran[1] as DisplayObject).x += tran[4];
				if((tran[1] as DisplayObject).x > tran[2])(tran[1] as DisplayObject).x = tran[2];
			}
			if((tran[1] as DisplayObject).y > tran[3]){
				(tran[1] as DisplayObject).y -= tran[5];
				if((tran[1] as DisplayObject).y < tran[3])(tran[1] as DisplayObject).y = tran[3];
			}else if((tran[1] as DisplayObject).y < tran[3]){
				(tran[1] as DisplayObject).y += tran[5];
				if((tran[1] as DisplayObject).y > tran[3])(tran[1] as DisplayObject).y = tran[3];
			}
			return false;
		}
	}
}