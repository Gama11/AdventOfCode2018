package days;

import polygonal.ds.Dll;

class Day09 {
	public static function findHighScore(players:Int, lastMarble:Int):Int {
		var marbles = new Dll(0, [0]);
		marbles.close();
		var current = marbles.getNodeAt(0);
		var marbleNumber = 1;
		var scores = [for (player in 0...players) player => 0];
		var player = 0;

		while (marbleNumber <= lastMarble) {
			if (marbleNumber % 23 == 0) {
				for (_ in 0...7) {
					current = current.prev;
				}
				scores[player] += marbleNumber + current.val;
				current = marbles.unlink(current);
			} else {
				current = marbles.insertAfter(current.next, marbleNumber);
			}
			player = (player + 1) % players;
			marbleNumber++;
		}
		
		var scores = scores.array();
		scores.sort((i1, i2) -> i2 - i1);
		return scores[0];
	}
}
