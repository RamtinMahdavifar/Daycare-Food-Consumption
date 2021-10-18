
/// Abstract Info class that specifies fields and methods for info classes. At a
/// high level an Info class is tied to another class and gives some information on
/// such a class as well as allowing that class to be easily read in from our database
abstract class Info{
  // specify attributes as late so they don't have to be provided on instantiation
  // as we cannot instantiate an abstract class

  // name of the component being represented by this info object
  late String name;
  // key on the database that can be used to lookup the item being represented
  // by this info object
  late String databaseKey;

  @override
  String toString(){
    // ensure this object has a legitimate name
    assert(this.name.isNotEmpty);
    return this.name;
  }

  Map<String, dynamic> toJson() => {
    'name': this.name,
    'databaseKey': this.databaseKey,
  };

  // TODO: overwrite hashcode(), two equal objects should have the same hashcode
  @override
  bool operator ==(Object other){
    if (other.runtimeType == this.runtimeType){
      Info otherInfo = other as Info;
      return this.name == otherInfo.name &&
          this.databaseKey == otherInfo.databaseKey;
    }
    return false;
  }
}