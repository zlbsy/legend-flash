package zhanglubin.legend.scripts.analysis
{
	
	import zhanglubin.legend.components.LRadio;
	import zhanglubin.legend.display.LBitmap;
	import zhanglubin.legend.display.LButton;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.scripts.LScript;
	import zhanglubin.legend.text.LTextField;
	import zhanglubin.legend.utils.LDisplay;
	import zhanglubin.legend.utils.LGlobal;
	import zhanglubin.legend.utils.LString;
	import zhanglubin.legend.utils.transitions.LManager;

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
				case "Layer.clear":
					clearLayer(value,start,end);
					break;
				case "Layer.drawRect":
					drawRect(value,start,end);
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
				default:
					
			}
			
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
		 * @param 脚本信息
		 */
		private static function transition(value:String,start:int,end:int):void{
			var lArr:Array = value.substring(start+1,end).split(",");
			var nameStr:String = lArr[0];
			var modeStr:String = lArr[1];
			var speedNum:Number = Number(lArr[2]);
			var gotoNum:Number;
			if(lArr.length > 3){
				gotoNum = Number(lArr[3]);
			}
			
			var fun:Function;
			var script:LScript = LGlobal.script;
			var layer:LSprite;
			layer = script.scriptArray.layerList[nameStr];
			if(modeStr == "fadeIn"){
				fun = function():void{
					script.analysis();
				}
				LManager.fadeIn(layer,speedNum,fun);
			}else if(modeStr == "fadeOut"){
				fun = function():void{
					script.analysis();
				}
				LManager.fadeOut(layer,speedNum,fun);
			}else if(modeStr == "fadeTo"){
				fun = function():void{
					script.analysis();
				}
				LManager.fadeTo(layer,gotoNum,speedNum,fun);
			}
		}
		/**
		 * 脚本解析
		 * 添加层
		 * Layer.removeLayer(name)
		 * @param 脚本信息
		 */
		private static function clearLayer(value:String,start:int,end:int):void{
			var nameStr:String = LString.trim(value.substring(start+1,end));
			var script:LScript = LGlobal.script;
			var layer:LSprite;
			var i:uint;
			layer = script.scriptArray.layerList[nameStr];
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