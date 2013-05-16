package zhanglubin.legend.utils
{

	public class LString
	{
		public static function getRandWord(l:int):String{
			var randStr:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghigklmnopqrstuvwxyz0123456789_";
			var value:String = "";
			while(value.length<l){
				value += randStr.substr(int(randStr.length*Math.random()),1);
			}
			return value;
		}
		public static function trim(str:String):String
		{
			if (str == null) return '';
			
			var startIndex:int = 0;
			while (isWhitespace(str.charAt(startIndex)))
				++startIndex;
			
			var endIndex:int = str.length - 1;
			while (isWhitespace(str.charAt(endIndex)))
				--endIndex;
			
			if (endIndex >= startIndex)
				return str.slice(startIndex, endIndex + 1);
			else
				return "";
		}
		public static function isWhitespace(character:String):Boolean
		{
			switch (character)
			{
				case "	":
				case "　":
				case " ":
				case "\t":
				case "\r":
				case "\n":
				case "\f":
					return true;
					
				default:
					return false;
			}
		}
	}
}