package com.lufylegend.legend.core.net
{
	/**
	 * legendPHP接口
	 * @author lufy(lufy.legend＠gmail.com)
	 */
	public interface IPHP
	{
		function ioErrorHandler():void;
		function run():void;
		function setVariables():void;
		function configureListeners():void;
	}
}