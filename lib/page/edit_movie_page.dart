import 'package:flutter/material.dart';
import '../db/movie_database.dart';
import '../model/movie.dart';
import '../widget/movie_form_widget.dart';

class AddEditMoviePage extends StatefulWidget {
  final Movie? movie;

  const AddEditMoviePage({
    Key? key,
    this.movie,
  }) : super(key: key);

  @override
  State<AddEditMoviePage> createState() => _AddEditMoviePageState();
}

class _AddEditMoviePageState extends State<AddEditMoviePage> {
  final _formKey = GlobalKey<FormState>();
  late String imageURL;
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();

    imageURL = widget.movie?.imageURL ?? '';
    title = widget.movie?.title ?? '';
    description = widget.movie?.description ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actions: [buildButton()],
    ),
    body: Form(
      key: _formKey,
      child: MovieFormWidget(
        title: title,
        description: description,
        onChangedTitle: (title) => setState(() => this.title = title),
        onChangedDescription: (description) =>
            setState(() => this.description = description),
        onChangedImageURL: (imageURL) => setState(() => this.imageURL = imageURL),
      ),
    ),
  );

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateMovie,
        child: const Text('Save'),
      ),
    );
  }

  void addOrUpdateMovie() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.movie != null;

      if (isUpdating) {
        await updateMovie();
      } else {
        await addMovie();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateMovie() async {
    final movie = widget.movie!.copy(
      title: title,
      description: description,
      imageURL: imageURL,
    );

    await MovieDatabase.instance.update(movie);
  }

  Future addMovie() async {
    final movie = Movie(
      title: title,
      description: description,
      imageURL: imageURL,
      createdTime: DateTime.now(),
    );

    await MovieDatabase.instance.create(movie);
  }
}