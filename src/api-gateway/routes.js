import express from "express";
import { sendToQueue } from "./rabbitmq.js";

const router = express.Router();

// Convert HTTP request to RabbitMQ message
router.post("/", async (req, res) => {
  try {
    const orderData = {
      user_id: req.body.user_id,
      number_of_items: req.body.number_of_items,
      total_amount: req.body.total_amount,
    };

    await sendToQueue(orderData);
    res.status(200).json({
      message: "Order has been queued for processing",
    });
  } catch (error) {
    console.error("Error processing order:", error);
    res.status(500).json({
      message: "Error processing order",
    });
  }
});

export default router;
