package days;

class Day08 {
	public static function parseTree(input:String):Node {
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

	public static function checksum(node:Node):Int {
		return node.metadata.sum() + node.children.map(checksum).sum();
	}

	public static function value(node:Node):Int {
		if (node.children.length == 0) {
			return node.metadata.sum();
		}
		return [for (meta in node.metadata) {
			var child = node.children[meta - 1];
			if (child == null) 0 else value(child);
		}].sum();
	}
}

private typedef Node = {
	final children:Array<Node>;
	final metadata:Array<Int>;
}
