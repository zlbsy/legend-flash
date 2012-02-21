package zhanglubin.legend.scripts.analysis
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import zhanglubin.legend.components.LComboBox;
	import zhanglubin.legend.components.LLabel;
	import zhanglubin.legend.components.LRadio;
	import zhanglubin.legend.display.LBitmap;
	import zhanglubin.legend.display.LButton;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.events.LEvent;
	import zhanglubin.legend.scripts.LScript;
	import zhanglubin.legend.utils.LGlobal;
	import zhanglubin.legend.utils.math.LCoordinate;

	public class ScriptComboBox
	{
		
		public function ScriptComboBox()
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
				case "ComboBox.add":
					addComboBox(value,start,end);
					break;
				case "ComboBox.remove":
					removeComboBox(value,start,end);
					break;
				case "ComboBox.setValue":
					setValue(value,start,end);
					break;
				case "ComboBox.getValue":
					getValue(value,start,end);
					break;
				case "ComboBox.valuechange":
					valuechange(value,start,end);
					break;
				case "ComboBox.addList":
					addList(value,start,end);
					break;
				default:
					
			}
			
		}
		/**
		 * 脚本解析
		 * 按钮事件，鼠标按下
		 * 
		 * @param 脚本信息
		 */
		private static function valuechange(value:String,start:int,end:int):void{
			var script:LScript = LGlobal.script;
			var i:uint;
			var lArr:Array = value.substring(start+1,end).split(",");
			var nameStr:String = lArr[0];
			var funStr:String = lArr[1];
			var comboBox:LComboBox = script.scriptArray.comboBoxList[nameStr];
			/*
			var fun:Function = function(event:Event):void{
				ScriptFunction.analysis("Call." + funStr + "();");
			}
			radio.addEventListener(LEvent.RADIO_VALUE_CHANGE,fun);
			*/
			script.analysis();
		}
		/**
		 * 脚本解析
		 * ComboBox.getValue(name,valname)
		 * 
		 * @param 脚本信息
		 */
		private static function getValue(value:String,start:int,end:int):void{
			var script:LScript = LGlobal.script;
			var i:uint;
			var lArr:Array = value.substring(start+1,end).split(",");
			var nameStr:String = lArr[0];
			var valName:String = lArr[1];
			var comboBox:LComboBox = script.scriptArray.comboBoxList[nameStr];
			if(comboBox != null)script.scriptArray.varList[valName] = comboBox.value;
			
			script.analysis();
		}
		/**
		 * 脚本解析
		 * ComboBox.setValue(name,value)
		 * 
		 * @param 脚本信息
		 */
		private static function setValue(value:String,start:int,end:int):void{
			var script:LScript = LGlobal.script;
			var i:uint;
			var lArr:Array = value.substring(start+1,end).split(",");
			var nameStr:String = lArr[0];
			var value:String = lArr[1];
			var comboBox:LComboBox = script.scriptArray.comboBoxList[nameStr];
			if(comboBox == null){
				script.analysis();
				return;
			}
			comboBox.value = value;
			
			script.analysis();
		}
		/**
		 * 脚本解析
		 * 添加层
		 * ComboBox.remove(name);
		 * @param 脚本信息
		 */
		private static function removeComboBox(value:String,start:int,end:int):void{
			var lArr:Array = value.substring(start+1,end).split(",");
			var nameStr:String = lArr[0];
			
			var script:LScript = LGlobal.script;
			var comboBox:LComboBox = script.scriptArray.comboBoxList[nameStr];
			if(comboBox == null){
				script.scriptArray.comboBoxList[nameStr] = null;
				script.analysis();
				return;
			}
			comboBox.removeFromParent();
			script.scriptArray.comboBoxList[nameStr] = null;
			script.analysis();
		}
		/**
		 * 脚本解析
		 * ComboBox.addList(name,cname,cvalue);
		 * @param 脚本信息
		 */
		private static function addList(value:String,start:int,end:int):void{
			var script:LScript = LGlobal.script;
			var i:uint;
			var lArr:Array = value.substring(start+1,end).split(",");
			var nameStr:String = lArr[0];
			var cname:String = lArr[1];
			var cvalue:String = lArr[2];
			var comboBox:LComboBox = script.scriptArray.comboBoxList[nameStr];
			if(comboBox != null)comboBox.push(cname,cvalue);
			script.analysis();
		}
		/**
		 * 脚本解析
		 * 添加addComboBox
		 * ComboBox.add(-,combo01,100,50,back,childBack,buttonBitmapdata);
		 */
		private static function addComboBox(value:String,start:int,end:int):void{
			var script:LScript = LGlobal.script;
			var layer:LSprite;
			var i:uint;
			
			var params:Array = value.substring(start+1,end).split(",");

			var layerStr:String = params[0];
			var nameStr:String = params[1];
			var x:int = params[2];
			var y:int = params[3];
			var back:BitmapData;
			var childBack:BitmapData;
			var buttonBitmapdata:BitmapData;
			var comboBox:LComboBox;
			if(params.length > 7){
				if((params[4] as String).length > 0){
					back = LGlobal.getBitmapData(script.scriptArray.swfList[params[7]],params[4]);
				}
				if((params[5] as String).length > 0){
					childBack = LGlobal.getBitmapData(script.scriptArray.swfList[params[7]],params[5]);
				}
				if((params[6] as String).length > 0){
					buttonBitmapdata = LGlobal.getBitmapData(script.scriptArray.swfList[params[7]],params[6]);
				}
			}else{
				if(params.length > 4 && (params[4] as String).length > 0){
					back = script.scriptArray.bitmapdataList[params[4]];
				}
				if(params.length > 5 && (params[5] as String).length > 0){
					childBack = script.scriptArray.bitmapdataList[params[5]];
				}
				if(params.length > 6 && (params[6] as String).length > 0){
					buttonBitmapdata = script.scriptArray.bitmapdataList[params[6]];
				}
			}
			comboBox = new LComboBox(back,childBack,buttonBitmapdata);
			comboBox.x = x;
			comboBox.y = y;
			
			layer = script.scriptArray.layerList[layerStr];
			script.scriptArray.comboBoxList[nameStr] = comboBox;
			layer.addChild(comboBox);
			script.analysis();
		}
	}
}