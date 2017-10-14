package src.Controllers
{	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import src.Entities.Character;
	import src.Entities.EncounterVolume;
	import src.Events.EventWithData;
	import src.Utilities.TimerWithData;
	
	/**
	 * ...
	 * @author SeguinM
	 * // PURPOSE: This is the main combat engine.
	 */
	public class  CombatController extends MovieClip
	{
		
		private var stageRef:Stage;
		private var combatContainer:MovieClip
		private var worldContainer:MovieClip
		
		private var playerDecisionPool:Array = [];                 // array of objects containing player actions
		
		public var goodGuys:Array = [];
		public var badGuys:Array = [];
		public var allCharacters:Array = [];
		
		private var actionInputIndex:int = 0;         // input index for player decisions
		private var combatIndex:int = 0;              // index to store current combatant from allCharacters
		
		private var targetID:int;                     // index of bad guy array of current target
		
		public var partyController:PartyController;
		public var playerController:PlayerController;
		public var worldController:WorldController;
		public var characterDataManager:CharacterDataManager;
		public var uiController:UIControllerBase;
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function CombatController($stageRef:Stage, $combatContainer:MovieClip, $worldContainer:MovieClip)
		{
			super();
			init($stageRef, $combatContainer, $worldContainer);	
		} // end of function CombatController
		
		public function spawnCharacters(leftChars:Array, rightChars:Array):void
		{
			
			// null check
			if (leftChars == null || rightChars == null)
				return;
				
			trace ("CombatController::spawnCharacters " + leftChars + ", " + rightChars);
			
			// assigns to existing vars
			goodGuys = leftChars;
			badGuys = rightChars;
			
			
			// LEFT CHARACTERS (YOUR GUYS)
			for (var i:int = 0; i < leftChars.length; i++)
			{
				
				var leftCharRef:MovieClip;
				leftCharRef = leftChars[i] as MovieClip;
				
				// adds sprite and pushes to back of render stack
				combatContainer.addChild(leftCharRef);
				combatContainer.setChildIndex(leftCharRef, 0);
				
				// Reference node
				var l_refNode:MovieClip = combatContainer.getChildByName("lNode" + String(i)) as MovieClip;
				if (l_refNode == null)
					return;
					
				leftCharRef.x = l_refNode.x;
				leftCharRef.y = l_refNode.y;
				
				// sets to Combat Idle animation
				(leftCharRef as Character).setAnimState("combatIdle");
				
				// event listener
				(leftCharRef as Character).addEventListener(Character.EVENT_KO, onCharacterKO);
			} // end of for loop
			
			// RIGHT CHARACTERS
			for (var j:int = 0; j < rightChars.length; j++)
			{
				var rightCharRef:MovieClip;
				rightCharRef = rightChars[j] as MovieClip;
				
				// adds sprite and pushes to back of render stack
				combatContainer.addChild(rightCharRef);
				combatContainer.setChildIndex(rightCharRef, 0);
				
				// Reference node
				var r_refNode:MovieClip = combatContainer.getChildByName("rNode" + String(j)) as MovieClip;
				if (r_refNode == null)
					return;
					
				rightCharRef.x = r_refNode.x;
				rightCharRef.y = r_refNode.y;
				
				// flips character so that it's facing the left
				rightCharRef.scaleX *= -1;
				
				// sets to combat idle animation
				rightCharRef.setAnimState("combatIdle");
				
				// event listener
				(rightCharRef as Character).addEventListener(Character.EVENT_KO, onCharacterKO);
			} // end of for loop
			
			combatContainer.setChildIndex(combatContainer.bg, 0);
			
		} // end of function spawnCharacters
		
		public function startAttackSequence(perpetrator:Character, defender:Character, attack:String):void
		{
			perpetrator.setAnimState("attackPhysical");
			defender.setAnimState("hurt");
		} // end of function startAttackSequence
		
		public function triggerCombatEncounter(enemySets:Array):void
		{
			if (partyController == null) return;
			if (uiController == null) return;
			
			trace ("triggered combat encounter");
			
			// sets ui
			uiController.show("battleLog");
			worldController.setGameMode("combat");
			
			// resets target id
			targetID = 0;
			
			// disables player movement
			if (playerController != null)
				playerController.isMovable = false;
			
			goodGuys = generateGoodGuys();
			badGuys = generateEnemyGroup(enemySets);
			
			var combatBarUI:MovieClip = uiController.getUIElement("combatBar");
			
			if (combatBarUI != null)
			{
				combatBarUI.populateCharacterData(goodGuys, badGuys);
				trace ("Passed Combat Bar UI null check");
			} // end of if statement
			
			spawnCharacters(goodGuys, badGuys);
			
			generateCharacterPool(goodGuys, badGuys);
			
			playerDecisionPool = [];
			
			actionInputIndex = 0;	//index that stores what active player input index is
			
			getPlayerDecisions();
		} // end of function triggerCombatEncounter
		
		public function forceTriggerCombat(enemies:Array):void
		{
			if (partyController == null) return;
			if (uiController == null) return;
			trace ("force trigger combat. " + enemies);
			
			// sets ui
			uiController.show("battleLog");
			worldController.setGameMode("combat");
			
			// resets target id
			targetID = 0;
			
			// disables player movement
			if (playerController != null)
				playerController.isMovable = false;
			
			goodGuys = generateGoodGuys();
			
			badGuys = [];
			for (var i:int = 0; i < enemies.length; i++)
			{
				var enemy:MovieClip = characterDataManager.generateNewCharacter(enemies[i].id, enemies[i].level);
				badGuys.push(enemy);
			} // end of for loop
			
			var combatBarUI:MovieClip = uiController.getUIElement("combatBar");
			
			if (combatBarUI != null)
			{
				combatBarUI.populateCharacterData(goodGuys, badGuys);
				trace ("Passed Combat Bar UI null check");
			} // end of if statement
			
			spawnCharacters(goodGuys, badGuys);
			
			generateCharacterPool(goodGuys, badGuys);
			
			playerDecisionPool = [];
			
			actionInputIndex = 0;	//index that stores what active player input index is
			
			getPlayerDecisions();
		} // end of function forceTriggerCombat
		
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                               PRIVATE FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function init($stageRef:Stage, $combatContainer:MovieClip, $worldContainer:MovieClip):void
		{
			stageRef = $stageRef;
			combatContainer = $combatContainer;
			worldContainer = $worldContainer;
			
			hideHighlights();
			combatContainer.highlight_choice.mouseEnabled = false;
			combatContainer.highlight_choice.mouseChildren = false;
			combatContainer.highlight_target.mouseEnabled = false;
			combatContainer.highlight_target.mouseChildren = false;
			
			initListeners();
		} // end of function init
		
		private function hideHighlights():void
		{
			if (combatContainer == null) return;
			
			combatContainer.highlight_target.visible = false;
			combatContainer.highlight_choice.visible = false;
		} // end of funciton hideHighlights
		
		private function highlight(type:String, target:Character)
		{
			var highlighter:MovieClip = type == "target" ? combatContainer.highlight_target : combatContainer.highlight_choice;
			
			highlighter.visible = true;
			highlighter.x = target.x;
			highlighter.y = target.y; 
			
			combatContainer.setChildIndex(highlighter, combatContainer.getChildIndex(target) + 1);
		} // end of function highlight
		
		private function initListeners():void
		{
			worldContainer.addEventListener(EncounterVolume.EVENT_TRIGGER_COMBAT, onCombatTriggered);
		} // end of function initListeners
		
		private function onCombatTriggered(event:EventWithData):void
		{
			trace ("Combat controller ready to set up combat");
			triggerCombatEncounter(event.data.enemies);
		} // end of function onCombatTriggered
		
		private function generateEnemyGroup(enemySets:Array):Array
		{
			var ret:Array = [];    // array of characters to return
			
			var r:Number = (Math.random() * 100) + 1;    // random number to compare with
			var enemySet:Object;                         // enemy set that will be randomly selected
			var c:Number = 0;                            // chance number, accumulative for randomization purposes
			
			for (var i:int = 0; i < enemySets.length; i++)
			{
				c += enemySets[i].chance;
				
				if (i == 0)
					enemySet = enemySets[i];
					
				else if (i > 0)
				{
					if (r <= c && r > c - enemySets[i].chance)
						enemySet = enemySets[i];
				} // end of else if
			} // end of for loop
			
			trace ("Random Enemy Gen. " + r + ", " + enemySet.enemies);
			
			ret = generateEnemies(enemySet.enemies);
			
			return ret;
		} // end of function generateEnemyGroup
		
		private function generateEnemies(enemyDataArray:Array):Array
		{
			var ret:Array = [];
			
			for (var i:int = 0; i < enemyDataArray.length; i++)
			{
				var char:MovieClip = characterDataManager.generateNewCharacter(enemyDataArray[i].stringID, enemyDataArray[i].lvl);
				
				if (char != null)
					ret.push(char);
			} // end of function ret
			
			return ret;
		} // end of function generateEnemies
		
		private function generateCharacterPool(goodGuys:Array, badGuys:Array):void
		{
			var i:int = 0;
			
			allCharacters = [];
			
			for (i = 0; i < goodGuys.length; i++)
				allCharacters.push(goodGuys[i]);
			for (i = 0; i < badGuys.length; i++)
				allCharacters.push(badGuys[i]);
				
			trace ("length " + allCharacters.length);
		} // end of function generateCharacterPool
		
		private function getPlayerDecisions():void
		{	
			hideHighlights();
			
			uiController.show("combatBar");
			
			var combatBarUI:MovieClip = uiController.getUIElement("combatBar");
			
			if (combatBarUI == null) return;
			
			combatBarUI.setDecisionButtonVis(true);
			
			highlight("target", badGuys[targetID]);
			highlight("choice", goodGuys[actionInputIndex]);
			
			combatContainer.highlight_choice.visible = true;
			
			
			
			if (!combatBarUI.hasEventListener(CombatBarController.EVENT_ATTACK_CLICKED))
				combatBarUI.addEventListener(CombatBarController.EVENT_ATTACK_CLICKED, getAttackDecision); 
				
			for (var i:int = 0; i < badGuys.length; i++)
			{
				if (!badGuys[i].hasEventListener(MouseEvent.CLICK))
					badGuys[i].addEventListener(MouseEvent.CLICK, onTargetChange);
			} // end of for loop
		} // end of function getPlayerDecisions
		
		private function onTargetChange(event:MouseEvent):void
		{
			if (!(event.target is Character)) return;
				
			var inID:int = event.target.id;
			
			for (var i:int = 0; i < badGuys.length; i++)
			{
				if (badGuys[i].id == inID)
				{
					targetID = i;
					highlight("target", badGuys[i]);
					break;
				} // end of if statement
			} // end of for loop
		} // end of function onTargetChange
		
		private function getAttackDecision(event:Event):void
		{
			var action:Object = { };
			action.id = goodGuys[actionInputIndex].id;
			action.perpetrator = goodGuys[actionInputIndex];
			action.defender = badGuys[targetID];
			action.type = goodGuys[actionInputIndex].equippedWeapon == null ? "melee" : goodGuys[actionInputIndex].equippedWeapon.weaponType;
			trace ("Attack type: " + action.type);
			playerDecisionPool.push(action);
			
			onDecisionMade();
		} // end of function getAttackDecision
		
		private function onDecisionMade():void
		{
			actionInputIndex++;
			
			if (actionInputIndex < goodGuys.length)
				getPlayerDecisions();
				
			else
			{
				var combatBarUI:MovieClip = uiController.getUIElement("combatBar");
				if (combatBarUI != null)
					combatBarUI.setDecisionButtonVis(false);
					hideHighlights();
				getAIDecisions();
			} // end of else statement
		} // end of function get onDecisionMade;
		
		private function getAIDecisions():void
		{	// make more verbose!
			for (var i:int = 0; i < badGuys.length; i++)
			{
				var action:Object = { };
				action.id = badGuys[i].id;
				action.perpetrator = badGuys[i];
				var r:int = Math.random() * goodGuys.length;
				action.defender = goodGuys[r];
				action.type = badGuys[i].equippedWeapon == null ? "melee" : badGuys[i].equippedWeapon.weaponType;
				playerDecisionPool.push(action);
				
				if (badGuys[i].hasEventListener(MouseEvent.CLICK))
					badGuys[i].removeEventListener(MouseEvent.CLICK, onTargetChange);
			} // end of for loop
			
			triggerTurnSequence();
		} // end of function getAIDecisions
		
		private function triggerTurnSequence():void
		{	// Called once all player and AI decisions are made
			trace ("DECISIONS MADE");
			combatIndex = 0;
			
			playAction();
		} // end of function triggerTurnSequence
		
		private function playAction():void
		{	// plays the action at index 0
			if (playerDecisionPool == null) return;
			if (playerDecisionPool.length == 0) return;
			
			var action:Object = playerDecisionPool[0];
			
			var actionFunction:Function;
			
			switch (action.type)
			{
				case "melee":
					actionFunction = attack;
					break;
				case "ranged":
					actionFunction = rangedAttack;
					break;
				default:
					throw new Error("invalid action type specified at CombatController::playAction. " + action.type);
					break;
			} // end of switch
			
			// remove sequence from pool
			playerDecisionPool.splice(0, 1);
			
			actionFunction(action);
			
			// DO STUFF -- do a switch on the type, then pass on the relevant function and pass this action through as params.
		} // end of function playAction
		
		private function onCharacterKO(event:EventWithData):void
		{
			trace ("CHARACTER KO!!!");
			
			var char:Character;
			
			for (var i:int = 0; i < allCharacters.length; i++)
			{
				if (allCharacters[i].id == event.data.id)
				{
					trace ("Removed char from allChars");
					char = allCharacters[i];
					allCharacters.splice(i, 1);
					break;
				} // end of if statement
			} // end of for loop
			
			for (var j:int = 0; j < goodGuys.length; j++)
			{
				if (goodGuys[j].id == event.data.id)
				{
					trace ("Removed char from goodguys");
					goodGuys.splice(j, 1);
					break;
				} // end of if statement
			} // end of for loop
			
			for (var k:int = 0; k < badGuys.length; k++)
			{
				if (badGuys[k].id == event.data.id)
				{
					trace ("Removed char from badguys");
					var xp:int = badGuys[k].getExperience();
					addExpToParty(xp);
					badGuys.splice(k, 1);
					break;
				} // end of if statement
			} // end of for loop
			
			if (char == null) return;
			
			removeActionsFromPool(event.data.id);
			
			if (targetID > badGuys.length - 1)
				targetID = badGuys.length - 1;
			
			var timer:TimerWithData = new TimerWithData(0.9, { onComplete: cleanUpDeadChar, onCompleteParams: event.data } );
			timer.startTimer();
		} // end of function onCharacterKO
		
		private function cleanUpDeadChar(params:Object):void
		{
			trace ("CombatController::cleanUpDeadChar " + params.id + ", " + params.char);
			
			if (params.char == null || params.id == null) return;
			
			var combatBarUI:MovieClip = uiController.getUIElement("combatBar");
			
			if (combatBarUI == null) return;
			
			combatBarUI.removeItem(params.id);
			
			combatContainer.removeChild(params.char);
		} // end of function cleanUpDeadChar
		
		private function addExpToParty(xp:int):void
		{
			if (partyController == null) return;
			
			var activeParty:Array = generateGoodGuys();
			
			if (activeParty == null) return;
			
			var xpDiv:int = xp / activeParty.length;
			
			for (var i:int = 0; i < activeParty.length; i++)
				(activeParty[i] as Character).addExperience(xpDiv);
		} // end of function addExpToParty
		
		private function removeActionsFromPool(id:int):void
		{
			var repeat:Boolean = false;
			
			for (var i:int = 0; i < playerDecisionPool.length; i++)
			{
				if (playerDecisionPool[i].id == id)
				{
					playerDecisionPool.splice(i, 1);
					repeat = true;
					break;
				} // end of nested if statement
				
				// also removes any attacks that had this char as defendant
				if ((playerDecisionPool[i].defender as Character).id == id)
				{
					playerDecisionPool.splice(i, 1);
					combatIndex++;  // bumps up to accoutn for lost sequence
					repeat = true;
					break;
				} // end of if statement
			} // for loop
			
			if (repeat && playerDecisionPool.length > 0)
				removeActionsFromPool(id);
		} // end of function removeActionFromPool
		
		private function endCombat():void
		{
			trace ("END COMBAT!");
			
			hideHighlights();
			
			if (badGuys.length == 0)
			{
				
				for (var i:int = 0; i < goodGuys.length; i++)
					goodGuys[i].setAnimState("victoryPose");
					
				// sets ui
				uiController.hide("combatBar");
				
				var timer:TimerWithData = new TimerWithData(3, { onComplete: triggerWorldMode } );
				timer.startTimer();
			} // end of if statement
				
		} // end of function endCombat
		
		private function triggerWorldMode():void
		{
			uiController.hide("battleLog");
			
			worldController.setGameMode("overworld");
				
				// disables player movement
				if (playerController != null)
					playerController.isMovable = true;
		} // end of function triggerWorldMode
		
		private function generateGoodGuys():Array
		{
			var ret:Array = [];
			var party:Array = partyController.activeParty;
			for (var i:int = 0; i < party.length; i++)
			{
				if ((party[i] as Character).HP > 0)
					ret.push(party[i]);
			} // end of for loop
			
			return ret;
		} // end of function generateGoodGuys
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                COMBAT FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function attack(params:Object):void
		{
			if (params.perpetrator == null || params.defender == null) return;
			
			var perpetrator:Character = params.perpetrator;
			var defender:Character = params.defender;
			
			perpetrator.setAnimState("attackPhysical");
			
			var onCompleteData:Object = { perpetrator: perpetrator, defender: defender };
			var timer:TimerWithData = new TimerWithData(1, { onComplete: onAttackAnimComplete, onCompleteParams: onCompleteData} );
			timer.startTimer();
		} // end of function attack
		
		private function rangedAttack(params:Object):void
		{
			if (params.perpetrator == null || params.defender == null) return;
			
			var perpetrator:Character = params.perpetrator;
			var defender:Character = params.defender;
			
			perpetrator.setAnimState("attackRanged");
			perpetrator.equippedWeapon.playFireAnim();
			
			var onCompleteData:Object = { perpetrator: perpetrator, defender: defender };
			var timer:TimerWithData = new TimerWithData(1, { onComplete: onAttackAnimComplete, onCompleteParams: onCompleteData } );
			timer.startTimer();
		} // end of function rangedAttack
		
		private function onAttackAnimComplete(params:Object):void
		{
			trace ("TIMER COMPLETE! ");
			
			var perpetrator:Character = params.perpetrator;
			var defender:Character = params.defender;
			
			if (perpetrator == null || defender == null) return;
			
			defender.setAnimState("hurt");
			
			//var damage:int = (perpetrator.P_ATK + (perpetrator.equippedWeapon == null ? 20 : perpetrator.equippedWeapon.damage)) - ( defender.P_DEF);
			var damage:int;
			
			if (perpetrator.equippedWeapon == null)
				damage = (perpetrator.P_ATK + 20) - defender.P_DEF;
			else
				damage = perpetrator.equippedWeapon.getDamage(perpetrator) - (perpetrator.equippedWeapon.weaponType == "ranged" ? defender.R_DEF : defender.P_DEF);
			if (damage < 1)
				damage = 1;
			
			//trace (perpetrator.characterName + " attacked " + defender.characterName + ". " + damage + " damage. " + perpetrator.P_ATK + " attack, " + defender.P_DEF + " defense.");
			var battleLog:MovieClip = uiController.getUIElement("battleLog");
			if (battleLog != null)
				battleLog.generateLog(String(perpetrator.characterName + " attacked " + defender.characterName + ". " + damage + " damage. "));
			
			defender.dealDamage(damage);
			
			//var onCompleteData:Object = { perpetrator: perpetrator, defender: defender };
			var timer:TimerWithData = new TimerWithData(1, { onComplete: onPhaseComplete } );
			timer.startTimer();
		} // end of function onAttackAnimComplete
		
		private function onPhaseComplete():void
		{
			combatIndex++;
			
			if (combatIndex < allCharacters.length)
				playAction();
			else
			{
				actionInputIndex = 0;	//index that stores what active player input index is
				
				if (goodGuys.length == 0 || badGuys.length == 0)
					endCombat();
				else
					getPlayerDecisions();
				playerDecisionPool = [];
			} // end of else statement
		} // end of function onPhaseComplete
		
	} // end of class CombatController
	
} // end of package src.Controllers