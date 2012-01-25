package zhanglubin.legend.scripts.analysis.slg.sousou
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.text.StyleSheet;
	
	import zhanglubin.legend.components.LLabel;
	import zhanglubin.legend.display.LBitmap;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.events.LEvent;
	import zhanglubin.legend.game.sousou.object.LSouSouObject;
	import zhanglubin.legend.scripts.LScript;
	import zhanglubin.legend.scripts.analysis.text.ScriptLabel;
	import zhanglubin.legend.scripts.analysis.text.ScriptWind;
	import zhanglubin.legend.text.LTextField;
	import zhanglubin.legend.utils.LDisplay;
	import zhanglubin.legend.utils.LGlobal;
	import zhanglubin.legend.utils.math.LCoordinate;
	
	public class SouSouTalk
	{
		
		public function SouSouTalk()
		{
		}
		/**
		 * 脚本解析
		 * 对话操作
		 * 
		 * @param 脚本信息
		 */
		public static function analysis(value:String):void{
			var start:int = value.indexOf("(");
			var end:int = value.indexOf(")");
			switch(value.substr(0,start)){
				case "SouSouTalk.set":
					setTalk(value,start,end);
					break;
				default:
			}
			
		}
		
		/**
		 * 脚本解析
		 * 添加对话
		 * SouSouTalk.set(1,0,こんにちは、張です。,1);
		 * @param 脚本信息
		 */
		public static function setTalk(value:String,start:int,end:int):void{
			var script:LScript = LGlobal.script;
			var lArr:Array = value.substring(start+1,end).split(",");
			var label:LTextField = new LTextField();
			var characterName:LLabel = new LLabel();
			var layer:LSprite = script.scriptLayer;
			var nameStr:String = "SouSouTalk";
			var speed:int = 50;
			if(lArr.length > 3){
				speed = int(lArr[3]);
			}
			var mask:LSprite = new LSprite();
			LDisplay.drawRect(mask.graphics,[0,0,800,480],true,0x000000,0);
			script.scriptArray.layerList["mask"] = mask;
			layer.addChild(mask);
			var bitdata:BitmapData = LGlobal.getBitmapData(script.scriptArray.swfList["img"],"talk.png");
			var bitmap:LBitmap;
			bitmap = new LBitmap(bitdata);
			bitmap.x = 200;
			bitmap.y = 300;
			bitmap.name = nameStr;
			script.scriptArray.imgList[nameStr] = bitmap;
			layer.addChild(bitmap);
			
			var name_bitmap:LBitmap;
			name_bitmap = new LBitmap(bitdata);
			name_bitmap.x = bitmap.x + 246.5;
			name_bitmap.y = bitmap.y - 15;
			name_bitmap.width = 300;
			name_bitmap.height = 35;
			name_bitmap.name = nameStr+"-name";
			script.scriptArray.imgList[nameStr+"-name"] = name_bitmap;
			layer.addChild(name_bitmap);
			
			var facedata:BitmapData = LGlobal.getBitmapData(script.scriptArray.swfList["face"],
				"face" + LSouSouObject.chara["peo"+lArr[0]]["Face"] +"-"+ lArr[1]);
			var face:LBitmap = new LBitmap(facedata);
			face.x = bitmap.x + 25;
			face.y = bitmap.y -112;
			script.scriptArray.imgList["face"] = face;
			layer.addChild(face);
			
			characterName.htmlText = "<font color='#ff0000' size='22'><b>" + LSouSouObject.chara["peo"+lArr[0]]["Name"] + "</b></font>";
			characterName.xy = new LCoordinate(bitmap.x + 265,bitmap.y - 13);
			script.scriptArray.textList["talkname"] = characterName;
			characterName.name = "talkname";
			layer.addChild(characterName);
			
			label.selectable = false;
			label.wordWrap = true;
			label.width = 260;
			label.height = 90;
			label.xy = new LCoordinate(bitmap.x + 260,bitmap.y + 30);
			label.setWindText(lArr[2],SouSouTalk.getCss(18),speed);
			
			script.scriptArray.textList[nameStr] = label;
			label.name = nameStr;
			layer.addChild(label);
			label.addEventListener(LEvent.LTEXT_MAX,function (event:LEvent):void{
				LGlobal.script.scriptLayer.addEventListener(MouseEvent.CLICK,clickEvent);
			});
		}
		private static function clickEvent(event:MouseEvent):void{
			LGlobal.script.scriptLayer.removeEventListener(MouseEvent.CLICK,clickEvent);
			var nameStr:String = "SouSouTalk";
			LGlobal.script.scriptArray.textList["talkname"].removeFromParent();
			LGlobal.script.scriptArray.textList[nameStr].removeFromParent();
			LGlobal.script.scriptArray.imgList[nameStr].removeFromParent();
			LGlobal.script.scriptArray.imgList[nameStr + "-name"].removeFromParent();
			LGlobal.script.scriptArray.imgList["face"].removeFromParent();
			LGlobal.script.scriptArray.layerList["mask"].removeFromParent();
			LGlobal.script.analysis();
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
			return css;
		}

	}
}