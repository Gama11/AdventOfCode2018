package days;

import haxe.ds.HashMap;
import Util.Point;

class Day22 {
	static function getErosionLevel(pos:Point, depth:Int, target:Point, cache:HashMap<Point, Int>):Int {
		if (cache.exists(pos)) {
			return cache.get(pos);
		}
		var geologicIndex = if (pos.equals(new Point(0, 0)) || pos.equals(target)) {
			0;
		} else if (pos.x == 0) {
			pos.y * 48271;
		} else if (pos.y == 0) {
			pos.x * 16807;
		} else {
			getErosionLevel(pos.add(new Point(-1, 0)), depth, target, cache) *
			getErosionLevel(pos.add(new Point(0, -1)), depth, target, cache);
		}
		var erosionLevel = (geologicIndex + depth) % 20183;
		cache.set(pos, erosionLevel);
		return erosionLevel;
	}

	public static function determineRiskLevel(depth:Int, target:Point):Int {
		var erosionLevels = new HashMap<Point, Int>();
		var riskLevel = 0;
		for (x in 0...target.x + 1) {
			for (y in 0...target.y + 1) {
				riskLevel += getErosionLevel(new Point(x, y), depth, target, erosionLevels) % 3;
			}
		}
		return riskLevel;
	}
}
