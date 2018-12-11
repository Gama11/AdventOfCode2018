package days;

import Util.Point;

class Day11 {
	public static function computePowerLevel(p:Point, gridSerial:Int):Int {
		var rackID = p.x + 10;
		var powerLevel = rackID * p.y;
		powerLevel += gridSerial;
		powerLevel *= rackID;
		return getHundredsDigit(powerLevel) - 5;
	}

	static function getHundredsDigit(n:Int):Int {
		var s = Std.string(n);
		var digit = s.charAt(s.length - 3);
		return if (digit == "") 0 else Std.parseInt(digit);
	}

	public static function findHighestPoweredSquare(gridSerial:Int):Point {
		var gridSize = new Point(300, 300);
		var square = new Point(3, 3);
		var grid = [for (x in 0...gridSize.x + 1) [for (y in 0...gridSize.y + 1) {
			computePowerLevel(new Point(x, y), gridSerial);
		}]];
		var bestPower = 0;
		var bestSquare = null;
		for (x in 0...gridSize.x - square.x) {
			for (y in 0...gridSize.y - square.y) {
				var power = 0;
				for (sx in 0...square.x) {
					for (sy in 0...square.y) {
						power += grid[x + sx][y + sy];
					}
				}
				if (power > bestPower) {
					bestPower = power;
					bestSquare = new Point(x, y);
				}
			}
		}
		return bestSquare;
	}
}
