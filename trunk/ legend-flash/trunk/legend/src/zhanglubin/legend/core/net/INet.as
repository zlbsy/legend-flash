package zhanglubin.legend.core.net
{
	import flash.events.IOErrorEvent;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	

	/**
	 * legendNet接口
	 * @author lufy(lufy.legend＠gmail.com)
	 */
	public interface INet
	{
		function ioErrorHandler(event:IOErrorEvent):void;
		function configureListeners():void;
		function setVariables(phpURL:String,variables:URLVariables,errorFun:Function,completeFun:Function):void;
		function run(method:String = URLRequestMethod.POST):void;
	}
}