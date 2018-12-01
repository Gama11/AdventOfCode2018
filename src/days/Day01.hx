package days;

class Day01 {
	static function parse(input:String):Array<Int> {
		return ~/(\n|, )/g.split(input).map(op -> {
			if (op.charAt(0) == "+") {
				op = op.substr(1);
			}
			Std.parseInt(op);
		});
	}

	public static function findFinalFrequency(input:String):Int {
		var frequency = 0;
		for (i in parse(input)) {
			frequency += i;
		}
		return frequency;
	}

	public static function findFirstDuplicateFrequency(input:String):Null<Int> {
		var frequency = 0;
		var seen = [0 => true];
		while (true) {
			for (i in parse(input)) {
				frequency += i;
				if (seen.exists(frequency)) {
					return frequency;
				}
				seen[frequency] = true;
			}
		}
		return null;
	}
}
