package days;

import Util.Point;
import Util.Movement.*;
import haxe.ds.HashMap;

class Day15 {
	static function parse(input:String):Map {
		var rows = input.split("\n");
		var map = [for (y in 0...rows.length) [for (x in 0...rows[0].length) Empty]];
		for (y in 0...rows.length) {
			var row = rows[y];
			var cells = row.split("");
			for (x in 0...cells.length) {
				var cell = cells[x];
				map[y][x] = switch (cell) {
					case "#": Wall;
					case ".": Empty;
					case "E": Unit({faction: Elf, health: 200, position: new Point(x, y)});
					case "G": Unit({faction: Goblin, health: 200, position: new Point(x, y)});
					case _: throw 'unknown map tile $cell';
				}
			}
		}
		return map;
	}

	static function render(map:Map):String {
		return map.array().map(row -> {
			var healths = [];
			var tiles = row.map(tile -> switch (tile) {
				case Wall: "#";
				case Empty: ".";
				case Unit({faction: faction, health: health}):
					var symbol = if (faction == Elf) "E" else "G";
					healths.push('$symbol($health)');
					symbol;
			}).join("");
		 	tiles + "   " + healths.join(", ");
		}).join("\n");
	}

	static var directions = [Up, Left, Right, Down]; // reading order

	static function getEnemiesInRange(map:Map, unit:UnitData):Array<UnitData> {
		var opponents = [];
		for (direction in directions) {
			var target = unit.position.add(direction);
			switch (map[target]) {
				case Unit(enemy) if (enemy.faction != unit.faction):
					opponents.push(enemy);
				case _:
			}
		}
		return opponents;
	}

	static function findNextPosition(map:Map, unit:UnitData):Null<Point> {
		var closedSet = new HashMap<Point, Bool>();
		var openSet:Array<SearchNode> = [{
			score: 0,
			start: null,
			end: unit.position
		}];
		var solutions = new Array<SearchNode>();
		while (openSet.length > 0) {
			var node = openSet.shift();
			if (closedSet.exists(node.end)) {
				continue;
			}
			closedSet.set(node.end, true);
			
			if (solutions.length > 0 && solutions[0].score < node.score) {
				break;
			}
			for (direction in directions) {
				var position = node.end.add(direction);
				switch (map[position]) {
					case Empty:
						openSet.push({
							score: node.score + 1,
							start: if (node.start == null) position else node.start,
							end: position
						});
					case Unit({faction: f}) if (f != unit.faction):
						solutions.push(node);
					case _:
				}
			}
		}

		if (solutions.length == 0) {
			return null;
		}		
		return solutions[0].start;
	}
	
	static function attack(map:Map, unit:UnitData):Bool {
		var enemies = getEnemiesInRange(map, unit);
		if (enemies.length == 0) {
			return false;
		}

		var lowestHealth = 200;
		for (enemy in enemies) {
			if (enemy.health < lowestHealth) {
				lowestHealth = enemy.health;
			}
		}
		enemies = enemies.filter(unit -> unit.health == lowestHealth);
		enemies.sort((a, b) -> a.position.hashCode() - b.position.hashCode());

		var target = enemies[0];
		target.health -= 3;
		if (target.health <= 0) {
			target.health = 0;
			map[target.position] = Empty;
		}
		return true;
	}

	static function takeTurn(map:Map, unit:UnitData):Bool {
		if (attack(map, unit)) {
			return true;
		}
		var next = findNextPosition(map, unit);
		if (next == null) {
			return false;
		}
		map[unit.position] = Empty;
		map[next] = Unit(unit);
		unit.position = next;
		attack(map, unit);
		return true;
	}

	static function hasWon(faction:Faction, units:Array<UnitData>):Bool {
		return !units.exists(unit -> unit.faction != faction && unit.health > 0);
	}

	public static function simulateCombat(input:String, debug:Bool = false):Int {
		var map = parse(input);
		var rounds = 0;
		function renderMap() {
			if (debug) {
				Sys.println('After $rounds rounds:\n' + render(map) + "\n");
			}
		}
		renderMap();

		while (true) {
			var units = [];
			for (y in 0...map.height) {
				for (x in 0...map.width) {
					switch (map[y][x]) {
						case Unit(unit):
							units.push(unit);
						case _:
					}
				}
			}
			
			for (unit in units) {
				if (unit.health == 0) {
					continue;
				}
				if (!takeTurn(map, unit) && hasWon(unit.faction, units)) {
					renderMap();
					var totalHealth = units.map(unit -> unit.health).sum();
					var outcome = units.map(unit -> unit.health).sum() * rounds;
					if (debug) {
						Sys.println('Outcome: $rounds * $totalHealth = $outcome');
					}
					return outcome;
				}
			}

			rounds++;
			renderMap();
		}
		return 0;
	}
}

private typedef SearchNode = {
	var score:Int;
	var start:Point;
	var end:Point;
}

private abstract Map(Array<Array<Tile>>) from Array<Array<Tile>> {
	public var width(get, never):Int;
	function get_width() return this[0].length;

	public var height(get, never):Int;
	function get_height() return this.length;

	@:arrayAccess function getPoint(p:Point):Tile {
		return this[p.y][p.x];
	}

	@:arrayAccess function setPoint(p:Point, v:Tile):Tile {
		return this[p.y][p.x] = v;
	}

	@:arrayAccess function getIndex(i:Int):Array<Tile> {
		return this[i];
	}

	public function array():Array<Array<Tile>> {
		return this;
	}
}

private enum Tile {
	Wall;
	Empty;
	Unit(unit:UnitData);
}

private typedef UnitData = {
	final faction:Faction;
	var health:Int;
	var position:Point;
}

private enum Faction {
	Elf;
	Goblin;
}
