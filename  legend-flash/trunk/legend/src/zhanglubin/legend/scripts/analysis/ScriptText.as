package zhanglubin.legend.scripts.analysis
{
	import zhanglubin.legend.components.LLabel;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.scripts.LScript;
	import zhanglubin.legend.scripts.analysis.text.ScriptLabel;
	import zhanglubin.legend.scripts.analysis.text.ScriptWind;
	import zhanglubin.legend.utils.LGlobal;

	public class ScriptText
	{
		
		public function ScriptText()
		{
		}
		/**
		 * 脚本解析
		 * 文本等操作
		 * 
		 * @param 脚本信息
		 */
		public static function analysis(value:String):void{
			var start:int = value.indexOf("(");
			var end:int = value.indexOf(")");
			switch(value.substr(0,start)){
				case "Text.label":
					ScriptLabel.analysis(value,start,end);
					break;
				case "Text.labelChange":
					ScriptLabel.labelChange(value,start,end);
					break;
				case "Text.wind":
					ScriptWind.analysis(value,start,end);
					break;
				case "Text.windChange":
					ScriptWind.windChange(value,start,end);
					break;
				case "Text.remove":
					removeText(value,start,end);
					break;
			}
			
		}
		/**
		 * 脚本解析
		 * 添加层
		 * Layer.removeLayer(name)
		 * @param 脚本信息
		 */
		private static function removeText(value:String,start:int,end:int):void{
			var lArr:Array = value.substring(start+1,end).split(",");
			var nameStr:String = lArr[0];
			var script:LScript = LGlobal.script;
			var label:LLabel = script.scriptArray.textList[nameStr];
			label.removeFromParent();
			script.scriptArray.textList[nameStr] = null;
			script.analysis();
		}
	}
}