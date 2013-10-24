package havok.puzzle 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author ...
	 */
	public class hpzPuzzleType 
	{
		public static const TYPE_COUNT:int = 4;
		
		public static const VISION:int = 1 << 0;
		public static const ANIMSTUDIO:int = 1 << 1;
		public static const PHYSICS:int = 1 << 2;
		public static const AI:int = 1 << 3;
		
		private static var flagInitialized:Boolean = false;
		private static var flagPair:Dictionary = new Dictionary();
		private static var typeInitialized:Boolean = false;
		private static var typePair:Dictionary = new Dictionary();
		private static var imageInitialized:Boolean = false;
		private static var imagePair:Dictionary = new Dictionary();
				
		static function GetImageByType(type:int):String
		{
			if (imageInitialized == false)
			{
				imagePair[VISION] = "vision.png";
				imagePair[ANIMSTUDIO] = "animation.png";
				imagePair[PHYSICS] = "physics.png";
				imagePair[AI] = "ai.png";
				
				imageInitialized = true;
			}
			if (imagePair[type] != null)
			{
				return imagePair[type];
			}
			
			trace("GetImageByType : failed, value = ",type);
			
			return "";
		}
	}

}