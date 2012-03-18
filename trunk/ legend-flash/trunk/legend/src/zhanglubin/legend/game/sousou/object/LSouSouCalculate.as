package zhanglubin.legend.game.sousou.object
{
	import zhanglubin.legend.game.sousou.character.LSouSouCharacterS;
	import zhanglubin.legend.game.sousou.map.LSouSouWindow;
	import zhanglubin.legend.utils.LGlobal;
	/**
	 * 战场命中伤害等计算
	 * */
	public class LSouSouCalculate
	{
		public function LSouSouCalculate()
		{
		}
		public static function belongMeff(charas:LSouSouCharacterS):Boolean{
			var strategyBelong:int = int(LSouSouObject.sMap.strategy.Belong.toString());
			var window:LSouSouWindow;
			if(strategyBelong == 0){
				if(charas.belong == LSouSouObject.BELONG_ENEMY){
					window = new LSouSouWindow();
					window.setMsg(["无法向对方使用",1,30]);
					LGlobal.script.scriptLayer.addChild(window);
					return false;
				}
			}else{
				if(charas.belong == LSouSouObject.BELONG_FRIEND){
					window = new LSouSouWindow();
					window.setMsg(["无法向我方使用",1,30]);
					LGlobal.script.scriptLayer.addChild(window);
					return false;
				}else if(charas.belong == LSouSouObject.BELONG_FRIEND){
					window = new LSouSouWindow();
					window.setMsg(["无法向友方使用",1,30]);
					LGlobal.script.scriptLayer.addChild(window);
					return false;
				}
			}
			return true;
		}
		/********************************************
		   法术是否可用
		 *********************************************/
		public static function canUseMeff(intX:int,intY:int,strategy:XMLList):Boolean{
			var meffStr:String = LSouSouObject.terrain["Terrain"+LSouSouObject.sMap.mapData[intY][intX]].@meff;
			if(meffStr.length == 0)return false;
			var meffs:Array = meffStr.split(",");
			var type:int = strategy.Type;
			var meffType:int;
			for each(meffType in meffs){
				if(meffType == type)return true;
			}
			return false;
		}
		/********************************************
		 物理攻击的命中率<br>
		 X代表我方的爆发力，Y代表敌方的爆发力。R表示命中率<br>
		 if (x>2*y)<br>
		 r=100;<br>
		 else if(x>y)<br>
		 r=(x-y)*10/y+90;<br>
		 else if(x>y/2)<br>
		 r=(x-y/2)*30/(y/2)+60;<br>
		 else<br>
		 r=(x-y/3)*30/(y/3)+30;<br>
		 注：手套和盾有加成效果。比如敌人有辅助防御15%的宝物，那么最终的命中率是r-15<br>
		 2、法术攻击的命中率<br>
		 计算公式与1相同，其中X表示我方的精神力与运气之和，Y表示敌方的精神力与运气之和<br>
		 再考虑宝物的加成<br>
		 最后，不同的法术还会有具体的权重系数，比如还要乘以1.5、0.9等等。
		 *********************************************/
		public static function getHitrate(attChara:LSouSouCharacterS,hertChara:LSouSouCharacterS):Boolean{
			if(hertChara.statusArray[LSouSouCharacterS.STATUS_CHAOS][0]> 0)return true;
			var r:int;
			//得到双方的爆发力
			var attBreakout:int = attChara.member.breakout;
			var hertBreakout:int = hertChara.member.breakout;
			if(attBreakout > 2*hertBreakout){
				r = 100;
			}else if(attBreakout > hertBreakout){
				r=(attBreakout-hertBreakout)*10/hertBreakout+90;
			}else if(attBreakout > hertBreakout){
				r=(attBreakout-hertBreakout/2)*30/(hertBreakout/2)+60;
			}else{
				r=(attBreakout-hertBreakout/3)*30/(hertBreakout/3)+30;
			}
			if(Math.random()*100 <= r){
				return true;
			}
			return false;
		}
		
		/********************************************
		 法术恢复的命中率<br>
		 
		 *********************************************/
		public static function getHitrateRestoration(attChara:LSouSouCharacterS,hertChara:LSouSouCharacterS):Boolean{
			if(LSouSouObject.sMap.strategy.Type.toString() == "8")return true;
			if(LSouSouObject.sMap.strategy.Type.toString() == "7")return true;
			return false;
		}
		/********************************************
		 法术攻击的命中率<br>
		 X代表我方的精神力与运气之和，Y代表敌方的精神力与运气之和。R表示命中率<br>
		 if (x>2*y)<br>
		 r=100;<br>
		 else if(x>y)<br>
		 r=(x-y)*10/y+90;<br>
		 else if(x>y/2)<br>
		 r=(x-y/2)*30/(y/2)+60;<br>
		 else<br>
		 r=(x-y/3)*30/(y/3)+30;<br>
		 宝物的加成<br>
		 *********************************************/
		public static function getHitrateStrategy(attChara:LSouSouCharacterS,hertChara:LSouSouCharacterS):Boolean{
			if(hertChara.statusArray[LSouSouCharacterS.STATUS_CHAOS][0]> 0)return true;
			var r:int;
			//得到双方的爆发力
			var attX:int = attChara.member.spirit + attChara.member.morale;
			var hertY:int = hertChara.member.spirit + hertChara.member.morale;
			if(attX > 2*hertY){
				r = 100;
			}else if(attX > hertY){
				r=(attX-hertY)*10/hertY+90;
			}else if(attX > hertY){
				r=(attX-hertY/2)*30/(hertY/2)+60;
			}else{
				r=(attX-hertY/3)*30/(hertY/3)+30;
			}
			if(Math.random()*100 <= r){
				return true;
			}
			
			return false;
		}
		
		/***************************************************************************
		 法术攻击的伤害值计算<br>
		 X代表攻击方的精神力，Y代表被攻击方的精神力，Lv表示攻击方的等级。R表示伤害值<br>
		 if (x'>y')<br>
		 r=Lv+25+(X'-Y')/2;<br>
		 else<br>
		 r=Lv+25-(Y'-X')/2<br>
		 然后再根据兵种相克和宝物进行修正
		 *****************************************************************************/
		public static function getHertStrategyValue(attChara:LSouSouCharacterS,hertChara:LSouSouCharacterS):int{
			var r:int;
			//得到攻击方的精神力和等级
			var attLv:int =  attChara.member.lv;
			var attAttack:int = attChara.member.spirit;
			//得到防御方的精神力
			var hertDefense:int = hertChara.member.spirit;
			
			//物理攻击的伤害值计算
			if(attAttack > hertDefense){
				r = attLv + 25 + (attAttack - hertDefense)/3;
			}else{
				r = attLv + 25 - (hertDefense - attAttack)/3;
			}
			/******************************
			 //宝物进行修正
			 ******************************/
			/*
			//反击75%伤害
			if(Ctrl.BACK_ATTACK){
			r = Math.floor(r*0.75);
			}
			*/
			r = int(r * Number(LSouSouObject.sMap.strategy.Hert.toString()));
			return r;
		}
		
		/***************************************************************************
		 物理攻击的伤害值计算
		 X代表攻击方的攻击力，Y代表被攻击方的防御力，Lv表示攻击方的等级。R表示伤害值
		 首先会根据地形修正攻击和防御力为X',Y'
		 if (x'>y')
		 r=Lv+25+(X'-Y')/2;
		 else
		 r=Lv+25-(Y'-X')/2
		 然后再根据兵种相克和宝物进行修正
		 *****************************************************************************/
		public static function getHertValue(attChara:LSouSouCharacterS,hertChara:LSouSouCharacterS):int{
			var r:int;
			//得到攻击方的攻击力和等级
			var attLv:int =  attChara.member.lv;
			var attAttack:int = attChara.member.attack + attChara.statusArray[LSouSouCharacterS.STATUS_ATTACK][2];
			//得到防御方的防御力
			var hertDefense:int = hertChara.member.defense + hertChara.statusArray[LSouSouCharacterS.STATUS_DEFENSE][2];
			//计算攻击方所在地形
			var attTerrain:String = "Terrain" + LSouSouObject.sMap.mapData[attChara.locationY][attChara.locationX];
			//计算防御方所在地形
			var hertTerrain:String = "Terrain" + LSouSouObject.sMap.mapData[hertChara.locationY][hertChara.locationX];
			//根据地形修正攻击和防御力
			var attAttackAddition:int;
			if(LSouSouObject.arms["Arms" + attChara.arms].Terrain[attTerrain] == null || LSouSouObject.arms["Arms" + attChara.arms].Terrain[attTerrain].length > 0){
				attAttackAddition = attAttack;
			}else{
				attAttackAddition = Math.floor((int(LSouSouObject.arms["Arms" + attChara.arms].Terrain[attTerrain].@Addition)/100) * attAttack);
			}
			
			var hertDefenseAddition:int;
			if(LSouSouObject.arms["Arms" + hertChara.arms].Terrain[hertTerrain] == null || LSouSouObject.arms["Arms" + hertChara.arms].Terrain[hertTerrain].length > 0){
				hertDefenseAddition = hertDefense;
			}else{
				hertDefenseAddition = Math.floor((int(LSouSouObject.arms["Arms" + hertChara.arms].Terrain[hertTerrain].@Addition)/100) * hertDefense);
			}
			
			
			//物理攻击的伤害值计算
			if(attAttackAddition > hertDefenseAddition){
				r = attLv + 25 + (attAttackAddition - hertDefenseAddition)/2;
			}else{
				r = attLv + 25 - (hertDefenseAddition - attAttackAddition)/2;
			}
			//兵种相克
			if(LSouSouObject.arms["Arms" + attChara.arms].Restrain["list" + hertChara.arms].toString().length>0){
				r = Math.floor((int(LSouSouObject.arms["Arms" + attChara.arms].Restrain["list" + hertChara.arms])/100) * r);
			}
			r = int((110-Math.random()*20)*r/100);
			/******************************
			 //宝物修正
			 ******************************/
			/*
			//反击75%伤害
			if(Ctrl.BACK_ATTACK){
				r = Math.floor(r*0.75);
			}
			*/
			return r;
		}
		/********************************************
		 双击概率计算
		 如果Sa/Sd<1，那么H=1；
		 如果1<=Sa/Sd<2，那么H=2+18*（Sa/Sd-1）；
		 如果2<=Sa/Sd<=3，那么H=20+80*（Sa/Sd-2）；
		 如果Sa/Sd>=3，那么H=100；
		 *********************************************/
		public static function getDoubleAtt(attChara:LSouSouCharacterS,hertChara:LSouSouCharacterS):Boolean{
			/**if(attChara.doubleFightIndex >= attChara.doubleFightMaxIndex || Ctrl.BACK_ATTACK){
				return false;
			}*/
			//attChara.doubleFightIndex ++;
			var h:int;
			//得到双方的爆发力
			var attBreakout:int = attChara.member.breakout;
			var hertBreakout:int = hertChara.member.breakout;
			var rate:Number = attBreakout/hertBreakout;
			if(rate < 1){
				h = 1;
			}else if(rate >= 1 && rate < 2){
				h = 2 + 18*(rate - 1);
			}else if(rate >= 2 && rate < 3){
				h = 20 + 80*(rate - 2);
			}else if(rate >= 3){
				h = 100;
			}
			if(Math.random()*100 <= h){
				return true;
			}
			return false;
		}
		/********************************************
		 致命概率计算
		 如果Sa/Sd<1，那么H=1；
		 如果1<=Sa/Sd<2，那么H=2+18*（Sa/Sd-1）；
		 如果2<=Sa/Sd<=3，那么H=20+80*（Sa/Sd-2）；
		 如果Sa/Sd>=3，那么H=100；
		 *********************************************/
		public static function getFatalAtt(attChara:LSouSouCharacterS,hertChara:LSouSouCharacterS):Boolean{
			var h:int;
			//得到双方的士气
			var attMorale:int = attChara.member.morale;
			var hertMorale:int = hertChara.member.morale;
			var rate:Number = attMorale/hertMorale;
			if(rate < 1){
				h = 1;
			}else if(rate >= 1 && rate < 2){
				h = 2 + 18*(rate - 1);
			}else if(rate >= 2 && rate < 3){
				h = 20 + 80*(rate - 2);
			}else if(rate >= 3){
				h = 100;
			}
			if(Math.random()*100 <= h){
				return true;
			}
			return false;
		}
	}
}