package havok.puzzle 
{
	import flash.display.MovieClip;
	import flash.text.TextField;

	/**
	 * ...
	 * @author minsu.kim
	 */
	public class hpzScoreField extends MovieClip
	{		
		public function set Score(value:int)
		{
			m_textField.text = value.toString();
		}
	}

}