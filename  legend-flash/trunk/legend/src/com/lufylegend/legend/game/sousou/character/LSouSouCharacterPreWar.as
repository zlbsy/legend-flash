package com.lufylegend.legend.game.sousou.character
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import com.lufylegend.legend.components.LLabel;
	import com.lufylegend.legend.display.LBitmap;
	import com.lufylegend.legend.display.LShape;
	import com.lufylegend.legend.display.LSprite;
	import com.lufylegend.legend.game.sousou.object.LSouSouObject;
	import com.lufylegend.legend.utils.LDisplay;
	import com.lufylegend.legend.utils.LGlobal;
	import com.lufylegend.legend.utils.math.LCoordinate;

	public class LSouSouCharacterPreWar extends LSprite
	{
		private var _member:LSouSouMember;
		private var _bitmap:LBitmap;
		private var _name:LLabel;
		private var _shape:LShape;
		private var _isSelect:Boolean;
		private var _width:int = 700;
		private var _height:int = 72;
		public function LSouSouCharacterPreWar(member:LSouSouMember)
		{
			_member = member;
			/*
			for each(_member in LSouSouObject.memberList){
				if(_member.index == index)break;
			}
			if(_member == null)return;
			*/
			_shape = new LShape();
			this.addChild(_shape);
			var data01:BitmapData =LSouSouObject.charaMOVList[LSouSouObject.chara["peo"+_member.index]["S"]];
			/*
			var data01:BitmapData = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["S"],
				LSouSouObject.chara["peo"+_member.index]["S"] + "mov");
			*/
			var imagedata:BitmapData = new BitmapData(48,48,true);
			imagedata.copyPixels(data01,new Rectangle(0,288,48,48),new Point(0,0));
			_bitmap = new LBitmap(imagedata);
			_bitmap.xy = new LCoordinate((70 - _bitmap.width)/2,0);
			this.addChild(_bitmap);
			_name = new LLabel();
			_name.htmlText = "<font size='14' color='#ffffff'><b>" + _member.name + "</b></font>";
			_name.xy = new LCoordinate((70 - _name.width)/2,_bitmap.height+2);
			this.addChild(_name);
			LDisplay.drawRect(this._shape.graphics,[0,0,_width,_height],true,0xffffff,0.1);
			LDisplay.drawRect(this._shape.graphics,[0,0,_width,_height],false,0xffffff,0.2);
			
			if(_member.must == 1){
				onSelect();
			}else{
				this.addEventListener(MouseEvent.MOUSE_UP,onClick);
			}
			
			//this.addEventListener(MouseEvent.MOUSE_UP,onClick);
		}
		private function onClick(event:MouseEvent):void{
			onSelect();
			
		}
		private function onSelect():void{
			this._shape.graphics.clear();
			if(_isSelect){
				_isSelect = false;
				_bitmap.xy = new LCoordinate((70 - _bitmap.width)/2,0);
				LDisplay.drawRect(this._shape.graphics,[0,0,_width,_height],true,0xffffff,0.1);
				LDisplay.drawRect(this._shape.graphics,[0,0,_width,_height],false,0xffffff,0.2);
				_name.htmlText = "<font size='14' color='#ffffff'><b>" + _member.name + "</b></font>";
			}else{
				_isSelect = true;
				_bitmap.xy = new LCoordinate((70 - _bitmap.width)/2 + 4,4);
				LDisplay.drawRect(this._shape.graphics,[0,0,_width,_height],true,0x000000,0.3);
				LDisplay.drawRect(this._shape.graphics,[0,0,_width,_height],false,0x000000,0.4);
				_name.htmlText = "<font size='14' color='#cccccc'><b>" + _member.name + "</b></font>";
			}
			LSouSouObject.window.setWarList(_member.index,_isSelect);
		}
	}
}