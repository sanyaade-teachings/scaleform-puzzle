package havok.puzzle 
{
	import flash.utils.Dictionary;
	import flash.external.ExternalInterface;
	import scaleform.gfx.Extensions;
	/**
	 * ...
	 * @author minsu.kim
	 */
	public class hpzPuzzleType 
	{
		public static const TYPE_COUNT:int = 4;
		
		public static const VISION:int = 1 << 0;
		public static const ANIMSTUDIO:int = 1 << 1;
		public static const PHYSICS:int = 1 << 2;
		public static const AI:int = 1 << 3;
		
		private static var imageInitialized:Boolean = false;
		private static var imagePair:Dictionary = new Dictionary();
				
		public static function GetImageByType(type:int):String
		{	
			if (imageInitialized == false)
			{			
				var extension:String = (Extensions.isScaleform == true)?"dds":"png";
				trace("extension : " + extension);

				imagePair[VISION] = "vision." + extension;
				imagePair[ANIMSTUDIO] = "animation." + extension;
				imagePair[PHYSICS] = "physics." + extension;
				imagePair[AI] = "ai." + extension;
				
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