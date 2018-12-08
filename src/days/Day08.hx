package days;

class Day08 {
	static function parseTree(input:String):Node {
		var data = input.split(" ").map(Std.parseInt);
		function parse(i:Int):{length:Int, node:Node} {
			var startIndex = i;
			var childCount = data[i++];
			var metaCount = data[i++];
			var children = [];
			for (_ in 0...childCount) {
				var child = parse(i);
				i += child.length;
				children.push(child.node);
			}
			var endIndex = i + metaCount;
			return {
				length: endIndex - startIndex,
				node: {
					children: children,
					metadata: data.slice(i, endIndex)
				}
			}
		}
		return parse(0).node;
	}

	public static function checksum(input:String):Int {
		var tree = parseTree(input);
		function _checksum(node:Node):Int {
			return node.metadata.sum() + node.children.map(_checksum).sum();
		}
		return _checksum(tree);
	}
}

private typedef Node = {
	final children:Array<Node>;
	final metadata:Array<Int>;
}
