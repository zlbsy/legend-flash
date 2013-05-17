package com.lufylegend.legend.utils.math
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;

	public class LMath
	{
		public function LMath()
		{
		}
		/**
		 * 自定义注册点旋转
         * 
         * @param displayObj    显示对象
         * @param angle 旋转角度（0 - 360）
         * @param point 新的注册点（相对于原注册点的坐标）
		 */
		public static function rotateAt(displayObj:DisplayObject,angle:Number,point:Point=null):void   
		{   
			if (!point)point = new Point();
			if(displayObj is Bitmap)(displayObj as Bitmap).smoothing = true;
			var m:Matrix = new Matrix();
			m.translate(-point.x, -point.y); 	
			m.rotate(angle / 180 * Math.PI);
			m.translate(point.x, point.y);  
			displayObj.transform.matrix = m;
		}
		
		/**
		 * 随机排序
		 * 
		 * @param arr   数组
		 * 
		 */             
		public static function randomArray(arr:Array):void
		{
			arr.sort(randomFunction);
		}
		
		private static function randomFunction(n1:*,n2:*):int
		{
			return (Math.random() < 0.5)? -1 : 1;
		}
	}
}