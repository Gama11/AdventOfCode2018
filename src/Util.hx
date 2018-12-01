class Util {
	public static function mod(a:Int, b:Int) {
		var r = a % b;
		return r < 0 ? r + b : r;
	}
}

class ERegUtil {
	public static function matchedInt(reg:EReg, n:Int):Null<Int> {
		return Std.parseInt(reg.matched(n));
	}
}

class Point {
    public final x:Int;
    public final y:Int;

    public inline function new(x, y) {
        this.x = x;
        this.y = y;
    }

    public function hashCode():Int {
        return x + 10000 * y;
    }

    public inline function add(point:Point):Point {
        return new Point(x + point.x, y + point.y);
    }

	public function distanceTo(point:Point):Int {
        return Std.int(Math.abs(x - point.x) + Math.abs(y - point.y));
    }

    public inline function equals(point:Point):Bool {
        return x == point.x && y == point.y;
    }

    function toString() {
        return '($x, $y)';
    }
}

class Movement {
    public static final Left = new Point(-1, 0);
    public static final Up = new Point(0, -1);
    public static final Down = new Point(0, 1);
    public static final Right = new Point(1, 0);
}
