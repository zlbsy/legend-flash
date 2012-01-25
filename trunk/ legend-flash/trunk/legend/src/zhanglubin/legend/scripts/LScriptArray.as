package zhanglubin.legend.scripts
{
	import zhanglubin.legend.display.LSprite;

	internal class LScriptArray
	{
		private var _imgList:Array;
		private var _btnList:Array;
		private var _bitmapdataList:Array;
		private var _swfList:Array;
		private var _funList:Array;
		private var _layerList:Array;
		private var _textList:Array;
		private var _varList:Array;
		private var _radioList:Array;
		public function LScriptArray()
		{
			_imgList = new Array();
			_btnList = new Array();
			_textList = new Array();
			_varList = new Array();
			_funList = new Array();
			_bitmapdataList = new Array();
			_swfList = new Array();
			_layerList = new Array();
			_radioList = new Array();
		}

		public function get radioList():Array
		{
			return _radioList;
		}

		public function set radioList(value:Array):void
		{
			_radioList = value;
		}

		public function get swfList():Array
		{
			return _swfList;
		}

		public function set swfList(value:Array):void
		{
			_swfList = value;
		}

		public function get funList():Array
		{
			return _funList;
		}

		public function set funList(value:Array):void
		{
			_funList = value;
		}

		public function get btnList():Array
		{
			return _btnList;
		}

		public function set btnList(value:Array):void
		{
			_btnList = value;
		}

		public function get varList():Array
		{
			return _varList;
		}

		public function set varList(value:Array):void
		{
			_varList = value;
		}

		public function get textList():Array
		{
			return _textList;
		}

		public function set textList(value:Array):void
		{
			_textList = value;
		}

		public function get layerList():Array
		{
			return _layerList;
		}

		public function set layerList(value:Array):void
		{
			_layerList = value;
		}

		public function get bitmapdataList():Array
		{
			return _bitmapdataList;
		}

		public function set bitmapdataList(value:Array):void
		{
			_bitmapdataList = value;
		}

		public function get imgList():Array
		{
			return _imgList;
		}

		public function set imgList(value:Array):void
		{
			_imgList = value;
		}

	}
}