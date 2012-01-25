package zhanglubin.legend.utils
{
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.ConvolutionFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	
	/**
	 * legend滤镜类
	 * 
	 * @author lufy(lufy.legend＠gmail.com)
	 */
	public class LFilter
	{
		/**
		 *原色
		 */
		public static const INIT:Array = [new ColorMatrixFilter()];
		/**
		 *光晕
		 */
		public static const SUN:Array = [new GlowFilter()];
		/**
		 *阴影
		 */
		public static const SHADOW:Array = [new DropShadowFilter(4,60,0x000000,0.4)];
		/**
		 *灰色
		 */
		public static const GRAY:Array = [new ColorMatrixFilter([0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0,0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0])];
		/**
		 *浮雕
		 */
		public static const RELIEF:Array = [new ConvolutionFilter(3, 3, [-2, -1, 0, -1, 1, 1, 0, 1, 2])];
		/**
		 * legend滤镜类
		 */
		public function LFilter()
		{
		}
		/**
		 *滤镜效果
		 * 
		 * @param 操作对象
		 * @param 效果
		 */
		public static function setFilter(container:DisplayObject,filterArr:Array ):void {
			container.filters = filterArr;
		}
		/**
		 *明暗效果
		 * 
		 * @param 操作对象
		 * @param 亮度
		 */
		public static function setBrightness(container:DisplayObject,value:Number):void{
			container.filters = [new ColorMatrixFilter([value, 0, 0, 0, 0, 0, value, 0, 0, 0, 0, 0, value, 0, 0, 0, 0, 0, 1, 0])];
		}
	}
}