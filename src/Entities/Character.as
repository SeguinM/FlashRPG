package src.Entities
{
	import flash.display.MovieClip;
	import src.Controllers.UIControllerBase;
	import src.Events.EventWithData;
	import src.Utilities.TimerWithData;
	
	/**
	 * ...
	 * @author SeguinM
	 * PURPOSE: This is the base class for character entities.
	 */
	public class  Character extends MovieClip
	{
		// STATS
		private var $name:String;
		private var $level:int;
		private var $exp_current:int;
		private var $exp_max:int;
		private var $hp_current:int;
		private var $hp_max:int;
		private var $ap_current:int;
		private var $ap_max:int;
		private var $speed:int;
		private var $p_atk:int;
		private var $p_def:int;
		private var $r_atk:int;
		private var $r_def:int;
		private var $m_atk:int;
		private var $m_def:int;
		private var $s_atk:int;
		private var $s_def:int;
		
		// level up variables
		public var lvlUp_hp_min:int;
		public var lvlUp_hp_max:int;
		public var lvlUp_speed_min:int;
		public var lvlUp_speed_max:int;
		public var lvlUp_patk_min:int;
		public var lvlUp_patk_max:int;
		public var lvlUp_ratk_min:int;
		public var lvlUp_ratk_max:int;
		public var lvlUp_matk_min:int;
		public var lvlUp_matk_max:int;
		public var lvlUp_satk_min:int;
		public var lvlUp_satk_max:int;
		public var lvlUp_pdef_min:int;
		public var lvlUp_pdef_max:int;
		public var lvlUp_rdef_min:int;
		public var lvlUp_rdef_max:int;
		public var lvlUp_mdef_min:int;
		public var lvlUp_mdef_max:int;
		public var lvlUp_sdef_min:int;
		public var lvlUp_sdef_max:int;
		
		public var equippedWeapon:Weapon;
		
		public var uiController:UIControllerBase;     // EXTERNALLY ASSIGNED
		
		private var dialogueQueue:Array = [];              // Array of arrays of objects (dialogueUtility)
		
		private var internalID:int;                    // unique assigned ID
		
		// STAGE REFS
		public var animWrapper:MovieClip;
		
		// STATIC CONTS
		public static const EVENT_DATA_CHANGE:String = "damageTakenEvent";
		public static const EVENT_KO:String = "KOEvent";
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function Character($id:int)
		{
			super();
			init($id);
		} // end of function Character
		
		public function generateFromXML():void
		{
			
		} // end of generateFromXML
		
		public function setAnimState(anim:String):void
		{
			if (clip.animWrapper)
			{
				try
				{
					clip.animWrapper.gotoAndPlay(anim);
				}
				catch (error:Error)
				{
					trace("Issue playing animation: " + anim);
				}
			} // end of if statement
		} // end of function setAnimState
		
		public function levelUp():void
		{	// levels up character
			
			$level++;
			
			if (uiController != null)
			{
				var battleLog:MovieClip = uiController.getUIElement("battleLog");
				if (battleLog != null)
					battleLog.generateLog(characterName + " levelled up! (" + $level + ")");
			} // end of if statement
			
			var newHP:int = Math.floor(Math.random() * (lvlUp_hp_max - lvlUp_hp_min + 1)) + lvlUp_hp_min;
			trace ("NEW HP ADDITION: " + newHP);
			trace ("HP VARIATION: " + lvlUp_hp_min + " to " + lvlUp_hp_max);
			$hp_current += newHP;
			$hp_max += newHP;
			
			// attack values
			P_ATK += Math.floor(Math.random() * (lvlUp_patk_max - lvlUp_patk_min + 1)) + lvlUp_patk_min;
			R_ATK += Math.floor(Math.random() * (lvlUp_ratk_max - lvlUp_ratk_min + 1)) + lvlUp_ratk_min;
			M_ATK += Math.floor(Math.random() * (lvlUp_matk_max - lvlUp_matk_min + 1)) + lvlUp_matk_min;
			S_ATK += Math.floor(Math.random() * (lvlUp_satk_max - lvlUp_satk_min + 1)) + lvlUp_satk_min;
			
			// defense values
			P_DEF += Math.floor(Math.random() * (lvlUp_pdef_max - lvlUp_pdef_min + 1)) + lvlUp_pdef_min;
			R_DEF += Math.floor(Math.random() * (lvlUp_rdef_max - lvlUp_rdef_min + 1)) + lvlUp_rdef_min;
			M_DEF += Math.floor(Math.random() * (lvlUp_mdef_max - lvlUp_mdef_min + 1)) + lvlUp_mdef_min;
			S_DEF += Math.floor(Math.random() * (lvlUp_sdef_max - lvlUp_sdef_min + 1)) + lvlUp_sdef_min;
			
			// speed
			SPEED += Math.floor(Math.random() * (lvlUp_speed_max - lvlUp_speed_min + 1)) + lvlUp_speed_min;
			
			$exp_max = $level * 100;      // sets new exp cap. 
			
			dispatchEvent(new EventWithData(EVENT_DATA_CHANGE, { id: internalID } ));
			
		} // end of function levelUp
		
		public function dealDamage(damage:int):void
		{	// At this point, all defense/attack and modifiers should have been accounted for
			$hp_current -= damage;
			if ($hp_current <= 0)
			{
				$hp_current = 0;
				onCharacterKO();
			} // end of if statement
				
			dispatchEvent(new EventWithData(EVENT_DATA_CHANGE, { id: internalID } ));
		} // end of function dealDamage
		
		public function addExperience(value:int):void
		{
			trace (characterName + " gained " + value + " experience!");
			
			var battleLog:MovieClip = uiController.getUIElement("battleLog");
			if (battleLog != null)
				battleLog.generateLog(characterName + " gained " + value + " EXP");
			
			$exp_current += value;
			
			if ($exp_current >= $exp_max)
			{
				var overage:int = $exp_current - $exp_max;
				$exp_current = overage;
				levelUp();
			} // end of if statement
			
			dispatchEvent(new EventWithData(EVENT_DATA_CHANGE, { id: internalID } ));
		} // end of function addExperience
		
		public function getExperience():int
		{
			var xp:int = 0;
			
			xp += $hp_max / 10;
			xp += P_ATK;
			xp += P_DEF;
			xp += R_ATK;
			xp += R_DEF;
			xp += M_ATK;
			xp += M_DEF;
			xp += S_ATK;
			xp += S_DEF;
			
			return xp;
		} // end of function getExperience
		
		public function addDialogueEntry(entry:Array):void
		{
			/* DIALOGUE STRUCTURE:
			 * dialogueQueue(Array)
			 * 	dialogueEntry(Array)
			 * 		dialogueDataObject(Object)
			 */
			trace ("Character::addDialogueEntry " + entry);
			
			dialogueQueue.push(entry);
		} // end of function addDialogueEntry
		
		public function interact(entryID:String = ""):void
		{
			// null check
			if (uiController == null) return;
			var diag:MovieClip = uiController.getUIElement("dialogue");
			
			if (diag == null) return;
			if (dialogueQueue == null) return;
			if (dialogueQueue.length <= 0) return;
			
			uiController.show("dialogue");
			
			// Make this more verbose so it can get a specific dialogue ID.
			trace ("Dialogue queue length (Character): " + dialogueQueue.length);
			diag.playDialogueEntry(dialogueQueue[0]);
			
			dialogueQueue.splice(0, 1);
		} // end of function interact
		
		public function equipWeapon($wep:Weapon):void
		{
			equippedWeapon = $wep;
			
			if ($wep.weaponClip == null) return;
			
			while (clip.animWrapper.weaponContainer.numChildren > 0)
				clip.animWrapper.weaponContainer.removeChildAt(0);
				
			clip.animWrapper.weaponContainer.addChild($wep.weaponClip);
			
		} // end of function equipWeapon
		
		public function healHP(value:int):void
		{
			$hp_current += value;
			if ($hp_current > $hp_max)
				$hp_current = $hp_max;
			dispatchEvent(new EventWithData(EVENT_DATA_CHANGE, { id: internalID } ));
		} // end of function healHP
		
		
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PRIVATE FUNCTIONS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function init($id:int):void
		{
			internalID = $id;
		} // end of function init
		
		private function onCharacterKO():void
		{
			dispatchEvent(new EventWithData(EVENT_KO, { id: internalID, char:this } ));
		} // end of function onCharacterKO
		
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                GETTERS / SETTERS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function get id():int
		{
			return internalID;
		} // end of function get id
		
		// CHARACTER SPRITE
		private function get clip():MovieClip
		{
			return this.getChildAt(0) as MovieClip;
		}
		
		// STAT REFERENCES
		
		public function get characterName():String
		{
			return $name;
		} // end of function get characterName
		
		public function set setCharacterName(newName:String):void
		{
			$name = newName;
		} // end of function set characterName
		
		public function get HP():int 
		{ 
			return $hp_current;
		}
		public function set HP(value:int):void
		{
			$hp_current = value;
		}
		
		public function get HP_MAX():int
		{
			return $hp_max;
		}
		
		public function set HP_MAX(value:int):void
		{
			$hp_max = value;
		}

		public function get EXP():int 
		{ 
			return $exp_current;
		}
		public function set EXP(value:int):void
		{
			$exp_current = value;
		}
		public function get EXP_MAX():int
		{
			return $exp_max;
		}
		public function set EXP_MAX(value:int):void
		{
			$exp_max = value;
		}
		public function get LEVEL():int 
		{ 
			return $level;
		}
		public function set LEVEL(value:int):void
		{
			$level = value;
		}
		public function get AP():int 
		{ 
			return $ap_current;
		}
		public function set AP(value:int):void
		{
			$ap_current = value;
		}
		public function get AP_MAX():int
		{
			return $ap_max;
		}
		public function set AP_MAX(value:int):void
		{
			$ap_max = value;
		}
		public function get SPEED():int 
		{ 
			return $speed;
		}
		public function set SPEED(value:int):void
		{
			$speed = value;
		}
		public function get P_ATK():int 
		{ 
			return $p_atk;
		}
		public function set P_ATK(value:int):void
		{
			$p_atk = value;
		}
		public function get R_ATK():int 
		{ 
			return $r_atk;
		}
		public function set R_ATK(value:int):void
		{
			$r_atk = value;
		}
		public function get M_ATK():int 
		{ 
			return $m_atk;
		}
		public function set M_ATK(value:int):void
		{
			$m_atk = value;
		}
		public function get S_ATK():int 
		{ 
			return $s_atk;
		}
		public function set S_ATK(value:int):void
		{
			$s_atk = value;
		}
		
		
		
		public function get P_DEF():int 
		{ 
			return $p_def;
		}
		public function set P_DEF(value:int):void
		{
			$p_def = value;
		}
		public function get R_DEF():int 
		{ 
			return $r_def;
		}
		public function set R_DEF(value:int):void
		{
			$r_def = value;
		}
		public function get M_DEF():int 
		{ 
			return $m_def;
		}
		public function set M_DEF(value:int):void
		{
			$m_def = value;
		}
		public function get S_DEF():int 
		{ 
			return $s_def;
		}
		public function set S_DEF(value:int):void
		{
			$s_def = value;
		}
		
		
	} // end of class Character
	
} // enDate of package src.Entites