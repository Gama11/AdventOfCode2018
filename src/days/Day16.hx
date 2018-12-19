package days;

class Day16 {
	static function parseInstruction(input:String):Instruction {
		var instruction = input.split(" ").map(Std.parseInt);
		return {
			opcode: instruction[0],
			args: {
				a: instruction[1],
				b: instruction[2],
				c: instruction[3]
			}
		};
	}

	static function parseSamples(input:String):Array<Sample> {
		var lines = input.split("\n");
		var samples = [];
		var regex = ~/(?:After|Before):\s*\[((?:\d,? ?)+)\]/;
		for (i in 0...Std.int(lines.length / 4)) {
			var before = lines[i * 4];
			var instruction = lines[i * 4 + 1];
			var after = lines[i * 4 + 2];
			function parseRegisters(s:String):Array<Int> {
				regex.match(s);
				return regex.matched(1).split(", ").map(Std.parseInt);
			}
			samples.push({
				before: parseRegisters(before),
				instruction: parseInstruction(instruction),
				after: parseRegisters(after)
			});
		}
		return samples;
	}

	public static function exceuteInstruction(registers:Array<Int>, op:Operation, args:Arguments):Array<Int> {
		var r = registers;
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

	static function equals(a:Array<Int>, b:Array<Int>) {
		return a.join(",") == b.join(",");
	}

	public static function countTripleMatchSamples(input:String):Int {
		var samples = parseSamples(input);
		var count = 0;
		for (sample in samples) {
			var matches = 0;
			for (op in Operation.getConstructors()) {
				var op = Operation.createByName(op);
				var result = exceuteInstruction(sample.before.copy(), op, sample.instruction.args);
				if (equals(result, sample.after)) {
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

	static function findOpcodeMapping(samples:Array<Sample>):Map<Int, Operation> {
		var mapping = new Map();
		var mappingsFound = 0;
		var candidates = new Array<Array<Operation>>();

		for (i in 0...16) {
			var relevantSamples = samples.filter(sample -> sample.instruction.opcode == i);
			var ops = Operation.getConstructors().map(op -> Operation.createByName(op));
			for (sample in relevantSamples) {
				ops = ops.filter(op -> {
					var result = exceuteInstruction(sample.before.copy(), op, sample.instruction.args);
					equals(result, sample.after);
				});
			}
			candidates[i] = ops;
		}

		while (mappingsFound < 16) {
			for (i in 0...candidates.length) {
				var ops = candidates[i];
				if (candidates[i].length == 1) {
					var found = ops[0];
					mapping[i] = found;
					mappingsFound++;
					for (ops in candidates) {
						ops.remove(found);
					}
				}
			}
		}

		return mapping;
	}

	public static function executeProgram(samples:String, program:String):Int {
		var mapping = findOpcodeMapping(parseSamples(samples));
		var program = program.split("\n").map(parseInstruction);
		var registers = [0, 0, 0, 0];
		for (instruction in program) {
			var op = mapping[instruction.opcode];
			exceuteInstruction(registers, op, instruction.args);
		}
		return registers[0];
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

typedef Arguments = {
	final a:Int;
	final b:Int;
	final c:Int;
}

enum Operation {
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
