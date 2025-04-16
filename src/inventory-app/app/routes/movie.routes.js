import express from "express";
import * as movies from "../controllers/movie.controller.js";

const router = express.Router();

// Create a new movie.
router.post("/", movies.create);
// Get all movies (with optional title filter).
router.get("/", movies.findAll);
// Get a single movie by id.
router.get("/:id", movies.findOne);
// Update a movie by id.
router.put("/:id", movies.update);
// Delete a movie by id.
router.delete("/:id", movies.deleteOne);
// Delete all movies.
router.delete("/", movies.deleteAll);

export default function (app) {
  app.use("/api/movies", router);
}
