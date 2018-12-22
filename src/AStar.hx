import haxe.ds.HashMap;
import polygonal.ds.PriorityQueue;
import polygonal.ds.Prioritizable;

class AStar {
	public static function search<T:State>(start:T, goal:T, score:T->Int, getMoves:T->Array<Move<T>>):Null<Int> {
		var scores = new HashMap<T, Score>();
		scores.set(start, {
			g: 0,
			f: score(start)
		});
		var closedSet = new HashMap<T, Bool>();
		var openSet = new PriorityQueue(1, true, [new PrioritizedState(start, score(start))]);

		while (openSet.size > 0) {
			var current = openSet.dequeue().state;
			closedSet.set(current, true);
			
			var currentScore = scores.get(current).g;
			if (current.hashCode() == goal.hashCode()) {
				return currentScore;
			}

			for (move in getMoves(current)) {
				if (closedSet.exists(move.state)) {
					continue;
				}
				var node = scores.get(move.state);
				var scoreAfterMove = currentScore + move.cost;
				if (node == null || node.g > scoreAfterMove) {
					var score = {
						g: scoreAfterMove,
						f: scoreAfterMove + score(move.state)
					};
					scores.set(move.state, score);
					openSet.enqueue(new PrioritizedState(move.state, score.f));
				}
			}

		}

		return null;
	}
}

typedef Move<T> = {
	var cost:Int;
	var state:T;
}

typedef State = {
	function hashCode():Int;
}

private typedef Score = {
	var g:Int;
	var f:Int;
}

private class PrioritizedState<T:State> implements Prioritizable {
	public final state:T;
	public var priority(default, null):Float = 0;
	public var position(default, null):Int;

	public function new(state:T, priority:Float) {
		this.state = state;
		this.priority = priority;
	}
}
