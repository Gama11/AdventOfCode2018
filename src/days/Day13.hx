package days;

import Util.Point;
import Util.Movement.*;
import haxe.ds.HashMap;

class Day13 {
	static function parse(input:String):TrackSystem {
		var track = new Track();
		var carts = new Array<Cart>();

		var rows = input.split("\n");
		for (y in 0...rows.length) {
			var row = rows[y];
			for (x in 0...row.length) {
				var position = new Point(x, y);
				function addSegment(segment:Segment) {
					track.set(position, segment);
				}
				function addCart(direction:Point) {
					carts.push({position: position, direction: direction, turnsMade: 0});
				}
				switch (row.charAt(x)) {
					case "-":
						addSegment(Horizontal);
					case "|":
						addSegment(Vertical);
					case "/":
						addSegment(CurveLeft);
					case "\\":
						addSegment(CurveRight);
					case "+":
						addSegment(Intersection);
					case "^":
						addCart(Up);
						addSegment(Horizontal);
					case "v":
						addCart(Down);
						addSegment(Horizontal);
					case "<":
						addCart(Left);
						addSegment(Vertical);
					case ">":
						addCart(Right);
						addSegment(Vertical);
					case _:
				}
			}
		}

		return {
			track: track,
			carts: carts
		};
	}

	static function sortCarts(a:Cart, b:Cart):Int {
		var p1 = a.position;
		var p2 = b.position;
		if (p1.y == p2.y) {
			return p1.x - p2.x;
		}
		return p1.y - p2.y;
	}

	static final directions = [Left, Up, Right, Down];

	static function move(cart:Cart, track:Track) {
		cart.position = cart.position.add(cart.direction);
		var nextSegment = track.get(cart.position);
		if (nextSegment == null) {
			throw 'no segment at ${cart.position}';
		}
		cart.direction = switch [cart.direction, nextSegment] {
			case [Left, CurveLeft] | [Right, CurveRight]: Down;
			case [Left, CurveRight] | [Right, CurveLeft]: Up;
			case [Down, CurveLeft] | [Up, CurveRight]: Left;
			case [Up, CurveLeft] | [Down, CurveRight]: Right;
			case [_, Intersection]:
				var i = directions.indexOf(cart.direction);
				i += switch (cart.turnsMade % 3) {
					case 0: -1; // turn left
					case 1: 0; // continue straight
					case 2: 1; // turn right
					case _:
						throw 'invalid';
				}
				cart.turnsMade++;
				directions[Util.mod(i, directions.length)];
			case _: cart.direction;
		}
	}

	public static function simulate(input:String, removeCrashes:Bool):String {
		var trackSystem = parse(input);
		var track = trackSystem.track;
		var carts = trackSystem.carts;
		while (true) {
			carts.sort(sortCarts);
			var occupied = new HashMap<Point, Cart>();
			var i = carts.length;
			while (i-- > 0) {
				var cart = carts[i];
				move(cart, track);
				if (occupied.exists(cart.position)) {
					if (removeCrashes) {
						carts.remove(cart);
						carts.remove(occupied.get(cart.position));
					} else {
						return cart.position.shortString();
					}
				}
				occupied.set(cart.position, cart);
			}
			if (removeCrashes && carts.length == 1) {
				return carts[0].position.shortString();
			}
		}
		return null;
	}
}

private enum Segment {
	Horizontal;
	Vertical;
	CurveLeft;
	CurveRight;
	Intersection;
}

private typedef Cart = {
	var position:Point;
	var direction:Point;
	var turnsMade:Int;
}

private typedef Track = HashMap<Point, Segment>;

private typedef TrackSystem = {
	final track:Track;
	final carts:Array<Cart>;
}
