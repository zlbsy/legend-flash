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

	public class LSouSouWindwoSystem extends LSouSouWindow
	{
		private const TITLE_STXT:String = "游戏设定";
		private const RETURN_STXT:String = "返回游戏";
		private const AVERAGE:String = "普通";
		private const FAST:String = "快速";
		private const SPEED_STXT:String = "游戏速度设定";
		private const VALID:String = "有效";
		private const SCRIPT_SOUND_ON:String = "SouSouSound.musicMode(1)";
		private const SCRIPT_SOUND_OFF:String = "SouSouSound.musicMode(0)";
		private const COLOR_WHITE:String = "#ffffff";
		private const INVALID:String = "无效";
		private const SOUND_STXT:String = "游戏音效设定";
		
		public function LSouSouWindwoSystem()
		{
			super();
		}
		public function showSet():void{
			LDisplay.drawRect(this.graphics,[0,0,LGlobal.stage.stageWidth,LGlobal.stage.stageHeight],true,0x000000,0.8,5);
			LSouSouObject.window = this;
			var fun:Function;
			
			setBox(0,0,LGlobal.stage.stageWidth,LGlobal.stage.stageHeight);
			
			var title:LSprite = LGlobal.getColorText(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList[LSouSouObject.STR_IMG],LSouSouObject.STR_COLOR),TITLE_STXT,50);
			title.x = 50;
			title.y = 20;
			this.addChild(title);
			
			//游戏速度设定
			setBox(50,120,LGlobal.stage.stageWidth - 100,100);
			
			var titlespeed:LSprite = LGlobal.getColorText(new BitmapData(50,50,false,0x990000),SPEED_STXT,25);
			titlespeed.x = 60;
			titlespeed.y = 130;
			this.addChild(titlespeed);
			
			var titleAve:LSprite = LGlobal.getColorText(new BitmapData(50,50,false,0x0000ff),AVERAGE,20);
			titleAve.x = 100;
			titleAve.y = titlespeed.y + 40;
			this.addChild(titleAve);
			
			var titleFast:LSprite = LGlobal.getColorText(new BitmapData(50,50,false,0x0000ff),FAST,20);
			titleFast.x = 200;
			titleFast.y = titlespeed.y + 40;
			this.addChild(titleFast);
			
			var radioSpeed:LRadio = new LRadio();
			var radioChild:LRadioChild;
			var btn:LButton,bit:LBitmap;
			btn = new LButton(this.getBoxBitmapData(25,25));
			LFilter.setFilter(btn,LFilter.GRAY);
			bit = new LBitmap(this.getBoxBitmapData(25,25));
			LFilter.setFilter(bit,LFilter.SUN);
			radioChild = new LRadioChild(0,bit,btn);
			radioChild.x = 0;
			radioSpeed.push(radioChild);
			btn = new LButton(this.getBoxBitmapData(25,25));
			LFilter.setFilter(btn,LFilter.GRAY);
			bit = new LBitmap(this.getBoxBitmapData(25,25));
			LFilter.setFilter(bit,LFilter.SUN);
			radioChild = new LRadioChild(1,bit,btn);
			radioChild.x = 100;
			radioSpeed.push(radioChild);
			radioSpeed.x = 150;
			radioSpeed.y = titlespeed.y + 40;
			if(LGlobal.script.scriptArray.varList[LSouSouObject.SPEED_FLAG] == LSouSouObject.FAST){
				radioSpeed.value = 1;
			}else{
				radioSpeed.value = 0;
			}
			fun = function():void{
				if(radioSpeed.value == 0){
					LGlobal.script.scriptArray.varList[LSouSouObject.SPEED_FLAG] = LSouSouObject.AVERAGE;
				}else{
					LGlobal.script.scriptArray.varList[LSouSouObject.SPEED_FLAG] = LSouSouObject.FAST;
				}
			}
			radioSpeed.addEventListener(LEvent.RADIO_VALUE_CHANGE,fun);
			this.addChild(radioSpeed);
			
			
			//游戏音效设定
			setBox(50,250,LGlobal.stage.stageWidth - 100,100);
			
			var soundtitle:LSprite = LGlobal.getColorText(new BitmapData(50,50,false,0x660099),SOUND_STXT,25);
			soundtitle.x = 60;
			soundtitle.y = 260;
			this.addChild(soundtitle);
			
			var titleVaild:LSprite = LGlobal.getColorText(new BitmapData(50,50,false,0x0000ff),VALID,20);
			titleVaild.x = 100;
			titleVaild.y = soundtitle.y + 40;
			this.addChild(titleVaild);
			
			var titleInvaild:LSprite = LGlobal.getColorText(new BitmapData(50,50,false,0x0000ff),INVALID,20);
			titleInvaild.x = 200;
			titleInvaild.y = soundtitle.y + 40;
			this.addChild(titleInvaild);
			
			var radioSound:LRadio = new LRadio();
			btn = new LButton(this.getBoxBitmapData(25,25));
			LFilter.setFilter(btn,LFilter.GRAY);
			bit = new LBitmap(this.getBoxBitmapData(25,25));
			LFilter.setFilter(bit,LFilter.SUN);
			radioChild = new LRadioChild(0,bit,btn);
			radioChild.x = 0;
			radioSound.push(radioChild);
			btn = new LButton(this.getBoxBitmapData(25,25));
			LFilter.setFilter(btn,LFilter.GRAY);
			bit = new LBitmap(this.getBoxBitmapData(25,25));
			LFilter.setFilter(bit,LFilter.SUN);
			radioChild = new LRadioChild(1,bit,btn);
			radioChild.x = 100;
			radioSound.push(radioChild);
			radioSound.x = 150;
			radioSound.y = soundtitle.y + 40;
			
			if(LGlobal.script.scriptArray.varList[LSouSouObject.SOUND_FLAG] == LSouSouObject.OFF){
				radioSound.value = 1;
			}else{
				radioSound.value = 0;
			}
			fun = function():void{
				if(radioSound.value == 0){
					LGlobal.script.scriptArray.varList[LSouSouObject.SOUND_FLAG] = LSouSouObject.ON;
					LSouSouObject.sound.analysis(SCRIPT_SOUND_ON);
				}else{
					LGlobal.script.scriptArray.varList[LSouSouObject.SOUND_FLAG] = LSouSouObject.OFF;
					LSouSouObject.sound.analysis(SCRIPT_SOUND_OFF);
				}
			}
			radioSound.addEventListener(LEvent.RADIO_VALUE_CHANGE,fun);
			this.addChild(radioSound);
			
			
			btn = new LButton(this.getBoxBitmapData(200,40));
			btn.labelColor = COLOR_WHITE;
			btn.label = RETURN_STXT;
			btn.x = (LGlobal.stage.stageWidth - btn.width)/2;
			btn.y = 400;
			btn.addEventListener(MouseEvent.MOUSE_UP,function (event:MouseEvent):void{
				removeFromParent();
			});
			this.addChild(btn);
		}
	}
}