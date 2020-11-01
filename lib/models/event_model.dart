class Event {
  String name;
  String description;
  DateTime eventDate;
  String image;
  String location;
  String organizer;
  num price;

  Event({this.eventDate, this.image, this.location, this.name, this.organizer, this.price, this.description});
}

final List<Event> upcomingEvents = [
  Event(
    name: "Shop A",
    eventDate: DateTime.now().add(const Duration(days: 24)),
    image: 'https://source.unsplash.com/800x600/?concert',
    description: "yash is an American rock band from New york city, Formed in 2009. The",
    location: "Fairview Gospel Church",
    organizer: "Westfield Centre",
    price: 30,
  ),
  Event(
    name: "Shop B",
    eventDate: DateTime.now().add(const Duration(days: 33)),
    image: 'https://source.unsplash.com/800x600/?band',
    description: "yash is an American rock band from New york city, Formed in 2009. The",
    location: "David Geffen Hall",
    organizer: "Westfield Centre",
    price: 30,
  ),
  Event(
    name: "Shop C",
    eventDate: DateTime.now().add(const Duration(days: 12)),
    image: 'https://source.unsplash.com/800x600/?music',
    description: "yash is an American rock band from New york city, Formed in 2009. The",
    location: "The Cutting room",
    organizer: "Westfield Centre",
    price: 30,
  ),
];

// final List<Event> nearbyEvents = [
//   Event(
//     name: "yash",
//     eventDate: DateTime.now().add(const Duration(days: 1)),
//     image: 'https://source.unsplash.com/600x800/?concert',
//     description: "yash is an American rock band from New york city, Formed in 2009. The",
//     location: "Fairview Gospel Church",
//     organizer: "Westfield Centre",
//     price: 30,
//   ),
//   Event(
//     name: "New Thread Quartet",
//     eventDate: DateTime.now().add(const Duration(days: 4)),
//     image: 'https://source.unsplash.com/600x800/?live',
//     description: "yash is an American rock band from New york city, Formed in 2009. The",
//     location: "David Geffen Hall",
//     organizer: "Westfield Centre",
//     price: 30,
//   ),
//   Event(
//     name: "Songwriters in Concert",
//     eventDate: DateTime.now().add(const Duration(days: 2)),
//     image: 'https://source.unsplash.com/600x800/?orchestra',
//     description: "yash is an American rock band from New york city, Formed in 2009. The",
//     location: "The Cutting room",
//     organizer: "Westfield Centre",
//     price: 30,
//   ),
//   Event(
//     name: "Rock Concert",
//     eventDate: DateTime.now().add(const Duration(days: 21)),
//     image: 'https://source.unsplash.com/600x800/?music',
//     description: "yash is an American rock band from New york city, Formed in 2009. The",
//     location: "The Cutting room",
//     organizer: "Westfield Centre",
//     price: 32,
//   ),
//   Event(
//     name: "Songwriters in Concert",
//     eventDate: DateTime.now().add(const Duration(days: 16)),
//     image: 'https://source.unsplash.com/600x800/?rock_music',
//     description: "yash is an American rock band from New york city, Formed in 2009. The",
//     location: "David Field",
//     organizer: "Westfield Centre",
//     price: 14,
//   ),
// ];
