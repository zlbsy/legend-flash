package zhanglubin.legend.utils
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.media.Sound;
	import flash.net.SharedObject;
	import flash.utils.getDefinitionByName;
	
	import zhanglubin.legend.components.LLabel;
	import zhanglubin.legend.display.LBitmap;
	import zhanglubin.legend.display.LButton;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.net.LNet;
	import zhanglubin.legend.scripts.LScript;
 
	/**
	 * legend Object操作类
	 * 
	 * @author lufy(lufy.legend＠gmail.com)
	 */
	public class LGlobal
	{
		/**
		 * legend Object操作类
		 * 
		 * @author lufy(lufy.legend＠gmail.com)
		 */
		public function LGlobal()
		{
		}
		public static var stage:Stage;
		public static var script:LScript;
		public static var isreading:String="";
		/**
		 * 是否释放bitmapdata
		 * */
		public static var bitmapDataDispose:Boolean;
		private static var _url:LNet;
		public static function get url():LNet{
			if(LGlobal._url == null){
				LGlobal._url = new LNet();
			}
			return LGlobal._url;
		}
		/**
		 * legend 得到.swf文件中的图片数据
		 * 使用此方法时，swf文件发布的时候，必须在第一贞添加
		 * function getClassByName(value:String):Class{
		 * 		var _class:Class =  getDefinitionByName(value) as Class;
		 *		return _class;
		 * }
		 * @param .swf文件
		 * @param 名称
		 * @return BitmapData图片数据
		 */
		public static function getBitmapData(obj:Object,classname:String):BitmapData{
			var ClassReference:Class;
			try{
				ClassReference = obj.getClassByName(classname) as Class;
			}catch(e:Error){
				return null;
			}
			return new ClassReference(0,0) as BitmapData;
		}
		public static function getClass(obj:Object,classname:String):Sound{
			var ClassReference:Class;
			try{
				ClassReference = obj.getClassByName(classname) as Class;
				var lsound:Sound = new ClassReference();
			}catch(e:Error){
				return null;
			}
			return lsound;
		}
		/**
		 * legend 得到.swf文件中的MovieClip
		 * 使用此方法时，swf文件发布的时候，必须在第一贞添加
		 * function getClassByName(value:String):Class{
		 * 		var _class:Class =  getDefinitionByName(value) as Class;
		 *		return _class;
		 * }
		 * @param .swf文件
		 * @param 名称
		 * @return MovieClip图片数据
		 */
		public static function getMovieClip(obj:Object,classname:String):MovieClip{
			var ClassReference:Class;
			try{
				ClassReference = obj.getClassByName(classname) as Class;
			}catch(e:Error){
				return null;
			}
			return new ClassReference as MovieClip;
		}
		/**
		 *从字符串中获取数组
		 * afjidfja[a,b,c],[g,e,c,g]afda[4,5]jfa
		 * */
		public static function getArray(value:String):Array{
			var returnValue:Array = [];
			var str:String;
			var arrindex:int,overindex:int;
			while((arrindex = value.indexOf("[")) >= 0){
				overindex = value.indexOf("]");
				if(overindex <= 0)break;
				str = value.substring(arrindex + 1, overindex);
				returnValue.push(str.split(","));
				value = value.substring(overindex+1);
			}
			return returnValue;
		}
		
		public static function getColorText(color:BitmapData,txtvalue:String,size:int,filterColor:int = 0x00ff00):LSprite{
			var sp:LSprite = new LSprite;
			var bit:LBitmap = new LBitmap(color);
			bit.cacheAsBitmap = true;
			sp.addChild(bit);
			var txt:LLabel = new LLabel();
			txt.htmlText = '<font size="'+size+'"><b>' + txtvalue + '</b></font>';
			bit.width = txt.width;
			bit.height = txt.height;
			txt.cacheAsBitmap = true;
			sp.addChild(txt);
			bit.mask = txt;
			sp.filters = [new GlowFilter(filterColor,1,2,2)];
			return sp;
		}
		/**
		 * 按钮demo
		 * @param type 按钮类型
		 * @param typeArray type0[x,y,w,h,text,size,color]
		 * @param typeArray type1[x,y,w,h,text,size,color]
		 **/
		public static function getModelButton(type:int,typeArray:Array):LButton{
			
			var color:int = 0xF700FF;
			var upBtnSprite:LSprite = new LSprite();
			var onBtnSprite:LSprite = new LSprite();
			var downBtnSprite:LSprite = new LSprite();
			var upBitmapdata:BitmapData,onBitmapdata:BitmapData,downBitmapdata:BitmapData;
			var btnApp:LButton;
			if(type == 0){
				//typeArray [x,y,w,h,text,size,color]
				if(typeArray.length >= 7)color = typeArray[6];
				LDisplay.drawRectGradient(upBtnSprite.graphics,[typeArray[0] + 1,typeArray[1] + 1,typeArray[2] - 2,typeArray[3] - 2],[0xcccccc,color]);
				LDisplay.drawRect(upBtnSprite.graphics,[typeArray[0],typeArray[1],typeArray[2],typeArray[3]],false,0,1,2);
				upBitmapdata = LDisplay.displayToBitmap(upBtnSprite);
				
				LDisplay.drawRectGradient(onBtnSprite.graphics,[typeArray[0] + 1,typeArray[1] + 1,typeArray[2] - 2,typeArray[3] - 2],[0xffffff,color]);
				LDisplay.drawRect(onBtnSprite.graphics,[typeArray[0],typeArray[1],typeArray[2],typeArray[3]],false,0,1,2);
				onBitmapdata = LDisplay.displayToBitmap(onBtnSprite);
				
				LDisplay.drawRectGradient(downBtnSprite.graphics,[typeArray[0] + 3,typeArray[1] + 3,typeArray[2] - 2,typeArray[3] - 2],[0xffffff,color]);
				LDisplay.drawRect(downBtnSprite.graphics,[typeArray[0] + 2,typeArray[1] + 2,typeArray[2],typeArray[3]],false,0,1,2);
				downBitmapdata = LDisplay.displayToBitmap(downBtnSprite);
				
				btnApp = new LButton(upBitmapdata,onBitmapdata,downBitmapdata);
				btnApp.filters = LFilter.SHADOW;
				btnApp.labelSize = typeArray[5];
				btnApp.label = typeArray[4];
			}else if(type == 1){
				//typeArray [x,y,w,h,text,size,color]
				if(typeArray.length >= 7)color = typeArray[6];
				LDisplay.drawRect(upBtnSprite.graphics,[typeArray[0],typeArray[1],typeArray[2],typeArray[3]],true,color);
				LDisplay.drawTriangle(upBtnSprite.graphics,[typeArray[0] + typeArray[2],typeArray[1],typeArray[0] + typeArray[2],typeArray[1] + typeArray[3],typeArray[0] + typeArray[2] + typeArray[3]/2,typeArray[1] + typeArray[3]],true,color);
				LDisplay.drawLine(upBtnSprite.graphics,[typeArray[0],typeArray[1],typeArray[0]+typeArray[2],typeArray[1]],1,0x333333);
				LDisplay.drawLine(upBtnSprite.graphics,[typeArray[0],typeArray[1],typeArray[0],typeArray[1]+typeArray[3]],1,0x333333);
				LDisplay.drawLine(upBtnSprite.graphics,[typeArray[0]+typeArray[2]+typeArray[3]/2 ,typeArray[1]+typeArray[3],typeArray[0]+typeArray[2],typeArray[1]],1,0x333333);
				LDisplay.drawLine(upBtnSprite.graphics,[typeArray[0]+typeArray[2]+typeArray[3]/2,typeArray[1]+typeArray[3],typeArray[0],typeArray[1]+typeArray[3]],1,0x333333);
				upBitmapdata = LDisplay.displayToBitmap(upBtnSprite);
				
				
				btnApp = new LButton(upBitmapdata,upBitmapdata,upBitmapdata);
				btnApp.labelSize = typeArray[5];
				btnApp.label = typeArray[4];
			}
			return btnApp;
		}
	}
}