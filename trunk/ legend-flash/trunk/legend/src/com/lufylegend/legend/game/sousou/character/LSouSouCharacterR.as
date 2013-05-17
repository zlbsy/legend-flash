package com.lufylegend.legend.game.sousou.character
{
	import flash.display.BitmapData;
	
	import com.lufylegend.legend.display.LBitmap;
	import com.lufylegend.legend.events.LEvent;
	import com.lufylegend.legend.game.sousou.object.LSouSouObject;
	import com.lufylegend.legend.game.utils.Node;
	import com.lufylegend.legend.objects.LAnimation;
	import com.lufylegend.legend.utils.LGlobal;
	import com.lufylegend.legend.utils.LImage;
	import com.lufylegend.legend.utils.math.LCoordinate;

	public class LSouSouCharacterR extends LSouSouCharacter
	{
		//普通
		public static const DOWN:int = 0;
		public static const LEFT:int = 1;
		public static const UP:int = 2;
		public static const RIGHT:int = 3;
		//移动
		public static const MOVE_DOWN:int = 4;
		public static const MOVE_LEFT:int = 5;
		public static const MOVE_UP:int = 6;
		public static const MOVE_RIGHT:int = 7;
		//坐下
		public static const SIT_DOWN:int = 8;
		public static const SIT_LEFT:int = 9;
		public static const SIT_UP:int = 10;
		public static const SIT_RIGHT:int = 11;
		//发怒
		public static const ANGRY_DOWN:int = 12;
		public static const ANGRY_LEFT:int = 13;
		public static const ANGRY_UP:int = 14;
		public static const ANGRY_RIGHT:int = 15;
		//欢呼
		public static const CHEER_DOWN:int = 16;
		public static const CHEER_LEFT:int = 17;
		public static const CHEER_UP:int = 18;
		public static const CHEER_RIGHT:int = 19;
		//哭泣
		public static const CRY_DOWN:int = 20;
		public static const CRY_LEFT:int = 21;
		public static const CRY_UP:int = 22;
		public static const CRY_RIGHT:int = 23;
		//伸手 
		public static const HAND_DOWN:int = 24;
		public static const HAND_LEFT:int = 25;
		public static const HAND_UP:int = 26;
		public static const HAND_RIGHT:int = 27;
		//作揖
		public static const SALUTE_DOWN:int = 28;
		public static const SALUTE_LEFT:int = 29;
		public static const SALUTE_UP:int = 30;
		public static const SALUTE_RIGHT:int = 31;
		//坐着发怒
		public static const SIT_ANGRY_DOWN:int = 32;
		public static const SIT_ANGRY_LEFT:int = 33;
		public static const SIT_ANGRY_UP:int = 34;
		public static const SIT_ANGRY_RIGHT:int = 35;
		//坐着举手
		public static const SIT_UPHAND_DOWN:int = 36;
		public static const SIT_UPHAND_LEFT:int = 37;
		public static const SIT_UPHAND_UP:int = 38;
		public static const SIT_UPHAND_RIGHT:int = 39;
		//坐着哭
		public static const SIT_CRY_DOWN:int = 40;
		public static const SIT_CRY_LEFT:int = 41;
		public static const SIT_CRY_UP:int = 42;
		public static const SIT_CRY_RIGHT:int = 43;
		//倒地
		public static const FALL_DOWN:int = 44;
		public static const FALL_LEFT:int = 45;
		public static const FALL_UP:int = 46;
		public static const FALL_RIGHT:int = 47;
		//跪地作揖
		public static const SIT_SALUTE_DOWN:int = 48;
		public static const SIT_SALUTE_LEFT:int = 49;
		public static const SIT_SALUTE_UP:int = 50;
		public static const SIT_SALUTE_RIGHT:int = 51;
		//捆绑
		public static const BINDING_DOWN:int = 52;
		public static const BINDING_LEFT:int = 53;
		public static const BINDING_UP:int = 54;
		public static const BINDING_RIGHT:int = 55;
		//攻击预备
		public static const P_ATTACK_DOWN:int = 56;
		public static const P_ATTACK_LEFT:int = 57;
		public static const P_ATTACK_UP:int = 58;
		public static const P_ATTACK_RIGHT:int = 59;
		//攻击
		public static const ATTACK_DOWN:int = 60;
		public static const ATTACK_LEFT:int = 61;
		public static const ATTACK_UP:int = 62;
		public static const ATTACK_RIGHT:int = 63;
		//半蹲
		public static const SQUAT_DOWN:int = 64;
		public static const SQUAT_LEFT:int = 65;
		public static const SQUAT_UP:int = 66;
		public static const SQUAT_RIGHT:int = 67;
		//双手举起
		public static const T_UPHAND_DOWN:int = 68;
		public static const T_UPHAND_LEFT:int = 69;
		public static const T_UPHAND_UP:int = 70;
		public static const T_UPHAND_RIGHT:int = 71;
		//单手举起
		public static const S_UPHAND_DOWN:int = 72;
		public static const S_UPHAND_LEFT:int = 73;
		public static const S_UPHAND_UP:int = 74;
		public static const S_UPHAND_RIGHT:int = 75;
		
		private var _data:BitmapData;
		private var _bitmap:LBitmap;
		private var _index:int;
		private var _dataArray:Array;
		private var _animation:LAnimation;
		private var _mode:int = LAnimation.POSITIVE;
		private var _direction:int = 0;
		private var _path:Array;
		private var _tagerCoordinate:LCoordinate;
		private var _ismoving:Boolean;
		public function LSouSouCharacterR(index:int,direction:int,ismoving:Boolean)
		{
			super();
			this._direction = direction;
			this._index = index;
			this._ismoving = ismoving;
			setImage();
		}


		public function get ismoving():Boolean
		{
			return _ismoving;
		}

		public function set ismoving(value:Boolean):void
		{
			_ismoving = value;
		}

		public function get path():Array
		{
			return _path;
		}

		public function set path(value:Array):void
		{
			_path = value;
		}

		public function get tagerCoordinate():LCoordinate
		{
			return _tagerCoordinate;
		}

		public function set tagerCoordinate(value:LCoordinate):void
		{
			_tagerCoordinate = value;
		}

		public function get index():int
		{
			return _index;
		}

		public function set index(value:int):void
		{
			_index = value;
		}
		
		public function onFrame():void{
			//this._animation.run(LAnimation.POSITIVE);
			this._animation.run(_mode);
			this.bitmapData = this._animation.dataBMP;
			
			move();
		}
		public function move():void{
			if(this._path == null)return;
			if(this.xy.x == this._tagerCoordinate.x && this.xy.y == this._tagerCoordinate.y){
				if(this._path.length == 0){
					if(this._animation.rowIndex >= 4)this._animation.rowIndex -= 4;
					this._animation.run(_mode);
					this._mode = LAnimation.CIRCULATION;
					this._path == null;
					dispatchEvent(new LEvent(LEvent.CHARACTER_MOVE_COMPLETE));
					return;
				}else{
					this._tagerCoordinate.x = this._path[0].x*24;
					this._tagerCoordinate.y = this._path[0].y*24;
					this._path.shift();
				}
			}
			
			this._mode = LAnimation.POSITIVE;
			if(this.xy.x > this._tagerCoordinate.x && this.xy.y > this._tagerCoordinate.y){
				this.x -= 4;
				this.y -= 4;
				this._animation.rowIndex =	LSouSouCharacterR.MOVE_LEFT
			}else if(this.xy.x > this._tagerCoordinate.x && this.xy.y < this._tagerCoordinate.y){
				this.x -= 4;
				this.y += 4;
				this._animation.rowIndex =	LSouSouCharacterR.MOVE_DOWN;
			}else if(this.xy.x < this._tagerCoordinate.x && this.xy.y > this._tagerCoordinate.y){
				this.x += 4;
				this.y -= 4;
				this._animation.rowIndex =	LSouSouCharacterR.MOVE_UP;
			}else{
				this.x += 4;
				this.y += 4;
				this._animation.rowIndex =	LSouSouCharacterR.MOVE_RIGHT;
			}
		}
		private function setImage():void{
			/**
			var data01:BitmapData = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["R"],
				"r" + LSouSouObject.chara["peo"+this._index]["R"] + "-0");
			var data02:BitmapData = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["R"],
				"r" + LSouSouObject.chara["peo"+this._index]["R"] + "-1");
			*/
			
			var data01:BitmapData = LSouSouObject.charaR0List[LSouSouObject.chara["peo"+this._index]["R"]];
			var data02:BitmapData =LSouSouObject.charaR1List[LSouSouObject.chara["peo"+this._index]["R"]];
			
			var datalist01:Array = LImage.divideByCopyPixels(data01,20,1);
			var datalist02:Array = LImage.divideByCopyPixels(data02,20,1);
			_dataArray = new Array();
			/*********站立*********/
			//下
			_dataArray.push([datalist01[0][0]]);
			//左
			_dataArray.push([LImage.horizontal(datalist02[0][0])]);
			//上
			_dataArray.push([datalist02[0][0]]);
			//右
			_dataArray.push([LImage.horizontal(datalist01[0][0])]);
			/*********移動*********/
			//下
			_dataArray.push([datalist01[1][0],datalist01[2][0]]);
			//左
			_dataArray.push([LImage.horizontal(datalist02[1][0]),LImage.horizontal(datalist02[2][0])]);
			//上
			_dataArray.push([datalist02[1][0],datalist02[2][0]]);
			//右
			_dataArray.push([LImage.horizontal(datalist01[1][0]),LImage.horizontal(datalist01[2][0])]);
			/*********坐下*********/
			//下
			_dataArray.push([datalist01[3][0]]);
			//左
			_dataArray.push([LImage.horizontal(datalist02[3][0])]);
			//上
			_dataArray.push([datalist02[3][0]]);
			//右
			_dataArray.push([LImage.horizontal(datalist01[3][0])]);
			/*********发怒*********/
			//下
			_dataArray.push([datalist01[4][0]]);
			//左
			_dataArray.push([LImage.horizontal(datalist02[4][0])]);
			//上
			_dataArray.push([datalist02[4][0]]);
			//右
			_dataArray.push([LImage.horizontal(datalist01[4][0])]);
			/*********欢呼*********/
			//下
			_dataArray.push([datalist01[5][0]]);
			//左
			_dataArray.push([LImage.horizontal(datalist02[5][0])]);
			//上
			_dataArray.push([datalist02[5][0]]);
			//右
			_dataArray.push([LImage.horizontal(datalist01[5][0])]);
			/*********哭泣*********/
			//下
			_dataArray.push([datalist01[6][0]]);
			//左
			_dataArray.push([LImage.horizontal(datalist02[6][0])]);
			//上
			_dataArray.push([datalist02[6][0]]);
			//右
			_dataArray.push([LImage.horizontal(datalist01[6][0])]);
			/*********伸手*********/
			//下
			_dataArray.push([datalist01[7][0]]);
			//左
			_dataArray.push([LImage.horizontal(datalist02[7][0])]);
			//上
			_dataArray.push([datalist02[7][0]]);
			//右
			_dataArray.push([LImage.horizontal(datalist01[7][0])]);
			/*********作揖*********/
			//下
			_dataArray.push([datalist01[8][0]]);
			//左
			_dataArray.push([LImage.horizontal(datalist02[8][0])]);
			//上
			_dataArray.push([datalist02[8][0]]);
			//右
			_dataArray.push([LImage.horizontal(datalist01[8][0])]);
			/*********坐着发怒*********/
			//下
			_dataArray.push([datalist01[9][0]]);
			//左
			_dataArray.push([LImage.horizontal(datalist02[9][0])]);
			//上
			_dataArray.push([datalist02[9][0]]);
			//右
			_dataArray.push([LImage.horizontal(datalist01[9][0])]);
			/*********坐着举手*********/
			//下
			_dataArray.push([datalist01[10][0]]);
			//左
			_dataArray.push([LImage.horizontal(datalist02[10][0])]);
			//上
			_dataArray.push([datalist02[10][0]]);
			//右
			_dataArray.push([LImage.horizontal(datalist01[10][0])]);
			/*********坐着哭*********/
			//下
			_dataArray.push([datalist01[11][0]]);
			//左
			_dataArray.push([LImage.horizontal(datalist02[11][0])]);
			//上
			_dataArray.push([datalist02[11][0]]);
			//右
			_dataArray.push([LImage.horizontal(datalist01[11][0])]);
			/*********倒地*********/
			//下
			_dataArray.push([datalist01[12][0]]);
			//左
			_dataArray.push([LImage.horizontal(datalist02[12][0])]);
			//上
			_dataArray.push([datalist02[12][0]]);
			//右
			_dataArray.push([LImage.horizontal(datalist01[12][0])]);
			/*********跪地作揖*********/
			//下
			_dataArray.push([datalist01[13][0]]);
			//左
			_dataArray.push([LImage.horizontal(datalist02[13][0])]);
			//上
			_dataArray.push([datalist02[13][0]]);
			//右
			_dataArray.push([LImage.horizontal(datalist01[13][0])]);
			/*********捆绑*********/
			//下
			_dataArray.push([datalist01[14][0]]);
			//左
			_dataArray.push([LImage.horizontal(datalist02[14][0])]);
			//上
			_dataArray.push([datalist02[14][0]]);
			//右
			_dataArray.push([LImage.horizontal(datalist01[14][0])]);
			/*********攻击预备*********/
			//下
			_dataArray.push([datalist01[15][0]]);
			//左
			_dataArray.push([LImage.horizontal(datalist02[15][0])]);
			//上
			_dataArray.push([datalist02[15][0]]);
			//右
			_dataArray.push([LImage.horizontal(datalist01[15][0])]);
			/*********攻击*********/
			//下
			_dataArray.push([datalist01[16][0]]);
			//左
			_dataArray.push([LImage.horizontal(datalist02[16][0])]);
			//上
			_dataArray.push([datalist02[16][0]]);
			//右
			_dataArray.push([LImage.horizontal(datalist01[16][0])]);
			/*********半蹲*********/
			//下
			_dataArray.push([datalist01[17][0]]);
			//左
			_dataArray.push([LImage.horizontal(datalist02[17][0])]);
			//上
			_dataArray.push([datalist02[17][0]]);
			//右
			_dataArray.push([LImage.horizontal(datalist01[17][0])]);
			/*********双手举起*********/
			//下
			_dataArray.push([datalist01[18][0]]);
			//左
			_dataArray.push([LImage.horizontal(datalist02[18][0])]);
			//上
			_dataArray.push([datalist02[18][0]]);
			//右
			_dataArray.push([LImage.horizontal(datalist01[18][0])]);
			/*********单手举起*********/
			//下
			_dataArray.push([datalist01[19][0]]);
			//左
			_dataArray.push([LImage.horizontal(datalist02[19][0])]);
			//上
			_dataArray.push([datalist02[19][0]]);
			//右
			_dataArray.push([LImage.horizontal(datalist01[19][0])]);
			
			this._animation = new LAnimation(_dataArray);
			this._animation.rowIndex = this._direction;
			this._animation.run(this.mode);
			this.bitmapData = this._animation.dataBMP;
		}
		override public function die():void{
			var i:int,j:int,arr:Array;
			for(i=0;i<_dataArray.length;i++){
				arr = _dataArray[i];
				for(j=0;j<arr.length;j++)(arr[j] as BitmapData).dispose();
			}
			super.die();
		}
		public function get action():int
		{
			return this._animation.rowIndex;
		}
		
		public function set action(value:int):void
		{
			this._animation.rowIndex = value;
			this._animation.run(LAnimation.POSITIVE);
			this.bitmapData = this._animation.dataBMP;
			this._mode = LAnimation.CIRCULATION;
		}
		public function get mode():int
		{
			return _mode;
		}
		
		public function set mode(value:int):void
		{
			_mode = value;
		}

		override public function set xy(_xy:LCoordinate):void{
			this.x = _xy.x - 24;
			this.y = _xy.y - 54;
		}
		override public function get xy():LCoordinate{
			return new LCoordinate(this.x + 24,this.y + 54);
		}
	}
}