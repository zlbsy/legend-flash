package zhanglubin.legend.components
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	import zhanglubin.legend.display.LBitmap;
	import zhanglubin.legend.display.LButton;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.events.LEvent;

	public class LRadioChild extends LSprite
	{
		private var _value:Object;
		private var _bitmap:LBitmap;
		private var _button:LButton;
		private var _checked:Boolean;
		public function LRadioChild(value:Object,bitmap:LBitmap,button:LButton)
		{
			super();
			_value = value;
			_bitmap = bitmap;
			_button = button;
			this.addChild(_bitmap);
			this.addChild(_button);
			_bitmap.visible = false;
			_button.visible = true;
			_checked = false;
			this.addEventListener(MouseEvent.MOUSE_UP,onclick);
		}
		private function onclick(event:MouseEvent):void{
			if(this.checked)return;
			(this.parent as LRadio).value = this.value;
		}
		public function set checked(val:Boolean):void{
			_checked = val;
			if(_checked){
				_bitmap.visible = true;
				_button.visible = false;
				
				(this.parent as LRadio).dispatchEvent(new LEvent(LEvent.CHANGE_VALUE));
			}else{
				_bitmap.visible = false;
				_button.visible = true;
			}
		}
		public function get checked():Boolean{
			return _checked;
		}
		public function get value():Object{
			return _value;
		}
	}
}