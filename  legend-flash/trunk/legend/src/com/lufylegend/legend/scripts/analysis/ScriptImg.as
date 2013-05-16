package zhanglubin.legend.scripts.analysis
{
	import flash.display.BitmapData;
	
	import zhanglubin.legend.display.LBitmap;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.scripts.LScript;
	import zhanglubin.legend.utils.LGlobal;
	import zhanglubin.legend.utils.transitions.LManager;

	public class ScriptImg
	{
		
		public function ScriptImg()
		{
		}
		/**
		 * 脚本解析
		 * 添加图片
		 * @param 脚本信息
		 */
		public static function analysis(value:String):void{
			
			var start:int = value.indexOf("(");
			var end:int = value.indexOf(")");
			switch(value.substr(0,start)){
				case "Img.add":
					addImg(value,start,end);
					break;
				case "Img.changeData":
					changeData(value,start,end);
					break;
				case "Img.transition":
					transition(value,start,end);
					break;
				case "Img.moveTo":
					moveTo(value,start,end);
					break;
				case "Img.remove":
					removeImg(value,start,end);
					break;
			}
			
		}
		/**
		 * 脚本解析
		 * 添加层
		 * Img.remove(chara01);
		 * @param 脚本信息
		 */
		private static function removeImg(value:String,start:int,end:int):void{
			var lArr:Array = value.substring(start+1,end).split(",");
			var nameStr:String = lArr[0];
			
			var script:LScript = LGlobal.script;
			var bitmap:LBitmap = script.scriptArray.imgList[nameStr];
			bitmap.removeFromParent();
			script.scriptArray.imgList[nameStr] = null;
			script.analysis();
		}
		/**
		 * 脚本解析
		 * 移动层
		 * Img.moveTo(chara01,300,50,0.1);
		 * @param 脚本信息
		 */
		private static function moveTo(value:String,start:int,end:int):void{
			var lArr:Array = value.substring(start+1,end).split(",");
			var nameStr:String = lArr[0];
			var xInt:Number = Number(lArr[1]);
			var yInt:Number = Number(lArr[2]);
			var speedNum:Number = Number(lArr[3]);

			var script:LScript = LGlobal.script;
			var bitmap:LBitmap = script.scriptArray.imgList[nameStr] as LBitmap;
			LManager.moveTo(bitmap,xInt,yInt,speedNum,function():void{
				LGlobal.script.analysis();
			});
		}
		/**
		 * 脚本解析
		 * 添加层
		 * Img.transition(backimg,fadeIn,0.1);
		 * Img.transition(backimg,fadeOut,0.1);
		 * Img.transition(backimg,fadeTo,0.1,0.5);
		 * @param 脚本信息
		 */
		private static function transition(value:String,start:int,end:int):void{
			var lArr:Array = value.substring(start+1,end).split(",");
			var nameStr:String = lArr[0];
			var modeStr:String = lArr[1];
			var speedNum:Number = Number(lArr[2]);
			var gotoNum:Number;
			if(lArr.length > 3){
				gotoNum = Number(lArr[3]);
			}
			
			var fun:Function;
			var script:LScript = LGlobal.script;
			var bitmap:LBitmap = script.scriptArray.imgList[nameStr] as LBitmap;
			if(modeStr == "fadeIn"){
				fun = function():void{
					script.analysis();
				}
				LManager.fadeIn(bitmap,speedNum,fun);
			}else if(modeStr == "fadeOut"){
				fun = function():void{
					script.analysis();
				}
				LManager.fadeOut(bitmap,speedNum,fun);
			}else if(modeStr == "fadeTo"){
				fun = function():void{
					script.analysis();
				}
				LManager.fadeTo(bitmap,gotoNum,speedNum,fun);
			}
		}
		/**
		 * 脚本解析
		 * 添加层
		 * Img.add(back,backimg,backdata,0,0,700,500,0.5);
		 * @param 脚本信息
		 */
		private static function addImg(value:String,start:int,end:int):void{
			var script:LScript = LGlobal.script;
			var layer:LSprite;
			var i:uint;
			
			var lArr:Array = value.substring(start+1,end).split(",");
			var layerStr:String = lArr[0];
			var nameStr:String = lArr[1];
			var dataStr:String = lArr[2];
			var bitdata:BitmapData;
			
			if(lArr.length > 8){
				bitdata = LGlobal.getBitmapData(script.scriptArray.swfList[lArr[8]],dataStr);
			}else{
				bitdata = script.scriptArray.bitmapdataList[dataStr];
			}
			var xInt:Number = Number(lArr[3]);
			var yInt:Number = Number(lArr[4]);
			var wNum:Number;
			var hNum:Number;
			if(lArr.length > 5){
				wNum = Number(lArr[5]);
			}
			if(lArr.length > 6){
				hNum = Number(lArr[6]);
			}
			var alphaNum:Number = 1;
			if(lArr.length > 7){
				alphaNum = Number(lArr[7]);
			}
			
			layer = script.scriptArray.layerList[layerStr];
			var bitmap:LBitmap = new LBitmap(bitdata);
			bitmap.width = wNum;
			bitmap.height = hNum;
			bitmap.alpha = alphaNum;
			bitmap.x = xInt;
			bitmap.y = yInt;
			bitmap.name = nameStr;
			script.scriptArray.imgList[nameStr] = bitmap;
			layer.addChild(bitmap);
			script.analysis();
		}
		/**
		 * 脚本解析
		 * 添加层
		 * Img.changeData(backimg,backdata);
		 * @param 脚本信息
		 */
		private static function changeData(value:String,start:int,end:int):void{
			var script:LScript = LGlobal.script;
			var lArr:Array = value.substring(start+1,end).split(",");
			var nameStr:String = lArr[0];
			var dataStr:String = lArr[1];
			var bitdata:BitmapData;
			if(lArr.length > 4){
				bitdata = LGlobal.getBitmapData(script.scriptArray.swfList[lArr[4]],dataStr);
			}else{
				bitdata = script.scriptArray.bitmapdataList[dataStr];
			}
			var wNum:Number;
			var hNum:Number;
			if(lArr.length > 2){
				wNum = Number(lArr[2]);
			}
			if(lArr.length > 3){
				hNum = Number(lArr[3]);
			}
			var bitmap:LBitmap = (script.scriptArray.imgList[nameStr] as LBitmap);
			bitmap.bitmapData = bitdata;
			bitmap.width = wNum;
			bitmap.height = hNum;
			script.analysis();
		}

	}
}