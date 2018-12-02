package days;

class Day02 {
	static function countLetters(word:String):Map<String, Int> {
		var counts = new Map<String, Int>();
		for (i in 0...word.length) {
			var char = word.charAt(i);
			var count = counts[char];
			if (count == null) {
				count = 0;
			}
			counts[char] = count + 1;
		}
		return counts;
	}

	public static function calculateChecksum(input:String):Int {
		var twos = 0;
		var threes = 0;
		for (id in input.split("\n")) {
			var counts = countLetters(id).array();
			if (counts.exists(i -> i == 2)) {
				twos++;
			}
			if (counts.exists(i -> i == 3)) {
				threes++;
			}
		}
		return twos * threes;
	}

	public static function findCommonLetters(input:String):String {
		var ids = input.split("\n");
		for (tuple in Util.tuples(ids)) {
			var differingLetter = null;
			for (i in 0...tuple.a.length) {
				var c1 = tuple.a.charAt(i);
				var c2 = tuple.b.charAt(i);
				if (c1 != c2) {
					if (differingLetter != null) {
						differingLetter = null;
						break;
					}
					differingLetter = c1;
				}
			}
			if (differingLetter != null) {
				return tuple.a.replace(differingLetter, "");
			}
		}
		return null;
	}
}
