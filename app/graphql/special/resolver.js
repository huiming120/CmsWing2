'use strict';
module.exports = {
	Special: {
		async special_data(root, params, ctx) {
			const map = {};
			map.where = { special_id: root.id };
			if (Object.hasOwnProperty.call(params, 'limit')) {
				map.limit = params.limit;
			}
			if (Object.hasOwnProperty.call(params, 'offset')) {
				map.offset = params.offset;
			}
			if (Object.hasOwnProperty.call(params, 'order')) {
				map.order = params.order;
			}
			return await ctx.connector.special_data.findAll(map);
		},
	},

	Query: {
		async Special_findAll(_root, params, ctx) {
			return await ctx.connector.special.findAll(params);
		},
		async Special_findByPk(_root, params, ctx) {
			return await ctx.connector.special.findByPk(params);
		},
		async Special_findOne(_root, params, ctx) {
			return await ctx.connector.special.findOne(params);
		},
		async Special_findAndCountAll(_root, params, ctx) {
			return await ctx.connector.special.findAndCountAll(params);
		},
	},
	Mutation: {
		async Special_create(_root, params, ctx) {
			return await ctx.connector.special.create(params);
		},
		async Special_destroy(_root, params, ctx) {
			return await ctx.connector.special.destroy(params);
		},
		async Special_update(_root, params, ctx) {
			return await ctx.connector.special.update(params);
		},
	},
};