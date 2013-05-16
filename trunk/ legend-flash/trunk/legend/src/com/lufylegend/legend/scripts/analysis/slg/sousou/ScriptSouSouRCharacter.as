package zhanglubin.legend.scripts.analysis.slg.sousou
{
	import zhanglubin.legend.game.sousou.character.LSouSouCharacterR;
	import zhanglubin.legend.game.sousou.object.LSouSouObject;
	import zhanglubin.legend.utils.LGlobal;

	public class ScriptSouSouRCharacter
	{
		public function ScriptSouSouRCharacter()
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
				case "SouSouRCharacter.remove":
					LSouSouObject.rMap.removeCharacter(int(value.substring(start + 1,end)));
					break;
				case "SouSouRCharacter.add":
					LSouSouObject.rMap.addCharacter(value.substring(start + 1,end).split(","));
					break;
				case "SouSouRCharacter.changeAction":
					LSouSouObject.rMap.changeAction(value.substring(start + 1,end).split(","));
					break;
				case "SouSouRCharacter.changeDirection":
					changeDirection(value.substring(start + 1,end).split(","));
					break;
				case "SouSouRCharacter.moveTo":
					LSouSouObject.rMap.moveTo(value.substring(start + 1,end).split(","));
					break;
			}
		}
		private static function changeDirection(params:Array):void{
			var charar:LSouSouCharacterR = getCharacterR(int(params[0]));
			if(charar == null){LGlobal.script.analysis();return;}
			
			var charastarget:LSouSouCharacterR = getCharacterR(int(params[1]));
			if(charar.y > charastarget.y){
				if(charar.x > charastarget.x){
					charar.action =	1;
				}else{
					charar.action =	2;
				}
			}else{
				if(charar.x > charastarget.x){
					charar.action =	0;
				}else{
					charar.action =	3;
				}
			}
			LGlobal.script.analysis();
		}
		private static function getCharacterR(index:int):LSouSouCharacterR{
			var _characterR:LSouSouCharacterR;
			for each(_characterR in LSouSouObject.rMap.characterList){
				if(_characterR.index == index){
					return _characterR;
				}
			}
			return null;
		}
	}
}