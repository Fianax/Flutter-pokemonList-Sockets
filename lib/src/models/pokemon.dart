

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
      id: obj.containsKey('id') ? obj['id'] : 'no-id',
      name: obj.containsKey('name') ? obj['name'] : 'no-name',
      votes: obj.containsKey('votes') ? obj['votes'] : 'no-votes'
  );
}