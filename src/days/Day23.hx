package days;

import Util.Point3D;

class Day23 {
	static function parse(input:String):Array<Nanobot> {
		var regex = ~/pos=<([-\d]+),([-\d]+),([-\d]+)>, r=(\d+)/;
		return input.split("\n").map(line -> {
			regex.match(line);
			return {
				position: new Point3D(regex.matchedInt(1), regex.matchedInt(2), regex.matchedInt(3)),
				radius: regex.matchedInt(4)
			};
		});
	}

	public static function countBotsInBiggestRange(input:String):Int {
		var bots = parse(input);
		var biggestRadius = bots.max(bot -> bot.radius);
		return bots.filter(bot -> {
			bot.position.distanceTo(biggestRadius.position) <= biggestRadius.radius;
		}).length;
	}
}

private typedef Nanobot = {
	final position:Point3D;
	final radius:Int;
}
