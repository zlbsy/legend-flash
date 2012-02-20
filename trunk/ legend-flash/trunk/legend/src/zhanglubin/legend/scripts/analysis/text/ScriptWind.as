package zhanglubin.legend.scripts.analysis.text
{
	import flash.text.StyleSheet;
	
	import zhanglubin.legend.components.LLabel;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.events.LEvent;
	import zhanglubin.legend.game.sousou.object.LSouSouObject;
	import zhanglubin.legend.scripts.LScript;
	import zhanglubin.legend.utils.LGlobal;
	import zhanglubin.legend.utils.math.LCoordinate;

	public class ScriptWind
	{
		
		public function ScriptWind()
		{
		}
		/**
		 * 脚本解析
		 * 添加label
		 * Text.wind(layer,name,こんにちは、張です。,x,y,width,size,speed);
		 * @param 脚本信息
		 */
		public static function analysis(value:String,start:int,end:int):void{
			var script:LScript = LGlobal.script;
			var lArr:Array = value.substring(start+1,end).split(",");
			var label:LLabel = new LLabel();
			var layer:LSprite;
			var layerStr:String = lArr[0];
			var nameStr:String = lArr[1];
			var textStr:String = lArr[2];
			label.wordWrap = true;
			label.width = int(lArr[5]);
			label.xy = new LCoordinate(int(lArr[3]),int(lArr[4]));
			var speed:Number = lArr[7];
			
			if(LGlobal.script.scriptArray != null && LGlobal.script.scriptArray.varList != null && LGlobal.script.scriptArray.varList[LSouSouObject.SPEED_FLAG] == LSouSouObject.FAST){
				speed *= 0.5;;
			}
			while(textStr.indexOf("\\n")>=0)textStr = textStr.replace("\\n","\n");
			label.setWindText(textStr,ScriptWind.getCss(int(lArr[6])),speed);
			
			layer = script.scriptArray.layerList[layerStr];
			script.scriptArray.textList[nameStr] = label;
			label.name = nameStr;
			layer.addChild(label);
			label.addEventListener(LEvent.LTEXT_MAX,function (event:LEvent):void{
				label.removeAllEventListener();
				script.analysis();
			});
		}
		/**
		 * 脚本解析
		 * 添加label
		 * Text.windChange(name,こんにちは、張です。);
		 * @param 脚本信息
		 */
		public static function windChange(value:String,start:int,end:int):void{
			var script:LScript = LGlobal.script;
			var lArr:Array = value.substring(start+1,end).split(",");
			var nameStr:String = lArr[0];
			var textStr:String = lArr[1];
			var label:LLabel = script.scriptArray.textList[nameStr];
			while(textStr.indexOf("\\n")>=0)textStr = textStr.replace("\\n","\n");
			label.setWindText(textStr,label.css);
			label.addEventListener(LEvent.LTEXT_MAX,function (event:LEvent):void{
				trace("windChange Max");
				label.removeAllEventListener();
				script.analysis();
			});
		}
		/**
		 * 返回一个StyleSheet的Css
		 * 
		 */
		private static function getCss(size:uint):StyleSheet{
			var css:StyleSheet = new StyleSheet( );
			css.setStyle("p", {fontFamily: "_sans",fontSize:""+size,color:"#FFFFFF",fontWeight:"bold"});
			css.setStyle(".red", {color:"#FF0000"});
			css.setStyle(".yellow", {color:"#FFFF00"});
			css.setStyle(".green", {color:"#00FF00"});
			css.setStyle(".blue", {color:"#0000FF"});
			css.setStyle(".pink", {color:"#FF00FF"});
			css.setStyle(".black", {color:"#000000"});
			return css;
		}
	}
}