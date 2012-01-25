package zhanglubin.legend.events
{
	import flash.events.Event;

	public class LEvent extends Event
	{
		/**
		 * LRadio変更
		 */
		public static const RADIO_VALUE_CHANGE:String = "radio_value_change";
		/**
		 * LAnimation显示完一行图片后所触发的事件
		 */
		public static const ANIMATION_COMPLETE:String = "animationComplete";
		/**
		 * LTextField逐字显示时，最后所触发的事件
		 */
		public static const LTEXT_MAX:String = "ltextMax";
		/**
		 * LImageLoader读取多张图片时每读完一张图片所触发的事件
		 */
		public static const ONE_COMPLETE:String = "one_complete";
		/**
		 * 人物移动完成所触发的事件
		 */
		public static const CHARACTER_MOVE_COMPLETE:String = "character_move_complete";
		/**
		 * legend专用事件类
	 	 * @author lufy(lufy.legend＠gmail.com)
		 */
		public function LEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}