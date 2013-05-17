package com.lufylegend.legend.scripts.analysis
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import com.lufylegend.legend.components.LLabel;
	import com.lufylegend.legend.components.LRadio;
	import com.lufylegend.legend.display.LBitmap;
	import com.lufylegend.legend.display.LButton;
	import com.lufylegend.legend.display.LSprite;
	import com.lufylegend.legend.events.LEvent;
	import com.lufylegend.legend.scripts.LScript;
	import com.lufylegend.legend.utils.LGlobal;
	import com.lufylegend.legend.utils.math.LCoordinate;

	public class ScriptRadio
	{
		
		public function ScriptRadio()
		{
		}
		/**
		 * 脚本解析<br />
		 * radio按钮<br />
		 * Radio.add(-,radio01,0,[0,10,10,select,unselect,onover],[1,100,100,select,unselect,onover],[2,200,100,select,unselect,onover]...);<br />
		 * function radiochange();<br />
		 * Radio.getValue(radio01,radio01value);<br />
		 * Text.labelChange(test,＠radio01value);<br />
		 * endfunction;<br />
		 * Radio.valuechange(radio01,radiochange);<br />
		 * 
		 * @param 脚本信息
		 */
		public static function analysis(value:String):void{
			var start:int = value.indexOf("(");
			var end:int = value.indexOf(")");
			switch(value.substr(0,start)){
				case "Radio.add":
					addRadio(value,start,end);
					break;
				case "Radio.remove":
					removeRadio(value,start,end);
					break;
				case "Radio.setValue":
					setValue(value,start,end);
					break;
				case "Radio.getValue":
					getValue(value,start,end);
					break;
				case "Radio.valuechange":
					valuechange(value,start,end);
					break;
				default:
					
			}
			
		}
		/**
		 * 脚本解析
		 * 
		 * @param 脚本信息
		 */
		private static function valuechange(value:String,start:int,end:int):void{
			var script:LScript = LGlobal.script;
			var i:uint;
			var lArr:Array = value.substring(start+1,end).split(",");
			var nameStr:String = lArr[0];
			var funStr:String = lArr[1];
			var radio:LRadio = script.scriptArray.radioList[nameStr];
			var fun:Function = function(event:Event):void{
				ScriptFunction.analysis("Call." + funStr + "();");
			}
			radio.addEventListener(LEvent.CHANGE_VALUE,fun);
			
			script.analysis();
		}
		/**
		 * 脚本解析
		 * Radio.getValue(name,valname)
		 * 
		 * @param 脚本信息
		 */
		private static function getValue(value:String,start:int,end:int):void{
			var script:LScript = LGlobal.script;
			var i:uint;
			var lArr:Array = value.substring(start+1,end).split(",");
			var nameStr:String = lArr[0];
			var valName:String = lArr[1];
			var radio:LRadio = script.scriptArray.radioList[nameStr];
			if(radio != null)script.scriptArray.varList[valName] = radio.value;
			
			script.analysis();
		}
		/**
		 * 脚本解析
		 * Radio.setValue(name,value)
		 * 
		 * @param 脚本信息
		 */
		private static function setValue(value:String,start:int,end:int):void{
			var script:LScript = LGlobal.script;
			var i:uint;
			var lArr:Array = value.substring(start+1,end).split(",");
			var nameStr:String = lArr[0];
			var value:String = lArr[1];
			var radio:LRadio = script.scriptArray.radioList[nameStr];
			if(radio == null){
				script.analysis();
				return;
			}
			radio.value = value;
			
			script.analysis();
		}
		/**
		 * 脚本解析
		 * Radio.remove(name);
		 * @param 脚本信息
		 */
		private static function removeRadio(value:String,start:int,end:int):void{
			var lArr:Array = value.substring(start+1,end).split(",");
			var nameStr:String = lArr[0];
			
			var script:LScript = LGlobal.script;
			var radio:LRadio = script.scriptArray.radioList[nameStr];
			if(radio == null){
				script.scriptArray.radioList[nameStr] = null;
				script.analysis();
				return;
			}
			radio.removeFromParent();
			script.scriptArray.radioList[nameStr] = null;
			script.analysis();
		}
		/**
		 * 脚本解析
		 * 添加Radio
		 * Radio.add(back,name,0,[value,x,y,select,unselect,onover,swf],[value,x,y,select,unselect,onover,swf],[value,x,y,select,unselect,onover,swf]...);
		 */
		private static function addRadio(value:String,start:int,end:int):void{
			var script:LScript = LGlobal.script;
			var layer:LSprite;
			var i:uint;
			
			var params:Array = value.substring(start+1,end).split(",");
			var radioList:Array = LGlobal.getArray(value);
			var layerStr:String = params[0];
			var nameStr:String = params[1];
			var checkIndex:int = params[2];
			var select:BitmapData;
			var unselect:BitmapData;
			var onover:BitmapData;
			var layerRadio:LRadio;
			var rx:int,ry:int,arr:Array,btn:LButton,bit:LBitmap,radioChild:LSprite;
			
			layerRadio = new LRadio();
			layerRadio.name = nameStr;
			for(i=0;i<radioList.length;i++){
				arr = radioList[i];
				if(arr.length > 6){
					select = LGlobal.getBitmapData(script.scriptArray.swfList[arr[6]],arr[3]);
					unselect = LGlobal.getBitmapData(script.scriptArray.swfList[arr[6]],arr[4]);
					onover = LGlobal.getBitmapData(script.scriptArray.swfList[arr[6]],arr[5]);
				}else if(arr.length > 3){
					select = script.scriptArray.bitmapdataList[arr[3]];
					unselect = script.scriptArray.bitmapdataList[arr[4]];
					onover = script.scriptArray.bitmapdataList[arr[5]];
				}
				if(select == null){
					select = new BitmapData(20,20,false,0xff0000);
					unselect = new BitmapData(20,20,false,0xcccccc);
					onover = new BitmapData(20,20,false,0x333333);
				}
				btn = new LButton(unselect,
					onover,
					select);
				bit = new LBitmap(select);
				layerRadio.setChildRadio(arr[0],arr[1],arr[2],bit,btn);
				if(checkIndex >= 0 && checkIndex == i){
					layerRadio.value = arr[0];
				}
			}
			layer = script.scriptArray.layerList[layerStr];
			script.scriptArray.radioList[nameStr] = layerRadio;
			layer.addChild(layerRadio);
			script.analysis();
		}
	}
}