package days;

import Util.Point;
import Util.Movement.*;
import haxe.ds.HashMap;

class Day17 {
	static function parseScan(input:String):Map {
		var tiles = new HashMap();
		var minY = 1000;
		var maxY = 0;
		var regex = ~/(x|y)=(\d+), (?:x|y)=(\d+)\.\.(\d+)/;
		for (line in input.split("\n")) {
			regex.match(line);
			var horizontal = regex.matched(1) == "y";
			var first = regex.matchedInt(2);
			var from = regex.matchedInt(3);
			var to = regex.matchedInt(4);
			for (i in from...to + 1) {
				var p = if (horizontal) new Point(i, first) else new Point(first, i);
				minY = Std.int(Math.min(minY, p.y));
				maxY = Std.int(Math.max(maxY, p.y));
				tiles.set(p, Clay);
			}
		}
		return {
			tiles: tiles,
			minY: minY,
			maxY: maxY
		};
	}

	static function render(map:Map):String {
		var points = [for (point in map.tiles.keys()) point];
		return Util.renderPointGrid(points, point -> switch (map.tiles.get(point)) {
			case Clay: "#";
			case RestingWater: "~";
			case FlowingWater: "|";
		});
	}

	static function canFlow(map:Map, pos:Point):Bool {
		return map.tiles.get(pos) == null || map.tiles.get(pos) == FlowingWater;
	}

	static function flowHorizontally(map:Map, pos:Point, direction:Point):Null<Point> {
		while (canFlow(map, pos.add(direction))) {
			pos = pos.add(direction);
			map.tiles.set(pos, FlowingWater);
			if (canFlow(map, pos.add(Down))) {
				flow(map, pos);
				return null;
			}
		}
		return pos;
	}

	static function flow(map:Map, start:Point) {
		// flow downwards
		var pos = start;
		while (canFlow(map, pos.add(Down))) {
			pos = pos.add(Down);
			map.tiles.set(pos, FlowingWater);
			if (pos.y < 0 || pos.y >= map.maxY) {
				return;
			}
		}
		// flow horizontally
		var left = flowHorizontally(map, pos, Left);
		var right = flowHorizontally(map, pos, Right);
		if (left != null && right != null) {
			for (x in left.x...right.x + 1) {
				map.tiles.set(new Point(x, pos.y), RestingWater);
			}
			pos = pos.add(Up);
			if (canFlow(map, pos)) {
				flow(map, pos.add(Up));
			}
		}
	}

	public static function countWaterTiles(input:String) {
		var map = parseScan(input);
		flow(map, new Point(500, 0));
		var total = 0;
		var resting = 0;
		for (pos in map.tiles.keys()) {
			if (pos.y < map.minY) {
				continue;
			}
			var tile = map.tiles.get(pos);
			switch (tile) {
				case RestingWater:
					total++;
					resting++;
				case FlowingWater:
					total++;
				case _:
			}
		}
		return {
			total: total,
			resting: resting
		};
	}
}

private typedef Map = {
	final tiles:HashMap<Point, Tile>;
	final minY:Int;
	final maxY:Int;
}

private enum Tile {
	Clay;
	RestingWater;
	FlowingWater;
}
