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

	public static function findSleepiestMinuteOfSleepiestGuard(input:String) {
		var records = parseRecords(input);
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
		var sleepiest:SleepData = null;

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

					if (sleepiest == null || sleepiest.minutes < data.minutes) {
						sleepiest = data;
					}
			}
		}

		var sleepiestMinute = 0;
		var max = 0;
		for (i in 0...sleepiest.perMinute.length) {
			var current = sleepiest.perMinute[i];
			if (current > max) {
				max = current;
				sleepiestMinute = i;
			}
		}
		return sleepiestMinute * sleepiest.guard;
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
