import express from "express";
import db from "./app/models/index.js";
import initializeRoutes from "./app/routes/movie.routes.js";
import { checkDatabaseExists } from "./app/config/db.js";
import morgan from "morgan";
import config from "./app/config/environment.js";

const app = express();

app.use(morgan("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
initializeRoutes(app);

async function initializeApp() {
  try {
    await checkDatabaseExists();
    await db.sequelize.sync();
    console.log("##### Database synchronized successfully");

    const { port, host } = config.server;
    app.listen(port, host, () => {
      console.log(`##### Inventory service is running on ${host}:${port}.`);
      console.log("##### CTRL + C to quit.");
    });
  } catch (err) {
    console.error("##### Failed to initialize application:", err);
    process.exit(1);
  }
}

initializeApp();
