import express from "express";
import db from "./app/models/index.js";
import { checkDatabaseExists } from "./app/config/db.js";
import { setupMessageQueue } from "./app/services/message.service.js";
import config from "./app/config/environment.js";

const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

async function initializeApp() {
  try {
    await checkDatabaseExists();
    await db.sequelize.sync();
    console.log("##### Database synchronized successfully");

    await setupMessageQueue();
    console.log("##### Message queue setup completed");

    const { port, host } = config.server;
    app.listen(port, () => {
      console.log(`##### Billing service is running on ${host}:${port}`);
      console.log("##### CTRL + C to quit.");
    });
  } catch (err) {
    console.error("##### Failed to initialize application:", err);
    process.exit(1);
  }
}

initializeApp();
