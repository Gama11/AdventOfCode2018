package days;

class Day09 {
	public static function findHighScore(players:Int, lastMarble:Int):Int {
		var marbles = [0];
		var current = 0;
		var marbleNumber = 1;
		var scores = [for (player in 0...players) player => 0];
		var player = 0;

		while (marbleNumber <= lastMarble) {
			if (marbleNumber % 23 == 0) {
				scores[player] += marbleNumber;
				var toRemove = Util.mod(current - 7, marbles.length);
				scores[player] += marbles.splice(toRemove, 1)[0];
				current = toRemove;
			} else {
				var clockwise1 = (current + 1) % marbles.length;
				current = clockwise1 + 1;
				marbles.insert(current, marbleNumber);
			}
			player = (player + 1) % players;
			marbleNumber++;
		}
		
		var scores = scores.array();
		scores.sort((i1, i2) -> i2 - i1);
		return scores[0];
	}
}
