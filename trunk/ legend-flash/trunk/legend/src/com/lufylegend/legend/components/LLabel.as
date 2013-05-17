package com.lufylegend.legend.components
{
	
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	
	import com.lufylegend.legend.text.LTextField;

	public class LLabel extends LTextField
	{
		public function LLabel(backgroundColor:int=-1)
		{
			this.selectable = false;
			if(backgroundColor >= 0){
				this.background = true;
				this.backgroundColor = backgroundColor;
			}
			this.autoSize = TextFieldAutoSize.LEFT;
			this.antiAliasType = AntiAliasType.ADVANCED;
		}
	}
}