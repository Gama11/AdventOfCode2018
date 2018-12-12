package days;

class Day12 {
	static function parse(input:String):Data {
		var lines = input.split("\n");
		var initialState = lines.shift();
		initialState = initialState.replace("initial state: ", "");
		lines.shift();
		var rules = [for (rule in lines) {
			var split = rule.split(" => ");
			split[0] => split[1];
		}];
		return {
			pots: initialState,
			rules: rules
		}
	}

	public static function simulate(input:String):Int {
		var data = parse(input);
		var pots = data.pots.split("");
		var padding = 0;

		function pad() {
			var amount = 0;
			function filled(n:Int) {
				return pots[n] == Filled || pots[pots.length - 1 - n] == Filled;
			}
			if (filled(2)) amount = 1;
			if (filled(1)) amount = 2;
			if (filled(0)) amount = 3;
			for (_ in 0...amount) {
				pots.unshift(Empty);
				pots.push(Empty);
			}
			padding += amount;
		}
		pad();
		
		var generations = 20;
		for (_ in 0...generations) {
			var newPots = pots.copy();
			for (i in 2...pots.length - 2) {
				var section = pots[i - 2] + pots[i - 1] + pots[i] + pots[i + 1] + pots[i + 2];
				var rule = data.rules[section];
				newPots[i] = if (rule == null) Empty else rule;
			}
			pots = newPots;
			pad();
		}

		var sum = 0;
		for (i in 0...pots.length) {
			if (pots[i] == Filled) {
				sum += i - padding;
			}
		}
		return sum;
	}
}

private typedef Data = {
	var pots:String;
	var rules:Map<String, String>;
}

private enum abstract Pot(String) to String {
	var Empty = ".";
	var Filled = "#";
}
