'use strict';
const stripe = require('stripe')('sk_test_51K1nwrG38QROjSe4ChlV3AVlKbP6woRuikaw6xR3LGzhbKfpTm7yoDtVVAWh8vH0CZkQ5ov2Xza9IqWaBvcac0yV00g4R8SzYz')
/**
 * A set of functions called "actions" for `card`
 */

module.exports = {
 index: async ctx => {
    const customerId = ctx.request.querystring;
    // ctx.send(customerId);
   const customerData = await stripe.customers.retrieve(customerId);
    ctx.send(customerData);
  //  const cardData = customerData.sources;
    // ctx.send(cardData);
  //  ctx.send("hello world");
  }
};
