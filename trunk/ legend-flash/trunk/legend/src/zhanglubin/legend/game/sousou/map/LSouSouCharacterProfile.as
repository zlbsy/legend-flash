package zhanglubin.legend.game.sousou.map
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import zhanglubin.legend.components.LLabel;
	import zhanglubin.legend.display.LBitmap;
	import zhanglubin.legend.display.LButton;
	import zhanglubin.legend.display.LScrollbar;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.game.sousou.character.LSouSouCharacterS;
	import zhanglubin.legend.game.sousou.object.LSouSouObject;
	import zhanglubin.legend.text.LTextField;
	import zhanglubin.legend.utils.LDisplay;
	import zhanglubin.legend.utils.LGlobal;
	import zhanglubin.legend.utils.LImage;
	import zhanglubin.legend.utils.math.LCoordinate;

	public class LSouSouCharacterProfile extends LSprite
	{
		private var _view:int;
		public function LSouSouCharacterProfile(view:int = -1)
		{
			init(view);
		}
		private function init(value:int):void{
			this.die();
			_view = value;
			addBackground();
			addFace();
			addStatus();
			addStrategy();
			addSkill();
			addArms();
			addEquipment();
			addButton();
			if(_view>=0)showMemberList();
		}
		private function showMemberList():void{
			var memLayer:LSprite;
			var memScroll:LScrollbar;
			memLayer = new LSprite();
			var bitmapName:BitmapData;
			var btnName:LButton;
			var i:int;
			for(i=0;i<LSouSouObject.memberList.length;i++){
				if(LSouSouObject.charaSNow.index == int(LSouSouObject.memberList[i].index)){
					bitmapName = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"btn_003.png");
				}else{
					bitmapName = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"btn_002.png");
				}
				btnName = new LButton(bitmapName);
				btnName.value = i;
				btnName.addEventListener(MouseEvent.MOUSE_UP,function (event:MouseEvent):void{
					LSouSouObject.charaSNow = new LSouSouCharacterS(LSouSouObject.memberList[event.target.value],0,0,0);
					init(0);
				});
				btnName.label = LSouSouObject.memberList[i].name;
				btnName.y = btnName.height*i;
				memLayer.addChild(btnName);
			}
			
			memScroll = new LScrollbar(memLayer,105,200,20,false);
			memScroll.alpha = 0.9;
			memScroll.xy = new LCoordinate(5,5);
			this.addChild(memScroll);
			setBox(0,0,110,210,this);
		}
		private function setBox(_menuX:int,_menuY:int,_menuW:int,_menuH:int,layer:LSprite):void{
			var _menuBitmap:LBitmap;
			_menuBitmap = new LBitmap(new BitmapData(_menuW,5,true));
			_menuBitmap.bitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar02.png"),
				new Rectangle(0,0,_menuBitmap.width,_menuBitmap.height),new Point(0,0));
			_menuBitmap.x = _menuX;
			_menuBitmap.y = _menuY;
			layer.addChild(_menuBitmap);
			_menuBitmap = new LBitmap(new BitmapData(5,_menuH,true));
			_menuBitmap.bitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar04.png"),
				new Rectangle(0,0,_menuBitmap.width,_menuBitmap.height),new Point(0,0));
			_menuBitmap.x = _menuX;
			_menuBitmap.y = _menuY;
			layer.addChild(_menuBitmap);
			_menuBitmap = new LBitmap(new BitmapData(5,_menuH,true));
			_menuBitmap.bitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar05.png"),
				new Rectangle(0,0,_menuBitmap.width,_menuBitmap.height),new Point(0,0));
			_menuBitmap.x = _menuW + _menuX - _menuBitmap.width;
			_menuBitmap.y = _menuY;
			layer.addChild(_menuBitmap);
			_menuBitmap = new LBitmap(new BitmapData(_menuW,5,true));
			_menuBitmap.bitmapData.copyPixels(LImage.vertical(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar02.png")),
				new Rectangle(0,0,_menuBitmap.width,_menuBitmap.height),new Point(0,0));
			_menuBitmap.x = _menuX;
			_menuBitmap.y = _menuY + _menuH - 5;
			layer.addChild(_menuBitmap);
			_menuBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar01.png"));
			_menuBitmap.x = _menuX;
			_menuBitmap.y = _menuY;
			layer.addChild(_menuBitmap);
			_menuBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar03.png"));
			_menuBitmap.x = _menuW + _menuX - 15;
			_menuBitmap.y = _menuY;
			layer.addChild(_menuBitmap);
			_menuBitmap = new LBitmap(LImage.vertical(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar01.png")));
			_menuBitmap.x = _menuX;
			_menuBitmap.y = _menuY + _menuH - 15;
			layer.addChild(_menuBitmap);
			_menuBitmap = new LBitmap(LImage.vertical(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar03.png")));
			_menuBitmap.x = _menuW + _menuX - 15;
			_menuBitmap.y = _menuY + _menuH - 15;
			layer.addChild(_menuBitmap);
		}
		/**
		 * 显示策略
		 */
		private function addStrategy():void{
			LDisplay.drawRect(this.graphics,[260,260,240,130],false,0xffffff,1,2);
			var lblTitle:LLabel = new LLabel();
			lblTitle.htmlText = "<font color='#ffffff' size='18'><b>策略名称</b></font>";
			lblTitle.x = 265 + 30;
			lblTitle.y = 265;
			this.addChild(lblTitle);
			lblTitle = new LLabel();
			lblTitle.htmlText = "<font color='#ffffff' size='18'><b>消耗MP</b></font>";
			lblTitle.x = 400;
			lblTitle.y = 265;
			this.addChild(lblTitle);
			//LDisplay.drawRect(this.graphics,[265,290,230,95],false,0xffffff,1,2);
			
			
			var strategyLayer:LSprite = new LSprite();
			var i:int;
			var lblStrategy:LLabel;
			var lblMp:LLabel;
			var slist:XML;
			var img:LBitmap;
			for each(slist in LSouSouObject.charaSNow.member.strategyList.elements()){
				if(slist.@lv > LSouSouObject.charaSNow.member.lv)continue;
				LDisplay.drawRect(strategyLayer.graphics,[0,i*20,140,20],false,0xffffff);
				LDisplay.drawRect(strategyLayer.graphics,[140,i*20,60,20],false,0xffffff);
				
				img = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],LSouSouObject.strategy["Strategy" + slist].Icon.toString()));
				img.width = 20;
				img.height = 20;
				img.xy = new LCoordinate(0,i*20);
				strategyLayer.addChild(img);
				lblStrategy = new LLabel();
				lblStrategy.htmlText = "<font color='#ffffff' size='15'><b>"+LSouSouObject.strategy["Strategy" + slist].Name+"</b></font>";
				lblStrategy.x = 25;
				lblStrategy.y = i*20;
				strategyLayer.addChild(lblStrategy);
				lblMp = new LLabel();
				lblMp.htmlText = "<font color='#ffffff' size='15'><b>"+LSouSouObject.strategy["Strategy" + slist].Cost+"</b></font>";
				lblMp.x = 150;
				lblMp.y = i*20;
				strategyLayer.addChild(lblMp);
				i++;
				/**
				img = new LBitmap(new BitmapData(10,btn_h));
				img.alpha = 0;
				img.xy = new LCoordinate(0,btn_h*index);
				_menuBack.addChild(img);
				lbltext = new LLabel();
				lbltext.htmlText = "<font color='#ffffff' size='15'><b>"+LSouSouObject.strategy["Strategy" + slist].Name+"</b></font>";
				lbltext.xy = new LCoordinate(25 + (90-lbltext.width)/2,btn_h*index + (btn_h - lbltext.height)/2);
				_menuBack.addChild(lbltext);
				img = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],LSouSouObject.strategy["Strategy" + slist].Icon.toString()));
				img.xy = new LCoordinate(5,btn_h*index + (btn_h - img.height)/2);
				_menuBack.addChild(img);
				_strategyList.push(slist);
				index++;*/
			}
			/**
			for(i=0;i<10;i++){
				LDisplay.drawRect(strategyLayer.graphics,[0,i*20,140,20],false,0xffffff);
				LDisplay.drawRect(strategyLayer.graphics,[140,i*20,60,20],false,0xffffff);
				lblStrategy = new LLabel();
				lblStrategy.htmlText = "<font color='#ffffff' size='15'>测试策略</font>";
				lblStrategy.x = 5;
				lblStrategy.y = i*20;
				strategyLayer.addChild(lblStrategy);
				lblMp = new LLabel();
				lblMp.htmlText = "<font color='#ffffff' size='15'>5</font>";
				lblMp.x = 150;
				lblMp.y = i*20;
				strategyLayer.addChild(lblMp);
			}
			*/
			var scrollbar:LScrollbar = new LScrollbar(strategyLayer,210,95,15,false);
			scrollbar.xy = new LCoordinate(265,290);
			this.addChild(scrollbar);
		}
		/**
		 * 显示特技
		 */
		private function addSkill():void{
			var lblX:int = 260;
			var lblY:int = 400;
			var notSkill:Boolean;
			if(int(LSouSouObject.charaSNow.member.skill.toString()) <= 0)notSkill = true;
			var skill:XMLList = LSouSouObject.skill["Skill" + LSouSouObject.charaSNow.member.skill];
			if(skill == null)notSkill = true;
			LDisplay.drawRect(this.graphics,[lblX,lblY,240,65],false,0xffffff,1,2);
			var lblTitle:LLabel = new LLabel();
			lblTitle.htmlText = "<font color='#ffffff' size='20'><b>特技</b></font>";
			lblTitle.x = lblX + 5;
			lblTitle.y = lblY + 5;
			this.addChild(lblTitle);
			var lblComment:LLabel;
			if(!notSkill){
				var lblSkill:LLabel = new LLabel();
				lblSkill.htmlText = "<font color='#ffffff' size='20'><b>"+skill.Name+"</b></font>";
				lblSkill.x = lblX + 55;
				lblSkill.y = lblY + 5;
				this.addChild(lblSkill);
				
				lblComment = new LLabel();
				lblComment.htmlText = "<font color='#ffffff' size='15'>"+skill.Introduction+"</font>";
				lblComment.autoSize =LTextField.NONE;
				lblComment.width = 240;
				lblComment.wordWrap = true;
				lblComment.x = lblX + 5;
				lblComment.y = lblY + 27;
				this.addChild(lblComment);
			}else{
				lblComment = new LLabel();
				lblComment.htmlText = "<font color='#ffffff' size='15'>无</font>";
				lblComment.x = lblX + 5;
				lblComment.y = lblY + 27;
				this.addChild(lblComment);
			}
		}
		/**
		 * 显示兵种信息
		 */
		private function addArms():void{
			LDisplay.drawRect(this.graphics,[510,10,250,240],false,0xffffff,1,2);
			
			var lblArmsName:LLabel = new LLabel();
			lblArmsName.htmlText = "<font color='#ffffff' size='20'><b>" + LSouSouObject.charaSNow.member.armsName + "</b></font>";
			lblArmsName.x = 520;
			lblArmsName.y = 15;
			this.addChild(lblArmsName);
			
			var armsProperty:XMLList = LSouSouObject.charaSNow.member.armsProperty;
			var lblX:int = 520;
			var lblY:int = -40;
			var attackBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_icon_attack.png"));
			attackBitmap.smoothing = true;
			attackBitmap.width = 20;
			attackBitmap.height = 20;
			attackBitmap.x = lblX;
			attackBitmap.y = lblY + 90;
			this.addChild(attackBitmap);
			var attack:int = LSouSouObject.charaSNow.member.attack;
			var lblAttack:LLabel = new LLabel();
			lblAttack.htmlText = "<font color='#ffffff' size='15'>" + armsProperty["Attack"] + "</font>";
			lblAttack.x = lblX + 40;
			lblAttack.y = lblY + 90;
			this.addChild(lblAttack);
			
			var spiritBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_icon_strategy.png"));
			spiritBitmap.smoothing = true;
			spiritBitmap.width = 20;
			spiritBitmap.height = 20;
			spiritBitmap.x = lblX;
			spiritBitmap.y = lblY + 120;
			this.addChild(spiritBitmap);
			var spirit:int = LSouSouObject.charaSNow.member.spirit;
			var lblSpirit:LLabel = new LLabel();
			lblSpirit.htmlText = "<font color='#ffffff' size='15'>" + armsProperty["Spirit"] + "</font>";
			lblSpirit.x = lblX + 40;
			lblSpirit.y = lblY + 120;
			this.addChild(lblSpirit);
			
			var defenseBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"shield.png"));
			defenseBitmap.smoothing = true;
			defenseBitmap.width = 20;
			defenseBitmap.height = 20;
			defenseBitmap.x = lblX;
			defenseBitmap.y = lblY + 150;
			this.addChild(defenseBitmap);
			var defense:int = LSouSouObject.charaSNow.member.defense;
			var lblDefense:LLabel = new LLabel();
			lblDefense.htmlText = "<font color='#ffffff' size='15'>" + armsProperty["Defense"] + "</font>";
			lblDefense.x = lblX + 40;
			lblDefense.y = lblY + 150;
			this.addChild(lblDefense);
			
			var breakoutBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"ring.png"));
			breakoutBitmap.smoothing = true;
			breakoutBitmap.width = 20;
			breakoutBitmap.height = 20;
			breakoutBitmap.x = lblX;
			breakoutBitmap.y = lblY + 180;
			this.addChild(breakoutBitmap);
			var breakout:int = LSouSouObject.charaSNow.member.breakout;
			var lblBreakout:LLabel = new LLabel();
			lblBreakout.htmlText = "<font color='#ffffff' size='15'>" + armsProperty["Breakout"] + "</font>";
			lblBreakout.x = lblX + 40;
			lblBreakout.y = lblY + 180;
			this.addChild(lblBreakout);
			
			var moraleBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"flag.png"));
			moraleBitmap.smoothing = true;
			moraleBitmap.width = 20;
			moraleBitmap.height = 20;
			moraleBitmap.x = lblX;
			moraleBitmap.y = lblY + 210;
			this.addChild(moraleBitmap);
			var morale:int = LSouSouObject.charaSNow.member.morale;
			var lblMorale:LLabel = new LLabel();
			lblMorale.htmlText = "<font color='#ffffff' size='15'>" + armsProperty["Morale"] + "</font>";
			lblMorale.width = 230;
			lblMorale.x = lblX + 40;
			lblMorale.y = lblY + 210;
			this.addChild(lblMorale);
			
			var moveBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_icon_move.png"));
			moveBitmap.smoothing = true;
			moveBitmap.width = 20;
			moveBitmap.height = 20;
			moveBitmap.x = lblX;
			moveBitmap.y = lblY + 240;
			this.addChild(moveBitmap);
			var move:int = LSouSouObject.charaSNow.member.distance;
			var lblMove:LLabel = new LLabel();
			lblMove.htmlText = "<font color='#ffffff' size='15'>" + move + "</font>";
			lblMove.width = 230;
			lblMove.x = lblX + 40;
			lblMove.y = lblY + 240;
			this.addChild(lblMove);
			
			var arms:LBitmap = new LBitmap(LSouSouObject.charaSNow.bitmapData.clone());
			arms.x = 650;
			arms.y = 20;
			this.addChild(arms);
			
			//LDisplay.drawRect(this.graphics,[620,80,120,120],true,0xffffff,0.5,0);
			var attRect:XMLList = LSouSouObject.charaSNow.rangeAttack;
			var attRectsWidth:int = 120;
			var attRectCount:int = 3;
			var nodeStr:String;
			var nodeArr:Array;
			for each(nodeStr in attRect){
				nodeArr = nodeStr.split(",");
				if(attRectCount < Math.abs(int(nodeArr[0])))attRectCount = Math.abs(int(nodeArr[0]));
				if(attRectCount < Math.abs(int(nodeArr[1])))attRectCount = Math.abs(int(nodeArr[1]));
			}
			var attRectWidth:Number = attRectsWidth/(attRectCount*2 + 1);
			var i:int,j:int;
			var rx:int = 620 + attRectCount*attRectWidth;
			var ry:int = 80 + attRectCount*attRectWidth;
			this.graphics.lineStyle(0,0x000000);
			for(i = -attRectCount;i<attRectCount + 1;i++){
				LDisplay.drawRect(this.graphics,[rx + attRectWidth*i,ry - attRectWidth*attRectCount,attRectWidth,attRectWidth*(attRectCount*2+1)],true,0x999999,0.5,0);
			}
			this.graphics.lineStyle(0,0x000000);
			for(i = -attRectCount;i<attRectCount + 1;i++){
				LDisplay.drawRect(this.graphics,[rx - attRectWidth*attRectCount,ry + attRectWidth*i,attRectWidth*(attRectCount*2+1),attRectWidth],true,0x999999,0.5,0);
			}
			LDisplay.drawRect(this.graphics,[rx,ry,attRectWidth,attRectWidth],true,0x0000ff,0.5,0);
			for each(nodeStr in attRect){
				nodeArr = nodeStr.split(",");
				LDisplay.drawRect(this.graphics,[rx + int(nodeArr[0])*attRectWidth,ry + int(nodeArr[1])*attRectWidth,attRectWidth,attRectWidth],true,0xff0000,0.5,0);
			}
			LDisplay.drawRect(this.graphics,[510,340,250,130],false,0xffffff,1,2);
			LDisplay.drawRect(this.graphics,[512,342,246,126],false,0x000000,1,2);
			LDisplay.drawRect(this.graphics,[514,344,242,122],false,0xffffff,1,2);
			
			var lblIntroduction:LLabel = new LLabel();
			lblIntroduction.htmlText = "<font color='#ffffff' size='15'>" + LSouSouObject.charaSNow.member.armIntroduction + "</font>";
			lblIntroduction.autoSize = LTextField.NONE;
			lblIntroduction.wordWrap = true;
			lblIntroduction.width = 240;
			lblIntroduction.x = 520;
			lblIntroduction.y = 350;
			this.addChild(lblIntroduction);
		}
		/**
		 * 显示装备
		 */
		private function addEquipment():void{
			LDisplay.drawRect(this.graphics,[510,260,250,70],false,0xffffff,1,2);
			LDisplay.drawRect(this.graphics,[520,270,50,50],true,0xffffff,0.5,0);
			LDisplay.drawRect(this.graphics,[580,270,50,50],true,0xffffff,0.5,0);
			LDisplay.drawRect(this.graphics,[640,270,50,50],true,0xffffff,0.5,0);
			LDisplay.drawRect(this.graphics,[700,270,50,50],true,0xffffff,0.5,0);
			
			var helmet:XMLList = LSouSouObject.charaSNow.member.helmet;
			var equipment:XMLList = LSouSouObject.charaSNow.member.equipment;
			var weapon:XMLList = LSouSouObject.charaSNow.member.weapon;
			var horse:XMLList = LSouSouObject.charaSNow.member.horse;
			trace("addEquipment = ",helmet,equipment,weapon,horse);
			//饰品
			if(int(helmet.toString()) > 0){
				var helmetBit:LBitmap = new LBitmap(
					LGlobal.getBitmapData(
						LGlobal.script.scriptArray.swfList["item"],
						LSouSouObject.item["Child" + helmet.toString()]["Icon"]
					)
				);
				helmetBit.width = 50;
				helmetBit.height = 50;
				helmetBit.xy = new LCoordinate(520,270);
				this.addChild(helmetBit);
			}
			//装备
			if(int(equipment.toString()) > 0){
				var equipmentBit:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["item"],
					LSouSouObject.item["Child" + equipment.toString()]["Icon"]));
				equipmentBit.width = 50;
				equipmentBit.height = 50;
				equipmentBit.xy = new LCoordinate(580,270);
				this.addChild(equipmentBit);
			}
			//武器
			if(int(weapon.toString()) > 0){
				var weaponBit:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["item"],
					LSouSouObject.item["Child" + weapon.toString()]["Icon"]));
				weaponBit.width = 50;
				weaponBit.height = 50;
				weaponBit.xy = new LCoordinate(640,270);
				this.addChild(weaponBit);
			}
			//坐骑
			if(int(horse.toString()) > 0){
				var horseBit:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["item"],
					LSouSouObject.item["Child" + horse.toString()]["Icon"]));
				horseBit.width = 50;
				horseBit.height = 50;
				horseBit.xy = new LCoordinate(700,270);
				this.addChild(horseBit);
			}
		}
		/**
		 * 显示基本状态
		 */
		private function addStatus():void{
			LDisplay.drawRect(this.graphics,[260,10,240,240],false,0xffffff,1,2);
			
			
			var lblX:int = 400;
			var lblY:int = 105;
			var lblForce:LLabel = new LLabel();
			lblForce.htmlText = "<font color='#ffffff' size='15'><b>武力</b></font>";
			lblForce.x = lblX;
			lblForce.y = lblY;
			this.addChild(lblForce);
			lblForce = new LLabel();
			lblForce.htmlText = "<font color='#ffffff' size='15'>" + LSouSouObject.charaSNow.member.force+ "</font>";
			lblForce.x = lblX + 50;
			lblForce.y = lblY;
			this.addChild(lblForce);
			var lblIntelligence:LLabel = new LLabel();
			lblIntelligence.htmlText = "<font color='#ffffff' size='15'><b>智力</b></font>";
			lblIntelligence.x = lblX;
			lblIntelligence.y = lblY + 30;
			this.addChild(lblIntelligence);
			lblIntelligence = new LLabel();
			lblIntelligence.htmlText = "<font color='#ffffff' size='15'>" + LSouSouObject.charaSNow.member.intelligence+ "</font>";
			lblIntelligence.x = lblX + 50;
			lblIntelligence.y = lblY + 30;
			this.addChild(lblIntelligence);
			var lblCommand:LLabel = new LLabel();
			lblCommand.htmlText = "<font color='#ffffff' size='15'><b>统帅</b></font>";
			lblCommand.x = lblX;
			lblCommand.y = lblY + 60;
			this.addChild(lblCommand);
			lblCommand = new LLabel();
			lblCommand.htmlText = "<font color='#ffffff' size='15'>" + LSouSouObject.charaSNow.member.command+ "</font>";
			lblCommand.x = lblX + 50;
			lblCommand.y = lblY + 60;
			this.addChild(lblCommand);
			var lblAgile:LLabel = new LLabel();
			lblAgile.htmlText = "<font color='#ffffff' size='15'><b>敏捷</b></font>";
			lblAgile.x = lblX;
			lblAgile.y = lblY + 90;
			this.addChild(lblAgile);
			lblAgile = new LLabel();
			lblAgile.htmlText = "<font color='#ffffff' size='15'>" + LSouSouObject.charaSNow.member.agile+ "</font>";
			lblAgile.x = lblX + 50;
			lblAgile.y = lblY + 90;
			this.addChild(lblAgile);
			var lblLuck:LLabel = new LLabel();
			lblLuck.htmlText = "<font color='#ffffff' size='15'><b>运气</b></font>";
			lblLuck.x = lblX;
			lblLuck.y = lblY + 120;
			this.addChild(lblLuck);
			lblLuck = new LLabel();
			lblLuck.htmlText = "<font color='#ffffff' size='15'>" + LSouSouObject.charaSNow.member.luck+ "</font>";
			lblLuck.x = lblX + 50;
			lblLuck.y = lblY + 120;
			this.addChild(lblLuck);
			
			lblX = 265;
			lblY = 15;
			var exp:LLabel = new LLabel();
			exp.htmlText = "<font color='#ffffff' size='15'>Exp</font>";
			exp.x = lblX;
			exp.y = lblY;
			this.addChild(exp);
			this.graphics.lineStyle(0);
			LDisplay.drawRect(this.graphics,[lblX + 140 - LSouSouObject.charaSNow.member.exp,lblY + 5,LSouSouObject.charaSNow.member.exp,10],true,0xff0000,1,0);
			LDisplay.drawRect(this.graphics,[lblX + 40,lblY + 5,100,10],false,0xcccccc,1,2);
			var lblExp:LLabel = new LLabel();
			lblExp.htmlText = "<font color='#ffffff' size='15'>" + LSouSouObject.charaSNow.member.exp + "/100</font>";
			lblExp.x = lblX + 150;
			lblExp.y = lblY;
			this.addChild(lblExp);
			
			var hertBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"hert.png"));
			hertBitmap.width = 20;
			hertBitmap.height = 20;
			hertBitmap.x = lblX;
			hertBitmap.y = lblY + 30;
			this.addChild(hertBitmap);
			var troops:int = LSouSouObject.charaSNow.member.troops;
			var maxTroops:int = LSouSouObject.charaSNow.member.maxTroops;
			this.graphics.lineStyle(0);
			LDisplay.drawRect(this.graphics,[lblX + 140 - int(troops*100/maxTroops),lblY + 35,int(troops*100/maxTroops),10],true,0xff0000,1,0);
			LDisplay.drawRect(this.graphics,[lblX + 40,lblY + 35,100,10],false,0xcccccc,1,2);
			var lblTroops:LLabel = new LLabel();
			lblTroops.htmlText = "<font color='#ffffff' size='15'>" + troops + "/" + maxTroops + "</font>";
			lblTroops.x = lblX + 150;
			lblTroops.y = lblY + 30;
			this.addChild(lblTroops);
			
			var fanBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"fan.png"));
			fanBitmap.smoothing = true;
			fanBitmap.width = 20;
			fanBitmap.height = 20;
			fanBitmap.x = lblX;
			fanBitmap.y = lblY + 60;
			this.addChild(fanBitmap);
			var strategy:int = LSouSouObject.charaSNow.member.strategy;
			var maxStrategy:int = LSouSouObject.charaSNow.member.maxStrategy;
			this.graphics.lineStyle(0);
			LDisplay.drawRect(this.graphics,[lblX + 140 - int(strategy*100/maxStrategy),lblY + 65,int(strategy*100/maxStrategy),10],true,0xff0000,1,0);
			LDisplay.drawRect(this.graphics,[lblX + 40,lblY + 65,100,10],false,0xcccccc,1,2);
			var lblStrategy:LLabel = new LLabel();
			lblStrategy.htmlText = "<font color='#ffffff' size='15'>" + strategy + "/" + maxStrategy + "</font>";
			lblStrategy.x = lblX + 150;
			lblStrategy.y = lblY + 60;
			this.addChild(lblStrategy);
			
			var attackBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_icon_attack.png"));
			attackBitmap.smoothing = true;
			attackBitmap.width = 20;
			attackBitmap.height = 20;
			attackBitmap.x = lblX;
			attackBitmap.y = lblY + 90;
			this.addChild(attackBitmap);
			var attack:int = LSouSouObject.charaSNow.member.attack;
			var addAtk:int = int(LSouSouObject.charaSNow.statusArray[LSouSouCharacterS.STATUS_ATTACK][2]);
			var lblAttack:LLabel = new LLabel();
			lblAttack.htmlText = "<font color='#ffffff' size='15'>" + (attack+addAtk) + "/" + attack + "("+addAtk+")" + "</font>";
			lblAttack.x = lblX + 40;
			lblAttack.y = lblY + 90;
			this.addChild(lblAttack);
			
			var spiritBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_icon_strategy.png"));
			spiritBitmap.smoothing = true;
			spiritBitmap.width = 20;
			spiritBitmap.height = 20;
			spiritBitmap.x = lblX;
			spiritBitmap.y = lblY + 120;
			this.addChild(spiritBitmap);
			var spirit:int = LSouSouObject.charaSNow.member.spirit;
			var lblSpirit:LLabel = new LLabel();
			lblSpirit.htmlText = "<font color='#ffffff' size='15'>" + spirit + "/" + spirit + "</font>";
			lblSpirit.x = lblX + 40;
			lblSpirit.y = lblY + 120;
			this.addChild(lblSpirit);
			
			var defenseBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"shield.png"));
			defenseBitmap.smoothing = true;
			defenseBitmap.width = 20;
			defenseBitmap.height = 20;
			defenseBitmap.x = lblX;
			defenseBitmap.y = lblY + 150;
			this.addChild(defenseBitmap);
			var defense:int = LSouSouObject.charaSNow.member.defense;
			var addDef:int = int(LSouSouObject.charaSNow.statusArray[LSouSouCharacterS.STATUS_DEFENSE][2]);
			var lblDefense:LLabel = new LLabel();
			lblDefense.htmlText = "<font color='#ffffff' size='15'>" + (defense + addDef) + "/" + defense + "("+addDef+")" + "</font>";
			lblDefense.x = lblX + 40;
			lblDefense.y = lblY + 150;
			this.addChild(lblDefense);
			
			var breakoutBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"ring.png"));
			breakoutBitmap.smoothing = true;
			breakoutBitmap.width = 20;
			breakoutBitmap.height = 20;
			breakoutBitmap.x = lblX;
			breakoutBitmap.y = lblY + 180;
			this.addChild(breakoutBitmap);
			var breakout:int = LSouSouObject.charaSNow.member.breakout;
			var lblBreakout:LLabel = new LLabel();
			lblBreakout.htmlText = "<font color='#ffffff' size='15'>" + breakout + "/" + breakout + "</font>";
			lblBreakout.x = lblX + 40;
			lblBreakout.y = lblY + 180;
			this.addChild(lblBreakout);
			
			var moraleBitmap:LBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"flag.png"));
			moraleBitmap.smoothing = true;
			moraleBitmap.width = 20;
			moraleBitmap.height = 20;
			moraleBitmap.x = lblX;
			moraleBitmap.y = lblY + 210;
			this.addChild(moraleBitmap);
			var morale:int = LSouSouObject.charaSNow.member.morale;
			var lblMorale:LLabel = new LLabel();
			lblMorale.htmlText = "<font color='#ffffff' size='15'>" + morale + "/" + morale + "</font>";
			lblMorale.width = 230;
			lblMorale.x = lblX + 40;
			lblMorale.y = lblY + 210;
			this.addChild(lblMorale);
		}
		/**
		 * 显示按钮
		 */
		private function addButton():void{
			var bitmapup:BitmapData = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"close2");
			//var bitmapover:BitmapData = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"close_over");
			var btnClose:LButton = new LButton(bitmapup);
			btnClose.xy = new LCoordinate(750,10);
			btnClose.addEventListener(MouseEvent.MOUSE_UP,function (event:MouseEvent):void{
				removeFromParent();
			});
			this.addChild(btnClose);
		}
		/**
		 * 显示头像姓名简介
		 */
		private function addFace():void{
			
			var facedata:BitmapData;
			var faceIndex:int = LSouSouObject.chara["peo"+LSouSouObject.charaSNow.index]["Face"];
			if(faceIndex >= LSouSouObject.charaFaceList.length){
				facedata = new BitmapData(240,240,false,0x000000);
			}else{
				facedata = LSouSouObject.charaFaceList[faceIndex];
			}
			
			//var facedata:BitmapData = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["face"],
				//"face" + LSouSouObject.charaSNow.member.face +"-0");
			facedata.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar02.png"),
				new Rectangle(0,0,240,5),new Point(0,0));
			facedata.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar04.png"),
				new Rectangle(0,0,5,240),new Point(0,0));
			facedata.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar05.png"),
				new Rectangle(0,0,5,240),new Point(235,0));
			facedata.copyPixels(LImage.vertical(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar02.png")),
				new Rectangle(0,0,240,5),new Point(0,235));
			facedata.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar01.png"),
				new Rectangle(0,0,15,15),new Point(0,0));
			facedata.copyPixels(LImage.vertical(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar01.png")),
				new Rectangle(0,0,15,15),new Point(0,225));
			facedata.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar03.png"),
				new Rectangle(0,0,15,15),new Point(225,0));
			facedata.copyPixels(LImage.vertical(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar03.png")),
				new Rectangle(0,0,15,15),new Point(225,225));
			var face:LBitmap = new LBitmap(facedata);
			face.x = 10;
			face.y = 10;
			this.addChild(face);
			
			LDisplay.drawRect(this.graphics,[10,260,240,29],false,0xffffff,1,2);
			var lblName:LLabel = new LLabel();
			lblName.htmlText = "<font color='#ffffff' size='20'><b>"+LSouSouObject.charaSNow.member.name+"</b></font>";
			lblName.x = 15;
			lblName.y = 261;
			this.addChild(lblName);
			var lblLv:LLabel = new LLabel();
			lblLv.htmlText = "<font color='#ffffff' size='20'><b>Lv."+LSouSouObject.charaSNow.member.lv+"</b></font>";
			lblLv.x = 110;
			lblLv.y = 261;
			this.addChild(lblLv);
			var lblBelong:LLabel = new LLabel();
			lblBelong.htmlText = "<font color='#ffffff' size='20'><b>"+(LSouSouObject.charaSNow.belong==LSouSouObject.BELONG_SELF?"我军":(LSouSouObject.charaSNow.belong==LSouSouObject.BELONG_FRIEND?"友军":"敌军"))+"</b></font>";
			lblBelong.x = 180;
			lblBelong.y = 261;
			this.addChild(lblBelong);
			
			
			LDisplay.drawRect(this.graphics,[10,300,240,170],false,0xffffff,1,2);
			LDisplay.drawRect(this.graphics,[12,302,236,166],false,0x000000,1,2);
			LDisplay.drawRect(this.graphics,[14,304,232,162],false,0xffffff,1,2);
			var lblIntroduction:LLabel = new LLabel();
			lblIntroduction.htmlText = "<font color='#ffffff' size='15'>" + LSouSouObject.charaSNow.member.introduction + "</font>";
			lblIntroduction.autoSize = LTextField.NONE;
			lblIntroduction.wordWrap = true;
			lblIntroduction.width = 230;
			lblIntroduction.x = 15;
			lblIntroduction.y = 310;
			this.addChild(lblIntroduction);
			
		}
		/**
		 * 显示背景
		 */
		private function addBackground():void{
			LDisplay.drawRect(this.graphics,[0,0,800,480],true,0x000000,0.7,5);
			//LDisplay.drawRect(this.graphics,[50,50,700,250],false,0xffffff,1,2);
			//LDisplay.drawRect(this.graphics,[50,320,700,100],false,0xffffff,1,2);
			var _menuBitmap:LBitmap;
			_menuBitmap = new LBitmap(new BitmapData(LGlobal.stage.stageWidth,5,true));
			_menuBitmap.bitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar02.png"),
				new Rectangle(0,0,_menuBitmap.width,_menuBitmap.height),new Point(0,0));
			this.addChild(_menuBitmap);
			_menuBitmap = new LBitmap(new BitmapData(5,LGlobal.stage.stageHeight,true));
			_menuBitmap.bitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar04.png"),
				new Rectangle(0,0,_menuBitmap.width,_menuBitmap.height),new Point(0,0));
			this.addChild(_menuBitmap);
			_menuBitmap = new LBitmap(new BitmapData(5,LGlobal.stage.stageHeight,true));
			_menuBitmap.bitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar05.png"),
				new Rectangle(0,0,_menuBitmap.width,_menuBitmap.height),new Point(0,0));
			_menuBitmap.x = LGlobal.stage.stageWidth - 5;
			this.addChild(_menuBitmap);
			_menuBitmap = new LBitmap(new BitmapData(LGlobal.stage.stageWidth,5,true));
			_menuBitmap.bitmapData.copyPixels(LImage.vertical(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar02.png")),
				new Rectangle(0,0,_menuBitmap.width,_menuBitmap.height),new Point(0,0));
			_menuBitmap.y = LGlobal.stage.stageHeight - 5;
			this.addChild(_menuBitmap);
			
			_menuBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar01.png"));
			this.addChild(_menuBitmap);
			_menuBitmap = new LBitmap(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar03.png"));
			_menuBitmap.x = LGlobal.stage.stageWidth - 15;
			this.addChild(_menuBitmap);
			_menuBitmap = new LBitmap(LImage.vertical(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar01.png")));
			_menuBitmap.y = LGlobal.stage.stageHeight - 15;
			this.addChild(_menuBitmap);
			_menuBitmap = new LBitmap(LImage.vertical(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar03.png")));
			_menuBitmap.x = LGlobal.stage.stageWidth - 15;
			_menuBitmap.y = LGlobal.stage.stageHeight - 15;
			this.addChild(_menuBitmap);
		}
	}
}