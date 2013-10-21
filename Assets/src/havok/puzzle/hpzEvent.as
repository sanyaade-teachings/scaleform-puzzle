package havok.puzzle 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author ...
	 */
	public class hpzEvent extends Event
	{
		public static const MOVED : String = "PieceMoved";
		
		public var Piece:hpzPuzzlePiece;
		public function hpzEvent(event:String, piece:hpzPuzzlePiece)
		{
			super(event);
			Piece = piece;
		}
	}

}