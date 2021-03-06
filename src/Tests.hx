import days.*;
import Util.Point;
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

	#if !eval
	function testDay04() {
		Assert.equals(240, Day04.findSleepiestMinuteOfSleepiestGuard(getData("day04-0")));
		Assert.equals(74743, Day04.findSleepiestMinuteOfSleepiestGuard(getData("day04-1")));

		Assert.equals(4455, Day04.findSleepiestMinuteOverall(getData("day04-0")));
		Assert.equals(132484, Day04.findSleepiestMinuteOverall(getData("day04-1")));
	}
	#end

	@Ignored
	function testDay05() {
		Assert.equals(10, Day05.reduce("dabAcCaCBAcCcaDA"));
		Assert.equals(10972, Day05.reduce(getData("day05")));

		Assert.equals(4, Day05.findBestReduction("dabAcCaCBAcCcaDA"));
		Assert.equals(5278, Day05.findBestReduction(getData("day05")));
	}

	@Ignored
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

	function testDay08() {
		var example = Day08.parseTree("2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2");
		var data = Day08.parseTree(getData("day08"));
	
		Assert.equals(138, Day08.checksum(example));
		Assert.equals(45210, Day08.checksum(data));

		Assert.equals(66, Day08.value(example));
		Assert.equals(22793, Day08.value(data));
	}

	@Ignored
	function testDay09() {
		Assert.equals(32, Day09.findHighScore(9, 25));
		Assert.equals(8317, Day09.findHighScore(10, 1618));
		Assert.equals(146373, Day09.findHighScore(13, 7999));
		Assert.equals(2764, Day09.findHighScore(17, 1104));
		Assert.equals(54718, Day09.findHighScore(21, 6111));
		Assert.equals(37305, Day09.findHighScore(30, 5807));
		Assert.equals(399645, Day09.findHighScore(429, 70901));

		Assert.equals(3352507536, Day09.findHighScore(429, 70901 * 100));
	}

	@Ignored
	function testDay10() {
		Assert.equals(3, Day10.getMessage(getData("day10-0")));
		Assert.equals(10007, Day10.getMessage(getData("day10-1")));
	}

	@Ignored
	function testDay11() {
		Assert.equals(4, Day11.computePowerLevel(new Point(3, 5), 8));
		Assert.equals(-5, Day11.computePowerLevel(new Point(122, 79), 57));
		Assert.equals(0, Day11.computePowerLevel(new Point(217, 196), 39));
		Assert.equals(4, Day11.computePowerLevel(new Point(101, 153), 71));

		Assert.equals("33,45", Day11.findHighestPowered3x3(18));
		Assert.equals("21,61", Day11.findHighestPowered3x3(42));
		Assert.equals("34,13", Day11.findHighestPowered3x3(1723));

		Assert.equals("280,218,11", Day11.findHighestPoweredAnySize(1723));
	}

	function testDay12() {
		Assert.equals(325, Day12.simulate(getData("day12-0"), 20));
		Assert.equals(2736, Day12.simulate(getData("day12-1"), 20));
		
		Assert.equals(3150000000905, Day12.simulate(getData("day12-1"), 50000000000));
	}

	function testDay13() {
		Assert.equals("0,3", Day13.simulate(getData("day13-0"), false));
		Assert.equals("7,3", Day13.simulate(getData("day13-1"), false));
		Assert.equals("119,41", Day13.simulate(getData("day13-2"), false));

		Assert.equals("6,4", Day13.simulate(getData("day13-3"), true));
		Assert.equals("45,136", Day13.simulate(getData("day13-2"), true));
	}

	@Ignored
	function testDay14() {
		Assert.equals("5158916779", Day14.getSequenceAfter(9));
		Assert.equals("0124515891", Day14.getSequenceAfter(5));
		Assert.equals("9251071085", Day14.getSequenceAfter(18));
		Assert.equals("5941429882", Day14.getSequenceAfter(2018));
		Assert.equals("1631191756", Day14.getSequenceAfter(409551));

		Assert.equals(9, Day14.countRecipesLeftOf("51589"));
		Assert.equals(5, Day14.countRecipesLeftOf("01245"));
		Assert.equals(18, Day14.countRecipesLeftOf("92510"));
		Assert.equals(2018, Day14.countRecipesLeftOf("59414"));
		Assert.equals(20219475, Day14.countRecipesLeftOf("409551"));
	}

	@Ignored
	function testDay15() {
		Assert.equals(27730, Day15.simulateCombat(getData("day15-0")));
		Assert.equals(36334, Day15.simulateCombat(getData("day15-1")));
		Assert.equals(39514, Day15.simulateCombat(getData("day15-2")));
		Assert.equals(27755, Day15.simulateCombat(getData("day15-3")));
		Assert.equals(28944, Day15.simulateCombat(getData("day15-4")));
		Assert.equals(18740, Day15.simulateCombat(getData("day15-5")));
		Assert.equals(13400, Day15.simulateCombat(getData("day15-6")));
		Assert.equals(13987, Day15.simulateCombat(getData("day15-7")));
		Assert.equals(261855, Day15.simulateCombat(getData("day15-8")));

		Assert.equals(4988, Day15.findMinAttackPower(getData("day15-0")));
		Assert.equals(31284, Day15.findMinAttackPower(getData("day15-2")));
		Assert.equals(3478, Day15.findMinAttackPower(getData("day15-3")));
		Assert.equals(6474, Day15.findMinAttackPower(getData("day15-4")));
		Assert.equals(1140, Day15.findMinAttackPower(getData("day15-5")));
		Assert.equals(59568, Day15.findMinAttackPower(getData("day15-8")));
	}

	function testDay16() {
		Assert.equals(636, Day16.countTripleMatchSamples(getData("day16-1")));
		Assert.equals(674, Day16.executeProgram(getData("day16-1"), getData("day16-2")));
	}

	@Ignored
	function testDay17() {
		var result0 = Day17.countWaterTiles(getData("day17-0"));
		Assert.equals(57, result0.total);
		Assert.equals(29, result0.resting);

		var result1 = Day17.countWaterTiles(getData("day17-1"));
		Assert.equals(31471, result1.total);
		Assert.equals(24169, result1.resting);
	}

	@Ignored
	function testDay18() {
		Assert.equals(1147, Day18.getResourceValue(getData("day18-0"), 10));
		Assert.equals(507755, Day18.getResourceValue(getData("day18-1"), 10));

		Assert.equals(235080, Day18.getResourceValue(getData("day18-1"), 1000000000));
	}

	@Ignored
	function testDay19() {
		Assert.equals(6, Day19.executeProgram(getData("day19-0")));
		Assert.equals(1848, Day19.executeProgram(getData("day19-1")));

		Assert.equals(22157688, Day19.sumOfDivisors(10551260));
	}

	#if !eval
	function testDay20() {
		var example1 = "^WNE$";
		var example2 = "^ENWWW(NEEE|SSE(EE|N))$";
		var example3 = "^ENNWSWW(NEWS|)SSSEEN(WNSE|)EE(SWEN|)NNN$";
		var example4 = "^ESSWWN(E|NNENN(EESS(WNSE|)SSS|WWWSSSSE(SW|NNNE)))$";
		var example5 = "^WSSEESWWWNW(S|NENNEEEENN(ESSSSW(NWSW|SSEN)|WSWWN(E|WWS(E|SS))))$";

		Assert.equals(3, Day20.analyzeFacility(example1).maxDistance);
		Assert.equals(10, Day20.analyzeFacility(example2).maxDistance);
		Assert.equals(18, Day20.analyzeFacility(example3).maxDistance);
		Assert.equals(23, Day20.analyzeFacility(example4).maxDistance);
		Assert.equals(31, Day20.analyzeFacility(example5).maxDistance);

		var facility = Day20.analyzeFacility(getData("day20"));
		Assert.equals(4360, facility.maxDistance);
		Assert.equals(8509, facility.min1000Count);
	}

	@Ignored
	function testDay21() {
		var exitConditions = Day21.findExitConditions(getData("day21"));
		Assert.equals(1024276, exitConditions.min);
		Assert.equals(5876609, exitConditions.max);
	}

	@Ignored
	function testDay22() {
		Assert.equals(114, Day22.determineRiskLevel(510, new Point(10, 10)));
		Assert.equals(6318, Day22.determineRiskLevel(11820, new Point(7, 782)));
		
		Assert.equals(45, Day22.findFastestPath(510, new Point(10, 10)));
		Assert.equals(1075, Day22.findFastestPath(11820, new Point(7, 782)));
	}

	@Ignored
	function testDay23() {
		Assert.equals(7, Day23.countBotsInBiggestRange(getData("day23-0")));
		Assert.equals(417, Day23.countBotsInBiggestRange(getData("day23-1")));

		Assert.equals(36, Day23.findIdealPosition(getData("day23-2")));
		Assert.equals(112997634, Day23.findIdealPosition(getData("day23-1")));
	}
	#end

	@Ignored
	function testDay24() {
		Assert.equals(5216, Day24.simulateCombat(getData("day24-0")).unitsLeft);
		Assert.equals(24318, Day24.simulateCombat(getData("day24-1")).unitsLeft);

		Assert.equals(51, Day24.findMinimalBoost(getData("day24-0")));
		Assert.equals(1083, Day24.findMinimalBoost(getData("day24-1")));
	}

	function testDay25() {
		Assert.equals(2, Day25.countConstellations(getData("day25-0")));
		Assert.equals(4, Day25.countConstellations(getData("day25-1")));
		Assert.equals(3, Day25.countConstellations(getData("day25-2")));
		Assert.equals(8, Day25.countConstellations(getData("day25-3")));
		Assert.equals(425, Day25.countConstellations(getData("day25-4")));
	}
}
