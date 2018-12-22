package days;

import AStar.Move;
import Util.Point;
import Util.Movement.*;
import haxe.ds.HashMap;

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

	public static function findFastestPath(depth:Int, target:Point):Int {
		var erosionLevels = new HashMap<Point, Int>();
		var map = new HashMap<Point, RegionType>();
		function getRegion(pos:Point):RegionType {
			var erosionLevel = getErosionLevel(pos, depth, target, erosionLevels);
			var type = switch (erosionLevel % 3) {
				case 0: Rocky;
				case 1: Wet;
				case 2: Narrow;
				case _: throw pos;
			}
			map.set(pos, type);
			return type;
		}

		function isEquipmentValid(tool:Tool, pos:Point):Bool {
			return tool != switch (getRegion(pos)) {
				case Rocky: None;
				case Wet: Torch;
				case Narrow: ClimbingGear;
			};
		}

		var start = new CaveState(new Point(0, 0), Torch);
		var goal = new CaveState(target, Torch);
		
		function score(state:CaveState):Int {
			return state.pos.distanceTo(goal.pos);
		}
		
		var directions = [Left, Right, Up, Down];
		var tools = [Torch, ClimbingGear, None];
		function getMoves(state:CaveState):Array<Move<CaveState>> {
			var moves = [];
			for (direction in directions) {
				var pos = state.pos.add(direction);
				if (pos.x < 0 || pos.y < 0) {
					continue;
				}
				if (isEquipmentValid(state.tool, pos)) {
					moves.push({
						cost: 1,
						state: new CaveState(pos, state.tool)
					});
				}
			}

			for (tool in tools) {
				if (tool != state.tool && isEquipmentValid(tool, state.pos)) {
					moves.push({
						cost: 7,
						state: new CaveState(state.pos, tool)
					});
				}
			}
			
			return moves;
		}

		return AStar.search(start, goal, score, getMoves);
	}
}

private enum RegionType {
	Rocky;
	Wet;
	Narrow;
}

private enum Tool {
	Torch;
	ClimbingGear;
	None;
}

private class CaveState {
	public final pos:Point;
	public final tool:Tool;

	public function new(pos:Point, tool:Tool) {
		this.pos = pos;
		this.tool = tool;
	}

	public function hashCode():Int {
		return pos.hashCode() + 10000000 * tool.getIndex();
	}

	public function toString():String {
		return '$pos,$tool';
	}
}
