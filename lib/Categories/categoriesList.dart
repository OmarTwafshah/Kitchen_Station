List<Categories> categoriesList = [
  Categories(title: "Burger", imgPath: "image/categories/burger.png"),
  Categories(title: "Fish", imgPath: "image/categories/fish.png"),
  Categories(title: "Pizza", imgPath: "image/categories/pizza.png"),
  Categories(title: "Drink", imgPath: "image/categories/drink.png"),
  Categories(title: "Chicken", imgPath: "image/categories/chicken.png"),
  Categories(title: "Donut", imgPath: "image/categories/donut.png"),
];

class Categories {
  late String title;
  late String imgPath;

  Categories({required this.title, required this.imgPath});
}
