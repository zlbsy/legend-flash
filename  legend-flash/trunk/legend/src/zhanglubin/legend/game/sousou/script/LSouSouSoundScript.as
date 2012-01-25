package zhanglubin.legend.game.sousou.script
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	import zhanglubin.legend.game.sousou.character.LSouSouCharacterS;
	import zhanglubin.legend.game.sousou.object.LSouSouObject;
	import zhanglubin.legend.scripts.LScript;
	import zhanglubin.legend.scripts.analysis.ScriptFunction;
	import zhanglubin.legend.scripts.analysis.ScriptIF;
	import zhanglubin.legend.scripts.analysis.ScriptVarlable;
	import zhanglubin.legend.utils.LGlobal;
	import zhanglubin.legend.utils.LString;
	import zhanglubin.legend.utils.math.LCoordinate;

	public class LSouSouSoundScript
	{
		private var _sound:Sound;
		private var _channel:SoundChannel;
		private var _effect:Sound;
		private var _effectChannel:SoundChannel;
		private var _soundStop:Boolean = false;
		private var _effectStop:Boolean = false;
		private var _saveMusic:Array=[];
		public function LSouSouSoundScript()
		{
			//_soundStop = true;
			//_effectStop = true;
		}

		public function get effectStop():Boolean
		{
			return _effectStop;
		}

		public function set effectStop(value:Boolean):void
		{
			_effectStop = value;
		}

		public function get soundStop():Boolean
		{
			return _soundStop;
		}

		public function set soundStop(value:Boolean):void
		{
			_soundStop = value;
		}

		public function analysis(lineValue:String):void{
			var start:int = lineValue.indexOf("(");
			var end:int = lineValue.indexOf(")");
			var transform:SoundTransform;
			var params:Array = lineValue.substring(start + 1,end).split(",");
			switch(lineValue.substr(0,start)){
				case "SouSouSound.musicMode":
					if(int(params[0])==0){
						this._soundStop = true;
						this._effectStop = true;
						if(_channel){
							//_channel.soundTransform.volume = 0;
							
							transform = new SoundTransform( );
							transform.volume = 0;
							_channel.soundTransform = transform;
						}
					}else{
						this._soundStop = false;
						this._effectStop = false;
						if(_channel){
							transform = new SoundTransform( );
							transform.volume = 1;
							_channel.soundTransform = transform;
						}
					}
					break;
				case "SouSouSound.playEffect":
					playEffect(params[0]);
					LGlobal.script.analysis();
					break;
				case "SouSouSound.playMusic":
					if(params.length > 1){
						playMusic(params[0],params[1]);
					}else{
						playMusic(params[0]);
					}
					LGlobal.script.analysis();
					break;
				case "SouSouSound.stopMusic":
					if(_channel){
						_channel.stop();
						_channel = null;
					}
					LGlobal.script.analysis();
					break;
				case "SouSouSound.stopEffect":
					if(_effectChannel){
						_effectChannel.stop();
						_effectChannel = null;
					}
					LGlobal.script.analysis();
					break;
				case "SouSouSound.stopAll":
					SoundMixer.stopAll();
					LGlobal.script.analysis();
					break;
				default:
					LGlobal.script.analysis();
			}
		}
		private function playMusic(path:String,start:int = 0):void{
			if(!_soundStop){
				if(_channel){
					_channel.stop();
				}
				_sound = new Sound();
				_sound.load(new URLRequest(path));
				_channel = _sound.play(start);
				_saveMusic[0] = path;
				_saveMusic[1] = start;
				_channel.addEventListener(Event.SOUND_COMPLETE,onComplete);
			}
			//LGlobal.script.analysis();
		}
		private function onComplete(event:Event):void{
			_channel.removeEventListener(Event.SOUND_COMPLETE,onComplete);
			playMusic(_saveMusic[0],_saveMusic[1]);
		}
		private function playEffect(path:String):void{
			if(!_effectStop){
				play(path);
			}
		}
		public function play(name:String):void{
			if(!_effectStop){
				if(_effectChannel){
					_effectChannel.stop();
				}
				_effect = LGlobal.getClass(LGlobal.script.scriptArray.swfList["sound"],name) as Sound;
				_effectChannel = _effect.play();
			}
		}
	}
}