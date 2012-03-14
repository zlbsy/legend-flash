package zhanglubin.legend.game.sousou.map.window
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	import zhanglubin.legend.components.LLabel;
	import zhanglubin.legend.components.LRadio;
	import zhanglubin.legend.components.LRadioChild;
	import zhanglubin.legend.display.LBitmap;
	import zhanglubin.legend.display.LButton;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.events.LEvent;
	import zhanglubin.legend.game.sousou.map.LSouSouWindow;
	import zhanglubin.legend.game.sousou.object.LSouSouObject;
	import zhanglubin.legend.utils.LDisplay;
	import zhanglubin.legend.utils.LFilter;
	import zhanglubin.legend.utils.LGlobal;

	public class LSouSouWindwoCondition extends LSouSouWindow
	{
		
		public function LSouSouWindwoCondition()
		{
			super();
		}
		public function show(param:Array,clickMenu:Boolean = false):void{
			LSouSouObject.sMap.condition = param;
			//战场名称
			var sName:String = param[0];
			//胜利条件
			var winText:String = param[1];
			//失败条件
			var failText:String = param[2];
			
			LDisplay.drawRect(this.graphics,[0,0,LGlobal.stage.stageWidth,LGlobal.stage.stageHeight],true,0x000000,0.7,5);
			
			var lblText:LLabel;
			
			setBox(0,0,LGlobal.stage.stageWidth,LGlobal.stage.stageHeight);
			
			var _menuX:int = 50;
			var _menuY:int = 20;
			var _menuW:int = 400;
			var _menuH:int = 50;
			setBox(_menuX,_menuY,_menuW,_menuH);
			lblText = new LLabel();
			lblText.htmlText = "<font size='30' color='#ffffff'><b>" + sName + "</b></font>";
			lblText.x = _menuX + 10;
			lblText.y = _menuY + 5;
			this.addChild(lblText);
			
			_menuX = 500;
			_menuY = 20;
			_menuW = 100;
			_menuH = 50;
			setBox(_menuX,_menuY,_menuW,_menuH);
			lblText = new LLabel();
			lblText.htmlText = "<font size='30' color='#ffffff'><b>回合</b></font>";
			lblText.x = _menuX + 10;
			lblText.y = _menuY + 5;
			this.addChild(lblText);
			_menuX = 600;
			_menuY = 20;
			_menuW = 150;
			_menuH = 50;
			setBox(_menuX,_menuY,_menuW,_menuH);
			lblText = new LLabel();
			lblText.htmlText = "<font size='30' color='#ffffff'><b>" + LSouSouObject.sMap.roundCount +"/" + LSouSouObject.sMap.roundMax + "</b></font>";
			lblText.x = _menuX + 10;
			lblText.y = _menuY + 5;
			this.addChild(lblText);
			
			_menuX = 50;
			_menuY = 80;
			_menuW = 80;
			_menuH = 40;
			setBox(_menuX,_menuY,_menuW,_menuH);
			lblText = new LLabel();
			lblText.htmlText = "<font size='25' color='#ffffff'><b>天气</b></font>";
			lblText.x = _menuX + 10;
			lblText.y = _menuY + 3;
			this.addChild(lblText);
			_menuX = 130;
			_menuY = 80;
			_menuW = 140;
			_menuH = 40;
			setBox(_menuX,_menuY,_menuW,_menuH);
			lblText = new LLabel();
			lblText.htmlText = "<font size='25' color='#ffffff'><b>" + LSouSouObject.sMap.weather[LSouSouObject.sMap.weatherIndex][0] + "</b></font>";
			lblText.x = _menuX + 10;
			lblText.y = _menuY + 3;
			this.addChild(lblText);
			
			_menuX = 50;
			_menuY = 150;
			_menuW = 160;
			_menuH = 50;
			setBox(_menuX,_menuY,_menuW,_menuH);
			lblText = new LLabel();
			lblText.htmlText = "<font size='30' color='#ffffff'><b>胜利条件:</b></font>";
			lblText.x = _menuX + 10;
			lblText.y = _menuY + 5;
			this.addChild(lblText);
			_menuX = 210;
			_menuY = 150;
			_menuW = 550;
			_menuH = 120;
			setBox(_menuX,_menuY,_menuW,_menuH);
			lblText = new LLabel();
			while(winText.indexOf("\\n")>=0)winText = winText.replace("\\n","\n");
			lblText.htmlText = "<font size='20' color='#ffffff'><b>"+winText+"</b></font>";
			lblText.x = _menuX + 10;
			lblText.y = _menuY + 5;
			this.addChild(lblText);
			
			_menuX = 50;
			_menuY = 270;
			_menuW = 160;
			_menuH = 50;
			setBox(_menuX,_menuY,_menuW,_menuH);
			lblText = new LLabel();
			lblText.htmlText = "<font size='30' color='#ffffff'><b>失败条件:</b></font>";
			lblText.x = _menuX + 10;
			lblText.y = _menuY + 5;
			this.addChild(lblText);
			_menuX = 210;
			_menuY = 270;
			_menuW = 550;
			_menuH = 120;
			setBox(_menuX,_menuY,_menuW,_menuH);
			lblText = new LLabel();
			while(failText.indexOf("\\n")>=0)failText = failText.replace("\\n","\n");
			lblText.htmlText = "<font size='20' color='#ffffff'><b>"+failText+"</b></font>";
			lblText.x = _menuX + 10;
			lblText.y = _menuY + 5;
			this.addChild(lblText);
			var bitmapover:BitmapData = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"logobtnover.png");
			if(clickMenu){
				//var bitmapup:BitmapData = LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"logobtnover.png");
				//var btnDeparture:LButton = new LButton(bitmapup,bitmapover,bitmapover);
				var btnRoundOver:LButton = new LButton(bitmapover);
				btnRoundOver.labelColor = "#ffffff";
				btnRoundOver.label = "回合结束";
				btnRoundOver.x = (LGlobal.stage.width - btnRoundOver.width)/2 - btnRoundOver.width/2-10;
				btnRoundOver.y = 410;
				btnRoundOver.addEventListener(MouseEvent.MOUSE_UP,
					function (event:MouseEvent):void{
						//LSouSouObject.window.removeFromParent();
						//LGlobal.script.analysis();
						LSouSouObject.window.die();
						LSouSouObject.window.isEndRoundSelect();
					});
				this.addChild(btnRoundOver);
				
				//var btnDeparture:LButton = new LButton(bitmapup,bitmapover,bitmapover);
				var btnContinue:LButton = new LButton(bitmapover);
				btnContinue.labelColor = "#ffffff";
				btnContinue.label = "继续游戏";
				btnContinue.x = (LGlobal.stage.width - btnContinue.width)/2 + btnContinue.width/2+10;
				btnContinue.y = 410;
				btnContinue.addEventListener(MouseEvent.MOUSE_UP,
					function (event:MouseEvent):void{
						LSouSouObject.window.removeFromParent();
						LGlobal.script.analysis();
					});
				this.addChild(btnContinue);
			}else{
				var btnStart:LButton = new LButton(bitmapover);
				btnStart.labelColor = "#ffffff";
				btnStart.label = "开始战斗";
				btnStart.x = (LGlobal.stage.width - btnStart.width)/2;
				btnStart.y = 410;
				btnStart.addEventListener(MouseEvent.MOUSE_UP,
					function (event:MouseEvent):void{
						LSouSouObject.window.removeFromParent();
						LGlobal.script.analysis();
					});
				this.addChild(btnStart);
			}
			LSouSouObject.window = this;
		}
	}
}