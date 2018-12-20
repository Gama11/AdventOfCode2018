package days;

import Util.Point;
import Util.Movement.*;
import haxe.ds.HashMap;
import polygonal.ds.HashSet;

class Day20 {
	static function explore(input:String) {
		var rooms = new HashMap<Point, Room>();
		rooms.set(new Point(0, 0), {doors: new HashMap()});

		function addDoor(pos:Point, c:String):Point {
			var direction = switch (c) {
				case "N": Up;
				case "S": Down;
				case "W": Left;
				case "E": Right;
				case _: throw 'invalid direction $c';
			}
			var nextPos = pos.add(direction);
			var nextRoom = rooms.get(nextPos);
			if (nextRoom == null) {
				nextRoom = {doors: new HashMap()};
			}
			rooms.set(nextPos, nextRoom);
			var room = rooms.get(pos);
			room.doors.set(direction, nextRoom);
			nextRoom.doors.set(direction.invert(), room);
			return nextPos;
		}

		function parse(i:Int, options:HashSet<Point>) {
			var results = new HashSet<Point>(64);
			var current:HashSet<Point> = cast options.clone();
			while (i < input.length) {
				var c = input.charAt(i);
				i++;
				switch (c) {
					case "(":
						var parsed = parse(i, current);
						i = parsed.end;
						current = parsed.results;
					case ")":
						break;
					case "|":
						for (option in current) {
							results.set(option);
						}
						current = cast options.clone();
					case "N", "S", "W", "E":
						var newCurrent = new HashSet<Point>(current.size, current.size);
						for (room in current) {
							newCurrent.set(addDoor(room, c));
						}
						current = newCurrent;
					case "^", "$":
				}
			}
			for (option in current) {
				results.set(option);
			}
			return {results: results, end: i};
		}

		var options = new HashSet(1);
		options.set(new Point(0, 0));
		parse(0, options);
		return rooms;
	}

	static function render(rooms:HashMap<Point, Room>) {
		var points = [for (point in rooms.keys()) point];
		var bounds = Util.findBounds(points);
		var min = bounds.min;
		var max = bounds.max;
		var width = (max.x - min.x + 1) * 2 + 1;
		var height = (max.y - min.y + 1) * 2 + 1;
		var map = [for (_ in 0...height + 1) [for (_ in 0...width + 1) " "]];

		for (point in points) {
			var x = (point.x - min.x) * 2 + 1;
			var y = (point.y - min.y) * 2 + 1;
			map[y][x] = if (point.x == 0 && point.y == 0) "X" else ".";
			
			map[y - 1][x - 1] = "#";
			map[y - 1][x + 1] = "#";
			map[y + 1][x - 1] = "#";
			map[y + 1][x + 1] = "#";

			var doors = rooms.get(point).doors;
			map[y][x - 1] = if (doors.exists(Left)) "|" else "#";
			map[y][x + 1] = if (doors.exists(Right)) "|" else "#";
			map[y - 1][x] = if (doors.exists(Up)) "-" else "#";
			map[y + 1][x] = if (doors.exists(Down)) "-" else "#";
		}

		return map.map(row -> row.join("")).join("\n");
	}

	public static function analyzeFacility(input:String) {
		var rooms = explore(input);
		var openSet = [{pos: new Point(0, 0), distance: 0}];
		var closedSet = new HashMap<Point, Int>();
		while (openSet.length > 0) {
			var node = openSet.shift();
			var room = rooms.get(node.pos);
			for (neighbour in room.doors.keys()) {
				var pos = node.pos.add(neighbour);
				if (!closedSet.exists(pos)) {
					openSet.push({pos: pos, distance: node.distance + 1});
				}
			}
			closedSet.set(node.pos, node.distance);
		}

		var maxDistance = 0;
		var min1000Count = 0;
		for (distance in closedSet) {
			if (distance > maxDistance) {
				maxDistance = distance;
			}
			if (distance >= 1000) {
				min1000Count++;
			}
		}
		return {
			maxDistance: maxDistance,
			min1000Count: min1000Count
		};
	}
}

typedef Room = {
	final doors:HashMap<Point, Room>;
}
