package days;

class Day18 {
	public static function getResourceValue(input:String):Int {
		var area = input.split("\n").map(row -> row.split(""));
		for (_ in 0...10) {
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
			area = newArea;
		}
		var trees = area.flatten().filter(t -> t == Trees).length;
		var lumberyards = area.flatten().filter(t -> t == Lumberyard).length;
		return trees * lumberyards;
	}
}

private enum abstract Tile(String) from String to String {
	var OpenGround = ".";
	var Trees = "|";
	var Lumberyard = "#";
}
