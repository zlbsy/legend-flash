package zhanglubin.legend.game.sousou.map
{
	import zhanglubin.legend.display.LShape;
	import zhanglubin.legend.game.utils.LStarQuery;
	import zhanglubin.legend.game.utils.Node;
	import zhanglubin.legend.utils.LGlobal;
	import zhanglubin.legend.utils.math.LCoordinate;

	public class LSouSouStarR extends LStarQuery
	{
		public function LSouSouStarR(map:Array) {
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
		//寻路
		public function path(star:LCoordinate, end:LCoordinate):Array {
			
			_path = [];
			if(end.x >= _map[0].length)end.x = _map[0].length - 2;
			if(end.y >= _map.length)end.y = _map.length - 2;
			if (star.x == end.x && star.y == end.y) {
				return _path;
			}

			setStart();
			//trace("LSouSouStarR star = ",star.x,star.y);
			//trace("LSouSouStarR end = ",end.x,end.y);
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
				
				if (thisPoint.x > 0 && thisPoint.y > 0) {
					checkList.push(_map[(thisPoint.y-1)][thisPoint.x - 1]);
				}
				if (thisPoint.x < _w - 1 && thisPoint.y < _h - 1) {
					checkList.push(_map[thisPoint.y + 1][(thisPoint.x+1)]);
				}
				if (thisPoint.x > 0 && thisPoint.y < _h - 1) {
					checkList.push(_map[(thisPoint.y+1)][thisPoint.x - 1]);
				}
				if (thisPoint.x < _w - 1 && thisPoint.y > 0) {
					checkList.push(_map[(thisPoint.y-1)][thisPoint.x + 1]);
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
					if (_map[checkPoint.y][checkPoint.x].value == 0 || _map[checkPoint.y][checkPoint.x].isRoad) {
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