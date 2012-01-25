package zhanglubin.legend.game.sousou.menu
{
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.utils.math.LCoordinate;

	public class LSouSouSMapMenu
	{
		public function LSouSouSMapMenu()
		{
		}
		public function addSMenu(charaCoordinate:LCoordinate,value:String = "select"):LSprite{
			var _menu:LSprite;
			if(value == "select"){
				_menu = new LSouSouSMapMenuSelect(charaCoordinate);
			}else if(value == "ctrl"){
				_menu = new LSouSouSMapMenuCtrl(charaCoordinate);
			}else if(value == "strategy"){
				_menu = new LSouSouSMapMenuStrategy(charaCoordinate);
			}else if(value == "props"){
				_menu = new LSouSouSMapMenuProps(charaCoordinate);
			}
			_menu.name = value;
			return _menu;
		}
		public function onMove(_menu:LSprite,mx:int,my:int):void{
			if(_menu.name == "select"){
				(_menu as LSouSouSMapMenuSelect).onMove(mx,my);
			}else if(_menu.name == "ctrl"){
				(_menu as LSouSouSMapMenuCtrl).onMove(mx,my);
			}else if(_menu.name == "strategy"){
				(_menu as LSouSouSMapMenuStrategy).onMove(mx,my);
			}else if(_menu.name == "props"){
				(_menu as LSouSouSMapMenuProps).onMove(mx,my);
			}
		}
		public function onClick(_menu:LSprite,mx:int,my:int):void{
			if(_menu.name == "select"){
				(_menu as LSouSouSMapMenuSelect).onClick(mx,my);
			}else if(_menu.name == "ctrl"){
				(_menu as LSouSouSMapMenuCtrl).onClick(mx,my);
			}else if(_menu.name == "strategy"){
				(_menu as LSouSouSMapMenuStrategy).onClick(mx,my);
			}else if(_menu.name == "props"){
				(_menu as LSouSouSMapMenuProps).onClick(mx,my);
			}
		}
	}
}