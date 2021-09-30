
/// Abstract Info class that specifies fields and methods for info classes.
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
    return this.name;
  }
}