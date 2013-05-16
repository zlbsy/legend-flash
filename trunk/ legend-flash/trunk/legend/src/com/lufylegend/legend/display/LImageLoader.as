package zhanglubin.legend.display
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import zhanglubin.legend.events.LEvent;
	
	/**
	 * legend的图片加载类继承自BaseLoader
	 * @author lufy(lufy.legend＠gmail.com)
	 */
	public class LImageLoader extends LLoader
	{
		public static const TYPE_LLOADER_IMAGE:String = "LLoader_Image";
		public static const TYPE_LLOADER_BYTES:String = "LLoader_Bytes";
		public static const TYPE_LLOADER_IMAGE_ARRAY:String = "LLoader_Image_Array";
		/**
		 * legend的图片加载类的图片数据
		 */
		private var _data:BitmapData;
		private var _dateArray:Array;
		private var _loadIndex:int;
		private var _loadArray:Array;
		private var _context:LoaderContext;
		/**
		 * legend的图片加载类继承自BaseLoader
		 * @param obj 要加载的对象(ByteArray、String或数组)
		 * @param context LoaderContext
		 * @author lufy(lufy.legend＠gmail.com)
		 */
		public function LImageLoader(obj:Object,context:LoaderContext=null)
		{
			if(obj != null){
				if(obj is ByteArray){
					this._type = LImageLoader.TYPE_LLOADER_BYTES;
					this.loadBytes(obj as ByteArray,context);
				}else if(obj is String){
					this._type = LImageLoader.TYPE_LLOADER_IMAGE;
					this.load(obj as String,context);
				}else if(obj is Array){
					this._type = LImageLoader.TYPE_LLOADER_IMAGE_ARRAY;
					this._loadIndex = 0;
					this._context = context;
					this._loadArray = obj as Array;
					this.loadArrayStart();
				}else {
					throw new Error("参数错误");
				}
			}
		}
		/**
		 * 图片数组加载
		 */
		private function loadArrayStart():void{
			this.load(this._loadArray[this._loadIndex++],this._context);
		}
		/**
		 * 读取bitmapData
		 */
		public function get data():BitmapData{
			return this._data;
		}
		/**
		 * 读取bitmapData数组
		 */
		public function get dateArray():Array{
			return this._dateArray;
		}
		/**
		 * 读取bitmapData数组index
		 */
		public function get loadIndex():int{
			return this._loadIndex;
		}
		override protected function complete(event:Event):void{
			if(this._type == LImageLoader.TYPE_LLOADER_IMAGE_ARRAY){
				if(this._dateArray == null){
					this._dateArray = new Array();
				}
				this._dateArray.push(this._loader.content["bitmapData"]);
				if(this._loadIndex < this._loadArray.length){
					this.dispatchEvent(new LEvent(LEvent.ONE_COMPLETE));
					this.reset();
					loadArrayStart();
					return;
				}
			}else{
				this._data = this._loader.content["bitmapData"];
			}
			super.complete(event);
			super.die();
		}
		override public function die():void{
			this._data = null;
			if(this._dateArray != null){
				this._dateArray.splice(0,this._dateArray.length);
				this._dateArray = null;
			}
			super.die();
		}
	}
}