package days;

import Util.Point3D;
import Util.PrioritizedItem;
import polygonal.ds.PriorityQueue;

class Day23 {
	static function parse(input:String):Array<Sphere> {
		var regex = ~/pos=<([-\d]+),([-\d]+),([-\d]+)>, r=(\d+)/;
		return input.split("\n").map(line -> {
			regex.match(line);
			var center = new Point3D(regex.matchedInt(1), regex.matchedInt(2), regex.matchedInt(3));
			var radius = regex.matchedInt(4);
			return new Sphere(center, radius);
		});
	}

	public static function countBotsInBiggestRange(input:String):Int {
		var bots = parse(input);
		var biggestRadius = bots.max(bot -> bot.radius).list[0];
		return bots.count(bot -> biggestRadius.contains(bot.center));
	}

	public static function findIdealPosition(input:String):Int {
		var bots = parse(input);

		var spheres = new PriorityQueue(1);
		function enqueue(sphere:Sphere) {
			var overlaps = bots.count(bot -> bot.overlaps(sphere));
			spheres.enqueue(new PrioritizedItem(sphere, overlaps));
		}

		var biggestRadius = bots.max(bot -> bot.radius).list[0].radius;
		var initialSphere = new Sphere(new Point3D(0, 0, 0), biggestRadius);
		enqueue(initialSphere);

		while (true) {
			var sphere = spheres.dequeue().item;
			if (sphere.radius == 0) {
				return sphere.center.distanceTo(new Point3D(0, 0, 0));
			}

			for (subsphere in sphere.divide()) {
				enqueue(subsphere);
			}
		}

		return 0;
	}
}

private class Sphere {
	static var directions = [
		new Point3D(-1,  0,  0),
		new Point3D( 1,  0,  0),
		new Point3D( 0, -1,  0),
		new Point3D( 0,  1,  0),
		new Point3D( 0,  0, -1),
		new Point3D( 0,  0,  1)
	];

	public final center:Point3D;
	public final radius:Int;

	public function new(center, radius) {
		this.center = center;
		this.radius = radius;
	}

	public function divide():Array<Sphere> {
		var newRadius = Math.floor(radius * (3 / 4));
		if (newRadius == 0) {
			return [new Sphere(center, 0)];
		}
		return directions.map(dir -> new Sphere(center.add(dir.scale(newRadius)), newRadius));
	}

	public function overlaps(sphere:Sphere):Bool {
		return center.distanceTo(sphere.center) <= radius + sphere.radius;
	}

	public function contains(pos:Point3D):Bool {
		return center.distanceTo(pos) <= radius;
	}
	
	function toString() {
		return '$center r$radius';
	}
}
