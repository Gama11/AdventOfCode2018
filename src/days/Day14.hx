package days;

class Day14 {
	public static function makeRecipes(amount:Int):String {
		var elf1 = 0;
		var elf2 = 1;
		var recipes = [3, 7];
		while (recipes.length < amount + 10) {
			var recipe1 = recipes[elf1];
			var recipe2 = recipes[elf2];
			var sum = recipe1 + recipe2;
			for (newRecipe in Std.string(sum).split("")) {
				recipes.push(Std.parseInt(newRecipe));
			}
			elf1 = (elf1 + recipe1 + 1) % recipes.length;
			elf2 = (elf2 + recipe2 + 1) % recipes.length;
		}
		return [for (i in amount...amount + 10) recipes[i]].join("");
	}
}
