package com.lufylegend.legend.scripts.analysis
{
	import flash.events.TextEvent;
	import flash.net.URLRequest;
	import flash.xml.XMLDocument;
	import flash.net.navigateToURL;
	
	import com.lufylegend.legend.components.LLabel;
	import com.lufylegend.legend.display.LSprite;
	import com.lufylegend.legend.scripts.LScript;
	import com.lufylegend.legend.scripts.analysis.text.ScriptLabel;
	import com.lufylegend.legend.scripts.analysis.text.ScriptWind;
	import com.lufylegend.legend.utils.LGlobal;

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
				case "Text.windOver":
					ScriptWind.windOver(value,start,end);
					break;
				case "Text.remove":
					removeText(value,start,end);
					break;
				case "Text.link":
					linkText(value,start,end);
					break;
			}
			
		}
		/**
		 * 脚本解析
		 * 添加层
		 * Layer.linkText(name,host,url,window)
		 * @param 脚本信息
		 */
		private static function linkText(value:String,start:int,end:int):void{
			var params:Array = value.substring(start+1,end).split(",");
			var nameStr:String = params[0];
			var strHost:String = params[1];
			var strURL:String = params[2];
			var strWindow:String = "_self";
			if(params.length > 3)strWindow = params[3];
			
			var script:LScript = LGlobal.script;
			var label:LLabel = script.scriptArray.textList[nameStr];
			if(label == null){
				script.analysis();
				return;
			}
			var xmlString:String = label.htmlText.toUpperCase();
			var startIndex:int = xmlString.indexOf(">") + 1;
			var endIndex:int = xmlString.indexOf("</P>");
			var xmlText:XML = new XML(label.htmlText);
			label.htmlText = xmlString.substring(0,startIndex) + "<a href='event:"+strHost+"://"+strURL+"'><u>" + label.htmlText.substring(startIndex,endIndex) + "</u></a>" + xmlString.substring(endIndex);
			label.addEventListener(TextEvent.LINK, function (event:TextEvent):void{
				var adUrl:URLRequest = new URLRequest(event.text);
				navigateToURL(adUrl,strWindow); 
			});
			script.analysis();
		}
		/**
		 * 脚本解析
		 * 添加层
		 * Layer.removeText(name)
		 * @param 脚本信息
		 */
		private static function removeText(value:String,start:int,end:int):void{
			var lArr:Array = value.substring(start+1,end).split(",");
			var nameStr:String = lArr[0];
			var script:LScript = LGlobal.script;
			var label:LLabel = script.scriptArray.textList[nameStr];
			if(label == null){
				script.analysis();
				return;
			}
			label.removeFromParent();
			script.scriptArray.textList[nameStr] = null;
			script.analysis();
		}
	}
}