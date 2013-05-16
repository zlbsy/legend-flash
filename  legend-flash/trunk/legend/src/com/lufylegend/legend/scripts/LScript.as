package zhanglubin.legend.scripts
{
	
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.game.sousou.object.LSouSouObject;
	import zhanglubin.legend.scripts.analysis.*;
	import zhanglubin.legend.utils.LGlobal;
	import zhanglubin.legend.utils.LString;

	public class LScript
	{
		private var _lineList:Array
		private var _copyList:Array
		private var _dataList:Array;
		private var _scriptLayer:LSprite;
		private var _scriptArray:LScriptArray;
		/**
		 * 基于legend的L#脚本
		 * @param scriptLayer 基层
		 * @param value 脚本文件位置
		 * @author lufy(lufy.legend＠gmail.com)
		 */
		public function LScript(scriptLayer:LSprite,value:String)
		{
			LGlobal.script = this;
			_scriptLayer = scriptLayer;
			LGlobal.stage = scriptLayer.stage;
			
			_scriptArray = new LScriptArray();
			this._scriptArray.layerList["-"] = this._scriptLayer;
			
			if(scriptLayer.root.loaderInfo.parameters){
				for(var key:String in scriptLayer.root.loaderInfo.parameters){
					this._scriptArray.varList[key] = scriptLayer.root.loaderInfo.parameters[key];
				}
			}
			
			_dataList = new Array();
			value = removeComment(value);
			var arr:Array=[value];
			_dataList.unshift(arr);
			//游戏速度
			//LGlobal.stage.frameRate = 10;
			toList(value);
		}
		
		public function set copyList(value:Array):void
		{
			_copyList = value;
		}
		public function get copyList():Array
		{
			return _copyList;
		}

		public function saveList():void{
			var arr:Array=_dataList[0] as Array;
			if(arr){
				arr[1]=_lineList;
				arr[2]=_copyList;
			}
		}
		public function removeComment(str:String):String{
			var sIndex:int;
			var eIndex:int;
			var sStr:String;
			var eStr:String;
			sIndex = str.indexOf("/*");
			while(sIndex >=0){
				eIndex = str.indexOf("*/",sIndex + 2);
				sStr = str.substr(0,sIndex);
				eStr = str.substr(eIndex + 2);
				str = sStr + eStr;
				sIndex = str.indexOf("/*");
			}
			
			sIndex = str.indexOf("//");
			while(sIndex >=0){
				eIndex = str.indexOf("\n",sIndex);
				if(eIndex >= 0){
					sStr = str.substr(0,sIndex);
					eStr = str.substr(eIndex);
					str = sStr + eStr;
					sIndex = str.indexOf("//");
				}else{
					sStr = str.substr(0,sIndex);
					str = sStr;
					sIndex = -1;
				}
			}
			return str;
		} 
		public function toList(ltxt:String):void{
			_lineList = ltxt.split(";");
			if(LGlobal.isreading.length > 0){
				_lineList.unshift("Mark.goto("+LGlobal.isreading+")");
				LGlobal.isreading = "";
			}
			_copyList = _lineList.concat();
			analysis();
		}
		public function analysis():void{
			var arr:Array;
			if(_lineList.length == 0){
				_dataList.shift();
				if(_dataList.length > 0){
					arr=_dataList[0];
					_lineList = arr[1];
					_copyList = arr[2];
					analysis();
				}
				return;
			}
			var lineValue:String = "";
			while(_lineList.length > 0 && lineValue.length == 0){
				lineValue = LString.trim(_lineList[0]);
				_lineList.shift();
			}
			if(lineValue.length == 0){
				analysis();
				return;
			}
			lineValue = ScriptVarlable.getVarlable(lineValue);
			var sarr:Array = lineValue.split(".");
			trace("LScript analysis lineValue = " + lineValue);
			switch(sarr[0]){
				case "Exit":
					ScriptExit.analysis(lineValue);
					/**
					_dataList.shift();
					if(_dataList.length > 0){
						arr=_dataList[0];
						_lineList = arr[1];
						_copyList = arr[2];
						analysis();
					}
					return;*/
					break;
				case "Layer":
					ScriptLayer.analysis(lineValue);
					break;
				case "Load":
					ScriptLoad.analysis(lineValue);
					break;
				case "Url":
					ScriptUrl.analysis(lineValue);
					break;
				case "Img":
					ScriptImg.analysis(lineValue);
					break;
				case "Var":
					ScriptVarlable.analysis(lineValue);
					break;
				case "Button":
					ScriptButton.analysis(lineValue);
					break;
				case "Radio":
					ScriptRadio.analysis(lineValue);
					break;
				case "ComboBox":
					ScriptComboBox.analysis(lineValue);
					break;
				case "Text":
					ScriptText.analysis(lineValue);
					break;
				case "Call":
					ScriptFunction.analysis(lineValue);
					break;
				case "Wait":
					ScriptWait.analysis(lineValue);
					break;
				case "Mark":
					ScriptMark.analysis(lineValue);
					break;
				case "Animation":
					ScriptAnimation.analysis(lineValue);
					break;
				default:
					if(lineValue.indexOf("if") >= 0){
						ScriptIF.getIF(lineValue);
					}else if(lineValue.indexOf("function") >= 0){
						ScriptFunction.setFunction(lineValue);
					}else if(lineValue.indexOf("SouSou") == 0){
						LScriptSLGSouSou.analysis(sarr[0],lineValue);
					}else{
						childAnalysis(sarr[0],lineValue);
					}
			}
		}
		public function get scriptLayer():LSprite
		{
			return _scriptLayer;
		}

		public function set scriptLayer(value:LSprite):void
		{
			_scriptLayer = value;
		}
		public function get scriptArray():LScriptArray
		{
			return _scriptArray;
		}
		
		public function set scriptArray(value:LScriptArray):void
		{
			_scriptArray = value;
		}
		public function get dataList():Array
		{
			return _dataList;
		}
		
		public function set dataList(value:Array):void
		{
			_dataList = value;
		}
		
		public function get lineList():Array
		{
			return _lineList;
		}
		
		public function set lineList(value:Array):void
		{
			_lineList = value;
		}
		public function childAnalysis(childType:String,lineValue:String):void{
			
		}
		/**
		 * L#脚本文法<br />
		 * 一、变量操作<br />
		 * 	1,变量赋值<br />
		 * 	Var.set(name,value);<br />
		 * 	参数：变量名，值(例：100,"abc")<br />
		 * 	2,变量使用<br />
		 * 	＠+变量名(例：＠width)<br />
		 * 二、条件语句if<br />
		 * if语句以if开头，以endif结束，每一个分句用";"结束<br />
		 * 例：<br />
		 * if(＠test==0);<br />
		 * 	Var.set(backWidth,100);<br />
		 * elseif(＠test==1);<br />
		 * 	Var.set(backWidth,400);<br />
		 * else;<br />
		 * 	Var.set(backWidth,700);<br />
		 * endif;<br />
		 * 说明：如果变量test等于0，则变量backWidth等于100，如果变量test等于1，则变量backWidth等于400，否则变量backWidth等于700<br />
		 * 三、goto语句<br />
		 * 1,定义Mark.married;(married是任意自定义名称)<br />
		 * 2,Mark.goto(married);可以跳转到定义的位置<br />
		 * 	参数：自定义名称的位置<br />
		 * 四、Load:文件Load类，用来读取文件和图片<br />
		 *  1,Load.script(path);<br />
		 * 	载入脚本文件<br />
		 * 	参数：脚本文件路径，例：data/script/Main.lf<br />
		 * 	2,Load.img(name,path);<br />
		 * 	载入图片<br />
		 * 	参数：载入图片文件后的数据名,图片路径<br />
		 * 五、Layer:操作层<br />
		 * 	1,Layer.add(-,name,0,0);<br />
		 * 	添加层<br />
		 * 	参数：层名(如果是-，则添加到基层上)，添加层名，添加层坐标<br />
		 * 	2,Layer.remove(name);<br />
		 * 	移除层<br />
		 * 	参数：移除层名<br />
		 *  3,Layer.clear(name);<br />
		 * 	移除该层上的所有子元件<br />
		 * 	参数：移除层名<br />
		 *  4,Layer.clear(name);<br />
		 * 	移除该层上的所有子元件<br />
		 * 	参数：移除层名<br />
		 *  5,改变透明度<br />
		 *  Layer.transition(name,fadeIn,0.1);<br />
		 * 	参数：层名,类型,速度<br />
		 *  Layer.transition(name,fadeOut,0.1);<br />
		 * 	参数：层名,类型,速度<br />
		 *  Layer.transition(name,fadeTo,0.1,0.5);<br />
		 * 	参数：层名,类型,目标透明度,速度<br />
		 */
		private function comment():void{};
	}
}