package com.lufylegend.legend.scripts.analysis
{
	import flash.events.MouseEvent;
	
	import com.lufylegend.legend.components.LLabel;
	import com.lufylegend.legend.display.LSprite;
	import com.lufylegend.legend.scripts.LScript;
	import com.lufylegend.legend.scripts.analysis.text.ScriptLabel;
	import com.lufylegend.legend.scripts.analysis.text.ScriptWind;
	import com.lufylegend.legend.utils.LGlobal;
	import com.lufylegend.legend.utils.transitions.LManager;

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
				case "Wait.clickOver":
					LGlobal.script.scriptLayer.removeEventListener(MouseEvent.MOUSE_UP,clickEvent);
					break;
				case "Wait.Over":
					LGlobal.script.scriptLayer.removeEventListener(MouseEvent.MOUSE_UP,clickEvent);
				case "Wait.timeOver":
					timeOver();
					break;
			}
			
		}
		private static function timeOver():void{
			if(LManager.transitionList == null){
				LGlobal.script.analysis();
				return;
			}
			var i:uint;
			for(i=0;i<LManager.transitionList.length;i++){
				var tran:Array = LManager.transitionList[i];
				if(tran[0] == "wait"){
					LManager.transitionList.splice(i,1);
					i--;
				}
			}
			LGlobal.script.analysis();
		}
		/**
		 * 脚本解析
		 * 添加waitclick
		 * 
		 * @param 脚本信息
		 */
		private static function waitclick():void{
			trace("ScriptWait waitclick is run");
			var layer:LSprite = LGlobal.script.scriptLayer;
			layer.addEventListener(MouseEvent.MOUSE_UP,clickEvent);
		}
		private static function clickEvent(event:MouseEvent):void{
			trace("ScriptWait clickEvent is run");
			LGlobal.script.scriptLayer.removeEventListener(MouseEvent.MOUSE_UP,clickEvent);
			LGlobal.script.analysis();
		}
	}
}