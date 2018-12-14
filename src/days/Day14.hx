package days;

class Day14 {
	public static function getSequenceAfter(n:Int):String {
		var factory = new RecipeFactory();
		while (factory.recipes.length < n + 10) {
			factory.makeRecipes();
		}
		return [for (i in n...n + 10) factory.recipes[i]].join("");
	}

	public static function countRecipesLeftOf(searchSequence:String):Int {
		var sequence = "";
		var factory = new RecipeFactory();
		var count = factory.recipes.length;
		while (true) {
			for (newRecipe in factory.makeRecipes()) {
				count++;				
				sequence += newRecipe;
				if (sequence.length > searchSequence.length) {
					sequence = sequence.substr(1);
				}
				if (sequence == searchSequence) {
					return count - searchSequence.length;
				}
			}
		}
		return -1;
	}
}

class RecipeFactory {
	var elf1:Int = 0;
	var elf2:Int = 1;
	public var recipes = [3, 7];

	public function new() {}

	public function makeRecipes():Array<Int> {
		var recipe1 = recipes[elf1];
		var recipe2 = recipes[elf2];
		var sum = recipe1 + recipe2;
		var newRecipes = Std.string(sum).split("").map(s -> (Std.parseInt(s) : Int));
		for (newRecipe in newRecipes) {
			recipes.push(newRecipe);
		}
		elf1 = (elf1 + recipe1 + 1) % recipes.length;
		elf2 = (elf2 + recipe2 + 1) % recipes.length;
		return newRecipes;
	}
}
