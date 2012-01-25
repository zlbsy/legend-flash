package zhanglubin.legend.game.sousou.map
{
	import zhanglubin.legend.display.LShape;
	import zhanglubin.legend.game.sousou.character.LSouSouCharacterS;
	import zhanglubin.legend.game.sousou.object.LSouSouObject;
	import zhanglubin.legend.game.utils.LStarQuery;
	import zhanglubin.legend.game.utils.Node;
	import zhanglubin.legend.utils.LGlobal;
	import zhanglubin.legend.utils.math.LCoordinate;

	public class LSouSouStarS extends LStarQuery
	{
		private var _chara:LSouSouCharacterS;
		
		public function LSouSouStarS(map:Array) {
			_map = [];
			_w = map[0].length;
			_h = map.length;
			for (var y:int=0; y<_h; y++) {
				if (_map[y] == undefined) {
					_map[y] = [];
				}
				for (var x:int=0; x<_w; x++) {
					_map[y][x] = new Node(x,y,map[y][x]);
				}
			}
		}
		private function loopPath(thisPoint:Object):void {
			trace("loopPath ",thisPoint)
			if (thisPoint.moveLong <= 0) {
				return;
			}
			trace("loopPath check")
			
			if (! thisPoint.isChecked) {
				_path.push(thisPoint);
				thisPoint.isChecked = true;
			}
			var checkList:Array = [];
			//获取周围四个点
			if (thisPoint.y > 0) {
				checkList.push(_map[(thisPoint.y-1)][thisPoint.x]);
			}
			if (thisPoint.x > 0) {
				checkList.push(_map[thisPoint.y][(thisPoint.x-1)]);
			}
			if (thisPoint.x < _w - 1) {
				checkList.push(_map[thisPoint.y][(thisPoint.x+1)]);
			}
			if (thisPoint.y < _h - 1) {
				checkList.push(_map[(thisPoint.y+1)][thisPoint.x]);
			}
			var i:int;
			for (i=0; i<checkList.length; i++) {
				var checkPoint:Object = checkList[i];
				if (! checkPoint.isChecked || checkPoint.moveLong < thisPoint.moveLong) {
					var cost:int = int(LSouSouObject.arms["Arms" + _chara.arms]["Terrain"]["Terrain" + _map[checkPoint.y][checkPoint.x].value]);
					trace('_enemyCost[checkPoint.x + "-" + checkPoint.y]',checkPoint.x + "-" + checkPoint.y,_enemyCost[checkPoint.x + "-" + checkPoint.y]);
					cost += _enemyCost[checkPoint.x + "-" + checkPoint.y] != null && _enemyCost[checkPoint.x + "-" + checkPoint.y] != "all" ? _enemyCost[checkPoint.x + "-" + checkPoint.y]:0;
					trace("cost = ",cost,thisPoint.moveLong);
					checkPoint.moveLong = thisPoint.moveLong - cost;
					trace("checkPoint.moveLong = ",checkPoint.moveLong);
					if (_enemyCost[checkPoint.x + "-" + checkPoint.y] == "all" && checkPoint.moveLong > 1) {
						checkPoint.moveLong = 1;
					}
					loopPath(checkPoint);
				}
			}
			
		}
		public function setPathAll(px:int,py:int,value:int):void{
			if(_enemyCost[px+"-"+py] != null && _enemyCost[px+"-"+py] >= 200)return;
			if(value == -1){
				_enemyCost[px+"-"+py] = "all";
				return;
			}
			
			_enemyCost[px+"-"+py] = value;
		}
		public function makePath(chara:LSouSouCharacterS):Array {
			_chara = chara;
			_path = [];
			var isOver:Boolean = false;
			setStart();
			_enemyCost = new Object();
			var thisChara:LSouSouCharacterS;
			if(chara.belong == LSouSouObject.BELONG_SELF || chara.belong == LSouSouObject.BELONG_FRIEND){
				for each(thisChara in LSouSouObject.sMap.enemylist){
					if(thisChara.visible){
						_enemyCost[thisChara.locationX + "-" + thisChara.locationY] = 255;
						setPathAll((thisChara.locationX - 1) , thisChara.locationY , -1);
						setPathAll((thisChara.locationX + 1) , thisChara.locationY , -1);
						setPathAll(thisChara.locationX , (thisChara.locationY - 1) , -1);
						setPathAll(thisChara.locationX , (thisChara.locationY + 1) , -1);
						trace("thisChara ",thisChara.index,thisChara.locationX + "-" + thisChara.locationY);
					}
				}
				/*
				for each(thisChara in LSouSouObject.sMap.friendlist){
					if(thisChara.visible)_enemyCost[thisChara.locationX + "-" + thisChara.locationY] = 255;
				}
				for each(thisChara in LSouSouObject.sMap.ourlist){
					if(thisChara.visible)_enemyCost[thisChara.locationX + "-" + thisChara.locationY] = 255;
				}
				*/
			}else if(chara.belong == LSouSouObject.BELONG_ENEMY){
				for each(thisChara in LSouSouObject.sMap.ourlist){
					if(thisChara.visible){
						_enemyCost[thisChara.locationX + "-" + thisChara.locationY] = 255;
						setPathAll((thisChara.locationX - 1) , thisChara.locationY , -1);
						setPathAll((thisChara.locationX + 1) , thisChara.locationY , -1);
						setPathAll(thisChara.locationX , (thisChara.locationY - 1) , -1);
						setPathAll(thisChara.locationX , (thisChara.locationY + 1) , -1);
					}
				}
				for each(thisChara in LSouSouObject.sMap.friendlist){
					if(thisChara.visible){
						_enemyCost[thisChara.locationX + "-" + thisChara.locationY] = 255;
						setPathAll((thisChara.locationX - 1) , thisChara.locationY , -1);
						setPathAll((thisChara.locationX + 1) , thisChara.locationY , -1);
						setPathAll(thisChara.locationX , (thisChara.locationY - 1) , -1);
						setPathAll(thisChara.locationX , (thisChara.locationY + 1) , -1);
					}
				}
			}
			var nodeArr:Array;
			for each(nodeArr in LSouSouObject.sMap.stageList){
				setPathAll(int(nodeArr[3]/LSouSouObject.sMap._nodeLength) ,int(nodeArr[4]/LSouSouObject.sMap._nodeLength) , nodeArr[7]);
			}
			_starPoint = _map[Math.floor(chara.locationY)][Math.floor(chara.locationX)];
			_starPoint.moveLong = chara.member.distance;
			_starPoint.moveLong += chara.statusArray[LSouSouCharacterS.STATUS_MOVE][0]?chara.statusArray[LSouSouCharacterS.STATUS_MOVE][2]:0;
			loopPath(_starPoint);
			
			return _path;
		}
		//寻路
		public function path(star:LCoordinate, end:LCoordinate,charas:LSouSouCharacterS = null):Array {
			_path = [];
			if(end.x >= _map[0].length)end.x = _map[0].length - 2;
			if(end.y >= _map.length)end.y = _map.length - 2;
			if (star.x == end.x && star.y == end.y) {
				return _path;
			}

			setStart();
			var node:Node;
			for each(node in LSouSouObject.sMap.roadList){
				_map[node.y][node.x].isRoad = true;
			}
			
			_starPoint = _map[star.y][star.x] as Node;
			_endPoint = _map[end.y][end.x] as Node;
			_open = new Array();
			_open.push(null);
			var isOver:Boolean = false;
			var thisPoint:Object = _starPoint;
			var firstCheck:Boolean = true;
			while (!isOver) {
				thisPoint.isChecked = true;
				var checkList:Array = [];
				
				if (thisPoint.y > 0) {
					checkList.push(_map[(thisPoint.y-1)][thisPoint.x]);
				}
				if (thisPoint.x > 0) {
					checkList.push(_map[thisPoint.y][(thisPoint.x-1)]);
				}
				if (thisPoint.x < _w - 1) {
					checkList.push(_map[thisPoint.y][(thisPoint.x+1)]);
				}
				if (thisPoint.y < _h - 1) {
					checkList.push(_map[(thisPoint.y+1)][thisPoint.x]);
				}
				//检测开始
				var startIndex:int = checkList.length;
				for (var i:int = 0; i<startIndex; i++) {
					//周围的每一个节点
					var checkPoint:Object = checkList[i];
					//if(_map[checkPoint.y][thisPoint.x].value==0|| _map[thisPoint.y][checkPoint.x].value==0){
					/*
					trace("checkPoint:" + checkPoint.x +","+ checkPoint.y + "=" + _map[checkPoint.y][checkPoint.x].value);
					var cc:LShape = new LShape();
					LGlobal.script.scriptLayer.addChild(cc);
					cc.graphics.beginFill(0xffffff,0.5);
					cc.graphics.lineStyle(2, 0x000000,0.8);     
					cc.graphics.drawRect(checkPoint.x*24,checkPoint.y*24,24,24);
					cc.graphics.endFill(); 
					*/
					if (_map[checkPoint.y][checkPoint.x].isRoad || 
						(charas && int(LSouSouObject.arms["Arms" + charas.arms]["Terrain"]["Terrain" + _map[checkPoint.y][checkPoint.x].value]) < 100)) {
						//if (_map[checkPoint.y][thisPoint.x].value == 0 && _map[thisPoint.y][checkPoint.x].value == 0 && _map[checkPoint.y][checkPoint.x].value == 0) {
						//如果坐标可以通过，则首先检查是不是目标点
						if (checkPoint == _endPoint) {
							//如果搜索到目标点，则结束搜索
							checkPoint.nodeparent = thisPoint;
							isOver = true;
							break;
						}
						count(checkPoint, thisPoint);
						/*
						if (checkPoint.x != thisPoint.x && checkPoint.y != thisPoint.y) {
						//斜角计算
						count(checkPoint, thisPoint,true);
						} else if (_map[checkPoint.y][checkPoint.x].value == 0) {
						//直角计算
						count(checkPoint, thisPoint);
						}
						*/
					} 
				}
				
				if (! isOver) {
					//如果未到达指定地点则取出f值最小的点作为循环点
					if (_open.length > 1) {
						//thisPoint = _open.splice(getMin(),1)[0];
						thisPoint = getOpen();
					} else {
						//开发列表为空，寻路失败
						return [];
					}
				}
			}
			//路径做成
			drawPath(_endPoint);
			
			return _path;
		}

		
	}
}