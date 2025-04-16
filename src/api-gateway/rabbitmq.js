import amqp from "amqplib";
import config from "./config/environment.js";

let channel;
let connection;

async function connectQueue() {
  try {
    connection = await amqp.connect(config.rabbitmq.apiUrl);
    console.log(config.rabbitmq.apiUrl);
    channel = await connection.createChannel();
    await channel.assertQueue(config.rabbitmq.queue, { durable: true });

    connection.on("close", async (err) => {
      console.error("RabbitMQ connection closed. Reconnecting...", err);
      setTimeout(connectQueue, 5000);
    });

    connection.on("error", (err) => {
      console.error("RabbitMQ connection error:", err);
    });
  } catch (error) {
    console.error("Error connecting to RabbitMQ:", error);
    setTimeout(connectQueue, 5000);
  }
}

async function sendToQueue(data) {
  try {
    if (!channel) {
      await connectQueue();
    }
    console.log(`Sending message to queue: ${config.rabbitmq.queue}`, data);
    channel.sendToQueue(config.rabbitmq.queue, Buffer.from(JSON.stringify(data)), {
      persistent: true,
    });
    console.log(`Message sent to queue: ${config.rabbitmq.queue}`);
  } catch (error) {
    console.error("Error sending to queue:", error);
  }
}

export { connectQueue, sendToQueue };
