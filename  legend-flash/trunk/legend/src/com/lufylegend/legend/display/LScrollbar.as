package zhanglubin.legend.display
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import zhanglubin.legend.utils.LDisplay;
	import zhanglubin.legend.utils.math.LCoordinate;

	public class LScrollbar extends LSprite
	{
		private const SPEED:uint = 10;
		private var _showLayer:LSprite;
		private var _showObject:DisplayObject;
		private var _mask:LShape;
		private var _width:int;
		private var _height:int;
		private var _scrollWidth:uint;
		private var _scroll_h:LShape;
		private var _scroll_w:LShape;
		private var _scroll_h_bar:LShape;
		private var _scroll_w_bar:LShape;
		private var _key:Array;
		private var _tager:LCoordinate;
		private var _distance:uint;
		private var _speed:uint;
		private var _wVisible:Boolean;
		private var _lineSprite:LSprite;
		private var _thisStage:Stage;
		/**
		 * legend滚动条显示类
		 * 
		 * @param showObject 显示对象
		 * @param maskW 宽度
		 * @param maskH 高度
		 * @param scrollWidth 滚动条宽度
		 *
		 * @author lufy(lufy.legend＠gmail.com)
		 */
		public function LScrollbar(showObject:DisplayObject,maskW:int,maskH:int,scrollWidth:uint = 20,wVisible:Boolean=true)
		{
			this._showLayer = new LSprite();
			this._mask = new LShape();
			_wVisible = wVisible;
			LDisplay.drawRect(this._showLayer.graphics,[0,0,maskW,maskH],true,0xffffff,0);
			LDisplay.drawRect(this._mask.graphics,[0,0,maskW,maskH],true,0xffffff);
			this.addChild(this._showLayer);
			this.addChild(this._mask);
			this._width = 0;
			this._height = 0;
			this._showObject = showObject;
			this._showLayer.addChild(showObject);
			this._showObject.mask = this._mask;
			this._scrollWidth = scrollWidth;
			this._tager = new LCoordinate(0,0);
			this.addEventListener(Event.ENTER_FRAME,onFrame);
		}
		public function set line(value:Boolean):void{
			if(value){
				if(_lineSprite != null)return;
				_lineSprite = new LSprite();
				LDisplay.drawRect(_lineSprite.graphics,[0,0,_mask.width,_mask.height],false,0x999999,1,2);
				this.addChild(_lineSprite);
			}else{
				if(_lineSprite == null)return;
				this.removeChild(_lineSprite);
				_lineSprite = null;
			}
		}
		/**
		 * 贞事件
		 */
		private function onFrame(event:Event):void{
			if(_wVisible && this._width != this._showObject.width){
				this._width = this._showObject.width;
				if(this._width > this._mask.width){
					resizeWidth(true);
					moveLeft();
				}else{
					resizeWidth(false);
				}
			}
			if(this._height != this._showObject.height){
				this._height = this._showObject.height;
				if(this._height > this._mask.height){
					resizeHeight(true);
					moveUp();
				}else{
					resizeHeight(false);
				}
			}
			if(this._key == null)return;
			if(this._key["up"]){
				moveUp();
			}
			if(this._key["down"]){
				moveDown();
			}
			if(this._key["left"]){
				moveLeft();
			}
			if(this._key["right"]){
				moveRight();
			}
		}
		public function get scrollY():int{
			return this._showObject.y;
		}
		public function set scrollY(value:int):void{
			this._showObject.y = value;
			setScroll_h();
		}
		/**
		 * 滚动条到顶部
		 */
		public function scrollToTop():void{
			this._showObject.y = 0;
			setScroll_h();
		}
		/**
		 * 滚动条到底部
		 */
		public function scrollToBottom():void{
			this._showObject.y = this._showObject.height>this._mask.height?this._mask.height-this._showObject.height:0;
			setScroll_h();
		}
		/**
		 * 滚动条到左端
		 */
		public function scrollToLeft():void{
			this._showObject.x = 0;
			setScroll_w();
		}
		/**
		 * 滚动条到右端
		 */
		public function scrollToRight():void{
			this._showObject.x = this._showObject.width>this._mask.width?this._mask.width-this._showObject.width:0;
			setScroll_w();
		}
		/**
		 * 上移
		 */
		private function moveUp():void{
			if(!this._key["Dkey"] && this._showObject.y >= this._tager.y){
				this._key["up"] = false;
				setScroll_h();
				return;
			}else if(this._showObject.y >= 0){
				this._showObject.y = 0;
				this._key["up"] = false;
				setScroll_h();
				return;
			}
			if(this._key["Dkey"])this._speed = 5;
			this._showObject.y += this._speed;
			setScroll_h();
			this.setSpeed();
		}
		/**
		 * 下移
		 */
		private function moveDown():void{
			if(!this._key["Dkey"] && this._showObject.y <= this._tager.y){
				this._key["down"] = false;
				setScroll_h();
				return;
			}else if(this._showObject.y <= this._mask.height - this._showObject.height){
				this._showObject.y = this._mask.height - this._showObject.height;
				this._key["down"] = false;
				setScroll_h();
				return;
			}
			if(this._key["Dkey"])this._speed = 5;
			this._showObject.y -= this._speed;
			setScroll_h();
			this.setSpeed();
		}
		/**
		 * 左移
		 */
		private function moveLeft():void{
			if(!this._key["Dkey"] && this._showObject.x >= this._tager.x){
				this._key["left"] = false;
				setScroll_w();
				return;
			}else if(this._showObject.x >= 0){
				this._showObject.x = 0;
				this._key["left"] = false;
				setScroll_w();
				return;
			}
			if(this._key["Dkey"])this._speed = 5;
			this._showObject.x += this._speed;
			setScroll_w();
			this.setSpeed();
		}
		/**
		 * 右移
		 */
		private function moveRight():void{
			if(!this._key["Dkey"] && this._showObject.x <= this._tager.x){
				this._key["right"] = false;
				setScroll_w();
				return;
			}else if(this._showObject.x <= this._mask.width - this._showObject.width){
				this._showObject.x = this._mask.width - this._showObject.width;
				this._key["right"] = false;
				setScroll_w();
				return;
			}
			if(this._key["Dkey"])this._speed = 5;
			this._showObject.x -= this._speed;
			setScroll_w();
			this.setSpeed();
		}
		/**
		 * 竖向滚动条位置调整
		 */
		private function setScroll_h():void{
			var sy:Number = (this._mask.height - this._scrollWidth*3.5)*this._showObject.y/(this._mask.height - this._showObject.height);
			if(_scroll_h_bar)_scroll_h_bar.xy = new LCoordinate(this._mask.width,this._scrollWidth + sy);
		}
		/**
		 * 横向滚动条位置调整
		 */
		private function setScroll_w():void{
			var sx:Number = (this._mask.width - this._scrollWidth*3.5)*this._showObject.x/(this._mask.width - this._showObject.width);
			if(_scroll_w_bar)_scroll_w_bar.xy = new LCoordinate(this._scrollWidth + sx,this._mask.height);
		}
		/**
		 * 宽度调整
		 */
		private function resizeWidth(value:Boolean):void{
			if(!value){
				if(_scroll_w != null){
					_scroll_w.removeFromParent();
					_scroll_w_bar.removeFromParent();
					_scroll_w = null;
					_scroll_w_bar = null;
				}
				return;
			}
			var i:uint;
			if(_scroll_w == null){
				if(_key == null)_key = new Array();
				
				_scroll_w = new LShape()
				_scroll_w_bar = new LShape();
				this.addChild(_scroll_w);
				this.addChild(_scroll_w_bar);
				var ny:Number = this._scrollWidth*1.5;
				_scroll_w.xy = new LCoordinate(0,this._mask.height);
				_scroll_w_bar.xy = new LCoordinate(this._scrollWidth,this._mask.height);
				
				LDisplay.drawRect(_scroll_w_bar.graphics,[0,0,ny,this._scrollWidth],true,0xcccccc);
				LDisplay.drawRect(_scroll_w_bar.graphics,[0,0,ny,this._scrollWidth]);
				LDisplay.drawLine(_scroll_w_bar.graphics,[ny*0.5,this._scrollWidth*0.25,ny*0.5,this._scrollWidth*0.75]);
				LDisplay.drawLine(_scroll_w_bar.graphics,[ny*0.5-2,this._scrollWidth*0.25,ny*0.5-2,this._scrollWidth*0.75]);
				LDisplay.drawLine(_scroll_w_bar.graphics,[ny*0.5+2,this._scrollWidth*0.25,ny*0.5+2,this._scrollWidth*0.75]);
				
				LDisplay.drawRect(_scroll_w.graphics,[0,0,this._mask.width,this._scrollWidth],true,0x292929);
				LDisplay.drawRect(_scroll_w.graphics,[0,0,this._scrollWidth,this._scrollWidth],true,0xffffff);
				LDisplay.drawRect(_scroll_w.graphics,[this._mask.width - this._scrollWidth,0,this._scrollWidth,this._scrollWidth],true,0xffffff);

				LDisplay.drawTriangle(_scroll_w.graphics,[this._scrollWidth*0.75,this._scrollWidth*0.25, 
					this._scrollWidth*0.75,this._scrollWidth*0.75,
					this._scrollWidth*0.25,this._scrollWidth*0.5],true);
				
				LDisplay.drawTriangle(_scroll_w.graphics,[this._mask.width - this._scrollWidth*0.75,this._scrollWidth*0.25, 
					this._mask.width - this._scrollWidth*0.75,this._scrollWidth*0.75,
					this._mask.width - this._scrollWidth*0.25,this._scrollWidth*0.5],true);
				
				
				LDisplay.drawRect(_scroll_w.graphics,[0,0,this._mask.width,this._scrollWidth]);
				LDisplay.drawRect(_scroll_w.graphics,[0,0,this._scrollWidth,this._scrollWidth]);
				LDisplay.drawRect(_scroll_w.graphics,[this._mask.width - this._scrollWidth,0,this._scrollWidth,this._scrollWidth]);

				var mouseDownHave:Boolean = false;
				for(i=0;i<this.eventList.length;i++){
					if(eventList[i][0] == MouseEvent.MOUSE_DOWN){
						mouseDownHave = true;
						break;
					}
				}
				if(!mouseDownHave)this.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			}
			
			
		}
		/**
		 * 高度调整
		 */
		private function resizeHeight(value:Boolean):void{
			if(!value){
				if(_scroll_h != null){
					_scroll_h.removeFromParent();
					_scroll_h_bar.removeFromParent();
					_scroll_h = null;
					_scroll_h_bar = null;
				}
				return;
			}
			var i:uint;
			if(_scroll_h_bar == null){
				if(_key == null)_key = new Array();
				
				_scroll_h = new LShape()
				_scroll_h_bar = new LShape();
				this.addChild(_scroll_h);
				this.addChild(_scroll_h_bar);
				var ny:Number = this._scrollWidth*1.5;
				_scroll_h.xy = new LCoordinate(this._mask.width,0);
				_scroll_h_bar.xy = new LCoordinate(this._mask.width,this._scrollWidth);
				
				
				LDisplay.drawRect(_scroll_h_bar.graphics,[0,0,this._scrollWidth,this._scrollWidth*1.5],true,0xcccccc);
				LDisplay.drawRect(_scroll_h_bar.graphics,[0,0,this._scrollWidth,ny]);
				LDisplay.drawLine(_scroll_h_bar.graphics,[this._scrollWidth*0.25,ny*0.5,this._scrollWidth*0.75,ny*0.5]);
				LDisplay.drawLine(_scroll_h_bar.graphics,[this._scrollWidth*0.25,ny*0.5-2,this._scrollWidth*0.75,ny*0.5-2]);
				LDisplay.drawLine(_scroll_h_bar.graphics,[this._scrollWidth*0.25,ny*0.5+2,this._scrollWidth*0.75,ny*0.5+2]);
				
				LDisplay.drawRect(_scroll_h.graphics,[0,0,this._scrollWidth,this._mask.height],true,0x292929);
				LDisplay.drawRect(_scroll_h.graphics,[0,0,this._scrollWidth,this._scrollWidth],true,0xffffff);
				LDisplay.drawRect(_scroll_h.graphics,[0,this._mask.height - this._scrollWidth,this._scrollWidth,this._scrollWidth],true,0xffffff);
				
				LDisplay.drawTriangle(_scroll_h.graphics,[this._scrollWidth/4,this._scrollWidth*0.75, 
					this._scrollWidth/2,this._scrollWidth/4, 
					this._scrollWidth*0.75,this._scrollWidth*0.75],true);
				LDisplay.drawTriangle(_scroll_h.graphics,[this._scrollWidth/4,this._mask.height - this._scrollWidth*0.75, 
					this._scrollWidth/2,this._mask.height - this._scrollWidth*0.25, 
					this._scrollWidth*0.75,this._mask.height - this._scrollWidth*0.75],true);
				
				LDisplay.drawRect(_scroll_h.graphics,[0,0,this._scrollWidth,this._mask.height]);
				LDisplay.drawRect(_scroll_h.graphics,[0,0,this._scrollWidth,this._scrollWidth]);
				LDisplay.drawRect(_scroll_h.graphics,[0,this._mask.height - this._scrollWidth,this._scrollWidth,this._scrollWidth]);
				
				var mouseDownHave:Boolean = false;
				var mouseWheelHave:Boolean = false;
				for(i=0;i<this.eventList.length;i++){
					if(eventList[i][0] == MouseEvent.MOUSE_DOWN){
						mouseDownHave = true;
					}
					if(eventList[i][0] == MouseEvent.MOUSE_WHEEL){
						mouseWheelHave = true;
					}
				}
				if(!mouseDownHave){
					this.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
				}
				if(!mouseWheelHave){
					this._showLayer.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
				}
				
				
			}
		}
		/**
		 * 鼠标滚动
		 */
		private function onMouseWheel(event:MouseEvent):void{
			if(event.delta > 0){
				this._distance = 10*event.delta;
				if(this._showObject.y + this._distance > 0)this._distance = Math.abs(this._showObject.y);
				this._tager.y = this._showObject.y + this._distance;
				this._key["up"] = true;
				this._key["down"] = false;
				this._speed = this._distance;
				this.setSpeed();
			}else{
				this._distance = 10*(-event.delta);
				if(this._showObject.y - this._distance < this._mask.height - this._showObject.height)this._distance = this._showObject.y - this._mask.height + this._showObject.height;
				this._tager.y = this._showObject.y - this._distance;
				this._key["down"] = true;
				this._key["up"] = false;
				this._speed = this._distance;
				this.setSpeed();
			}
		}
		/**
		 * 鼠标按下
		 */
		private function mouseDown(event:MouseEvent):void{
			if(_scroll_h != null && this.mouseX >= _scroll_h.x && this.mouseX <= _scroll_h.x + this._scrollWidth){
				mouseDownH();
			}
			if(_scroll_w != null && this.mouseY >= _scroll_w.y && this.mouseY <= _scroll_w.y + this._scrollWidth){
				mouseDownW();
			}
		}
		private function mouseDownW():void{
			_thisStage = this.stage;
			if(this.mouseX >= 0 && this.mouseX <= this._scrollWidth){
				if(this._showObject.x >= 0 || this._key["left"])return;
				this._distance = 10;
				if(this._showObject.x + this._distance > 0)this._distance = this._showObject.x;
				this._tager.x = this._showObject.x + this._distance;
				this._key["left"] = true;
				this._key["right"] = false;
				this._key["Dkey"] = true;
				this._speed = this._distance;
				this.setSpeed();
			}else if(this.mouseX >= this._mask.width - this._scrollWidth && this.mouseX <= this._mask.width){
				if(this._showObject.x <= this._mask.width - this._showObject.width || this._key["left"])return;
				this._distance = 10;
				if(this._showObject.x - this._distance < this._mask.width - this._showObject.width)this._distance = this._showObject.x - this._mask.width + this._showObject.width;
				this._tager.x = this._showObject.x - this._distance;
				this._key["right"] = true;
				this._key["left"] = false;
				this._key["Dkey"] = true;
				this._speed = this._distance;
				this.setSpeed();
			}else if(this.mouseX >= this._scroll_w_bar.x && this.mouseX <= this._scroll_w_bar.x + this._scroll_w_bar.width && !this._key["scroll_w"]){
				this._key["scroll_w"] = true;
				this._key["scroll_x"] = this.mouseX - this._scroll_w_bar.x;
				this._key["mouseX"] = this.mouseX;
				_thisStage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveW);
				_thisStage.addEventListener(MouseEvent.MOUSE_UP,mouseUpW);
			}else if(this.mouseX > 0 && this.mouseX < this._mask.width){
				this._key["left"] = false;
				this._key["right"] = false;
				this._tager.x = (this._mask.width - this._showObject.width)*(this.mouseX - this._scrollWidth)/(this._mask.width - this._scrollWidth*3.5);
				if(this._tager.x > this._showObject.x){
					this._key["left"] = true;
				}else{
					this._key["right"] = true;
				}
				this._speed = Math.abs(this._tager.x - this._showObject.x);
				this.setSpeed();
			}
		}
		private function mouseDownH():void{
			_thisStage = this.stage;
			if(this.mouseY >= 0 && this.mouseY <= this._scrollWidth){
				if(this._showObject.y >= 0)return;
				this._distance = 10;
				if(this._showObject.y + this._distance > 0)this._distance = this._showObject.y;
				this._tager.y = this._showObject.y + this._distance;
				this._key["up"] = true;
				this._key["down"] = false;
				this._key["Dkey"] = true;
				this._speed = this._distance;
				this.setSpeed();
				_thisStage.addEventListener(MouseEvent.MOUSE_UP,mouseUpH);
			}else if(this.mouseY >= this._mask.height - this._scrollWidth && this.mouseY <= this._mask.height){
				if(this._showObject.y <= this._mask.height - this._showObject.height)return;
				this._distance = 10;
				if(this._showObject.y - this._distance < this._mask.height - this._showObject.height)this._distance = this._showObject.y - this._mask.height + this._showObject.height;
				this._tager.y = this._showObject.y - this._distance;
				this._key["down"] = true;
				this._key["up"] = false;
				this._key["Dkey"] = true;
				this._speed = this._distance;
				this.setSpeed();
				_thisStage.addEventListener(MouseEvent.MOUSE_UP,mouseUpH);
			}else if(this.mouseY >= this._scroll_h_bar.y && this.mouseY <= this._scroll_h_bar.y + this._scroll_h_bar.height && !this._key["scroll_h"]){
				this._key["scroll_h"] = true;
				this._key["scroll_y"] = this.mouseY - this._scroll_h_bar.y;
				this._key["mouseY"] = this.mouseY;
				_thisStage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveH);
				_thisStage.addEventListener(MouseEvent.MOUSE_UP,mouseUpH);
			}else if(this.mouseY > 0 && this.mouseY < this._mask.height){
				this._key["up"] = false;
				this._key["down"] = false;
				this._tager.y = (this._mask.height - this._showObject.height)*(this.mouseY - this._scrollWidth)/(this._mask.height - this._scrollWidth*3.5);
				if(this._tager.y > this._showObject.y){
					this._key["up"] = true;
				}else{
					this._key["down"] = true;
				}
				this._speed = Math.abs(this._tager.y - this._showObject.y);
				this.setSpeed();
			}
		}
		private function mouseMoveH(event:MouseEvent):void{
			if(this.mouseY < this._scrollWidth || this.mouseY > this._mask.height){
				return;
			}
			var mx:uint = this.mouseY - this._key["scroll_y"];
			this._key["up"] = false;
			this._key["down"] = false;
			this._tager.y = (this._mask.height - this._showObject.height)*(mx - this._scrollWidth)/(this._mask.height - this._scrollWidth*3.5);

			if(this._tager.y > this._showObject.y){
				this._key["up"] = true;
			}else{
				this._key["down"] = true;
			}
			this._speed = Math.abs(this._tager.y - this._showObject.y);
			this.setSpeed();
		}
		private function mouseUpH(event:MouseEvent):void{
			_thisStage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpH);
			if(this._key["Dkey"]){
				this._key["Dkey"] = false;
			}else{
				_thisStage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveH);
				if(this._key["scroll_h"])this._key["scroll_h"] = false;
			}
		}
		private function mouseMoveW(event:MouseEvent):void{
			if(this.mouseX < this._scrollWidth || this.mouseX > this._mask.width){
				return;
			}
			var my:uint = this.mouseX - this._key["scroll_x"];
			this._key["left"] = false;
			this._key["right"] = false;
			this._tager.x = (this._mask.width- this._showObject.width)*(my - this._scrollWidth)/(this._mask.width - this._scrollWidth*3.5);
			
			if(this._tager.x > this._showObject.x){
				this._key["left"] = true;
			}else{
				this._key["right"] = true;
			}
			this._speed = Math.abs(this._tager.x - this._showObject.x);
			this.setSpeed();
		}
		private function mouseUpW(event:MouseEvent):void{
			_thisStage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpW);
			_thisStage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveW);
			if(this._key["scroll_w"])this._key["scroll_w"] = false;
		}
		/**
		 * 滚动条缓动
		 */
		private function setSpeed():void{
			this._speed = Math.floor(this._speed/2);
			if(this._speed == 0)this._speed = 1;
		}
	}
}