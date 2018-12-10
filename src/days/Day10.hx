package days;

import Util.Point;

class Day10 {
	static function parse(input:String):Array<Star> {
		var regex = ~/position=<\s*(-?\d+),\s*(-?\d+)> velocity=<\s*(-?\d+),\s*(-?\d+)>/;
		return input.split("\n").map(line -> {
			if (!regex.match(line)) {
				throw 'unable to parse $line';
			}
			return {
				position: new Point(regex.matchedInt(1), regex.matchedInt(2)),
				velocity: new Point(regex.matchedInt(3), regex.matchedInt(4))
			}
		});
	}

	static function render(stars:Array<Star>):String {
		final n = 9999999;
		var maxX = -n;
		var maxY = -n;
		var minX = n;
		var minY = n;
		for (star in stars) {
			var pos = star.position;
			maxX = Std.int(Math.max(maxX, pos.x));
			maxY = Std.int(Math.max(maxY, pos.y));
			minX = Std.int(Math.min(minX, pos.x));
			minY = Std.int(Math.min(minY, pos.y));
		}
		var offset = new Point(-minX, -minY);
		var max = new Point(maxX, maxY).add(offset);

		var grid = [for (_ in 0...max.y + 1) [for (_ in 0...max.x + 1) "."]];
		for (star in stars) {
			var pos = star.position;
			grid[pos.y + offset.y][pos.x + offset.x] = "#";
		}
		return grid.map(row -> row.join("")).join("\n") + "\n";
	}

	public static function getMessage(input:String) {
		var stars = parse(input);
		var sum = 0.0;
		for (star in stars) {
			var pos = star.position;
			var vel = star.velocity;
			if (vel.x != 0) {
				sum += Math.abs(pos.x / vel.x);
			}
			if (vel.y != 0) {
				sum += Math.abs(pos.y / vel.y);
			}
		}
		var time = Math.round(sum / (stars.length * 2));
		for (star in stars) {
			star.position = star.position.add(star.velocity.scale(time));
		}
		Sys.println(render(stars));
		return time;
	}
}

private typedef Star = {
	var position:Point;
	final velocity:Point;
}
