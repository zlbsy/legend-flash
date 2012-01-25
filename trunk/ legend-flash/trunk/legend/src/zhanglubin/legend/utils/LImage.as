package zhanglubin.legend.utils
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * legend图片操作类
	 * 
	 * @author lufy(lufy.legend＠gmail.com)
	 */
	public class LImage
	{
		/**
		 * legend图片操作类
		 */
		public function LImage()
		{
		}
		
		/**
		 *用draw分割图片
		 * 
		 * @param __bitmapdata 分割对象
		 * @param row 行数
		 * @param col 列数
		 * @param matrix 效果
		 * @param total 总数
		 * @param smooting 锯齿
		 * @return 分割后数组
		 */
		public static function divideByDraw(__bitmapdata:BitmapData,row:int,col:int,matrix:Matrix=null,total:* = null,smooting:Boolean = false):Array{
			var result:Array = new Array();
			var w:int = __bitmapdata.width/col;
			var h:int = __bitmapdata.height/row;
			total=total==null?col*row:total;
			if(matrix == null){
				matrix = new Matrix();
			}
			var rect:Rectangle=new Rectangle(0,0,w,h);
			for (var i:int = 0; i < row; i++) {
				var tempArr:Array = new Array();
				for (var j:int = 0; j < col; j++) {
					if (total<=0) {
						break;
					}
					//新建小位图对象
					var bmp:BitmapData=new BitmapData(w,h,true,0x000000);
					bmp.lock();
					//定义矩阵的焦点
					matrix.tx = -j*w;
					matrix.ty = -i*h;
					//将矩阵内的数据按定义好的矩形大小和相应位置,画出小位图对象像素
					bmp.draw(__bitmapdata,matrix,null,null,rect,smooting);
					bmp.unlock();
					tempArr.push(bmp);
					total--;
				}
				result.push(tempArr);
			}
			return result;
		}
		/**
		 *用copyPixel分割图片
		 * 
		 * @param __bitmapdata 分割对象
		 * @param row 行数
		 * @param col 列数
		 * @param total 总数
		 * @return 分割后数组
		 */
		public static function divideByCopyPixels(__bitmapdata:BitmapData,row:int,col:int,total:* = null):Array{
			var result:Array = new Array();
			var w:int = __bitmapdata.width/col;
			var h:int = __bitmapdata.height/row;
			total=total==null?col*row:total;
			var rect:Rectangle;
			for (var i:int = 0; i < row; i++) {
				var tempArr:Array = new Array();
				for (var j:int = 0; j < col; j++) {
					if (total<=0) {
						break;
					}
					rect=new Rectangle(j*w,i*h,w,h);
					//新建小位图对象
					var bmp:BitmapData=new BitmapData(w,h,true,0x000000);
					bmp.lock();
					//将矩阵内的数据按定义好的矩形大小和相应位置,画出小位图对象像素
					bmp.copyPixels(__bitmapdata, rect, new Point(0,0));
					bmp.unlock();
					tempArr.push(bmp);
					total--;
				}
				result.push(tempArr);
			}
			return result;
		}

		/**
		 *截取bitmapData
		 * 
		 * @param source 原bitmapData
		 * @param startX 截取开始x坐标
		 * @param startY 截取开始y坐标
		 * @param imageWidth 截取宽度
		 * @param imageHeight 截取长度
		 * @param smooting 锯齿
		 * @return 截取完的bitmapData
		 */
		public static function getBitmapDataByDraw(source:BitmapData,startX:Number,startY:Number,imageWidth:Number,imageHeight:Number,smooting:Boolean = false):BitmapData{
			var matrix:Matrix = new Matrix();
			var rect:Rectangle=new Rectangle(0,0,imageWidth,imageHeight);
			var bmp:BitmapData=new BitmapData(imageWidth,imageHeight,true,0x00000000);
			matrix.tx = -startX;
			matrix.ty = -startY;
			bmp.draw(source,matrix,null,null,rect,smooting);
			return bmp;
		}
		/**
		 *bitmapData水平翻转
		 * 
		 * @param source 原bitmapData
		 * @return 水平翻转后的bitmapData
		 */
		public static function horizontal(source:BitmapData):BitmapData{
			 
			var bmp:BitmapData = new BitmapData(source.width,source.height,true,0x000000);
			var matrix:Matrix = new Matrix();
			matrix.a = -1;
			matrix.tx = source.width;
			var rect:Rectangle=new Rectangle(0,0,source.width,source.height);
			bmp.draw(source,matrix,null,null,rect);
			return bmp;
		}
		
		/**
		 *bitmapData垂直翻转
		 * 
		 * @param source 原bitmapData
		 * @return 垂直翻转后的bitmapData
		 */
		public static function vertical(source:BitmapData):BitmapData
		{
			var bmp:BitmapData = new BitmapData(source.width,source.height,true,0x000000);
			var matrix:Matrix = new Matrix();
			matrix.d = -1;
			matrix.ty = source.height;
			var rect:Rectangle=new Rectangle(0,0,source.width,source.height);
			bmp.draw(source,matrix,null,null,rect);
			return bmp;
		}
	}
}