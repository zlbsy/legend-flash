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
	import zhanglubin.legend.scripts.analysis.slg.sousou.ScriptSouSouSave;
	import zhanglubin.legend.utils.LDisplay;
	import zhanglubin.legend.utils.LFilter;
	import zhanglubin.legend.utils.LGlobal;
	import zhanglubin.legend.utils.math.LCoordinate;

	public class LSouSouWindwoArchive extends LSouSouWindow
	{
		
		private var systemArray:Array;
		public function LSouSouWindwoArchive()
		{
			super();
		}
		public function show(ctrl:String = ""):void{
			LDisplay.drawRect(this.graphics,[0,0,LGlobal.stage.stageWidth,LGlobal.stage.stageHeight],true,0x000000,0.7,5);
			LSouSouObject.window = this;
			var readBtn:LButton;
			var saveBtn:LButton;
			var expLbl:LLabel;
			var saveList:Array = new Array();
			systemArray = new Array();
			setBox(20,70,740,70);
			var savepath:String = LGlobal.script.scriptArray.varList["savepath"];
			saveList.push(LGlobal.script.scriptLayer["readGame"]("save1.slf",savepath));
			expLbl = new LLabel();
			expLbl.xy = new LCoordinate(30,80);
			expLbl.htmlText = "<font color='#ffffff' size='18'>"+
				"存档一："+(saveList[0] == null?"空":saveList[0][saveList[0].length - 1])
			"<b></b></font>";
			systemArray.push(expLbl);
			this.addChild(expLbl);
			setBox(20,150,740,70);
			saveList.push(LGlobal.script.scriptLayer["readGame"]("save2.slf",savepath));
			expLbl = new LLabel();
			expLbl.xy = new LCoordinate(30,160);
			expLbl.htmlText = "<font color='#ffffff' size='18'>"+
				"存档二："+(saveList[1] == null?"空":saveList[1][saveList[1].length - 1])
			"<b></b></font>";
			systemArray.push(expLbl);
			this.addChild(expLbl);
			setBox(20,230,740,70);
			saveList.push(LGlobal.script.scriptLayer["readGame"]("save3.slf",savepath));
			expLbl = new LLabel();
			expLbl.xy = new LCoordinate(30,240);
			expLbl.htmlText = "<font color='#ffffff' size='18'>"+
				"存档三："+(saveList[2] == null?"空":saveList[2][saveList[2].length - 1])
			"<b></b></font>";
			systemArray.push(expLbl);
			this.addChild(expLbl);
			setBox(20,310,740,70);
			saveList.push(LGlobal.script.scriptLayer["readGame"]("save4.slf",savepath));
			expLbl = new LLabel();
			expLbl.xy = new LCoordinate(30,320);
			expLbl.htmlText = "<font color='#ffffff' size='18'>"+
				"存档四："+(saveList[3] == null?"空":saveList[3][saveList[3].length - 1])
			"<b></b></font>";
			systemArray.push(expLbl);
			this.addChild(expLbl);
			setBox(20,390,740,70);
			saveList.push(LGlobal.script.scriptLayer["readGame"]("save5.slf",savepath));
			expLbl = new LLabel();
			expLbl.xy = new LCoordinate(30,400);
			expLbl.htmlText = "<font color='#ffffff' size='18'>"+
				"存档五："+(saveList[4] == null?"空":saveList[4][saveList[4].length - 1])
			"<b></b></font>";
			systemArray.push(expLbl);
			this.addChild(expLbl);
			
			if(ctrl == "" || ctrl == "read"){
				if(saveList[0] != null){
					readBtn = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"read"));
					readBtn.filters = [new GlowFilter()];
					readBtn.xy = new LCoordinate(650,80);
					readBtn.name = "read01";
					readBtn.addEventListener(MouseEvent.MOUSE_UP,readGame);
					this.addChild(readBtn);
				}
				if(saveList[1] != null){
					readBtn = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"read"));
					readBtn.filters = [new GlowFilter()];
					readBtn.xy = new LCoordinate(650,160);
					readBtn.name = "read02";
					readBtn.addEventListener(MouseEvent.MOUSE_UP,readGame);
					this.addChild(readBtn);
				}
				if(saveList[2] != null){
					readBtn = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"read"));
					readBtn.filters = [new GlowFilter()];
					readBtn.xy = new LCoordinate(650,240);
					readBtn.name = "read03";
					readBtn.addEventListener(MouseEvent.MOUSE_UP,readGame);
					this.addChild(readBtn);
				}
				if(saveList[3] != null){
					readBtn = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"read"));
					readBtn.filters = [new GlowFilter()];
					readBtn.xy = new LCoordinate(650,320);
					readBtn.name = "read04";
					readBtn.addEventListener(MouseEvent.MOUSE_UP,readGame);
					this.addChild(readBtn);
				}
				if(saveList[4] != null){
					readBtn = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"read"));
					readBtn.filters = [new GlowFilter()];
					readBtn.xy = new LCoordinate(650,400);
					readBtn.name = "read05";
					readBtn.addEventListener(MouseEvent.MOUSE_UP,readGame);
					this.addChild(readBtn);
				}
			}
			readBtn = null;
			if(ctrl == "" || ctrl == "save"){
				saveBtn = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"save"));
				saveBtn.filters = [new GlowFilter()];
				saveBtn.xy = new LCoordinate(700,80);
				saveBtn.name = "save01";
				saveBtn.addEventListener(MouseEvent.MOUSE_UP,saveGame);
				this.addChild(saveBtn);
				
				saveBtn = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"save"));
				saveBtn.filters = [new GlowFilter()];
				saveBtn.xy = new LCoordinate(700,160);
				saveBtn.name = "save02";
				saveBtn.addEventListener(MouseEvent.MOUSE_UP,saveGame);
				this.addChild(saveBtn);
				
				saveBtn = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"save"));
				saveBtn.filters = [new GlowFilter()];
				saveBtn.xy = new LCoordinate(700,240);
				saveBtn.name = "save03";
				saveBtn.addEventListener(MouseEvent.MOUSE_UP,saveGame);
				this.addChild(saveBtn);
				
				saveBtn = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"save"));
				saveBtn.filters = [new GlowFilter()];
				saveBtn.xy = new LCoordinate(700,320);
				saveBtn.name = "save04";
				saveBtn.addEventListener(MouseEvent.MOUSE_UP,saveGame);
				this.addChild(saveBtn);
				
				saveBtn = new LButton(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"save"));
				saveBtn.filters = [new GlowFilter()];
				saveBtn.xy = new LCoordinate(700,400);
				saveBtn.name = "save05";
				saveBtn.addEventListener(MouseEvent.MOUSE_UP,saveGame);
				this.addChild(saveBtn);
			}
			
			setBox(0,0,LGlobal.stage.stageWidth,LGlobal.stage.stageHeight);
			if(ctrl == "save"){
				addCloseButton(true);
			}else{
				addCloseButton();
			}
		}
		private function readGame(event:MouseEvent):void{
			trace("readGame event"+event.target.name);
			if(event.target.name == "read01"){
				ScriptSouSouSave.readGameAsFile("save1.slf");
			}else if(event.target.name == "read02"){
				ScriptSouSouSave.readGameAsFile("save2.slf");
			}else if(event.target.name == "read03"){
				ScriptSouSouSave.readGameAsFile("save3.slf");
			}else if(event.target.name == "read04"){
				ScriptSouSouSave.readGameAsFile("save4.slf");
			}else if(event.target.name == "read05"){
				ScriptSouSouSave.readGameAsFile("save5.slf");
			}
		}
		private function saveGame(event:MouseEvent):void{
			trace("saveGame event = "+event.target.name);
			var strName:String;
			if(event.target.name == "save01"){
				strName = ScriptSouSouSave.saveGameAsFile("save1");
				systemArray[0].htmlText = "<font color='#ffffff' size='18'>"+
					"存档一："+strName + "<b></b></font>";
			}else if(event.target.name == "save02"){
				strName = ScriptSouSouSave.saveGameAsFile("save2");
				systemArray[1].htmlText = "<font color='#ffffff' size='18'>"+
					"存档二："+strName + "<b></b></font>";
			}else if(event.target.name == "save03"){
				strName = ScriptSouSouSave.saveGameAsFile("save3");
				systemArray[2].htmlText = "<font color='#ffffff' size='18'>"+
					"存档三："+strName + "<b></b></font>";
			}else if(event.target.name == "save04"){
				strName = ScriptSouSouSave.saveGameAsFile("save4");
				systemArray[3].htmlText = "<font color='#ffffff' size='18'>"+
					"存档四："+strName + "<b></b></font>";
			}else if(event.target.name == "save05"){
				strName = ScriptSouSouSave.saveGameAsFile("save5");
				systemArray[4].htmlText = "<font color='#ffffff' size='18'>"+
					"存档五："+strName + "<b></b></font>";
			}
		}
	}
}