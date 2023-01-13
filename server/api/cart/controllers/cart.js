'use strict';

/**
 * Read the documentation (https://strapi.io/documentation/v3.x/concepts/controllers.html#core-controllers)
 * to customize this controller
 */

module.exports = {
   async update(ctx) {
    const { products } = ctx.request.body;
    console.log(products);
       return strapi.services.cart.update(ctx.params, {
         products: JSON.parse(products)
       });
    },

};
