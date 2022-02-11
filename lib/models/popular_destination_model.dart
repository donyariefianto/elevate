class PopularDestinationModel {
  String name;
  String country;
  String image;

  PopularDestinationModel(this.name, this.country, this.image);
}

List<PopularDestinationModel> populars = popularsData
    .map((item) => PopularDestinationModel(item['name'].toString(),
        item['country'].toString(), item['image'].toString()))
    .toList();

var popularsData = [
  {
    "name": "Bali",
    "country": "Indonesia",
    "image": "assets/images/destination_bali.png"
  },
  {
    "name": "Paris",
    "country": "France",
    "image": "assets/images/destination_paris.png"
  },
  {
    "name": "Rome",
    "country": "Italy",
    "image": "assets/images/destination_rome.png"
  },
  {
    "name": "Bali",
    "country": "Indonesia",
    "image": "assets/images/destination_bali.png"
  },
  {
    "name": "Paris",
    "country": "France",
    "image": "assets/images/destination_paris.png"
  },
  {
    "name": "Rome",
    "country": "Italy",
    "image": "assets/images/destination_rome.png"
  },
];
