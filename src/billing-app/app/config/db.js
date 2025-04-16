import { Sequelize } from "sequelize";
import config from "./environment.js";

export async function checkDatabaseExists() {
  const tempSequelize = new Sequelize({
    ...config.database,
    database: "postgres",
    logging: false,
  });

  try {
    await tempSequelize.authenticate();
    const [results] = await tempSequelize.query(
      `SELECT 1 FROM pg_database WHERE datname = '${config.database.database}'`
    );
    if (results.length === 0) {
      throw new Error(
        `Database ${config.database.database} does not exist. Run setup-billing-db.sh first.`
      );
    }
    console.log(`Database ${config.database.database} exists, proceeding with connection`);
  } finally {
    await tempSequelize.close();
  }
}

export default config.database;
