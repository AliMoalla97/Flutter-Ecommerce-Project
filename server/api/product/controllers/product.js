const { parseMultipartData, sanitizeEntity } = require('strapi-utils');

module.exports = {
  async comment(ctx) {
    let entity;
    if (ctx.is('multipart')) {
      const { data, files } = parseMultipartData(ctx);
      entity = await strapi.services.comment.create(data, { files });
    } else {
    ctx.request.body.user = ctx.state.user.id;
    ctx.request.body.product = ctx.params.id;
      entity = await strapi.services.comment.create(ctx.request.body);
    }
    return sanitizeEntity(entity, { model: strapi.models.restaurant });
  },

   async update(ctx) {
       const { id } = ctx.params;
       let entity;
       entity = await strapi.services.product.update({ id }, ctx.request.body);
       return sanitizeEntity(entity, { model: strapi.models.product });
     },
};

