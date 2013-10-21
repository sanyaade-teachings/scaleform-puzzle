package havok.puzzle 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	/**
	 * ...
	 * @author ...
	 */
	public class hpzScoreField extends MovieClip
	{		
		public function set Score(value:int)
		{
			m_textField.text = value.toString();
		}
	}

}