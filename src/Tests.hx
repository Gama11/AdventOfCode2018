import days.*;
import utest.ITest;
import utest.Assert;
import utest.UTest;

class Tests implements ITest {
	static function main() {
		UTest.run([new Tests()]);
	}

	function new() {}

	function getData(name:String):String {
		return sys.io.File.getContent('data/$name.txt').replace("\r", "");
	}

	function testDay01() {
		Assert.equals(408, Day01.findFinalFrequency(getData("day01")));

		Assert.equals(0, Day01.findFirstDuplicateFrequency("+1, -1"));
		Assert.equals(10, Day01.findFirstDuplicateFrequency("+3, +3, +4, -2, -4"));
		Assert.equals(5, Day01.findFirstDuplicateFrequency("-6, +3, +8, +5, -6"));
		Assert.equals(14, Day01.findFirstDuplicateFrequency("+7, +7, -2, -7, -4"));
		Assert.equals(55250, Day01.findFirstDuplicateFrequency(getData("day01")));
	}

	function testDay02() {
		Assert.equals(12, Day02.calculateChecksum(getData("day02-0")));
		Assert.equals(3952, Day02.calculateChecksum(getData("day02-1")));
	}
}
