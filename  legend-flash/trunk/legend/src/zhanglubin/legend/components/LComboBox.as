package zhanglubin.legend.components
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	
	import zhanglubin.legend.display.LBitmap;
	import zhanglubin.legend.display.LButton;
	import zhanglubin.legend.display.LScrollbar;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.events.LEvent;
	import zhanglubin.legend.utils.LDisplay;
	import zhanglubin.legend.utils.LFilter;
	
	public class LComboBox extends LSprite
	{
		private var _childList:Array;
		private var _childSprite:LSprite;
		private var _childSelect:LBitmap;
		private var _childScroll:LScrollbar;
		private var _back:BitmapData; 
		private var _buttonBitmapdata:BitmapData; 
		private var _backLabel:LLabel;
		private var _childBack:BitmapData;
		private var _button:LSprite;
		private var _backHeight:int;
		private var _backWidth:int;
		private var _textsize:int = 15;
		private var _selectIndex:int;
		private var _mystage:LSprite;
		public function LComboBox(back:BitmapData = null,childBack:BitmapData = null,buttonBitmapdata:BitmapData = null)
		{
			super();
			_mystage = this;
			var i:int;
			_back = back;
			_childBack = childBack;
			_buttonBitmapdata = buttonBitmapdata;
			_childList = new Array();
			_childSprite = new LSprite();
			
			var buttonSprite:LSprite = new LSprite();
			var bitdata:BitmapData;
			if(_back == null){
				_back = new BitmapData(150,20); 
				LDisplay.drawRect(this.graphics,[0,0,150,20],false,0x999999,1,1);
			}else{
				var backBit:LBitmap = new LBitmap(back);
				addChild(backBit);
			}
			
			_backLabel = new LLabel();
			addChild(_backLabel);
			
			_button = new LSprite();
			if(_buttonBitmapdata == null){
				_buttonBitmapdata = new BitmapData(20,20);
				LDisplay.drawRect(buttonSprite.graphics,[_back.width,0,_buttonBitmapdata.width,_buttonBitmapdata.height],true,0xffffff,1,1);
				LDisplay.drawTriangle(buttonSprite.graphics,[_back.width + 3,7,_back.width + 17,7,_back.width + 10,_back.height - 5],true);
				LDisplay.drawRect(buttonSprite.graphics,[_back.width,0,_buttonBitmapdata.width,_back.height],false,0x999999,1,1);
				LDisplay.drawRect(buttonSprite.graphics,[0,0,_back.width+_buttonBitmapdata.width,_back.height],true,0x000000,0);
			}else{
				var buttonBit:LBitmap = new LBitmap(_buttonBitmapdata);
				buttonBit.x = _back.width + 3;
				buttonSprite.addChild(buttonBit);
				LDisplay.drawRect(buttonSprite.graphics,[0,0,_back.width+_buttonBitmapdata.width,_back.height],true,0x000000,0);
			}
			_button.addChild(buttonSprite);
			
			
			if(_childBack == null){
				_childBack = new BitmapData(_back.width + _buttonBitmapdata.width,_back.height,false,0xffffff);
			}
			
			_button.buttonMode = true;
			addChild(_button);
			
			
			var childBitmap:LBitmap;
			for(i = 0;i < 4;i++){
				childBitmap = new LBitmap(_childBack);
				childBitmap.y = i*_back.height;
				_childSprite.addChild(childBitmap);
			}
			_childSelect = new LBitmap(new BitmapData(_back.width - 2,_back.height,false,0x999999));
			_childSelect.alpha = 0.5;
			_childSelect.x = 1;
			_childScroll = new LScrollbar(_childSprite,_back.width,_back.height*4+4,20,false);
			_childScroll.visible = false;
			addChild(_childScroll);
			_button.addEventListener(MouseEvent.MOUSE_OVER,onover);
			_button.addEventListener(MouseEvent.MOUSE_OUT,onout);
			_button.addEventListener(MouseEvent.MOUSE_DOWN,ondown);
			_button.addEventListener(MouseEvent.MOUSE_UP,onup);
		}
		/**
		 * ComboBox的文字大小
		 */
		public function set textsize(value:int):void{
			_textsize = value;
		}
		/**
		 * ComboBox的index
		 */
		public function set selectIndex(value:int):void{
			if(value >= _childList.length)return;
			_selectIndex = value;
			_backLabel.htmlText = "<font size='"+_textsize+"'>"+_childList[_selectIndex][0]+"</font>";
			toselectY();
		}
		/**
		 * ComboBox的index
		 */
		public function get selectIndex():int{
			return _selectIndex;
		}
		/**
		 * ComboBox的值
		 */
		public function get value():String{
			return _childList[_selectIndex][1];
		}
		/**
		 * ComboBox的值
		 */
		public function set value(value:String):void{
			var index:int,arr:Array;
			for(index=0;index<_childList.length;index++){
				arr = _childList[index];
				if(arr[1] == value){
					_selectIndex = index;
					_backLabel.htmlText = "<font size='"+_textsize+"'>"+arr[0]+"</font>";
					break;
				}
			}
			toselectY();
		}
		/**
		 * ComboBox的显示值
		 */
		public function get label():String{
			return _childList[_selectIndex][0];
		}
		/**
		 * ComboBox的显示值
		 */
		public function set label(value:String):void{
			var index:int,arr:Array;
			for(index=0;index<_childList.length;index++){
				arr = _childList[index];
				if(arr[0] == value){
					_selectIndex = index;
					_backLabel.htmlText = "<font size='"+_textsize+"'>"+arr[0]+"</font>";
					break;
				}
			}
			toselectY();
		}
		/**
		 * 鼠标移入
		 */
		private function onover(event:MouseEvent):void{
			LFilter.setFilter(_button,LFilter.SUN);
		}
		/**
		 * 鼠标移出
		 */
		private function onout(event:MouseEvent):void{
			LFilter.setFilter(_button,LFilter.INIT);
		}
		/**
		 * 鼠标按下
		 */
		private function ondown(event:MouseEvent):void{
			(this.parent as LSprite).setChildIndex(this,(this.parent as LSprite).numChildren - 1);
			LFilter.setBrightness(_button,0.5);
		}
		/**
		 * 鼠标弹起
		 */
		private function onup(event:MouseEvent):void{
			LFilter.setBrightness(_button,1);
			
			_childSprite.addChild(_childSelect);
			_childSprite.addEventListener(MouseEvent.MOUSE_MOVE,onmove);
			_childSprite.addEventListener(MouseEvent.MOUSE_UP,onselect);
			_childScroll.visible = true;
			
			_childScroll.y = _back.height;
			
			var selectHeight:int = _back.height * 4 + 4;
			if(_childList.length < 4){
				selectHeight = _back.height * _childList.length + 4
			}
			var parentLayer:Object = _childScroll;
			var _scrollY:int = _childScroll.y;
			do{
				parentLayer = parentLayer.parent as LSprite;
				_scrollY += parentLayer.y;
			}while(parentLayer.parent is LSprite || parentLayer.parent is Sprite || parentLayer.parent is MovieClip);
			if(_scrollY + selectHeight > (parentLayer.stage as Stage).stageHeight){
				_childScroll.y -= (_scrollY + selectHeight - (parentLayer.stage as Stage).stageHeight);
			}
			_mystage.addEventListener(MouseEvent.ROLL_OUT,hiddenChild);
		}
		/**
		 * 鼠标移动
		 */
		private function onmove(event:MouseEvent):void{
			var index:int = int(event.currentTarget.mouseY / _back.height);
			if(index >= _childList.length)return;
			_childSelect.y = index*_back.height;
		}
		/**
		 * 选择
		 */
		private function onselect(event:MouseEvent):void{
			var index:int = int(event.currentTarget.mouseY / _back.height);
			if(index >= _childList.length)return;
			_mystage.removeEventListener(MouseEvent.ROLL_OUT,hiddenChild);
			var oldSelectIndex:int = _selectIndex;
			_selectIndex = index;
			_backLabel.htmlText = "<font size='"+_textsize+"'>"+_childList[index][0]+"</font>";
			_childSprite.removeAllEventListener();
			_childSprite.removeChild(_childSelect);
			_childScroll.visible = false;
			if(_selectIndex != oldSelectIndex){
				this.dispatchEvent(new LEvent(LEvent.CHANGE_VALUE));
			}
		}
		/**
		 * 调整选择条出现位置
		 */
		private function toselectY():void{
			_childSelect.y = _selectIndex*_back.height;
			if(_selectIndex > 3){
				_childScroll.scrollY = _back.height*3 -_childSelect.y;
			}
			
		}
		/**
		 * 隐藏选择框
		 */
		private function hiddenChild(event:MouseEvent):void{
			_mystage.removeEventListener(MouseEvent.ROLL_OUT,hiddenChild);
			_childScroll.visible = false;
			toselectY();
		}
		/**
		 * 给comboBox添加元素
		 * @param {name:value}
		 */
		public function push(name:String,value:String):void{
			_childList.push([name,value]);
			var text:LLabel = new LLabel()
			text.htmlText = "<font size='"+_textsize+"'>"+name+"</font>";
			text.y = (_childList.length - 1)*_back.height;
			var childBitmap:LBitmap = new LBitmap(_childBack);
			childBitmap.y = text.y;
			_childSprite.addChild(childBitmap);
			
			_childSprite.addChild(text);
			if(_childList.length == 1)selectIndex = 0;
		}
	}
}