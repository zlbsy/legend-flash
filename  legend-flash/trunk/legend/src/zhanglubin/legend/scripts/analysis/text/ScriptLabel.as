package zhanglubin.legend.scripts.analysis.text
{
	import zhanglubin.legend.components.LLabel;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.scripts.LScript;
	import zhanglubin.legend.utils.LGlobal;
	import zhanglubin.legend.utils.math.LCoordinate;

	public class ScriptLabel
	{
		
		public function ScriptLabel()
		{
		}
		/**
		 * 脚本解析
		 * 添加label
		 * Text.label(layer,name,こんにちは、張です。,100,200,13,#ff0000,1);
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
			while(textStr.indexOf("\\n")>=0)textStr = textStr.replace("\\n","\n");
			if(lArr.length > 7 && int(lArr[7]) == 1)textStr = "<b>"+textStr+"</b>";
			label.htmlText = "<font size='"+lArr[5]+"' color='"+lArr[6]+"'>" + textStr + "</font>";
			label.x = int(lArr[3]);
			label.y = int(lArr[4]);
			
			layer = script.scriptArray.layerList[layerStr];
			script.scriptArray.textList[nameStr] = label;
			label.name = nameStr;
			layer.addChild(label);
			script.analysis();
		}
		/**
		 * 脚本解析
		 * 添加label
		 * Text.labelChange(name01,[ ??? ],15,#ffffff);
		 * @param 脚本信息
		 */
		public static function labelChange(value:String,start:int,end:int):void{
			var script:LScript = LGlobal.script;
			var lArr:Array = value.substring(start+1,end).split(",");
			var nameStr:String = lArr[0];
			var label:LLabel = script.scriptArray.textList[nameStr]
			label.htmlText = "<font size='"+lArr[2]+"' color='"+lArr[3]+"'>" + lArr[1] + "</font>";
			script.analysis();
		}
	}
}