package zhanglubin.legend.game.sousou.character.characterS
{
	import flash.display.Bitmap;
	
	import zhanglubin.legend.game.sousou.character.LSouSouCharacterS;
	import zhanglubin.legend.game.sousou.object.LSouSouCalculate;
	import zhanglubin.legend.game.sousou.object.LSouSouObject;
	import zhanglubin.legend.game.utils.Node;
	import zhanglubin.legend.utils.math.LCoordinate;

	/**
	 * 战场人物AI处理类
	 * */
	public class LSouSouCharacterSAI
	{
		private static var _charalist:Array;
		public function LSouSouCharacterSAI()
		{
		}
		private static function setSupply(charasSupply:Array,charas:LSouSouCharacterS):void{
			var objSupply:Object;
			if(charas.member.troops < charas.member.pantTroops){
				objSupply = {type:"troops",charas:charas};
				charasSupply.push(objSupply);
			}else if(charas.statusArray[LSouSouCharacterS.STATUS_CHAOS][0] > 0 || 
				charas.statusArray[LSouSouCharacterS.STATUS_FIXED][0] > 0 || 
				charas.statusArray[LSouSouCharacterS.STATUS_POISON][0] > 0 || 
				charas.statusArray[LSouSouCharacterS.STATUS_STATEGY][0] > 0 || 
				charas.statusArray[LSouSouCharacterS.STATUS_NOATK][0] > 0){
				objSupply = {type:"status",charas:charas};
				charasSupply.push(objSupply);
			}
		}
		/**
		 * 计算攻击目标
		 */
		public static function getAttTarget(aiChara:LSouSouCharacterS):Object{
			aiChara.aiForStrategy = null;
			var charas:LSouSouCharacterS;
			var i:int,j:int;
			var objResult:Object;
			var obj:Object;
			var objSupply:Object;
			var node:Node;
			var node2:Node;
			var canattack:Boolean;
			
			var charasSupply:Array = new Array();
			var characterSArray:Array = new Array();
			var targetArray:Array = new Array();
			var targetArray2:Array = new Array();
			var intHert:int;
			_charalist = new Array();
			//获取所有敌军，以及战场所有人员位置
			if(aiChara.belong == LSouSouObject.BELONG_FRIEND){
				//友军
				for each(charas in LSouSouObject.sMap.enemylist){
					if(!charas.visible || charas.member.troops == 0)continue;
					obj = new Object();
					obj.charas = charas;
					targetArray.push(obj);
					_charalist[charas.locationX + "," + charas.locationY] = charas;
					characterSArray[charas.locationX + "," + charas.locationY] = charas;
				}
				for each(charas in LSouSouObject.sMap.ourlist){
					if(!charas.visible || charas.member.troops == 0)continue;
					setSupply(charasSupply,charas);
					_charalist[charas.locationX + "," + charas.locationY] = charas;
				}
				for each(charas in LSouSouObject.sMap.friendlist){
					if(!charas.visible || charas.member.troops == 0)continue;
					setSupply(charasSupply,charas);
					_charalist[charas.locationX + "," + charas.locationY] = charas;
				}
			}else{
				//敌军
				for each(charas in LSouSouObject.sMap.ourlist){
					if(!charas.visible || charas.member.troops == 0)continue;
					obj = new Object();
					obj.charas = charas;
					targetArray.push(obj);
					_charalist[charas.locationX + "," + charas.locationY] = charas;
					characterSArray[charas.locationX + "," + charas.locationY] = charas;
				}
				for each(charas in LSouSouObject.sMap.friendlist){
					if(!charas.visible || charas.member.troops == 0)continue;
					obj = new Object();
					obj.charas = charas;
					targetArray.push(obj);
					_charalist[charas.locationX + "," + charas.locationY] = charas;
					characterSArray[charas.locationX + "," + charas.locationY] = charas;
				}
				for each(charas in LSouSouObject.sMap.enemylist){
					if(!charas.visible || charas.member.troops == 0)continue;
					setSupply(charasSupply,charas);
					_charalist[charas.locationX + "," + charas.locationY] = charas;
				}
			}
			obj = null;
			//行动范围
			if(aiChara.command == LSouSouCharacterS.COMMAND_STAND_DEFENSE){
				LSouSouObject.sMap.roadList = [];
			}else{
				LSouSouObject.sMap.roadList = LSouSouObject.sStarQuery.makePath(LSouSouObject.charaSNow);
			}
			//将自己加入到行动范围
			LSouSouObject.sMap.roadList.unshift(new Node(aiChara.locationX,aiChara.locationY,0));
			if(aiChara.statusArray[LSouSouCharacterS.STATUS_STATEGY][0] == 0 && aiChara.member.strategy >= 0){
				//判断是否用恢复策略
				if(charasSupply.length > 0){
					obj = useSupply(aiChara,characterSArray,charasSupply);
				}
				//判断是否用攻击策略
				if(obj == null && (aiChara.member.armsType == 1 || 
					(aiChara.member.armsType == 2 && Math.random() < 0.5))){
					obj = getStrategyTarget(aiChara,characterSArray,targetArray);
				}
				//如果获得策略攻击目标，则停止计算
				if(obj){
					aiChara.aiForStrategy = obj;
					return obj;
				}
			}
			//计算所有攻击范围
			var attRange:Array = getAttRange(aiChara);
			
			for each(obj in attRange){
				if(characterSArray[obj.x + "," + obj.y]){
					charas = characterSArray[obj.x + "," + obj.y];
					obj.charas = charas;
					targetArray2.push(obj);
					intHert = LSouSouCalculate.getHertValue(aiChara,charas);
					obj.hert = intHert;
					//判断是否有一击可以杀死的人，有的话直接确立目标
					if(intHert >= charas.member.troops){
						return obj;
					}
				}
			}
			
			
			if(targetArray2.length > 0 ){
				trace("没有一击可以杀死的人的时候，如果有可以攻击到的人，则随机抽取可以攻击到的人，确立目标");
				var returnObj:Object;
				for each(obj in targetArray2){
					if(returnObj == null){
						for each(node in obj.parentList){
							canattack = atAttackRect(obj.charas as LSouSouCharacterS,new LCoordinate(node.x,node.y));
							if(!canattack){
								obj.nodeparent = node;
								break;
							}
						}
						obj.canattack = canattack;
						returnObj = obj;
					}else{
						canattack = true;
						for each(node in obj.parentList){
							canattack = atAttackRect(obj.charas as LSouSouCharacterS,new LCoordinate(node.x,node.y));
							if(!canattack){
								obj.nodeparent = node;
								break;
							}
						}
						obj.canattack = canattack;
						if(returnObj.canattack && !obj.canattack){
							returnObj = obj;
						}else if(!returnObj.canattack && !obj.canattack && returnObj.hert < obj.hert){
							returnObj = obj;
						}
					}
				}
				return returnObj;
			}else if(targetArray.length > 0 && aiChara.command == LSouSouCharacterS.COMMAND_INITIATIVE){
				trace("没有可以攻击到的人，确立最近目标,准备向目标移动");
				//没有可以攻击到的人，随机确立目标 obj.nodeparent空
				var objDistance:int = 100000000;
				var objDx:int = 0;
				var objDy:int = 0;
				var objx:int = 0;
				var objy:int = 0;
				var objDxy:int = 0;
				var dis:Array;
				var selectindex:int = 0;
				var selectdis:Array;
				var setarr:Array;
				for(i=0;i<targetArray.length;i++){
					obj = targetArray[i];
					charas = obj.charas;
					dis = LSouSouObject.sStarQuery.path(
						new LCoordinate(LSouSouObject.charaSNow.locationX,LSouSouObject.charaSNow.locationY),
						new LCoordinate(charas.locationX,charas.locationY),
						LSouSouObject.charaSNow
					);
					objDxy = dis.length;
					if(objDxy < objDistance){
						selectindex = i;
						selectdis = dis;
						objDistance = objDxy;
					}
				}
				obj = targetArray[selectindex];
				objDistance = 0;
				objDxy = 0;
				obj.mx = LSouSouObject.charaSNow.locationX;
				obj.my = LSouSouObject.charaSNow.locationY;
				for each(node in LSouSouObject.sMap.roadList){
					if(_charalist[node.x + "," +node.y])continue;
					if(setarr == null){
						setarr = new Array();
						for(j=0;j<selectdis.length;j++){
							node2 = selectdis[j];
							setarr[node2.x + "," +node2.y] = j;
						}
					}
					if(setarr[node.x + "," +node.y] == null)continue;
					objDistance = setarr[node.x + "," +node.y];
					
					if(objDxy < objDistance){
						obj.mx = node.x;
						obj.my = node.y;
						objDistance = objDxy;
					}
				}
				return obj;
			}
			
			//没有找到目标
			return null;
		}
		/**
		 * 是否使用恢复策略判断
		 * */
		private static function useSupply(aiChara:LSouSouCharacterS,characterSArray:Array,charasSupply:Array):Object{
			//如果mp为0，则无法使用策略
			if(aiChara.member.strategy == 0)return null;
			
			var roadLength:int = LSouSouObject.sMap.roadList.length;
			var charas:LSouSouCharacterS;
			var obj:Object;
			var objSupply:Object;
			var slist:XML;
			var strategyXMLList:XMLList;
			var strategyRectString:String;
			var strategyRect:Array;
			var i:int;
			//根据每一个可移动到的位置进行判断
			for(i=0;i<roadLength;i++){
				//如果移动目的地有其他人员，则判断下一位置
				if(_charalist[LSouSouObject.sMap.roadList[i].x + "," +LSouSouObject.sMap.roadList[i].y] && 
					LSouSouObject.charaSNow.index != _charalist[LSouSouObject.sMap.roadList[i].x + "," +LSouSouObject.sMap.roadList[i].y].index	)continue;
				
				//循环敌军数组
				for each(obj in charasSupply){
					charas = obj.charas;
					//获取所有策略，依次判断是否使用
					for each(slist in aiChara.member.strategyList.elements()){
						//跳过未习得策略
						if(slist.@lv > aiChara.member.lv)continue;
						//获取策略
						strategyXMLList = LSouSouObject.strategy["Strategy" + slist];
						//如果mp不够，则跳过
						if(aiChara.member.strategy < int(strategyXMLList.Cost))continue;
						if(obj.type == "troops"){
							if(int(strategyXMLList.Type.toString()) != 8)continue;
						}else{
							if(objSupply != null || int(strategyXMLList.Type.toString()) != 7)continue;
						}
						//trace("int(strategyXMLList.Type.toString()) = " + int(strategyXMLList.Type.toString()),"index="+charas.index);
						//trace((null as Bitmap).bitmapData);
						//获取策略可视范围
						for each(strategyRectString in strategyXMLList["Range"].elements()){
							//strategyRectString = strategyXMLList["Range"].elements()[0];
							strategyRect = strategyRectString.split(",");
							//判断策略可视范围内所有位置，是否有可攻击的敌军
							if(LSouSouObject.sMap.roadList[i].x + int(strategyRect[0]) == charas.locationX && 
								LSouSouObject.sMap.roadList[i].y + int(strategyRect[1]) == charas.locationY){
								obj.nodeparent = LSouSouObject.sMap.roadList[i];
								LSouSouObject.sMap.strategy = strategyXMLList;
								if(obj.type == "troops"){
									return obj;
								}
								
								objSupply = obj;
							}
						}
					}
				}
			}
			return objSupply;
		}
		/**
		 * 是否使用攻击策略判断
		 * */
		public static function getStrategyTarget(aiChara:LSouSouCharacterS,characterSArray:Array,targetArray:Array):Object{
			//如果mp为0，则无法使用策略
			if(aiChara.member.strategy == 0)return null;
			//行动范围
			//LSouSouObject.sMap.roadList = LSouSouObject.sStarQuery.makePath(LSouSouObject.charaSNow);
			//将自己加入到行动范围
			//LSouSouObject.sMap.roadList.unshift(new Node(aiChara.locationX,aiChara.locationY,0));
			
			var roadLength:int = LSouSouObject.sMap.roadList.length;
			var charas:LSouSouCharacterS;
			var obj:Object;
			var slist:XML;
			var strategyXMLList:XMLList;
			var strategyRectString:String;
			var strategyRect:Array;
			var i:int;
			//根据每一个可移动到的位置进行判断
			for(i=0;i<roadLength;i++){
				//如果移动目的地有其他人员，则判断下一位置
				if(_charalist[LSouSouObject.sMap.roadList[i].x + "," +LSouSouObject.sMap.roadList[i].y] && 
					LSouSouObject.charaSNow.index != _charalist[LSouSouObject.sMap.roadList[i].x + "," +LSouSouObject.sMap.roadList[i].y].index	)continue;
				//循环敌军数组
				for each(obj in targetArray){
					charas = obj.charas;
					//获取所有策略，依次判断是否使用
					for each(slist in aiChara.member.strategyList.elements()){
						//跳过未习得策略
						if(slist.@lv > aiChara.member.lv)continue;
						//获取策略
						strategyXMLList = LSouSouObject.strategy["Strategy" + slist];
						//己方策略则跳过
						if(int(strategyXMLList.Belong.toString()) == 0)continue;
						//非攻击性策略则跳过
						if(int(strategyXMLList.Type.toString()) >= 7)continue;
						//天气因素
						if(int(strategyXMLList.Type.toString()) == 1 && LSouSouObject.sMap.weatherIndex >= 2)continue;
						//如果mp不够，则跳过
						if(aiChara.member.strategy < int(strategyXMLList.Cost))continue;
						//获取策略可视范围
						for each(strategyRectString in strategyXMLList["Range"].elements()){
							strategyRect = strategyRectString.split(",");
							//判断策略可视范围内所有位置，是否有可攻击的敌军
							if(LSouSouObject.sMap.roadList[i].x + int(strategyRect[0]) == charas.locationX && 
								LSouSouObject.sMap.roadList[i].y + int(strategyRect[1]) == charas.locationY){
								if(!LSouSouCalculate.canUseMeff(charas.locationX,charas.locationY,strategyXMLList))continue;
								obj.nodeparent = LSouSouObject.sMap.roadList[i];
								LSouSouObject.sMap.strategy = strategyXMLList;
								return obj;
							}
						}
					}
				}
			}
			
			
			return null;
		}
		/**
		 * 计算所有攻击范围
		 */
		private static function getAttRange(aiChara:LSouSouCharacterS):Array{
			//LSouSouObject.sMap.roadList = LSouSouObject.sStarQuery.makePath(LSouSouObject.charaSNow);
			//if(LSouSouObject.sMap.roadList == null)return null;
			var attArr:Array = new Array();
			var attRoundArr:Array;
			var i:int;
			var j:int;
			var objAll:Object = new Object();
			var objCheck:Object = new Object();
			var obj:Object = new Object();
			var attRound:Array = new Array();
			var node:Node;
			//兵种攻击范围
			for each ( var roundment:String in aiChara.member.rangeAttack) {
				attRoundArr = roundment.split(",");
				attRound.push(new LCoordinate(int(attRoundArr[0]), int(attRoundArr[1])));
			}
			//方针不为原地防守的话
			if(aiChara.command != LSouSouCharacterS.COMMAND_STAND_DEFENSE){
				//根据移动范围来计算所有攻击范围
				var roadLength:int = LSouSouObject.sMap.roadList.length;
				
				for(i=0;i<roadLength;i++){
					for(j=0;j<attRound.length;j++){
						if(_charalist[LSouSouObject.sMap.roadList[i].x + "," +LSouSouObject.sMap.roadList[i].y])continue;
						obj = new Object();
						obj.x = LSouSouObject.sMap.roadList[i].x + attRound[j].x;
						obj.y = LSouSouObject.sMap.roadList[i].y + attRound[j].y;
						
						var nodeStr:String;
						var nodeArr:Array;
						var lx:int,ly:int;
						var canattack:Boolean;
						
						if(objAll[obj.x + "," + obj.y] == null){
							obj.nodeparent = LSouSouObject.sMap.roadList[i];
							obj.parentList = [LSouSouObject.sMap.roadList[i]];
							objAll[obj.x + "," + obj.y] = obj;
							attArr.push(obj);
						}else{
							node = LSouSouObject.sMap.roadList[i];
							if(getDistance(new LCoordinate(LSouSouObject.charaSNow.locationX,LSouSouObject.charaSNow.locationY),new LCoordinate(node.x,node.y)) < 
								getDistance(new LCoordinate(LSouSouObject.charaSNow.locationX,LSouSouObject.charaSNow.locationY),new LCoordinate(objAll[obj.x + "," + obj.y].nodeparent.x,objAll[obj.x + "," + obj.y].nodeparent.y))){
								objAll[obj.x + "," + obj.y].nodeparent = LSouSouObject.sMap.roadList[i];
								objAll[obj.x + "," + obj.y].parentList.push(LSouSouObject.sMap.roadList[i]);
							}
							
						}
					}
				}
			}
			for(j=0;j<attRound.length;j++){
				obj = new Object();
				obj.x = LSouSouObject.charaSNow.locationX + attRound[j].x;
				obj.y = LSouSouObject.charaSNow.locationY + attRound[j].y;
				
				node = new Node(LSouSouObject.charaSNow.locationX,LSouSouObject.charaSNow.locationY,0);
				if(objAll[obj.x + "," + obj.y] == null){
					obj.nodeparent = node;
					obj.parentList = [node];
					objAll[obj.x + "," + obj.y] = obj;
					attArr.push(obj);
				}else{
					objAll[obj.x + "," + obj.y].nodeparent = node;
					objAll[obj.x + "," + obj.y].parentList.push(node);
					
				}
			}
			return attArr;
		}
		
		/**
		 * 判断是否在攻击范围之内
		 * */
		public static function atAttackRect(attChara:LSouSouCharacterS,hertCoordinate:LCoordinate):Boolean{
			var nodeStr:String;
			var nodeArr:Array;
			var canattack:Boolean;
			for each(nodeStr in attChara.member.rangeAttack){
				nodeArr = nodeStr.split(",");
				if(attChara.locationX + int(nodeArr[0]) == hertCoordinate.x &&
					attChara.locationY + int(nodeArr[1]) == hertCoordinate.y){
					canattack = true;
					break;
				}
			}
			return canattack;
		}
		
		private static function getDistance(fromCoordinate:LCoordinate,toCoordinate:LCoordinate):int{
			var coorX:int = fromCoordinate.x - toCoordinate.x;
			var coorY:int = fromCoordinate.y - toCoordinate.y;
			return coorX*coorX + coorY*coorY;
		}
	}
}