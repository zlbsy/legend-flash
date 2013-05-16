package zhanglubin.legend.game.sousou.map.smap
{
	import zhanglubin.legend.game.sousou.character.LSouSouCharacterS;
	import zhanglubin.legend.game.sousou.map.LSouSouWindow;
	import zhanglubin.legend.game.sousou.map.window.LSouSouWindwoTerrain;
	import zhanglubin.legend.game.sousou.object.LSouSouCalculate;
	import zhanglubin.legend.game.sousou.object.LSouSouObject;
	import zhanglubin.legend.game.utils.Node;
	import zhanglubin.legend.utils.LGlobal;

	public class LSouSouSMapClick
	{
		public function LSouSouSMapClick()
		{
		}
		
		private function findRoad(mx:int,my:int):void{
			var intX:int = int((mx - LSouSouObject.sMap.mapCoordinate.x)/LSouSouObject.sMap.nodeLength);
			var intY:int = int((my - LSouSouObject.sMap.mapCoordinate.y)/LSouSouObject.sMap.nodeLength);
			var isRoad:Boolean;
			var node:Node;
			var _characterS:LSouSouCharacterS;
			for each(node in LSouSouObject.sMap.roadList){
				for each(_characterS in LSouSouObject.sMap.ourlist){
					if(_characterS.visible && _characterS.index != LSouSouObject.charaSNow.index && _characterS.locationX == intX && _characterS.locationY == intY){
						return;
					}
				}
				for each(_characterS in LSouSouObject.sMap.friendlist){
					if(_characterS.visible && _characterS.locationX == intX && _characterS.locationY == intY){
						return;
					}
				}
				if(mx >= node.x*LSouSouObject.sMap.nodeLength + LSouSouObject.sMap.mapCoordinate.x && 
					mx < node.x*LSouSouObject.sMap.nodeLength + LSouSouObject.sMap.mapCoordinate.x + LSouSouObject.sMap.nodeLength && 
					my >= node.y*LSouSouObject.sMap.nodeLength + LSouSouObject.sMap.mapCoordinate.y && 
					my < node.y*LSouSouObject.sMap.nodeLength + LSouSouObject.sMap.mapCoordinate.y + LSouSouObject.sMap.nodeLength){
					isRoad = true;
					break;
				}
			}
			
			if(!isRoad)return;
			//LSouSouObject.charaSNow.tagerCoordinate = new LCoordinate(LSouSouObject.charaSNow.locationX,LSouSouObject.charaSNow.locationY);
			LSouSouObject.sMap.moveToCoordinate(mx,my);
		}
		private function findAttackTarget(mx:int,my:int):void{
			var nodeStr:String;
			var nodeArr:Array;
			var _characterS:LSouSouCharacterS;
			var intX:int = int((mx - LSouSouObject.sMap.mapCoordinate.x)/LSouSouObject.sMap.nodeLength);
			var intY:int = int((my - LSouSouObject.sMap.mapCoordinate.y)/LSouSouObject.sMap.nodeLength);
			for each(nodeStr in LSouSouObject.sMap.attackRange){
				nodeArr = nodeStr.split(",");
				if(mx >= LSouSouObject.charaSNow.x + nodeArr[0]*LSouSouObject.sMap.nodeLength + LSouSouObject.sMap.mapCoordinate.x && 
					mx < LSouSouObject.charaSNow.x + nodeArr[0]*LSouSouObject.sMap.nodeLength + LSouSouObject.sMap.mapCoordinate.x + LSouSouObject.sMap.nodeLength &&
					my >= LSouSouObject.charaSNow.y + nodeArr[1]*LSouSouObject.sMap.nodeLength + LSouSouObject.sMap.mapCoordinate.y && 
					my < LSouSouObject.charaSNow.y + nodeArr[1]*LSouSouObject.sMap.nodeLength + LSouSouObject.sMap.mapCoordinate.y + LSouSouObject.sMap.nodeLength){
					if(LSouSouObject.charaSNow.belong == LSouSouObject.BELONG_SELF){
						
						for each(_characterS in LSouSouObject.sMap.enemylist){
							if(_characterS.visible && _characterS.locationX == intX && _characterS.locationY == intY){
								LSouSouObject.sMap.attackRange = null;
								LSouSouObject.sMap.cancel_menu.removeAllEventListener();
								LSouSouObject.sMap.cancel_menu.visible = false;
								LSouSouObject.charaSNow.targetCharacter = _characterS;
								LSouSouObject.charaSNow.setAttackNumber();
								LSouSouObject.charaSNow.attackCalculate();
								return;
							}
						}
					}
				}
			}
			
		}
		/**
		 * 鼠标弹起事件
		 * 
		 * @param event 鼠标事件
		 */
		public function onUp(mouseX:int,mouseY:int):void{
			var _characterS:LSouSouCharacterS;
			var charaList:Vector.<LSouSouCharacterS>;
			var getcharacter:Boolean;
			var nodeStr:String;
			var nodeArr:Array;
			var window:LSouSouWindow;
			LSouSouObject.sMap.mouseIsDown = false;
			if(LSouSouObject.sMap.roadList != null){
				findRoad(mouseX,mouseY);
			}else if(LSouSouObject.sMap.attackRange != null){
				findAttackTarget(mouseX,mouseY);
			}else if(LSouSouObject.sMap.props != null){
				charaList = new Vector.<LSouSouCharacterS>();
				
				for each(_characterS in LSouSouObject.sMap.ourlist){
					if(!_characterS.visible || _characterS.member.troops == 0)continue;
					charaList.push(_characterS);
				}
				for each(_characterS in LSouSouObject.sMap.friendlist){
					if(!_characterS.visible || _characterS.member.troops == 0)continue;
					charaList.push(_characterS);
				}
				
				for each(_characterS in charaList){
					if(!_characterS.visible)continue;
					if(mouseX > _characterS.x + LSouSouObject.sMap.mapCoordinate.x && 
						mouseX < _characterS.x + LSouSouObject.sMap.mapCoordinate.x + LSouSouObject.sMap.nodeLength && 
						mouseY > _characterS.y + LSouSouObject.sMap.mapCoordinate.y && 
						mouseY < _characterS.y + LSouSouObject.sMap.mapCoordinate.y + LSouSouObject.sMap.nodeLength){
						getcharacter = true;
						if(mouseX > LSouSouObject.charaSNow.x + LSouSouObject.sMap.mapCoordinate.x - LSouSouObject.sMap.nodeLength && 
							mouseX < LSouSouObject.charaSNow.x + LSouSouObject.sMap.mapCoordinate.x + 2*LSouSouObject.sMap.nodeLength
							&& mouseY > LSouSouObject.charaSNow.y + LSouSouObject.sMap.mapCoordinate.y - LSouSouObject.sMap.nodeLength && 
							mouseY < LSouSouObject.charaSNow.y + LSouSouObject.sMap.mapCoordinate.y + 2*LSouSouObject.sMap.nodeLength){
							LSouSouObject.charaSNow.targetCharacter = _characterS;
							
							var xmllist:XML;
							var ishava:Boolean;
							for each(xmllist in LSouSouObject.propsList.elements()){
								if(int(xmllist.@index) == int(LSouSouObject.sMap.props.index.toString())){
									xmllist.@num = int(xmllist.@num) - 1;
									ishava = true;
									break;
								}
							}
							LSouSouObject.sMap.cancel_menu.removeAllEventListener();
							LSouSouObject.sMap.cancel_menu.visible = false;
							LSouSouObject.charaSNow.propsCalculate();
							break;
						}
						if(getcharacter)break;
					}
				}
				
			}else if(LSouSouObject.sMap.strategy != null){
				var intX:int = int((mouseX - LSouSouObject.sMap.mapCoordinate.x)/LSouSouObject.sMap.nodeLength);
				var intY:int = int((mouseY - LSouSouObject.sMap.mapCoordinate.y)/LSouSouObject.sMap.nodeLength);
				if(!LSouSouCalculate.canUseMeff(intX,intY,LSouSouObject.sMap.strategy)){
					window = new LSouSouWindow();
					window.setMsg(["此地形无法使用",1,30]);
					LGlobal.script.scriptLayer.addChild(window);
					return;
				}
				
				if(LSouSouObject.sMap.strategy.Belong == 1){
					charaList = LSouSouObject.sMap.enemylist;
				}else if(LSouSouObject.sMap.strategy.Belong == 0){
					
					charaList = new Vector.<LSouSouCharacterS>();
					
					for each(_characterS in LSouSouObject.sMap.ourlist){
						if(!_characterS.visible || _characterS.member.troops == 0)continue;
						charaList.push(_characterS);
					}
					for each(_characterS in LSouSouObject.sMap.friendlist){
						if(!_characterS.visible || _characterS.member.troops == 0)continue;
						charaList.push(_characterS);
					}
				}
				for each(_characterS in charaList){
					if(!_characterS.visible)continue;
					if(mouseX > _characterS.x + LSouSouObject.sMap.mapCoordinate.x 
						&& mouseX < _characterS.x + LSouSouObject.sMap.mapCoordinate.x + LSouSouObject.sMap.nodeLength && 
						mouseY > _characterS.y + LSouSouObject.sMap.mapCoordinate.y && 
						mouseY < _characterS.y + LSouSouObject.sMap.mapCoordinate.y + LSouSouObject.sMap.nodeLength){
						getcharacter = true;
						
						for each(nodeStr in LSouSouObject.sMap.strategy.Range.elements()){
							nodeArr = nodeStr.split(",");
							if(LSouSouObject.charaSNow.locationX  + int(nodeArr[0]) == _characterS.locationX && 
								LSouSouObject.charaSNow.locationY + int( nodeArr[1]) == _characterS.locationY){
								if(!LSouSouCalculate.belongMeff(_characterS)){
									return;
								}else{
									LSouSouObject.sMap.cancel_menu.removeAllEventListener();
									LSouSouObject.sMap.cancel_menu.visible = false;
									LSouSouObject.charaSNow.targetCharacter = _characterS;
									LSouSouObject.charaSNow.strategyAttackCalculate();
								}
								break;
							}
						}
						if(getcharacter)break;
					}
				}
			}else{
				var isChara:Boolean;
				if(LSouSouObject.sMap.menu != null){
					LSouSouObject.sMap.sMenu.onClick(LSouSouObject.sMap.menu,mouseX,mouseY);
				}else{
					var sx:int;
					var sy:int;
					var act:int;
					//是否点击我军
					for each(_characterS in LSouSouObject.sMap.ourlist){
						if(!_characterS.visible)continue;
						if(mouseX > _characterS.x + LSouSouObject.sMap.mapCoordinate.x && mouseX < _characterS.x + LSouSouObject.sMap.mapCoordinate.x + LSouSouObject.sMap.nodeLength && 
							mouseY > _characterS.y + LSouSouObject.sMap.mapCoordinate.y && mouseY < _characterS.y + LSouSouObject.sMap.mapCoordinate.y + LSouSouObject.sMap.nodeLength){
							LSouSouObject.charaSNow = _characterS;
							
							sx = LSouSouObject.charaSNow.x;
							sy = LSouSouObject.charaSNow.y;
							act = LSouSouObject.charaSNow.action;
							LSouSouObject.returnFunction = function ():void{
								LSouSouObject.charaSNow.x = sx;
								LSouSouObject.charaSNow.y = sy;
								LSouSouObject.charaSNow.action = act;
								LSouSouObject.charaSNow.tagerCoordinate=LSouSouObject.charaSNow.xy; 
								
								LSouSouObject.sMap.menu = LSouSouObject.sMap.sMenu.addSMenu(LSouSouObject.charaSNow.xy,"select");
								LSouSouObject.sMap.menuLayer.addChild(LSouSouObject.sMap.menu);
							}
							LSouSouObject.returnFunction();
							return;
						}
					}
					//是否点击友军
					for each(_characterS in LSouSouObject.sMap.friendlist){
						if(!_characterS.visible)continue;
						if(mouseX > _characterS.x + LSouSouObject.sMap.mapCoordinate.x && 
							mouseX < _characterS.x + LSouSouObject.sMap.mapCoordinate.x + LSouSouObject.sMap.nodeLength && 
							mouseY > _characterS.y + LSouSouObject.sMap.mapCoordinate.y 
							&& mouseY < _characterS.y + LSouSouObject.sMap.mapCoordinate.y + LSouSouObject.sMap.nodeLength){
							LSouSouObject.charaSNow = _characterS;
							
							sx = LSouSouObject.charaSNow.x;
							sy = LSouSouObject.charaSNow.y;
							act = LSouSouObject.charaSNow.action;
							LSouSouObject.returnFunction = function ():void{
								LSouSouObject.charaSNow.x = sx;
								LSouSouObject.charaSNow.y = sy;
								LSouSouObject.charaSNow.action = act;
								LSouSouObject.charaSNow.tagerCoordinate=LSouSouObject.charaSNow.xy; 
								
								LSouSouObject.sMap.menu = LSouSouObject.sMap.sMenu.addSMenu(LSouSouObject.charaSNow.xy,"select");
								LSouSouObject.sMap.menuLayer.addChild(LSouSouObject.sMap.menu);
							}
							LSouSouObject.returnFunction();
							return;
						}
					}
					//是否点击敌军
					for each(_characterS in LSouSouObject.sMap.enemylist){
						if(!_characterS.visible)continue;
						if(mouseX > _characterS.x + LSouSouObject.sMap.mapCoordinate.x && 
							mouseX < _characterS.x + LSouSouObject.sMap.mapCoordinate.x + LSouSouObject.sMap.nodeLength && 
							mouseY > _characterS.y + LSouSouObject.sMap.mapCoordinate.y && 
							mouseY < _characterS.y + LSouSouObject.sMap.mapCoordinate.y + LSouSouObject.sMap.nodeLength){
							LSouSouObject.charaSNow = _characterS;
							
							sx = LSouSouObject.charaSNow.x;
							sy = LSouSouObject.charaSNow.y;
							act = LSouSouObject.charaSNow.action;
							LSouSouObject.returnFunction = function ():void{
								LSouSouObject.charaSNow.x = sx;
								LSouSouObject.charaSNow.y = sy;
								LSouSouObject.charaSNow.action = act;
								LSouSouObject.charaSNow.tagerCoordinate=LSouSouObject.charaSNow.xy; 
								
								LSouSouObject.sMap.menu = LSouSouObject.sMap.sMenu.addSMenu(LSouSouObject.charaSNow.xy,"select");
								LSouSouObject.sMap.menuLayer.addChild(LSouSouObject.sMap.menu);
							}
							LSouSouObject.returnFunction();
							return;
						}
					}
					//点击战场，显示地形
					if(LSouSouObject.storyCtrl || LSouSouObject.sMap.menu || LSouSouObject.sMap.mapIsMove || mouseX > 760)return;
					
					window = new LSouSouWindwoTerrain();
					(window as LSouSouWindwoTerrain).show(mouseX,mouseY);
					LGlobal.script.scriptLayer.addChild(window);
				}
			}
		}

	}
}