package com.lufylegend.legend.game.utils
{
	import com.lufylegend.legend.utils.math.LCoordinate;

	public class LStarQuery
	{
		public var _map:Array;//地图
		public var _w:int;//地图的宽
		public var _h:int;//地图的高
		public var _open:Array;//开放列表
		public var _starPoint:Object;//起点
		public var _endPoint:Object;//目标点
		public var _path:Array;//计算出的路径
		public var _enemyCost:Object;
		
		public function LStarQuery()
		{
		}
		
		//路径做成
		public function drawPath(node:Object):void {
			var pathNode:Object = node;
			//倒过来得到路径
			while (pathNode != _starPoint) {
				_path.unshift(pathNode);
				pathNode = pathNode.nodeparent;
			}
			//_path.unshift(pathNode);
		}
		//寻路前的初始化
		public function setStart():void {
			for (var y:int=0; y<_h; y++) {
				for (var x:int=0; x<_w; x++) {
					_map[y][x].open = false;
					_map[y][x].isChecked = false;
					_map[y][x].value_g = 0;
					_map[y][x].value_h = 0;
					_map[y][x].value_f = 0;
					_map[y][x].nodeparent = null;
					_map[y][x].index = -1;
					_map[y][x].moveLong = 0;
					_map[y][x].isRoad = false;
				}
			}
			_open = [];
		}
		
		//计算每个节点
		public function count(neighboringNode:Object, centerNode:Object, eight:Boolean=false):void {
			//是否已经检测过
			if (! neighboringNode.isChecked) {
				//不在关闭列表里才开始判断
				var g:Number = eight ? centerNode.value_g + 14:centerNode.value_g + 10;
				if (neighboringNode.open) {
					//如果该节点已经在开放列表里
					if (neighboringNode.value_g >= g) {
						//如果新G值小于或者等于旧值，则表明该路更优，更新其值
						neighboringNode.value_g = g;
						ghf(neighboringNode);
						neighboringNode.nodeparent = centerNode;
						
						setOpen(neighboringNode);
					}
				} else {
					//如果该节点未在开放列表里
					//计算GHF值
					neighboringNode.value_g = g;
					ghf(neighboringNode);
					neighboringNode.nodeparent = centerNode;
					//添加至列表
					setOpen(neighboringNode,true);
				}
			}
		}
		
		//计算ghf各值
		public function ghf(node:Object):void {
			var dx:Number = Math.abs(node.x - _endPoint.x);
			var dy:Number = Math.abs(node.y - _endPoint.y);
			node.value_h = 10*(dx+dy);
			node.value_f = node.value_g + node.value_h;
		}
		//加入开放列表
		public function setOpen(newNode:Object,newFlg:Boolean = false):void {
			var new_index:int;
			if (newFlg) {
				newNode.open = true;
				var new_f:int = newNode.value_f;
				_open.push(newNode);
				new_index = _open.length - 1;
			} else {
				new_index = newNode.index;
			}
			while (true) {
				//找到父节点
				var f_note_index:int = new_index / 2;
				if (f_note_index > 0) {
					//如果父节点的F值较大，则与父节点交换
					if (_open[new_index].value_f < _open[f_note_index].value_f) {
						var obj_note:Object = _open[f_note_index];
						_open[f_note_index] = _open[new_index];
						_open[new_index] = obj_note;
						
						_open[f_note_index].index = f_note_index;
						_open[new_index].index = new_index;
						new_index = f_note_index;
					} else {
						break;
					}
				} else {
					break;
				}
			}
			
		}
		
		//取开放列表里的最小值
		public function getOpen():Object {
			var change_note:Object;
			//将第一个节点，即F值最小的节点取出，最后返回
			var obj_note:Object = _open[1];
			_open[1] = _open[_open.length - 1];
			_open[1].index = 1;
			_open.pop();
			var this_index:int = 1;
			while (true) {
				var left_index:int = this_index * 2;
				var right_index:int = this_index * 2 + 1;
				if (left_index >= _open.length) {
					break;
				} else if (left_index == _open.length - 1) {
					//当二叉树只存在左节点时，比较左节点和父节点的F值，若父节点较大，则交换
					if (_open[this_index].value_f > _open[left_index].value_f) {
						change_note = _open[left_index];
						_open[left_index] = _open[this_index];
						_open[this_index] = change_note;
						
						_open[left_index].index = left_index;
						_open[this_index].index = this_index;
						
						this_index = left_index;
					} else {
						break;
					}
				} else if (right_index < _open.length) {
					//找到左节点和右节点中的较小者
					if (_open[left_index].value_f <= _open[right_index].value_f) {
						//比较左节点和父节点的F值，若父节点较大，则交换
						if (_open[this_index].value_f > _open[left_index].value_f) {
							change_note = _open[left_index];
							_open[left_index] = _open[this_index];
							_open[this_index] = change_note;
							
							_open[left_index].index = left_index;
							_open[this_index].index = this_index;
							
							this_index = left_index;
						} else {
							break;
						}
					} else {
						//比较右节点和父节点的F值，若父节点较大，则交换
						if (_open[this_index].value_f > _open[right_index].value_f) {
							change_note = _open[right_index];
							_open[right_index] = _open[this_index];
							_open[this_index] = change_note;
							
							_open[right_index].index = right_index;
							_open[this_index].index = this_index;
							
							this_index = right_index;
						} else {
							break;
						}
					}
				}
			}
			return obj_note;
		}
	}
}