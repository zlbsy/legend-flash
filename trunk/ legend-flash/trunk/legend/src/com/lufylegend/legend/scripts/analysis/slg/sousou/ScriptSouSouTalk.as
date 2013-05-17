package com.lufylegend.legend.scripts.analysis.slg.sousou
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.StyleSheet;
	
	import com.lufylegend.legend.components.LLabel;
	import com.lufylegend.legend.display.LBitmap;
	import com.lufylegend.legend.display.LSprite;
	import com.lufylegend.legend.events.LEvent;
	import com.lufylegend.legend.game.sousou.character.LSouSouCharacterR;
	import com.lufylegend.legend.game.sousou.character.LSouSouCharacterS;
	import com.lufylegend.legend.game.sousou.object.LSouSouObject;
	import com.lufylegend.legend.game.sousou.object.LSouSouSMapMethod;
	import com.lufylegend.legend.scripts.LScript;
	import com.lufylegend.legend.scripts.analysis.text.ScriptLabel;
	import com.lufylegend.legend.scripts.analysis.text.ScriptWind;
	import com.lufylegend.legend.text.LTextField;
	import com.lufylegend.legend.utils.LDisplay;
	import com.lufylegend.legend.utils.LGlobal;
	import com.lufylegend.legend.utils.LImage;
	import com.lufylegend.legend.utils.math.LCoordinate;
	
	public class ScriptSouSouTalk
	{
		
		public function ScriptSouSouTalk()
		{
		}
		/**
		 * 脚本解析
		 * 对话操作
		 * 
		 * @param 脚本信息
		 */
		public static function analysis(value:String):void{
			var start:int = value.indexOf("(");
			var end:int = value.indexOf(")");
			switch(value.substr(0,start)){
				case "SouSouTalk.set":
					setTalk(value,start,end);
					break;
				case "SouSouTalk.select":
					setSelect(value.substring(start+1,end).split(","));
					break;
				default:
			}
			
		}
		/**
		 * 脚本解析
		 * 添加对话
		 * SouSouTalk.select(选择一,选择二);
		 * @param 脚本信息
		 */
		public static function setSelect(params:Array):void{
			var script:LScript = LGlobal.script;
			var layer:LSprite = script.scriptLayer;
			var mask:LSprite = new LSprite();
			LDisplay.drawRect(mask.graphics,[0,0,LGlobal.stage.stageWidth,LGlobal.stage.stageHeight],true,0x000000,0);
			script.scriptArray.layerList["mask"] = mask;
			layer.addChild(mask);
			
			var selectLayer:LSprite = new LSprite();
			layer.addChild(selectLayer);
			var i:int = 0;
			var bar_h:int = 15;
			var btn_h:int = 34;
			var btn_w:int = 115;
			var bar_w:int = 5;
			
			var lblArray:Array = new Array();
			var lblMenu:LLabel;
			for(i=0;i<params.length;i++){
				lblMenu = new LLabel();
				lblMenu.htmlText = "<font color='#ffffff' size='15'><b>" +params[i]+"</b></font>";
				lblMenu.xy = new LCoordinate(10,10 + btn_h*i + (btn_h - lblMenu.height)/2);
				if(btn_w < lblMenu.width)btn_w = lblMenu.width;
				lblArray.push(lblMenu);
			}
			
			var menu_w:int=btn_w + 20;
			var menu_h:int = 20 + btn_h*params.length;
			
			var _menuBitmap:LBitmap = new LBitmap(new BitmapData(menu_w,menu_h,false,0x333333));
			
			_menuBitmap.bitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar02.png"),
				new Rectangle(0,0,menu_w,bar_w),new Point(0,0));
			_menuBitmap.bitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar04.png"),
				new Rectangle(0,0,bar_w,menu_h),new Point(0,0));
			_menuBitmap.bitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar05.png"),
				new Rectangle(0,0,bar_w,menu_h),new Point(menu_w - bar_w,0));
			_menuBitmap.bitmapData.copyPixels(LImage.vertical(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar02.png")),
				new Rectangle(0,0,menu_w,bar_w),new Point(0,menu_h - bar_w));
			
			_menuBitmap.bitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar01.png"),
				new Rectangle(0,0,bar_h,bar_h),new Point(0,0));
			_menuBitmap.bitmapData.copyPixels(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar03.png"),
				new Rectangle(0,0,bar_h,bar_h),new Point(menu_w - bar_h,0));
			_menuBitmap.bitmapData.copyPixels(LImage.vertical(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar01.png")),
				new Rectangle(0,0,bar_h,bar_h),new Point(0,menu_h - bar_h));
			_menuBitmap.bitmapData.copyPixels(LImage.vertical(LGlobal.getBitmapData(LGlobal.script.scriptArray.swfList["img"],"menu_bar03.png")),
				new Rectangle(0,0,bar_h,bar_h),new Point(menu_w - bar_h,menu_h - bar_h));
			selectLayer.addChild(_menuBitmap);
			
			var _menuSelect:LSprite = new LSprite();
			LDisplay.drawRoundRect(_menuSelect.graphics,[0,0,btn_w,btn_h,10,10],true,0x000000,0.7);
			_menuSelect.x = 10;
			_menuSelect.visible = false;
			selectLayer.addChild(_menuSelect);
			
			for(i=0;i<lblArray.length;i++){
				selectLayer.addChild(lblArray[i]);
			}
			selectLayer.xy = new LCoordinate((LGlobal.stage.stageWidth-_menuBitmap.width)/2,(LGlobal.stage.stageHeight-_menuBitmap.height)/2);
			selectLayer.addEventListener(MouseEvent.MOUSE_MOVE,function (e:MouseEvent):void{
				if(e.currentTarget.mouseY < 10){
					_menuSelect.visible = false;
					return;
				}else if(e.currentTarget.mouseY > _menuBitmap.height - 20){
					_menuSelect.visible = false;
					return;
				}else if(e.currentTarget.mouseX < 10){
					_menuSelect.visible = false;
					return;
				}else if(e.currentTarget.mouseX > _menuBitmap.width - 20){
					_menuSelect.visible = false;
					return;
				}
				_menuSelect.visible = true;
				_menuSelect.y = 10 + int((e.currentTarget.mouseY - 10)/btn_h)*btn_h;
			});
			selectLayer.addEventListener(MouseEvent.MOUSE_UP,function (e:MouseEvent):void{
				if(!_menuSelect.visible)return;
				LGlobal.script.scriptArray.varList["select"] = int((e.currentTarget.mouseY - 10)/btn_h);
				LGlobal.script.scriptArray.varList["param_select"] = int((e.currentTarget.mouseY - 10)/btn_h);
				trace('LGlobal.script.scriptArray.varList["select"]='+LGlobal.script.scriptArray.varList["select"]);
				mask.removeFromParent();
				selectLayer.removeFromParent();
				LGlobal.script.analysis();
			});
		}
		
		/**
		 * 脚本解析
		 * 添加对话
		 * SouSouTalk.set(1,0,こんにちは、張です。,1);
		 * @param 脚本信息
		 */
		public static function setTalk(value:String,start:int,end:int):void{
			var script:LScript = LGlobal.script;
			var lArr:Array = value.substring(start+1,end).split(",");
			var label:LTextField = new LTextField();
			var characterName:LLabel = new LLabel();
			var layer:LSprite = new LSprite();
			var baseLayer:LSprite = script.scriptLayer;
			var nameStr:String = "SouSouTalk";
			var speed:int = 50;
			if(lArr.length > 3){
				speed = int(lArr[3]);
			}
			if(LGlobal.script.scriptArray.varList[LSouSouObject.SPEED_FLAG] == LSouSouObject.FAST){
				speed *= 0.5;;
			}
			var mask:LSprite = new LSprite();
			LDisplay.drawRect(mask.graphics,[0,0,LGlobal.stage.stageWidth,LGlobal.stage.stageHeight],true,0x000000,0);
			script.scriptArray.layerList["mask"] = mask;
			if(LSouSouObject.talkLayer){
				if(LSouSouObject.talkLayer.parent)LSouSouObject.talkLayer.removeFromParent();
				LSouSouObject.talkLayer.die();
			}
			layer.addChild(mask);
			baseLayer.addChild(layer);
			LSouSouObject.talkLayer = layer;
			var _characterR:LSouSouCharacterR;
			var charas:LSouSouCharacterS;
			var isget:Boolean;
			
			var talkImgX:int = 200,talkImgY:int=300;
			
			if(LSouSouObject.rMap){
				for each(_characterR in LSouSouObject.rMap.characterList){
					if(_characterR.index == int(lArr[0])){
						break;
					}else{
						_characterR = null;
					}
				}
				if(_characterR){
					var direction:int = _characterR.action % 4;
					var talkSign:LBitmap; 
					if(direction >= 2){
						talkSign = new LBitmap(LGlobal.getBitmapData(script.scriptArray.swfList["img"],"talk_sign.gif"));
						talkSign.x = _characterR.x + _characterR.width - 15;
					}else{
						talkSign = new LBitmap(LImage.horizontal(LGlobal.getBitmapData(script.scriptArray.swfList["img"],"talk_sign.gif")));
						talkSign.x = _characterR.x - talkSign.width + 15;
					}
					talkSign.y = _characterR.y - 15; 
					script.scriptArray.imgList["talkSign"] = talkSign;
					layer.addChild(talkSign);
					if(_characterR.x >= LGlobal.stage.stageWidth/2){
						talkImgX = 10;
					}else{
						talkImgX = 200;
					}
					if(_characterR.y >= LGlobal.stage.stageHeight/2){
						talkImgY = 30;
					}else{
						talkImgY = 300;
					}
				}
			}else if(LSouSouObject.sMap){
				for each(charas in LSouSouObject.sMap.ourlist){
					if(charas.index == int(lArr[0])){
						isget = true;
						break;
					}
				}
				if(!isget){
					for each(charas in LSouSouObject.sMap.friendlist){
						if(charas.index == int(lArr[0])){
							isget = true;
							break;
						}
					}
				}
				if(!isget){
					for each(charas in LSouSouObject.sMap.enemylist){
						if(charas.index == int(lArr[0])){
							isget = true;
							break;
						}
					}
				}
				if(isget){
					LSouSouSMapMethod.setLocationAtChara(charas);
				}
			}
			
			var bitdata:BitmapData = LGlobal.getBitmapData(script.scriptArray.swfList["img"],"talk.png");
			var bitmap:LBitmap;
			bitmap = new LBitmap(bitdata);
			bitmap.x = talkImgX;
			bitmap.y = talkImgY;
			bitmap.height = 180;
			bitmap.name = nameStr;
			script.scriptArray.imgList[nameStr] = bitmap;
			layer.addChild(bitmap);
			/*
			var name_bitmap:LBitmap;
			name_bitmap = new LBitmap(bitdata);
			name_bitmap.x = bitmap.x + 246.5;
			name_bitmap.y = bitmap.y - 15;
			name_bitmap.width = 300;
			name_bitmap.height = 35;
			name_bitmap.name = nameStr+"-name";
			script.scriptArray.imgList[nameStr+"-name"] = name_bitmap;
			layer.addChild(name_bitmap);
			*/
			var facedata:BitmapData;
			var faceIndex:int = LSouSouObject.chara["peo"+lArr[0]]["Face"];
			if(faceIndex >= LSouSouObject.charaFaceList.length){
				facedata = new BitmapData(150,150,false,0x000000);
			}else{
				facedata = LSouSouObject.charaFaceList[faceIndex];
			}
			
			//var facedata:BitmapData = LGlobal.getBitmapData(script.scriptArray.swfList["face"],
			//	"face" + LSouSouObject.chara["peo"+lArr[0]]["Face"] +"-"+ lArr[1]);
			var face:LBitmap = new LBitmap(facedata);
			face.x = bitmap.x + 30;
			face.y = bitmap.y -112;
			face.y = bitmap.y + 33;
			script.scriptArray.imgList["face"] = face;
			layer.addChild(face);
			
			setBox(face.x,face.y,120,120,layer);
			
			characterName.htmlText = "<font color='#ff0000' size='22'><b>" + LSouSouObject.chara["peo"+lArr[0]]["Name"] + "</b></font>";
			characterName.xy = new LCoordinate(bitmap.x + 160,bitmap.y + 30);
			script.scriptArray.textList["talkname"] = characterName;
			characterName.name = "talkname";
			layer.addChild(characterName);
			
			label.selectable = false;
			label.wordWrap = true;
			label.width = 370;
			label.height = 90;
			label.xy = new LCoordinate(bitmap.x + 160,bitmap.y + 60);
			var talkText:String = lArr[2];
			while(talkText.indexOf("\\n")>=0)talkText = talkText.replace("\\n","\n");
			label.setWindText(talkText,ScriptSouSouTalk.getCss(18),speed);
			
			script.scriptArray.textList[nameStr] = label;
			label.name = nameStr;
			layer.addChild(label);
			label.addEventListener(LEvent.LTEXT_MAX,function (event:LEvent):void{
				LGlobal.script.scriptLayer.addEventListener(MouseEvent.MOUSE_UP,clickEvent);
			});
		}
		private static function clickEvent(event:MouseEvent):void{
			LGlobal.script.scriptLayer.removeEventListener(MouseEvent.MOUSE_UP,clickEvent);
			LSouSouObject.talkLayer.removeFromParent();
			LSouSouObject.talkLayer.die();
			/**
			var nameStr:String = "SouSouTalk";
			LGlobal.script.scriptArray.textList["talkname"].removeFromParent();
			LGlobal.script.scriptArray.textList[nameStr].removeFromParent();
			LGlobal.script.scriptArray.imgList[nameStr].removeFromParent();
			LGlobal.script.scriptArray.imgList[nameStr + "-name"].removeFromParent();
			LGlobal.script.scriptArray.imgList["face"].removeFromParent();
			LGlobal.script.scriptArray.layerList["mask"].removeFromParent();
			if(LGlobal.script.scriptArray.imgList["talkSign"])LGlobal.script.scriptArray.imgList["talkSign"].removeFromParent();
			
			*/
			LGlobal.script.analysis();
		}
		/**
		 * 返回一个StyleSheet的Css
		 * 
		 */
		private static function getCss(size:uint):StyleSheet{
			var css:StyleSheet = new StyleSheet( );
			css.setStyle("p", {fontFamily: "_sans",fontSize:""+size,color:"#FFFFFF",fontWeight:"bold"});
			css.setStyle(".red", {color:"#FF0000"});
			css.setStyle(".yellow", {color:"#FFFF00"});
			css.setStyle(".green", {color:"#00FF00"});
			css.setStyle(".blue", {color:"#0000FF"});
			css.setStyle(".pink", {color:"#FF00FF"});
			return css;
		}
		
		private static function setBox(_menuX:int,_menuY:int,_menuW:int,_menuH:int,layer:LSprite):void{
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

	}
}