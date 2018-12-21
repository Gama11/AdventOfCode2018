package days;

class Day21 {
	public static function executeProgram(input:String, register0:Int):Int {
		var program = Day19.parseProgram(input);
		var ip = program.instructionPointer;
		var instructions = program.instructions;
		var registers = [register0, 0, 0, 0, 0, 0];
		var instructionCount = 0;

		while (true) {
			var instruction = instructions[registers[ip]];
			instructionCount++;
			Day16.exceuteInstruction(registers, instruction.op, instruction.args);
			if (registers[ip] + 1 >= instructions.length) {
				break;
			}
			registers[ip]++;
		}

		return instructionCount;
	}
}
