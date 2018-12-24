package days;

class Day24 {
	static function parse(input:String):Array<Army> {
		var armies = ~/(\n\n)?.*?:\n/g.split(input).filter(s -> s.length > 0);
		var regex = ~/(\d+) units each with (\d+) hit points(?: \((.*?)\))? with an attack that does (\d+) (\w+) damage at initiative (\d+)/;
		return armies.map(army -> {
			var id = 1;
			army.split("\n").map(group -> {
				if (!regex.match(group)) {
					throw group;
				}
				var weaknesses = [];
				var immunities = [];
				var resistances = regex.matched(3);
				if (resistances != null) {
					for (resistance in resistances.split("; ")) {
						var regex = ~/(immune|weak) to (.*)/;
						regex.match(resistance);
						var list = regex.matched(2).split(", ");
						switch (regex.matched(1)) {
							case "weak": weaknesses = list;
							case "immune": immunities = list;
							case s: throw s; 
						}
					}
				}
				return new Group({
					id: id++,
					units: regex.matchedInt(1),
					hitPoints: regex.matchedInt(2),
					weaknesses: weaknesses,
					immunities: immunities,
					damage: regex.matchedInt(4),
					damageType: regex.matched(5),
					initiative: regex.matchedInt(6)
				});
			});
		});
	}

	public static function simulateCombat(input:String):Int {
		var armies = parse(input);
		var immuneSystem = armies[0];
		var infection = armies[1];

		while (immuneSystem.length > 0 && infection.length > 0) {
			var selectedTargets = new Map<Group, Group>();
			immuneSystem.sort();
			infection.sort();

			function selectTargets(attackers:Army, defenders:Army) {
				var defendersLeft = defenders.copy();
				for (attacker in attackers) {
					var max:Army = defendersLeft.max(defender -> attacker.damageAgainst(defender));
					if (max.length == 0) {
						continue;
					}
					var defender = max.sort()[0];
					selectedTargets[attacker] = defender;
					defendersLeft.remove(defender);
				}
			}

			selectTargets(infection, immuneSystem);
			selectTargets(immuneSystem, infection);

			var groups = immuneSystem.concat(infection);
			groups.sort((a, b) -> Reflect.compare(b.initiative, a.initiative));
			for (attacker in groups) {
				var defender = selectedTargets[attacker];
				if (attacker.alive && defender != null) {
					attacker.attack(defender);
				}
			}

			immuneSystem = immuneSystem.filter(group -> group.alive);
			infection = infection.filter(group -> group.alive);
		}
		
		var winner = if (infection.length == 0) immuneSystem else infection;
		return winner.map(group -> group.units).sum();
	}
}

@:forward private abstract Group(GroupData) to GroupData {
	public var alive(get, never):Bool;
	function get_alive() return this.units > 0;

	public var effectivePower(get, never):Int;
	function get_effectivePower() return this.damage * this.units;

	public function new(group) {
		this = group;
	}

	public function isWeakTo(damageType:DamageType):Bool {
		return this.weaknesses.indexOf(damageType) != -1;
	}

	public function isImmuneTo(damageType:DamageType):Bool {
		return this.immunities.indexOf(damageType) != -1;
	}

	public function damageAgainst(defender:Group):Int {
		if (defender.isImmuneTo(this.damageType)) {
			return 0;
		}
		var multiplier = if (defender.isWeakTo(this.damageType)) 2 else 1;
		return effectivePower * multiplier;
	}

	public function attack(defender:Group) {
		var damageDealt = damageAgainst(defender);
		var unitsKilled = Std.int(damageDealt / defender.hitPoints);
		defender.units -= unitsKilled;
	}

	public function compareTo(group:Group):Int {
		var i = Reflect.compare(effectivePower, group.effectivePower);
		if (i == 0) {
			i = Reflect.compare(this.initiative, group.initiative);
		}
		return i;
	}
}

private typedef GroupData = {
	final id:Int;
	var units:Int;
	final hitPoints:Int;
	final weaknesses:Array<DamageType>;
	final immunities:Array<DamageType>;
	final damage:Int;
	final damageType:DamageType;
	final initiative:Int;
}

private typedef DamageType = String;

@:forward abstract Army(Array<Group>) from Array<Group> to Array<Group> {
	public function sort():Army {
		this.sort((a, b) -> b.compareTo(a));
		return this;
	}

	@:arrayAccess function get(i:Int):Group {
		return this[i];
	}
}
