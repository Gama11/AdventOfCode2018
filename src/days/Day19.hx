package days;

import days.Day16.Arguments;
import days.Day16.Operation;

class Day19 {
	public static function parseProgram(input:String):Program {
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

	public static function executeProgram(input:String, ?registers:Array<Int>):Int {
		var program = parseProgram(input);
		var ip = program.instructionPointer;
		var instructions = program.instructions;
		if (registers == null) {
			registers = [0, 0, 0, 0, 0, 0];
		} 
		while (true) {
			var instruction = instructions[registers[ip]];
			Day16.exceuteInstruction(registers, instruction.op, instruction.args);
			if (registers[ip] + 1 >= instructions.length) {
				break;
			}
			registers[ip]++;
		}
		return registers[0];
	}

	public static function getSampleSequence(input:String):String {
		// register 1 contains the number the program is run on, ip = 1 skips the initialization of that register
		// (so we can sample outputs for other inputs)
		// entering the sequence on oeis.org reveals that the program computes the sum of the divisors
		return [for (i in 0...20) executeProgram(input, [0, i + 1, 0, 0, 1, 0])].join(",");
	}

	public static function sumOfDivisors(n:Int):Int {
		var sum = 0;
		for (i in 0...n + 1) {
			if (n % i == 0) {
				sum += i;
			}
		} 
		return sum;
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
