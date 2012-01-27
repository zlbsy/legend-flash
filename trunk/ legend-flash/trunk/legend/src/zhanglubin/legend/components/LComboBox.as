package zhanglubin.legend.components
{
	import flash.display.BitmapData;
	
	import zhanglubin.legend.display.LButton;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.utils.LDisplay;
	
	public class LComboBox extends LSprite
	{
		private var _childList:Array;
		private var _back:BitmapData;
		private var _childBack:BitmapData;
		private var _button:LSprite;
		public function LComboBox(back:BitmapData = null,childBack:BitmapData = null,buttonBitmapdata:BitmapData = null)
		{
			super();
			_back = back;
			_childBack = childBack;
			_childList = new Array();
			var buttonX:int = 0;
			var buttonSprite:LSprite = new LSprite();
			var bitdata:BitmapData;
			if(back == null){
				buttonSprite.die();
				//LDisplay.drawRect(this.graphics,[0,0,150,20],true,0xcccccc);
				LDisplay.drawRect(this.graphics,[0,0,150,20],false,0x999999,1,1);
				buttonX = 150;
			}
			_button = new LSprite();
			if(buttonBitmapdata == null){
				buttonSprite.die();
				LDisplay.drawTriangle(buttonSprite.graphics,[buttonX+3,5,buttonX+17,5,buttonX+10,15],true);
				LDisplay.drawRect(buttonSprite.graphics,[buttonX,0,20,20],false,0x999999,1,1);
				_button.addChild(buttonSprite);
			}
			addChild(_button);
		}
		public function push(value:Object):void{
			_childList.push(value);
			//this.addChild(value);
		}
	}
}