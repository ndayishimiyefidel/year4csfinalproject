class UserModel {
  final id;
  final String name;
  final String imageUrl;
  final bool isOnline;

  UserModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.isOnline,
  });
}

// YOU - current user
final UserModel currentUser = UserModel(
  id: 0,
  name: 'Nick Fury',
  imageUrl: 'assets/images/nick-fury.jpg',
  isOnline: true,
);

// USERS
final UserModel ironMan = UserModel(
  id: 1,
  name: 'Iron Man',
  imageUrl: 'assets/images/ironman.jpeg',
  isOnline: true,
);
final UserModel captainAmerica = UserModel(
  id: 2,
  name: 'Captain America',
  imageUrl: 'assets/images/captain-america.jpg',
  isOnline: true,
);
final UserModel hulk = UserModel(
  id: 3,
  name: 'Hulk',
  imageUrl: 'assets/images/hulk.jpg',
  isOnline: false,
);
final UserModel scarletWitch = UserModel(
  id: 4,
  name: 'Scarlet Witch',
  imageUrl: 'assets/images/scarlet-witch.jpg',
  isOnline: false,
);
final UserModel spiderMan = UserModel(
  id: 5,
  name: 'Spider Man',
  imageUrl: 'assets/images/spiderman.jpg',
  isOnline: true,
);
final UserModel blackWindow = UserModel(
  id: 6,
  name: 'Black Widow',
  imageUrl: 'assets/images/black-widow.jpg',
  isOnline: false,
);
final UserModel thor = UserModel(
  id: 7,
  name: 'Thor',
  imageUrl: 'assets/images/thor.png',
  isOnline: false,
);
final UserModel captainMarvel = UserModel(
  id: 8,
  name: 'Captain Marvel',
  imageUrl: 'assets/images/captain-marvel.jpg',
  isOnline: false,
);
