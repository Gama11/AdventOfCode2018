package days;

class Day07 {
	static function parseGraph(input:String):Graph {
		var graph = new Graph();
		function add(step:String) {
			if (graph[step] == null) {
				graph.set(step, {
					name: step,
					dependencies: [],
					dependents: []
				});
			}
		}
		var regex = ~/Step ([A-Z]) must be finished before step ([A-Z]) can begin\./;
		input.split("\n").map(line -> {
			if (!regex.match(line)) {
				throw 'invalid instruction $line';
			}
			var step = regex.matched(2);
			var dependency = regex.matched(1);
			add(step);
			add(dependency);
			graph[step].dependencies.push(dependency);
			graph[dependency].dependents.push(step);
		});
		return graph;
	}

	public static function findOrder(input:String):String {
		var graph = parseGraph(input);
		var done = "";
		var queued = graph.filter(node -> node.dependencies.length == 0).map(n -> n.name);

		while (queued.length > 0) {
			queued.sort(Reflect.compare);
			var name = queued.shift();
			done += name;
			for (dependent in graph[name].dependents) {
				if (graph[dependent].dependencies.exists(dep -> done.indexOf(dep) == -1)) {
					continue;
				}
				if (queued.indexOf(dependent) == -1) {
					queued.push(dependent);
				}
			}
		}
		
		return done;
	}

	public static function computeCompletionTime(input:String, workers:Int, stepDuration:Int):Int {
		var graph = parseGraph(input);
		var done = "";
		var queued = graph.filter(node -> node.dependencies.length == 0).map(n -> n.name);
		var inProgress = [];
		var elapsedTime = 0;

		while (queued.length > 0 || inProgress.length > 0) {
			queued.sort(Reflect.compare);
			while (inProgress.length < workers && queued.length > 0) {
				var name = queued.shift();
				inProgress.push({
					name: name,
					timeLeft: stepDuration + name.charCodeAt(0) - 64,
				});
			}

			inProgress.sort((n1, n2) -> n1.timeLeft - n2.timeLeft);
			var completed = inProgress.shift();
			done += completed.name;
			for (left in inProgress) {
				left.timeLeft -= completed.timeLeft;
			}
			elapsedTime += completed.timeLeft;

			for (dependent in graph[completed.name].dependents) {
				if (graph[dependent].dependencies.exists(dep -> done.indexOf(dep) == -1)) {
					continue;
				}
				if (queued.indexOf(dependent) == -1) {
					queued.push(dependent);
				}
			}
		}
	
		return elapsedTime;
	}
}

private typedef Graph = Map<String, Node>;

private typedef Node = {
	final name:String;
	final dependencies:Array<String>;
	final dependents:Array<String>;
}
