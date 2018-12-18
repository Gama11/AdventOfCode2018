package days;

class Day18 {
	static function step(area:Area):Area {
		var newArea = [for (_ in 0...area.length) []];
		for (y in 0...area.length) {
			var row = area[y];
			for (x in 0...row.length) {
				function get(x:Int, y:Int) {
					return if (area[y] == null) null else area[y][x];
				}
				var surrounding = [
					get(x - 1, y - 1),
					get(x + 0, y - 1),
					get(x + 1, y - 1),
					get(x + 1, y + 0),
					get(x + 1, y + 1),
					get(x + 0, y + 1),
					get(x - 1, y + 1),
					get(x - 1, y + 0)
				];
				inline function count(tile:Tile):Int {
					return surrounding.filter(t -> t == tile).length;
				}
				newArea[y][x] = switch (area[y][x]) {
					case OpenGround if (count(Trees) >= 3):
						Trees;
					case Trees if (count(Lumberyard) >= 3):
						Lumberyard;
					case Lumberyard if (count(Lumberyard) == 0 || count(Trees) == 0):
						OpenGround;
					case _:
						area[y][x];
				}
			}
		}
		return newArea;
	}

	static function render(area:Area):String {
		return area.map(row -> row.join("")).join("\n");
	}

	public static function getResourceValue(input:String, minutes:Int):Int {
		var area = input.split("\n").map(row -> row.split(""));
		var history = [render(area)];
		var cycle:Null<Int> = null;
		while (minutes-- > 0) {
			area = step(area);
			var areaString = render(area);
			for (i in 0...history.length) {
				if (areaString == history[i]) {
					cycle = history.length - i;
				}
			}
			if (cycle != null) {
				break;
			}
			history.push(areaString);
		}

		if (cycle != null) {
			minutes -= Math.floor(minutes / cycle) * cycle;
			while (minutes-- > 0) {
				area = step(area);
			}
		}

		var trees = area.flatten().filter(t -> t == Trees).length;
		var lumberyards = area.flatten().filter(t -> t == Lumberyard).length;
		return trees * lumberyards;
	}
}

private typedef Area = Array<Array<Tile>>;

private enum abstract Tile(String) from String to String {
	var OpenGround = ".";
	var Trees = "|";
	var Lumberyard = "#";
}
