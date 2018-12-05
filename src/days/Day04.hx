package days;

class Day04 {
	static function parseRecords(input:String):Array<Record> {
		var regex = ~/\[(.*?)\] (.*)/;
		return input.split("\n").map(record -> {
			if (!regex.match(record)) {
				throw 'invalid record $record';
			}
			var date = Date.fromString(regex.matched(1) + ":00");
			var event = switch (regex.matched(2)) {
				case "falls asleep": FallsAsleep;
				case "wakes up": WakesUp;
				case beginsShift:
					var regex = ~/Guard #(\d+) begins shift/;
					regex.match(beginsShift);
					BeginsShift(regex.matchedInt(1));
			}
			return {
				date: date,
				event: event
			}
		});
	}

	static function processRecords(records:Array<Record>):Array<SleepData> {
		records.sort((r1, r2) -> {
			var t1 = r1.date.getTime();
			var t2 = r2.date.getTime();
			if (t1 > t2) {
				return 1;
			} else if (t2 > t1) {
				return -1;
			} else {
				return 0;
			}
		});

		var currentGuard = null;
		var sleepingSince = null;
		var sleepData = new Map<Int, SleepData>();

		for (record in records) {
			switch (record.event) {
				case BeginsShift(guardID):
					currentGuard = guardID;
					sleepingSince = null;
				case FallsAsleep:
					sleepingSince = record.date;
				case WakesUp:
					if (sleepingSince == null) {
						throw 'not sleeping';
					}
					var data = sleepData[currentGuard];
					if (data == null) {
						data = {
							guard: currentGuard,
							minutes: 0,
							perMinute: [for (_ in 0...60) 0]
						};
					}
					var start = sleepingSince.getMinutes();
					var end = record.date.getMinutes();
					for (i in start...end) {
						data.perMinute[i]++;
					}
					data.minutes += end - start;
					sleepData[currentGuard] = data;
			}
		}

		return sleepData.array();
	}

	static function findSleepiestMinute(sleepData:SleepData):{minute:Int, amount:Int} {
		var minute = 0;
		var maxAmount = 0;
		for (i in 0...sleepData.perMinute.length) {
			var amount = sleepData.perMinute[i];
			if (amount > maxAmount) {
				maxAmount = amount;
				minute = i;
			}
		}
		return {minute: minute, amount: maxAmount};
	}

	public static function findSleepiestMinuteOfSleepiestGuard(input:String):Int {
		var sleepData = processRecords(parseRecords(input));
		sleepData.sort((d1, d2) -> Reflect.compare(d2.minutes, d1.minutes));
		var sleepiestGuard = sleepData[0];
		return findSleepiestMinute(sleepiestGuard).minute * sleepiestGuard.guard;
	}

	public static function findSleepiestMinuteOverall(input:String):Int {
		var sleepData = processRecords(parseRecords(input));
		var sleepiestMinute = {minute: 0, amount: 0};
		var best = null;
		for (data in sleepData) {
			var current = findSleepiestMinute(data);
			if (current.amount > sleepiestMinute.amount) {
				sleepiestMinute = current;
				best = data;
			}
		}
		return sleepiestMinute.minute * best.guard;
	}
}

private enum Event {
	BeginsShift(guardID:Int);
	FallsAsleep;
	WakesUp;
}

private typedef Record = {
	final date:Date;
	final event:Event;
}

private typedef SleepData = {
	final guard:Int;
	var minutes:Int;
	final perMinute:Array<Int>;
}
