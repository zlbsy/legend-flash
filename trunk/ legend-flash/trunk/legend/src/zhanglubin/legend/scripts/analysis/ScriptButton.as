package zhanglubin.legend.scripts.analysis
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	import zhanglubin.legend.components.LLabel;
	import zhanglubin.legend.display.LButton;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.scripts.LScript;
	import zhanglubin.legend.utils.LFilter;
	import zhanglubin.legend.utils.LGlobal;
	import zhanglubin.legend.utils.math.LCoordinate;

	public class ScriptButton
	{
		
		public function ScriptButton()
		{
		}
		/**
		 * 脚本解析
		 * 按钮
		 * 
		 * @param 脚本信息
		 */
		public static function analysis(value:String):void{
			var start:int = value.indexOf("(");
			var end:int = value.indexOf(")");
			switch(value.substr(0,start)){
				case "Button.add":
					addButton(value,start,end);
					break;
				case "Button.remove":
					removeButton(value,start,end);
					break;
				case "Button.mousedown":
					mousedown(value,start,end,MouseEvent.MOUSE_DOWN);
					break;
				case "Button.mouseup":
					mousedown(value,start,end,MouseEvent.MOUSE_UP);
					break;
				case "Button.mouseover":
					mousedown(value,start,end,MouseEvent.MOUSE_OVER);
					break;
				case "Button.mouseout":
					mousedown(value,start,end,MouseEvent.MOUSE_OUT);
					break;
				case "Button.setFilter":
					setFilter(value,start,end);
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
			var btn:LButton = script.scriptArray.btnList[nameStr];
			switch(filter){
				case "INIT":
					LFilter.setFilter(btn,LFilter.INIT);
					break;
				case "GRAY":
					LFilter.setFilter(btn,LFilter.GRAY);
					break;
				case "SHADOW":
					LFilter.setFilter(btn,LFilter.SHADOW);
					break;
				case "SUN":
					LFilter.setFilter(btn,LFilter.SUN);
					break;
				case "RELIEF":
					LFilter.setFilter(btn,LFilter.RELIEF);
					break;
			}
			script.analysis();
		}
		/**
		 * 脚本解析
		 * 按钮事件，鼠标按下
		 * 
		 * @param 脚本信息
		 */
		private static function mousedown(value:String,start:int,end:int,e:String):void{
			var script:LScript = LGlobal.script;
			var i:uint;
			var lArr:Array = value.substring(start+1,end).split(",");
			var nameStr:String = lArr[0];
			var funStr:String = lArr[1];
			var btn:LButton = script.scriptArray.btnList[nameStr];
			var fun:Function = function(event:MouseEvent):void{
				ScriptFunction.analysis("Call." + funStr + "();");
			}
			btn.addEventListener(e,fun);
			script.scriptArray.btnList[nameStr] = btn;
			
			script.analysis();
		}
		/**
		 * 脚本解析
		 * 添加层
		 * Img.remove(chara01);
		 * @param 脚本信息
		 */
		private static function removeButton(value:String,start:int,end:int):void{
			var lArr:Array = value.substring(start+1,end).split(",");
			var nameStr:String = lArr[0];
			var script:LScript = LGlobal.script;
			var btn:LButton = script.scriptArray.btnList[nameStr];
			if(btn == null){
				script.scriptArray.btnList[nameStr] = null;
				script.analysis();
				return;
			}
			btn.removeFromParent();
			script.scriptArray.btnList[nameStr] = null;
			script.analysis();
		}
		/**
		 * 脚本解析
		 * 添加按钮
		 * Button.add(back,btn01,100,100,btn01_up,btn01_over,btn01_over);
		 */
		private static function addButton(value:String,start:int,end:int):void{
			var script:LScript = LGlobal.script;
			var layer:LSprite;
			var i:uint;
			
			var lArr:Array = value.substring(start+1,end).split(",");
			var layerStr:String = lArr[0];
			var nameStr:String = lArr[1];
			var labelStr:String = lArr[2];
			var xy:LCoordinate = new LCoordinate(int(lArr[3]),int(lArr[4]));
			var dataUp:String = lArr[5];
			var dataOver:String = lArr[6];
			var dataDown:String = lArr[7];
			var upimg:BitmapData;
			var overimg:BitmapData;
			var downimg:BitmapData;
			if(lArr.length > 9){
				upimg = LGlobal.getBitmapData(script.scriptArray.swfList[lArr[9]],dataUp);
				overimg = LGlobal.getBitmapData(script.scriptArray.swfList[lArr[9]],dataOver);
				downimg = LGlobal.getBitmapData(script.scriptArray.swfList[lArr[9]],dataDown);
			}else{
				upimg = script.scriptArray.bitmapdataList[dataUp];
				overimg = script.scriptArray.bitmapdataList[dataOver];
				downimg = script.scriptArray.bitmapdataList[dataDown];
			}
			var btn:LButton = new LButton(upimg,
				overimg,
				downimg);
			btn.xy = xy;
			if(lArr.length > 8){
				btn.labelColor = String(lArr[8]);
			}
			btn.label = labelStr;
			layer = script.scriptArray.layerList[layerStr];
			script.scriptArray.btnList[nameStr] = btn;
			btn.name = nameStr;
			layer.addChild(btn);
			script.analysis();
		}
	}
}