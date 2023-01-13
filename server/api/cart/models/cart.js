'use strict';
// const { parseMultipartData, sanitizeEntity } = require('strapi-utils');
/**
 * Read the documentation (https://strapi.io/documentation/v3.x/concepts/models.html#lifecycle-hooks)
 * to customize this model
 */

module.exports = {

 /* update: async (ctx, next) => {
    const { products } = ctx.request.body;
    return strapi.services.cart.update(ctx.params, {
      products: JSON.parse(products)
    });
  },


     lifecycles: {
    update: async (ctx, next) => {
        const { products } = ctx.request.body;
        consol.log(products);
        consol.log(JSON.parse(products));
        consol.log(JSON.load(products));
        return strapi.services.cart.edit(ctx.params, {
          products: products
        });
      },
      },*/

}
