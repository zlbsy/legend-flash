package zhanglubin.legend.game.sousou.map.window
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.filters.GlowFilter;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
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
	import zhanglubin.legend.utils.math.LCoordinate;

	public class LSouSouWindwoSupport extends LSouSouWindow
	{
		private const RETURN_STXT:String = "返回游戏";
		private const COLOR_WHITE:String = "#ffffff";
		
		public function LSouSouWindwoSupport()
		{
			super();
		}
		public function show():void{
			LDisplay.drawRect(this.graphics,[0,0,LGlobal.stage.stageWidth,LGlobal.stage.stageHeight],true,0x000000,0.8,5);
			LSouSouObject.window = this;
			var fun:Function;
			
			LDisplay.drawRect(this.graphics,[0,0,LGlobal.stage.stageWidth,LGlobal.stage.stageHeight],true,0x000000,0.7,5);
			LSouSouObject.window = this;
			setBox(0,0,LGlobal.stage.stageWidth,LGlobal.stage.stageHeight);
			setBox(15,15,LGlobal.stage.stageWidth - 50,450);
			var explanationTxt:LLabel = new LLabel();
			explanationTxt.xy = new LCoordinate(50,50);
			explanationTxt.width = 700;
			explanationTxt.wordWrap = true;
			explanationTxt.htmlText = "<b><font color='#ffffff' size='25'>" + 
				"LegendForFlashProgramming，简称legend，\n" + 
				"是一款游戏引擎，目前您正在玩的游戏由该引擎的0.11版本制作完成。\n\n" + 
				"本引擎将永远免费为大家提供更新和下载，\n" + 
				"如果您想表示对作者的支持的话，\n请您打开电脑体验一下由该引擎制作的一款免费的网页版游戏《三国记-经典战役版》，并点击一下广告：\n" + "</font></b>";
			this.addChild(explanationTxt);
			var urlTxt:LLabel = new LLabel();
			urlTxt.xy = new LCoordinate(50,300);
			urlTxt.htmlText = "<b><font color='#ffffff' size='25'><u><a href='event:http://www.4399.com/flash/80759_4.htm'>http://www.4399.com/flash/80759_4.htm</a></u></font></b>";
			urlTxt.addEventListener(TextEvent.LINK, function (event:TextEvent):void{
				var url:String = "http://www.4399.com/flash/80759_4.htm";
				var request:URLRequest = new URLRequest(url);
				navigateToURL(request);
			});
			this.addChild(urlTxt);
			
			var btn:LButton;
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