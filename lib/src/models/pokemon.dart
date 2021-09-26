

class Pokemon{

  String id;
  String name;
  int votes;

  Pokemon({
    required this.id,
    required this.name,
    required this.votes
  });
  
  factory Pokemon.fromMap( Map<String,dynamic> obj)=>Pokemon(
      id: obj['id'],
      name: obj['name'],
      votes: obj['votes']
  );
}