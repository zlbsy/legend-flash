package zhanglubin.legend.scripts.analysis.slg.sousou
{
	import zhanglubin.legend.game.sousou.map.LSouSouWindow;
	import zhanglubin.legend.game.sousou.map.window.LSouSouWindwoCondition;
	import zhanglubin.legend.game.sousou.map.window.LSouSouWindwoSupport;
	import zhanglubin.legend.game.sousou.map.window.LSouSouWindwoSystem;
	import zhanglubin.legend.game.sousou.object.LSouSouObject;
	import zhanglubin.legend.utils.LGlobal;

	public class ScriptSouSouWindow
	{
		public function ScriptSouSouWindow()
		{
		}
		/**
		 * 脚本解析
		 * 对话操作
		 * 
		 * @param 脚本信息
		 */
		public static function analysis(value:String):void{
			trace("ScriptSouSouWindow run");
			var start:int = value.indexOf("(");
			var end:int = value.indexOf(")");
			var window:LSouSouWindow;
			var param:Array = value.substring(start + 1,end).split(",");
			switch(value.substr(0,start)){
				case "SouSouWindow.preWar":
					trace("SouSouWindow.preWar run");
					window = new LSouSouWindow();
					window.preWar(param);
					LGlobal.script.scriptLayer.addChild(window);
					break;
				case "SouSouWindow.setCondition":
					trace("SouSouWindow.setCondition run");
					window = new LSouSouWindwoCondition();
					(window as LSouSouWindwoCondition).show(param);
					LGlobal.script.scriptLayer.addChild(window);
					break;
				case "SouSouWindow.shop":
					trace("SouSouWindow.shop run");
					window = new LSouSouWindow();
					window.shop();
					LGlobal.script.scriptLayer.addChild(window);
					break;
				case "SouSouWindow.addMoney":
					LSouSouObject.money += int(param[0]);
					LGlobal.script.analysis();
					break;
				case "SouSouWindow.addProps":
					var propsXml:XMLList = LSouSouObject.props["Props" + param[0]];
					var xmllist:XML;
					var ishava:Boolean;
					for each(xmllist in LSouSouObject.propsList.elements()){
						if(int(xmllist.@index) == int(param[0])){
							xmllist.@num = int(xmllist.@num) + 1;
							ishava = true;
							break;
						}
					}
					if(!ishava){
						LSouSouObject.propsList.appendChild(new XMLList("<list index='"+param[0]+"' num='1' />"));
					}
					LGlobal.script.analysis();
					break;
				case "SouSouWindow.addItem":
					var itemXml:XMLList = LSouSouObject.item["Child" + param[0]];
					LSouSouObject.itemsList.appendChild(new XMLList("<list index='"+param[0]+"' lv='"+param[1]+"' />"));
					LGlobal.script.analysis();
					break;
				case "SouSouWindow.msg":
					window = new LSouSouWindow();
					window.setMsg(param);
					LGlobal.script.scriptLayer.addChild(window);
					break;
				case "SouSouWindow.singled":
					trace("SouSouWindow.singled run");
					window = new LSouSouWindow();
					window.singled(param);
					LGlobal.script.scriptLayer.addChild(window);
					LGlobal.script.analysis();
					break;
				case "SouSouWindow.singledend":
					trace("SouSouWindow.singledend run ");
					LSouSouObject.window.removeFromParent();
					LGlobal.script.analysis();
					break;
				case "SouSouWindow.system":
					if(param[0] == "set"){
						window = new LSouSouWindwoSystem();
						(window as LSouSouWindwoSystem).showSet();
					}else if(param[0] == "support"){
						window = new LSouSouWindwoSupport();
						(window as LSouSouWindwoSupport).show();
					}else{
						window = new LSouSouWindow();
						window.systemShow(param[0]);
					}
					LGlobal.script.scriptLayer.addChild(window);
				default:
			}
			
		}
	}
}