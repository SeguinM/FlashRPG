package src.Entities
{
	import flash.display.MovieClip;
	import src.Utilities.SpriteSwapper;
	import src.Utilities.XMLLoader;
	
	/**
	 * ...
	 * @author SeguinM
	 */
	public class  Weapon extends MovieClip
	{
		
		// VARIABLES-------------------------------------------------------------------------------------------------------
		
		private var $weaponName:String = "";		// name of weapon
		private var $weaponType:String = "melee";   // type of weapon. melee, ranged, magic, soultap
		private var $ammoType:String = "";          // ammo type
		private var $accuracy:Number = 100.00;      // accuracy per hit
		private var $damage:int = 0;                // damage per hit
		private var $shots:int = 0;                 // number of shots gun takes 
		private var $magsize:int = 0;                // gun magsize.
		private var $clip:MovieClip;                // weapon graphic
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PUBLIC FUNCTIONS                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function Weapon(stringID:String)
		{
			generateWeaponFromXML(stringID);
			trace ("Weapon constructor function");
		} // end of constructor function
		
		public function getDamage(perpetrator:Character):int
		{
			var dmg:int;
			
			var ATK:int = $weaponType == "ranged" ? perpetrator.R_ATK : perpetrator.P_ATK;
			
			if ($weaponType == "ranged")
				dmg = calcShots(ATK);
				
			else
				dmg = ATK + $damage;
			
			return dmg;
		} // end of function getDamage
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                PRIVATE FUNCTIONS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function calcShots(ATK:int):int
		{
			var totalDamage:int = 0;
			
			var hitCounter:int = 0;
			
			for (var i:int = 0; i < $shots; i++)
			{
				var r:Number = Math.random() * 100;
				if (r <= $accuracy)
				{
					totalDamage += $damage;
					hitCounter++;
				} // end of if statement
			} // end of for loop
			
			if (hitCounter > 0)
				totalDamage += ATK;
			
			trace ($weaponName + " did " + totalDamage + " damage. " + ATK + ", " + hitCounter + "/" + $shots + " hits. " + $damage + " damage per hit");
			
			return totalDamage;
			
		} // end of function calcShots
		
		public function playFireAnim():void
		{
			$clip.gotoAndPlay("fire");
		} // end of function playFireAnim
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                            WEAPON GENERATION FUNCTIONS                                        //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private function generateWeaponFromXML(stringID:String):void
		{
			var wepXML:XML = XMLLoader.getLoadedXML("WeaponList");
			
			if (wepXML == null) return;
			
			var weapons: XMLList = wepXML.weapon;       // assigns all instances of weapon
			var nWep:XML;                               // specific weapon instance we're looking for
			
			for each (var $tag:XML in weapons)
			{
				if ($tag.attribute("id"))
				{
					if ($tag.@id == stringID)
					{
						nWep = $tag;
						break;
					} // end of if statement
				} // end of if statement
			} // end of for each loop
			
			if (nWep == null) return;
			
			setData(nWep);
		} // end of function generateWeapon
		
		private function setData(nWep:XML):void
		{
			if (nWep.attribute("type"))
				$weaponType = nWep.@type;
			if (nWep.elements("name"))
				$weaponName = nWep.name;
			if (nWep.elements("ammo"))
				$ammoType = nWep.ammo;
			if (nWep.elements("accuracy"))
				$accuracy = nWep.accuracy;
			if (nWep.elements("damage"))
				$damage = nWep.damage;
			if (nWep.elements("shots"))
				$shots = nWep.shots;
			if (nWep.elements("magsize"))
				$magsize = nWep.magsize;
			if (nWep.elements("flashEntity"))
				$clip = SpriteSwapper.getSprite(nWep.flashEntity);
		} // end of function setData
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                GETTERS / SETTERS                                              //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function get weaponType():String
		{
			return $weaponType;
		} // end of function get weaponType
		
		public function get weaponName():String
		{
			return $weaponName;
		} // end of function get weaponName
		
		public function get weaponClip():MovieClip
		{
			return $clip;
		} // end of function get weaponClip
		
	} // end of class Weapon
	
} // end of package src.Entities