package havok.puzzle 
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.display.Bitmap;

	/**
	 * PuzzlePiece
	 * @author minsu.kim
	 */
	public class hpzPuzzlePiece extends MovieClip 
	{
		private var _type:int = 0;
		
		private var isAddedToStage:Boolean = false;
		public var col:int = 0;
		public var row:int = 0;
		
		public var oriPosX:Number = 0;
		public var oriPosY:Number = 0;
		
		private var tweenPos:hpzTweenPos = null;
		private var nowDragging:Boolean = false;
		private var imageLoader:Loader = new Loader();
		

		public function get Type():int
		{
			return _type;
		}
		
		public function set Type(value:int):void
		{
			_type = value;
			if (isAddedToStage)
			{
				resetImage();
			}
		}
		
		public override function toString():String
		{
			return "hpzPuzzlePiece : col = " + col + " row = " + row + " " + Type;
		}
		
		public function hpzPuzzlePiece() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
		}
		
		protected function addedToStage(event:Event):void {
			isAddedToStage = true;
            removeEventListener(Event.ADDED_TO_STAGE, addedToStage, false);
			
			addEventListener(Event.REMOVED_FROM_STAGE, removeFromStage, false, 0, false);
			addEventListener(MouseEvent.MOUSE_DOWN, onCursorDown, true, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, onCursorUp);
			resetImage();
        }
		
		protected function removeFromStage(event:Event):void {
			isAddedToStage = false;
			
			removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStage, false);
			removeEventListener(MouseEvent.MOUSE_DOWN, onCursorDown, false);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onCursorUp, false);
        }
		
		protected function resetImage():void
		{
			var url:URLRequest = new URLRequest("../../Textures/PuzzlePieces/" + hpzPuzzleType.GetImageByType(Type));
			imageLoader.load(url);
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadIconComplete,false,0,true);
		}
		
		public function onCursorDown(event:Event):void
		{
			if (hpzMain.Instance.State != hpzMainState.IDLE)
				return;
				
			trace("clicked : col = " + col + " row = " + row);
			gotoAndPlay("clicked");
			
			oriPosX = x;
			oriPosY = y;
			
			parent.setChildIndex(this,hpzGlobal.COL_COUNT*hpzGlobal.ROW_COUNT);

			startDrag(false,parent.getRect(parent));
			nowDragging = true;			
		}
		
		public function onCursorUp(event:Event):void
		{			
			if (nowDragging == false)
				return;

			nowDragging = false;
			stopDrag();
			dispatchEvent(new hpzEvent(hpzEvent.MOVED, this));
			
			gotoAndPlay("idle");
		}
		
		private function loadIconComplete (event:Event) : void
		{
			var bitmap:Bitmap = event.target.content as Bitmap;
			event.target.content.x = -hpzGlobal.PUZZLE_SIZE_X / 2;
			event.target.content.y = -hpzGlobal.PUZZLE_SIZE_Y / 2;
			(this.getChildByName("puzzleImageSlot") as MovieClip).addChild(bitmap);
		}
		
		public function setPosition(xPos:int, yPos:int, duration:int)
		{
			if (duration == 0)
			{
				this.x = xPos;
				this.y =  yPos;
			}
			else
			{
				tweenPos = new hpzTweenPos();
				tweenPos.begin(this,x,y,xPos,yPos,duration);
			}
		}
	}

}