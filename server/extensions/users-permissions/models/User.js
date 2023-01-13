'use strict';
const axios = require('axios');
const stripe = require('stripe')('sk_test_51K1nwrG38QROjSe4ChlV3AVlKbP6woRuikaw6xR3LGzhbKfpTm7yoDtVVAWh8vH0CZkQ5ov2Xza9IqWaBvcac0yV00g4R8SzYz')
/**
 * Lifecycle callbacks for the `User` model.
 */

module.exports = {
 lifecycles: {
    // Called before an entry is created
   beforeCreate: async (model) => {
   const cart = await axios.post('http://172.19.250.153:1337/carts');
  // console.log(model);
  const customer = await stripe.customers.create({
  email: model.email
  })
   model.cart_id=cart.data.id;
   model.customer_id=customer.id;
    },
 }
};

