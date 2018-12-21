package days;

import polygonal.ds.IntHashSet;

class Day21 {
	public static function findExitConditions(input:String) {
		var program = Day19.parseProgram(input);
		var ip = program.instructionPointer;
		var instructions = program.instructions;
		var registers = [0, 0, 0, 0, 0, 0];

		var exitConditions = new IntHashSet(128);
		var min:Int = null;
		var max:Int = null;

		while (true) {
			// at instruction #28, the program exits if the last register equals the first
			if (registers[ip] == 28) {
				var exitCondition = registers[5];
				if (min == null) {
					min = exitCondition;
				}
				if (exitConditions.has(exitCondition)) {
					// starting to loop
					break;
				}
				max = exitCondition;
				exitConditions.set(exitCondition);
			}

			var instruction = instructions[registers[ip]];
			Day16.exceuteInstruction(registers, instruction.op, instruction.args);
			if (registers[ip] + 1 >= instructions.length) {
				break;
			}
			registers[ip]++;
		}

		return {
			min: min,
			max: max
		};
	}
}
