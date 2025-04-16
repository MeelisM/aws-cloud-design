import db from "../models/index.js";
const Movie = db.movies;
const { Op, Sequelize } = db.Sequelize;

// Create a new movie.
const create = async (req, res) => {
  try {
    if (!req.body.title) {
      res.status(400).send({
        message: "Title cannot be empty!",
      });
      return;
    }

    const movie = await Movie.create({
      title: req.body.title,
      description: req.body.description,
    });
    res.status(201).send(movie);
  } catch (err) {
    res.status(500).send({
      message: err.message || "Error occurred while creating the movie.",
    });
  }
};

// Get all movies (with optional title filter).
const findAll = async (req, res) => {
  try {
    const { title } = req.query;
    let condition = null;

    if (title) {
      const searchTerm = title.trim();
      condition = {
        title: Sequelize.where(
          Sequelize.fn("LOWER", Sequelize.col("title")),
          "LIKE",
          "%" + searchTerm.toLowerCase() + "%"
        ),
      };
    }

    console.log(
      "Raw query:",
      await Movie.sequelize.query(
        Movie.queryGenerator.selectQuery("movies", {
          where: condition,
        }),
        { type: Movie.sequelize.QueryTypes.SELECT }
      )
    );

    const movies = await Movie.findAll({ where: condition });
    res.status(200).send(movies);
  } catch (err) {
    res.status(500).send({
      message: err.message || "Error occurred while retrieving movies.",
    });
  }
};

// Get a single movie by id.
const findOne = async (req, res) => {
  try {
    const id = req.params.id;
    const movie = await Movie.findByPk(id);

    if (movie) {
      res.send(movie);
    } else {
      res.status(404).send({
        message: `Movie with id=${id} was not found`,
      });
    }
  } catch (err) {
    res.status(500).send({
      message: `Error retrieving movie with id=${req.params.id}`,
    });
  }
};

// Update a movie by id.
const update = async (req, res) => {
  try {
    const id = req.params.id;

    const [num] = await Movie.update(req.body, {
      where: { id: id },
    });

    if (num === 1) {
      const updatedMovie = await Movie.findByPk(id);

      res.send(updatedMovie);
    } else {
      res.status(404).send({
        message: `Cannot update movie with id=${id}. Movie was not found.`,
      });
    }
  } catch (err) {
    res.status(500).send({
      message: `Error updating movie with id=${req.params.id}`,
    });
  }
};

// Delete a single movie by id.
const deleteOne = async (req, res) => {
  try {
    const id = req.params.id;
    const num = await Movie.destroy({
      where: { id: id },
    });

    if (num === 1) {
      res.send({
        message: "Movie was deleted successfully.",
      });
    } else {
      res.status(404).send({
        message: `Cannot delete movie with id=${id}. Movie was not found.`,
      });
    }
  } catch (err) {
    res.status(500).send({
      message: `Could not delete movie with id=${req.params.id}`,
    });
  }
};

// Delete all movies.
const deleteAll = async (req, res) => {
  try {
    const nums = await Movie.destroy({
      where: {},
      truncate: false,
    });

    res.send({ message: `${nums} movies were deleted successfully.` });
  } catch (err) {
    res.status(500).send({
      message: err.message || "Error occured while deleting all movies.",
    });
  }
};

export { create, findAll, findOne, update, deleteOne, deleteAll };
