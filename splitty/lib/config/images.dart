final List<Memoji> memojis = [
  Memoji(
    id: 1,
    imageURL:
        "https://dhruvilxcode.github.io/splitterapp/assets/memojis/memoji1.png",
  ),
  Memoji(
    id: 2,
    imageURL:
        "https://dhruvilxcode.github.io/splitterapp/assets/memojis/memoji2.png",
  ),
  Memoji(
    id: 3,
    imageURL:
        "https://dhruvilxcode.github.io/splitterapp/assets/memojis/memoji3.png",
  ),
  Memoji(
    id: 4,
    imageURL:
        "https://dhruvilxcode.github.io/splitterapp/assets/memojis/memoji4.png",
  ),
  Memoji(
    id: 5,
    imageURL:
        "https://dhruvilxcode.github.io/splitterapp/assets/memojis/memoji5.png",
  ),
  Memoji(
    id: 6,
    imageURL:
        "https://dhruvilxcode.github.io/splitterapp/assets/memojis/memoji6.png",
  ),
  Memoji(
    id: 7,
    imageURL:
        "https://dhruvilxcode.github.io/splitterapp/assets/memojis/memoji7.png",
  ),
  Memoji(
    id: 8,
    imageURL:
        "https://dhruvilxcode.github.io/splitterapp/assets/memojis/memoji8.png",
  ),
  Memoji(
    id: 9,
    imageURL:
        "https://dhruvilxcode.github.io/splitterapp/assets/memojis/memoji9.png",
  ),
  Memoji(
    id: 10,
    imageURL:
        "https://dhruvilxcode.github.io/splitterapp/assets/memojis/memoji10.png",
  ),
  Memoji(
    id: 11,
    imageURL:
        "https://dhruvilxcode.github.io/splitterapp/assets/memojis/memoji11.png",
  ),
  Memoji(
    id: 12,
    imageURL:
        "https://dhruvilxcode.github.io/splitterapp/assets/memojis/memoji12.png",
  ),
  Memoji(
    id: 13,
    imageURL:
        "https://dhruvilxcode.github.io/splitterapp/assets/memojis/memoji13.png",
  ),
  Memoji(
    id: 14,
    imageURL:
        "https://dhruvilxcode.github.io/splitterapp/assets/memojis/memoji14.png",
  ),
  Memoji(
    id: 15,
    imageURL:
        "https://dhruvilxcode.github.io/splitterapp/assets/memojis/memoji15.png",
  ),
  Memoji(
    id: 16,
    imageURL:
        "https://dhruvilxcode.github.io/splitterapp/assets/memojis/memoji16.png",
  ),
  Memoji(
    id: 17,
    imageURL:
        "https://dhruvilxcode.github.io/splitterapp/assets/memojis/memoji17.png",
  ),
  Memoji(
    id: 18,
    imageURL:
        "https://dhruvilxcode.github.io/splitterapp/assets/memojis/memoji18.png",
  ),
  Memoji(
    id: 19,
    imageURL:
        "https://dhruvilxcode.github.io/splitterapp/assets/memojis/memoji19.png",
  ),
];

class Memoji {
  int id;
  String imageURL;

  Memoji({required this.id, required this.imageURL});
}

// bill split item image
final List<BillItemImage> billItemImages = [
  BillItemImage(
    id: "other",
    name: "Other",
    imageURL:
        "https://dhruvilxcode.github.io/splitterapp/assets/icons/default.png",
  ),
  BillItemImage(
    id: "bill",
    name: "Bill",
    imageURL:
        "https://dhruvilxcode.github.io/splitterapp/assets/icons/bill.png",
  ),
  BillItemImage(
    id: "rent",
    name: "Rent",
    imageURL:
        "https://dhruvilxcode.github.io/splitterapp/assets/icons/rent.png",
  ),
  BillItemImage(
    id: "food",
    name: "Food",
    imageURL:
        "https://dhruvilxcode.github.io/splitterapp/assets/icons/food.png",
  ),
  BillItemImage(
    id: "travel",
    name: "Travel",
    imageURL:
        "https://dhruvilxcode.github.io/splitterapp/assets/icons/travel.png",
  ),
];

class BillItemImage {
  String id;
  String name;
  String imageURL;

  BillItemImage({
    required this.id,
    required this.name,
    required this.imageURL,
  });
}
