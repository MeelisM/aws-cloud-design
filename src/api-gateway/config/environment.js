import dotenv from "dotenv";
import { fileURLToPath } from "url";
import { dirname, join } from "path";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

dotenv.config({ path: join(__dirname, "/../.env") });

const config = {
  server: {
    port: process.env.GATEWAY_PORT,
    inventoryUrl: process.env.INVENTORY_URL,
    host: process.env.GATEWAY_HOST,
  },
  rabbitmq: {
    apiUrl: process.env.RABBITMQ_API_URL,
    queue: process.env.RABBITMQ_QUEUE,
  },
};

export default config;
