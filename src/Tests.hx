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

		Assert.equals("fgij", Day02.findCommonLetters(getData("day02-2")));
		Assert.equals("vtnikorkulbfejvyznqgdxpaw", Day02.findCommonLetters(getData("day02-1")));
	}

	@Ignored
	function testDay03() {
		Assert.equals(4, Day03.countInchesWithOverlaps(getData("day03-0")));
		Assert.equals(112418, Day03.countInchesWithOverlaps(getData("day03-1")));

		Assert.equals(3, Day03.findNonOverlappingClaim(getData("day03-0")));
		Assert.equals(560, Day03.findNonOverlappingClaim(getData("day03-1")));
	}

	function testDay04() {
		Assert.equals(240, Day04.findSleepiestMinuteOfSleepiestGuard(getData("day04-0")));
		Assert.equals(74743, Day04.findSleepiestMinuteOfSleepiestGuard(getData("day04-1")));

		Assert.equals(4455, Day04.findSleepiestMinuteOverall(getData("day04-0")));
		Assert.equals(132484, Day04.findSleepiestMinuteOverall(getData("day04-1")));
	}

	@Ignored
	function testDay05() {
		Assert.equals(10, Day05.reduce("dabAcCaCBAcCcaDA"));
		Assert.equals(10972, Day05.reduce(getData("day05")));

		Assert.equals(4, Day05.findBestReduction("dabAcCaCBAcCcaDA"));
		Assert.equals(5278, Day05.findBestReduction(getData("day05")));
	}

	function testDay06() {
		Assert.equals(17, Day06.findLargestFiniteArea(getData("day06-0")));
		Assert.equals(5035, Day06.findLargestFiniteArea(getData("day06-1")));

		Assert.equals(16, Day06.countPointsWithMaxDistance(getData("day06-0"), 32));
		Assert.equals(35294, Day06.countPointsWithMaxDistance(getData("day06-1"), 10000));
	}

	function testDay07() {
		Assert.equals("CABDFE", Day07.findOrder(getData("day07-0")));
		Assert.equals("BHRTWCYSELPUVZAOIJKGMFQDXN", Day07.findOrder(getData("day07-1")));

		Assert.equals(15, Day07.computeCompletionTime(getData("day07-0"), 2, 0));
		Assert.equals(959, Day07.computeCompletionTime(getData("day07-1"), 5, 60));
	}
}
