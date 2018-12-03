package days;

class Day03 {
	static function parseClaims(input:String):Array<Claim> {
		var regex = ~/#\d+ @ (\d+),(\d+): (\d+)x(\d+)/;
		return input.split("\n").map(claim -> {
			if (!regex.match(claim)) {
				throw 'invalid claim $claim';
			}
			return {
				x: regex.matchedInt(1),
				y: regex.matchedInt(2),
				width: regex.matchedInt(3),
				height: regex.matchedInt(4)
			};
		});
	}

	public static function countInchesWithOverlaps(input:String) {
		var grid = [for (_ in 0...1000)[for (_ in 0...1000) 0]];
		for (claim in parseClaims(input)) {
			for (x in 0...claim.width) {
				for (y in 0...claim.height) {
					grid[claim.x + x][claim.y + y]++;
				}
			}
		}
		return grid.flatten().count(i -> i >= 2);
	}
}

private typedef Claim = {
	final x:Int;
	final y:Int;
	final width:Int;
	final height:Int;
}
