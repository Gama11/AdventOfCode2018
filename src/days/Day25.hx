package days;

class Day25 {
	static function distanceBetween(p1:Point, p2:Point):Int {
		var distance = 0;
		for (i in 0...p1.length) {
			distance += Std.int(Math.abs(p1[i] - p2[i]));
		}
		return distance;
	}

	public static function countConstellations(input:String):Int {
		var points = input.split("\n").map(s -> s.trim().split(",").map(Std.parseInt));
		var constellations:Array<Array<Point>> = [];

		for (point in points) {
			var matchingConstellations = constellations.filter(constellation -> {
				constellation.exists(p -> distanceBetween(p, point) <= 3);
			});
			if (matchingConstellations.length == 0) {
				constellations.push([point]);
			} else {
				var constellation = matchingConstellations[0];
				constellation.push(point);
				
				for (i in 1...matchingConstellations.length) {
					var matchingConstellation = matchingConstellations[i];
					constellations.remove(matchingConstellation);
					for (point in matchingConstellation) {
						constellation.push(point);
					}
				}
			}
		}

		return constellations.length;
	}
}

private typedef Point = Array<Int>;
