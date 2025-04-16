import express from "express";
import { createProxyMiddleware } from "http-proxy-middleware";
import morgan from "morgan";
import router from "./routes.js";
import swaggerUi from "swagger-ui-express";
import yaml from "js-yaml";
import { readFileSync } from "fs";
import { fileURLToPath } from "url";
import { dirname, join } from "path";
import config from "./config/environment.js";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const app = express();

const openApiDocument = yaml.load(
  readFileSync(join(__dirname, "openapi.yaml"), "utf8")
);
app.use("/api-docs", swaggerUi.serve, swaggerUi.setup(openApiDocument));
app.use(morgan("dev"));

const proxyOptions = {
  target: config.server.inventoryUrl,
  changeOrigin: true,
};

console.log(proxyOptions);

app.use("/api/movies", createProxyMiddleware(proxyOptions));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use("/api/billing", router);

app.listen(config.server.port, config.server.host, () => {
  console.log(
    `##### API Gateway is running on ${config.server.host}:${config.server.port}`
  );
  console.log(
    `##### API Documentation available at ${config.server.host}:${config.server.port}/api-docs`
  );
});
