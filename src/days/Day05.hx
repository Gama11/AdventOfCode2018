package days;

class Day05 {
	public static function reduce(input:String):String {
		var polymer = input.split("");
		var i = 1;
		var prev = polymer[0];
		while (i < polymer.length) {
			var unit = polymer[i];
			if (prev != null && react(unit, prev)) {
				polymer.splice(i - 1, 2);
				i--;
				prev = polymer[i - 1];
			} else {
				i++;
				prev = unit;
			}
		}
		return polymer.join("");
	}

	static function react(unit1:String, unit2:String):Bool {
		return unit1 != unit2 && unit1.toLowerCase() == unit2.toLowerCase();
	}
}
