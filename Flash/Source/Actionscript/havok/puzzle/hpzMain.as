package havok.puzzle 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.xml.XMLDocument;
	import flash.external.ExternalInterface;
	
	/**
	 * PuzzleMain
	 * @author minsu.kim
	 */
	
	public class hpzMain extends MovieClip
	{		
		// static instance
		private static var _instance:hpzMain = null;
		
		public static function get Instance():hpzMain
		{
			return _instance;
		}
		
		//------------------
		// stores counts of each types
		private var m_countsPerTypes:Dictionary  = new Dictionary();
		
		private var m_puzzlePieces:Array  = new Array(hpzGlobal.COL_COUNT);
		public var m_state:int  = hpzMainState.IDLE;
		
		public var m_gatheredPieces:Array  = null;
		private var m_needToCreatForCol:Array = null;
		
		private var m_stateTimer:Timer = null;
		private var m_alignedFlag:int = 0;
		
		private var m_score:int = 0;
		
		public function get State():int
		{
			return m_state;
		}
		
		public function set State(value:int):void
		{		
			m_state = value;
					
			m_stateTimer = new Timer(1,1);
			m_stateTimer.addEventListener(TimerEvent.TIMER, stateChanged);
			m_stateTimer.start();
			trace("State = " + m_state);
		}
		
		public function setState(value:int, delay:Number):void
		{
			m_state = value;
					
			m_stateTimer = new Timer(delay,1);
			m_stateTimer.addEventListener(TimerEvent.TIMER, stateChanged);
			m_stateTimer.start();
			trace("State = " + m_state);
		}
		
		//------------------
		public function hpzMain() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
			
			_instance = this;
		}	
		
		private function addedToStage(event:Event):void
		{
            removeEventListener(Event.ADDED_TO_STAGE, addedToStage, false);
			addEventListener(Event.REMOVED_FROM_STAGE, removeFromStage, false, 0, false);
			
			for (var i:int = 0; i < m_countsPerTypes.length; ++i)
			{
				m_countsPerTypes[1 << i] = 0;
			}
			
			scoreField.Score = 0;
						
			for (i = 0; i < hpzPuzzleType.TYPE_COUNT; ++i)
			{
				m_alignedFlag += 1 << i;
			}	
			InitailzePuzzlePieces();
        }
		
		private function removeFromStage(event:Event):void
		{
			
			removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStage, false);
        }
		
		private function GetRandomType(needCheckCountsPerTypes:Boolean = false ):int
		{
			if (needCheckCountsPerTypes == false)
			{
				return 1 << ((Math.random() * 100) % hpzPuzzleType.TYPE_COUNT);
			}
			else
			{
				for (var i:int = 0; i < hpzPuzzleType.TYPE_COUNT; ++i)
				{
					if (m_countsPerTypes[1 << i] == 0)
						return 1 << i;
				}
				
				return 1 << ((Math.random() * 100) % hpzPuzzleType.TYPE_COUNT);
			}
		}
		
		private function createPuzzlePiece(col:int, row:int, fisrtCreation:Boolean = true):void 
		{
			var puzzlePiece:hpzPuzzlePieceClip = new hpzPuzzlePieceClip();
			puzzlePiece.col = col;
			puzzlePiece.row = row;
			
			if(fisrtCreation == true)
				setPiecePosition(puzzlePiece);
			
			puzzlePiece.Type = GetRandomType(!fisrtCreation);
						
			puzzlePiece.addEventListener(hpzEvent.MOVED, onPuzzlePieceMoved, false);
			
			m_puzzlePieces[col][row] = puzzlePiece;
			
			puzzleBG.addChild(puzzlePiece);
			
			// during the first creation, we add the count of type after create piece;
			if (fisrtCreation == false)
				m_countsPerTypes[puzzlePiece.Type]++;
		}
		
		private function InitailzePuzzlePieces()
		{
			var recreateCount:int = 0;
			for ( var col:int = 0; col < hpzGlobal.COL_COUNT; ++col)
			{
				m_puzzlePieces[col] = new Array(hpzGlobal.ROW_COUNT);
				for (var row:int = 0; row < hpzGlobal.ROW_COUNT; ++row)
				{
					createPuzzlePiece(col, row);
					while (isAligned( col, row,false) == true)
					{
						m_puzzlePieces[col][row].Type = GetRandomType();
						++recreateCount;
					}
					
					m_countsPerTypes[m_puzzlePieces[col][row].Type]++;
				}
			}
			trace("recreateCount = " + recreateCount);
		}
		
		private function isAligned(curCol:int, curRow:int, gatherPieces:Boolean = false):Boolean
		{
			var isAligned:Boolean = false;
				
			if (curCol >= hpzPuzzleType.TYPE_COUNT - 1)
			{
				var colSum:int = 0;
				for (var i:int = 0; i < 4; ++i)
				{
					colSum += getType(curCol - i, curRow);
				}
				if (m_alignedFlag == colSum)
				{
					isAligned = true;
					if (gatherPieces == true)
					{
						for ( i = 0; i < 4; ++i)
						{
							var piece = m_puzzlePieces[curCol - i][curRow];
							if(m_gatheredPieces.indexOf(piece) == -1 ) { m_gatheredPieces.push(piece); }
						}
					}
				}
			}
			
			if (curRow >= hpzPuzzleType.TYPE_COUNT - 1)
			{
				var rowSum:int = 0;
				for (i = 0; i < 4; ++i)
				{
					rowSum += getType(curCol, curRow - i);
				}
				if (m_alignedFlag == rowSum)
				{	
					isAligned = true;
					if (gatherPieces == true)
					{
						for ( i = 0; i < 4; ++i)
						{
							piece = m_puzzlePieces[curCol][curRow - i];
							if (m_gatheredPieces.indexOf(piece) == -1 ) { m_gatheredPieces.push(piece); }
						}
					}
				}
			}
			return isAligned;
		}
		
		private function getType(curCol:int, curRow:int):int
		{
			if (m_puzzlePieces[curCol] == null || m_puzzlePieces[curCol] == undefined)
				return 0;
				
			if (m_puzzlePieces[curCol][curRow] == null || m_puzzlePieces[curCol][curRow] == undefined)
				return 0;

			return m_puzzlePieces[curCol][curRow].Type;
		}

		private function onPuzzlePieceMoved(e:Event)
		{
			var event:hpzEvent = e as hpzEvent;
						
			var srcCol:int = event.Piece.col;
			var srcRow:int = event.Piece.row;
			
			var destCol:int = event.Piece.x/hpzGlobal.PUZZLE_SIZE_X;
			var destRow:int = event.Piece.y/hpzGlobal.PUZZLE_SIZE_Y;
			
			var srcPiece:hpzPuzzlePiece = m_puzzlePieces[srcCol][srcRow];
			var destPiece:hpzPuzzlePiece = m_puzzlePieces[destCol][destRow];
			
			swapPiece(srcPiece, destPiece);
			setPiecePosition(srcPiece);
			setPiecePosition(destPiece);
			
			trace("onPuzzlePieceMoved : piece = " + event.Piece + " Dest : " + "destCol = " + destCol + "destRow = " + destRow);
			
			State = hpzMainState.CHECK;
		}
		
		private function swapPiece(srcPiece:hpzPuzzlePiece,destPiece:hpzPuzzlePiece):void
		{
			var srcCol:int = srcPiece.col;
			var srcRow:int = srcPiece.row;
			
			var destCol:int = destPiece.col;
			var destRow:int = destPiece.row;;
			
			m_puzzlePieces[srcCol][srcRow] = destPiece;
			destPiece.col = srcCol; destPiece.row = srcRow;
			m_puzzlePieces[destCol][destRow] = srcPiece;
			srcPiece.col = destCol; srcPiece.row = destRow;
		}
		
		private function setPiecePosition(puzzlePiece:hpzPuzzlePiece,duration:int = 0):void 
		{
			puzzlePiece.setPosition(puzzlePiece.col * hpzGlobal.PUZZLE_SIZE_X + hpzGlobal.PUZZLE_SIZE_X/2,puzzlePiece.row * hpzGlobal.PUZZLE_SIZE_Y + hpzGlobal.PUZZLE_SIZE_Y / 2,duration);
		}
		
		private function stateChanged(e:Event)
		{
			trace("stateChanged = " + State + "m_stateTimer = " + m_stateTimer);
			m_stateTimer.removeEventListener(TimerEvent.TIMER, stateChanged);
			m_stateTimer.stop();
			m_stateTimer = null;
			
			if (State == hpzMainState.CHECK)
			{
				checkAligns();
			}
			else if (State == hpzMainState.GATHER_EFFECT)
			{
				for each (var piece:hpzPuzzlePiece in m_gatheredPieces)
				{
					piece.gotoAndPlay("gathered");
					var rect:Rectangle = piece.getRect(root);
					ExternalInterface.call("CreateEffect","AnarchyEffect", rect.left + hpzGlobal.PUZZLE_SIZE_X*0.5,rect.top + hpzGlobal.PUZZLE_SIZE_Y*0.5);
				}
				
				setState(hpzMainState.REFRESH,500);
			}
			else if (State == hpzMainState.REFRESH)
			{
				m_needToCreatForCol = new Array(hpzGlobal.COL_COUNT);
				
				for each (piece in m_gatheredPieces)
				{
					removePiece(piece);
					if(m_needToCreatForCol[piece.col] == null)
						m_needToCreatForCol[piece.col] = 0;
						
					++m_needToCreatForCol[piece.col];
				}
				m_gatheredPieces = null;
				
				State = hpzMainState.ARRANGE;
			}
			else if (State == hpzMainState.ARRANGE)
			{
				ArrangePuzzlePieces();
			}
			else if (State == hpzMainState.ARRANGE_FINISH)
			{				
				State = hpzMainState.CHECK;
			}
		}
		
		private function checkAligns()
		{
			m_gatheredPieces = null;
			m_gatheredPieces = new Array();
			
			for ( var col:int = 0; col < hpzGlobal.COL_COUNT; ++col)
			{
				for (var row:int = 0; row < hpzGlobal.ROW_COUNT; ++row)
				{
					isAligned( col, row, true);
				}
			}
			
			trace("m_gatheredPieces count = " + m_gatheredPieces.length);
			
			if (m_gatheredPieces.length == 0)
			{
				State = hpzMainState.IDLE;
			}
			else
			{
				m_score += m_gatheredPieces.length * m_gatheredPieces.length;
				scoreField.Score = m_score;
				State = hpzMainState.GATHER_EFFECT;
			}
		}
		
		private function ArrangePuzzlePieces():void 
		{			
			for ( var col:int = 0; col < hpzGlobal.COL_COUNT; ++col)
			{
				for (var row:int = hpzGlobal.ROW_COUNT - 2; row >= 0; --row)
				{
					if (m_puzzlePieces[col][row] == null)
						continue;
						
					var destRow:int = row + 1;
					while (m_puzzlePieces[col][destRow] == null
						&& destRow < hpzGlobal.ROW_COUNT)
					{
						++destRow;
					}
					
					destRow -= 1;
					if (destRow == row)
						continue;
						
					m_puzzlePieces[col][row].row = destRow;
					m_puzzlePieces[col][destRow] = m_puzzlePieces[col][row];
					m_puzzlePieces[col][row] = null;
					
					setPiecePosition(m_puzzlePieces[col][destRow], hpzGlobal.PIECE_ARRANGE_TIME);
					m_puzzlePieces[col][destRow].gotoAndPlay("rearranged");
				}
			}
			
			for(col = 0; col <  hpzGlobal.COL_COUNT; ++col )
			{
				var count:int = m_needToCreatForCol[col];
				
				for (row = 0; row < count; ++row)
				{
					createPuzzlePiece(col, row, false);
					setPiecePosition(m_puzzlePieces[col][row]);
					m_puzzlePieces[col][row].y = -(count - row + 1 ) * hpzGlobal.PUZZLE_SIZE_Y;
					setPiecePosition(m_puzzlePieces[col][row], hpzGlobal.PIECE_ARRANGE_TIME);
					m_puzzlePieces[col][row].gotoAndPlay("rearranged");
				}
			}
			
			setState(hpzMainState.ARRANGE_FINISH,hpzGlobal.PIECE_ARRANGE_TIME + 100 );
		}
		
		private function removePiece(piece:hpzPuzzlePiece):void 
		{
			puzzleBG.removeChild(piece);
			m_puzzlePieces[piece.col][piece.row] = null;
			m_countsPerTypes[piece.Type]--;
		}
	}

}