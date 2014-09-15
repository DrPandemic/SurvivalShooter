package  {
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import flash.events.Event;
	
	public class LivingWorldObject extends WorldObject{
		public static const NO_HP:Number = 0;
		private static const HP_BAR_SHOW_TIME_MILLISECS:Number = 3000;

		private var _maxHealth:Number;
		private var _currentHealth:Number;
		protected var invincible:Boolean;
		
		private var _hpBar:HealthBar;
		private var friendlyBar:Boolean;
		private var _hpBarShownTimer:Timer;
		
		public var hpBarContainer:DisplayObjectContainer;
		
		private var _healAnimation:HealAnimation;
		
		public function LivingWorldObject(isFriendly:Boolean, isSolid:Boolean, maxHp:Number) {
			super(isSolid);
			
			_hpBar = null;
			friendlyBar = isFriendly;
			hpBarContainer = Map._hpBarContainer;
			
			invincible = false;
			
			_maxHealth = maxHp;
			_currentHealth = maxHp;
		}
		
		private function initHpBar():void
		{
			if (_maxHealth != NO_HP)
			{
				_hpBar = new HealthBar(friendlyBar);
				
				_hpBar.y = -(this is Unit ? (this as Unit).getBodyWidth() : height)/2;
				_hpBar.setProgress(_currentHealth/ _maxHealth);
				
				_hpBarShownTimer = new Timer(HP_BAR_SHOW_TIME_MILLISECS);
				_hpBarShownTimer.addEventListener(TimerEvent.TIMER, hideHpBar,false,0,true);
			}
		}
		
		private function positionHpBar():void
		{
			if (_hpBar && hpBarContainer)
			{
				var boundsInHpBarContainer:Rectangle = getBounds(hpBarContainer);
					_hpBar.y = this is Unit ? hpBarContainer.y + this.y - (this as Unit).getBodyWidth() / 2 :
						boundsInHpBarContainer.top;
					_hpBar.x = this is Unit ? hpBarContainer.x + this.x : 
						boundsInHpBarContainer.left + boundsInHpBarContainer.width / 2;
			}
		}
		
		protected function onMoved():void
		{
			positionHpBar();
		}

		public function hurt(damage:Number):void
		{
			if (!invincible)
				changeHp(-damage);
		}
		
		public function heal(amount:Number):void
		{
			changeHp(amount);
			
			healAnimEnd(null);
			_healAnimation = new HealAnimation();
			addChild(_healAnimation);
			_healAnimation.addEventListener(Event.COMPLETE, healAnimEnd, false,0,true);
		}
		
		private function healAnimEnd(e:Event):void
		{
			if (_healAnimation != null)
			{
				_healAnimation.removeEventListener(Event.COMPLETE, healAnimEnd);
				removeChild(_healAnimation);
				_healAnimation = null;
			}
		}
		
		private function changeHp(amount:Number):void
		{
			var oldHP:Number = _currentHealth;
			_currentHealth += amount;
			_currentHealth = MathHelper.clamp(_currentHealth, 0, _maxHealth);
			
			// Show the health bar if our health went down
			if (_maxHealth != NO_HP && _currentHealth < oldHP)
			{
				if (_hpBar == null) initHpBar();
				_hpBar.setProgress(_currentHealth/ _maxHealth);
				showHpBar();
				if (_hpBarShownTimer.running)
				{
					_hpBarShownTimer.reset();
				}
				_hpBarShownTimer.start();
				
				onHpChanged();
			}
			
			if (isDead())
			{
				died();
			}
		}
		
		protected function died():void
		{
			cleanMe();
		}
		
		protected function onHpChanged():void { }
		
		public function getHp():Number
		{
			return _currentHealth;
		}
		
		private function showHpBar():void
		{
			if (hpBarContainer != this)
			{
				positionHpBar();
			}
			hpBarContainer.addChild(_hpBar);
		}
		
		protected function cleanMe():void
		{
			hideHpBar(null);
			killMe();
		}
		
		public function hideHpBar(e:TimerEvent):void
		{
			_hpBarShownTimer.stop();
			if (hpBarContainer.contains(_hpBar)) hpBarContainer.removeChild(_hpBar);
		}
		
		public function isDead():Boolean
		{
			return _currentHealth <= 0 && !invincible;
		}
		public override function isTargetable():Boolean
		{
			return !isDead();
		}
	}
	
}
