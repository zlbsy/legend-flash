package zhanglubin.legend.scripts.analysis.slg.sousou
{
	import zhanglubin.legend.game.sousou.object.LSouSouObject;

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
				case "SouSouRCharacter.moveTo":
					LSouSouObject.rMap.moveTo(value.substring(start + 1,end).split(","));
					break;
			}
		}
	}
}