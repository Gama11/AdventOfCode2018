package days;

import days.Day16.Arguments;
import days.Day16.Operation;

class Day19 {
	static function parseProgram(input:String):Program {
		var lines = input.split("\n");
		var instructionPointer = Std.parseInt(lines.shift().substr("#ip ".length));
		var instructions = lines.map(line -> {
			var split = line.split(" ");
			var op = split[0].charAt(0).toUpperCase() + split[0].substr(1);
			return {
				op: Operation.createByName(op),
				args: {
					a: Std.parseInt(split[1]),
					b: Std.parseInt(split[2]),
					c: Std.parseInt(split[3])
				}
			};
		});
		return {
			instructionPointer: instructionPointer,
			instructions: instructions
		};
	}

	public static function executeProgram(input:String):Int {
		var program = parseProgram(input);
		var ip = program.instructionPointer;
		var instructions = program.instructions;
		var registers = [0, 0, 0, 0, 0, 0];
		while (true) {
			var instruction = instructions[registers[ip]];
			registers = Day16.exceuteInstruction(registers, instruction.op, instruction.args);
			if (registers[ip] + 1 >= instructions.length) {
				break;
			}
			registers[ip]++;
		}
		return registers[0];
	}
}

private typedef Instruction = {
	final op:Operation;
	final args:Arguments;
}

private typedef Program = {
	final instructionPointer:Int;
	final instructions:Array<Instruction>;
}
