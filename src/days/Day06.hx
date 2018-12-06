package days;

import Util.Point;

class Day06 {
	static function parsePoints(input:String):Array<Point> {
		return input.split("\n").map(line -> {
			var split = line.split(", ");
			return new Point(Std.parseInt(split[0]), Std.parseInt(split[1]));
		});
	}

	public static function findLargestFiniteArea(input:String):Int {
		var points = parsePoints(input);

		var maxX = 0;
		var maxY = 0;
		for (point in points) {
			if (point.x > maxX) {
				maxX = point.x;
			}
			if (point.y > maxY) {
				maxY = point.y;
			}
		}
		
		var areas = [for (point in points) point => 0];
		for (x in 0...maxX + 1) {
			for (y in 0...maxY + 1) {
				var p = new Point(x, y);
				var bestPoint = null;
				var bestDistance = null;
				var contested = false;
				for (point in points) {
					var distance = p.distanceTo(point);
					if (bestPoint == null || distance < bestDistance) {
						bestPoint = point;
						bestDistance = distance;
						contested = false;
					} else if (distance == bestDistance) {
						contested = true;
					}
				}

				if (contested) {
					continue;
				}

				if (p.x == 0 || p.x == maxX || p.y == 0 || p.y == maxY) {
					areas[bestPoint] = null;
				}
				if (areas[bestPoint] != null) {
					areas[bestPoint]++;
				}
			}
		}

		var sizes = areas.array().filter(i -> i != null);
		sizes.sort(Reflect.compare);
		return sizes[sizes.length - 1];
	}
}
