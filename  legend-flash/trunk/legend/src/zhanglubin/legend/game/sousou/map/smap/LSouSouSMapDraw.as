package zhanglubin.legend.game.sousou.map.smap
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import zhanglubin.legend.display.LBitmap;
	import zhanglubin.legend.display.LShape;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.game.sousou.character.LSouSouCharacterS;
	import zhanglubin.legend.game.sousou.meff.LSouSouMeffShow;
	import zhanglubin.legend.game.sousou.object.LSouSouObject;
	import zhanglubin.legend.game.utils.Node;
	import zhanglubin.legend.utils.LDisplay;
	import zhanglubin.legend.utils.LGlobal;
	import zhanglubin.legend.utils.math.LCoordinate;

	public class LSouSouSMapDraw
	{
		public function LSouSouSMapDraw()
		{
		}
		
		public function drawMap(mouseX:int,mouseY:int):void{
			var node:Node;
			var nodeStr:String;
			var nodeArr:Array;
			var statusBit:BitmapData;
			var meffShow:LSouSouMeffShow,i:int;
			var _characterS:LSouSouCharacterS;
			
			
			var _drawLayer:LShape = LSouSouObject.sMap.drawLayer;
			var _mapBitmapData:BitmapData = LSouSouObject.sMap.mapBitmapData;
			var _mapCoordinate:LCoordinate = LSouSouObject.sMap.mapCoordinate;
			var _minimapBitmapData:BitmapData = LSouSouObject.sMap.minimapBitmapData;
			
			_drawLayer.graphics.clear();
			
			/**画地图*/
			LSouSouObject.sMap.map.bitmapData.copyPixels(
				_mapBitmapData,
				new Rectangle(-_mapCoordinate.x,-_mapCoordinate.y,LSouSouObject.sMap.SCREEN_WIDTH,LSouSouObject.sMap.SCREEN_HEIGHT),
				new Point(0,0));
			/**画小地图*/
			LSouSouObject.sMap.miniMap.bitmapData.copyPixels(_minimapBitmapData,_minimapBitmapData.rect,new Point(5,5));
			if(mouseX < 300){
				LSouSouObject.sMap.miniWindow.x = LSouSouObject.sMap.SCREEN_WIDTH - LSouSouObject.sMap.miniMap.width;
			}else if(mouseX > 500){
				LSouSouObject.sMap.miniWindow.x = 0;
			}
			/**画人物*/
			for each(_characterS in LSouSouObject.sMap.ourlist){
				if(!_characterS.visible)continue;
				_characterS.onFrame();
				drawMiniMap(_characterS);
				/**判断是否需要绘制人物*/
				if(_characterS.x + _mapCoordinate.x >= 0 && _characterS.x + _mapCoordinate.x < LSouSouObject.sMap.SCREEN_WIDTH &&
					_characterS.y + _mapCoordinate.y >= 0 && _characterS.y + _mapCoordinate.y < LSouSouObject.sMap.SCREEN_HEIGHT){
				
					if(_characterS.action_mode == LSouSouCharacterS.MODE_STOP)_characterS.colorTrans(-70);
					if(_characterS.action_mode == LSouSouCharacterS.MODE_BREAKOUT)_characterS.colorTrans(100);
					LSouSouObject.sMap.map.bitmapData.copyPixels(_characterS.bitmapData,
						new Rectangle(0,0,_characterS.width,_characterS.height),
						new Point(_characterS.x + _mapCoordinate.x + _characterS.point.x,
							_characterS.y + _mapCoordinate.y + (LSouSouObject.sMap.nodeLength - _characterS.height)/2));
					statusBit = _characterS.drawStatus();
					if(statusBit)LSouSouObject.sMap.map.bitmapData.copyPixels(statusBit,statusBit.rect,
						new Point(_characterS.x + _mapCoordinate.x + _characterS.point.x + _characterS.statusX,
							_characterS.y + _mapCoordinate.y + (LSouSouObject.sMap.nodeLength - _characterS.height)/2));
					//船
					if(LSouSouObject.sMap.mapData[_characterS.locationY][_characterS.locationX] == 13)
						LSouSouObject.sMap.map.bitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["stage"],"boatmask"+(_characterS.animation.currentframe + 2) % 2),
							new Rectangle(0,0,_characterS.width,_characterS.height),
							new Point(_characterS.x + _mapCoordinate.x + _characterS.point.x,
								_characterS.y + _mapCoordinate.y + (LSouSouObject.sMap.nodeLength - _characterS.height)/2));
				}
			}
			
			for each(_characterS in LSouSouObject.sMap.enemylist){
				if(!_characterS.visible)continue;
				_characterS.onFrame();
				drawMiniMap(_characterS);
				/**判断是否需要绘制人物*/
				if(_characterS.x + _mapCoordinate.x >= 0 && _characterS.x + _mapCoordinate.x < LSouSouObject.sMap.SCREEN_WIDTH &&
					_characterS.y + _mapCoordinate.y >= 0 && _characterS.y + _mapCoordinate.y < LSouSouObject.sMap.SCREEN_HEIGHT){
					
					if(_characterS.action_mode == LSouSouCharacterS.MODE_STOP)_characterS.colorTrans(-70);
					if(_characterS.action_mode == LSouSouCharacterS.MODE_BREAKOUT)_characterS.colorTrans(100);
					LSouSouObject.sMap.map.bitmapData.copyPixels(_characterS.bitmapData,
						new Rectangle(0,0,_characterS.width,_characterS.height),
						new Point(_characterS.x + _mapCoordinate.x + _characterS.point.x,
							_characterS.y + _mapCoordinate.y + _characterS.point.y));
					statusBit = _characterS.drawStatus();
					if(statusBit)LSouSouObject.sMap.map.bitmapData.copyPixels(statusBit,statusBit.rect,
						new Point(_characterS.x + _mapCoordinate.x + _characterS.point.x + _characterS.statusX,
							_characterS.y + _mapCoordinate.y + (LSouSouObject.sMap.nodeLength - _characterS.height)/2));
					//船
					if(LSouSouObject.sMap.mapData[_characterS.locationY][_characterS.locationX] == 13)
						LSouSouObject.sMap.map.bitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["stage"],"boatmask" + (_characterS.animation.currentframe + 2) % 2),
							new Rectangle(0,0,_characterS.width,_characterS.height),
							new Point(_characterS.x + _mapCoordinate.x + _characterS.point.x,
								_characterS.y + _mapCoordinate.y + (LSouSouObject.sMap.nodeLength - _characterS.height)/2));
				}
			}
			for each(_characterS in LSouSouObject.sMap.friendlist){
				if(!_characterS.visible)continue;
				_characterS.onFrame();
				drawMiniMap(_characterS);
				/**判断是否需要绘制人物*/
				if(_characterS.x + _mapCoordinate.x >= 0 && _characterS.x + _mapCoordinate.x < LSouSouObject.sMap.SCREEN_WIDTH &&
					_characterS.y + _mapCoordinate.y >= 0 && _characterS.y + _mapCoordinate.y < LSouSouObject.sMap.SCREEN_HEIGHT){
					
					if(_characterS.action_mode == LSouSouCharacterS.MODE_STOP)_characterS.colorTrans(-70);
					if(_characterS.action_mode == LSouSouCharacterS.MODE_BREAKOUT)_characterS.colorTrans(100);
					LSouSouObject.sMap.map.bitmapData.copyPixels(_characterS.bitmapData,
						new Rectangle(0,0,_characterS.width,_characterS.height),
						new Point(_characterS.x + _mapCoordinate.x + _characterS.point.x,
							_characterS.y + _mapCoordinate.y + (LSouSouObject.sMap.nodeLength - _characterS.height)/2));
					statusBit = _characterS.drawStatus();
					if(statusBit)LSouSouObject.sMap.map.bitmapData.copyPixels(statusBit,statusBit.rect,
						new Point(_characterS.x + _mapCoordinate.x + _characterS.point.x + _characterS.statusX,
							_characterS.y + _mapCoordinate.y + (LSouSouObject.sMap.nodeLength - _characterS.height)/2));
					//船
					if(LSouSouObject.sMap.mapData[_characterS.locationY][_characterS.locationX] == 13)
						LSouSouObject.sMap.map.bitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["stage"],"boatmask" + (_characterS.animation.currentframe + 2) % 2),
							new Rectangle(0,0,_characterS.width,_characterS.height),
							new Point(_characterS.x + _mapCoordinate.x + _characterS.point.x,
								_characterS.y + _mapCoordinate.y + (LSouSouObject.sMap.nodeLength - _characterS.height)/2));
				}
			}
			//小地图框架
			LSouSouObject.addBoxBitmapdata(LSouSouObject.sMap.miniMap.bitmapData);
			
			/**画法术*/
			if(LSouSouObject.sMap.meff != null){
				LSouSouObject.sMap.meff.onFrame();
				var meffarr:Array;
				for each(meffarr in LSouSouObject.sMap.meff.animationList){
					LSouSouObject.sMap.map.bitmapData.copyPixels(meffarr[0].dataBMP,meffarr[0].dataBMP.rect,
						new Point(LSouSouObject.sMap.meff.x + meffarr[2] + _mapCoordinate.x,LSouSouObject.sMap.meff.y + meffarr[3] + _mapCoordinate.y));
				}
				
				LSouSouObject.sMap.meff.checkOver();
			}
			/**画绝招*/
			if(LSouSouObject.sMap.skill != null){
				LSouSouObject.sMap.map.bitmapData.copyPixels(LSouSouObject.sMap.skill.bitmapData,LSouSouObject.sMap.skill.bitmapData.rect,
					new Point(LSouSouObject.sMap.skill.x,LSouSouObject.sMap.skill.y));
				LSouSouObject.sMap.skill.onFrame();
			}
			/**画法术演示*/
			i=0;
			for each(meffShow in LSouSouObject.sMap.meffShowList){
				LSouSouObject.sMap.map.bitmapData.copyPixels(meffShow.bitmapData,meffShow.bitmapData.rect,
					new Point(meffShow.x + _mapCoordinate.x,meffShow.y + _mapCoordinate.y));
				meffShow.onFrame(i);
				i++;
			}
			/**画路径*/
			if(LSouSouObject.sMap.roadList != null){
				for each(node in LSouSouObject.sMap.roadList){
					LDisplay.drawRect(_drawLayer.graphics,
						[node.x*LSouSouObject.sMap.nodeLength + _mapCoordinate.x,node.y*LSouSouObject.sMap.nodeLength + _mapCoordinate.y,
							LSouSouObject.sMap.nodeLength-1,LSouSouObject.sMap.nodeLength-1],
						true,0x0000FF,0.5,3);
				}
				for each(nodeStr in LSouSouObject.charaSNow.rangeAttack){
					nodeArr = nodeStr.split(",");
					LDisplay.drawRect(_drawLayer.graphics,
						[LSouSouObject.charaSNow.x + nodeArr[0]*LSouSouObject.sMap.nodeLength + _mapCoordinate.x,
							LSouSouObject.charaSNow.y + nodeArr[1]*LSouSouObject.sMap.nodeLength + _mapCoordinate.y,
							LSouSouObject.sMap.nodeLength,LSouSouObject.sMap.nodeLength],
						false,0xFF0000,0.5,5);
				}
			}else if(LSouSouObject.sMap.attackRange != null){
				for each(nodeStr in LSouSouObject.sMap.attackRange){
					nodeArr = nodeStr.split(",");
					LDisplay.drawRect(_drawLayer.graphics,
						[LSouSouObject.charaSNow.x + nodeArr[0]*LSouSouObject.sMap.nodeLength + _mapCoordinate.x,
							LSouSouObject.charaSNow.y + nodeArr[1]*LSouSouObject.sMap.nodeLength + _mapCoordinate.y,
							LSouSouObject.sMap.nodeLength-1,LSouSouObject.sMap.nodeLength-1],
						true,0xFF0000,0.5,1);
				}
				for each(nodeStr in LSouSouObject.sMap.attackTargetRange){
					nodeArr = nodeStr.split(",");
					LDisplay.drawRect(_drawLayer.graphics,
						[int(mouseX/LSouSouObject.sMap.nodeLength)*LSouSouObject.sMap.nodeLength + nodeArr[0]*LSouSouObject.sMap.nodeLength,
							int(mouseY/LSouSouObject.sMap.nodeLength)*LSouSouObject.sMap.nodeLength + nodeArr[1]*LSouSouObject.sMap.nodeLength,
							LSouSouObject.sMap.nodeLength,LSouSouObject.sMap.nodeLength],
						false,0xFF0000,1,2);
				}
			}else if(LSouSouObject.sMap.strategy != null && LSouSouObject.sMap.meff == null && LSouSouObject.charaSNow.belong == LSouSouObject.BELONG_SELF){
				for each(nodeStr in LSouSouObject.sMap.strategy.Range.elements()){
					nodeArr = nodeStr.split(",");
					LDisplay.drawRect(_drawLayer.graphics,
						[LSouSouObject.charaSNow.x + nodeArr[0]*LSouSouObject.sMap.nodeLength + _mapCoordinate.x,
							LSouSouObject.charaSNow.y + nodeArr[1]*LSouSouObject.sMap.nodeLength + _mapCoordinate.y,
							LSouSouObject.sMap.nodeLength-1,LSouSouObject.sMap.nodeLength-1],
						true,0xFF0000,0.5,1);
				}
				for each(nodeStr in LSouSouObject.sMap.strategy.Att.elements()){
					nodeArr = nodeStr.split(",");
					LDisplay.drawRect(_drawLayer.graphics,
						[int(mouseX/LSouSouObject.sMap.nodeLength)*LSouSouObject.sMap.nodeLength + nodeArr[0]*LSouSouObject.sMap.nodeLength,
							int(mouseY/LSouSouObject.sMap.nodeLength)*LSouSouObject.sMap.nodeLength + nodeArr[1]*LSouSouObject.sMap.nodeLength,
							LSouSouObject.sMap.nodeLength,LSouSouObject.sMap.nodeLength],
						false,0xFF0000,1,2);
				}
			}
			/**画方框*/
			if(mouseX<LSouSouObject.sMap.SCREEN_WIDTH)
				LDisplay.drawRect(
					_drawLayer.graphics,
					[int(mouseX/LSouSouObject.sMap.nodeLength)*LSouSouObject.sMap.nodeLength,int(mouseY/LSouSouObject.sMap.nodeLength)*LSouSouObject.sMap.nodeLength,LSouSouObject.sMap.nodeLength,LSouSouObject.sMap.nodeLength],
					false,0xffffff,0.8,3);
			/**画战场物件*/
			if(LSouSouObject.sMap.stageList.length > 0){
				////战场物件，火，船等[icon,index,maxindex,x，y，fun,stageindex]
				for each(nodeArr in LSouSouObject.sMap.stageList){
					var stageImg:BitmapData = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["stage"],nodeArr[0] + nodeArr[1]);
					var upX:int = int((stageImg.width/2)/LSouSouObject.sMap.nodeLength)*LSouSouObject.sMap.nodeLength;
					var upY:int = int((stageImg.height/2)/LSouSouObject.sMap.nodeLength)*LSouSouObject.sMap.nodeLength;
					LSouSouObject.sMap.map.bitmapData.copyPixels(stageImg,stageImg.rect,	
						new Point(nodeArr[3] + _mapCoordinate.x - upX,nodeArr[4] + _mapCoordinate.y - upY));
					nodeArr[1] = int(nodeArr[1]) + 1;
					if(int(nodeArr[1]) > nodeArr[2])(nodeArr[5] as Function)(nodeArr);
				}
			}
			/**画伤害值等*/
			if(LSouSouObject.sMap.numList.length > 0)drawNum();
			
			/**画回合*/
			if(LSouSouObject.sMap.roundCtrl)LSouSouObject.sMap.roundShow();
			
			/**画menu*/
			if(LSouSouObject.sMap.menu != null){
				LSouSouObject.sMap.sMenu.onMove(LSouSouObject.sMap.menu,mouseX,mouseY);
			}
			/**画单条*/
			if(LSouSouObject.window != null && LSouSouObject.window.name == "singled"){
				LSouSouObject.window.windowSingled.draw();
			}
		}
		private function drawNum():void{
			var i:int,j:int;
			var child:Array;
			var numStr:String;
			var numBitmap:BitmapData;
			for(i=0;i<LSouSouObject.sMap.numList.length;i++){
				child = LSouSouObject.sMap.numList[i];
				numStr = child[0];
				for(j=0;j<numStr.length;j++){
					numBitmap = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],numStr.charAt(j) + ".png");
					LSouSouObject.sMap.map.bitmapData.copyPixels(numBitmap,numBitmap.rect,new Point(child[1] + j*20,child[2]));
				}
				child[2] = int(child[2]) - 2;
				child[3] = int(child[3]) + 1;
				if(int(child[3]) > 10){
					LSouSouObject.sMap.numList.splice(i,1);
					i--;
				}
			}
		}
		private function drawMiniMap(charas:LSouSouCharacterS):void{
			if(charas.belong == LSouSouObject.BELONG_SELF){
				LSouSouObject.sMap.miniMap.bitmapData.copyPixels(LSouSouObject.sMap.miniSelf,LSouSouObject.sMap.miniSelf.rect,new Point(LSouSouObject.sMap.miniCoordinate + charas.x*LSouSouObject.sMap.miniCoordinate,LSouSouObject.sMap.miniCoordinate + charas.y*LSouSouObject.sMap.miniScale));
			}else if(charas.belong == LSouSouObject.BELONG_FRIEND){
				LSouSouObject.sMap.miniMap.bitmapData.copyPixels(LSouSouObject.sMap.miniSelf,LSouSouObject.sMap.miniFriend.rect,new Point(LSouSouObject.sMap.miniCoordinate + charas.x*LSouSouObject.sMap.miniScale,LSouSouObject.sMap.miniCoordinate + charas.y*LSouSouObject.sMap.miniScale));
			}else {
				LSouSouObject.sMap.miniMap.bitmapData.copyPixels(LSouSouObject.sMap.miniEnemy,LSouSouObject.sMap.miniEnemy.rect,new Point(LSouSouObject.sMap.miniCoordinate + charas.x*LSouSouObject.sMap.miniScale,LSouSouObject.sMap.miniCoordinate + charas.y*LSouSouObject.sMap.miniScale));
			}
		}
	}
}