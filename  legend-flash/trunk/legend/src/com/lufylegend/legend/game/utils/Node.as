package zhanglubin.legend.game.utils
{
	public class Node
	{
		public var x:int;
		public var y:int;
		public var value:int;
		public var isChecked:Boolean;
		public var value_g:int;
		public var value_h:int;
		public var value_f:int;
		public var nodeparent:Node;
		public var index:int;
		public var charaIndex:int;
		public var moveLong:int;
		public var isRoad:Boolean;
		public var open:Boolean;
		public function Node(_x:int,_y:int,_value:int=0)
		{
			this.x = _x;
			this.y = _y;
			this.value = _value;
		}
		public function toString():String{
			return "["+this.x+","+this.y+"]";
		}
	}
}