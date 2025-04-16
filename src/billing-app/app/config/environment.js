import dotenv from "dotenv";
import { fileURLToPath } from "url";
import { dirname, join } from "path";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

dotenv.config({ path: join(__dirname, "/../../.env") });

const config = {
  server: {
    port: process.env.BILLING_PORT,
    host: process.env.BILLING_HOST,
  },
  database: {
    username: process.env.BILLING_DB_USER,
    password: process.env.BILLING_DB_PASSWORD,
    database: process.env.BILLING_DB_NAME,
    host: process.env.BILLING_DB_HOST,
    port: process.env.BILLING_DB_PORT,
    dialect: "postgres",
    pool: {
      max: 5,
      min: 0,
      acquire: 30000,
      idle: 10000,
    },
  },
  rabbitmq: {
    localUrl: process.env.RABBITMQ_LOCAL_URL,
    queue: process.env.RABBITMQ_QUEUE,
  },
};
export default config;
