package com.lufylegend.legend.scripts.analysis
{
	
	import flash.events.Event;
	
	import com.lufylegend.legend.components.LRadio;
	import com.lufylegend.legend.display.LBitmap;
	import com.lufylegend.legend.display.LButton;
	import com.lufylegend.legend.display.LSprite;
	import com.lufylegend.legend.scripts.LScript;
	import com.lufylegend.legend.text.LTextField;
	import com.lufylegend.legend.utils.LDisplay;
	import com.lufylegend.legend.utils.LFilter;
	import com.lufylegend.legend.utils.LGlobal;
	import com.lufylegend.legend.utils.LString;
	import com.lufylegend.legend.utils.transitions.LManager;

	public class ScriptLayer
	{
		
		public function ScriptLayer()
		{
		}
		/**
		 * 脚本解析
		 * 添加层
		 * 
		 * @param 脚本信息
		 */
		public static function analysis(value:String):void{
			var start:int = value.indexOf("(");
			var end:int = value.indexOf(")");
			switch(value.substr(0,start)){
				case "Layer.add":
					setLayer(value,start,end);
					break;
				case "Layer.remove":
					removeLayer(value,start,end);
					break;
				case "Layer.transition":
					transition(value,start,end);
					break;
				case "Layer.setFilter":
					setFilter(value,start,end);
					break;
				case "Layer.clear":
					clearLayer(value,start,end);
					break;
				case "Layer.drawRect":
					drawRect(value,start,end);
					break;
				case "Layer.drawRoundRect":
					drawRoundRect(value,start,end);
					break;
				case "Layer.drawRectLine":
					drawRectLine(value,start,end);
					break;
				case "Layer.drawRoundRectLine":
					drawRoundRectLine(value,start,end);
					break;
				case "Layer.drawRectGradient":
					drawRectGradient(value,start,end);
					break;
				case "Layer.drawTriangle":
					drawTriangle(value,start,end);
					break;
				case "Layer.drawTriangleLine":
					drawTriangle(value,start,end);
					break;
				default:
					
			}
			
		}
		/**
		 * 脚本解析
		 * 添加层
		 * Layer.setFilter(name,filter);
		 * @param 脚本信息
		 */
		private static function setFilter(value:String,start:int,end:int):void{
			var params:Array = value.substring(start+1,end).split(",");
			var nameStr:String = params[0];
			var filter:String = params[1];
			var script:LScript = LGlobal.script;
			var layer:LSprite;
			layer = script.scriptArray.layerList[nameStr];
			switch(filter){
				case "INIT":
					LFilter.setFilter(layer,LFilter.INIT);
					break;
				case "GRAY":
					LFilter.setFilter(layer,LFilter.GRAY);
					break;
				case "SHADOW":
					LFilter.setFilter(layer,LFilter.SHADOW);
					break;
				case "SUN":
					LFilter.setFilter(layer,LFilter.SUN);
					break;
				case "RELIEF":
					LFilter.setFilter(layer,LFilter.RELIEF);
					break;
			}
			script.analysis();
		}
		/**
		 * 脚本解析
		 * 添加层
		 * Layer.drawRect(name,x,y,width,height,color,color2);
		 * @param 脚本信息
		 */
		private static function drawRectGradient(value:String,start:int,end:int):void{
			var params:Array = value.substring(start+1,end).split(",");
			var nameStr:String = params[0];
			var color:int = int(params[5]);
			var color2:Number = int(params[6]);
			var script:LScript = LGlobal.script;
			var layer:LSprite;
			layer = script.scriptArray.layerList[nameStr];
			LDisplay.drawRectGradient(layer.graphics,[int(params[1]),int(params[2]),int(params[3]),int(params[4])],[color,color2]);
			script.analysis();
		}
		/**
		 * 脚本解析
		 * 添加层
		 * Layer.drawRoundRect(name,x,y,width,height,jw,jh,color,size);
		 * @param 脚本信息
		 */
		private static function drawRoundRect(value:String,start:int,end:int):void{
			var params:Array = value.substring(start+1,end).split(",");
			var nameStr:String = params[0];
			var color:int = int(params[7]);
			var size:int = int(params[8]);
			var script:LScript = LGlobal.script;
			var layer:LSprite;
			layer = script.scriptArray.layerList[nameStr];
			layer.graphics.lineStyle(size,color);
			LDisplay.drawRoundRect(layer.graphics,[int(params[1]),int(params[2]),int(params[3]),int(params[4]),int(params[5]),int(params[6])],true,color,1,size);
			script.analysis();
		}
		/**
		 * 脚本解析
		 * 添加层
		 * Layer.drawTriangle(name,x1,y1,x2,y2,x3,y3,color,alpha);
		 * @param 脚本信息
		 */
		private static function drawTriangle(value:String,start:int,end:int):void{
			var params:Array = value.substring(start+1,end).split(",");
			var nameStr:String = params[0];
			var color:int = int(params[7]);
			var alpha:Number = Number(params[8]);
			var script:LScript = LGlobal.script;
			var layer:LSprite;
			layer = script.scriptArray.layerList[nameStr];
			LDisplay.drawTriangle(layer.graphics,[int(params[1]),int(params[2]),int(params[3]),int(params[4]),int(params[5]),int(params[6])],true,color,alpha);
			script.analysis();
		}
		/**
		 * 脚本解析
		 * 添加层
		 * Layer.drawTriangle(name,x1,y1,x2,y2,x3,y3,color,alpha);
		 * @param 脚本信息
		 */
		private static function drawTriangleLine(value:String,start:int,end:int):void{
			var params:Array = value.substring(start+1,end).split(",");
			var nameStr:String = params[0];
			var color:int = int(params[7]);
			var alpha:Number = Number(params[8]);
			var script:LScript = LGlobal.script;
			var layer:LSprite;
			layer = script.scriptArray.layerList[nameStr];
			LDisplay.drawTriangle(layer.graphics,[int(params[1]),int(params[2]),int(params[3]),int(params[4]),int(params[5]),int(params[6])],false,color,alpha);
			script.analysis();
		}
		/**
		 * 脚本解析
		 * 添加层
		 * Layer.drawRect(name,x,y,width,height,color,alpha);
		 * @param 脚本信息
		 */
		private static function drawRect(value:String,start:int,end:int):void{
			var params:Array = value.substring(start+1,end).split(",");
			var nameStr:String = params[0];
			var color:int = int(params[5]);
			var alpha:Number = Number(params[6]);
			var script:LScript = LGlobal.script;
			var layer:LSprite;
			layer = script.scriptArray.layerList[nameStr];
			LDisplay.drawRect(layer.graphics,[int(params[1]),int(params[2]),int(params[3]),int(params[4])],true,color,alpha);
			script.analysis();
		}
		/**
		 * 脚本解析
		 * 添加层
		 * Layer.drawRoundRectLine(name,x,y,width,height,jw,jh,color,size);
		 * @param 脚本信息
		 */
		private static function drawRoundRectLine(value:String,start:int,end:int):void{
			var params:Array = value.substring(start+1,end).split(",");
			var nameStr:String = params[0];
			var color:int = int(params[7]);
			var size:int = int(params[8]);
			var script:LScript = LGlobal.script;
			var layer:LSprite;
			layer = script.scriptArray.layerList[nameStr];
			layer.graphics.lineStyle(size,color);
			LDisplay.drawRoundRect(layer.graphics,[int(params[1]),int(params[2]),int(params[3]),int(params[4]),int(params[5]),int(params[6])],false,color,1,size);
			script.analysis();
		}
		/**
		 * 脚本解析
		 * 添加层
		 * Layer.drawRectLine(name,x,y,width,height,color,size);
		 * @param 脚本信息
		 */
		private static function drawRectLine(value:String,start:int,end:int):void{
			var params:Array = value.substring(start+1,end).split(",");
			var nameStr:String = params[0];
			var color:int = int(params[5]);
			var size:int = int(params[6]);
			var script:LScript = LGlobal.script;
			var layer:LSprite;
			layer = script.scriptArray.layerList[nameStr];
			layer.graphics.lineStyle(size,color);
			LDisplay.drawRect(layer.graphics,[int(params[1]),int(params[2]),int(params[3]),int(params[4])],false,color,1,size);
			script.analysis();
		}
		/**
		 * 脚本解析
		 * 添加层
		 * Layer.transition(name,fadeIn,0.1);
		 * Layer.transition(name,fadeOut,0.1);
		 * Layer.transition(name,fadeTo,0.1,0.5);
		 * Layer.transition(name,fly,w,speed);
		 * @param 脚本信息
		 */
		private static function transition(value:String,start:int,end:int):void{
			var params:Array = value.substring(start+1,end).split(",");
			var nameStr:String;
			var modeStr:String;
			nameStr = params[0];
			modeStr = params[1];
			
			var speedNum:Number;
			var gotoNum:Number;
			var widthNum:Number;
			
			var fun:Function;
			var script:LScript = LGlobal.script;
			var layer:LSprite;
			layer = script.scriptArray.layerList[nameStr];
			if(modeStr == "fadeIn"){
				speedNum = Number(params[2]);
				fun = function():void{
					script.analysis();
				}
				LManager.fadeIn(layer,speedNum,fun);
			}else if(modeStr == "fadeOut"){
				speedNum = Number(params[2]);
				fun = function():void{
					script.analysis();
				}
				LManager.fadeOut(layer,speedNum,fun);
			}else if(modeStr == "fadeTo"){
				speedNum = Number(params[2]);
				if(params.length > 3){
					gotoNum = Number(params[3]);
				}
				fun = function():void{
					script.analysis();
				}
				LManager.fadeTo(layer,gotoNum,speedNum,fun);
			}else if(modeStr == "fly"){
				widthNum = Number(params[2]);
				speedNum = Number(params[3]);
				var mask:LSprite = new LSprite();
				LDisplay.drawRect(mask.graphics,[0,0,widthNum,layer.height],true);
				script.scriptLayer.addChild(mask);
				mask.x = layer.x;
				mask.y = layer.y;
				layer.mask = mask;
				layer.addEventListener(Event.ENTER_FRAME,function(event:Event):void{
					layer.x -= speedNum;
					if(layer.x <= mask.x - layer.width)layer.x = mask.x + layer.mask.width;
				});
				script.analysis();
			}
		}
		/**
		 * 脚本解析
		 * 添加层
		 * Layer.clearLayer(name)
		 * @param 脚本信息
		 */
		private static function clearLayer(value:String,start:int,end:int):void{
			var nameStr:String = LString.trim(value.substring(start+1,end));
			var script:LScript = LGlobal.script;
			var layer:LSprite;
			var i:uint;
			layer = script.scriptArray.layerList[nameStr];
			if(layer == null){
				script.analysis();
				return;
			}
			removeFromArray(layer);
			layer.die();
			
			script.analysis();
		}
		public static function removeFromArray(obj:LSprite):void{
			
			var count:int = obj.numChildren;
			
			for(var i:int = 0; i < count; i++){
				if(obj.getChildAt(i) is LSprite){
					removeFromArray(obj.getChildAt(i) as LSprite);
				}else if(obj.getChildAt(i) is LButton){
					LGlobal.script.scriptArray.btnList[obj.getChildAt(i).name] = null;
				}else if(obj.getChildAt(i) is LBitmap){
					LGlobal.script.scriptArray.imgList[obj.getChildAt(i).name] = null;
				}else if(obj.getChildAt(i) is LTextField){
					LGlobal.script.scriptArray.textList[obj.getChildAt(i).name] = null;
				}else if(obj.getChildAt(i) is LRadio){
					LGlobal.script.scriptArray.radioList[obj.getChildAt(i).name] = null;
				}
			}
		}
		/**
		 * 脚本解析
		 * 添加层
		 * Layer.removeLayer(name)
		 * @param 脚本信息
		 */
		private static function removeLayer(value:String,start:int,end:int):void{
			var nameStr:String = LString.trim(value.substring(start+1,end));
			var script:LScript = LGlobal.script;
			var layer:LSprite;
			var parent:LSprite;
			layer = script.scriptArray.layerList[nameStr];
			if(layer == null){
				script.analysis();
				return;
			}
			try{
				if(layer.mask != null && script.scriptLayer.getChildByName(layer.mask.name))script.scriptLayer.removeChild(layer.mask);
			}catch(e:Error){
			}
			removeFromArray(layer);
			layer.removeFromParent();
			script.scriptArray.layerList[nameStr] = null;
			
			script.analysis();
		}
		/**
		 * 脚本解析
		 * 添加层
		 * Layer.add(-,back,0,0)
		 * @param 脚本信息
		 */
		private static function setLayer(value:String,start:int,end:int):void{
			var lArr:Array = value.substring(start+1,end).split(",");
			var parentStr:String = lArr[0];
			var nameStr:String = lArr[1];
			var xInt:Number = Number(lArr[2]);
			var yInt:Number = Number(lArr[3]);
			var script:LScript = LGlobal.script;
			var layer:LSprite;
			var parent:LSprite;
			var i:uint;
			parent = script.scriptArray.layerList[parentStr];
			layer = new LSprite();
			layer.x = xInt;
			layer.y = yInt;
			layer.name = nameStr;
			parent.addChild(layer);
			script.scriptArray.layerList[nameStr] = layer;
			script.analysis();
		}
	}
}