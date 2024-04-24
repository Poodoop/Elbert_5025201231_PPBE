import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/movie.dart';

class MovieDatabase {
  static final MovieDatabase instance = MovieDatabase._init();

  static Database? _database;

  MovieDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB('movie.db');
    return _database!;
  }

  Future<Database> initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: createDB);
  }

  Future createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE $tableMovie ( 
  ${MovieFields.id} $idType, 
  ${MovieFields.title} $textType,
  ${MovieFields.description} $textType,
  ${MovieFields.imageURL} $textType,
  ${MovieFields.time} $textType
  )
''');
  }

  Future<Movie> create(Movie movies) async {
    final db = await instance.database;

    final id = await db.insert(tableMovie, movies.toJson());
    return movies.copy(id: id);
  }

  Future<Movie> readMovie(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableMovie,
      columns: MovieFields.values,
      where: '${MovieFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Movie.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Movie>> readAllNotes() async {
    final db = await instance.database;

    final orderBy = '${MovieFields.time} ASC';

    final result = await db.query(tableMovie, orderBy: orderBy);

    return result.map((json) => Movie.fromJson(json)).toList();
  }

  Future<int> update(Movie movies) async {
    final db = await instance.database;

    return db.update(
      tableMovie,
      movies.toJson(),
      where: '${MovieFields.id} = ?',
      whereArgs: [movies.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableMovie,
      where: '${MovieFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}