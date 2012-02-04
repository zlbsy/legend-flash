package zhanglubin.legend.utils
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class LDisplay
	{
		public function LDisplay()
		{
		}
		public static function displayToBitmap(_target:DisplayObject,rect:Rectangle=null):BitmapData
		{
			if(rect==null)rect = _target.getBounds(_target);
			var bound:Rectangle = _target.getBounds(_target);
			// stageと同サイズのBitmapDataを生成
			var bitmapdata:BitmapData = new BitmapData(bound.width, bound.height, false, 0x00ffffff);
			// BitmapDataに_targetをビットマップ化します
			bitmapdata.draw(_target);
			var retrunvalue:BitmapData = new BitmapData(rect.width, rect.height, true, 0x00ffffff);
			retrunvalue.copyPixels(bitmapdata,rect,new Point(0,0));
			return retrunvalue;
		}
		/**
		 * 画三角形
		 * @param 
		 */
		public static function drawTriangle(_target:Graphics,pointArray:Array,fill:Boolean=false,color:uint = 0x000000,alpha:Number = 1,thickness:Number = 1):void{
			if(fill){
				_target.beginFill(color,alpha);
			}else{
				_target.lineStyle(thickness,color,alpha);
			}
			_target.drawTriangles(Vector.<Number>(pointArray));
			if(fill){
				_target.endFill();
			}
		}
		/**
		 * 画菱形
		 * @param pointArray（左顶点，上顶点，右顶点，下顶点）
		 */
		public static function drawDiamond(_target:Graphics,pointArray:Array,fill:Boolean=false,color:uint = 0x000000,alpha:Number = 1,thickness:Number = 1):void{
			if(fill){
				_target.beginFill(color,alpha);
			}else{
				_target.lineStyle(thickness,color,alpha);
			}
			_target.drawTriangles(Vector.<Number>(pointArray), 
				Vector.<int>([0,1,2,0,2,3]));
			if(fill){
				_target.endFill();
			}
		}
		public static function drawRect(_target:Graphics,pointArray:Array,fill:Boolean=false,color:uint = 0x000000,alpha:Number = 1,thickness:Number = 1):void{
			if(fill){
				_target.beginFill(color,alpha);
			}else{
				_target.lineStyle(thickness,color,alpha);
			}
			_target.drawRect(pointArray[0],pointArray[1],pointArray[2],pointArray[3]);
			if(fill){
				_target.endFill();
			}
		}
		public static function drawRoundRect(_target:Graphics,pointArray:Array,fill:Boolean=false,color:uint = 0x000000,alpha:Number = 1,thickness:Number = 1):void{
			if(fill){
				_target.beginFill(color,alpha);
			}else{
				_target.lineStyle(thickness,color,alpha);
			}
			_target.drawRoundRect(pointArray[0],pointArray[1],pointArray[2],pointArray[3],pointArray[4],pointArray[5]);
			if(fill){
				_target.endFill();
			}
		}
		public static function drawRectGradient(_target:Graphics,pointArray:Array,colors : Array,alphas : Array = null,ratios : Array = null):void{
			if(alphas == null)alphas = [1,1];
			if(ratios == null)ratios = [0,255];
			var matrix : Matrix = new Matrix();
			matrix.createGradientBox(pointArray[2],pointArray[3], Math.PI / 2, 0, 0);
			_target.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix);
			_target.drawRect(pointArray[0],pointArray[1],pointArray[2],pointArray[3]);
			_target.endFill();
		}
		/**
		 * 画线
		 * @param _target
		 * @param pointArray [startx,starty,endx,endy]
		 * @param thickness
		 * @param color
		 * @param alpha
		 */
		public static function drawLine(_target:Graphics,pointArray:Array,thickness:Number = 1,color:uint = 0x000000,alpha:Number = 1):void{
			_target.lineStyle(thickness,color,alpha);
			_target.moveTo(pointArray[0],pointArray[1]);
			_target.lineTo(pointArray[2],pointArray[3]);
		}
		/**
		 * 水平翻转
		 * @param 要翻转得元件
		 */
		public static function horizontal(displayObj:DisplayObject):void
		{
			var m:Matrix = displayObj.transform.matrix.clone();
			m.a = -1;
			displayObj.transform.matrix = m;
		}
		
		/**
		 * 垂直翻转
		 * @param 要翻转得元件
		 */             
		public static function vertical(displayObj:DisplayObject):void
		{
			var m:Matrix = displayObj.transform.matrix.clone();
			m.d = -1;
			displayObj.transform.matrix = m;
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
		public static function horizontalBitmapData(source:BitmapData):BitmapData{
			
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
		public static function verticalBitmapData(source:BitmapData):BitmapData
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