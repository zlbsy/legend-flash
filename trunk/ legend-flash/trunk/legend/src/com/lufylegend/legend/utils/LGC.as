package zhanglubin.legend.utils
{
	import flash.net.LocalConnection;
	
	/**
	 * legend 强制垃圾回收
	 * 
	 * @author lufy(lufy.legend＠gmail.com)
	 */
	public class LGC
	{
		/**
		 * legend 强制垃圾回收 非万不得已不推荐调用
		 */
		public static function gc() : void {
			try {
				new LocalConnection().connect('foo');
				new LocalConnection().connect('foo');
			} catch (e : Error) {
				
			}
		}
	}
}