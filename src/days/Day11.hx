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

	static function findHighestPoweredSquare(gridSerial:Int, squareSizes:Array<Int>) {
		var gridSize = new Point(300, 300);
		var grid = [for (x in 0...gridSize.x + 1) [for (y in 0...gridSize.y + 1) {
			computePowerLevel(new Point(x, y), gridSerial);
		}]];
		var bestPower = 0;
		var bestSquare = null;
		var bestSize = 0;
		for (size in squareSizes) {
			for (x in 0...gridSize.x - size) {
				for (y in 0...gridSize.y - size) {
					var power = 0;
					for (sx in 0...size) {
						for (sy in 0...size) {
							power += grid[x + sx][y + sy];
						}
					}
					if (power > bestPower) {
						bestPower = power;
						bestSquare = new Point(x, y);
						bestSize = size;
					}
				}
			}
		}
		return {
			square: bestSquare.x + "," + bestSquare.y,
			size: bestSize	
		};
	}

	public static function findHighestPowered3x3(gridSerial:Int):String {
		var result = findHighestPoweredSquare(gridSerial, [3]);
		return result.square;
	}

	public static function findHighestPoweredAnySize(gridSerial:Int):String {
		var result = findHighestPoweredSquare(gridSerial, [for (i in 0...300) i + 1]);
		return result.square + "," + result.size;
	}
}
