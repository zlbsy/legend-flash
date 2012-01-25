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
	import zhanglubin.legend.display.LSprite;
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
	}
}