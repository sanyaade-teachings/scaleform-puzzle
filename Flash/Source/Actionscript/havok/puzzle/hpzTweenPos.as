package havok.puzzle 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.*;
	
	/**
	 * ...
	 * @author minsu.kim
	 */
	public class hpzTweenPos 
	{
		private var timerDelta:int = 1000 / 60;
		private var oriX:int = 0;
		private var oriY:int = 0;
		private var destX:int = 0;
		private var destY:int = 0;
		
		private var startTime:int = 0;
		private var processedTime:int = 0;
		private var duration:int = 0;
		
		private var timer:Timer = null;
		
		private var targetClip:MovieClip;
		
		public function begin(targetClip:MovieClip,oriX:int, oriY:int, destX:int, destY:int, duration:int):void
		{
			this.oriX = oriX;
			this.oriY = oriY;
			this.destX = destX;
			this.destY = destY;
			this.duration = duration;
			this.targetClip = targetClip;
			
			startTime = getTimer();
			timer = new Timer(timerDelta, (duration/timerDelta) + 2);
			timer.addEventListener(TimerEvent.TIMER, onUpdate);
			timer.start();
		}
		
		private function onUpdate(e:Event):void
		{
			processedTime = getTimer() - startTime;
			if (processedTime > duration)
			{
				targetClip.x = destX;
				targetClip.y = destY;
				timer.removeEventListener(TimerEvent.TIMER, onUpdate);
				timer.stop();
				timer = null;
			}
			else
			{
				targetClip.x = oriX + ((destX - oriX ) * processedTime) / duration;
				targetClip.y = oriY + ((destY - oriY ) * processedTime) / duration;
			}
		}
	}

}