'use strict';
const stripe = require("stripe")("sk_test_51K1nwrG38QROjSe4ChlV3AVlKbP6woRuikaw6xR3LGzhbKfpTm7yoDtVVAWh8vH0CZkQ5ov2Xza9IqWaBvcac0yV00g4R8SzYz");
const uuid = require("uuid/v4");
const { sanitizeEntity } = require('strapi-utils');
/**
 * Read the documentation (https://strapi.io/documentation/v3.x/concepts/controllers.html#core-controllers)
 * to customize this controller
 */

module.exports = {
    async create(ctx) {
      let entity;
      const { amount, products, customer, source ,ptext} = ctx.request.body;
          const { email } = ctx.state.user;

          const charge = {
            amount: Number(amount) * 100,
            currency: "usd",
            customer,
            source,
            receipt_email: email
          };

          const idempotencyKey = uuid();
           await stripe.charges.create(charge, {
            idempotencyKey: idempotencyKey
          });
        entity = await strapi.services.order.create({    amount,
                                                         products: JSON.parse(products),
                                                         user: ctx.state.user,
                                                         ptext:ptext
                                                             });
      return sanitizeEntity(entity, { model: strapi.models.order });
    },


};
