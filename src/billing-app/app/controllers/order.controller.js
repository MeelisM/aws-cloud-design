import db from "../models/index.js";
const Order = db.orders;

export async function processOrder(orderData) {
  try {
    if (!orderData.user_id || !orderData.number_of_items || !orderData.total_amount) {
      throw new Error("Missing required order data");
    }

    const order = await Order.create({
      user_id: orderData.user_id,
      number_of_items: orderData.number_of_items,
      total_amount: orderData.total_amount,
    });

    console.log("Order processed successfully:", order.id);
    return order;
  } catch (error) {
    console.error("Error processing order:", error);
    throw error;
  }
}

export async function findAllOrders() {
  try {
    return await Order.findAll();
  } catch (error) {
    console.error("Error fetching orders:", error);
    throw error;
  }
}

export async function findOrderById(id) {
  try {
    return await Order.findByPk(id);
  } catch (error) {
    console.error("Error fetching order:", error);
    throw error;
  }
}
