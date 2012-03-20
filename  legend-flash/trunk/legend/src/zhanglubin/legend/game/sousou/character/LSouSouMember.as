package zhanglubin.legend.game.sousou.character
{
	import zhanglubin.legend.game.sousou.object.LSouSouObject;

	public class LSouSouMember
	{
		private var _data:XML;
		public function LSouSouMember(xmlData:XML=null)
		{
			if(xmlData)_data = calculation(xmlData);
		}
		public function calculation(xmlData:XML):XML{
			var result:XML = xmlData;
			
			result.Helmet = new XMLList("<Helmet>0</Helmet>");
			result.Equipment = new XMLList("<Equipment lv='1' exp='0'>0</Equipment>");
			result.Weapon = new XMLList("<Weapon lv='1' exp='0'>0</Weapon>");
			result.Horse = new XMLList("<Horse>0</Horse>");
			
			var armXml:XMLList = LSouSouObject.arms["Arms" + result.Arms];
			result.Attack = int(result.Force.toString())/2 + upValue(armXml.Property.Attack,result.Force)*int(result.Lv);
			result.Spirit =  int(result.Intelligence.toString())/2 + upValue(armXml.Property.Spirit,result.Intelligence)*int(result.Lv);
			result.Defense =  int(result.Command.toString())/2 + upValue(armXml.Property.Defense,result.Command)*int(result.Lv);
			result.Breakout =  int(result.Agile.toString())/2 + upValue(armXml.Property.Breakout,result.Agile)*int(result.Lv);
			result.Morale =  int(result.Luck.toString())/2 + upValue(armXml.Property.Morale,result.Luck)*int(result.Lv);
			result.MaxTroops = int(result.MaxTroops.toString()) + int(armXml.Property.Troops.toString())*int(result.Lv);
			result.MaxStrategy = int(result.MaxStrategy.toString()) + int(armXml.Property.Strategy.toString())*int(result.Lv);
			
			result.Exp = 0;
			/**
			var xmllist:XML = <StrategyList></StrategyList>;
			xmllist.appendChild(<list index='1' icon='menu_icon_attack.png'>小风计</list>);
			xmllist.appendChild(<list index='0' icon='menu_icon_attack.png'>小火计</list>);
			xmllist.appendChild(<list index='1' icon='menu_icon_attack.png'>小风计</list>);
			xmllist.appendChild(<list index='0' icon='menu_icon_attack.png'>小火计</list>);
			xmllist.appendChild(<list index='1' icon='menu_icon_attack.png'>小风计</list>);
			xmllist.appendChild(<list index='0' icon='menu_icon_attack.png'>小火计</list>);
			result.StrategyList = xmllist;*/
			return result;
		}
		public function upValue(type:String,value:int):int{
			trace(type,value);
			if(type == "S"){
				if(value < 50)return 1;
				if(value < 70)return 2;
				if(value < 90)return 3;
				return 4;
			}else if(type == "A"){
				if(value < 50)return 1;
				if(value < 70)return 2;
				return 3;
			}else if(type == "B"){
				if(value < 50)return 1;
				return value >= 90?3:2;
			}else if(type == "C"){
				return value >=70?2:1;
			}
			return 0;
		}
		public function lvUp():void{
			var armXml:XMLList = LSouSouObject.arms["Arms" + _data.Arms];
			_data.Attack = int(_data.Attack.toString()) + upValue(armXml.Property.Attack,_data.Force);
			_data.Spirit =  int(_data.Spirit.toString()) + upValue(armXml.Property.Spirit,_data.Intelligence);
			_data.Defense =  int(_data.Defense.toString()) + upValue(armXml.Property.Defense,_data.Command);
			_data.Breakout =  int(_data.Breakout.toString()) + upValue(armXml.Property.Breakout,_data.Agile);
			_data.Morale =  int(_data.Morale.toString()) + upValue(armXml.Property.Morale,_data.Luck);
			_data.MaxTroops = int(_data.MaxTroops.toString()) + int(armXml.Property.Troops.toString()); 
			_data.MaxStrategy = int(_data.MaxStrategy.toString()) + int(armXml.Property.Strategy.toString()); 
			_data.Lv = int(_data.Lv.toString()) + 1;
			_data.Exp = 0;
			
		}
		/**
		 * 坐骑
		 * */
		public function set horse(value:XMLList):void{
			_data.Horse = value;
		}
		/**
		 * 坐骑
		 * */
		public function get horse():XMLList{
			return _data.Horse;
		}
		/**
		 * 武器
		 * */
		public function set weapon(value:XMLList):void{
			_data.Weapon = value;
		}
		/**
		 * 武器
		 * */
		public function get weapon():XMLList{
			return _data.Weapon;
		}
		/**
		 * 盔甲
		 * */
		public function set equipment(value:XMLList):void{
			_data.Equipment = value;
		}
		/**
		 * 盔甲
		 * */
		public function get equipment():XMLList{
			return _data.Equipment;
		}
		/**
		 * 头盔/辅助品
		 * */
		public function set helmet(value:XMLList):void{
			_data.Helmet = value;
		}
		/**
		 * 头盔/辅助品
		 * */
		public function get helmet():XMLList{
			return _data.Helmet;
		}
		public function get strategyList():XMLList{
			return LSouSouObject.arms["Arms" + _data.Arms].Strategy;
			//var armXml:XMLList = LSouSouObject.arms["Arms" + _data.Arms];
			
			/**
			 var xmllist:XML = <StrategyList></StrategyList>;
			 xmllist.appendChild(<list index='1' icon='menu_icon_attack.png'>小风计</list>);
			 xmllist.appendChild(<list index='0' icon='menu_icon_attack.png'>小火计</list>);
			 xmllist.appendChild(<list index='1' icon='menu_icon_attack.png'>小风计</list>);
			 xmllist.appendChild(<list index='0' icon='menu_icon_attack.png'>小火计</list>);
			 xmllist.appendChild(<list index='1' icon='menu_icon_attack.png'>小风计</list>);
			 xmllist.appendChild(<list index='0' icon='menu_icon_attack.png'>小火计</list>);
			 result.StrategyList = xmllist;*/
			//return _data.StrategyList;
		}
		public function get distance():int{
			return int(LSouSouObject.arms["Arms" + arms]["Distance"].toString());
		}
		public function get force():int{
			return int(_data.Force.toString());
		}
		public function get intelligence():int{
			return int(_data.Intelligence.toString());
		}
		public function get command():int{
			return int(_data.Command.toString());
		}
		public function get agile():int{
			return int(_data.Agile.toString());
		}
		public function get luck():int{
			return int(_data.Luck.toString());
		}
		public function get exp():int{
			return int(_data.Exp.toString());
		}
		public function set exp(value:int):void{
			_data.Exp = value;
			if(int(_data.Exp) > 100)_data.Exp = 100;
		}
		public function get skill():int{
			if(_data.Skill == null || _data.Skill == "")return 0;
			return int(_data.Skill.toString());
		}
		public function get index():int{
			return int(_data.Index.toString());
		}
		public function getAddValue(addName:String):int{
			var addvalue:int = 0;
			var itemXml:XMLList;
			//饰品
			if(int(helmet.toString()) > 0){
				itemXml = LSouSouObject.item["Child"+helmet];
				addvalue+=int(itemXml[addName]);
			}
			//装备
			if(int(equipment.toString()) > 0){
				itemXml = LSouSouObject.item["Child"+equipment];
				addvalue+=int(itemXml[addName]) + int(itemXml[addName].@add)*int(equipment.@lv);
			}
			//武器
			if(int(weapon.toString()) > 0){
				itemXml = LSouSouObject.item["Child"+weapon];
				addvalue+=int(itemXml[addName]) + int(itemXml[addName].@add)*int(weapon.@lv);
			}
			//坐骑
			if(int(horse.toString()) > 0){
				itemXml = LSouSouObject.item["Child"+horse];
				addvalue+=int(itemXml[addName]);
			}
			return addvalue;
		}
		public function get attack():int{
			return int(_data.Attack.toString()) + getAddValue("Attack");
		}
		/**
		 *精神力
		 **/
		public function get spirit():int{
			return int(_data.Spirit.toString()) + getAddValue("Spirit");
		}
		public function get defense():int{
			return int(_data.Defense.toString()) + getAddValue("Defense");
		}
		/**
		 *爆发力
		 **/
		public function get breakout():int{
			return int(_data.Breakout.toString()) + getAddValue("Breakout");
		}
		/**
		 *士气
		 **/
		public function get morale():int{
			return int(_data.Morale.toString()) + getAddValue("Morale");
		}
		public function get troops():int{
			return int(_data.Troops.toString());
		}
		public function set troops(value:int):void{
			_data.Troops = value;
		}
		public function get maxTroops():int{
			return int(_data.MaxTroops.toString()) + getAddValue("Hp");
		}
		public function set maxTroops(value:int):void{
			_data.MaxTroops = value;
		}
		public function get pantTroops():int{
			return maxTroops*0.25;
		}
		public function get strategy():int{
			return int(_data.Strategy.toString());
		}
		public function set strategy(value:int):void{
			_data.Strategy = value;
		}
		public function get maxStrategy():int{
			return int(_data.MaxStrategy.toString()) + getAddValue("Mp");
		}
		public function set maxStrategy(value:int):void{
			_data.MaxStrategy = value;
		}
		public function get name():String{
			return _data.Name.toString();
		}
		public function get face():int{
			return int(_data.Face.toString());;
		}
		public function get introduction():String{
			return _data.Introduction.toString();
		}
		public function get arms():int{
			return int(_data.Arms.toString());
		}
		public function get lv():int{
			return int(_data.Lv.toString());
		}
		public function set lv(value:int):void{
			_data.Lv = value;
		}
		public function get data():XML{
			return _data;
		}
		public function set data(value:XML):void{
			_data = value;
		}
		/**
		 * 盔甲
		 * 
		 * @param 盔甲编号
		 */
		public function set armor(value:int):void{
			_data.Armor = value;
		}
		public function set must(value:int):void{
			_data.Must = value;
		}
		public function get must():int{
			return int(_data.Must.toString());
		}
		public function get rangeAttack():XMLList{
			return LSouSouObject.arms["Arms" + arms]["RangeAttack"].elements();
		}
		public function get rangeAttackTarget():XMLList{
			return LSouSouObject.arms["Arms" + arms]["RangeAttackTarget"].elements();
		}
		public function get armsName():String{
			return LSouSouObject.arms["Arms" + arms]["Name"];
		}
		public function get armsType():int{
			return int(LSouSouObject.arms["Arms" + arms]["Arms_type"].toString());
		}
		public function get armsProperty():XMLList{
			return LSouSouObject.arms["Arms" + arms]["Property"];
		}
		public function get armIntroduction():String{
			return LSouSouObject.arms["Arms" + arms]["Introduction"];
		}
		public function get armsMoveType():int{
			return int(LSouSouObject.arms["Arms" + arms]["MoveType"].toString());
		}
	}
}
/**
 * 
<peo1>
 	<Index>1</Index>
	<Name>刘备</Name>
	<Must>0</Must>
	<Face>1</Face>
	<Image>1</Image>
	<R>0</R>
	<S>1</S>
	<Arms ex="兵种">1</Arms>
	<Lv>1</Lv>
	<Exp>0</Exp>
	<Troops ex="兵力">124</Troops>
	<Strategy ex="策略">85</Strategy>
	<MaxTroops>124</MaxTroops>
	<MaxStrategy>85</MaxStrategy>
	<Force ex="武力">73</Force>
	<Intelligence ex="智力">77</Intelligence>
	<Command ex="统帅">82</Command>
	<Agile ex="敏捷">80</Agile>
	<Luck ex="运气">90</Luck>
	<Attack ex="攻击力">82</Attack>
	<Spirit ex="精神力">92</Spirit>
	<Defense ex="防御力">80</Defense>
	<Breakout ex="爆发力">385</Breakout>
	<Morale ex="士气力">380</Morale>
	<Armor ex="盔甲">
	 <id>001</id>
	 <Name>火龙甲</Name>
	 <Defense ex="防御力">10</Defense>
	</Armor>
	<Helmet ex="头盔">
	 <id>001</id>
	 <Name>火龙甲</Name>
	 <Defense ex="防御力">10</Defense>
	</Helmet>
	<Weapon ex="武器">
	 <id>001</id>
	 <Name>火龙甲</Name>
	 <Attack ex="攻击力">12</Attack>
	</Weapon>
</peo1>
 * */