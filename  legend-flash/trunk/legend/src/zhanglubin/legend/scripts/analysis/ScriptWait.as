package zhanglubin.legend.scripts.analysis
{
	import flash.events.MouseEvent;
	
	import zhanglubin.legend.components.LLabel;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.scripts.LScript;
	import zhanglubin.legend.scripts.analysis.text.ScriptLabel;
	import zhanglubin.legend.scripts.analysis.text.ScriptWind;
	import zhanglubin.legend.utils.LGlobal;
	import zhanglubin.legend.utils.transitions.LManager;

	public class ScriptWait
	{
		
		public function ScriptWait()
		{
		}
		/**
		 * 脚本解析
		 * 添加Wait
		 *
		 * @param 脚本信息
		 */
		public static function analysis(value:String):void{
			var start:int = value.indexOf("(");
			var end:int = value.indexOf(")");
			switch(value.substr(0,start)){
				case "Wait.click":
					waitclick();
					break;
				case "Wait.ctrl":
					if(int(value.substring(start + 1,end)) > 0)LGlobal.script.lineList.unshift("Wait.ctrl()");
					break;
				case "Wait.play":
					LGlobal.script.analysis();
					break;
				case "Wait.time":
					LManager.wait(int(value.substring(start + 1,end)),function ():void{trace("wait time run !! ");LGlobal.script.analysis();});
					break;
			}
			
		}
		/**
		 * 脚本解析
		 * 添加waitclick
		 * 
		 * @param 脚本信息
		 */
		private static function waitclick():void{
			trace("ScriptWait waitclick");
			var layer:LSprite = LGlobal.script.scriptLayer;
			layer.addEventListener(MouseEvent.CLICK,clickEvent);
		}
		private static function clickEvent(event:MouseEvent):void{
			LGlobal.script.scriptLayer.removeEventListener(MouseEvent.CLICK,clickEvent);
			LGlobal.script.analysis();
		}
	}
}