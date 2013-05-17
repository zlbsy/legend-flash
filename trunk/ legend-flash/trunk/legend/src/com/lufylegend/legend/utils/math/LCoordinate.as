package com.lufylegend.legend.utils.math
{
	/**
	 * legend坐标类
	 * @author lufy(lufy.legend＠gmail.com)
	 */
	public class LCoordinate
	{
		private var _x:int;
		private var _y:int;
		/**
		 * legend坐标类
		 * @author lufy(lufy.legend＠gmail.com)
		 */
		public function LCoordinate(x:int,y:int)
		{
			this._x = x;
			this._y = y;
		}
		public function coordinate(x:int,y:int):void{
			this._x = x;
			this._y = y;
		}
		public function get x():int
		{
			return _x;
		}

		public function set x(value:int):void
		{
			_x = value;
		}

		public function get y():int
		{
			return _y;
		}

		public function set y(value:int):void
		{
			_y = value;
		}
		public function toString():String{
			return this._x + "," + this._y;
		}

	}
}