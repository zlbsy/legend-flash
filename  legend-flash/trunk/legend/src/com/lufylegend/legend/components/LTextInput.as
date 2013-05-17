package com.lufylegend.legend.components
{
	import flash.text.TextFieldType;
	
	import com.lufylegend.legend.text.LTextField;

	public class LTextInput extends LTextField
	{
		/**
		 * legend输入框
		 * @param w 宽
		 * @param h 高
		 * @param backgroundColor 背景色
		 * @param border 边框
		 * @author lufy(lufy.legend＠gmail.com)
		 */
		public function LTextInput(w:uint = 100,h:uint = 20,backgroundColor:int=0xcccccc,borderColor:int = 0x000000)
		{
			this.type = TextFieldType.INPUT;
			if(backgroundColor >= 0){
				this.background = true;
				this.backgroundColor = backgroundColor;
			}
			if(borderColor >= 0){
				this.border = true;
				this.borderColor = borderColor;
			}
			this.width = w;
			this.height = h;
		}
	}
}