package zhanglubin.legend.components
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	import zhanglubin.legend.display.LBitmap;
	import zhanglubin.legend.display.LButton;
	import zhanglubin.legend.display.LSprite;

	public class LRadio extends LSprite
	{
		private var _childRadio:Vector.<LRadioChild> = new Vector.<LRadioChild>(); 
		
		public function LRadio()
		{
			super();
		}
		public function setChildRadio(value:Object,rx:int,ry:int,bitmap:LBitmap = null,button:LButton = null):void{
			if(bitmap == null)bitmap = new LBitmap(new BitmapData(20,20,false,0x999999));
			if(button == null)button = new LButton(new BitmapData(20,20,false,0xcccccc),new BitmapData(20,20,false,0x333333),new BitmapData(20,20,false,0x999999));
			var child:LRadioChild = new LRadioChild(value,bitmap,button);
			child.x = rx;
			child.y = ry;
			_childRadio.push(child);
			this.addChild(child);
		}
		public function push(value:LRadioChild):void{
			_childRadio.push(value);
			this.addChild(value);
		}
		public function get value():Object{
			var child:LRadioChild;
			for each(child in _childRadio){
				if(child.checked)return child.value;
			}
			return null;
		}
		public function set value(val:Object):void{
			var child:LRadioChild;
			for each(child in _childRadio){
				child.checked = false;
				if(child.value == val)child.checked = true;
			}
		}
	}
	
}