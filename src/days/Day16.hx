package days;

class Day16 {
	static function parseSamples(input:String):Array<Sample> {
		var lines = input.split("\n");
		var samples = [];
		var regex = ~/(?:After|Before):\s*\[((?:\d,? ?)+)\]/;
		for (i in 0...Std.int(lines.length / 4)) {
			var before = lines[i * 4];
			var instruction = lines[i * 4 + 1].split(" ").map(Std.parseInt);
			var after = lines[i * 4 + 2];
			function parseRegisters(s:String):Array<Int> {
				regex.match(s);
				return regex.matched(1).split(", ").map(Std.parseInt);
			}
			samples.push({
				before: parseRegisters(before),
				instruction: {
					opcode: instruction[0],
					args: {
						a: instruction[1],
						b: instruction[2],
						c: instruction[3]
					}
				},
				after: parseRegisters(after)
			});
		}
		return samples;
	}

	static function exceuteInstruction(registers:Array<Int>, op:Operation, args:Arguments):Array<Int> {
		var r = registers.copy();
		var a = args.a;
		var b = args.b;
		var c = args.c;
		r[c] = switch (op) {
			case Addr: r[a] + r[b];
			case Addi: r[a] + b;
			case Mulr: r[a] * r[b];
			case Muli: r[a] * b;
			case Banr: r[a] & r[b];
			case Bani: r[a] & b;
			case Borr: r[a] | r[b];
			case Bori: r[a] | b;
			case Setr: r[a];
			case Seti: a;
			case Gtir: if (a > r[b]) 1 else 0;
			case Gtri: if (r[a] > b) 1 else 0;
			case Gtrr: if (r[a] > r[b]) 1 else 0;
			case Eqir: if (a == r[b]) 1 else 0;
			case Eqri: if (r[a] == b) 1 else 0;
			case Eqrr: if (r[a] == r[b]) 1 else 0;
		}
		return r;
	}

	public static function countTripleMatchSamples(input:String):Int {
		var samples = parseSamples(input);
		var count = 0;
		for (sample in samples) {
			var matches = 0;
			for (op in Operation.getConstructors()) {
				var result = exceuteInstruction(sample.before,
					Operation.createByName(op), sample.instruction.args);
				if (result.join(",") == sample.after.join(",")) {
					matches++;
					if (matches >= 3) {
						count++;
						break;
					}
				}
			}
		}
		return count;
	}
}

private typedef Sample = {
	final before:Array<Int>;
	final instruction:Instruction;
	final after:Array<Int>;
}

private typedef Instruction = {
	final opcode:Int;
	final args:Arguments;
}

private typedef Arguments = {
	final a:Int;
	final b:Int;
	final c:Int;
}

private enum Operation {
	Addr;
	Addi;
	Mulr;
	Muli;
	Banr;
	Bani;
	Borr;
	Bori;
	Setr;
	Seti;
	Gtir;
	Gtri;
	Gtrr;
	Eqir;
	Eqri;
	Eqrr;
}
