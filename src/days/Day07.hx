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
		var steps = "";
		var available = graph.filter(node -> node.dependencies.length == 0).map(n -> n.name);
		while (available.length > 0) {
			available.sort(Reflect.compare);
			var name = available.shift();
			steps += name;
			for (dependent in graph[name].dependents) {
				if (graph[dependent].dependencies.exists(dep -> steps.indexOf(dep) == -1)) {
					continue;
				}
				if (available.indexOf(dependent) == -1) {
					available.push(dependent);
				}
			}
		}
		return steps;
	}
}

private typedef Graph = Map<String, Node>;

private typedef Node = {
	final name:String;
	final dependencies:Array<String>;
	final dependents:Array<String>;
}
