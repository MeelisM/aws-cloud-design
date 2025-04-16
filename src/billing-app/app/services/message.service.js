import amqp from "amqplib";
import config from "../config/environment.js";
import { processOrder } from "../controllers/order.controller.js";

export async function setupMessageQueue() {
  try {
    const connection = await amqp.connect(config.rabbitmq.localUrl);
    const channel = await connection.createChannel();
    await channel.assertQueue(config.rabbitmq.queue, {
      durable: true,
    });
    console.log(`##### Waiting for messages in ${config.rabbitmq.queue}`);
    channel.consume(config.rabbitmq.queue, async (msg) => {
      if (msg !== null) {
        try {
          const orderData = JSON.parse(msg.content.toString());
          await processOrder(orderData);
          channel.ack(msg);
        } catch (error) {
          console.error("Error processing message:", error);
        }
      }
    });
    connection.on("close", (err) => {
      console.error("RabbitMQ connection closed:", err);
      setTimeout(setupMessageQueue, 5000);
    });
    return { connection, channel };
  } catch (error) {
    console.error("Error connecting to RabbitMQ:", error);
    setTimeout(setupMessageQueue, 5000);
  }
}
