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
			var counts = [for (count in countLetters(id)) count];
			if (counts.exists(i -> i == 2)) {
				twos++;
			}
			if (counts.exists(i -> i == 3)) {
				threes++;
			}
		}
		return twos * threes;
	}
}
