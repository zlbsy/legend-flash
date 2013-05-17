package com.lufylegend.legend.scripts.analysis
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import com.lufylegend.legend.components.LComboBox;
	import com.lufylegend.legend.components.LLabel;
	import com.lufylegend.legend.components.LRadio;
	import com.lufylegend.legend.display.LBitmap;
	import com.lufylegend.legend.display.LButton;
	import com.lufylegend.legend.display.LSprite;
	import com.lufylegend.legend.events.LEvent;
	import com.lufylegend.legend.objects.LAnimation;
	import com.lufylegend.legend.objects.LAnimationMovie;
	import com.lufylegend.legend.scripts.LScript;
	import com.lufylegend.legend.utils.LGlobal;
	import com.lufylegend.legend.utils.LImage;
	import com.lufylegend.legend.utils.math.LCoordinate;

	public class ScriptAnimation
	{
		
		public function ScriptAnimation()
		{
		}
		/**
		 * 脚本解析
		 * 按钮
		 * 
		 * @param 脚本信息
		 */
		public static function analysis(value:String):void{
			var start:int = value.indexOf("(");
			var end:int = value.indexOf(")");
			switch(value.substr(0,start)){
				case "Animation.add":
					addAnimation(value,start,end);
					break;
				case "Animation.remove":
					removeAnimation(value,start,end);
					break;
				case "Animation.action":
					action(value,start,end);
					break;
				default:
					
			}
			
		}
		/**
		 * 脚本解析
		 * Animation.action(name,action);
		 * 
		 * @param 脚本信息
		 */
		private static function action(value:String,start:int,end:int):void{
			var lArr:Array = value.substring(start+1,end).split(",");
			var nameStr:String = lArr[0];
			var actionIndex:int = lArr[1];
			var script:LScript = LGlobal.script;
			var animationMovie:LAnimationMovie = script.scriptArray.animationList[nameStr];
			if(animationMovie == null){
				script.scriptArray.animationList[nameStr] = null;
				script.analysis();
				return;
			}
			animationMovie.action = actionIndex;
			script.analysis();
		}
		/**
		 * 脚本解析
		 * 添加层
		 * Animation.remove(name);
		 * @param 脚本信息
		 */
		private static function removeAnimation(value:String,start:int,end:int):void{
			var lArr:Array = value.substring(start+1,end).split(",");
			var nameStr:String = lArr[0];
			
			var script:LScript = LGlobal.script;
			var animationMovie:LAnimationMovie = script.scriptArray.animationList[nameStr];
			if(animationMovie == null){
				script.scriptArray.animationList[nameStr] = null;
				script.analysis();
				return;
			}
			animationMovie.removeFromParent();
			script.scriptArray.animationList[nameStr] = null;
			script.analysis();
		}
		/**
		 * 脚本解析
		 * 添加Animation
		 *Animation.add(-,name,img,row,col,speed,x,y);
		 */
		private static function addAnimation(value:String,start:int,end:int):void{
			var script:LScript = LGlobal.script;
			var layer:LSprite;
			var i:uint;
			
			var params:Array = value.substring(start+1,end).split(",");

			var layerStr:String = params[0];
			var nameStr:String = params[1];
			var dataStr:String = params[2];
			var row:int = params[3];
			var col:int = params[4];
			var speed:int = params[5];
			var x:int = params[6];
			var y:int = params[7];
			var data:BitmapData;
			if(params.length > 8){
				data = LGlobal.getBitmapData(script.scriptArray.swfList[params[8]],dataStr);
			}else{
				data = script.scriptArray.bitmapdataList[dataStr];
			}
			var imgArray:Array = LImage.divideByCopyPixels(data,row,col);
			var animation:LAnimation = new LAnimation(imgArray);
			var animationMovie:LAnimationMovie = new LAnimationMovie(animation,speed);
			animationMovie.x = x;
			animationMovie.y = y;
			
			layer = script.scriptArray.layerList[layerStr];
			script.scriptArray.animationList[nameStr] = animationMovie;
			layer.addChild(animationMovie);
			script.analysis();
		}
	}
}